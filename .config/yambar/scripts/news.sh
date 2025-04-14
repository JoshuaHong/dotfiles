#!/bin/bash
#
# Yambar script to display news.

main() {
    local -r numUnread="$(fetchNumUnread)"
    if [[ "${numUnread}" -gt 0 ]]; then
        echo -e "news|int|${numUnread}\n"
    fi
}

fetchNumUnread() {
    local -ar news=($(newsboat -x reload print-unread))
    echo "${news[0]}"
}

main
