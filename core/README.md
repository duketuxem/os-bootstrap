# The core profile

My most basic configuration, relying on nothing more than a tty.
Just a set of pre-configured tools I expect to be present to keep my workflow
consistent across devices.

This will install all the following listed software as well as the related
configuration. Then the file structure present in `_home_folder_structure` will
be created to welcome the associated dotfiles.


## Software table

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
			<td>`zsh`</td>
			<td>`zsh-syntax-highlighting`</td>
			<td>Shell of choice with a minimal set of plugins</td>
		</tr>
		<tr>
			<td>`tmux`</td>
			<td>-</td>
			<td>Useful to resume a session on a remote, remember considering an alternative ?(dvtm + abducco)</td>
		</tr>
		<tr>
			<td>`vim`</td>
			<td>-</td>
			<td>Honestly, just the best editor. That's all...</td>
		</tr>
		<tr>
			<td>`fzf`</td>
			<td>`fd`</td>
			<td>Insanely fast fuzzy finding tool backed up by a `find` replacement</td>
		</tr>
		<tr>
			<td>`htop`</td>
			<td>-</td>
			<td>System monitor</td>
		</tr>
		<tr>
			<td>`neofetch`</td>
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



## Git bare repository (~/.dotfiles)

After a successful setup, another folder will be created on top of these two.
The Git bare repository `~/.dotfiles` will store all the details related to
changes related in my workflow including custom scripts and configuration
for my favorite applications. This repository will enable me to push or pull
updates while actively using the home folder.


# Home folder structure

In my opinion, to best feel like home one needs to establish a clearly
predefined folder structure hierarchy, and stick to it to always maintain those
bytes tidy !

The 'specification' I came with is available to check and adapt to your needs if
you feel so. Anything in this folder will be used to create the folder tree on
the targeted system.


#### draft, wip, todo
- jq

### Fonts
- cyrillic


		<tr>
			<td>`xorg`</td>
			<td>Graphic drivers ready</td>
			<td>Graphic server. Does the job but why not to try wayland some day...</td>
		</tr>
		<tr>
			<td rowspan="2">Fonts</td>
			<td>Nerd fonts</td>
			<td>Window manager and terminal</td>
		</tr>
		<tr>
			<td>Noto fonts CJK</td>
			<td>Asian languages</td>
		</tr>
		<tr>
			<td>`dwm` + `dmenu`</td>
			<td>`libX11 libXft libXinerama`, fonts</td>
			<td>Tiling window manager and app launcher by suckless</td>
		</tr>
		<tr>
			<td>`st`</td>
			<td>`libX11 libXft`, fonts</td>
			<td>Terminal emulator from by suckless</td>
		</tr>
	</tbody>
</table>
