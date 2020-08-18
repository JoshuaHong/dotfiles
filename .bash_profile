#!/bin/bash
#
# The personal initialization file, sources files for login shells.

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
