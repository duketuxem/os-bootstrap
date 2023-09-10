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


# The software list
The following table lists all the software that can be installed.

Note that it is possible to choose some targets for say a server, so it only
holds the system utilities and does not come installed with all the GUI layer.

Also note that the name of the target should match the corresponding file in
the distribution directory (core.txt, gui.txt, ...).

The dependencies column is not really about a package install requirement
but more like things related to the use of the software, sometimes a remember.

<table>
	<thead>
		<tr>
			<th>Target</th>
			<th>Software</th>
			<th>Dependencies</th>
			<th>Short description</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td rowspan="7">Core</td>
			<td>Development tools</td>
			<td>Suckless suite</td>
			<td>Compilers, make and so on.
				Distro-dependant</td>
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
		<tr>
			<td rowspan="5">GUI</td>
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


# Home folders structure
The feeling of a familiar and comfy environment to work with
comes from a pre-determined folder structure.
Here is how I designed mine:
```
~
├── .config/
│   ├── vim/
│   ├── zsh/
│   └── ...and so on...
├── .dotfiles/
├── .local/
│   ├── bin/
│   ├── cache/
│   ├── share/
│   └── state/
├── develop/
│   └── ricing/
│       ├── dotfiles/
│       ├── os-bootstrap/
│       └── suckless/
│           ├── dmenu/
│           ├── dwm/
│           └── st/
├── movies/
├── music/
└── pictures/
    └── wallpaper.img
```
To add a note, a quite idealistic goal would be to have all the applications
using configuration files at the home root folder 


# How to use
The user is logged on the system, and the machine has access to the internet.

1. Update the system, and reboot eventually.
2. Install `git` and `doas`.
3. Create the path specified in the variable `$ricing_project_directory`
in the `config.sh` file.
4. Change the directory to that newly created folder.
5. Clone this repository:
`$> git clone https://github.com/duketuxem/os-bootstrap.git`
6. Navigate to the relevant platform folder.
7. Run the `setup.sh` script in that folder.

%% 8. Refer to https://github.com/DukeTuxem/dotfiles for the associated configuration

#### draft, wip, todo
- curl / wget
- jq...

### Fonts
- cyrillic


