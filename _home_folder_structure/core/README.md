# Core profile

This is to ensure the expected folders exist before migrating all the
configuration that will rely on it. A typical example is the XDG_* directories,
which need to be created before some applications try to store something in say
`state` or `cache`.

The main idea behind this is to try to keep everything at the same place,
whether it is configuration or state of applications. This also have the
advantage of keeping a less cluttered home folder with fewer application
dotfiles even if unfortunately, many still do not follow the XDG Base Directory
specification.

The `~/.local/bin/` and `~/.local/log/` directories represent an extension of
the previous concept, providing a centralized location for respectively storing
custom scripts and relevant software logs to access.


## Git bare repository (~/.dotfiles)

After a successful setup, another folder will be created on top of these two.
The Git bare repository `~/.dotfiles` will store all the details related to
changes related in my workflow including custom scripts and configuration
for my favorite applications. This repository will enable me to push or pull
updates while actively using the home folder.
