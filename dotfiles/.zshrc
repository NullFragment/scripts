# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000
setopt autocd
unsetopt beep extendedglob nomatch notify
bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '${HOME}/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

source ${HOME}/.antidote/antidote.zsh
antidote load ${ZDOTDIR:-$HOME}/.zsh_plugins

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh


ZSH_DISABLE_COMPFIX=true
ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"

#########################################
### ALIASES
#########################################
## Colors and such
STARS='*********************************************************************************************************************************'
PREFIX='\\033[0\;34m*********************************************************************************************************************************'
POSTFIX='*********************************************************************************************************************************\\033[0m'

## Git functions
function git_branch_status() {
  (
    cd $1
    ~/git-branch-status -l
  )
}

function git_diff() {
  git --no-pager -C $1 diff --color $2
}

function git_stash_list() {
  git --no-pager -C $1 stash list --color
}

function git_status() {
  git --no-pager -C $1 status
}

function git_push() {
  git --no-pager -C $1 push
}

function git_fetch() {
  git --no-pager -C $1 fetch
}

function git_log() {
  git --no-pager -C $1 log -n 1 --color
}

function git_fetch_pull() {
  while read branch; do
    upstream=$(git --no-pager -C $1 rev-parse --abbrev-ref $branch@{upstream} 2>/dev/null)

    if [[ $? == 0 ]]; then
      echo $branch tracks $upstream
      git --no-pager -C "$1" pull origin $branch
    else
      echo $branch" is not tracking a remote. Only doing a fetch."
      git --no-pager -C "$1" fetch origin $branch
    fi

  done < <(git --no-pager -C $1 for-each-ref --format='%(refname:short)' refs/heads/*)
}

## Other Fun functions
function sshProxy() {
    echo "SSHing through $1 to $2"
    ssh -o ProxyCommand="ssh $1 nc %h %p" $2
}

## Random Steam Compatibility stuff
function steamAddGamemode() {
    perl -0777 -i -pe 's/(\t\t\t\t\t\}\n\t\t\t\t\t"[0-9]+"\n\t\t\t\t\t\{)/\t\t\t\t\t\t"LaunchOptions"\t\t"gamemoderun %command%"\n$1/g' ${HOME}/.steam/steam/userdata/37533255/config/localconfig.vdf
}


## RClone Proton Drive
function protonRepair(){
    baseDir=~/Storage/Drive
    if [ $# -eq 1 ]; then
        baseDir="$1"
    fi
    while IFS='' read -r -d '' dir; do
        splitDir=`echo $dir | awk '{split($0, a, "${HOME}/Storage/Drive"); print(a[2])}'`
        rclone bisync ~/Storage/Drive$splitDir protonDrive:$splitDir \
	    --create-empty-src-dirs \
	    --compare size,modtime,checksum \
	    --slow-hash-sync-only \
	    --resilient \
	    -MvP \
	    -vv \
	    --drive-skip-gdocs \
	    --fix-case \
	    --max-depth 1 \
	    --resync \
	    --resync-mode newer

    done < <(find $baseDir -type d -print0)
}

function protonFullSync(){
	rclone bisync ~/Storage/Drive protonDrive: \
		--create-empty-src-dirs \
		--compare size,modtime,checksum \
	    	--slow-hash-sync-only \
	    	--resilient \
	    	-MvP \
	    	--drive-skip-gdocs \
	    	--fix-case 
}


function protonSync(){
    baseDir=~/Storage/Drive
    if [ $# -eq 1 ]; then
        baseDir="$1"
    fi
    
    splitDir=`echo $1 | awk '{split($0, a, "${HOME}/Storage/Drive"); print(a[2])}'`
    rclone bisync ~/Storage/Drive$splitDir protonDrive:$splitDir \
        --create-empty-src-dirs \
        --compare size,modtime,checksum \
        --slow-hash-sync-only \
        --resilient \
       	-MvP \
        --drive-skip-gdocs \
        --fix-case \
        --max-depth 1
}

## Useful commands
alias ls='ls --color=auto'
alias ll='ls -a -l --color=auto'
alias cls='clear && ls --color=auto'
alias resource='source ~/.zshrc'
alias rubykill='ps aux | grep ruby | awk "{print \$2}" | xargs kill -9'
alias python='python3'

# Dumb stuff
alias fixAudio='pw-metadata -n settings 0 clock.force-quantum 256 && pw-metadata -n settings 0 clock.force-rate 96000 && pw-metadata -n settings 0 clock.force-quantum 512 && pw-metadata -n settings 0 clock.force-rate 192000'

## Tmux
alias mux='tmuxinator'
alias mlmux='tmuxinator ml_sys'

alias tmk='tmux kill-session -t'
alias tmn='tmux new -s'
alias tml='tmux list-sessions'
alias tma='tmux a -t'

## Git stuff
alias gbsl='git-branch-status -l'
alias git-branch-status='~/git-branch-status'
alias gnd='git --no-pager diff'

function gcnc() {
    git checkout $1 $2 && git clean -fd -x
}

############################################################################
### EXPORTS
############################################################################
export EDITOR=$(which vim)

#export DOTNET_ROOT="/opt/homebrew/opt/dotnet/libexec"
#path=$PATH:${HOME}/.dotnet/tools
#path=$PATH:${HOME}/Developer/PlaydateSDK
path=$PATH:${HOME}/.local/share/yabridge
path=$PATH:${HOME}/.local/bin
export PATH=$PATH

#export PLAYDATE_SDK_PATH=${HOME}/Developer/PlaydateSDK
#export CPATH=/opt/homebrew/include
#export LIBRARY_PATH=/opt/homebrew/lib

unsetopt correct
unsetopt correct_all
unsetopt nomatch

# pnpm
#export PNPM_HOME="${HOME}/Library/pnpm"
#export PATH="$PNPM_HOME:$PATH"
# pnpm end
