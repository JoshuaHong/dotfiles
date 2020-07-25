# $HOME/.bashrc

# !/bin/bash

function main() {
    # If not running interactively, don't do anything
    if [[ "${-}" != *i* ]]; then
        return
    fi

    setAliases
    setPrimaryPrompt
    setShopt
}

function setAliases() {
    alias cp="cp -ir"             # cp recursively, confirm if overriding
    alias diff="diff --color"     # diff with color
    alias grep="grep --color"     # grep with color
    alias ln="ln -i"              # ln confirm if overriding
    alias ls="ls --color=auto"    # ls with color
    alias mkdir="mkdir -p"        # mkdir recursively
    alias mv="mv -i"              # mv confirm if overriding

    alias ga="git add"
    alias gaa="git add --all"
    alias gb="git branch"
    alias gcm="git commit"
    alias gcl="git clone"
    alias gco="git checkout"
    alias gcob="git checkout -b"
    alias gcom="git checkout master"
    alias gcod="git checkout develop"
    alias gd="git diff"
    alias gdh="git diff HEAD"
    alias gl="git log --all --decorate --graph --oneline --date=short --pretty=format:'%C(yellow)%h%Creset%C(red)%C(bold)%d%Creset%C(white)(%cd)%Creset %s'"
    alias gm="git merge"
    alias gpl="git pull"
    alias gps="git push"
    alias grb="git rebase"
    alias grs="git reset"
    alias gs="git status"
    alias gst="git stash"
    alias gstp="git stash pop"

    # Cd and ls, and cd to a parent directory for every "."
    function cd() {
        local dir="$1"
        if [[ "$dir" =~ ^(\.)+$ ]]; then
            local MYOLDPWD="$PWD"
            for ((i=1; i<"${#dir}"; ++i)); do
                command cd "../"
            done
            OLDPWD="$MYOLDPWD"
            pwd
        else
            command cd "$@"
        fi
        ls --color=auto
    }
}

function setPrimaryPrompt() {
    function gitbranch() {
        git branch 2> /dev/null | sed -e "/^[^*]/d" -e "s/* \(.*\)/ (\1)/"
    }
    local red="\[\e[31m\]"
    local green="\[\e[32m\]"
    local yellow="\[\e[33m\]"
    local blue="\[\e[34m\]"
    local magenta="\[\e[35m\]"
    local cyan="\[\e[36m\]"
    local lightBlue="\[\e[94m\]"
    local reset="\[\e[m\]"
    local lbrace="${red}["
    local username="${yellow}\u"
    local at="${green}@"
    local hostname="${blue}\h"
    local pwd="${lightBlue}\W"
    local branch="${magenta}\$(gitbranch)"
    local rbrace="${red}]"
    local dollar="${cyan}$"
    local space=" "
    PS1="${lbrace}${username}${at}${hostname}${space}${pwd}${branch}${rbrace}${dollar}${space}${reset}"
}

function setShopt() {
    shopt -s autocd          # cd when entering a path without the cd command
    shopt -s cdspell         # cd automatically fixes minor spelling errors
    shopt -s checkwinsize    # Update LINES and COLUMNS after each command
    shopt -s cmdhist         # Save multiline commands as a single history entry
    shopt -s dirspell        # Fix directory spelling errors on word completion
    shopt -s dotglob         # Include hidden files in pathname expansion
    shopt -s globstar        # Context match "**" pattern
    shopt -s histappend      # Append history rather than overriding the file
}

main
