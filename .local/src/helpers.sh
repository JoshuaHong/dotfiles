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
#   dependencies (array[string]): An array of dependencies.
assertDependenciesExist() {
  local -ar dependencies=("${@}")
  local -a missingDependencies=()
  for dependency in "${dependencies[@]}"; do
    if ! programExists "${dependency}"; then
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
#   optString (string): The OPTSTRING to use for getopts.
#   options (variable): The variable containing an array of options.
#   arguments (array[string]): The array of arguments to the program.
parseOptions() {
  local -r optString="${1}"
  local -n optionsRef="${2}"
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
#   maxNumArguments (integer): The maximum number of arguments to the program.
#     If less than 0, the maximum number of arguments is unbounded.
#   operands (variable): The variable containing an array of operands.
#   arguments (array[string]): The array of arguments to the program.
parseOperands() {
  local -ir maxNumArguments="${1}"
  local -n operandsRef="${2}"
  shift "$(( "${OPTIND}" + 1 ))"
  local -ir numOperands="${#@}"
  if [[ "${numOperands}" -gt "${maxNumArguments}" \
        && "${maxNumArguments}" -ge 0 ]]; then
    echoError "Error: Invalid number of arguments."
    printUsageMessage
    exit 1
  fi
  operandsRef=("${@}")
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
  [[ -z "${variableRef:+x}" ]]
}

# Return true if the program exists, false otherwise.
# Parameters:
#   program (string): The name of the program to test if it exists.
programExists() {
  local -r program="${1}"
  command -v "${program}" > /dev/null 2>&1
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
