#!/usr/bin/env sh

# this must exists _before_ running the distro script
ricing_project_directory="$HOME/develop/ricing"

create_home_folder_structure()
{
	# top level directories
	step mkdir "$HOME/music"
	step mkdir "$HOME/movies"
	step mkdir "$HOME/pictures"

	# XDG spec directories
	step mkdir -p "$HOME/.local/bin"
	step mkdir "$HOME/.config"
}

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

