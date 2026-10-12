#!/bin/bash
#
# Select a password.
#
# References:
#     ${XDG_CONFIG_HOME}/niri/config.kdl
#
# Usage:
#     password

declare -gr CLIPBOARD_DELAY_SECS=45

main() {
    local -r clipboard="$(getClipboard)"
    clearClipboard
    copyPassword
    restoreClipboard "${clipboard}"
}

getClipboard() {
    wl-paste
}

clearClipboard() {
    wl-copy --clear
}

copyPassword() {
    local -r selection="$(selectPassword)"
    pass show --clip "${selection}"
}

restoreClipboard() {
    local -r clipboard="${1}"

    sleep "${CLIPBOARD_DELAY_SECS}"
    wl-copy "${clipboard}"
}

selectPassword() {
    mapfile -t passwords < <(find "${PASSWORD_STORE_DIR}" -name "*.gpg" -type f)
    passwords=( "${passwords[@]#"${PASSWORD_STORE_DIR}"/}" )
    passwords=( "${passwords[@]%.gpg}" )
    printf "%s\n" "${passwords[@]}" | sort | fuzzel --dmenu
}

main "${@}"
