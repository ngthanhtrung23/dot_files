" nvim python
let g:python3_host_prog = '/opt/salt/bin/python3.7'
" Plugins {{{
" download vim-plug if it's missing
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

Plug 'sheerun/vim-polyglot'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'christoomey/vim-tmux-navigator'
Plug 'vim-airline/vim-airline'
Plug 'chrisbra/csv.vim'
" Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'mileszs/ack.vim'
" Plug 'Glench/Vim-Jinja2-Syntax'
" Plug 'ojroques/vim-oscyank', {'branch': 'main'}  " Does not work over mosh
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
call plug#end()
" }}}

let mapleader=","

" Plugin Settings {{{
" fzf settings - https://github.com/junegunn/fzf.vim {{{
if has('nvim')
    let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6 } }
endif
cabbrev rg Rg

" Only use git files in c-p
"nmap <c-p> :GFiles<CR>
nnoremap <silent> <C-P> :Files<CR>
" }}}

" gitgutter {{{
highlight GitGutterAdd    guifg=#009900 ctermfg=2
highlight GitGutterChange guifg=#bbbb00 ctermfg=3
highlight GitGutterDelete guifg=#ff2222 ctermfg=1
highlight! link SignColumn LineNr
" }}}

" ack {{{
let g:ackprg = 'ag --nogroup --nocolor --column --ignore ENV/'
let g:ackhighlight = 1
cabbrev Ack Ack!
" }}}

" OSC Yank {{{
vnoremap <leader>y :OSCYank<CR>
" }}}
" }}}

" Stuffs that should be set by default: {{{
set nocompatible            " use new features whenever they are available
set nomodeline

syntax on
filetype on
filetype plugin on
filetype plugin indent on
set nu                      " show line number
set tabstop=4
set shiftwidth=4
set autoindent
set expandtab
" Automatically update changed files (but need to focus on the file)
set autoread
set hidden " needed for languageclient

set bg=dark
set softtabstop=4
set bs=2                    " backspace should work as we expect
set history=50              " remember last 50 commands
set ruler                   " show cursor position in bottom line
set hlsearch                " highlight search result
" y and d put stuff into system clipboard (so that other apps can see it)
set clipboard=unnamed,unnamedplus
"set mouse=a                " enable mouse. At least this should work for iTerm
set textwidth=0
" Open new split to right / bottom
set splitbelow
set splitright
set foldlevel=20
" Disable Ex mode.
nnoremap Q <Nop>
" Copy multiple times: gv to reselect and y to copy again.
xnoremap p pgvy
" }}}

" Misc {{{
set autoread                " auto re-read changes outside vim
set autowrite               " auto save before make/execute
set pastetoggle=<F10>
set showcmd
set timeout                 " adjust timeout for mapped commands
set timeoutlen=1200

set visualbell
set noerrorbells
set foldmethod=marker
" }}}

" Display related: {{{
set display+=lastline       " Show everything you can in the last line (intead of stupid @@@)
set display+=uhex           " Show chars that cannot be displayed as <13> instead of ^M
set colorcolumn=72          " For HRT, max width = 72 for commit messages
" }}}

" Searching {{{
set incsearch               " show first match when start typing
set ignorecase              " default should ignore case
set smartcase               " use case sensitive if I use uppercase
" }}}

" Shortcuts {{{
nnoremap <leader>vs :vs <C-R>=expand("%:p:h") . '/' <CR>
" }}}

" netrw {{{
" Hide .swp, .pyc, ENV/, .git/, *.map, *.o
let g:netrw_list_hide= '.*\.swp$,.*\.pyc$,ENV,.git/,.*\.map$,.*\.o$'
" Override netrw settings to show line numbers
let g:netrw_bufsettings = 'noma nomod nu nobl nowrap ro'

" Ctrl-N opens netrw
nnoremap <C-N> :Ex<cr>
" }}}

" vimrc file config {{{
function! VIMSET()
    set foldmethod=marker
    set nowrap
endfunction
autocmd FileType zsh,vim call VIMSET()
" }}}

" csv config {{{
function! CSVSET()
    " Performance optimization
    let g:csv_start = 1
    let g:csv_end = 100

    " Move filtered lines to the end
    " Disabled because it is too slow
    " let g:csv_move_folds = 1

    " Align columns. THIS MODIFIES THE FILE!
    nmap <leader>a ggVG:ArrangeColumn<CR>
    nmap <leader>dc :DeleteColumn<CR>

    set colorcolumn=
    " If there's newline in quote, set following:
    " let g:csv_nl = 1
endfunction
autocmd FileType csv call CSVSET()
" }}}

" C++ config {{{
function! CPPSET()
    " -fsplit-stack for increasing stack size
    nnoremap <buffer> <F8> :w<cr>:!g++-12 -fsplit-stack -Wall -Wextra -Wshadow -O2 % -o %< -std=c++11 -I ./<cr>
endfunction
autocmd FileType cpp call CPPSET()
" }}}

" Auto complete {{{
function! MyTabCompletion()
    if col('.')>1 && strpart( getline('.'), col('.')-2, 3 ) =~ '^\w'
        return "\<C-P>"
    else
        return "\<Tab>"
    endif
endfunction
inoremap <Tab> <C-R>=MyTabCompletion()<CR>
" }}}

" Show filename in tmux panel {{{
autocmd BufEnter,BufReadPost,FileReadPost,BufNewFile * call system("tmux rename-window " . expand('%'))
autocmd VimLeave * call system("tmux rename-window bash")
" }}}
