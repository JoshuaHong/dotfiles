"========== Plugins ==========
call plug#begin('~/.vim/plugged')
  Plug 'valloric/youcompleteme'
  let g:ycm_global_ycm_extra_conf = "~/.vim/plugged/youcompleteme/third_party/ycmd/.ycm_extra_conf.py"
call plug#end()


"========== Init ==========

set nocompatible                    "Set compatibility to Vim only


"========== General ==========

set backspace=indent,eol,start      "Allow backspacing insert mode
set history=1000                    "Store 1000 lines of history
set autoread                        "Reload files changed outside Vim
set mouse=a                         "Enable use of mouse for all modes
set scrolloff=2                     "Keep cursor from edges when scrolling
set wildmenu                        "Allow toggling through tab-completion
set wildignorecase                  "Case-insensitive wildmenu search
set wildmode=longest:list,full      "Display all results of tab-completion
set splitbelow splitright           "Split screens add to the right or bottom
set lazyredraw                      "Disable screen redraw when executing macros
set ttyfast                         "Send more characters when screen redrawing
set clipboard=unnamedplus           "Set default register to system clipboard
set belloff=all                     "Disable all error notifications
set number                          "Show line numbers
set ruler                           "Show current line and column
set showcmd                         "Show partial commands
set showmode                        "Show current mode
set linebreak                       "Wrap lines at convenient points
set list listchars=tab:\ \ ,trail:· "Display trailing tabs and spaces
match ErrorMsg '\%>80v.\+'          "Highlights characters over 80 column limit

"Allow cursor to move one past end of line
set virtualedit=onemore
nnoremap $ $l

"Colorscheme
syntax on                           "Enable syntax highlighting
set background=dark                 "Use dark background
set t_Co=256                        "Enable 256 colours
let g:solarized_termcolors=256
let g:solarized_termtrans=1
colorscheme solarized               "Use solarized colorscheme


"========== Folds ==========

augroup AutoSaveFolds
  autocmd!
  autocmd BufWinLeave * mkview
  autocmd BufWinEnter * silent loadview
augroup END


"========== Indentation ==========

set autoindent                      "New line keeps same indent as previous line
set copyindent                      "Autoindent line copies previous indentation
set expandtab                       "Convert tab to spaces
set tabstop=2                       "Set spaces to use per tab
set softtabstop=2                   "Set spaces to use per tab on paste
set shiftwidth=2                    "Set spaces to use per tab on autoindent
set shiftround                      "Use shiftwidth on indent with '<' and '>'
set smarttab                        "Use shiftwidth to indent on line start

"Autoindent pasted text
nnoremap p p=`]<C-o>
nnoremap P P=`]<C-o>


"========== Search ==========

set hlsearch                        "Highlight all search results
set incsearch                       "Show matches while typing
set ignorecase                      "Case-insensitive search
set smartcase                       "Case-sensitive search for capital letters

"Unset search pattern upon pressing Enter
nnoremap <silent> <CR> :noh<CR><CR>


"========== Filetype ==========

filetype on                         "Enable filetype detection
filetype indent on                  "Enable filetype specific indenting
filetype plugin on                  "Enable filetype specific plugins


"========== Backup ==========

set noswapfile                      "Disable swap files
set nobackup                        "Disable backups
set nowb                            "Disable writing to backups


"========== Persistent Undo ==========

if !isdirectory("/tmp/.vim-undo-dir")
  call mkdir("/tmp/.vim-undo-dir", "", 0700)
endif

set undodir=/tmp/.vim-undo-dir
set undofile