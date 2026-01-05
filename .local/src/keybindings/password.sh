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
    local -r password="$(selectPassword)"

    if ! hasCachedPassword; then
        enterPassword "${password}"
    fi

    pass show --clip "${password}"
}

selectPassword() {
    local -a passwords
    parsePasswords passwords
    printf '%s\n' "${passwords[@]}" | fuzzel --dmenu "${@}"
}

parsePasswords() {
    local -n passwordFiles="${1}"
    passwordFiles=( "${PASSWORD_STORE_DIR}"**/*.gpg )
    passwordFiles=( "${passwords[@]#"${PASSWORD_STORE_DIR}"/}" )
    passwordFiles=( "${passwords[@]%.gpg}" )
}

hasCachedPassword() {
    echo | gpg --pinentry-mode error --sign > /dev/null 2>&1
}

enterPassword() {
    local -r password="${1}"
    foot pass show "${password}"
}

main "${@}"
