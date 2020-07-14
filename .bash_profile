# $HOME/.bash_profile

# !/bin/bash

function main() {
    sourceProfile
    sourceBashrc
}

function sourceProfile() {
    local profile="${HOME}/.profile"
    if [[ -f "${profile}" ]]; then
        . "${profile}"
    fi
}

function sourceBashrc() {
    local bashrc="${HOME}/.bashrc"
    if [[ -f "${bashrc}" ]]; then
        . "${bashrc}"
    fi
}

main
