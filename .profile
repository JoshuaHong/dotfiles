#!/bin/sh
#
# The profile script executed when a Bourne shell is invoked as an interactive
# login shell.
# Contains commands that should only be called once to set up the environment.

main() {
    exportLocalPath
    exportPrograms
    exportXDGBaseDirectories
}

exportLocalPath() {
    directory="${HOME}/.local/share"
    if ! isValidPath "${directory}"; then
        return
    fi

    export PATH="${PATH}:${directory}"
}

exportPrograms() {
    export EDITOR="/usr/bin/nvim"
    export PAGER="/usr/bin/less"
    export VISUAL="/usr/bin/nvim"
}

exportXDGBaseDirectories() {
    # User directories
    export XDG_CACHE_HOME="${HOME}/.cache"
    export XDG_CONFIG_HOME="${HOME}/.config"
    export XDG_DATA_HOME="${HOME}/.local/share"
    export XDG_STATE_HOME="${HOME}/.local/state"

    # System directories
    export XDG_CONFIG_DIRS="/etc/xdg"
    export XDG_DATA_DIRS="/usr/local/share:/usr/share"

    # Programs
    mkdir -p "${XDG_STATE_HOME}/bash"
    export HISTFILE="${XDG_STATE_HOME}/bash/history"
}

isValidPath() {
    directory="${1}"
    directoryExists "${directory}" && ! isDirectoryInPath "${directory}"
}

directoryExists() {
    directory="${1}"
    [ -d "${directory}" ]
}

isDirectoryInPath() {
    directory="${1}"
    echo "${PATH}" | grep --quiet "${directory}"
}

main
