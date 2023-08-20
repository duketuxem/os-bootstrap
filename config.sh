#!/usr/bin/env sh

ricing_project_directory="$HOME/develop/ricing"

create_home_folder_structure()
{
	# the lab
	mkdir -p "$ricing_project_directory"

	# top level directories
	mkdir "$HOME/music"
	mkdir "$HOME/movies"
	mkdir "$HOME/pictures"

	mkdir -p "$HOME/.local/bin"
	mkdir "$HOME/.config"
}

###
# Utils
###
error() {
    printf "\033[0;1;31m$*\033[0m\n"
    exit
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

