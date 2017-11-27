# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin directories
PATH="$HOME/bin:$HOME/.local/bin:$PATH"
PATH="$PATH:/usr/local/cuda-9.0/bin"
PATH="$PATH:/usr/local/texlive/2017/bin/x86_64-linux"
MANPATH="$MANPATH:/usr/local/texlive/2017/texmf-dist/doc/man"
INFOPATH="$INFOPATH:/usr/local/texlive/2017/texmf-dist/doc/info"
LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/usr/local/cuda-9.0/lib"

export PATH
export MANPATH
export INFOPATH
export LD_LIBRARY_PATH

