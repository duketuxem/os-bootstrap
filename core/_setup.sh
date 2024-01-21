#!/usr/bin/env sh

# Where to retrieve the user dotfiles
dotfiles_repo='https://github.com/duketuxem/dotfiles.git'
dotfiles_repo_ssh='git@github.com/duketuxem/dotfiles.git'
dotfiles_repo_branch='setup'
dotfiles_repo_name='dotfiles'

default_shell='/usr/bin/zsh'


if [ -z "${privilege_escalation+test_if_set}" ]
then
	. ../utils.sh
	# TODO: OS detection when the script is not run from install.sh ...
	which_linux
fi


# Copier le contenu du repo dotfiles dans les $HOME/.dots
# Changer le shell par defaut si pas fait
# Faire la config root pour le respect des dotfiles

check_git_repository "$dotfiles_repo" "$dotfiles_repo_branch" || exit 1

# Will create .config/ .local/{share/state/...}
prev_dir=$(pwd)
# Create the folders (if any) from the profile template description
cd # $HOME
if ! find "$prev_dir/_home_folder_structure" \
	-type d -printf '%P\n' | xargs -I % mkdir %
then
	error "Could not create the folders from the $1 profile"
	return 1
fi
cd -

# Clone dotfiles repository next to os-bootstrap
cd ..
if ! git clone "$dotfiles_repo" -b "$dotfiles_repo_branch"
then
	error "Failed to clone the dotfiles repository"
	exit 1
else
	cd "$dotfiles_repo_name"
fi

# 'deploy' the configuration
# TODO: Use `rsync` here ?
cp -r "./$dotfiles_repo_name/.config" "./$dotfiles_repo_name/.local" "$HOME"

# Setup the dotfiles workflow using git bare repositories
git clone --bare "$dotfiles_repo" "$HOME/.dotfiles"
# Ready to commit with ssh if needed
git --git-dir="$HOME/.dotfiles" remote set-url origin "$dotfiles_repo_ssh"

# Configure zsh to not look for dotfiles in $HOME anymore
"$privilege_escalation" sh -c \
	'printf "ZDOTDIR=\"\$HOME\"/.config/zsh\n" > /etc/zsh/zshenv'

# Check and change default shell
if [ $(cat /etc/passwd | grep "$USER" | cut -d ':' -f 7) != "$default_shell"]
then
	info "Changing the user's shell to $login_shell"
	chsh -s "$login_shell"
fi
