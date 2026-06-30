#!/bin/bash
#
# Use Fuzzel for GPG pinentry.

echo "OK"
while read -r stdin; do
    case "${stdin}" in
        *BYE*)
            break
            ;;
        *SETDESC*)
            KEYNAME="${stdin#*:%0A%22}"
            KEYNAME="${KEYNAME%\%22\%0A*}"
            KEYID="${stdin#*ID}"
            KEYID="${KEYID%,*}"
            echo "OK"
            ;;
        *GETPIN*)
            PASS_INPUT="$(DISPLAY=:0 \
                    fuzzel --dmenu --password --prompt-only "Password: ")"
            if [[ -n "${PASS_INPUT}" ]] ; then
                echo "D ${PASS_INPUT}"
                echo "OK"
           else
                echo "ERR 83886179 Operation cancelled" 
                echo "OK"
            fi
            ;;
        *)
            echo "OK"
            ;;
    esac
done
