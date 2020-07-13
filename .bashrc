# $HOME/.bashrc

# !/bin/bash

# If not running interactively, don't do anything
if [[ "${-}" != *i* ]]; then
    return
fi

# Aliases
alias ls="ls --color=auto"  # ls with color

# Primary Prompt
PS1='[\u@\h \W]\$ '
