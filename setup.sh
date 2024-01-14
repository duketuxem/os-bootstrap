#!/usr/bin/env sh

# This script aims to be POSIX compatible (no shell flavor).
# As a reminder there are no arrays, all variables are global, ...

# Load the configuration (variables) to be used here
. ./config.sh

error=0

# Prevent git from asking to supply information in an interactive way.
# This makes all the checks regarding remote repositories possible.
export GIT_ASKPASS="echo"
export SSH_ASKPASS="echo"

###
# Utils
###
error()
{
    printf "\033[0;1;31m$*\033[0m\n"
    error=1
}

success()
{
    printf "\033[0;1;32m$*\033[0m\n"
}

warning()
{
    printf "\033[0;1;33m$*\033[0m\n"
}

info()
{
    printf "\033[0;1;34m$*\033[0m\n"
}

step()
{
    printf "\033[0;1;35m$*\033[0m\n"
}

call()
{
    info "$*"

    "$@"
    ret=$?
    if [ $ret -ne 0 ]
    then
        error "$*\nreturned: $ret"
		error "Being in: $(pwd)"
        exit $ret
    fi
}

# The following is taken from: https://github.com/dylanaraps/pfetch
# This is just a simple wrapper around 'command -v' to avoid
# spamming '>/dev/null' throughout this function. This also guards
# against aliases and functions.
has()
{
    _cmd=$(command -v "$1") 2>/dev/null || return 1
    [ -x "$_cmd" ] || return 1
}

ask()
{
	printf "%s [Y/n] " "$1"
	read -r answer
	if [ -z "$answer" ] || [ "$answer" = "y" ] || [ "$answer" = "Y" ]; then
		return 0
	else
		return 1
	fi
}


###
# Actual script
###
which_linux()
{
	step "Detecting Linux Flavor"

	if has lsb_release; then
		distro=$(lsb_release -sd)
	else
		# try with if [ ! -f /etc/os-release ]; then
		error "No lsb_release command available"
		exit 1
	fi

	if [ "$distro" = '"Void Linux"' ]; then
		success "$distro detected"
		platform_folder='void_linux'
		package_manager='xbps-install -y'
		privilege_escalation='sudo'
	else
		error "Unhandled flavor for the moment..."
		exit 1
	fi


	# printf "$os_release" | grep -q 'arch' \
	# 	&& package_manager="pacman -S"

	# printf "$os_release" | grep -Eq 'debian|ubuntu' \
	# 	&& package_manager="apt-get install -y"

	# printf "$os_release" | grep -q 'alpine' \
	# 	&& package_manager="pkg add "

	# printf "$os_release" | grep -q 'gentoo' \
	# 	&& package_manager="emerge "

	printf "Package manager command should be '%s'\n" "$package_manager"
	if ! ask "Is that correct ?"; then
		exit 1
	fi
}

create_home_folder_structure()
{
	find "$home_template/$main_profile_directory" -type d \
		| xargs -I % mkdir %
}

# optimization: detect if any package is missing before running the
# package manager command
install_packages()
{
	packages=$(grep -v '^#' "./$platform_folder/$main_profile_file" | tr -s '\n' ' ')
	install_command="$privilege_escalation $package_manager $packages"
	printf "Running: $install_command\n"

	if ! ask "Proceed ?"; then
		exit 1
	fi
	if ! eval "$install_command"; then
		error "Something failed during the packages installation."
		exit 1
	fi

	# =======================================================================

	# TODO Make this not hardcoded...
	# step "Installing the custom desktop suite (suckless)..."
	# cd "$repositories_location"
	# for soft in dmenu dwm st
   	# do
	# 	if has $soft; then
	# 		info "$soft is already installed"
	# 		continue
	# 	fi
	# 	call git clone https://github.com/duketuxem/"$soft".git -b my_fork \
	# 		&& cd $soft \
	# 		&& call "$privilege_escalation" make install \
	# 		&& success "$soft successfully installed!\n" \
	# 		&& git remote set-url origin git@github.com:duketuxem/$soft.git \
	# 		&& success "Repository set to use SSH." \
	# 		&& cd ..
	# done
}

install_dotfiles()
{
	# In case the GUI profile is not installed, we're still in the repo.
	cd "$repositories_location"
	# Clone the repository sources using the right branch.
	call git clone "$dotfiles_repo_url_http" -b "$dotfiles_git_branch"
	# 'deploy' the configuration TODO: Use `rsync` here ?
	call cp -r "./$dotfiles_git_repo/.config"	\
		"./$dotfiles_git_repo/.local"			\
		"$HOME"
	# Setup the dotfiles workflow using git bare repositories
	call git clone --bare "$dotfiles_repo_url_http" "$HOME/.dotfiles"
	# As with all my repositories, set it to use ssh. TODO: Fix
	call git --git-dir="$HOME/.dotfiles" \
		remote set-url origin "$dotfiles_repo_ssh"
}

set_default_location_zsh_config()
{
	# TODO printf <<EOF and comment
	"$privilege_escalation" sh -c \
		'printf "ZDOTDIR=\"\$HOME\"/.config/zsh\n" > /etc/zsh/zshenv'
}

change_default_shell() {
	info "Setting login shell to $login_shell"
	call chsh -s "$login_shell"
}

# Attempt to detect any inconsistence that would raise an error later
# Also helps to make the script replayable
check_requirements()
{
	step "Checking requirements"
	#
	if ! mkdir -p "$repositories_location" 2> /dev/null;
	then
		error "The folder holding repos doesn't exist and can't be created"
	fi

	# Required for creating the home folder structure
	# devnote: let's not handle some cases where the script is run
	# from outside the working directory. Make this a requirement, over.
	if [ "$(pwd | awk -F '/' '{print $NF}')" != "os-bootstrap" ];
	then
		error "Please, cd to the os-bootstrap cloned repository"
	fi

	# Check if all the packages can be resolved
	for file in "$platform_folder"/*;
	do
		# TODO: test | alternative otherwise : "${string#*"$word"}"
		case "$main_profile_file $desktop_profile_file" in
		  *$main_profile_file*) 	;;
		  *$desktop_profile_file*) 	;;
		  *)	error "Unexpected profile text file" ;;
		esac

		# Concatenate all lines representing packages from the current
		# text file and verify whether the package manager accepts
		# all of them.
		packages=$(awk '/^[a-zA-Z0-9]/ {printf "%s ", $0} END{print ""}' "$file")
		# TODO: --dry-run is not implemented in every package managers
		# so far as I checked : xbps / apt / not rpm...
		eval "$package_manager" --dry-run "$packages" > /dev/null 2>&1
		if [ $? -ne 0 ]; then
		       error "The package install check failed:"
		       eval "$package_manager" --dry-run "$packages" > /dev/null
		fi
       	done

	### Check if the dotfiles repository exists
	# --exit-code allows the command to fail if the branch is incorrect
	if ! git ls-remote --exit-code \
		"$dotfiles_git_full_url" \
	       	"$dotfiles_git_branch" > /dev/null 2>&1;
	then
		error "The 'dotfiles' repo or branch is incorrect"
	fi

	[ $error -ne 0 ] && exit $error

	success "All requirements satisfied"
	sleep 1
}



operating_system="$(uname -s)"

if [ "$operating_system" = "Linux" ]
then
	platform_folder='NONE'
	package_manager='NONE'
	which_linux

	check_requirements

	step "Installing the packages"
	# related : core / gui profiles
	# direct adherences to dotfiles (wm)
	# for Desktop: which graphic server
	install_packages
	exit 0

	# related : directory spec
	step "Creating the expected home folder structure if not present"
	create_home_folder_structure

	step "Importing the dotfiles configuration"
	# related: other reposiory
	install_dotfiles

	step "Overriding the default Zsh config location"
	set_default_location_zsh_config

	step "Setting up the default shell"
	change_default_shell

	# TODO: change this repository git remote method

	success "The script has finished the install. Enjoy."
else
	error "Unsupported platform"
	return 1
fi
return 0
