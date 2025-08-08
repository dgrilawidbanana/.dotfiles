#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias config='git --git-dir="$HOME/.dotfiles" --work-tree="$HOME"'

PS1='\[\033[01;32m\]\u@\h\[\033[01;34m\] \w\[\033[00m\] \$ '

export EDITOR="micro"
export PYENV_ROOT="$HOME/.pyenv"
[[ -d "$PYENV_ROOT/bin" ]] && export PATH="$PYENV_ROOT/bin:$PATH"

eval "$(pyenv init - bash)"

fastfetch
