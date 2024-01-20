# Why this project

Every time I finish installing a new distribution on a (virtual) machine,
obvioulsy nothing I want is there... Having to reinstall the same software
suite repeatedly is frustrating, and managing the corresponding configuration
for those applications is even worse.

This project aims to minimize those tedious steps as much as possible
for every platform I intend or have to work with.

This is not about scripts that perform a fully automated operating system
installation, like a specific Linux distribution on a hard drive. The
requirements for a given machine or context may also vary each time, which is
why this is more focused to preparing a usable, familiar environment once the
core system installation is done.


## How does it work

This repository contains an `install.sh` script that takes a profile name as an
argument. A profile is simply any directory left at the root of that repository
and describe how that latter should be deployed on a target system.

When `install.sh` is run with a given profile, it will first identify the
system it is running on. Next, it will look for a plain text file corresponding
to the detected system. That file should hold all the software dependencies
related to the configuration to be deployed, as expected by the package
manager.

Finally, the configuration deployment process is handled over the profile main
script, which has to describe all the steps to deploy what it is embedding.


## How to use

1. Install the system of your choice that is supported
2. Be sure the system has access to the internet
3. Update the system and eventually reboot
4. Install `git`
5. Clone this repository:
	`$> git clone https://github.com/duketuxem/os-bootstrap.git`
6. Change directory to it: `cd os-bootstrap/`
7. To install the core profile for example, run `install.sh core`
8. Eventually install other profiles or create your own !
9. Enjoy


## Implementation notes

### Design

Separating the installation from the configuration steps offers several
benefits:

1. **Generic Installation:** The installation part is generic and requires only
   a profile to list all software dependencies. This provides a clear view of
   what the profile expects to find already installed on a target, which can be
   any platform.
2. **Independence of Processes:** Each process can be replayed independently.
   However, the installation may suggest executing the corresponding profile
   subscript.
3. **Standalone Configuration Deployment:** The configuration deployment
   process is a standalone and contained routine. This allows the script to be
   replayed at any time, helping to keep the configuration up to date, even as
   it evolves over time.

### Scripting

The install script is written in pure shell (no bash/zsh... flavor) to maximize
portability. The goal would be to even support Windows, as long as there is a
package manager available and other requirements met. So far, supporting a wide
range of linux distributions is nice. As a minor drawback, one needs to look
for every package name in each distribution for any software adding, but once a
configuration is established it should not be something done everytime...
