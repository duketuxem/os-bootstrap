#!/usr/bin/env sh

# Where to retrieve the user dotfiles
dotfiles_repo='https://github.com/duketuxem/dotfiles.git'
dotfiles_repo_ssh='git@github.com/duketuxem/dotfiles.git'
dotfiles_repo_branch='setup'
dotfiles_repo_name='dotfiles'

default_shell='/usr/bin/zsh'


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

deploy_config()
{
	# Clone dotfiles repository next to os-bootstrap
	cd ../..
	if ! git clone "$dotfiles_repo" -b "$dotfiles_repo_branch"
	then
		error "Failed to clone the dotfiles repository"
		exit 1
	fi

	cd "$dotfiles_repo_name"
	cp -r "./.config" "./.local" "$HOME"

	cd	# $HOME
	# Setup the dotfiles workflow using git bare repositories
	git clone --bare "$dotfiles_repo" "$HOME/.dotfiles"
	# Ready to commit with ssh if needed - just need the key
	git --git-dir="$HOME/.dotfiles" remote set-url origin "$dotfiles_repo_ssh"
}

change_shell()
{
	# Check and change default shell
	if [ "$(cat /etc/passwd | grep "$USER" | cut -d ':' -f 7)" != "$default_shell" ]
	then
		# Configure zsh to not look for dotfiles in $HOME anymore
		info "Configuring zsh to look for dotfiles in $HOME/.config/zsh"
		"$privilege_escalation" sh -c \
			'printf "ZDOTDIR=\"\$HOME\"/.config/zsh\n" > /etc/zsh/zshenv'
		info "Changing the user's shell to $default_shell"
		chsh -s "$default_shell"
	fi
}

# Arguments
if [ -z "${privilege_escalation+test_if_set}" ]
then
	. ../utils.sh || exit 1
fi

# Main
check_git_repository "$dotfiles_repo" "$dotfiles_repo_branch" || exit 1

check_and_create_folders

deploy_config

change_shell


