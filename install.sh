#!/usr/bin/env sh

# This script aims to be POSIX compatible (no shell flavor).
# As a reminder there are no arrays, all variables are global, ...

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
		distro_file='void_linux.txt'
		package_manager='xbps-install -y'
		package_manager_check="$package_manager --dry-run"
		privilege_escalation='sudo'
	# elif [ printf "$os_release" | grep -Eq 'debian|ubuntu' ]; then
	# 	distro_file='debian.txt'
	# 	package_manager='apt-get install -y'
	# 	package_manager_check="$package_manager --dry-run"
	# 	privilege_escalation='sudo'
	else
		error "Unhandled flavor for the moment..."
		exit 1
	fi

	# printf "$os_release" | grep -q 'arch' \
	# 	&& package_manager="pacman -S"

	# printf "$os_release" | grep -q 'alpine' \
	# 	&& package_manager="pkg add "

	# printf "$os_release" | grep -q 'gentoo' \
	# 	&& package_manager="emerge "

	printf "Package manager command should be '%s'\n" "$package_manager"
	if ! ask "Is that correct ?"; then
		exit 1
	fi
}

install_profile()
{
	if [ ! "$1" ]
	then
		error "install_profile function must take a profile as argument"
		exit 1
	fi

	### Packages - check
	# Concatenate all lines representing packages from the current
	# text file and verify whether the package manager accepts
	# all of them.
	packages=$(awk '/^[a-zA-Z0-9]/ {printf "%s ", $0} END{print ""}' \
		"$1/$distro_file")
	if ! r=$(eval "$package_manager_check" "$packages" 2>&1 >/dev/null)
	then
		error "The package check failed:\n$r"
		exit 1
	fi
	### Packages - install
	install_command="$privilege_escalation $package_manager $packages"
	printf 'Running: %s\n' "$install_command"
	if ! ask "Proceed ?";
	then
		exit 1
	elif ! eval "$install_command";
	then
		error "Something failed during the packages installation."
		exit 1
	fi

	### Install config using directives from the profile script
	# if [ ! "./$1/unpack.sh" ];
	# then
	# fi

}



# Is the script not called from the root of the repository ?
if [ "$(pwd | awk -F '/' '{print $NF}')" != "os-bootstrap" ];
then
	printf "Please, run this script while being in the repo directory"
	exit 1
# Otherwise load some helper functions
elif ! . ./utils.sh; then
	printf "utils.sh file not found."
	exit 1
fi



operating_system="$(uname -s)"
if [ "$operating_system" = "Linux" ]
then

	which_linux

	install_profile

	success "The script has finished the install. Enjoy."
fi
return 0

# vim: fdm=marker fmr={,}
