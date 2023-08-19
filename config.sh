#!/usr/bin/env sh

suckless_tools_location="$HOME/dev/suckless"

create_home_folder_structure()
{
	# ~
	# ├── .dotfiles/
	# ├── bin/
	# ├── dev/
	#     └── suckless/
	#         ├── dmenu/
	#         ├── dwm/
	#         └── st/
	# ├── music/
	# ├── pictures/
	# │   └── wallpaper.img
	# └── projects/
	#     ├── another_project/
	#     └── ricing/
	#         ├── dotfiles/ -> /home/remi/home/.dotfiles
	#         ├── os-bootstrap/

	# top level directories
	mkdir "$HOME"/music
	mkdir "$HOME"/pictures
	mkdir "$HOME"/movies

	# the lab
	mkdir "$HOME"/dev
	mkdir "$HOME"/dev/suckless
	mkdir "$HOME"/dev/suckless/dmenu
	mkdir "$HOME"/dev/suckless/dwm
	mkdir "$HOME"/dev/suckless/st

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

