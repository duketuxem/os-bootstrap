#!/usr/bin/env sh

. ../config.sh	# sourcing common template

. ./env.sh		# sourcing distro specifics

distro_directory="$(pwd)"


info "Creating the home folder structure..."
create_home_folder_structure

info "Installing the user packages..."
call sudo xbps-install -y $(grep -v '^#' ./packages.txt | tr '\n' ' ') \
	&& success "Package requirements satisfied!\n"

cd "$ricing_project_directory"

info "Installing the suckless tool suite..."
for soft in dmenu dwm st; do
	call git clone https://github.com/duketuxem/$soft.git -b my_fork \
		&& cd $soft && call sudo make install > /dev/null 2>&1 \
		&& success "$soft successfully installed!\n"

	call git remote set-url origin git@github.com:duketuxem/$soft.git \
		&& success "Repository set to use SSH."
done

info "Setting up all the dotfiles..."
call git clone https://github.com/duketuxem/dotfiles.git -b setup
call cp -r "./dotfiles/.config" "$HOME"
call cp -r "./dotfiles/.local" "$HOME"
call git clone --bare https://github.com/duketuxem/dotfiles "$HOME"/.dotfiles
call git --git-dir="$HOME"/.dotfiles \
	remote set-url origin git@github.com:duketuxem/$soft.git

info "Override the default Zsh configuration location to match ours"
sudo sh -c 'printf "export ZDOTDIR=\"\$HOME\"/.config/zsh\n" > /etc/zsh/zshenv'

info "Changing to Zsh"
call chsh -s /bin/zsh
