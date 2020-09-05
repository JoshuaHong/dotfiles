" The Neovim configuration file

"
" ================================== Defaults ==================================
"
syntax on                           " Enable syntax highlighting
filetype on                         " Enable filetype detection
filetype indent on                  " Enable filetype specific indenting
filetype plugin on                  " Enable filetype specific plug-ins
set autoindent                      " Copy indent from current line on new line
set autoread                        " Reload files changed outside of Neovim
set background=dark                 " Use dark background unless set by terminal
set backspace=indent,eol,start      " Allow backspacing insert mode
set backupdir=.,$XDG_DATA_HOME/nvim/backup "Set backup directory
set belloff=all                     " Disable all bell events
set nocompatible " (Always)         " Set compatibility to Neovim only
set complete-=i                     " Enable argument completion
set cscopeverbose                   " Enable verbose cscope database adding
set directory=$XDG_DATA_HOME/nvim/swap// "Set swap directory, auto-created
set display+=lastline               " Show as much of last line instead of '@'
set display+=msgsep                 " Add separator for scrolled messages
set encoding=utf-8                  " Set encoding displayed in terminal
set fileencoding=utf-8              " Set encoding written to file
set fillchars+=vert:│               " Set vertical split separators
set fillchars+=fold:·               " Set filling foldtext
set formatoptions+=t                " Auto-wrap text using textwidth
set formatoptions+=c                " Auto-wrap comments inserting current lead
set formatoptions+=q                " Allow formatting of comments with 'gq'
set formatoptions+=j                " Remove a comment leader joining lines
set nofsync                         " Disable the OS fsync() after saving a file
set history=10000                   " Set lines of history stored (max is 10000)
set hlsearch                        " Highlight all search matches
set incsearch                       " Show matches while typing
set langnoremap                     " No 'langmap' characters without mappings
set laststatus=2                    " Show status line
set listchars=tab:>\ ,trail:-,nbsp:+ " Set strings to be used in 'list' mode
set nrformats+=bin                  " Define numbers beginning in 0b as binary
set nrformats+=hex                  " Define numbers beginning in 0x as hex
set ruler                           " Show line number and cursor position
set sessionoptions+=blank           " On ':mksession' save/restore empty windows
set sessionoptions+=buffers         " On ':mksession' save/restore buffers
set sessionoptions+=curdir          " On ':mksession' save/restore the curdir
set sessionoptions+=folds           " On ':mksession' save/restore folds
set sessionoptions+=help            " On ':mksession' save/restore help windows
set sessionoptions+=tabpages        " On ':mksession' save/restore tab pages
set sessionoptions+=winsize         " On ':mksession' save/restore window sizes
set shortmess+=f                    " Avoid hit-enter prompts using '(3 of 5)'
set shortmess+=i                    " Avoid hit-enter prompts using '[noeol]'
set shortmess+=l                    " Avoid hit-enter prompts using '999L, 888C'
set shortmess+=n                    " Avoid hit-enter prompts using '[New]'
set shortmess+=x                    " Avoid hit-enter prompts using '[dos]'
set shortmess+=t                    " Truncate file message at the start
set shortmess+=T                    " Truncate other messages in the middle
set shortmess+=o                    " Overwrites messages for writing a file
set shortmess+=O                    " Overwrites messages for reading a file
set shortmess+=F                    " Don't show file info when editing a file
set showcmd                         " Show partial commands
set sidescroll=1                    " Set minimum columns to scroll horizontally
set smarttab                        " Insert blanks at line start per shiftwidth
set tabpagemax=50                   " Maximum number of tab pages opened
set tags=./tags;,tags               " Set tags directory
set t_Co=256 " (Always)             " Use 256 colors
set ttimeoutlen=50                  " Set to wait time for key code sequences
set ttyfast " (Always)              " Send more characters on screen redraw
set undodir=$XDG_DATA_HOME/nvim/undo " Set undo directory
set viminfo+=!                      " Read shared data file overwriting all data
set wildmenu                        " Allow toggling through tab-completion
set wildoptions+=pum                " Display matches as 'ins-completion-menu'
set wildoptions+=tagfile            " Using CTRL-D list type and file of the tag

" Plug-ins
" The man.vim plug-in is enabled, to provide the :Man command.
" The matchit plug-in is enabled. To disable it in your config:
"   :let loaded_matchit = 1

" Change cursor shape based on mode
let &t_SI = "\<Esc>[6 q"
let &t_SR = "\<Esc>[4 q"
let &t_EI = "\<Esc>[2 q"

" Start Neovim with block cursor shape
autocmd VimEnter * :execute "normal v\<Esc>"

"
" ================================== General ===================================
"
set clipboard+=unnamedplus          " Use system clipboard by default
set colorcolumn=81                  " Set columns highlighted by 'ColorColumn'
set completeopt+=menuone            " Use completion menu even with one match
set completeopt+=noinsert           " No insert completion text until selected
set completeopt+=noselect           " No select completion match until selected
set completeopt-=preview            " No completion item info in preview window
set copyindent                      " New lines copy characters used for indents
set cursorline                      " Highlight the cursor line by 'CursorLine'
set expandtab                       " Convert tabs to spaces
set foldmethod=manual               " Create folds manually
set hidden                          " Allow switching between unsaved buffers
set ignorecase                      " Case-insensitive search
set lazyredraw                      " Don't redraw screen when executing macros
set linebreak                       " Wrap long lines at a 'breakat' character
set list                            " Display unprintable characters
set listchars=nbsp:˽,tab:>-,trail:· " Set strings to be used in 'list' mode
set mouse=a                         " Enable use of mouse in all modes
set noequalalways                   " Don't resize splits when closed
set nospell                         " Disable spell checking in place of plug-in
set noswapfile                      " Disable swap files
set nobackup                        " Disable backups
set number                          " Precede each line with its line number
set scrolloff=5                     " Set offset from cursor when scrolling
set shiftround                      " Use shiftwidth on indent with '<' and '>'
set shiftwidth=4                    " Set number of spaces to use for autoindent
set shortmess+=c                    " Avoid new message buffer using completion
set showmode                        " Show current mode: insert, replace, visual
set smartcase                       " Case-sensitive search for capital letters
set softtabstop=4                   " The number of columns a tab character uses
set splitbelow                      " Add horizontal splits to the bottom
set splitright                      " Add vertical splits to the right
set tabstop=4                       " Set number of spaces per tab
set termguicolors                   " Enable 24 bit RGB color in the TUI
set updatetime=30                   " Set idle time to trigger 'CursorHold'
set wildignorecase                  " Case-insensitive wildmenu search
set wildmode=longest:list,full      " Display all results of tab-completion
set writebackup                     " Make a temp backup before overwriting file

"
" ================================== Mappings ==================================
"
" Set mapleader
let mapleader = "\<Space>"

" Prepare an Ex command
nnoremap <Leader><Space> :
vnoremap <Leader><Space> :

" Open and exit the terminal
nnoremap <Leader>t :terminal<CR>i
tnoremap <C-q> <C-\><C-n>:bp<bar>sp<bar>bn<bar>bd!<CR>

" Movement keys
noremap n h
noremap e j
noremap i k
noremap o l
noremap N H
noremap E <C-d>
noremap I <C-u>
noremap O L
noremap a ^
noremap r b
noremap s w
noremap t $
noremap A I
noremap R B
noremap S W
noremap T A

" Remap used movement keys
noremap h n
noremap H N
noremap l i
noremap L a
noremap w t
noremap W T
noremap k r
noremap K R
noremap b e
noremap B E
noremap j o

" Jump to mark line and column
noremap ' `
noremap ' `
noremap ` '
noremap ` '

" Leave cursor after pasted text
nnoremap p gp
vnoremap p gp
nnoremap P gP
vnoremap P gP
nnoremap gp p
vnoremap gp p
nnoremap P gP
vnoremap P gP

" Yank until end of line
nnoremap Y 0y$
vnoremap Y 0y$

" Don't override clipboard on delete
nnoremap d "1d
vnoremap d "1d
nnoremap D 0"1d$
vnoremap D 0"1d$
nnoremap c "1c
vnoremap c "1c
nnoremap C 0"1c$
vnoremap C 0"1c$
nnoremap <Del> "1d<Right>
vnoremap <Del> "1d<Right>

" Keep visual highlighting after shifting
vnoremap < <gv
vnoremap > >gv

" Write and quit
nnoremap <Leader>w :update<CR>
nnoremap <Leader>W :write !sudo tee %<CR>
nnoremap <Leader>q :quit<CR>
nnoremap <Leader>Q :quit!<CR>

" Splits movement and resize
nnoremap <Leader>n <C-w>h
nnoremap <Leader>e <C-w>j
nnoremap <Leader>i <C-w>k
nnoremap <Leader>o <C-w>l
nnoremap <Leader>N <C-w><
nnoremap <Leader>E <C-w>-
nnoremap <Leader>I <C-w>+
nnoremap <Leader>O <C-w>>
nnoremap <Leader>k <C-w>=
nnoremap <Leader>v :vnew<CR>
nnoremap <Leader>x :new<CR>

" Make and display output
nnoremap <Leader>m :make<bar>copen 24<CR>

" Unset search pattern
nnoremap <Leader>h :nohlsearch<CR>

" Close current buffer while keeping splits
nnoremap <expr> <Leader>c &modified ? ":bd<CR>" : ":bp<bar>sp<bar>bn<bar>bd<CR>"

" Keep cursor on the same character when exiting insert mode
inoremap <silent> <Esc> <Esc>`^

"
" ================================== Plug-ins ==================================
"
" ============== Vim-plug ==============
call plug#begin(stdpath('data') . '/plugged')
    Plug 'ap/vim-css-color'
    Plug 'bfrg/vim-cpp-modern'
    Plug 'gcavallanti/vim-noscrollbar'
    Plug 'joshdick/onedark.vim'
    Plug 'junegunn/fzf.vim'
    Plug 'junegunn/goyo.vim'
    Plug 'kamykn/spelunker.vim'
    Plug 'nvim-lua/diagnostic-nvim'
    Plug 'neovim/nvim-lsp'
    Plug 'nvim-lua/completion-nvim'
    Plug 'yuttie/comfortable-motion.vim'
call plug#end()

" Open Vim-plug splits vertically in the far right
let g:plug_window = "vertical botright new"

" =========== Vim-cpp-modern ===========
" Enable highlighting of named requirements
let g:cpp_named_requirements_highlight = 1

" Don't highlight braces inside brackets
let c_no_curly_error = 1

" ========== Vim-noscrollbar ===========
set statusline=%<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %{noscrollbar#statusline(25,'-','█',['▐'],['▌'])}

" ============ Onedark.vim =============
" Use true colors
let $NVIM_TUI_ENABLE_TRUE_COLOR=1

" Use italics
let g:onedark_terminal_italics=1

" Execute the colorscheme
colorscheme onedark

" Use transparent background
highlight Normal guibg=NONE

" Set status line colors
highlight StatusLine guibg=#5f5f87
highlight StatusLineNC guibg=#303030

" Set whitespace colors
highlight WhiteSpace guifg=#5c6370

" ============== Fzf.vim ===============
" Mappings
nnoremap <Leader>b :Buffers<CR>
nnoremap <Leader>f :Files<CR>
nnoremap <Leader>; :History:<CR>
nnoremap <Leader>/ :History/<CR>
nnoremap <Leader>l :Lines<CR>
nnoremap <Leader>' :Marks<CR>
nnoremap <Leader>s :Rg<CR>

let g:fzf_action = {
      \ 'ctrl-w': 'tab split',
      \ 'ctrl-v': 'split',
      \ 'ctrl-x': 'vsplit'
  \ }

" Layout
let g:fzf_layout = { 'down': '70%' }

" ================ Goyo ================
" Reload color schemes on Goyo exit
augroup Goyo
    autocmd!
    autocmd  User GoyoLeave nested source $HOME/.config/nvim/init.vim
augroup END

" Mappings
nnoremap <Leader>g :Goyo<CR>

" =========== Spelunker.vim ============
" Disable by default
let g:enable_spelunker_vim = 0

" Movement
nnoremap <Leader>. :call spelunker#jump_next()<CR>
nnoremap <Leader>, :call spelunker#jump_prev()<CR>
nnoremap <Leader>z :call spelunker#correct_from_list()<CR>
nnoremap <Leader>Z :call spelunker#toggle()<CR>

" ========== Diagnostic-nvim ===========
" Define diagnostic symbols
call sign_define("LspDiagnosticsErrorSign", {"text" : "❌", "texthl" : "LspDiagnosticsError"})
call sign_define("LspDiagnosticsWarningSign", {"text" : "⚠️", "texthl" : "LspDiagnosticsWarning"})
call sign_define("LspDiagnosticsInformationSign", {"text" : "ℹ️", "texthl" : "LspDiagnosticsInformation"})
call sign_define("LspDiagnosticsHintSign", {"text" : "H", "texthl" : "LspDiagnosticsHint"})

" Disable diagnostics while in insert mode
let g:diagnostic_insert_delay = 1

" Mappings
nnoremap <Leader>y :NextDiagnosticCycle<CR>
nnoremap <Leader>Y :PrevDiagnosticCycle<CR>

" ============== Nvim-lsp ==============
lua <<EOF
    local on_attach = function()
        require'completion'.on_attach()
        require'diagnostic'.on_attach()
    end
    require'nvim_lsp'.clangd.setup{
        on_attach=on_attach
    }
EOF

" Mappings
nnoremap <Leader>a <cmd>lua vim.lsp.buf.code_action()<CR>
nnoremap <Leader>d <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <Leader>D <cmd>lua vim.lsp.buf.declaration()<CR>
nnoremap <Leader>p <cmd>lua vim.lsp.buf.formatting()<CR>
nnoremap <Leader>k <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <Leader>r <cmd>lua vim.lsp.buf.rename()<CR>
nnoremap <Leader>u <cmd>lua vim.lsp.buf.references()<CR>

" =========== Completion-lsp ===========
" Enable auto insert parenthesis
let g:completion_enable_auto_paren=1

" Set matching strategy in order of priority
let g:completion_matching_strategy_list = ['exact', 'substring', 'fuzzy', 'all']

" Set completion mappings
inoremap <expr> <Tab>   pumvisible() ? "\<C-p>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-n>" : "\<S-Tab>"
inoremap <expr> <C-e> pumvisible() ? "\<C-n>" : "\<C-e>"

" ======= Comfortable-motion.vim =======
" Scroll proportional to window height
let g:comfortable_motion_no_default_key_mappings = 1
let g:comfortable_motion_impulse_multiplier = 1
nnoremap <silent> E :call comfortable_motion#flick(g:comfortable_motion_impulse_multiplier * winheight(0) * 2)<CR>
nnoremap <silent> I :call comfortable_motion#flick(g:comfortable_motion_impulse_multiplier * winheight(0) * -2)<CR>
nnoremap <silent> <C-f> :call comfortable_motion#flick(g:comfortable_motion_impulse_multiplier * winheight(0) * 4)<CR>
nnoremap <silent> <C-b> :call comfortable_motion#flick(g:comfortable_motion_impulse_multiplier * winheight(0) * -4)<CR>

" =============== Netrw ================
augroup Netrw
    autocmd!
    autocmd filetype netrw call NetrwMappings()
    autocmd VimEnter * call NetrwOpen()
    autocmd WinEnter * call NetrwClose()
augroup END

function NetrwMappings()
    " Toggle Netrw
    nnoremap <Leader><Tab> :Lexplore<CR>
    " Movement keys
    nmap <buffer> n -<Esc>
    nmap <buffer> e <Down>
    nmap <buffer> i <Up>
    nmap <buffer> o gn
    nmap <buffer> <C-v> :call NetrwVSplit()<CR>
    nmap <buffer> <C-x> :call NetrwSplit()<CR>
endfunction

function NetrwOpen()
    " Set Netrw appearance
    let g:netrw_banner = 0
    let g:netrw_liststyle = 3
    let g:netrw_winsize = 20
    " Open Netrw
    execute "Lexplore"
    " Switch focus to main split
    wincmd p
    " If Neovim is not opened in directory then open selected file in new window
    if ! isdirectory(expand("%h"))
        let g:netrw_browse_split = 4
    endif
endfunction

function NetrwClose()
    " Close Netrw if it's the only open buffer and all buffers are not modified
    if winnr("$") == 1 && getbufvar(winbufnr(winnr()), "&filetype") == "netrw"
        try
            quit
        catch
            call NetrwOpen()
            echoerr v:exception
        endtry
    endif
endfunction

function NetrwVSplit()
    wincmd p
    wincmd v
    exe 1 . "wincmd w"
    call feedkeys("\<CR>")
endfunction

function NetrwSplit()
    wincmd p
    wincmd s
    exe 1 . "wincmd w"
    call feedkeys("\<CR>")
endfunction

" ============= Termdebug ==============
" Use wide layout
let g:termdebug_wide=1

" Mappings
nnoremap <Leader>j :call TermDebugSetup()<CR>
function TermDebugSetup()
    packadd termdebug
    Termdebug
    normal A
endfunction
