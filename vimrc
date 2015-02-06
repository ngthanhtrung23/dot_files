" -----------------------------------------------------------------------------
" Plugins: {{{
set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle
Plugin 'gmarik/Vundle.vim'

" My plugins
Bundle 'Lokaltog/powerline', {'rtp': 'powerline/bindings/vim/'}
Bundle 'Yggdroot/indentLine'
"Bundle 'Lokaltog/vim-easymotion'
Bundle 'scrooloose/syntastic'
Bundle 'scrooloose/nerdtree'
Bundle 'tpope/vim-surround'
Bundle 'nanotech/jellybeans.vim'
Bundle 'kien/ctrlp.vim'
Bundle 'airblade/vim-gitgutter'
Bundle 'tpope/vim-fugitive'
"Bundle 'mileszs/ack.vim'
"Bundle 'vsushkov/nerdtree-ack'
Bundle 'ngthanhtrung23/vim-markdown'
Bundle 'ngthanhtrung23/vim-comment'
"Bundle 'Valloric/YouCompleteMe'

call vundle#end()
filetype plugin indent on
" }}}

" Plugin settings: {{{
" Syntastic
let g:syntastic_cpp_compiler = 'g++-4.9'
let g:syntastic_cpp_compiler_options = ' -std=c++11'
" powerline
set rtp+=$HOME/.local/lib/python2.7/site-packages/powerline/bindings/vim/
set laststatus=2
set t_Co=256
" nerdtree
map <C-n> :NERDTreeToggle<CR>
autocmd WinEnter * call s:CloseIfOnlyNerdTreeLeft()
let NERDTreeIgnore = ['\.pyc$', '\.class$']

" indentLine
let g:indentLine_color_term = 237
let g:indentLine_char = '┆'

" Close all open buffers on entering a window if the only
" buffer that's left is the NERDTree buffer
function! s:CloseIfOnlyNerdTreeLeft()
  if exists("t:NERDTreeBufName")
    if bufwinnr(t:NERDTreeBufName) != -1
      if winnr("$") == 1
        q
      endif
    endif
  endif
endfunction
" ctrlp
map <C-p> :CtrlP<CR><F5>
" jellybeans
set background=dark
color jellybeans  " set background=dark for other machine, but use jellybeans in my computer
" }}}

" -----------------------------------------------------------------------------
" Stuffs that should be set by default: {{{
syntax on
set nocompatible  " use new features whenever they are available
set bs=2          " backspace should work as we expect
set autoindent    " 
set history=50    " remember last 50 commands
set ruler         " show cursor position in bottom line
set nu            " show line number
set hlsearch      " highlight search result
" y and d put stuff into system clipboard (so that other apps can see it)
set clipboard=unnamed,unnamedplus
set mouse=a       " enable mouse. At least this should work for iTerm
" }}}

" Shortcuts

" Tab related stuffs: {{{
set shiftwidth=4  " tab size = 4
set expandtab
set softtabstop=4
set shiftround    " when shifting non-aligned set of lines, align them to next tabstop
" }}}

" Misc {{{
set autoread      " auto re-read changes outside vim
set autowrite     " auto save before make/execute
set pastetoggle=<F10>
" The following line is disabled to make powerline work
" set showcmd
set timeout       " adjust timeout for mapped commands
set timeoutlen=200

set visualbell    " Tell vim to shutup
set noerrorbells  " Tell vim to shutup!
" }}}

" Display related: {{{
set display+=lastline " Show everything you can in the last line (intead of stupid @@@)
set display+=uhex     " Show chars that cannot be displayed as <13> instead of ^M
" }}}

" Searching {{{
set incsearch     " show first match when start typing
set ignorecase    " default should ignore case
set smartcase     " use case sensitive if I use uppercase
" }}}

" -----------------------------------------------------------------------------
" <Tab> at the end of a word should attempt to complete it using tokens from the current file: {{{
function! MyTabCompletion()
  if col('.')>1 && strpart( getline('.'), col('.')-2, 3 ) =~ '^\w'
    return "\<C-P>"
  else
    return "\<Tab>"
  endif
endfunction
inoremap <Tab> <C-R>=MyTabCompletion()<CR>
" }}}

" -----------------------------------------------------------------------------
" Specific settings for specific filetypes:  {{{

" usual policy: if there is a Makefile present, :mak calls make, otherwise we define a command to compile the filetype

" LaTeX
function! TEXSET()
  set makeprg=if\ \[\ -f\ \"Makefile\"\ \];then\ make\ $*;else\ if\ \[\ -f\ \"makefile\"\ \];then\ make\ $*;else\ pdfcslatex\ -file-line-error-style\ %;fi;fi
  set textwidth=0
  set nowrap
endfunction

" C/C++:
function! CSET()
  set makeprg=if\ \[\ -f\ \"Makefile\"\ \];then\ make\ $*;else\ if\ \[\ -f\ \"makefile\"\ \];then\ make\ $*;else\ gcc\ -O2\ -g\ -Wall\ -Wextra\ -o%.bin\ %\ -lm;fi;fi
  set cindent
  set textwidth=0
  set nowrap
endfunction

function! CPPSET()
  set makeprg=if\ \[\ -f\ \"Makefile\"\ \];then\ make\ $*;else\ if\ \[\ -f\ \"makefile\"\ \];then\ make\ $*;else\ g++\ -std=gnu++0x\ -O2\ -g\ -Wall\ -Wextra\ -o\ %<\ %;fi;fi
  set cindent
  set textwidth=0
  set nowrap
  nnoremap <buffer> <F9> :w<cr>:!g++-4.9 % -o %< -std=c++11 -I ./<cr>:!clear;./%<<cr>
  nnoremap <buffer> <F8> :w<cr>:!g++-4.9 % -o %< -std=c++11 -I ./<cr>
endfunction

" Java
function! JAVASET()
  set makeprg=if\ \[\ -f\ \"Makefile\"\ \];then\ make\ $*;else\ if\ \[\ -f\ \"makefile\"\ \];then\ make\ $*;else\ javac\ -g\ %;fi;fi
  set cindent
  set textwidth=0
  set nowrap
  nnoremap <buffer> <F8> :w<cr>:!javac %<cr>
  nnoremap <buffer> <F9> :w<cr>:!javac %<cr>:!clear;java %< %<cr>
endfunction

" vim scripts
function! VIMSET()
  set textwidth=0
  set nowrap
  set tabstop=2
  set softtabstop=2
  set shiftwidth=2
  set comments+=b:\"
endfunction

" Makefile
function! MAKEFILESET()
  set textwidth=0
  set nowrap
  " in a Makefile we need to use <Tab> to actually produce tabs
  set noexpandtab
  set softtabstop=8
  iunmap <Tab>
endfunction

" HTML/PHP
function! HTMLSET()
  set textwidth=0
  set nowrap
endfunction

" Python
function! PYSET()
  set textwidth=0
  set nowrap
  nnoremap <buffer> <F9> :w<cr>:exec '!clear;python' shellescape(@%, 1)<cr>
  " Docstring should be highlighted as comment
  syn region pythonDocstring  start=+^\s*[uU]\?[rR]\?"""+ end=+"""+ keepend excludenl contains=pythonEscape,@Spell,pythonDoctest,pythonDocTest2,pythonSpaceError
  syn region pythonDocstring  start=+^\s*[uU]\?[rR]\?'''+ end=+'''+ keepend excludenl contains=pythonEscape,@Spell,pythonDoctest,pythonDocTest2,pythonSpaceError
  hi  link   pythonDocstring  Comment
endfunction

" Ruby
function! RUBYSET()
  set autoindent!
  set noexpandtab!
  set tabstop=2
  set softtabstop=2
  set shiftwidth=2
  set expandtab

  " I prefer using same highlight for Ruby string and Ruby symbol
  hi clear rubySymbol
  hi link  rubySymbol String

  " Some simple highlight for Capybara
  syn keyword rubyRailsTestMethod feature scenario before after 
  hi link rubyRailsTestMethod Function

  nnoremap <buffer> <F9> :w<cr>:exec '!clear;ruby' shellescape(@%, 1)<cr>
  nnoremap <buffer> <F8> :w<cr>:exec '!clear;rspec' shellescape(@%, 1)<cr>
endfunction

" SQL
function! SQLSET()
  syn keyword sqlStatement use describe
  nnoremap <buffer> <F9> :!clear;mysql -u root -p test < %<cr>
endfunction

" BASH
function! BASHSET()
  syn keyword shStatement mkdir cp
  nnoremap <buffer> <F9> :!clear;./%<cr>
endfunction

" Autocommands for all languages:
autocmd FileType vim    call VIMSET()
autocmd FileType c      call CSET()
autocmd FileType C      call CPPSET()
autocmd FileType cc     call CPPSET()
autocmd FileType cpp    call CPPSET()
autocmd FileType java   call JAVASET()
autocmd FileType tex    call TEXSET()
autocmd FileType make   call MAKEFILESET()
autocmd FileType html   call HTMLSET()
autocmd FileType php    call HTMLSET()
autocmd FileType python call PYSET()
autocmd FileType ruby   call RUBYSET()
autocmd FileType sql    call SQLSET()
autocmd FileType sh     call BASHSET()
" }}}

