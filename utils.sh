# No shebang: This script is sourced from another script

# Disabling git interactive prompts allows for testing a repository existence
# Must be set this way to close 'stdin'
GIT_ASKPASS="echo"
SSH_ASKPASS="echo"


### Logging
error()
{
	printf '\033[0;1;31m%s\033[0m\n' "$*"
}

success()
{
	printf '\033[0;1;32m%s\033[0m\n' "$*"
}

warning()
{
	printf '\033[0;1;33m%s\033[0m\n' "$*"
}

info()
{
	printf '\033[0;1;34m%s\033[0m\n' "$*"
}

step()
{
	printf '\033[0;1;35m%s\033[0m\n' "$*"
}

### Generic actions to be used in other scripts
ask()
{
	printf "%s [Y/n] " "$1"
	read -r answer
	if [ -z "$answer" ] || [ "$answer" = "y" ] || [ "$answer" = "Y" ]
	then
		return 0
	else
		return 1
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

check_git_repository()
{
	### Repository / TODO archive, tar.gz ? ...
	# --exit-code allows the command to fail if the branch is incorrect
	if ! git ls-remote --exit-code "$1" "$2" > /dev/null 2>&1
	then
		error "The repository or branch is incorrect"
		return 1
	fi
	success "The dotfiles repository can be retrieved"
	return 0
}



### Platform detection

operating_system="$(uname -s)"
if [ "$operating_system" = 'Linux' ]
then
	step 'Detecting Linux Flavor'

	if [ -f '/etc/os-release' ]
	then
		# TODO: is 'ID' present everywhere
		distro=$(grep '^ID' /etc/os-release)
		eval "$distro"

		if [ "$ID" = 'debian' ]
		then
			distro_file='debian.txt'
			package_manager='apt-get install'
			privilege_escalation='sudo'
		elif [ "$ID" = 'void' ]
		then
			distro_file='void.txt'
			package_manager='xbps-install'
			privilege_escalation='sudo'
		else
			error 'Can not detect linux distribution, aborting.'
			exit 1
		fi
	elif ! has lsb_release
	then
		error 'No lsb_release command available.'
		error 'Can not rely on any reliable method to detect flavor.'
		exit 1
	# TODO: implement the fallback with lsb_release ?
	fi
	info "Package manager command should be '$package_manager'"

elif [ "$operating_system" = "FreeBSD" ]
then
	error "(Free)BSD Unimplemented"
	return 1
else
	error "Unsupported platform for now"
	return 1
fi

# Reset sudo 'cache' access for forcing password prompt
if [ "$privilege_escalation" = 'sudo' ]
then
	sudo -k
fi

return 0
