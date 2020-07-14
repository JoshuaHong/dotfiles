# $HOME/.bashrc

# !/bin/bash

function main() {
    # If not running interactively, don't do anything
    if [[ "${-}" != *i* ]]; then
        return
    fi

    setAliases
    setPrimaryPrompt
}

function setAliases() {
    alias ls="ls --color=auto"  # ls with color
}

function setPrimaryPrompt() {
    PS1='[\u@\h \W]\$ '
}

main
