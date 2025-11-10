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

    if $(hasCachedPassword); then
        pass show --clip "${password}"
    else
        foot pass show --clip "${password}"
    fi
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
    echo "test" | gpg --pinentry-mode error --sign -o /dev/null
}

main "${@}"
