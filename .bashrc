#
# $HOME/.bashrc
#

# ========== Init ========== {{{
# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Autostart X at login
if systemctl -q is-active graphical.target && [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
  exec startx
fi
# }}}

# ========== General ========== {{{
# Primary prompt
gitbranch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}
PS1="\[\e[31m\][\[\e[m\]\[\e[33m\]\u\[\e[m\]\[\e[32m\]@\[\e[m\]\[\e[34m\]\h\[\e[m\]\[\e[94m\] \W\[\e[35m\]\$(gitbranch)\[\e[m\]\[\e[m\]\[\e[31m\]]\[\e[m\]\[\e[36m\]$\[\e[m\]\[\e[39m\] "

# Use vim bindings
set -o vi

# Use fzf
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
# }}}

# ========== Exports ========== {{{
# Enable fzf file previews
export FZF_CTRL_T_OPTS="--preview '(highlight -O ansi -l {} 2> /dev/null || cat {} || tree -C {}) 2> /dev/null | head -200'"

# Set default editor
export EDITOR=/usr/bin/vim
# }}}

# ========== Aliases ========== {{{
# ========== General ========== {{{
# Cd to previous directory for each "."
str-rep() {
  local s=`printf "%$2s"`; printf '%s' "${s// /$1}"
}
for i in {1..8}; do
  alias `str-rep . $i`=cd\ `str-rep ../ $i`
done

# Cd and ls
cd() {
  builtin cd "$@" && ls --color=auto
}

alias cp="cp -r"
alias ls="ls --color=auto"
alias update="sudo pacman -Syu"
# }}}

# ========== Git ========== {{{
alias ga="git add"
alias gaa="git add --all"
alias gb="git branch"
alias gbd="git branch delete"
alias gc="git commit"
alias gcm="git commit --message"
alias gco="git checkout"
alias gcob="git checkout -b"
alias gcom="git checkout master"
alias gcod="git checkout develop"
alias gd="git diff"
alias gdh="git diff HEAD"
alias gi="git init"
alias gl="git log --all --decorate --graph --oneline --date=short --pretty=format:'%C(yellow)%h%Creset%C(red)%C(bold)%d%Creset%C(white)(%cd)%Creset %s'"
alias gm="git merge"
alias gpl="git pull"
alias gps="git push"
alias gr="git rebase"
alias gs="git status"
alias gst="git stash"
alias gstp="git stash pop"
# }}}

# ========== Scripts ========== {{{
alias timer="$HOME/scripts/general/timer.sh"
# }}}
# }}}
