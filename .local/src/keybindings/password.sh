#!/bin/bash
#
# Select a password to copy to the clipboard.
#
# References:
#     ${XDG_CONFIG_HOME}/niri/config.kdl
#
# Usage:
#     password [--username]
#
# Arguments:
#     --username - Copy the username instead.

# Define global variables.
declare -gr USERNAME_FLAG="--username"
declare -gir PASSWORD_LINE_NUMBER=1
declare -gir USERNAME_LINE_NUMBER=2

main() {
    local -r flag="${1}"
    if [[ -z "${flag}" ]]; then
        local -r hasUsernameFlag="false"
    elif  [[ "${flag}" == "${USERNAME_FLAG}" ]]; then
        local -r hasUsernameFlag="true"
    else
        echoError "ERROR: Invalid flag \"${flag}\""
        exit 1
    fi

    clearClipboard
    copyPassword "${hasUsernameFlag}"
}

clearClipboard() {
    wl-copy --clear
}

copyPassword() {
    local -r hasUsernameFlag="${1}"

    local -r selection="$(selectPassword "${hasUsernameFlag}")"
    pass show --clip="$(getLineNumber "${hasUsernameFlag}")" "${selection}"
}

selectPassword() {
    local -r hasUsernameFlag="${1}"

    mapfile -t passwords < <(find "${PASSWORD_STORE_DIR}" -name "*.gpg" -type f)
    passwords=( "${passwords[@]#"${PASSWORD_STORE_DIR}"/}" )
    passwords=( "${passwords[@]%.gpg}" )
    printf "%s\n" "${passwords[@]}" | sort | fuzzel --dmenu --placeholder \
            "$(getPlaceholder "${hasUsernameFlag}")"
}

getLineNumber() {
    local -r hasUsernameFlag="${1}"

    if [[ "${hasUsernameFlag}" == "true" ]]; then
        echo "${USERNAME_LINE_NUMBER}"
    else
        echo "${PASSWORD_LINE_NUMBER}"
    fi
}

getPlaceholder() {
    local -r hasUsernameFlag="${1}"

    if [[ "${hasUsernameFlag}" == "true" ]]; then
        echo "Username"
    else
        echo "Password"
    fi
}

echoError() {
    local -r errorMessage="${1}"
    echo -e "${errorMessage}" 1>&2
}

main "${@}"
