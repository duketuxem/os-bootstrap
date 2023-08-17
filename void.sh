#!/usr/bin/env sh

set -eu

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

# packages
sys_utils="base-devel curl htop"
display="xorg libX11-devel libXft-devel libXinerama-devel"
fonts="nerd-fonts-otf noto-fonts-cjk"
shell="zsh zsh-syntax-highlighting fd fzf tmux vim"
# my forked suckless tool suite repositories
suckless_tools_path="$USER/projets/ricing/"

# 1.
info "Installing the user packages..."
sudo xbps-install -y "$sys_utils $display $fonts $shell" \
&& success "Package requirements satisfied!\n"

# 2.
cd "$suckless_tools_path"
git clone https://github.com/DukeTuxem/dwm.git -b my_fork \
	&& cd dwm && sudo make install && cd .. && \

	git clone https://github.com/DukeTuxem/st.git -b my_fork \
	&& cd st && sudo make install && cd .. && \

	git clone https://github.com/DukeTuxem/dmenu.git -b my_fork \
	&& cd dmenu && sudo make install && cd .. \
	&& success "Suckless suite successfully installed!\n" \
	|| error "Some suckless program could not have been installed :(\n\n"
