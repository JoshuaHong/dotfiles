"========== Plugins =========={{{
call plug#begin('~/.vim/plugged')
  Plug 'altercation/vim-colors-solarized'
  Plug 'bfrg/vim-cpp-modern'
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
set relativenumber                  "Show relative line number
set showcmd                         "Show partial commands
set showmode                        "Show current mode
set linebreak                       "Wrap lines at convenient points
set hidden                          "Allow switching between unsaved buffers
set foldmethod=marker               "Use markers to indicate folds
set foldmarker={{{,}}}              "Set start and end markers for folds
set list listchars=tab:\ \ ,trail:· "Display trailing tabs and spaces
set colorcolumn=81                  "Highlights the column limit

"Change cursor shape based on mode
let &t_SI = "\<Esc>[6 q"
let &t_SR = "\<Esc>[4 q"
let &t_EI = "\<Esc>[2 q"
"}}}

"========== Colorscheme =========={{{
syntax on                           "Enable syntax highlighting
set background=dark                 "Use dark background
set t_Co=256                        "Enable 256 colors
colorscheme solarized               "Use solarized colorscheme
let g:solarized_termcolors=256      "Use 256 colors

"Enable transparent backgroud
highlight Normal guibg=NONE ctermbg=NONE

"Set colorcolumn color
highlight ColorColumn guibg=lightgrey ctermbg=235
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

"========== Mappings =========={{{
"========== General =========={{{
"Set mapleader
let mapleader = "\<Space>"

"Remap Escape key
nnoremap <Leader> za
nnoremap <Leader><Space> :
noremap <C-_> <Esc>
inoremap <C-_> <Esc>

"Map movement
inoremap <C-h> <Left>
inoremap <C-j> <Down>
inoremap <C-k> <Up>
inoremap <C-l> <Right>

"Remap write and quit
nnoremap <Leader>w :up<CR>
nnoremap <Leader>W :w !sudo tee %<CR>
nnoremap <Leader>a :wa<CR>
nnoremap <Leader>q :q<CR>
nnoremap <Leader>Q :q!<CR>

"Close current buffer
nnoremap <expr> <Leader>d &modified ? ':bd<CR>' : ':bp<bar>sp<bar>bn<bar>bd<CR>'

"Unset search pattern
nnoremap <silent> <Leader>n :noh<CR>

"Toggle spellcheck
nnoremap <Leader>s :set spell! spelllang=en_ca<CR>

"Open file explorer
nnoremap <Leader>e :Explore<CR>
"}}}

"========== Editing =========={{{
"Insert a single character
nnoremap <Leader>' :exec "normal i<C-l>".nr2char(getchar())."\e"<CR>
nnoremap <Leader>" :exec "normal i".nr2char(getchar())."\el"<CR>

"Delete without yanking
nnoremap d "_d
vnoremap d "_d
nnoremap D "_D
vnoremap D "_D
nnoremap <Del> "_x
vnoremap <Del> "_x
nnoremap c "_c
vnoremap c "_c
nnoremap C "_C
vnoremap C "_C

"Cut line
nnoremap <Leader>x dd

"Paste from clipboard before cursor without yanking
nnoremap p p=<CR>`[
vnoremap p "_d"+p=<CR>`[

"Paste from clipboard after cursor without yanking
nnoremap P P=<CR>`[
vnoremap P "_d"+P<CR>=`[

"Toggle Comments
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

"========== Autocmd =========={{{
"Start vim with block cursor shape
autocmd VimEnter * :execute "normal v\<Esc>"

"Escape key stays on current character
let CursorColumnI = 0
autocmd InsertEnter * let CursorColumnI = col('.')
autocmd CursorMovedI * let CursorColumnI = col('.')
autocmd InsertLeave * if col('.') != CursorColumnI | call cursor(0, col('.')+1) | endif

"Persistent Undo
if !isdirectory("/tmp/.vim-undo-dir/")
  call mkdir("/tmp/.vim-undo-dir/", "", 0700)
endif
set undodir=/tmp/.vim-undo-dir
set undofile
"}}}

"========== Plugins =========={{{
"========== FZF =========={{{
"Find buffers
nnoremap <Leader>b :Buffers<CR>

"Find files
nnoremap <Leader>f :Files<CR>

"Find marks
nnoremap <Leader>m :Marks<CR>

"Find lines in open buffers
nnoremap <Leader>l :Lines<CR>

"Find lines in project
nnoremap <Leader>g :Rg<CR>

"Find command history
nnoremap <Leader>h :History:<CR>
"}}}
"}}}
"}}}
