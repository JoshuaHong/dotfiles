#!/bin/bash

# The personal initialization file, sources files for login shells

main() {
    sourceProfile
    sourceBashrc
}

sourceProfile() {
    local profile="${HOME}/.profile"
    if fileExists "${profile}"; then
        source "${profile}"
    fi
}

sourceBashrc() {
    local bashrc="${HOME}/.bashrc"
    if fileExists "${bashrc}"; then
        source "${bashrc}"
    fi
}

fileExists() {
    local file="${1}"
    [[ -f "${file}" ]]
}

main
