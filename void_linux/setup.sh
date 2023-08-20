#!/usr/bin/env sh

. ../config.sh	# sourcing common template

. ./env.sh		# sourcing distro specifics

distro_directory="$(pwd)"


info "Creating the home folder structure..."
create_home_folder_structure


info "Installing the user packages..."
call sudo xbps-install -y $(grep -v '^#' ./packages.txt | tr '\n' ' ') \
&& success "Package requirements satisfied!\n"


info "Installing the suckless tool suite..."
cd "$ricing_project_directory"
for soft in dmenu dwm st; do
	call git clone https://github.com/DukeTuxem/$soft.git -b my_fork \
	&& cd $soft && call sudo make install 2>&1 > /dev/null && cd .. \
	&& success "$soft successfully installed!\n"
done
cd "$distro_directory"
