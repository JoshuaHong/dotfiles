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
PS1='\[\033[91m\]\][\[\033[93m\]\]\u\[\033[92m\]\]@\[\033[94m\]\]\h \[\033[95m\]\]\W\[\033[91m\]\]]\[\033[96m\]\]\$\[\033[39m\]\] '

# Use ls with color
alias ls='ls --color=auto'

# Use vim bindings
set -o vi
