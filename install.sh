#!/usr/bin/env sh

# This script aims to be POSIX compatible (no shell flavor).
# As a reminder there are no arrays, all variables are global, ...


install_profile()
{
	if [ ! "$1" ]
	then
		error "install_profile function must take a profile as argument"
		exit 1
	elif has_profile "$1"
	then
		error "Directory '$1' not found in the repository"
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
	elif ! r=$(eval "$install_command" 2>&1 >/dev/null);
	then
		error "Something failed during the packages installations:\n$r"
		exit 1
	fi

	success "The package(s) install/update was successful!"

	if ask "Do you want to run the configuration for the $1 profile ?"
	then
		return 1
	elif [ ! "./$1/_setup.sh" ];
	then
		### Deploy config using instructions from the profile script
		warn "No '_setup.sh' script found in directory $1"
	else
		cd "$1"
		. _setup.sh
		cd ..
	fi
}



# Is the script not called from the root of the repository ?
if [ "$(pwd | awk -F '/' '{print $NF}')" != "os-bootstrap" ];
then
	printf "Please, run this script while being in the repo directory\n"
	exit 1
# Otherwise load some helper functions
elif ! . ./utils.sh; then
	printf "utils.sh file not found.\n"
	exit 1
fi



operating_system="$(uname -s)"
if [ "$operating_system" = "Linux" ]
then

	which_linux

	install_profile "$1"

	success "The script has finished the install. Enjoy."

fi
return 0

# vim: fdm=marker fmr={,}
