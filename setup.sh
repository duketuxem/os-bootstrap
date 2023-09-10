#!/usr/bin/env sh

. ./config.sh

###
# Utils
###
error()
{
    printf "\033[0;1;31m$*\033[0m\n"
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

which_linux()
{
	if has lsb_release; then
		distro=$(lsb_release -sd)
	else
		# try with if [ ! -f /etc/os-release ]; then
		error "No lsb_release command available"
		exit 1
	fi

	if [ "$distro" = '"Void Linux"' ]; then
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
	ask "Is that correct ?"
	[ $? -eq 1 ] && exit 1
}

create_project_directory()
{
	mkdir "$ricing_project_directory" 2> /dev/null
	[ $? -ne 0 ] \
		&& error "The project folder does not exist and can not be created" \
		&& exit 1
	cd "$ricing_project_directory"
}

create_home_folder_structure()
{
	# Those folders are expected by my dotfiles before they are deployed.
	# I try to maintain a clean home as much as possible by using the
	# environment variables relative to the XDG Base Directory specification.
	#
	# The 'bin/' and 'log/' directories are conceptually extending the previous
	# concept a bit more, storing scripts and desktop related software logs to
	# one specific place.
	mkdir "$HOME/.config"			\
			"$HOME/.local"			\
			"$HOME/.local/cache"	\
			"$HOME/.local/share"	\
			"$HOME/.local/state"	\
									\
			"$HOME/.local/bin"		\
			"$HOME/.local/log"		2> /dev/null
}

# optimization: detect if any package is missing before running the
# package manager command
install_packages()
{
	# Install the core packages.
	if [ ! -f ./"$platform_folder"/core.txt ]; then
		error "Can not find the $platform_folder/core.txt file."
		exit 1
	fi
	core_packages=$(grep -v '^#' "./$platform_folder/core.txt" | tr -s '\n' ' ')
	install_command="$privilege_escalation $package_manager $core_packages"
	printf "Running: $install_command\n"

	# Install the desktop profile if the user wants it.
	ask "Do you want to install the desktop profile to have a GUI ?"
	[ $? -eq 1 ] && return
	if [ ! -f ./"$platform_folder"/gui.txt ]; then
		error "Can not find the $platform_folder/gui.txt file."
		exit 1
	fi
	gui_packages=$(grep -v '^#' "./$platform_folder/gui.txt" | tr -s '\n' ' ')
	install_command="$privilege_escalation $package_manager $gui_packages"
	printf "Running: $install_command\n"

	# TODO Make this not hardcoded...
	step "Installing the custom desktop suite (suckless)..."
	for soft in dmenu dwm st
   	do
		call git clone https://github.com/duketuxem/"$soft".git -b my_fork \
			&& cd $soft \
			&& call "$privilege_escalation" make install > /dev/null 2>&1 \
			&& success "$soft successfully installed!\n" \
			&& git remote set-url origin git@github.com:duketuxem/$soft.git \
			&& success "Repository set to use SSH." \
			&& cd ..
	done
}

install_dotfiles()
{
	# Clone the repository sources using the right branch.
	call git clone "$dotfiles_repo_url_http" -b "$dotfiles_repo_branch"
	# 'deploy' the configuration TODO: Use `rsync` here ?
	call cp -r "./$dotfiles_repo_name/*" "$HOME"
	# Setup the dotfiles workflow using git bare repositories
	call git clone --bare "$dotfiles_repo_url_http" "$HOME/.dotfiles"
	# As with all my repositories, set it to use ssh.
	call git --git-dir="$HOME/.dotfiles" \
		remote set-url origin "$dotfiles_repo_ssh"
}

set_default_location_zsh_config()
{
	"$privilege_escalation" sh -c \
		'printf "export ZDOTDIR=\"\$HOME\"/.config/zsh\n" > /etc/zsh/zshenv'
}

change_default_shell() {
	info "Setting login shell to $login_shell"
	call chsh -s "$login_shell"
}


# =============================================================================


step "Detecting platform"
operating_system="$(uname -s)"

if [ "$operating_system" = "Linux" ]
then
	# The 'related' notes below are here to help to distinguish the functionnal
	# concepts of this scripts.
	platform_folder='NONE'
	package_manager='NONE'
	which_linux							# related : os dectection

	step "Changing directory to the project folder"
	create_project_directory

	# related : directory spec
	step "Creating the expected home folder structure if not present"
	create_home_folder_structure

	step "Installing the packages"
	# related : core / gui profiles
	# direct adherences to dotfiles (wm)
	# for GUI: which graphic server
	install_packages

	step "Importing the dotfiles configuration"
	# related: other reposiory
	install_dotfiles

	step "Overriding the default Zsh config location"
	set_default_location_zsh_config

	step "Setting up the default shell"
	change_default_shell

	success "The script has finished the install. Enjoy."
else
	error "Unsupported platform"
	exit 1
fi
exit 0
