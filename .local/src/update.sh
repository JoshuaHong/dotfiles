#!/bin/bash
#
# Update packages.
#
# Usage: update [options].
#
# Dependencies: [checkupdates, paru].

# Imports.
source "/home/josh/.local/src/helpers.sh"

# Constants.
declare -agr DEPENDENCIES=("checkupdates" "paru")
declare -gr OPTSTRING="cl"
declare -gir MAX_NUM_ARGUMENTS=0
declare -gr BAR="waybar"
declare -gr SIGNAL="SIGRTMIN+1"

# Variables.
declare -Ag options=()
declare -ag operands=()

# Set-up for the script.
# Parameters:
#   arguments (array[string]): The array of arguments to the program.
setUp() {
  local -ag arguments=("${@}")
  setBashOptions
  assertDependenciesExist "${DEPENDENCIES[@]}"
  parseOptions "${OPTSTRING}" options "${arguments[@]}"
  parseOperands "${MAX_NUM_ARGUMENTS}" operands "${arguments[@]}"
}

# Main function of the script.
main() {
  if isVariableSet options["c"]; then
    printNumUpdates
  elif isVariableSet options["l"]; then
    printUpdates
  else
    update
    refreshBar
  fi
}

# Print the number of updates available.
printNumUpdates() {
  local -r updates="$(checkupdates)"
  if isVariableEmpty updates; then
    exit 0
  fi
  local numUpdates="$(echo "${updates}" | wc -l)"
  echo "${numUpdates}"
}

# Print the updates available.
printUpdates() {
  local -r updates="$(checkupdates)"
  if isVariableEmpty updates; then
    exit 0
  fi
  echo "${updates}"
}

# Update packages and notify of any .pacnew or .pacsave files.
update() {
  paru -Syu --removemake --cleanafter
  local -r pacnewPacsaveFiles="$(find /etc -regextype posix-extended \
      -regex ".+\.pac(new|save)" 2> /dev/null)"
  if isVariableSet pacnewPacsaveFiles; then
    echo -e "\nFix the following .pacnew and .pacsave files:"
    echo "${pacnewPacsaveFiles}"
  fi
}

# Send a signal to refresh the bar.
refreshBar() {
  pkill -"${SIGNAL}" "${BAR}"
}

# Print the help message.
printHelpMessage() {
  echo "Update - Update packages."
  echo -e "\nUsage: update [options]"
  echo -e "\nOptions:"
  echo -e "\t-c\t\tCount the number of available updates and exit."
  echo -e "\t-h\t\tPrint the help menu and exit."
  echo -e "\t-l\t\tList the available updates and exit."
  echo -e "\nDependencies:"
  echo -e "\tcheckupdates\tTo check for package updates."
  echo -e "\tparu\t\tTo update packages."
}

# Print the usage message.
printUsageMessage() {
  echo "Usage: update [options]"
  echo "Type \"update -h\" for more information."
}

setUp "${@}"
main
