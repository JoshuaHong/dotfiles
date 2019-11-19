#!/bin/sh

# A dmenu list of unicode characters to copy to clipboard

unicode="$(grep -v "//" $HOME/scripts/etc/unicode.txt \
  | dmenu -i -l 20 -fn "Noto Fonts -14" | awk '{print $1}')"

if [ ! -z "$unicode" ]; then
  echo -e "$unicode" | tr -d '\n' | xclip -selection clipboard
fi
