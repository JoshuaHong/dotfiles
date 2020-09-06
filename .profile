#!/bin/sh
#
# The personal initialization file, executed for login shells.

main() {
    exportVariables
    startXorg
}

exportVariables() {
    exportLocalPath
    exportPrograms
    exportXDGBaseDirectories
    exportConfigurations
}

exportLocalPath() {
    directory="${HOME}/.local/bin"
    if isValidPath "${directory}"; then
        export PATH="${PATH}:${directory}"
    fi
}

isValidPath() {
    directory="${1}"
    isValidUserId && directoryExists "${directory}" \
            && ! isDirectoryIncludedInPath "${directory}"
}

isValidUserId() {
    minimumUserId=1000
    [ "$(getUserId)" -ge "${minimumUserId}" ]
}

getUserId() {
    id --user
}

directoryExists() {
    directory="${1}"
    [ -d "${directory}" ]
}

isDirectoryIncludedInPath() {
    directory="${1}"
    echo "${PATH}" | grep --quiet "${directory}"
}

exportPrograms() {
    export BROWSER="firefox"
    export EDITOR="nvim"
    export TERMINAL="st"
    export VISUAL="nvim"
}

exportXDGBaseDirectories() {
    export XDG_CACHE_HOME="${HOME}/.cache"
    export XDG_CONFIG_HOME="${HOME}/.config"
    export XDG_DATA_HOME="${HOME}/.local/share"
    export HISTFILE="${XDG_DATA_HOME}/bash/history"
    export INPUTRC="${XDG_CONFIG_HOME}/readline/inputrc"
    export LESSKEY="${XDG_CONFIG_HOME}/less/lesskey"
    export XAUTHORITY="${XDG_RUNTIME_DIR}/Xauthority"
    export XINITRC="${XDG_CONFIG_HOME}/X11/xinitrc"
}

exportConfigurations() {
    export FZF_DEFAULT_COMMAND="rg --files --follow --no-heading --no-ignore --smart-case"
    export FZF_CTRL_T_COMMAND="${FZF_DEFAULT_COMMAND}"
    export FZF_CTRL_T_OPTS="--layout reverse --preview 'bat --style=numbers --color=always --line-range :500 {}'"
    export FZF_COMPLETION_OPTS="--layout reverse --preview 'bat --style=numbers --color=always --line-range :500 {}'"
    export FZF_DEFAULT_OPTS="--bind ctrl-n:backward-char,ctrl-i:up,ctrl-e:down,ctrl-o:forward-char,ctrl-a:beginning-of-line,ctrl-r:backward-word,ctrl-s:forward-word,ctrl-t:end-of-line,ctrl-u:preview-up,ctrl-d:preview-down --height 70% --border --color 'fg:#bbccdd,fg+:#ddeeff,bg:#334455,preview-bg:#223344,border:#778899'"
    export HISTCONTROL="erasedups:ignoreboth"    # Bash history ignores repeated
                                                 # or space beginning commands
    export LESSHISTFILE="-"                      # Disable the less history file
    export MANPAGER="sh -c 'col -bx | bat -l man -p'" # Color man pages with bat
}

startXorg() {
    xinitrc="${XDG_CONFIG_HOME}/X11/xinitrc"
    if canStartXorg; then
        exec startx "${xinitrc}"
    fi
}

canStartXorg() {
    isGraphicalTargetActive && ! displayExists && isVirtualTerminalNumber "1"
}

isGraphicalTargetActive() {
    systemctl --quiet is-active "graphical.target"
}

displayExists() {
    [ "${DISPLAY}" ]
}

isVirtualTerminalNumber() {
    number="${1}"
    [ "${XDG_VTNR}" -eq "${number}" ]
}

main
