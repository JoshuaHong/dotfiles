#!/bin/sh
#
# The script executed when a Bourne shell is invoked as an interactive login
# shell.
# Contains commands to set up the Bourne shell environment.

main() {
    exportLocalPath
    exportPrograms
    exportFiles
    exportVariables
    startWayland
}

exportLocalPath() {
    localPath="${HOME}/.local/bin"
    if isValidPath "${localPath}"; then
        export PATH="${PATH}:${localPath}"
    fi
}

exportPrograms() {
    export BROWSER="/usr/bin/mullvad-browser"
    export DIFFPROG="/usr/bin/nvim -d"
    export EDITOR="/usr/bin/nvim"
    export PAGER="/usr/bin/less"
    export VISUAL="/usr/bin/nvim"
}

exportFiles() {
    exportXDGBaseDirectories
    exportXDGFiles
}

exportXDGBaseDirectories() {
    export XDG_CACHE_HOME="${HOME}/.cache"
    export XDG_CONFIG_DIRS="/etc/xdg"
    export XDG_CONFIG_HOME="${HOME}/.config"
    export XDG_DATA_DIRS="/usr/local/share:/usr/share"
    export XDG_DATA_HOME="${HOME}/.local/share"
    export XDG_STATE_HOME="${HOME}/.local/state"
    exportXDGRuntimeDir
}

exportXDGRuntimeDir() {
    if isStringNull "${XDG_RUNTIME_DIR}"; then
        export XDG_RUNTIME_DIR="/tmp/${UID}-runtime-dir"
        createXDGRuntimeDir
    fi
}

createXDGRuntimeDir() {
    if ! isDirectory "${XDG_RUNTIME_DIR}"; then
        mkdir "${XDG_RUNTIME_DIR}"
        chmod 0700 "${XDG_RUNTIME_DIR}"
    fi
}

exportXDGFiles() {
    export GNUPGHOME="${XDG_DATA_HOME}/gnupg"
    export HISTFILE="${XDG_STATE_HOME}/bash/history"
    export INPUTRC="${XDG_CONFIG_HOME}/readline/inputrc"
    export PASSWORD_STORE_DIR="${XDG_DATA_HOME}/pass"
}

exportVariables() {
    # Erase previous duplicates from the Bash history file.
    export HISTCONTROL="erasedups"
    # Don't truncate the Bash history file.
    export HISTFILESIZE=-1
    # Save all commands in the Bash history file without limit.
    export HISTSIZE=-1
    # Disable the less history file.
    export LESSHISTFILE="-"
    # Use Fuzzel to enter sudo passwords using `sudo --askpass`.
    export SUDO_ASKPASS="${HOME}/.local/bin/fuzzel-sudo"
    # Enable Korean input method with Fcifx.
    export XMODIFIERS="@im=fcitx"
}

startWayland() {
    niri-session -l > /dev/null 2>&1
}

isValidPath() {
    directory="${1}"
    isDirectory "${directory}" && ! isDirectoryInPath "${directory}"
}

isDirectory() {
    directory="${1}"
    [ -d "${directory}" ]
}

isDirectoryInPath() {
    directory="${1}"
    echo "${PATH}" | grep --quiet "${directory}"
}

isStringNull() {
    string="${1}"
    [ -z "${string}" ]
}

main
