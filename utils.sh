# No shebang: This script is just sourced

# Prevent git from asking to supply information in an interactive way.
# This makes the check regarding a remote repository possible.
export GIT_ASKPASS="echo"
export SSH_ASKPASS="echo"

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

check_git_repository()
{
	### Repository / TODO archive, tar.gz ? ...
	# --exit-code allows the command to fail if the branch is incorrect
	if ! git ls-remote --exit-code "$1" "$2" > /dev/null 2>&1;
	then
		error "The repository or branch is incorrect"
		return 1
	fi
	success "The dotfiles repository can be retrieved"
	return 0
}

create_file_tree()
{
	if [ ! "$1" ]
	then
		return 1
	fi

	# Create the folders (if any) from the profile template description
	if ! find "$1" -type d | xargs -I % mkdir %; then
		error "Could not create the folders from the $1 profile"
		return 1
	fi
}


# call()
# {
# 	info "$*"

# 	"$@"
# 	ret=$?
# 	if [ $ret -ne 0 ]
# 	then
# 		error "$*\nreturned: $ret"
# 		error "Being in: $(pwd)"
# 		exit $ret
# 	fi
# }

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
	printf "%s [Y/n]" "$1"
	read -r answer
	if [ -z "$answer" ] || [ "$answer" = "y" ] || [ "$answer" = "Y" ]
	then
		return 0
	else
		return 1
	fi
}


### Platform detection

operating_system="$(uname -s)"
if [ "$operating_system" = "Linux" ]
then
	if has lsb_release
	then
		distro=$(lsb_release -sd)
	else
		# try with if [ ! -f /etc/os-release ]; then
		error "No lsb_release command available"
		exit 1
	fi

	if [ "$distro" = '"Void Linux"' ]; then
		info "$distro detected"
		# resetting sudo
		sudo -k
		distro_file='void_linux.txt'
		package_manager='xbps-install'
		# package_manager_check="$package_manager --dry-run"
		privilege_escalation='sudo'
	# elif [ printf "$os_release" | grep -Eq 'debian|ubuntu' ]; then
	# 	distro_file='debian.txt'
	# 	package_manager='apt-get install -y'
	# 	package_manager_check="$package_manager --dry-run"
	# 	privilege_escalation='sudo'
	else
		error "Unhandled/unknown flavor for the moment..."
		exit 1
	fi

	# printf "$os_release" | grep -q 'arch' \
	# 	&& package_manager="pacman -S"

	# printf "$os_release" | grep -q 'alpine' \
	# 	&& package_manager="pkg add "

	# printf "$os_release" | grep -q 'gentoo' \
	# 	&& package_manager="emerge "

	info "Package manager command should be '$package_manager'"
else
	error "Unsupported platform for now"
	return 1
fi

return 0
