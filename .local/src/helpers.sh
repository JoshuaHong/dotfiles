#!/bin/bash
#
# Helper functions for scripts.
#
# Usage: source helpers.sh

# Set the Bash options.
setBashOptions() {
  set -o errexit
  set -o noclobber
  set -o nounset
  set -o pipefail
}

# Assert that the dependencies exist.
# Parameters:
#   dependencies (array[string]): The array of dependencies.
assertDependenciesExist() {
  local -ar dependencies=("${@}")
  local -a missingDependencies=()
  for dependency in "${dependencies[@]}"; do
    if ! isInstalled "${dependency}"; then
      missingDependencies+=("\"${dependency}\"")
    fi
  done
  if ! isVariableEmpty missingDependencies; then
    echoError "Error: Missing dependencies: [${missingDependencies[*]}]"
    printUsageMessage
    exit 1
  fi
}

# Parse the command-line options.
# Parameters:
#   options (variable): The variable of an array to be populated with the
#       parsed command-line options.
#   optString (string): The OPTSTRING to use for getopts.
#   arguments (array[string]): The array of arguments to the program.
parseOptions() {
  local -n optionsRef="${1}"
  local -r optString="${2}"
  shift 2
  while getopts ":h-:${optString}" flag; do
    case "${flag}" in
      -)
        if isVariableSet OPTARG && [[ "${OPTARG}" == "help" ]]; then
          printHelpMessage
          exit 0
        else
          echoError "Error: Invalid option \"--${OPTARG}\"."
          printUsageMessage
          exit 1
        fi
        ;;
      h)
        printHelpMessage
        exit 0
        ;;
      [a-z])
        if ! isVariableSet OPTARG; then
          optionsRef["${flag}"]="true"
        else
          optionsRef["${flag}"]="${OPTARG}"
        fi
        ;;
      *)
        echoError "Error: Invalid option \"-${OPTARG}\"."
        printUsageMessage
        exit 1
        ;;
    esac
  done
}

# Parse the command-line operands.
# Parameters:
#   operands (variable): The variable of an array to be populated with the
#       parsed command-line operands.
#   maxNumOperands (integer): The maximum number of operands to the program.
#       If less than 0, the maximum number of operands is unbounded.
#   minNumOperands (integer): The minimum number of operands to the program.
#   arguments (array[string]): The array of arguments to the program.
parseOperands() {
  local -n operandsRef="${1}"
  local -ir maxNumOperands="${2}"
  local -ir minNumOperands="${3}"
  shift "$(( "${OPTIND}" + 2 ))"
  local -ir numOperands="${#@}"
  if [[ "${numOperands}" -gt "${maxNumOperands}" && "${maxNumOperands}" -ge 0 \
	|| "${numOperands}" -lt "${minNumOperands}" ]]; then
    echoError "Error: Invalid number of operands."
    printUsageMessage
    exit 1
  fi
  operandsRef=("${@}")
}

# Return true if confirmed, false otherwise.
# Parameters:
#   warning (string): The warning message to print before the confirmation.
confirm() {
  local -r warning="${1}"
  while true; do
    echoError "${warning}"
    read -p "Confirm (y/n)? " confirmation
    if [[ "${confirmation}" == "y" || "${confirmation}" == "n" ]]; then
      break
    fi
  done
  [[ "${confirmation}" == "y" ]]
}

# Print the error message to standard error.
# Parameters:
#   errorMessage (string): The error message to print to standard error.
echoError() {
  local -r errorMessage="${1}"
  echo -e "${errorMessage}" 1>&2
}

# Return true if the variable is set, false otherwise.
# Parameters:
#   variable (variable): The variable to test if it is set.
isVariableSet() {
  local -n variableRef="${1}"
  [[ -n "${variableRef+x}" ]]
}

# Return true if the variable is empty or unset, false otherwise.
# Parameters:
#   variable (variable): The variable to test if it is empty.
isVariableEmpty() {
  local -n variableRef="${1}"
  [[ -z "${variableRef[@]}" ]]
}

# Return true if the program is installed, false otherwise.
# Parameters:
#   program (string): The name of the program to test if it is installed.
isInstalled() {
  local -r program="${1}"
  command -v "${program}" > /dev/null 2>&1
}

# Return true if the string is a directory, false otherwise.
# Parameters:
#   directory (string): The name of the string to test if it is a directory.
isDirectory() {
  local -r directory="${1}"
  [[ -d "${directory}" ]]
}

# Return true if the string is a regular file, false otherwise.
# Parameters:
#   file (string): The name of the string to test if it is a regular file.
isRegularFile() {
  local -r file="${1}"
  [[ -f "${file}" ]]
}

# Assert that the directory exists.
# Parameters:
#   directory (string): The name of the directory to check if it exists.
assertDirectoryExists() {
  local -r directory="${1}"
  if ! isDirectory "${directory}"; then
    echoError "Error: Directory \"${directory}\" does not exist."
    exit 1
  fi
}

# Assert that the directory does not exist.
# Parameters:
#   directory (string): The name of the directory to check if it exists.
assertDirectoryNotExists() {
  local -r directory="${1}"
  if isDirectory "${directory}"; then
    echoError "Error: Directory \"${directory}\" already exists."
    exit 1
  fi
}

# Assert that the regular file exists.
# Parameters:
#   file (string): The name of the regular file to check if it exists.
assertRegularFileExists() {
  local -r file="${1}"
  if ! isRegularFile "${file}"; then
    echoError "Error: Regular file \"${file}\" does not exist."
    exit 1
  fi
}

# Assert that the regular file does not exist.
# Parameters:
#   file (string): The name of the regular file to check if it exists.
assertRegularFileNotExists() {
  local -r file="${1}"
  if isRegularFile "${file}"; then
    echoError "Error: Regular file \"${file}\" already exists."
    exit 1
  fi
}

# Print the help message.
printHelpMessage() {
  echoError "Error: Missing implementation of \"printHelpMessage\"."
  exit 1
}

# Print the usage message.
printUsageMessage() {
  echoError "Error: Missing implementation of \"printUsageMessage\"."
  exit 1
}
