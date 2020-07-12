# $HOME/.profile
# !/bin/sh

# Local path
if [ "${UID}" -ge 1000 ] && [ -d "${HOME}/.local/bin" ] && [ -z "$(echo "${PATH}" | grep -o "${HOME}/.local/bin")" ]; then
    export PATH="${PATH}:${HOME}/.local/bin"
fi

# Default programs
export BROWSER="firefox"
export EDITOR="nvim"
export TERMINAL="st"
export VISUAL="nvim"

# XDG base directory
export XDG_CONFIG_HOME="${HOME}/.config"
export XDG_CACHE_HOME="${HOME}/.cache"
export XDG_DATA_HOME="${HOME}/.local/share"

export HISTFILE="${XDG_DATA_HOME}/bash/history"
export INPUTRC="$XDG_CONFIG_HOME/readline/inputrc"
export XAUTHORITY="${XDG_RUNTIME_DIR}/Xauthority"
export XINITRC="${XDG_CONFIG_HOME}/X11/xinitrc"

export LESSHISTFILE=-                                   # Disable less history file

# Start Xorg
if systemctl -q is-active graphical.target && [ ! "${DISPLAY}" ] && [ "${XDG_VTNR}" -eq 1 ]; then
    exec startx "${XDG_CONFIG_HOME}/X11/xinitrc"
fi
