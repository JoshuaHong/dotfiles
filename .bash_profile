#!/bin/bash
#
# The profile script executed when Bash is invoked as an interactive login
# shell.
# Contains commands that should only be called once to set up the environment.

main() {
    sourceProfile
    sourceBashrc
}

sourceProfile() {
    local profile="${HOME}/.profile"
    if regularFileExists "${profile}"; then
        source "${profile}"
    fi
}

sourceBashrc() {
    local bashrc="${HOME}/.bashrc"
    if regularFileExists "${bashrc}"; then
        source "${bashrc}"
    fi
}

regularFileExists() {
    local file="${1}"
    [[ -f "${file}" ]]
}

main
