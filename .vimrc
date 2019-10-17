"========== Plugins =========={{{
call plug#begin('~/.vim/plugged')
  Plug 'scrooloose/nerdtree'
  "Open NERDTree on startup when file specified
  autocmd VimEnter * NERDTree
  autocmd StdinReadPre * let s:std_in=1
  "Open NERDTree on startup when no file specified
  autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
  "Open NERDTree on startup when opening a directory
  autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | exe 'cd '.argv()[0] | endif
  "Switch to main window after opening NERDTree
  autocmd VimEnter * wincmd p
  "Close vim if only window open is NERDTree
  autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
  "Update current buffer directory
  autocmd BufEnter * lcd %:p:h
  "Refresh NERDTree
  autocmd BufEnter * if &filetype !=# 'nerdtree' | noautocmd NERDTreeFind | noautocmd wincmd p | endif

  Plug 'valloric/youcompleteme'
  let g:ycm_global_ycm_extra_conf = "~/.vim/plugged/youcompleteme/third_party/ycmd/.ycm_extra_conf.py"

  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
  Plug 'junegunn/fzf.vim'
call plug#end()
"}}}

"========== Init =========={{{
set nocompatible                    "Set compatibility to Vim only
set encoding=utf-8                  "Set encoding displayed
set fileencoding=utf-8              "Set encoding written to file
filetype on                         "Enable filetype detection
filetype indent on                  "Enable filetype specific indenting
filetype plugin on                  "Enable filetype specific plugins
"}}}

"========== General =========={{{
set backspace=indent,eol,start      "Allow backspacing insert mode
set history=1000                    "Lines of history stored
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
set hidden                          "Allow switching between unsaved buffers
set virtualedit=onemore             "Allow cursor to move one past end of line
set foldmethod=marker               "Use markers to indicate folds
set foldmarker={{{,}}}              "Set start and end markers for folds
set list listchars=tab:\ \ ,trail:· "Display trailing tabs and spaces
set colorcolumn=81                  "Highlights the column limit
"}}}

"========== Colorscheme =========={{{
syntax on                           "Enable syntax highlighting
set background=dark                 "Use dark background
set t_Co=256                        "Enable 256 colours
let g:solarized_termcolors=256      "Enable 256 colours on terminal
let g:solarized_termtrans=1         "Enable transparent background of terminal
colorscheme solarized               "Use colorscheme solarized

let g:cpp_class_scope_highlight = 1                   "Highlight class scopes
let g:cpp_member_variable_highlight = 1               "Highlight member variables
let g:cpp_class_decl_highlight = 1                    "Highlight class names in declarations
let g:cpp_experimental_simple_template_highlight = 1  "Highlight template functions
let g:cpp_concepts_highlight = 1                      "Highlight library concepts
"}}}

"========== Indentation =========={{{
set autoindent                      "New line keeps same indent as previous line
set copyindent                      "Autoindent line copies previous indentation
set expandtab                       "Convert tab to spaces
set tabstop=2                       "Set spaces to use per tab
set softtabstop=2                   "Set spaces to use per tab on paste
set shiftwidth=2                    "Set spaces to use per tab on autoindent
set shiftround                      "Use shiftwidth on indent with '<' and '>'
set smarttab                        "Use shiftwidth to indent on line start
"}}}

"========== Search =========={{{
set hlsearch                        "Highlight all search results
set incsearch                       "Show matches while typing
set ignorecase                      "Case-insensitive search
set smartcase                       "Case-sensitive search for capital letters
"}}}

"========== Backup =========={{{
set noswapfile                      "Disable swap files
set nobackup                        "Disable backups
set nowb                            "Disable writing to backups
"}}}

"========== Persistent Undo =========={{{
if !isdirectory("/tmp/.vim-undo-dir")
  call mkdir("/tmp/.vim-undo-dir", "", 0700)
endif

set undodir=/tmp/.vim-undo-dir
set undofile
"}}}

"========== Mappings =========={{{
"========== General =========={{{
"Set mapleader
let mapleader = "\<Space>"

"Remap Escape key
nmap <Leader><Space> :
imap <Leader><Space> <Esc>
vmap <Leader><Space> <Esc>

"Update buffers
nnoremap <Leader>u :up<CR>
nnoremap <Leader>w :wa<CR>

"Close buffers
nnoremap <Leader>c :bd<CR>
nnoremap <Leader>q :q<CR>

"Unset search pattern
nnoremap <silent> <Leader>n :noh<CR>

"Move one past end of line
nnoremap $ $l

"Escape key stays on current character
let CursorColumnI = 0
autocmd InsertEnter * let CursorColumnI = col('.')
autocmd CursorMovedI * let CursorColumnI = col('.')
autocmd InsertLeave * if col('.') != CursorColumnI | call cursor(0, col('.')+1) | endif
"}}}

"========== fzf =========={{{
"Find buffers
nnoremap <Leader>b :Buffers<CR>

"Find files
nnoremap <Leader>f :Files<CR>

"Find tags
nnoremap <Leader>t :Tags<CR>

"Find marks
nnoremap <Leader>m :Marks<CR>

"Find lines in open buffers
nnoremap <Leader>l :Lines<CR>

"Find lines in project
nnoremap <Leader>s :Ag<CR>

"Find command history
nnoremap <Leader>h :History:<CR>
"}}}

"========== Editing =========={{{
"Insert a single character
nnoremap <Leader>i :exec "normal i".nr2char(getchar())."\el"<CR>

"Add Newline and Backspace in normal mode
nnoremap <CR> i<CR><Esc>`^
nnoremap <BS> i<BS><Esc>`^

"Delete without yanking
nnoremap d "_d
vnoremap d "_d
nnoremap <Del> "_x
vnoremap <Del> "_x

"Cut line
nnoremap <Leader>d dd

"Paste from clipboard without yanking and leave cursor after pasted text
nnoremap <Leader>p gP
vnoremap <Leader>p "_d"+gP
"}}}

"========== Toggle Comments =========={{{
let b:commentChar='// '
autocmd BufNewFile,BufReadPost *.vimrc let b:commentChar='" '
autocmd BufNewFile,BufReadPost *.\(sh\|py\) let b:commentChar='# '
function! Docomment ()
  execute '''<,''>s/^\s*/&'.escape(b:commentChar, '\/').'/e'
endfunction
function! Uncomment ()
  execute '''<,''>s/\v(^\s*)'.escape(b:commentChar, '\/').'\v\s*/\1/e'
endfunction
function! Comment ()
  if match(getline(getpos("'<")[1]), '^\s*'.b:commentChar)>-1
    call Uncomment()
  else
    call Docomment()
  endif
endfunction
vnoremap <silent> <Leader>/ :<C-u>call Comment()<cr>
nnoremap <silent> <Leader>/ v:<C-u>call Comment()<cr>
"}}}
"}}}
