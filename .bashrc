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
    PS1="\[\e[31m\][\[\e[m\]\[\e[33m\]\u\[\e[m\]\[\e[32m\]@\[\e[m\]\[\e[34m\]\h\[\e[m\]\[\e[94m\] \W\[\e[35m\]\$(gitbranch)\[\e[m\]\[\e[m\]\[\e[31m\]]\[\e[m\]\[\e[36m\]$\[\e[m\]\[\e[39m\] "
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
