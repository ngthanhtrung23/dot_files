" -----------------------------------------------------------------------------
" Plugins: {{{
set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle
Plugin 'gmarik/Vundle.vim'
" My plugins
Bundle 'bling/vim-airline'
Bundle 'vim-airline/vim-airline-themes'
"Bundle 'Yggdroot/indentLine'
Bundle 'scrooloose/syntastic'
Bundle 'tpope/vim-surround'
Bundle 'nanotech/jellybeans.vim'
Bundle 'ctrlpvim/ctrlp.vim'
Bundle 'airblade/vim-gitgutter'
Bundle 'tpope/vim-fugitive'
Bundle 'derekwyatt/vim-scala'
Bundle 'hdima/python-syntax'
Bundle 'ngthanhtrung23/vim-markdown'
Bundle 'ngthanhtrung23/vim-comment'
Bundle 'ngthanhtrung23/vim-extended-bash'
Bundle 'Valloric/YouCompleteMe'
Bundle 'junegunn/vim-easy-align'
Bundle 'mileszs/ack.vim'
Bundle 'christoomey/vim-tmux-navigator'
Bundle 'tpope/vim-repeat'
Bundle 'yegappan/mru'
Bundle 'embear/vim-localvimrc'
Bundle 'leafgarland/typescript-vim'

call vundle#end()
filetype plugin indent on
" }}}

" Plugin settings: {{{
" netrw
" Hide .swp, .pyc, ENV/, .git/, *.map
let g:netrw_list_hide= '.*\.swp$,.*\.pyc,ENV,.git/,.*\.map'
" Override netrw settings to show line numbers
let g:netrw_bufsettings = 'noma nomod nu nobl nowrap ro'

" vim-airlien
function! AirlineInit()
	let g:airline_mode_map = {
				\ '__' : '-',
				\ 'n' : 'N',
				\ 'i' : 'I',
				\ 'R' : 'R',
				\ 'c' : 'C',
				\ 'v' : 'V',
				\ 'V' : 'V',
				\ 's' : 'S',
				\ 'S' : 'S',
				\ }
	let g:airline_left_sep = ''
	let g:airline_left_alt_sep= ''
	let g:airline_right_sep = ''
	let g:airline_right_alt_sep = ''
	let g:airline_section_a = airline#section#create(['mode'])
	let g:airline_section_b = airline#section#create(['%f'])
	let g:airline_section_c = airline#section#create([''])
	let g:airline_section_x = airline#section#create_right([''])
	let g:airline_section_y = airline#section#create_right([''])
	let g:airline_section_z = airline#section#create_right(['%l %c'])
	AirlineToggleWhitespace
	AirlineTheme jellybeans
endfunction
autocmd VimEnter * call AirlineInit()
" ack.vim
let g:ackprg = 'ag --nogroup --nocolor --column'
let g:ackhighlight = 1
cabbrev Ack Ack!

" vim-easy-align
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" YouCompleteMe
let mapleader=","
let g:ycm_autoclose_preview_window_after_completion = 1		 " Auto close preview tab
let g:ycm_goto_buffer_command = 'vertical-split'						" Goto definition in new split
nnoremap <leader>jd :YcmCompleter GoTo<CR>
let g:ycm_key_list_select_completion = ['<TAB>', '<Down>']
let g:ycm_collect_identifiers_from_tags_files = 1					 " Let YCM read tags from Ctags file
let g:ycm_use_ultisnips_completer = 1											 " Default 1, just ensure
let g:ycm_seed_identifiers_with_syntax = 1									" Completion for programming language's keyword
let g:ycm_complete_in_comments = 1													" Completion in comments
let g:ycm_complete_in_strings = 1													 " Completion in string
" Syntastic
let g:syntastic_cpp_compiler = 'g++-4.9'
let g:syntastic_cpp_compiler_options = ' -std=c++11'
let g:syntastic_disabled_filetypes=['markdown'] " Disable for markdown files
" Ignore some rules broken by Garena codebase
let g:syntastic_python_flake8_args = "--ignore=W191,W293,E101,E126,E127,E128,E221,E226,E227,E228,E231,E241,E261,E262,E265,E272,E301,E302,E501"

set laststatus=2
set t_Co=256

" indentLine
let g:indentLine_color_term = 237
let g:indentLine_char = '┆'

" ctrlp
map <C-p> :CtrlP<CR><F5>
let g:ctrlp_custom_ignore = {
	\ 'dir': '\v[\/]\.(git|hg|svn)$',
	\ 'file': '\v\.(pyc|swp)$',
	\ 'link': '',
	\ }
" ctrlp should ignore things in .gitignore
let g:ctrlp_user_command = ['.git/', 'git --git-dir=%s/.git ls-files -oc --exclude-standard']

" jellybeans
set background=dark
color jellybeans	" set background=dark for other machine, but use jellybeans in my computer
" }}}

" vim-localvimrc
let g:localvimrc_whitelist='/home/rr/Code/\(rr-heart\|angular2-quickstart\)'

" -----------------------------------------------------------------------------
" Stuffs that should be set by default: {{{
syntax on
set softtabstop=4
set tabstop=4
set expandtab
set shiftwidth=4
set nocompatible	" use new features whenever they are available
set bs=2					" backspace should work as we expect
set autoindent
set history=50		" remember last 50 commands
set ruler				  " show cursor position in bottom line
set nu						" show line number
set hlsearch			" highlight search result
" y and d put stuff into system clipboard (so that other apps can see it)
set clipboard=unnamed,unnamedplus
"set mouse=a			 " enable mouse. At least this should work for iTerm
set textwidth=0
" Open new split to right / bottom
set splitbelow
set splitright
" Automatically update changed files (but need to focus on the file)
set autoread
set foldmethod=indent
set foldlevel=20
" }}}

" Shortcuts

" Tab related stuffs: {{{
"set tabstop=4
"set shiftwidth=4	" tab size = 4
"set noexpandtab
"set autoindent
"set softtabstop=4
"set shiftround		" when shifting non-aligned set of lines, align them to next tabstop
" }}}

" Misc {{{
set autoread			" auto re-read changes outside vim
set autowrite		 " auto save before make/execute
set pastetoggle=<F10>
set showcmd
set timeout			 " adjust timeout for mapped commands
set timeoutlen=1200

set visualbell		" Tell vim to shutup
set noerrorbells	" Tell vim to shutup!
" }}}

" Display related: {{{
set display+=lastline " Show everything you can in the last line (intead of stupid @@@)
set display+=uhex		 " Show chars that cannot be displayed as <13> instead of ^M
" }}}

" Searching {{{
set incsearch		 " show first match when start typing
set ignorecase		" default should ignore case
set smartcase		 " use case sensitive if I use uppercase
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
" Specific settings for specific filetypes:	{{{

" usual policy: if there is a Makefile present, :mak calls make, otherwise we define a command to compile the filetype

" LaTeX
function! TEXSET()
	set makeprg=if\ \[\ -f\ \"Makefile\"\ \];then\ make\ $*;else\ if\ \[\ -f\ \"makefile\"\ \];then\ make\ $*;else\ pdfcslatex\ -file-line-error-style\ %;fi;fi
	set nowrap
endfunction

" C/C++:
function! CSET()
	set makeprg=if\ \[\ -f\ \"Makefile\"\ \];then\ make\ $*;else\ if\ \[\ -f\ \"makefile\"\ \];then\ make\ $*;else\ gcc\ -O2\ -g\ -Wall\ -Wextra\ -o%.bin\ %\ -lm;fi;fi
	set cindent
	set nowrap
endfunction

function! CPPSET()
	set makeprg=if\ \[\ -f\ \"Makefile\"\ \];then\ make\ $*;else\ if\ \[\ -f\ \"makefile\"\ \];then\ make\ $*;else\ g++\ -std=gnu++0x\ -O2\ -g\ -Wall\ -Wextra\ -o\ %<\ %;fi;fi
	set cindent
	set nowrap
	nnoremap <buffer> <F9> :w<cr>:!g++ -O2 % -o %< -std=c++11 -I ./<cr>:!./%<<cr>
	nnoremap <buffer> <F8> :w<cr>:!g++ -O2 % -o %< -std=c++11 -I ./<cr>
endfunction

" Java
function! JAVASET()
	set makeprg=if\ \[\ -f\ \"Makefile\"\ \];then\ make\ $*;else\ if\ \[\ -f\ \"makefile\"\ \];then\ make\ $*;else\ javac\ -g\ %;fi;fi
	set cindent
	set nowrap
	nnoremap <buffer> <F8> :w<cr>:!javac %<cr>
	nnoremap <buffer> <F9> :w<cr>:!javac %<cr>:!java %< %<cr>
endfunction

" vim scripts
function! VIMSET()
	set nowrap
	set tabstop=2
	set softtabstop=2
	set shiftwidth=2
endfunction

" Makefile
function! MAKEFILESET()
	set nowrap
	" in a Makefile we need to use <Tab> to actually produce tabs
	set noexpandtab
	set softtabstop=8
	iunmap <Tab>
endfunction

" HTML/PHP
function! HTMLSET()
	set tabstop=2
	set softtabstop=2
	set autoindent
	set noexpandtab
	set shiftwidth=2
	set nowrap
endfunction

" Python
function! PYSET()
	if exists('g:no_pyset')
		return
	endif
	set nowrap

	set autoindent
	set noexpandtab
	set shiftwidth=4
	set tabstop=4
	nnoremap <buffer> <F9> :w<cr>:exec '!clear;python' shellescape(@%, 1)<cr>
	" Docstring should be highlighted as comment
	syn region pythonDocstring	start=+^\s*[uU]\?[rR]\?"""+ end=+"""+ keepend excludenl contains=pythonEscape,@Spell,pythonDoctest,pythonDocTest2,pythonSpaceError
	syn region pythonDocstring	start=+^\s*[uU]\?[rR]\?'''+ end=+'''+ keepend excludenl contains=pythonEscape,@Spell,pythonDoctest,pythonDocTest2,pythonSpaceError
	hi	link	 pythonDocstring	Comment
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
"	hi clear rubySymbol
"	hi link	rubySymbol String

	" Some simple highlight for Capybara
	syn keyword rubyRailsTestMethod feature scenario before after
	hi link rubyRailsTestMethod Function

	nnoremap <buffer> <F9> :w<cr>:exec '!clear;ruby' shellescape(@%, 1)<cr>
	nnoremap <buffer> <F8> :w<cr>:exec '!clear;rspec' shellescape(@%, 1)<cr>
endfunction

" Beautify JSON
nmap =j :%!python -m json.tool<CR>

" SQL
function! SQLSET()
	syn keyword sqlStatement use describe
	nnoremap <buffer> <F9> :!clear;mysql -u root -p test < %<cr>
endfunction

" Autocommands for all languages:
autocmd BufNewFile,BufReadPost *.py2 set filetype=python
autocmd FileType vim        call VIMSET()
autocmd FileType c          call CSET()
autocmd FileType C          call CPPSET()
autocmd FileType cc         call CPPSET()
autocmd FileType cpp        call CPPSET()
autocmd FileType java       call JAVASET()
autocmd FileType tex        call TEXSET()
autocmd FileType make       call MAKEFILESET()
autocmd FileType html       call HTMLSET()
autocmd FileType php        call HTMLSET()
autocmd FileType python     call PYSET()
autocmd FileType ruby       call RUBYSET()
autocmd FileType sql        call SQLSET()
au BufRead,BufNewFile *.handlebars,*.hbs set ft=html syntax=handlebars
" }}}

nnoremap <leader>e :e <C-R>=expand("%:p:h") . '/' <CR>
nnoremap <leader>vs :vs <C-R>=expand("%:p:h") . '/' <CR>
nnoremap <C-N> :Ex<cr>

" Disable ~ when inside tmux, as Ctrl + PageUp/Down are translated to 5~
if &term =~ '^screen'
	map ~ <Nop>
endif

" Show filename in tmux panel
autocmd BufEnter,BufReadPost,FileReadPost,BufNewFile * call system("tmux rename-window " . expand('%'))
autocmd VimLeave * call system("tmux rename-window bash")

" Hack to make bg black with jellybeans
hi Normal ctermbg=none
hi LineNr ctermbg=none
hi NonText ctermbg=none
