# No shebang: This script is just sourced
#
# Prevent git from asking to supply information in an interactive way.
# This makes the check regarding a remote repository possible.
export GIT_ASKPASS="echo"
export SSH_ASKPASS="echo"

### Logging
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



check_git_repository()
{
	### Repository / TODO archive, tar.gz ? ...
	# --exit-code allows the command to fail if the branch is incorrect
	if ! git ls-remote --exit-code "$1" "$2" > /dev/null 2>&1;
	then
		error "The repository or branch is incorrect"
		return 1
	fi
	return 0
}

create_file_tree()
{
	# test before ?... + Need to be optional
	# Create the folders (if any) from the profile template description
	if ! find "$home_template/$1" -type d | xargs -I % mkdir %; then
		error "Could not create the folders from the $1 profile"
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
	printf "%s [Y/n] " "$1"
	read -r answer
	if [ -z "$answer" ] || [ "$answer" = "y" ] || [ "$answer" = "Y" ]; then
		return 0
	else
		return 1
	fi
}


