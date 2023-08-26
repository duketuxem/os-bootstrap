#!/usr/bin/env sh

. ./config.sh

# operating_system='NONE'
linux_distribution='NONE'
package_manager='NONE'

###
# Utils
###
error() {
    printf "\033[0;1;31m$*\033[0m\n"
}

success() {
    printf "\033[0;1;32m$*\033[0m\n"
}

warning() {
    printf "\033[0;1;33m$*\033[0m\n"
}

info() {
    printf "\033[0;1;34m$*\033[0m\n"
}

step() {
    printf "\033[0;1;35m$*\033[0m\n"
}

call() {
    info "$*"

    "$@"
    ret=$?
    if [ $ret -ne 0 ]
    then
        error "$*\nreturned: $ret"
        exit $ret
    fi
}

ask()
{
	printf " %s [Y/n] " "$1"
	read -r answer
	if [ -z "$answer" ] || [ "$answer" = "y" ] || [ "$answer" = "Y" ]; then
		return 0
	else
		return 1
	fi
}

platform_detection()
{
	step "Trying to guess about the platform..."

	kernel_name="$(uname -s)"

	if [ "$kernel_name" = "Darwin" ]; then
		# operating_system="Darwin"
		error "OS Darwin is unsupported"
		exit 1
	elif [ "$kernel_name" = "Windows" ]; then
		# operating_system="Windows"
		error "OS Windows is unsupported"
		exit 1
	elif [ "$kernel_name" = "FreeBSD" ]; then
		error "OS BSD and alike are not supported yet"
		exit 1
	elif [ "$kernel_name" = "Linux" ]; then
		printf "OS Linux detected\n"
		if [ ! -f /etc/os-release ]; then
			error "No /etc/os-release file found, can not determine distro."
			exit 1
		fi
		which_linux
	fi
}

# use sudo or doas ?
has_doas()
{
}

which_linux()
{
	os_release=$(cat /etc/os-release)

	# Test: OK
	printf "$os_release" | grep -q 'void'		\
		&& printf "Void Linux detected\n"		\
		&& linux_distribution='void_linux'		\
		&& package_manager="xbps-install -y"

	# printf "$os_release" | grep -q 'arch' \
	# 	&& package_manager="pacman -S"

	# printf "$os_release" | grep -Eq 'debian|ubuntu' \
	# 	&& package_manager="apt-get install -y"

	# printf "$os_release" | grep -q 'alpine' \
	# 	&& package_manager="pkg add "

	# printf "$os_release" | grep -q 'gentoo' \
	# 	&& package_manager="emerge "

	if [ "$os_release" = "NONE" ]; then
		error 'Unhandled Linux(?) platform'
		exit 1
	fi
	printf "Package manager command should be '%s'\n" "$package_manager"

	ask "Is that correct ?"
	[ $? -eq 1 ] && exit 1
}

create_home_folder_structure()
{
	# ask "Do you want to create the home folder structure ?"
	# [ $? -eq 1 ] && return

	step "Creating the home folder structure..."
	# top level directories
	mkdir "$HOME/music"
	mkdir "$HOME/movies"
	mkdir "$HOME/pictures"

	# XDG spec directories
	mkdir "$HOME/.config"
	mkdir "$HOME/.local"
	mkdir "$HOME/.local/cache"
	mkdir "$HOME/.local/share"
	mkdir "$HOME/.local/state"

	# custom
	mkdir "$HOME/.local/bin"
	mkdir "$HOME/.local/log"
}

install_void_packages() {
	call sudo "$package_manager" $(grep -v '^#' ./packages.txt | tr '\n' ' ') \
		&& success "Package requirements satisfied!\n"
}

install_suckless_suite() {
	info "Installing the suckless tool suite..."

	cd "$ricing_project_directory"
	for soft in dmenu dwm st
   	do
		call git clone https://github.com/duketuxem/"$soft".git -b my_fork \
			&& cd $soft \
			&& call sudo make install > /dev/null 2>&1 \
			&& success "$soft successfully installed!\n" \
			&& git remote set-url origin git@github.com:duketuxem/$soft.git \
			&& success "Repository set to use SSH." \
			&& cd ..
	done
}

install_dotfiles() {
	info "Setting up all the dotfiles..."

	call git clone "$dotfiles_repo_url" -b "$setup"
	call cp -r "./$dotfiles_repo_name/*" "$HOME"
	call git clone --bare "$dotfiles_repo_url" "$HOME/.dotfiles"
	call git --git-dir="$HOME/.dotfiles" remote set-url origin "$dotfiles_repo_ssh"
	git@github.com:duketuxem/$soft.git
}

change_default_shell() {
	info "Setting login shell to $login_shell"
	call chsh -s "$login_shell"
}

# info "Installing the user packages..."

# info "Override the default Zsh configuration location to match ours"
# sudo sh -c 'printf "export ZDOTDIR=\"\$HOME\"/.config/zsh\n" > /etc/zsh/zshenv'

platform_detection

create_home_folder_structure

printf "Hello there\n"

# vim: fdm=marker foldmarker={,}
