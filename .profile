#!/usr/bin/sh
#
# The script executed when a Bourne shell is invoked as an interactive login
# shell.
# Contains commands to set up the Bourne shell environment.

main() {
  exportLocalPath
  exportPrograms
  exportXDGBaseDirectories
  exportBashVariables
  startWayland
}

exportLocalPath() {
  directory="${HOME}/.local/bin"
  if isValidPath "${directory}"; then
      export PATH="${PATH}:${directory}"
  fi
}

exportPrograms() {
  export EDITOR="/usr/bin/nvim"
  export PAGER="/usr/bin/less"
  export VISUAL="/usr/bin/nvim"
}

exportXDGBaseDirectories() {
  export XDG_CACHE_HOME="${HOME}/.cache"
  export XDG_CONFIG_DIRS="/etc/xdg"
  export XDG_CONFIG_HOME="${HOME}/.config"
  export XDG_DATA_DIRS="/usr/local/share:/usr/share"
  export XDG_DATA_HOME="${HOME}/.local/share"
  export XDG_STATE_HOME="${HOME}/.local/state"
}

exportBashVariables() {
  # Erase previous duplicates from the Bash history file.
  export HISTCONTROL=erasedups
  # Set the Bash history file path.
  export HISTFILE="${XDG_STATE_HOME}/bash/history"
  # Don't truncate the Bash history file.
  export HISTFILESIZE=-1
  # Save all commands in the Bash history file without limit.
  export HISTSIZE=-1
  # Set the inputrc file path.
  export INPUTRC="${XDG_CONFIG_HOME}/readline/inputrc"
}

startWayland() {
  if canStartWayland; then
      exec Hyprland
  fi
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

canStartWayland() {
  isGraphicalTargetActive && ! displayExists && isVirtualTerminalNumber 1
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
