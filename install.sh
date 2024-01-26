#!/usr/bin/env sh

# This script aims to be POSIX compatible (no shell flavor).
# As a reminder there are no arrays, all variables are global, ...


# Repository/file spec
profile_script='_setup.sh'
skip_packages=0
skip_config=0

fatal()
{
	printf '\033[0;1;31m%s\033[0m\n' "$*"
	exit 1
}

continue_install_or_not()
{
	if ! ask 'This part will be skipped. Continue the installation ?'
	then
		exit 0
	fi
}

no_profile()
{
	# Should be using ./ to support all filenames, see SC2035
	profiles=$(find * -maxdepth 0 -type d -not -path '*/.*')
	if printf '%s' "$profiles" | grep -wq "$1"
	then
		return 1
	fi
}


### Argument checking and requirements
if [ "$(pwd | awk -F '/' '{print $NF}')" != 'os-bootstrap' ]
then
	fatal 'Please, cd to the repository before running this script.'
elif [ ! "$1" ]
then
	fatal 'Please, specify a profile as the first argument of this script.'
elif no_profile "$1"
then
	fatal "Specified profile '$1' was not found in this folder."
# Sourcing utils which detects platform and sets required variables
elif ! . ./utils.sh
then
	fatal 'utils.sh file not found or failed after loading.'
elif [ ! -f "$1/$distro_file" ] || [ ! -s "$1/$distro_file" ]
then
	warning "No (or empty) package file found at: $1/$distro_file."
	continue_install_or_not
	skip_packages=1
fi

if [ ! -f "./$1/$profile_script" ] || [ ! -s "./$1/$profile_script" ]
then
	warning "No (or empty) profile setup script found at: $1/$profile_script."
	continue_install_or_not
	skip_config=1
fi


### Installation process
if [ "$skip_packages" -ne 1 ]
then
	step "Package(s) install"
	packages=$(awk '/^[a-zA-Z0-9]/ {printf "%s ", $0} END {print ""}' \
		"$1/$distro_file")
	install_command="$privilege_escalation $package_manager $packages"
	printf '%s\n' "$install_command"

	if ! eval "$install_command"
	then
		fatal "Something failed during the package(s) installation:\n$r"
	fi
	success "The package(s) install/update was successful!"
fi


if [ "$skip_config" -ne 1 ]
then
	if ! ask "Do you want to run the configuration for the $1 profile ?"
	then
		return 0
	fi
	step "Profile configuration"

	cd "$1" || fatal "Can not cd to $1"

	. "./$profile_script" || return 1
fi

success 'The script has finished the install. Enjoy.'
return 0
