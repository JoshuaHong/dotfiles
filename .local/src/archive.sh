#!/bin/bash
#
# Archive and encrypt files.
#
# Usage: archive [source destination].
#
# Dependencies: [find, gpg, mkdir, rm, rsync, tar].

# Imports.
source "/home/josh/.local/src/helpers.sh"

# Constants.
declare -agr DEPENDENCIES=("find" "gpg" "mkdir" "rm" "rsync" "tar")
declare -gr OPTSTRING="d:e:u"
declare -gir MAX_NUM_OPERANDS=2
declare -gir MIN_NUM_OPERANDS=0
declare -gr CIPHER_ALGORITHM="AES256"
declare -gr ENCRYPTED_SUFFIX=".tar.xz.gpg"
declare -gr COMPRESSED_SUFFIX=".tar.xz"
declare -gr NEW_SUFFIX=".new"

# Variables.
declare -Ag options=()
declare -ag operands=()
declare -g src=""
declare -g dest=""
declare -g password=""

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
}

# Set the operands.
setOperands() {
  if [[ "${#operands[@]}" -ne 2 ]]; then
    echoError "Error: Invalid number of operands."
    printUsageMessage
    exit 1
  fi
  src="${operands[0]%"/"}"  # Remove the trailing "/" if there is one.
  dest="${operands[1]%"/"}"  # Remove the trailing "/" if there is one.
  assertDirectoryExists "${src}"
  assertDirectoryExists "${dest}"
}

# Main function of the script.
main() {
  if isVariableSet options["d"]; then
    readPassword
    decrypt "${options["d"]}"
    unsetPasswords
    exit 0
  elif isVariableSet options["e"]; then
    readPassword
    encrypt "${options["e"]}"
    unsetPasswords
    exit 0
  fi
  setOperands
  if isVariableEmpty options; then
    archive
  elif isVariableSet options["u"]; then
    unarchive
  fi
}

# Archive and encrypt all files ending in "${ENCRYPTED_SUFFIX}".
archive() {
  readPassword
  local name="${src##*"/"}"  # Remove everything before the last "/".
  if isDirectory "${dest}/${name}" && ! isDirectoryEmpty "${dest}/${name}"; then
    if ! confirm "Warning: Directory \"${dest}/${name}\" will be overridden."; \
        then
      return
    fi
  fi
  readarray -t files \
      < <(find "${src}" -name "*${ENCRYPTED_SUFFIX}" -type "f" 2> /dev/null)
  files+=("${src}${ENCRYPTED_SUFFIX}")  # Also add the src archive itself.
  for file in "${files[@]}"; do
    local name="${file%"${ENCRYPTED_SUFFIX}"}"  # Remove the encrypted suffix.
    if shouldArchive "${name}"; then
      rm "${name}${ENCRYPTED_SUFFIX}"
      encrypt "${name}"
    fi
  done
  unsetPasswords
  rsync --archive --delete --include="*/" --include="*${ENCRYPTED_SUFFIX}" \
      --exclude="*" --prune-empty-dirs --xattrs "${src}" "${dest}"
  rsync --archive --delete --include="${src}${ENCRYPTED_SUFFIX}" --exclude="*" \
      --xattrs "${src}/../" "${dest}"  # Also copy the src archive itself.
}

# Decrypt and extract all files from the archive.
unarchive() {
  readPassword
  local -r name="${src##*"/"}"  # Remove everything before the last "/".
  if isDirectory "${dest}/${name}"; then
    if ! confirm "Warning: Directory \"${dest}/${name}\" will be overridden."; \
        then
      return
    fi
  fi
  rsync --archive --include="*/" --include="*${ENCRYPTED_SUFFIX}" \
      --exclude="*" --xattrs "${src}" "${dest}"
  rsync --archive --include="${name}${ENCRYPTED_SUFFIX}" --exclude="*" \
      --xattrs "${src}/../" "${dest}"  # Also copy the src archive itself.
  readarray -t files \
      < <(find "${dest}/${name}" -name "*${ENCRYPTED_SUFFIX}" -type "f" \
      2> /dev/null)
  for file in "${files[@]}"; do
    decrypt "${file}"
  done
  unsetPasswords
}

# Create an encrypted file of the directory.
# Parameters:
#   directory (string): The name of the directory to encrypt.
encrypt() {
  local -r directory="${1%"/"}"  # Remove the trailing "/" if there is one.
  local -r parent="${directory%"/"}/../"  # Add a trailing "/../".
  local -r name="${directory##*"/"}"  # Remove everything before the last "/".
  assertDirectoryExists "${directory}"
  assertRegularFileNotExists "${name}${ENCRYPTED_SUFFIX}"
  tar --create --directory "${parent}" \
      --file="${directory}${COMPRESSED_SUFFIX}" --xattrs --xattrs-include="*" \
      --xz "${name}"
  gpg --batch --cipher-algo "${CIPHER_ALGORITHM}" \
      --output "${directory}${ENCRYPTED_SUFFIX}" --passphrase "${password}" \
      --symmetric "${directory}${COMPRESSED_SUFFIX}"
  rm "${directory}${COMPRESSED_SUFFIX}"
}

# Decrypt and extract an encrypted file.
# Parameters:
#   file (string): The name of the file to decrypt.
decrypt() {
  local -r file="${1}"
  local -r name="${file%"${ENCRYPTED_SUFFIX}"}"  # Remove the encrypted suffix.
  local directory="${name}"
  assertRegularFileExists "${file}"
  if isDirectory "${name}"; then
    directory="${name}${NEW_SUFFIX}"
  fi
  if isDirectory "${directory}"; then
    if ! confirm "Warning: Directory \"${directory}\" will be overridden."; then
      return
    fi
  fi
  gpg --batch --decrypt --output "${name}${COMPRESSED_SUFFIX}" \
      --passphrase "${password}" --quiet "${name}${ENCRYPTED_SUFFIX}"
  mkdir --parents "${directory}"
  tar --directory="${directory}" --extract \
      --file="${name}${COMPRESSED_SUFFIX}" --strip-components=1 --xattrs \
      --xattrs-include="*" --xz
  rm "${name}${COMPRESSED_SUFFIX}"
}

# Read the password from user input.
readPassword() {
  read -p "Enter the password: " -s password
  echo
  read -p "Re-enter the password: " -s passwordReentry
  echo
  if [[ "${password}" != "${passwordReentry}" ]]; then
    echoError "Error: Passwords do not match."
    unsetPasswords
    exit 1
  fi
}

# Return true if the directory exists and should be archived, false otherwise.
# Parameters:
#   directory (string): The name of the directory to check for archival.
shouldArchive () {
  local -r directory="${1}"
  local -r encryptedFile="${directory}${ENCRYPTED_SUFFIX}"
  if ! isDirectory "${directory}" || ! isRegularFile "${encryptedFile}"; then
    return 1
  fi
  readarray -t subfiles < <(find "${directory}")
  for file in "${subfiles[@]}"; do
    if [[ ! "${file}" -ot "${encryptedFile}" ]]; then
      return 0
    fi
  done
  return 1
}

# Unset the password variables for additional security.
unsetPasswords() {
  unset password
  unset password-reentry
}

# Print the help message.
printHelpMessage() {
  echo "Archive - Archive and encrypt files."
  echo -e "\nArchive will recursively search for all files in the source "
  echo -e "directory containing the \"${ENCRYPTED_SUFFIX}\" suffix and copy "
  echo -e "them to the destination directory. Use the \"-e\" flag to create an "
  echo -e "encrypted copy of a directory to specify which subdirectories of "
  echo -e "the source should be archived. If the encrypted copy is older than "
  echo -e "its non-encrypted directory's modification time, then a new "
  echo -e "encrypted copy will be created and copied to the destination."
  echo -e "\nUsage: archive [source destination]"
  echo -e "\nOptions:"
  echo -e "\t-d file\t\tDecrypt and extract an encrypted file."
  echo -e "\t-e directory\tCreate an encrypted file of the directory."
  echo -e "\t-h\t\tPrint the help menu."
  echo -e "\t-u\t\tUnarchive - decrypt and extract all encrypted files."
  echo -e "\nOperands:"
  echo -e "\tsource\t\tThe source directory."
  echo -e "\tdestination\tThe destination directory."
  echo -e "\nDependencies:"
  echo -e "\tfind\t\tTo list directories to archive."
  echo -e "\tgpg\t\tTo encrypt and decrypt files."
  echo -e "\tmkdir\t\tTo make new directories."
  echo -e "\trm\t\tTo remove files."
  echo -e "\trsync\t\tTo copy files."
  echo -e "\ttar\t\tTo archive and unarchive files."
}

# Print the usage message.
printUsageMessage() {
  echo "Usage: archive source destination"
  echo "Type \"archive -h\" for more information."
}

setUp "${@}"
main
