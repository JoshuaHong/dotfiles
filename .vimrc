"========== Init ==========

set nocompatible                    "Set compatibility to Vim only


"========== General ==========

syntax on                           "Enable syntax highlighting
set backspace=indent,eol,start      "Allow backspacing insert mode
set history=1000                    "Store 1000 lines of history
set number                          "Show line numbers
set ruler                           "Show current line and column
set showcmd                         "Show partial commands
set showmode                        "Show current mode
set autoread                        "Reload files changed outside Vim
set list listchars=tab:\ \ ,trail:· "Display trailing tabs and spaces
set linebreak                       "Wrap lines at convenient points
set mouse=a                         "Enable use of mouse for all modes
set scrolloff=2                     "Keep cursor from edges when scrolling
set wildmenu                        "Allow toggling through tab-completion
set wildignorecase                  "Case-insensitive wildmenu search
set wildmode=longest:list,full      "Display all results of tab-completion
set splitbelow splitright           "Split screens add to the right or bottom
match ErrorMsg '\%>80v.\+'          "Highlights characters over 80 column limit


"========== Indentation ==========

set autoindent                      "New line keeps same indent as previous line
set copyindent                      "Autoindent line copies previous indentation
set expandtab                       "Convert tab to spaces
set tabstop=4                       "Set spaces to use per tab
set softtabstop=4                   "Set spaces to use per tab on paste
set shiftwidth=4                    "Set spaces to use per tab on autoindent
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


"========== Turn Off Swap Files ==========

set noswapfile
set nobackup
set nowb


"========== Persistent Undo ==========

if !isdirectory("/tmp/.vim-undo-dir")
    call mkdir("/tmp/.vim-undo-dir", "", 0700)
endif

set undodir=/tmp/.vim-undo-dir
set undofile
