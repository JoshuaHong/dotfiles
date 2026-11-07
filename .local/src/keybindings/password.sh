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
declare -gir USERNAME_LINE_NUMBER=1
declare -gir PASSWORD_LINE_NUMBER=2

main() {
    local -r usernameFlag="${1}"
    if [[ "${usernameFlag}" == "${USERNAME_FLAG}" ]]; then
        local -r hasUsernameFlag="true"
    elif  [[ -z "${usernameFlag}" ]]; then
        local -r hasUsernameFlag="false"
    else
        echoError "ERROR: Invalid parameter \"${usernameFlag}\""
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

    local -r selection="$(selectPassword)"
    pass show --clip="$(getLineNumber "${hasUsernameFlag}")" "${selection}"
}

selectPassword() {
    mapfile -t passwords < <(find "${PASSWORD_STORE_DIR}" -name "*.gpg" -type f)
    passwords=( "${passwords[@]#"${PASSWORD_STORE_DIR}"/}" )
    passwords=( "${passwords[@]%.gpg}" )
    printf "%s\n" "${passwords[@]}" | sort | fuzzel --dmenu
}

getLineNumber() {
    local -r hasUsernameFlag="${1}"

    if [[ "${hasUsernameFlag}" == "true" ]]; then
        echo "${USERNAME_LINE_NUMBER}"
    else
        echo "${PASSWORD_LINE_NUMBER}"
    fi
}

echoError() {
    local -r errorMessage="${1}"
    echo -e "${errorMessage}" 1>&2
}

main "${@}"
