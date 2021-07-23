"*************************************************
" Highlight                                      "
"*************************************************
set expandtab
set ruler
set sw=2 
set ts=2
set mouse=a
set nu
set smartindent
set noswapfile
set scrolloff=5
set cuc
set cul
set isfname+={,$,}
set hlsearch
set visualbell
":hi StatusLine ctermbg=6 ctermfg=2
"inoremap ( ()<left>
"inoremap [ []<left>
"inoremap { {}<left>
"inoremap {{ {<enter><enter>}<up><end>
"inoremap " ""<left>
"inoremap ' ''<left>
"inoremap begin begin<enter><enter>end<up><end>

inoremap <tab> <c-r>=CleverTab()<cr>
inoremap <s-tab> <c-r>=CleverBackTab()<cr>
nnoremap <c-j> <c-d>
nnoremap <c-k> <c-u>
vmap zy :w! ~/tmp/vitmp<CR>
nmap zp :r ~/tmp/vitmp<CR>
:au BufNewFile,BufRead *.src            setf asm
:au BufNewFile,BufRead *.equ            setf asm
:au BufNewFile,BufRead *.def            setf asm
:au BufNewFile,BufRead *.lis            setf asm
:au BufNewFile,BufRead *.inc            setf asm

:au BufNewFile,BufRead *.src,*.lis,*.h,*.H    setf asm
:au BufNewFile,BufRead *.src,*.lis,*.h,*.H     set  ts=2

:au BufNewFile,BufRead *log.stacheck*   setf verilog
:au BufNewFile,BufRead *.V              setf verilog
:au BufNewFile,BufRead *.sv             setf verilog
:au BufNewFile,BufRead *.svh            setf verilog

:au BufNewFile,BufRead *.io             setf verilog
:au BufNewFile,BufRead *.io             set  ts=5
:au BufNewFile,BufRead *.io             set  nowrap

au BufNewFile,BufRead   *.mycshrc call Csh()
"C Shell
 function! Csh()
 set filetype=csh
 endfunction


" An example for a vimrc file.
"
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last change:	2006 Aug 12
"
" To use it, copy it to
"     for Unix and OS/2:  ~/.vimrc
"	      for Amiga:  s:.vimrc
"  for MS-DOS and Win32:  $VIM\_vimrc
"	    for OpenVMS:  sys$login:.vimrc

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
	"set backup		" keep a backup file ?????????????????????????????????????
endif
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching
set ts=3
" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq
nmap hf <C-w>f
nmap vf <C-w>vgf

" In an xterm the mouse should work quite well, thus enable it.
"set mouse=i

" This is an alternative that also works in block mode, but the deleted
" text is lost and it only works for putting the current register.
"vnoremap p "_dp

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
"if &t_Co > 2 || has("gui_running")
"  syntax on
"  set hlsearch
"endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  augroup END

else

"  set autoindent		" always set autoindenting on

endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
	 	\ | wincmd p | diffthis
" User set
"set nu
"set ft=asm

function! CleverTab()
   if strpart( getline('.'), col('.')-2, 1 ) =~ '[a-zA-Z0-9_]'
       return "\<C-N>"
   else
       set ts=2
       return "\<Tab>"
   endif
endfunction

au BufNewFile,BufRead   *.v     call Verilog()

function! Verilog()
   set filetype=verilog
   let $date = strftime("%Y-%m-%d")
   noremap <F5>    :s/^/<USER_NAME># /<CR>:exe "normal I//#" . $date . 
" "<CR>
     noremap <F6>    :exe "normal A      //#" . $date .
"<CR>:s/$/<USER_NAME>#/<CR>
     endfunction

function! CleverBackTab()
   if strpart( getline('.'), col('.')-2, 1 ) =~ '[a-zA-Z0-9_]'
       return "\<C-P>"
   endif
endfunction 

"Verilog Tracing
"Setup : Include into $HOME/.vimrc
"H.L @ RVC
nmap <silent> <F3> :call Vswitch("w")<CR>
nmap <silent> <F4> :call Vswitch("t")<CR>

fun! Vswitch(type)
	if &ft == "verilog"
		call Vwhereami(a:type)
	else
		call Vjump2Module(a:type)
	endif
endfunction

fun! Vwhereami(type)
	let s:modstart=search('^\s*module\s','bnW')
	let s:line=getline(s:modstart)
	let s:modname=substitute(s:line,'^\s*module\s\+\(\w\+\).*',"\\1","")
	if s:modname==""
		echo "Error: blank module name"
	else
		highlight VerilogTrace ctermbg=green guibg=green 
		if a:type=="w"
			wincmd p
		elseif a:type=="t"
			tabnext
		endif
		exec "match VerilogTrace /" . s:modname . "/" 
		call search("(" . s:modname . ")","w") 
		if a:type=="w"
			wincmd p
		elseif a:type=="t"
			"tabnext	"In case of tabpage, no return
		endif
	endif
endfunction

fun! Vjump2Module(type)
	let s:modname=substitute(getline("."),'^.\+(\(\w\+\)).*',"\\1","")
	if s:modname==""
		echo "Error: blank module name"
	else
		if a:type=="w"
			wincmd p
		elseif a:type=="t"
			tabnext
		endif
		let s:save_last_search = @/
		call search("^\s*module \s*" . s:modname,"w")
		let @/ = s:save_last_search
	endif
endfunction

"name       SetMouse
""Function   Enable/Disable mouse
":function! SetMouse()
":if &mouse =~ "a"
":  set mouse=i
":  echo "mouse=i"
":else
":  set mouse=a
":  echo "mouse=a"
":endif
":endfunction
"map m :call SetMouse()<CR>


"Set wrap
nmap <silent> <F7> :set wrap<CR>
nmap <silent> <F8> :set nowrap<CR>

"name       SetColor
""Function   Change vimdiff color
":function! SetColor()
":se t_Co=256 
":endfunction
"map sc :call SetColor()<CR>

"ThanhTN
map M \m   |"mark object
map <C-m> \*   |"search object
"hi DiffText term=underline  ctermbg=LightGrey ctermfg=Yellow guibg=Grey90
hi DiffChange term=underline cterm=bold ctermfg=0 ctermbg=225 guibg=LightGrey
"hi DiffAdd term=underline ctermfg=0 ctermbg=LightGrey
"hi CursorColumn term=reverse ctermbg=7 guibg=Grey90
"hi CursorLine ctermbg=7 cterm=none


"___________________________________________

"           HIGHLIGHT

"___________________________________________

 

          " Use "hi" to display highlightghlight group

          " Color for diff

          se t_Co=256

          highlight DiffText term=reverse cterm=bold,underline ctermfg=0 ctermbg=white
          highlight DiffAdd  term=standout ctermfg=0 ctermbg=11 guifg=Black guibg=Yellow

 

          " Color for Search

          "highlight Search term=reverse ctermbg=14

          highlight Search term=reverse ctermbg=red

         " highlight Search term=reverse ctermbg=red

 

          " Color for cursorline

         highlight CursorLine    cterm=NONE ctermbg=238

         highlight CursorColumn  cterm=none  ctermbg=238

          "se Cursorline

 

          " Color for syntax highlight

          syntax on

 

  

          " SystemC highlight

          "autocmd BufRead,BufNewFile *.cpp se ft=systemc


" ===============================================
" Auto detect file type"
" ===============================================
au BufNewFile,BufRead   *.sh	    set filetype=csh
au BufNewFile,BufRead   *.src	    set filetype=asm
au BufNewFile,BufRead   *.cpp	    set filetype=verilog
au BufNewFile,BufRead   *.h	      set filetype=verilog
au BufNewFile,BufRead   *.list    set filetype=verilog
au BufNewFile,BufRead   *.lis	    set filetype=verilog
au BufNewFile,BufRead   *.tbl	    set filetype=asm
au BufNewFile,BufRead   *.pat	    set filetype=verilog
au BufNewFile,BufRead   *.v	      set filetype=verilog
au BufNewFile,BufRead   *.V	      set filetype=verilog
au BufNewFile,BufRead   *.sv	    set filetype=verilog
au BufNewFile,BufRead   *.txt	    set filetype=csh
au BufNewFile,BufRead   *.rpt	    set filetype=verilog
au BufNewFile,BufRead   *.LIST    set filetype=conf
au BufNewFile,BufRead   *.ptsc    set filetype=tcl
au BufNewFile,BufRead   *.l	      set filetype=data
au BufNewFile,BufRead   *.vimrc   set filetype=vim
au BufNewFile,BufRead   *.log	    set filetype=verilog

au BufNewFile,BufRead   *.io		  set filetype=verilog
au BufRead,BufNewFile   *#c_*,*#h_*		        set filetype=c
au BufRead,BufNewFile   *.v,*.vh,*.sv,*.svh,*#sv_*		set filetype=verilog_systemverilog
set ttymouse=xterm2     " set to prevent VIM hang up in screen

" au BufNewFile,BufRead   *.rpt      set filetype=cpp
" au BufNewFile,BufRead   *.src      set filetype=asm
" au BufNewFile,BufRead   *.list     set filetype=asm
" au BufNewFile,BufRead   *.lis      set filetype=asm
" au BufNewFile,BufRead   *.in       set filetype=cpp
" au BufNewFile,BufRead   *.cpp      set filetype=cpp
" au BufNewFile,BufRead   *.CPP      set filetype=cpp
" au BufNewFile,BufRead   *.sv       set filetype=verilog
" au BufNewFile,BufRead   *.v        set filetype=verilog
" au BufNewFile,BufRead   *.V        set filetype=verilog
" au BufNewFile,BufRead   *.f        set filetype=verilog
" au BufNewFile,BufRead   *.psl      set filetype=psl
" au BufNewFile,BufRead   *.log      set filetype=help
" au BufNewFile,BufRead   *.exrc     set filetype=vim
" au BufNewFile,BufRead   *.vifile   set filetype=vim

" ===============================================
" Replace TAB character by 2 SPACES character
" ===============================================
set expandtab
set ts=2

" ===============================================
" Source file here
" ===============================================
source ~/cscope.vim

call plug#begin('~/.vim/plugged')

" Declare the list of plugins.
  Plug 'davidhalter/jedi-vim'
  Plug 'drewtempelmeyer/palenight.vim'
  Plug 'preservim/nerdtree'
"
" " List ends here. Plugins become visible to Vim after this call.
call plug#end()
colorscheme palenight

" Start NERDTREE when Vim is started without file arguments
" autocmd VimEnter * NERDTree | wincmd p
" Open the existing on every tab automatically
autocmd BufWinEnter * silent NERDTreeMirror

" Exit Vim if NERDTREE is the only window left
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 &&
  \ exists('b:NERDTree') && b:NERDTree.isTabTree() |
  \ quit | endif

nnoremap <c-n> :NERDTreeToggle<CR>
nnoremap tn :tabnew<CR>
nnoremap tj :tabnext<CR>
nnoremap tk :tabprev<CR>
nnoremap td :tabclose<CR>

" Setting for Jedi-vim
let g:jedi#popup_on_dot = 0
