#!/usr/bin/bash
#
# The script executed when Bash is invoked as an interactive non-login shell.
# Contains commands to run each time a new Bash shell is launched.

main() {
    setAliases
    setOptions
    setPrompts
    disableFlowControl
}

setAliases() {
    # ls after cd, and cd to a parent directory for every additional "."
    cd() {
        containsOnlyOneOrMoreDots() {
            local directory="${1}"
            [[ "$directory" =~ ^(\.)+$ ]]
        }

        cdToParentDirectory() {
            local directory="${1}"
            local initialPWD="${PWD}"
            for ((i=1; i<"$(getLength "${directory}")"; ++i)); do
                command cd "../"
            done
            setOLDPWD "${initialPWD}"
            pwd
        }

        getLength() {
            local variable="${1}"
            echo "${#variable}"
        }

        setOLDPWD() {
            local initialPWD="${1}"
            OLDPWD="${initialPWD}"
        }

        local directory="${1}"
        if containsOnlyOneOrMoreDots "${directory}"; then
            cdToParentDirectory "${directory}"
        else
            command cd "$@"
        fi
        ls --color=auto
    }

    moveToTrash() {
        command mv --backup=numbered "${@}" "${HOME}/.trash/"
    }

    alias cp="cp --archive --interactive"
    alias diff="diff --color=auto"
    alias grep="grep --color=auto"
    alias ip="ip -color=auto"
    alias ln="ln --interactive"
    alias ls="ls --color=auto"
    alias mkdir="mkdir --parents"
    alias mv="mv --interactive"
    alias rm="moveToTrash"
}

setOptions() {
    # Prevent output redirection from overwriting existing files.
    set -o noclobber
    # Don't suppress multiple evaluation of associative array subscripts.
    shopt -u assoc_expand_once
    # Change directories when entering a path without the `cd` command.
    # E.g., /foo/bar -> cd /foo/bar.
    shopt -s autocd
    # Don't assume an argument to `cd` that isn't a directory is a variable name
    # whose value is the directory to which to navigate.
    # E.g., cd foo -/-> cd $foo.
    shopt -u cdable_vars
    # Fix minor spelling errors automatically when running `cd`.
    # E.g., cd /fou/bar -> cd /foo/bar.
    shopt -s cdspell
    # Check that a command found in the hash table exists before executing it.
    shopt -s checkhash
    # List background jobs before exiting, deferring the exit until an exit
    # command is called again.
    shopt -s checkjobs
    # Update `LINES` and `COLUMNS` after each command.
    shopt -s checkwinsize
    # Save multiline commands as a single entry in the history file.
    shopt -s cmdhist
    # Quote shell metacharacters in file and directory names during
    # autocompletion.
    shopt -s complete_fullquote
    # Expand directory names during completion.
    # E.g., $HOME/<TAB> -> /foo/bar/.
    shopt -s direxpand
    # Fix minor directory spelling errors on completion.
    # E.g., /fou/bar/<TAB> -> /foo/bar.
    shopt -s dirspell
    # Include hidden files in glob expansion.
    # E.g., cp * -> includes all hidden files.
    shopt -s dotglob
    # Don't exit an interactive shell if the `exec` command fails.
    shopt -s execfail
    # Enable aliases.
    shopt -s expand_aliases
    # Disable behavior to use for debuggers.
    shopt -u extdebug
    # Enable extended pattern matching.
    # E.g., ls !(*.txt) -> Lists all non `.txt` files.
    shopt -s extglob
    # Quote `$"str"` and `$'str'` in `${}`.
    # E.g., echo ${v:-$"foo bar"} -> foo bar.
    shopt -s extquote
    # Fail if patterns don't match any filenames.
    # E.g., touch foo* -> Error.
    shopt -s failglob
    # Ignore `FIGNORE` suffixes even if they contain words that are the only
    # possible completions.
    shopt -s force_fignore
    # Allow range expressions to behave as C local.
    # E.g. [a-d] matches `a` or `b` or `c` or `d`.
    shopt -s globasciiranges
    # Don't match `.` and `..` filenames during filename expansion.
    shopt -s globskipdots
    # Enable the `**` pattern matching. Used to search all sub-directories
    # recursively.
    # E.g., ls foo/**/*.txt -> Lists all `.txt` files recursively in `foo`.
    shopt -s globstar
    # Don't write shell error messages in GNU error message format.
    # E.g., GNU error message: ./foo.sh:1: bar: command not found.
    # E.g., Default error message: ./foo.sh: line 3: bar: command not found.
    shopt -u gnu_errfmt
    # Append to the history file instead of overwriting it.
    shopt -s histappend
    # Disable re-editing a failed history substitution.
    # E.g., !foo -> Clears the input.
    shopt -u histreedit
    # Don't load the results of history substitution into the input line instead
    # of executing it for further modification.
    # E.g., !foo -> Doesn't add `foo` to the input line.
    shopt -u histverify
    # Enable completion for a word with `@`.
    # E.g., @<TAB> -> @foo.
    shopt -s hostcomplete
    # Send `SIGHUP` to all jobs when an interactive login shell exits.
    shopt -s huponexit
    # Enable command substitution proceses to also use the `errexit` option.
    shopt -s inherit_errexit
    # Enable comments beginning with `#`.
    shopt -s interactive_comments
    # In the current shell, run the last command of a pipe that isn't executed.
    shopt -s lastpipe
    # If `cmdhist` is enabled, save multiline commands in the history file with
    # embedded newlines instaed of semicolons.
    shopt -s lithist
    # Don't allow local variables to inherit the value and attributes of a
    # variable of the same name that exists at a previous scope.
    shopt -u localvar_inherit
    # Don't allow `unset` to work on local variables in previous function
    # scopes.
    shopt -u localvar_unset
    # If the mail file has already been accessed, don't display the following
    # message:
    # `The mail in mailfile has been read`.
    shopt -u mailwarn
    # Attempt to search `PATH` for possible completions when completion is
    # attempted on an empty line.
    shopt -u no_empty_cmd_completion
    # Don't perform case-insensitie expansion.
    shopt -u nocaseglob
    # Don't perform case-insensitive matching.
    shopt -u nocasematch
    # Don't enclose the results of `$"..."` in single quotes instead of double
    # quotes.
    shopt -u noexpand_translation
    # Expand patterns that match nothing to an empty string instead of searching
    # for a literal file named `*`.
    # E.g., ls * -> "".
    shopt -s nullglob
    # Expand `&` in pattern substitution.
    shopt -s patsub_replacement
    # Enable programmable completion.
    shopt -s progcomp
    # Don't treat a command that doesn't have any possible completions as the
    # name of an alias and don't attempt to use the alias.
    shopt -u progcomp_alias
    # Allow expansion in prompt strings.
    shopt -s promptvars
    # Print an error if the `shift` command count exceeds the number of
    # positional parameters.
    shopt -s shift_verbose
    # Allow the `source` command to use `PATH` to find the path containing the
    # file being sourced.
    shopt -s sourcepath
    # Automatically close file descriptors assigned using `{varname}` instead of
    # leaving them open when the command completes.
    shopt -s varredir_close
    # Don't expand backslash-escape sequences by default when using `echo`.
    # Equivalent to `echo -e` if enabled.
    shopt -u xpg_echo
}

setPrompts() {
    local red="\[\e[31m\]"
    local green="\[\e[32m\]"
    local yellow="\[\e[33m\]"
    local blue="\[\e[34m\]"
    local magenta="\[\e[35m\]"
    local cyan="\[\e[36m\]"
    local lightYellow="\[\e[93m\]"
    local reset="\[\e[m\]"
    local lbrace="${red}["
    local username="${yellow}\u"
    local at="${lightYellow}@"
    local hostname="${green}\h"
    local pwd="${blue}\W"
    local rbrace="${red}]"
    local dollar="${magenta}$"
    local space=" "

    # Set the primary prompt.
    PS1="${lbrace}${username}${at}${hostname}${space}${pwd}${rbrace}${dollar}${space}${reset}"
    # Unset the prompt command so that the window title is not set to PS1.
    unset PROMPT_COMMAND
}

disableFlowControl() {
    stty -ixon  # Don't allow `Ctrl+S` to disable terminal execution.
}

main
