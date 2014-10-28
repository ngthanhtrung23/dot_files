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
" Bundle 'Lokaltog/vim-easymotion'
Bundle 'scrooloose/syntastic'
Bundle 'scrooloose/nerdtree'
Bundle 'tpope/vim-surround'
Bundle 'nanotech/jellybeans.vim'
Bundle 'kien/ctrlp.vim'
Bundle 'airblade/vim-gitgutter'
Bundle 'tpope/vim-fugitive'
Bundle 'mileszs/ack.vim'
Bundle 'vsushkov/nerdtree-ack'

call vundle#end()
filetype plugin indent on
" }}}

" Plugin settings: {{{
" Syntastic
let g:syntastic_cpp_compiler = 'clang++'
let g:syntastic_cpp_compiler_options = ' -std=c++11 -stdlib=libc++'
" powerline
set rtp+=$HOME/.local/lib/python2.7/site-packages/powerline/bindings/vim/
set laststatus=2
set t_Co=256
" nerdtree
map <C-n> :NERDTreeToggle<CR>
" ctrlp
map <C-p> :CtrlP<CR>
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
function! My_Tab_Completion()
    if col('.')>1 && strpart( getline('.'), col('.')-2, 3 ) =~ '^\w'
        return "\<C-P>"
    else
        return "\<Tab>"
endfunction
inoremap <Tab> <C-R>=My_Tab_Completion()<CR>
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
  nnoremap <buffer> <F9> :w<cr>:!clang++ % -o %< -std=c++11 -stdlib=libc++ -I ./<cr>:!./%<<cr>
  nnoremap <buffer> <F8> :w<cr>:!clang++ % -o %< -std=c++11 -stdlib=libc++ -I ./<cr>
  nnoremap <C-c> ^i// <esc>
endfunction

" Java
function! JAVASET()
  set makeprg=if\ \[\ -f\ \"Makefile\"\ \];then\ make\ $*;else\ if\ \[\ -f\ \"makefile\"\ \];then\ make\ $*;else\ javac\ -g\ %;fi;fi
  set cindent
  set textwidth=0
  set nowrap
  nnoremap <buffer> <F9> :!javac %<cr>:!java %< %<cr>
  nnoremap <C-c> ^i// <esc>
endfunction

" vim scripts
function! VIMSET()
  set textwidth=0
  set nowrap
  set tabstop=2
  set softtabstop=2
  set shiftwidth=2
  set comments+=b:\"
  nnoremap <C-c> ^i" <esc>
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
  nnoremap <buffer> <F9> :exec '!python' shellescape(@%, 1)<cr>
  nnoremap <C-c> ^i# <esc>
endfunction

" Ruby
function! RUBYSET()
  set autoindent!
  set noexpandtab!
  set tabstop=2
  set softtabstop=2
  set shiftwidth=2
  set expandtab
  nnoremap <buffer> <F9> :exec '!ruby' shellescape(@%, 1)<cr>
  nnoremap <buffer> <F8> :exec '!rspec' shellescape(@%, 1)<cr>
  nnoremap <C-c> ^i# <esc>
endfunction

" Markdown
function! TextEnableCodeSnip(filetype,start,end,textSnipHl) abort
  let ft=toupper(a:filetype)
  let group='textGroup'.ft
  if exists('b:current_syntax')
    let s:current_syntax=b:current_syntax
    " Remove current syntax definition, as some syntax files (e.g. cpp.vim)
    " do nothing if b:current_syntax is defined.
    unlet b:current_syntax
  endif
  execute 'syntax include @'.group.' syntax/'.a:filetype.'.vim'
  try
    execute 'syntax include @'.group.' after/syntax/'.a:filetype.'.vim'
  catch
  endtry
  if exists('s:current_syntax')
    let b:current_syntax=s:current_syntax
  else
    unlet b:current_syntax
  endif
  execute 'syntax region textSnip'.ft.'
  \ matchgroup='.a:textSnipHl.'
  \ start="'.a:start.'" end="'.a:end.'"
  \ contains=@'.group
endfunction

function! MARKDOWNSET()
  set wrap
  " I hate markdown highlight which does not allow mathjax $...$ and code --> create my own here
  " Many of the following are copied from vim-markdown/syntax/mkd.vim (https://github.com/plasticboy/vim-markdown/blob/master/syntax/mkd.vim)
  set ft=tex

  " HTML headings
  syn region htmlH1       start="^\s*#"                   end="\($\|#\+\)" contains=@Spell
  syn region htmlH2       start="^\s*##"                  end="\($\|#\+\)" contains=@Spell
  syn region htmlH3       start="^\s*###"                 end="\($\|#\+\)" contains=@Spell
  syn region htmlH4       start="^\s*####"                end="\($\|#\+\)" contains=@Spell
  syn region htmlH5       start="^\s*#####"               end="\($\|#\+\)" contains=@Spell
  syn region htmlH6       start="^\s*######"              end="\($\|#\+\)" contains=@Spell
  syn match  htmlH1       /^.\+\n=\+$/ contains=@Spell
  syn match  htmlH2       /^.\+\n-\+$/ contains=@Spell

  " List
  syn match  mkdListItem   "^\s*[-*+]\s\+"
  syn match  mkdListItem   "^\s*\d\+\.\s\+"
  hi link mkdListItem      Identifier

  " Link
  syn region mkdFootnotes matchgroup=mkdDelimiter start="\[^"      end="\]"
  syn region mkdID matchgroup=mkdDelimiter        start="\["       end="\]" contained oneline
  syn region mkdURL matchgroup=mkdDelimiter       start="("        end=")"  contained oneline
  syn region mkdLink matchgroup=mkdDelimiter      start="\\\@<!\[" end="\]\ze\s*[[(]" contains=@Spell nextgroup=mkdURL,mkdID skipwhite oneline
  hi link mkdLink          htmlLink
  hi link mkdURL           htmlString

  " Code
  syn region mkdCode       start=/^\s*```\s*[0-9A-Za-z_-]*\s*$/    end=/^\s*```\s*$/  contains=@CPP
  hi link mkdCode          String

  call TextEnableCodeSnip('cpp', '```cpp', '```', 'SpecialComment')
  call TextEnableCodeSnip('java', '```java', '```', 'SpecialComment')
endfunction

" Identify Markdown files
autocmd BufNewFile,BufReadPost *.md set filetype=markdown

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
autocmd Filetype markdown call MARKDOWNSET()
" }}}

