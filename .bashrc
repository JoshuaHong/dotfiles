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
gitbranch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}
PS1="\[\e[31m\][\[\e[m\]\[\e[33m\]\u\[\e[m\]\[\e[32m\]@\[\e[m\]\[\e[34m\]\h\[\e[m\]\[\e[94m\] \W\[\e[35m\]\$(gitbranch)\[\e[m\]\[\e[m\]\[\e[31m\]]\[\e[m\]\[\e[36m\]$\[\e[m\]\[\e[39m\] "

# Aliases
alias ls="ls --color=auto"
alias timer="$HOME/scripts/general/timer.sh"

# Use vim bindings
set -o vi

# Use fzf
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# Enable fzf file previews
export FZF_CTRL_T_OPTS="--preview '(highlight -O ansi -l {} 2> /dev/null || cat {} || tree -C {}) 2> /dev/null | head -200'"
