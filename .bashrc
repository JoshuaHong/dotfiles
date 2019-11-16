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
PS1="\[\e[91m\][\[\e[m\]\[\e[93m\]\u\[\e[m\]\[\e[92m\]@\[\e[m\]\[\e[94m\]\h\[\e[m\]\[\e[95m\] \W\[\e[m\]\[\e[91m\]]\[\e[m\]\[\e[96m\]$\[\e[m\]\[\e[39m\] "

# Use ls with color
alias ls="ls --color=auto"

# Use vim bindings
set -o vi
