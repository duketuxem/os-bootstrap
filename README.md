# About os-bootstrap
Every time I finish installing a new distribution on a machine,
everything feels like something is missing.
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

1. Update the system
2. Install git
3. Create a folder structure like: `~/projects/ricing` and `cd` to it
4. `$> git clone https://github.com/duketuxem/os-bootstrap.git`
5. Change directory to the cloned repository and corresponding platform
6. Run the script


TODO markdown table ?

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
