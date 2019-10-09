# Customizations
A collection of personal customizations.
## Setup
1. Copy all files to the home directory:
`rsync -av * ~ --exclude=README.md`
2. Upgrade vim-plug in vim:
`:PlugUpgrade`
3. Update plugins in vim:
`:PlugUpdate youcompleteme`
4. Install necessary tools:
`sudo apt install build-essential cmake python3-dev`
5. Install YouCompleteMe:
`cd ~/.vim/plugged/youcompleteme
python3 install.py --clang-completer`
