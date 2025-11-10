#!/bin/bash
#
# Select a password.
#
# References:
#     ${XDG_CONFIG_HOME}/niri/config.kdl
#
# Usage:
#     password

main() {
    local -a passwords=( "${PASSWORD_STORE_DIR}"**/*.gpg )
    passwords=( "${passwords[@]#"${PASSWORD_STORE_DIR}"/}" )
    passwords=( "${passwords[@]%.gpg}" )
    local -r password="$(printf '%s\n' "${passwords[@]}" | fuzzel --dmenu "${@}")"
    pass show --clip "${password}"
}

main "${@}"
