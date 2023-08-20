# About os-bootstrap
Every time I finish installing a new distribution on a machine,
obvioulsy nothing I want is there...
Having to reinstall the same software suite repeatedly is frustrating,
and managing the corresponding configuration for
those applications is even worse.

This project aims to minimize those tedious steps as much as possible
for every platform I intend or have to work with.

This is not about scripts that perform a fully automated
operating system installation. I believe there are other tools to handle that.
The requirements for a given machine or context may also vary each time, which
is why this is more focused to preparing a usable, familiar environment once
the core system installation is done.


# How to use
The user is logged on the system, and the machine has access to the internet.

1. Update the system.
2. Install Git.
3. Create the path specified in the variable `$ricing_project_directory`
in the `config.sh` file.
4. Change the directory to that newly created folder.
5. Clone this repository:
`$> git clone https://github.com/duketuxem/os-bootstrap.git`
6. Navigate to the relevant platform folder.
7. Run the `setup.sh` script in that folder.

%% 8. Refer to https://github.com/DukeTuxem/dotfiles for the associated configuration


# Software list
To give an idea of what is going to be installed.

### System utilities
- building tools (make, ...)
- htop
- curl / wget
- jq...

### Fonts
- Nerd fonts (for the terminal)
- noto-fonts-cjk (for asian languages support)
- cyrillic

### Basic user needs
- xorg
- dwm - depending on:
  - libX11
  - libXft
  - libXinerama
- st - depending on:
    - libX11
    - libXft
- dmenu - depending on:
    - libX11
    - libXft
    - libXinerama
- zsh
    - zsh-syntax-highlighting
- tmux
- vim
- fzf
  - fd (find replacement)
