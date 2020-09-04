#!/bin/bash
#
# The individual per-interactive-shell startup file.

main() {
    if ! isRunningInteractively; then
        return
    fi

    setAliases
    setSettings
    setPrompts
    removeHistoryFileDuplicates
}

isRunningInteractively() {
    tty --quiet
}

setAliases() {
    setLinuxAliases
    setGitAliases
}

setLinuxAliases() {
    alias cp="cp --interactive --recursive"
    alias diff="diff --color=auto"
    alias grep="grep --color=auto"
    alias less='less --RAW-CONTROL-CHARS'
    alias ln="ln --interactive"
    alias ls="ls --color=auto"
    alias mkdir="mkdir --parents"
    alias mv="mv --interactive"
    alias rm="rm --interactive=once"

    # ls after cd, and cd to a parent directory for every additional "."
    cd() {
        local directory="${1}"
        if containsOnlyOneOrMoreDots "${directory}"; then
            cdToParentDirectory "${directory}"
        else
            command cd "$@"
        fi
        ls --color="auto"
    }

    containsOnlyOneOrMoreDots() {
        local directory="${1}"
        [[ "$directory" =~ ^(\.)+$ ]]
    }

    cdToParentDirectory() {
        local directory="${1}"
        local initialPWD="${PWD}"
        for ((i=1; i<"$(getLength "${directory}")"; ++i)); do
            command cd "../"
        done
        setOLDPWD "${initialPWD}"
        pwd
    }

    getLength() {
        local variable="${1}"
        echo "${#variable}"
    }

    setOLDPWD() {
        local initialPWD="${1}"
        OLDPWD="${initialPWD}"
    }
}

setGitAliases() {
    alias ga="git add"
    alias gaa="git add --all"
    alias gb="git branch"
    alias gbD="git branch --delete --force"
    alias gcm="git commit"
    alias gcl="git clone"
    alias gco="git checkout"
    alias gcob="git checkout -b"
    alias gcom="git checkout master"
    alias gcod="git checkout develop"
    alias gd="git diff"
    alias gdh="git diff HEAD"
    alias gf="git fetch"
    alias gl="git log --all --decorate --graph --oneline --date=short --pretty=format:'%C(yellow)%h%Creset%C(red)%C(bold)%d%Creset%C(white) (%cd)%Creset %s'"
    alias gm="git merge"
    alias gpl="git pull --ff-only"
    alias gps="git push"
    alias grb="git rebase"
    alias grs="git reset"
    alias grsh="git reset --hard"
    alias gs="git status"
    alias gst="git stash"
    alias gstp="git stash pop"
}

setSettings() {
    setShopts
    setTerminal
}

setShopts() {
    shopt -s autocd          # cd when entering a path without the cd command
    shopt -s cdspell         # cd automatically fixes minor spelling errors
    shopt -s checkwinsize    # Update LINES and COLUMNS after each command
    shopt -s cmdhist         # Save multiline commands as a single history entry
    shopt -s dirspell        # Fix directory spelling errors on word completion
    shopt -s direxpand       # Along with dirspell to expand on word completion
    shopt -s dotglob         # Include hidden files in pathname expansion
    shopt -s histappend      # Append history rather than overriding the file
}

setTerminal() {
    stty -ixon               # Disable XON/XOFF flow control
}

setPrompts() {
    function getGitBranch() {
        git branch 2> /dev/null | sed -e "/^[^*]/d" -e "s/* \(.*\)/ (\1)/"
    }
    local red="\[\e[31m\]"
    local green="\[\e[32m\]"
    local yellow="\[\e[33m\]"
    local blue="\[\e[34m\]"
    local magenta="\[\e[35m\]"
    local cyan="\[\e[36m\]"
    local lightYellow="\[\e[93m\]"
    local reset="\[\e[m\]"
    local lbrace="${red}["
    local username="${yellow}\u"
    local at="${lightYellow}@"
    local hostname="${green}\h"
    local pwd="${blue}\W"
    local branch="${magenta}\$(getGitBranch)"
    local rbrace="${red}]"
    local dollar="${cyan}$"
    local space=" "
    PS1="${lbrace}${username}${at}${hostname}${space}${pwd}${branch}${rbrace}${dollar}${space}${reset}"
}

removeHistoryFileDuplicates() {
    echo "$(tac "${HISTFILE}" | awk '!x[$0]++' | tac)" > "${HISTFILE}"
}

main
