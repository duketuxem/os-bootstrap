# No shebang, this script is not meant to be executed

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
