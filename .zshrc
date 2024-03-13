# zmodload zsh/zprof
# Path to zsh configurations
if [[ -z "$ZSH_ROOT" ]]; then
  export ZSH_ROOT=$HOME/.zsh
fi

export SDKROOT="$(xcrun --sdk macosx --show-sdk-path)"

# Plugins {{{
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

autoload -Uz compinit
if [ $(date +'%j') != $(date -r ~/.zcompdump +'%j') ]; then
  compinit
else
  compinit -C
fi
setopt promptsubst

# Don't bind these keys until ready
bindkey -r '^[[A'
bindkey -r '^[[B'
function __bind_history_keys() {
  bindkey '^[[A' history-substring-search-up
  bindkey '^p' history-substring-search-up
  bindkey '^[[B' history-substring-search-down
  bindkey '^n' history-substring-search-down
}
# History substring searching
zinit ice wait lucid atload'__bind_history_keys'
zinit light zsh-users/zsh-history-substring-search

zinit ice wait lucid
zinit light zsh-users/zsh-autosuggestions
zinit ice wait lucid
zinit light zdharma/fast-syntax-highlighting

zinit light geometry-zsh/geometry

export NVM_COMPLETION=true
export NVM_LAZY_LOAD=true
zinit light lukechilds/zsh-nvm

zinit ice as"completion"
zinit light-mode depth=1 for \
  OMZP::docker/completions/_docker \
  OMZP::kubectl

# }}}

# Autoloads {{{
autoload -Uz zsh-mime-setup && zsh-mime-setup
autoload -Uz vcs_info
autoload -Uz zmv
autoload -Uz zed
autoload -Uz chpwd_recent_dirs
autoload -Uz cdr
autoload -Uz colors && colors
autoload -U edit-command-line
# }}}

# History {{{
HISTFILE=~/.zsh_history         # where to store zsh config
HISTSIZE=1000000                # big history
SAVEHIST=1000000                # big history
setopt append_history           # append
setopt extended_history
setopt hist_ignore_all_dups     # no duplicate
unsetopt hist_ignore_space      # ignore space prefixed commands
setopt hist_reduce_blanks       # trim blanks
setopt hist_verify              # show before executing history commands
setopt inc_append_history       # add commands as they are typed, don't wait until shell exit
setopt share_history            # share hist between sessions
setopt bang_hist                # !keyword
# }}}

# Directory Stack {{{
DIRSTACKSIZE=10                 # limit size of the stack
setopt autopushd                # change behavior of 'cd' to 'pushd'
setopt pushdsilent              # disable messages when push directories
setopt pushdminus               # because - is easier to type than +
setopt pushdignoredups          # ignore dupes
setopt pushdtohome              # pushd behaves like 'pushd $HOME'
# }}}

# Various {{{
setopt auto_cd                  # if command is a path, cd into it
setopt auto_remove_slash        # self explicit
setopt chase_links              # resolve symlinks
setopt correct                  # try to correct spelling of commands
setopt extended_glob            # activate complex pattern globbing
setopt glob_dots                # include dotfiles in globbing
unsetopt print_exit_value         # print return value if non-zero
unsetopt beep                   # no bell on error
unsetopt bg_nice                # no lower prio for background jobs
unsetopt clobber                # must use >| to truncate existing files
unsetopt hist_beep              # no bell on error in history
unsetopt hup                    # no hup signal at shell exit
unsetopt ignore_eof             # do not exit on end-of-file
unsetopt list_beep              # no bell on ambiguous completion
unsetopt rm_star_silent         # ask for confirmation for `rm *' or `rm path/*'
# }}}

# Zsh hooks {{{
function precmd {
  print -Pn '\e]0;%M:%~\a'    # terminal title: hostname:~/path/to/dir
}

function chpwd {
  chpwd_recent_dirs
}
# }}}

# Command not found {{{
# Uses the command-not-found package zsh support as seen in
# http://www.porcheron.info/command-not-found-for-zsh/ this is installed in
# Ubuntu
[[ -e /etc/zsh_command_not_found ]] && source /etc/zsh_command_not_found
# Arch Linux command-not-found support, you must have package pkgfile installed
# https://wiki.archlinux.org/index.php/Pkgfile#.22Command_not_found.22_hook
[[ -e /usr/share/doc/pkgfile/command-not-found.zsh ]] && source /usr/share/doc/pkgfile/command-not-found.zsh
# }}}

# Functions {{{
function take() {
  if [[ -n $1 && -d $1 ]]; then
    builtin cd $1
  elif [[ -n $1 ]]; then
    mkdir -p $1 && builtin cd $1
  fi
}

function ssh-tmux() {
command ssh -At $@ tmux
}

# Tmux
function trw() {
  if [[ -z $TMUX ]]; then
    return
  fi
  local window=`basename $PWD`
  if [[ -n $1 ]]; then
    window="$1"
  fi
  command tmux rename-window "$window"
}

function tsw() {
  if [[ -z $TMUX ]]; then
    return
  fi
  echo command tmux split-window "'zsh -i -l -c \"$@\"; zsh -i -l'"
  command tmux split-window "'zsh -i -l -c \"$@\"; zsh -i -l'"
}

function pathprepend() {
  for ARG in "$@"; do
    if [ -d "$ARG" ] && [[ ":$PATH:" != *":$ARG:"* ]]; then
      PATH="$ARG${PATH:+":$PATH"}"
    fi
  done
}

function pathappend() {
  for ARG in "$@"; do
    if [ -d "$ARG" ] && [[ ":$PATH:" != *":$ARG:"* ]]; then
      PATH="${PATH:+"$PATH:"}$ARG"
    fi
  done
}
# }}}

# Editor {{{
if type nvim > /dev/null; then
  export EDITOR='nvim'
else
  export EDITOR='vim'
fi
# }}}

# NVM {{{
# export NVM_DIR=~/.nvm
# source $(brew --prefix nvm)/nvm.sh
# }}}

# Go {{{
pathprepend /usr/local/go/bin
pathprepend $HOME/go/bin

# Completion {{{
zmodload -i zsh/complist
setopt menu_complete            # select the first entry
unsetopt flowcontrol
setopt alwayslastprompt
setopt hash_list_all            # hash everything before completion
setopt completealiases          # complete alisases
setopt always_to_end            # when completing from the middle of a word, move the cursor to the end of the word
setopt list_types
setopt complete_in_word         # allow completion from within a word/phrase
setopt correct                  # spelling correction for commands
setopt list_ambiguous           # complete as much of a completion until it gets ambiguous.
setopt cdablevars

zstyle ':completion::complete:*' use-cache on               # completion caching, use rehash to clear
zstyle ':completion::complete:*' rehash true
zstyle ':completion:*' cache-path ~/.zsh/cache              # cache path
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'   # ignore case
zstyle ':completion:*' menu select=2                        # menu if nb items > 2
zstyle ':completion:*::::' completer _expand _complete _ignored _approximate # list of completers to use
zstyle ':completion:*:functions' ignored-patterns '_*'

zstyle ':completion:*' verbose yes
zstyle ':completion:*' format '%B---- %d%b'
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format $'\e[00;34m%d'
zstyle ':completion:*:messages' format $'\e[00;31m%d ---'
zstyle ':completion:*:manuals' separate-sections true
zstyle ':completion:*:warnings' format "$fg[red]No matches for:$reset_color %d"

zstyle ':completion:*:processes' command 'ps -au$USER'
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*' force-list always
zstyle ':completion:*:*:kill:*:processes' list-colors "=(#b) #([0-9]#)*=29=34"
zstyle ':completion:*:*:killall:*' menu yes select
zstyle ':completion:*:killall:*' force-list always
users=(gcoll random root)
zstyle ':completion:*' users $users

zstyle ':completion:*:*:task:*' verbose yes
zstyle ':completion:*:*:task:*:descriptions' format '%U%B%d%b%u'
zstyle ':completion:*:*:task:*' group-name ''

# Make zsh know about hosts already accessed by SSH
zstyle -e ':completion:*:(ssh|scp|sftp|rsh|rsync):hosts' hosts 'reply=(${=${${(f)"$(cat {/etc/ssh_,~/.ssh/known_}hosts(|2)(N) /dev/null)"}%%[# ]*}//,/ })'

# ignore duplicate entries
zstyle ':completion:*:history-words' remove-all-dups yes
zstyle ':completion:*:history-words' stop yes

# completion for cdr
zstyle ':completion:*:*:cdr:*:*' menu selection
# }}}
# }}}

# Key bindings {{{
bindkey -v

if [[ "${terminfo[khome]}" != "" ]]; then
  bindkey "${terminfo[khome]}" beginning-of-line # [Home] - Go to beginning of line
fi

if [[ "${terminfo[kend]}" != "" ]]; then
  bindkey "${terminfo[kend]}" end-of-line # [End] - Go to end of line
fi

if [[ "${terminfo[kcbt]}" != "" ]]; then
  bindkey "${terminfo[kcbt]}" reverse-menu-complete # [Shift-Tab] - move through the completion menu backwards
fi

bindkey ' ' magic-space # [Space] - do history expansion
bindkey '^[[1;5C' forward-word # [Ctrl-RightArrow] - move forward one word
bindkey '^[[1;5D' backward-word # [Ctrl-LeftArrow] - move backward one word

# Make vi mode behave sanely
bindkey '^?' backward-delete-char
bindkey '^W' backward-kill-word
bindkey '^H' backward-delete-char      # Control-h also deletes the previous char
bindkey '^U' backward-kill-line

bindkey '^R' history-incremental-search-backward

# Emacs style
zle -N edit-command-line
bindkey '^xe' edit-command-line
bindkey '^x^e' edit-command-line
# }}}

# Aliases {{{
# List direcory contents
ls --color -d . &>/dev/null 2>&1 && alias ls='ls --color=tty ' || alias ls='ls -G'
alias lsa='ls -lah'
alias l='ls -lah'
alias ll='ls -lh'
alias la='ls -lAh'

alias -g ...='../../'
alias -g ....='../../../'

# Directory Stack
alias dirs='dirs -v'
alias pd='popd'

# be more human
alias df='df -h'
alias free='free -h'

alias zshrc="$EDITOR ~/.zshrc" # Quick access to the ~/.zshrc file
alias zshreload="source ~/.zshrc"

if type tmux2 > /dev/null ; then
  alias tmux=tmux2
  alias tm="agenttmux2 new-session -A -s work"
fi

# Show progress while file is copying
# Rsync options are:
# -p - preserve permissions
# -o - preserve owner
# -g - preserve group
# -h - output in human-readable format
# --progress - display progress
# -b - instead of just overwriting an existing file, save the original
# --backup-dir=/tmp/rsync - move backup copies to "/tmp/rsync"
# -e /dev/null - only work on local files
# -- - everything after this is an argument, even if it looks like an option
alias cpv="rsync -poghb --backup-dir=/tmp/rsync -e /dev/null --progress --"

# Add an "alert" alias for long running commands. Use like so:
# $ sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Programming
# alias build='mkdir build ; cd build && cmake .. && make ; cd .. && ls'

# System info
alias pg='ps aux | grep'  # requires an argument
# alias sensors='sensors && aticonfig --od-gettemperature'

# Misc
alias :q="exit"
alias e="$EDITOR"
alias ccat='pygmentize -O bg=dark'
alias nv="nvim"

# Git
alias glog='git log --graph --full-history --all --color --pretty=format:"%x1b[31m%h%x09%x1b[32m%d%x1b[0m%x20%s"'
alias git-clean-all='git clean -fXd'
alias g='git'
compdef g='git'

# directory shortcut ~ named directories
hash -d projects="$HOME/Projects"
hash -d desktop="$HOME/Desktop"
hash -d downloads="$HOME/Downloads"
if [ -d "$HOME/ownCloud" ]; then
  hash -d owncloud="$HOME/ownCloud"
fi
if [ -d "$HOME/Nextcloud" ]; then
  hash -d nextcloud="$HOME/Nextcloud"
  hash -d owncloud="$HOME/Nextcloud"
fi
if [ -d "$HOME/Code" ]; then
  if [ ! -d "$HOME/Projects" ]; then
    hash -d projects="$HOME/Code"
  fi
  hash -d code="$HOME/Code"
fi
if [ -d $GOPATH ]; then
  hash -d go="$GOPATH"
fi

# Docker {{{
if type docker > /dev/null ; then
  alias sen='docker run --rm --privileged -v /var/run/docker.sock:/run/docker.sock -it -e TERM tomastomecek/sen'
  alias docker-update-images='docker images --format "{{.Repository}}" | xargs -L1 docker pull'
  alias docker-dangling-images='docker images --filter "dangling=true"'
  alias docker-remove-dangling-images='docker rmi $(docker images -f "dangling=true" -q)'
  alias docker-clean-volumes='docker volume ls -qf dangling=true | xargs -r docker volume rm'
  alias docker-clean-containers='docker ps --filter status=dead --filter status=exited -aq | xargs -r docker rm -v'
fi
# }}}

alias py='python'
alias py3='python3'
alias notebook='jupyter notebook'
# }}}

# Cursor {{{
zle -N zle-keymap-select
zle -N zle-line-init
zle -N zle-line-finish

function zle-keymap-select {
# change cursor shape in urxvt
case $KEYMAP in
  vicmd)      print -n -- "\033[2 q";;  # block cursor
  viins|main) print -n -- "\033[5 q";;  # line blinking cursor
esac
zle -R
}

function zle-line-init {
print -n -- "\033[5 q"
}

function zle-line-finish {
print -n -- "\033[2 q"  # block cursor
}
# }}}

# fzf {{{
function fzf-install() {
command git clone --depth 1 https://github.com/junegunn/fzf.git $ZSH_ROOT/fzf
$ZSH_ROOT/fzf/install --completion --key-bindings --no-update-rc --no-fish
}

function fzf-update() {
builtin cd $ZSH_ROOT/fzf
command git pull
$ZSH_ROOT/fzf/install --completion --key-bindings --no-update-rc --no-fish
}

if [ -n $TMUX ]; then
  export FZF_TMUX=1
fi

[ -f $HOME/.fzf.zsh ] && source $HOME/.fzf.zsh
# }}}

pathprepend $HOME/.local/bin
pathprepend $HOME/.bin
pathprepend $(python3 -m site --user-base)/bin
pathappend /snap/bin

export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
if type pyenv > /dev/null ; then
  eval "$(pyenv init -)"
fi

if type zoxide >/dev/null ; then
  eval "$(zoxide init zsh)"
fi

# zprof
#compdef gt
###-begin-gt-completions-###
#
# yargs command completion script
#
# Installation: gt completion >> ~/.zshrc
#    or gt completion >> ~/.zprofile on OSX.
#
_gt_yargs_completions()
{
  local reply
  local si=$IFS
  IFS=$'
  ' reply=($(COMP_CWORD="$((CURRENT-1))" COMP_LINE="$BUFFER" COMP_POINT="$CURSOR" gt --get-yargs-completions "${words[@]}"))
  IFS=$si
  _describe 'values' reply
}
compdef _gt_yargs_completions gt
###-end-gt-completions-###

# vim: fdm=marker et fen fdl=0 tw=0 shiftwidth=2
