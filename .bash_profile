#!/bin/bash
#
# The script executed when Bash is invoked as an interactive login shell.
# Contains commands to set up the Bash environment.

main() {
    sourceProfile
    sourceBashrc
}

sourceProfile() {
    local profile="${HOME}/.profile"
    if isRegularFile "${profile}"; then
        source "${profile}"
    fi
}

sourceBashrc() {
    local bashrc="${HOME}/.bashrc"
    if isRegularFile "${bashrc}"; then
        source "${bashrc}"
    fi
}

isRegularFile() {
    local file="${1}"
    [[ -f "${file}" ]]
}

main
