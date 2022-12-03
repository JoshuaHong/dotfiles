#!/usr/bin/bash
#
# The script executed when Bash is invoked as an interactive login shell.
# Contains commands to set up the Bash environment.

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
