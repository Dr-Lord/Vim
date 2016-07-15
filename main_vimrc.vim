"""" INTRODUCTION """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
"   Author:
"       Dr-Lord
"   Version:
"       1.15 - 04/07/2016
"
"   Repository:
"       https://github.com/Dr-Lord/Vim
"
"   Description:
"       Non-extension related part of the personal vim configuration of Dr-Lord.
"       This configuration file contains all the basic/necessary settings in
"       order to make Vim vary good. See all the other files in the repository
"       for more advanced or specific settings and functions.
"
"   Sections:
"       1 - Basics
"       2 - User Interface
"       3 - Text, Font and Colours
"       4 - Usability
"       5 - Search
"       6 - Indentation
"       7 - Motions and Moving Around
"       8 - Buffers and Tabs
"       9 - Other Options
"       0 - Helper Functions

" Viktorian recommendations:
"
" Return to normal mode easily from insert mode
" inoremap jk <Esc>
" You MUST learn
" inoremap <Esc> <nop>  


"""" 1 - BASICS """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Ward off unexpected things and sanely reset options when re-sourcing .vimrc
set nocompatible

" Attempt to determine file type from name and possibly contents, which
" allows intelligent auto-indenting and filetype specific plugins.
filetype indent plugin on

" Set to auto read when a file is changed from the outside
set autoread

" Set "," as map leader, allowing extra key combinations
let mapleader = ","
let g:mapleader = ","

" Set "_" as local (buffer-wise) map leader, allowing extra key combinations
let maplocalleader = "_"
let g:maplocalleader = "_"

" Set utf8 as standard encoding and en_US as the standard language
set encoding=utf8

" Use Unix as the standard file type and handle Dos's and Mac's
set fileformats=unix,dos,mac

" Set what information should be stored in the viminfo file
"           +--Remember buffer list
"           | +--Disable hlsearch while loading viminfo
"           | | +--Remember marks for last 500 files
"           | | |    +--Remember up to 10000 lines in each register
"           | | |    |      +--Remember up to 1MB in each register
"           | | |    |      |     +--Remember last 1000 search patterns
"           | | |    |      |     |     +---Remember last 1000 commands
"           | | |    |      |     |     |
"           v v v    v      v     v     v
set viminfo=%,h,'500,<10000,s1000,/1000,:1000

" Return to last edit position when opening files
autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

" Use persistent undo
if has('persistent_undo')
    " Save all undo files in a single location (less messy, more risky)
    set undodir=$HOME/tmp/.VIM_UNDO_FILES
    " Allow a lot of undo operations
    set undolevels=5000
    " Save and restore a lot of history
    set undoreload=10000
    " Actually switch on persistent undo
    set undofile
endif



"""" 2 - USER INTERFACE """"""""""""""""""""""""""""""""""""""""""""""""""""""""

" Show file title in window title
set title

" Make abandoned buffers hidden, and generate a single undo history for all
set hidden

" Set the command window height to 2 lines, to avoid many cases of having to
" "press <Enter> to continue"
set cmdheight=2

" Adjust completions to match case
set infercase
" Enable command-line completions visualisation menu
set wildmenu
" Show list of completions and complete as much as then iterate full completions
set wildmode=list:longest,full
" Ignore compiled files
set wildignore=*.o,*~,*.pyc
if has("win16") || has("win32")
    set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
else
    set wildignore+=.git\*,.hg\*,.svn\*
endif

" Display line numbers on the left
set number

if has('cmdline_info')
    " Show the ruler
    set ruler
    " Set the ruler format (lookup symbols in help pages)
    set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%)
    " Show partial commands and selected characters or lines in visual mode
    set showcmd
endif

if has('statusline')
    " Always display the status line, even if only one window is displayed
    set laststatus=2

    " One format string, split for commenting (\<space> is actual space)
    set statusline=B:%n\ %<%15.f                  " Buffer number and Filename
    set statusline+=\ %{HasPaste()}%m%r%h%w       " Options
    set statusline+=\ \ [%{&ff}/%Y]               " OS style Filetype
    set statusline+=\ \ \                         " Spacing
    set statusline+=CWD:[%.40{getcwd()}]          " Current dir
    set statusline+=\ \ \                         " Spacing
    set statusline+=%=%-12.(%l/%L,%c%V%)\ \ %p%%  " Right aligned file nav info
endif

" Show matching brackets when text indicator is over them
set showmatch
" How many tenths of a second to blink when matching brackets
set mat=2

" Set scroll offset: x lines will be visible above and below the cursor
set scrolloff=5

" Add a bit extra margin to the left
set foldcolumn=1

" Set extra options when running in GUI mode: in total: gmrLtaAc
if has("gui_running")
    set guioptions+=aA  "Make selection in all modes available to other applications
    set guioptions+=c   "Console instead of popups for simple choices
    set guioptions-=T   "No Toolbar
    set guioptions-=m   "No menubar
    set guioptions-=e   "Allow non-GUI tab pages lines
    set t_Co=256        "Enable 256 colours
    set guitablabel=%M\ %t  "Set label of GUI tab pages lines (requires e above)
endif

" Remove startup screen message and implement many abbreviations
set shortmess+=filmnrxoOtTI

" Maximise on Startup (for Windows). Can also be done through shortcut options
au GUIEnter * if $OS == "Windows" |
    \   simalt ~x |
    \ endif


""" MAPPINGS """

" Restore Menu bar (use _vimrc reload to remove it: <leader>r)
nmap <leader>m :set guioptions+=m<CR>



"""" 3 - TEXT, FONT AND COLOURS """"""""""""""""""""""""""""""""""""""""""""""""

" Set font and size
if has("gui_gtk2")
    set guifont=Liberation\ Mono\ 14
elseif has("gui_macvim")
    set guifont=Liberation\ Mono\ 14
elseif has("gui_win32")
    set guifont=Lucida_Sans_Typewriter:h18:cANSI
end

" Enable syntax highlighting
syntax on

" Set colourscheme
try
    colorscheme slate
catch
endtry

set background=dark

" Set row number colour (no row highlighting whatsoever)
highlight CursorLine term=NONE cterm=NONE ctermbg=NONE ctermfg=NONE guibg=NONE guifg=NONE
highlight CursorLineNR guifg=Orange ""guibg=Black " No background change
set cursorline


""" MAPPINGS """

" ALL: Enable cursor row highlighting; reload _vimrc to remove (<leader>r)
map <silent> <leader>R :highlight CursorLine guibg=Black<CR>

" ALL: Pressing ,ss will toggle and untoggle spell checking
map <leader>ss :setlocal spell!<CR>

" ALL: Shortcuts using <leader>
map <leader>sn ]s
map <leader>sp [s
map <leader>sa zg
map <leader>s? z=



"""" 4 - USABILITY """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Instead of failing a command because of unsaved changes, instead raise a
" dialogue asking if you wish to save changed files.
set confirm

" Don't redraw while executing macros (good performance config)
set lazyredraw

" No annoying sound on errors i.e. Vim will neither flash nor beep.
set noerrorbells
set novisualbell
" And reset the terminal code for the visual bell.
set t_vb=
set tm=500

" Enable use of the mouse for all modes if possible
if has('mouse')
    set mouse=a
endif

" Quickly time out on keycodes, but never time out on mappings
set notimeout ttimeout ttimeoutlen=200

" Modelines have historically been a source of security vulnerabilities.
" Disable them. A secure script would be:
" http://www.vim.org/scripts/script.php?script_id=1876
set nomodeline

" Turn semi-permanent backups and swapfiles off, but leave backup during writes
set nobackup
set noswapfile
set writebackup

" Make selection of areas with no text possible in visual block mode
set virtualedit=block

" Add angle brackets to matching pairs (like all parentheses)
set matchpairs+=<:>

" Prevents inserting two spaces after punctuation on a join (J)
set nojoinspaces

" Change initial directory. Can also be done through shortcut options
"cd FOLDER


""" MAPPINGS """

" INSERT AND VISUAL: Return to normal mode (Alias of <Esc>).
" Other default on key combinations that will work are:
" Ctrl+[ (English keyboards only) or Ctrl+C.
"inoremap <S-Space> <Esc>
"vnoremap <S-Space> <Esc>

" ALL: \ also enters command mode. It is easier to type.
"   an alternative could have been to map ; and : to each other.
noremap \ :

" INSERT: Abbreviations for short and long dates
iab xdate <c-r>=strftime("%d/%m/%Y")<cr>
iab xldate <c-r>=strftime("%d/%m/%Y %H:%M:%S")<cr>

" ALL: Map Y to act like D and C, i.e. to yank until EOL,
" rather than act as yy, which is the default
map Y y$

" ALL: Smart way to move between windows
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" ALL: Toggle paste mode on and off (mode which does not reformat pastes)
map <leader>pp :setlocal paste!<CR>

" ALL: Quick cut, copy and paste from OS clipboard
noremap  <leader>x "*d
noremap  <leader>c "*y
noremap  <leader>v "*gp

" NORMAL: Fast save
nmap <leader>w :w!<CR>

" VISUAL: Make Backspace delete selection and go in insert mode
vnoremap <BS> di

" VISUAL: Select all shortcut
noremap <leader>a VGo1G

" INSERT: Automatically match parenthesis, square brackets and braces
inoremap  (  ()<Left>
inoremap  [  []<Left>
inoremap  {  {}<Left>

" INSERT: Automatically match quotes
inoremap  '  ''<Left>
inoremap  "  ""<Left>
inoremap  `  ``<Left>

" VISUAL: Same as above but around selection
vnoremap  <leader>(  s()<Esc>P<Right>%
vnoremap  <leader>[  s[]<Esc>P<Right>%
vnoremap  <leader>{  s{}<Esc>P<Right>%

" VISUAL: Same as above but with additional spaces
vnoremap <leader>)  s(  )<Esc><Left>P<Right><Right>%
vnoremap <leader>]  s[  ]<Esc><Left>P<Right><Right>%
vnoremap <leader>}  s{  }<Esc><Left>P<Right><Right>%

" VISUAL: Automatically match quotes around selection
vnoremap <leader>'  s''<Esc>P<Right>
vnoremap <leader>"  s""<Esc>P<Right>
vnoremap <leader>`  s``<Esc>P<Right>



"""" 5 - SEARCH """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Hilight search results
set hlsearch
" Hilight search results as the search is typed
set incsearch

" Use case insensitive search, except when using capital letters
set ignorecase
set smartcase

" For regular expressions turn magic on
set magic


""" MAPPINGS """

" ALL: Map <Space> to / (search) and Ctrl-<Space> to ? (backwards search)
noremap <space> /
noremap <c-space> ?

" NORMAL: Extend previous search query
nnoremap //   /<C-R>/
" Same, but put an or ("|") after it
nnoremap ///  /<C-R>/\<BAR>

" NORMAL: Map Backspace to turn off search highlighting until next search
nnoremap <silent> <BS> :nohl<CR><BS>

" NORMAL AND VISUAL: Shortcut for :s///g
map <leader>sg  :%s//g<Left><Left>

" NORMAL: Highlight all occurrences of the current word without selecting the
" next one. Double-Click has the same effect.
nnoremap <leader>h :let @/='\<<C-R>=expand("<cword>")<CR>\>'<CR>:set hls<CR>
nmap <2-LeftMouse> <leader>h

" NORMAL: Make * and # respect smartcase and also set @/ (to enable 'n' and 'N')
" i.e. Make * and # also generate proper searches.
nmap *  :let @/ = '\<'.expand('<cword>').'\>' ==? @/ ? @/ : '\<'.expand('<cword>').'\>'<CR>n
nmap #  :let @/ = '\<'.expand('<cword>').'\>' ==? @/ ? @/ : '\<'.expand('<cword>').'\>'<CR>N



"""" 6 - INDENTATION """""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" When opening a new line and no filetype-specific indenting is enabled, keep
" the same indent as the line you're currently on
set autoindent

" Automatically indent in nice, obvious places (e.g. after a line ending in { )
set smartindent

" Indentation settings for using 4 spaces instead of tabs.
" Use :retab to convert all tabs in a file under these settings.
set expandtab      " Use spaces instead of tabs
set shiftround     " Always indent/unindent to nearest tabstop
set smarttab       " Behave normally with tabs and backspaces at line beginnings
set shiftwidth=4   " Use indents of 4 spaces
set tabstop=4      " An indentation every four columns
set softtabstop=4  " Let backspace delete indent

" Linebreak on 120 characters for nicer visualisation
set linebreak
set tw=120
" or linebreak/wrap at end of window width
set wrap


""" MAPPINGS """

" Indent/unindent current block
nmap %% $>i}``
nmap $$ $<i}``

" NORMAL, VISUAL: Indent/Unindent a line of text using ALT+[hl]
nmap <A-h> <<Left>
nmap <A-l> ><Right>
vmap <A-h> <<
vmap <A-l> >

" NORMAL, VISUAL: Make Left/Right arrows indent/unindent lines as well
nmap <Left>  <A-h>
nmap <Right> <A-l>
vmap <Left>  <A-h>
vmap <Right> <A-l>

" Make the previous map group work for the Command key on Mac
if $OS == "Mac"
    nmap <D-h> <A-h>
    nmap <D-l> <A-l>
    vmap <D-h> <A-h>
    vmap <D-l> <A-l>
endif



"""" 7 - MOTIONS AND MOVING AROUND """""""""""""""""""""""""""""""""""""""""""""

" Allow specified keys that move the cursor left/right to move to the
" previous/next line when the cursor is on the first/last character in line.
set whichwrap=b,s,h,l,<,>,[,]

" Allow backspacing over autoindent, line breaks and start of insert action
set backspace=indent,eol,start

" Make . # - end of word designators (Just use capital (WORD) commands not to)
set iskeyword-=.
set iskeyword-=#
set iskeyword-=-


""" MAPPINGS """

" ALL: Treat long lines as break lines (useful when moving around in them)
map j gj
map k gk

" NORMAL, VISUAL: Move a line of text using ALT+[jk]
nmap <M-j> mz:m+<CR>`z
nmap <M-k> mz:m-2<CR>`z
vmap <M-j> :m'>+<CR>`<my`>mzgv`yo`z
vmap <M-k> :m'<-2<CR>`>my`<mzgv`yo`z

" NORMAL, VISUAL: Make Up/Down arrows move a line of text as well
nmap <Down> <M-j>
nmap <Up>   <M-k>
vmap <Down> <M-j>
vmap <Up>   <M-k>

" Make the previous map group work for the Command key on Mac
if $OS == "Mac"
    nmap <D-j> <M-j>
    nmap <D-k> <M-k>
    vmap <D-j> <M-j>
    vmap <D-k> <M-k>
endif



"""" 8 - BUFFERS AND TABS """"""""""""""""""""""""""""""""""""""""""""""""""""""

" Specify the behavior when switching between buffers
try
    set switchbuf=useopen,usetab,split,newtab
    " Make tabline always visible
    set stal=2
catch
endtry

" Better Unix / Windows compatibility by saving unix EOL char and path slashes
set viewoptions=folds,options,cursor,unix,slash

" Make session saves save only tabs and help pages (not extra maps and options)
set sessionoptions=tabpages,help
" Restore last session on startup if Vim is invoked without arguments.
autocmd VimLeave * nested if (!isdirectory($HOME . "/.vim")) |
    \ call mkdir($HOME . "/.vim") |
    \ endif |
    \ execute "mksession! " . $HOME . "/.vim/Session.vim"
autocmd VimEnter * nested if argc() == 0 && filereadable($HOME . "/.vim/Session.vim") |
    \ execute "source " . $HOME . "/.vim/Session.vim"


""" MAPPINGS """

" ALL: Show all buffers (with shortcuts) and wait for a shortcut for one
nnoremap <leader>bg :buffers<CR>:buffer<Space>

" ALL: Go to previous, next and last used buffers
nnoremap <Leader>[ :bp<CR>
nnoremap <Leader>] :bn<CR>
nnoremap <Leader>g :e#<CR>

" ALL: Close the current buffer
command! Bclose call <SID>BufcloseCloseIt()
map <silent> <leader>bc :Bclose<CR>

" ALL: Close all the buffers
map <silent> <leader>ba :1,1000 bd!<CR>

" ALL: Useful mappings for managing tabs (use C-PageUp/Down for :tabp/n)
" Open new tab through file search
map <leader>tf :tabfind <Space>
map <silent> <leader>tn :tabnew<CR>
map <silent> <leader>to :tabonly<CR>
map <silent> <leader>tc :tabclose<CR>
map <silent> <leader>t<leader> :tabnext
" Move tab to X position (starting from 0)
map <leader>tm :tabmove<Space>
" NORMAL: Let 'tl' toggle between this and the last accessed tab
let g:lasttab = 1
nmap <leader>tl :exe "tabn ".g:lasttab<CR>
au TabLeave * let g:lasttab = tabpagenr()
" Open a new tab with the current buffer's path
map <leader>te :tabedit <c-r>=expand("%:p:h")<CR>/

" ALL: Switch CWD to the directory of the open buffer
map <leader>cd :cd %:p:h<CR>:pwd<CR>



"""" 9 - OTHER OPTIONS """""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Identify Operating System
if (has('win16') || has('win32') || has('win64'))
    let $OS = "Windows"
elseif has('unix') && !has('macunix') && !has('win32unix')
    let $OS = "Unix"
elseif has('mac') || has('macunix')
    let $OS = "Mac"
endif

" Set shell on non-Windows OS
if $OS != "Windows"
    set shell=/bin/sh
endif

" On Windows, add home/.vim to the runtime path (makes inter-OS sync easier)
if $OS == "Windows"
    set runtimepath^=$HOME/.vim
endif

" Avoid garbled characters in Chinese language Windows OS
let $LANG='en'
set langmenu=en
source $VIMRUNTIME/delmenu.vim
source $VIMRUNTIME/menu.vim


""" MAPPINGS """

" NORMAL: Reload _vimrc file ($real_vimrc set in the real _vimrc)
" Useful to fix almost anything and reactivate settings.
nmap <leader>r :source $real_vimrc | nohl

" NORMAL: Edit real _vimrc file
nmap <leader>real :e $real_vimrc
nmap <leader>repo :e $main_vimrc



"""" 0 - HELPER FUNCTIONS """"""""""""""""""""""""""""""""""""""""""""""""""""""

" Returns true if paste mode is enabled
function! HasPaste()
    if &paste
        return 'PASTE MODE  '
        en
        return ''
endfunction


" Don't close the window when deleting a buffer
function! <SID>BufcloseCloseIt()
    let l:currentBufNum = bufnr("%")
    let l:alternateBufNum = bufnr("#")

    if buflisted(l:alternateBufNum)
        buffer #
        else
        bnext
    endif

    if bufnr("%") == l:currentBufNum
        new
    endif

    if buflisted(l:currentBufNum)
        execute("bdelete! ".l:currentBufNum)
    endif
endfunction

