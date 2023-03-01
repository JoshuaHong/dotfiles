#!/bin/bash
#
# Manage extended file attributes.
#
# Usage: xattr [options] file.
#
# Dependencies: [getfattr, setfattr].

# Imports.
source "/home/josh/.local/src/helpers.sh"

# Constants.
declare -agr DEPENDENCIES=("getfattr" "setfattr")
declare -gr OPTSTRING="a:d:e:g:lm"
declare -gir MAX_NUM_OPERANDS=1
declare -gir MIN_NUM_OPERANDS=1
declare -gr NAMESPACE="user"

# Variables.
declare -Ag options=()
declare -ag operands=()
declare -g file

# Set-up for the script.
# Parameters:
#   arguments (array[string]): The array of arguments to the program.
setUp() {
  local -ar arguments=("${@}")
  setBashOptions
  assertDependenciesExist "${DEPENDENCIES[@]}"
  parseOptions options "${OPTSTRING}" "${arguments[@]}"
  parseOperands operands "${MAX_NUM_OPERANDS}" "${MIN_NUM_OPERANDS}" \
      "${arguments[@]}"
  file="${operands[0]}"
  assertRegularFileExists "${file}"
}

# Main function of the script.
main() {
  if isVariableEmpty options; then
    printHelpMessage
  elif isVariableSet options["a"]; then
    addAttribute "${options["a"]}"
  elif isVariableSet options["d"]; then
    deleteAttribute "${options["d"]}"
  elif isVariableSet options["e"]; then
    editAttribute "${options["e"]}"
  elif isVariableSet options["g"]; then
    getAttribute "${options["g"]}"
  elif isVariableSet options["l"]; then
    listAttributes
  elif isVariableSet options["m"]; then
    setMediaAttributes
  fi
}

# Add an attribute.
# Parameters:
#   name (string): The name of the attribute to add.
addAttribute() {
  local -r name="${1}"
  if isAttribute "${name}" \
      && ! confirm "Warning: Attribute \"${name}\" will be overridden."; then
    return
  fi
  read -e -p "Enter the value: " value
  setfattr --name="${NAMESPACE}.${name}" --value="${value}" "${file}"
}

# Delete an attribute.
# Parameters:
#   name (string): The name of the attribute to delete.
deleteAttribute() {
  local -r name="${1}"
  if ! isAttribute "${name}"; then
    echoError "Error: Attribute \"${name}\" does not exist."
    return
  fi
  setfattr --remove="${NAMESPACE}.${name}" "${file}"
}

# Edit an attribute.
# Parameters:
#   name (string): The name of the attribute to edit.
editAttribute() {
  local -r name="${1}"
  if ! isAttribute "${name}"; then
    echoError "Error: Attribute \"${name}\" does not exist."
    return
  fi
  local -r previousValue="$(getfattr --name="${NAMESPACE}.${name}" \
      --only-values "${file}")"
  read -e -i "${previousValue}" -p "Enter the value: " value
  setfattr --name="${NAMESPACE}.${name}" --value="${value}" "${file}"
}

# Get an attribute.
# Parameters:
#   name (string): The name of the attribute to get.
getAttribute() {
  local -r name="${1}"
  if ! isAttribute "${name}"; then
    echoError "Error: Attribute \"${name}\" does not exist."
    return
  fi
  getfattr --name="${NAMESPACE}.${name}" --only-values "${file}"
  echo  # Needed because "--only-values" strips the trailing newline character.
}

# List all attributes.
listAttributes() {
  getfattr --dump "${file}"
}

# Set custom media attributes.
setMediaAttributes() {
  echo "Set the address attribute"
  addAttribute "address"
  echo -e "\nSet the datetime attribute"
  addAttribute "datetime"
  echo -e "\nSet the description attribute"
  addAttribute "description"
}

# Return true if the attribute already exists, false otherwise.
# Parameters:
#   name (string): The name of the attribute to check if it exists.
isAttribute() {
  local -r name="${1}"
  getfattr --name="${NAMESPACE}.${name}" "${file}" >/dev/null 2>&1
}

# Print the help message.
printHelpMessage() {
  echo "Xattr - Manage extended file attributes."
  echo -e "\nUsage: xattr [options] file"
  echo -e "\nOptions:"
  echo -e "\t-a name\t\tAdd an extended file attribute."
  echo -e "\t-d name\t\tDelete an extended file attribute."
  echo -e "\t-d name\t\tEdit an extended file attribute."
  echo -e "\t-g name\t\tGet an extended file attribute."
  echo -e "\t-l\t\tList all file attributes."
  echo -e "\t-m\t\tSet custom media extended file attributes."
  echo -e "\nDependencies:"
  echo -e "\tgetfattr\tTo get extended file attributes."
  echo -e "\tsetfattr\tTo set extended file attributes."
}

# Print the usage message.
printUsageMessage() {
  echo "Usage: xattr [options]"
  echo "Type \"xattr -h\" for more information."
}

setUp "${@}"
main
