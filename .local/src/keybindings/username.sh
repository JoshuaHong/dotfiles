#!/bin/bash
#
# Select a username.
#
# References:
#     ${XDG_CONFIG_HOME}/niri/config.kdl
#
# Usage:
#     username

# Define global variables.
declare -gir USERNAME_LINE_NUMBER=2

main() {
    clearClipboard
    copyPassword
}

clearClipboard() {
    wl-copy --clear
}

copyPassword() {
    local -r selection="$(selectPassword)"
    pass show --clip="${USERNAME_LINE_NUMBER}" "${selection}"
}

selectPassword() {
    mapfile -t passwords < <(find "${PASSWORD_STORE_DIR}" -name "*.gpg" -type f)
    passwords=( "${passwords[@]#"${PASSWORD_STORE_DIR}"/}" )
    passwords=( "${passwords[@]%.gpg}" )
    printf "%s\n" "${passwords[@]}" | sort | fuzzel --dmenu
}

main "${@}"
