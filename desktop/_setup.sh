#!/usr/bin/env sh

. ../utils.sh
which_linux

desktop_repositories_prefix='https://github.com/duketuxem/'
repositories_location='workspace/projects/repositories/github'

check_and_create_folders()
{
	if ! folders=$(find '_home_folder_structure' -type d -printf '%P\n')
	then
		error "Can not locate the home folder structure in core/"
		unset -v folders
		return 1
	fi

	cd	# folders should be checked/created in $HOME
	for folder in $home_folders
	do
		if [ ! -d "$folder"]
		then
			info "Creating folder: $PWD/$folder"
			mkdir "$folder" || error "failed"
		fi
	done
	cd -	# come back to core/

	unset -v folders
}

install_suckless_suite()
{
	info "Installing the custom desktop suite (suckless)..."
	cd
	cd "$repositories_location"

	for soft in dmenu dwm st
	do
		if has $soft; then
			info "$soft is already installed"
			continue
		fi
		call git clone "$desktop_repositories_prefix$soft".git -b my_fork \
			&& cd $soft \
			&& call "$privilege_escalation" make install \
			&& success "$soft successfully installed!\n" \
			&& git remote set-url origin git@github.com:duketuxem/$soft.git \
			&& success "Repository set to use SSH." \
			&& cd ..
	done
}

info "Creating the desktop profile file structure..."
check_and_create_folders

install_suckless_suite
