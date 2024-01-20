# The core profile

> My most basic configuration, relying on nothing more than a tty.

This is the collection of tools that forms the backbone of my setup. Nothing
here is expects a graphical server to run, because this should be able to be
installed just anywhere — new laptop, Raspberry Pi, or even a remote virtual
machine.

For a desktop usage and in my case, this is the requirement on top of which the
desktop profile later comes.


## Software to be installed

<table>
	<thead>
		<tr>
			<th>Software</th>
			<th>In link with</th>
			<th>Short description</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td>Development tools</td>
			<td>-</td>
			<td>Compilers, make and so on. Distro-dependant</td>
		</tr>
		<tr>
			<td><code>zsh</code></td>
			<td><code>zsh-syntax-highlighting</code></td>
			<td>Shell of choice with a minimal set of plugins</td>
		</tr>
		<tr>
			<td><code>tmux</code></td>
			<td>-</td>
			<td>Useful to resume a session on a remote, remember considering an alternative ?(dvtm + abducco)</td>
		</tr>
		<tr>
			<td><code>vim</code></td>
			<td>-</td>
			<td>Honestly, just the best editor. That's all...</td>
		</tr>
		<tr>
			<td><code>fzf</code></td>
			<td><code>fd</code></td>
			<td>Insanely fast fuzzy finding tool backed up by a <code>find</code> replacement</td>
		</tr>
		<tr>
			<td><code>htop</code></td>
			<td>-</td>
			<td>System monitor</td>
		</tr>
		<tr>
			<td><code>neofetch</code></td>
			<td>-</td>
			<td>System information concise overview</td>
		</tr>
	</tbody>
</table>


## Home folder structure

I try to keep all my config under the `~/.config` directory, as well as some
tweaks related to `~/.local`. Those two directories has to be created since my
dotfiles are relying on it. Another typical example is the XDG_* directories,
which need to be present before some applications try to store something in say
`state` or `cache`.

The main idea behind this is to try to keep everything at the same place,
whether it is configuration or state of applications. This also have the
advantage of keeping a less cluttered home folder with fewer application
dotfiles even if unfortunately, many still do not follow the XDG Base Directory
specification...

The `~/.local/bin/` and `~/.local/log/` directories represent an extension of
the previous concept, providing a centralized location for respectively storing
custom scripts and relevant software logs to access.


## Script steps

### Create the file structure

First, the file structure present in `_home_folder_structure` will be created to
welcome the associated dotfiles.


### Retrieve the dotfiles repository


### Setting up the git bare repository (~/.dotfiles)

After a successful setup, another folder will be created on top of these two.
The Git bare repository `~/.dotfiles` will store all the details related to
changes related in my workflow including custom scripts and configuration
for my favorite applications. This repository will enable me to push or pull
updates while actively using the home folder.


