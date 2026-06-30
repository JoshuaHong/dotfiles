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
    local -r selection="$(selectPassword)"
    pass show --clip "${selection}"
}

selectPassword() {
    mapfile -t passwords < <(find "${PASSWORD_STORE_DIR}" -name "*.gpg" -type f)
    passwords=( "${passwords[@]#"${PASSWORD_STORE_DIR}"/}" )
    passwords=( "${passwords[@]%.gpg}" )
    printf "%s\n" "${passwords[@]}" | sort | fuzzel --dmenu
}

main "${@}"
