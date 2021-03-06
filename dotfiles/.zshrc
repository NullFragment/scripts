###################################################
### The following lines were added by compinstall
###################################################
zstyle ':completion:*' completer _complete _ignored _approximate
zstyle ':completion:*' expand prefix suffix
zstyle ':completion:*' file-sort name
zstyle ':completion:*' insert-unambiguous false
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' list-suffixes true
zstyle ':completion:*' matcher-list '' 'm:{[:lower:]}={[:upper:]} m:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' menu select=0
zstyle ':completion:*' original true
zstyle ':completion:*' preserve-prefix '//[^/]##/'
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' special-dirs true
zstyle ':completion:*' squeeze-slashes true
zstyle ':completion:*' verbose true
zstyle :compinstall filename '/home/kyle/.zshrc'

autoload -Uz compinit
compinit
###################################################
### End of lines added by compinstall
###################################################

###################################################
### Lines configured by zsh-newuser-install
###################################################
HISTFILE=~/.zsh_histfile
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory autocd extendedglob nomatch
unsetopt beep notify
bindkey -e
###################################################
### End of lines configured by zsh-newuser-install
###################################################

###################################################
### ALIASES & DEFAULTS
###################################################

alias ls='ls --color=auto'
alias cls='clear;ls'
alias ll='ls -l'

alias mux='tmuxinator'
alias mlmux='tmuxinator ml_sys'

alias tmk='tmux kill-session -t'
alias tmn='tmux new -s'
alias tml='tmux list-sessions'
alias tma='tmux a -t'

alias acii='ssh kps168@aci-i.aci.ics.psu.edu'

export EDITOR=$(which vim)

###################################################
### PLUGINS & MODIFICATIONS
###################################################
source ~/.zsh/antigen.zsh
antigen bundle joel-porquet/zsh-dircolors-solarized.git
antigen apply
setupsolarized dircolors.256dark
