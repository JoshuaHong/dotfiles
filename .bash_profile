# $HOME/.bash_profile

# !/bin/bash

profile="${HOME}/.profile"
bashrc="${HOME}/.bashrc"

# Source profile if exists
if [[ -f "${profile}" ]]; then
    . "${profile}"
fi

# Source bashrc if exists
if [[ -f "${bashrc}" ]]; then
    . "${bashrc}"
fi
