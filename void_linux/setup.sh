#!/usr/bin/env sh

set -eu

. ../config.sh	# common template

. ./env.sh		# distro specifics

actual_directory="$(pwd)"


info "Creating the home folder structure..."
create_home_folder_structure


info "Installing the user packages..."
sudo xbps-install -y $(grep -v '^#' ./packages.txt | tr -d '\n') \
&& success "Package requirements satisfied!\n"


info "Installing the suckless tool suite..."
cd "$suckless_tools_location"
for soft in dmenu dwm st; do
	git clone https://github.com/DukeTuxem/$soft.git -b my_fork \
	&& cd $soft && sudo make install && cd .. \
	&& success "$soft successfully installed!\n" \
	|| error "$soft install failed for some reason :(\n"
done

cd "$actual_directory"
