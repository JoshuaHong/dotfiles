#
# $HOME/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Autostart X at login
if systemctl -q is-active graphical.target && [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
  exec startx
fi

# Primary prompt
PS1='[\u@\h \W]\$ '

# Use ls with color
alias ls='ls --color=auto'

# Use vim bindings
set -o vi
