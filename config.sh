# No shebang needed since this script is sourced, not meant to be executed

# To help to understand the concepts a bit more:
# [Target] tag relates to the machine/distro to set up
# [Config] tag relates to the user config (other repository)
# [Spec] a summary of what is used from the script


# [Target]
# Where to clone any other distant repository
repositories_location="$HOME/workspace/repositories/github/"
# User's shell of choice
login_shell='/usr/bin/zsh'

# [Config]
dotfiles_git_full_url='https://github.com/duketuxem/dotfiles.git'
dotfiles_git_branch='setup'

# [Spec]
home_template='_home_folder_structure'
main_profile_directory='core'
desktop_profile_directory='desktop'

main_profile_file='core.txt'
desktop_profile_directory='gui.txt'

# dotfiles_repo_url_http="https://github.com/duketuxem/dotfiles.git"
# dotfiles_repo_url_ssh="git@github.com/duketuxem/dotfiles.git"
