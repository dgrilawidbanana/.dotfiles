#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias config='/usr/bin/git --git-dir=/home/dgrilawidbanana/.dotfiles/ --work-tree=/home/dgrilawidbanana'

PS1='[\u@\h \W]\$ '

fastfetch
