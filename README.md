# Customizations
A collection of personal customizations.
## Setup
1. Copy all files to the home directory:
`rsync -av ./ ~ --exclude={README.md,.git}`
2. Upgrade vim-plug in vim:
`:PlugUpgrade`
3. Install plugins in vim:
`:PlugInstall`
4. Update plugins in vim:
`:PlugUpdate`
5. Install necessary tools:
`sudo apt install build-essential cmake python3-dev`
6. Install YouCompleteMe:
`cd ~/.vim/plugged/youcompleteme
python3 install.py --clang-completer`
