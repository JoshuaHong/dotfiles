#!/bin/bash
#
# Update packages.
#
# Usage: update [options].
#
# Dependencies: [checkupdates, paru].

set -o errexit
set -o nounset
set -o pipefail

# Constants.
declare -agr DEPENDENCIES=("checkupdates" "paru")
declare -gr SIGNAL="SIGRTMIN+1"
declare -gr BAR="waybar"

# Command-line arguments.
declare -g c="false"
declare -g l="false"

main() {
  assertDependencies
  parseArguments "${@}"
  run
}

# Assert that the dependencies exist.
assertDependencies() {
  for dependency in "${DEPENDENCIES[@]}"; do
    if ! programExists "${dependency}"; then
      echoError "Error: Missing dependency\"${dependency}\"."
      printUsageMessage
      exit 1
    fi
  done
}

# Parse the command-line arguments.
parseArguments() {
  parseOptions "${@}"
  local numArgs="$(("${#}" - "${OPTIND}" + 1))"
  if [[ "${numArgs}" -gt 0 ]]; then
    echoError "Error: Invalid number of arguments."
    printUsageMessage
    exit 1
  fi
}

# Begin the program execution.
run() {
  if [[ "${c}" == "true" ]]; then
    printNumUpdates
  elif [[ "${l}" == "true" ]]; then
    printUpdates
  else
    update
    refreshBar
  fi
}

# Print the number of updates available.
printNumUpdates() {
  local updates="$(checkupdates)"
  if isVariableEmpty "${updates}"; then
    exit 0
  fi
  local numUpdates="$(echo "${updates}" | wc -l)"
  echo " ${numUpdates}"
}

# Print the updates available.
printUpdates() {
  local updates="$(checkupdates)"
  if isVariableEmpty "${updates}"; then
    exit 0
  fi
  echo "${updates}"
}

# Update packages and notify of any .pacnew or .pacsave files.
update() {
  paru -Syu
  local pacnewPacsaveFiles="$(find /etc -regextype posix-extended \
      -regex ".+\.pac(new|save)" 2> /dev/null)"
  if ! isVariableEmpty "${pacnewPacsaveFiles}"; then
    echo -e "\nFix the following .pacnew and .pacsave files:"
    echo "${pacnewPacsaveFiles}"
  fi
}

# Send a signal to refresh the bar.
refreshBar() {
  pkill -"${SIGNAL}" "${BAR}"
}

# Parse the command-line options.
parseOptions() {
  while getopts ":chl" flag; do
    case "${flag}" in
      c)
        c="true"
        ;;
      h)
        printHelpMessage
        exit 0
        ;;
      l)
        l="true"
        ;;
      *)
        echoError "Error: Invalid option."
        printUsageMessage
        exit 1
        ;;
    esac
  done
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

# Print the error message to standard output.
echoError() {
  local errorMessage="${*}"
  echo -e "${errorMessage}" 1>&2
}

# Return true if the program exists, false otherwise.
programExists() {
  local program="${1}"
  command -v "${program}" > /dev/null 2>&1
}

# Return true if the variable is empty, false otherwise.
isVariableEmpty() {
  local variable="${1}"
  [[ -z "${variable}" ]]
}

main "${@}"
