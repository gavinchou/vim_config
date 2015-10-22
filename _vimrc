" ============================ favorite files and direcotries {{{2
let $favorites=''
if has("win32")
  let $favorites='E:/Material/Linux/Vim/config/favorites.vim'
endif
if $favorites != ""
  so $favorites
endif

" ============================ appearance =============================== {{{2
" ---------- indent {{{3
set autoindent " ai
set sw=2 " shift width, indent width
set tabstop=2 " ts, tabstop width
set tw=80
set et " extendtab
autocmd BufEnter * set et
autocmd BufEnter,BufRead *.txt,*.md set noet

" --------- display as more lines as possible, do not use @@ {{{3
set display=lastline " dy=lastline

set backspace=indent,eol,start
set number
set encoding=utf-8
set fencs=utf8,gbk,gb2312,cp936,gb18030

" scrolling {{{3
set scrolloff=3 "margin of moving to top or bot of current screen

" ---------- folding option {{{3
" marker manual indent
set foldmethod=marker
set foldenable
set fdl=3
" foldlevel

" --------- status line, command line {{{3
set statusline=%<%F\ %y\ %m%r%=0x%B\ %l/%L,%c%V\ [b%nw%{winnr()}]
" always display status line, 0 never, 1 more than 2 windows, 2 always
set laststatus=2
" ruler, command line appearance, if laststatus == 2, ruler is useless
set noruler " ru
set rulerformat =%30(%<%y\ %m%r%=0x%B\ %l,%c%V\ [%n]\ %P%)

" ---------- using system clipboard {{{3
set clipboard+=unnamed
" if has("win32")
"   set ff=dos
".proceed else
"   set ff=unix
" endif

" set right margin, only > 704 the cc option is available {{{3
if version >= 704
  set cc=80 " colorcolumn=80 " cc=80
endif
" hilight current line
set cursorline
" hilight column
set cursorcolumn

" netrw explorer {{{3
let g:netrw_winsize = 20
let g:netrw_liststyle= 3 " archive
let g:netrw_menu = 0 " no menu
let g:netrw_preview = 1 " preview in vertical new window
let g:netrw_banner = 0 " no banner
let g:netrw_browse_split = 5 " when browsing, <cr> will open the file as "p"
let g:netrw_cursor = "ctags"
let g:netrw_chgwin = 2 " specifies a window number where file edits will take place
let g:netrw_use_errorwindow = 0 " dont use an extra window for errors

" menu bar {{{3
if has("gui")
  " set window(gui) size
  if has("win32")
    " ~x max ~n min ~r restore
    autocmd GUIEnter * simalt ~x
    " set lines=25
    " set columns=100
  endif
  " toggle menu bar, tool bar, scroll bar
  " guioptions == go
  set guioptions-=T " += is on, -= is off
  set guioptions-=m " menu bar
  set go-=M " system menu
  set go-=R " right scroll
  set go-=r " do not show right scroll
  set go-=L " left
  set go-=l
  " set selectmode+=mouse
endif

" ---------- disable mouse under unix system {{{3
if has("unix")
  set mouse=
endif

" theme {{{3
if &term == 'vt100' || &term == 'xterm'
  set term=xterm-256color
endif
if &term == 'screen'
  set t_Co=256
end
colorscheme Monokai_Gavin
set guifont=Consolas:h13
" echo &t_Co
syntax enable
syntax on

" show white spaces {{{3
set listchars=tab:>-,trail:-
set list

" set tablabel as 'number filename' for gui{{{3
if has("gui")
  function! GuiTabLabel()

"     Add '*' if one of the buffers in the tab page is modified
"     let bufnrlist = tabpagebuflist(v:lnum)
"     for bufnr in bufnrlist
"       if getbufvar(bufnr, "&modified")
"         let label = '*'
"         break
"       endif
"     endfor

    let bufnrlist = tabpagebuflist(tabpagenr())
    " define some "useless" window whose title should not display in tablable
    let uselessWindow = ["__Tagbar__", "NetrwTreeListing", "__Tag_List__"]
    let fileName = bufname(bufnrlist[winnr() - 1])
    for each in uselessWindow
      if fileName =~ each
        if !exists('t:label')
          let t:label = tabpagenr() . ' '
        endif
        return t:label
      endif
    endfor

    let t:winCount = tabpagewinnr(tabpagenr(), '$')
    for i in range(0, t:winCount - 1)
      for each in uselessWindow
        let eachFileName = bufname(bufnrlist[i])
        if eachFileName =~ each
          let t:winCount = t:winCount - 1
        endif
      endfor
    endfor
    if t:winCount > 1
      let t:winCount = " " . t:winCount
    else
      let t:winCount = ''
    endif

    " add '*' if the current window(file) has been modified
    if getwinvar(winnr(), "&modified")
      let t:label = '*'
    else
      let t:label = ''
    endif

    let t:name =  " " . expand("%:t")
    if t:name == ' '
      let t:name = ' [No Name]'
    endif
    let t:label = t:label . tabpagenr() . t:name . t:winCount
    return t:label
  endfunction

  set guitablabel=%{GuiTabLabel()}
  " equivalent, but no *
  " set guitablabel=%N\ %t
endif

" ---------- custom tabs for terminal version {{{3
function! MyTabLabel(n)
  let label = ''
  let bufnrlist = tabpagebuflist(a:n)
  " Add '*' if one of the buffers in the tab page is modified
  for bufnr in bufnrlist
    if getbufvar(bufnr, "&modified")
      let label = '*'
      break
    endif
  endfor
  " define some "useless" window whose title should not display in tablable
  let uselessWindow = ["__Tagbar__", "NetrwTreeListing", "__Tag_List__"]
  " get window count of tabpage n
  let winCount = tabpagewinnr(a:n, '$')
  " dont count the "useless" window
  for i in range(1, winCount)
    for j in uselessWindow
      let fileName = bufname(bufnrlist[i - 1])
      if fileName =~ j
        let winCount = winCount - 1
      endif
    endfor
  endfor
  " current window (winnr) of tab page n, get filename from winnr
  let winnr = tabpagewinnr(a:n)
  let fileName = bufname(bufnrlist[winnr - 1])
  " filter "useless" filename, use other file name instead
  let realWinCount = tabpagewinnr(a:n, '$')
  for i in uselessWindow
    if realWinCount < 2
      break
    endif
    if fileName =~ i
      for j in range(0, realWinCount - 1)
        let tmpFileName = bufname(bufnrlist[j])
        let foundProperName = 1
        for k in uselessWindow
          if tmpFileName =~ k
            let foundProperName = 0
            break
          endif
        endfor
        if foundProperName
          let fileName = tmpFileName
          break
        endif
      endfor
      break
    endif
  endfor
  " get the filename, not the full path
  let lastOccur = strridx(fileName, "/")
  if (lastOccur > 0)
    let fileName = strpart(fileName, lastOccur + 1, strlen(fileName))
  endif
  " if the current filename is netrw, delete the number in it, that's ugly
  if fileName =~ "NetrwTreeListing"
    let fileName = "NetrwTreeListing"
  endif
  let label = label . a:n . " " . fileName . (winCount > 1 ? " ".winCount : "")
  return label
endfunction

function! MyTabLine()
  let s = ''
  for i in range(tabpagenr('$'))
    " select the highlighting
    if i + 1 == tabpagenr()
      let s .= '%#TabLineSel#'
    else
      let s .= '%#TabLine#'
    endif

    " set the tab page number (for mouse clicks)
    let s .= '%' . (i + 1) . 'T'

    " the label is made by MyTabLabel()
    let s .= ' %{MyTabLabel(' . (i + 1) . ')} %#TabLine#|'
  endfor

  " after the last tab fill with TabLineFill and reset tab page nr
  let s .= '%#TabLineFill#%T'

  " right-align the label to close the current tab page
  if tabpagenr('$') > 1
    let s .= '%=%#TabLine#%999Xclose'
  endif

  return s
endfunction
" %! means the things following it will be evaluated as expression
set tabline=%!MyTabLine()
augroup tabline
  autocmd InsertEnter * if exists("g:StatusLineInsert") |
        \  exe "hi TabLineSel " . g:StatusLineInsert |
        \endif
  autocmd InsertLeave * if exists("g:StatusLineNormal") |
        \  exe "hi TabLineSel " . g:StatusLineNormal |
        \endif
augroup end

" ============================== key mapping ============================ {{{2
" tab mappings {{{3
nmap <M-1> <ESC>1gt
nmap <M-2> <ESC>2gt
nmap <M-3> <ESC>3gt
nmap <M-4> <ESC>4gt
nmap <M-5> <ESC>5gt
nmap <M-6> <ESC>6gt
nmap <M-7> <ESC>7gt
nmap <M-8> <ESC>8gt
nmap <M-9> <ESC>9gt
nmap <M-t> <ESC>:tabnew<CR>
nmap <M-w> <ESC>:tabclose<CR>
map <C-Tab> <ESC>gt
imap <C-Tab> <ESC>gt
imap <C-F4> <ESC>:tabc<CR>
map <C-F4> <ESC>:tabc<CR>

" Use CTRL-S for saving, also in Insert mode {{{3
noremap <C-S> :update<CR>
vnoremap <C-S> <C-C>:update<CR>
inoremap <C-S> <C-O>:update<CR>

" comment {{{3
let g:COMMENT_1 = 1 " add comment string at the begin of the line
let g:COMMENT_2 = 2 " add comment string before the first word of the line
let g:UNCOMMENT = 3 " uncomment
function! CommentImpl(commentStr, mode)
  " echo a:commentStr
  " execute "echo " . '"' . a:commentStr . '"'
  let l:cs = ""
  let l:cse = ""
  if a:commentStr == "vim"
    let l:cs = '"'
  elseif a:commentStr == "xml"
    let l:cs = "<!--"
    let l:cse = " -->"
  else
    let l:cs .= a:commentStr
  endif
  let l:cs = escape(l:cs, '/\')

  " comment
  if a:mode == g:COMMENT_1
    " comment codes, add commentStr at the begin of line
    " exe 's!^!' . l:cs . ' !'
    exe 's/\(^\s*\)\(.*\)/' . l:cs . ' \1\2' . l:cse . '/e'
  elseif a:mode == g:COMMENT_2
    " comment description, add commentStr before the first word
    exe 's/\(^\s*\)\(.*\)/\1' . l:cs . ' \2' . l:cse . '/e'
  " uncomment
  elseif a:mode == g:UNCOMMENT
    exe 's/^\(\s*\)' . l:cs . ' \{0,1\}\(.*\)' . l:cse . '/\1\2/e'
  endif
  exe 'noh'
endfunction

function! Comment(mode)
  " comment string is //
  for tmp in ["cpp", "c", "java", "php", "javascript", "go"]
    if &ft == tmp
      call CommentImpl("//", a:mode)
      return "//"
    endif
  endfor
  " comment string is "
  if &ft == "vim"
    call CommentImpl("vim", a:mode)
    return "vim"
  endif
  " comment string is #
  for tmp in ["python","sed","apache","bash","conf", "sh", "make", "cfg",
      \ "gitignore", "zsh"]
    if &ft == tmp
      call CommentImpl("#", a:mode)
      return tmp
    endif
  endfor
  " comment string is ;
  if &ft == "dosini" || &ft == "ini" || &ft == "autohotkey"
    call CommentImpl(";", a:mode)
    return "dosini"
  endif
  " comment string is REM
  if &ft == "dosbatch" || &ft == "cmd" || &ft == "bat"
    let l:caseChanged = 0
    let l:smartcaseChanged = 0
    if &ignorecase == 0
      set ignorecase
      let l:caseChanged = 1
    endif
    if &smartcase == 1
      set nosmartcase
      let l:smartcaseChanged = 1
    end
    call CommentImpl("REM", a:mode)
    if l:caseChanged == 1
      set noignorecase
    endif
    if l:smartcaseChanged == 1
      set smartcase
    end
    return "dosbatch"
  endif
  " comment string is '
  if &ft == "vbs" || &ft == "vb"
    call CommentImpl("'", a:mode)
    return "vbs"
  endif
  
  " comment string is <!--  -->
  for tmp in ["html", "xml", "axml", "htm", "xhtml"]
    if &ft == tmp
      call CommentImpl("xml", a:mode)
      return "xml"
    endif
  endfor

  " comment string is %
  if &ft == "matlab"
    call CommentImpl("%", a:mode)
    return "matlab"
  endif

  " comment string is --
  if &ft == "lua"
    call CommentImpl("--", a:mode)
    return "lua"
  endif

  echo "No comment command support for " . &ft . " --- Gavin"
endfunction

nmap <silent> cc :call Comment(COMMENT_1)<CR>
vmap <silent> cc :call Comment(COMMENT_1)<CR>
nmap <silent> CC :call Comment(COMMENT_2)<CR>
vmap <silent> CC :call Comment(COMMENT_2)<CR>
nmap <silent> cz :call Comment(UNCOMMENT)<CR>
nmap <silent> cx :call Comment(UNCOMMENT)<CR>
vmap <silent> cz :call Comment(UNCOMMENT)<CR>
vmap <silent> cx :call Comment(UNCOMMENT)<CR>

function! Run()
  if &ft == "vim"
    exe 'source %'
    return "vim"
  endif
  for ext in ["cc", "cpp", "c", "cxx", "h", "hpp"]
    if &ft == ext
      if has("win32")
        exe '!start cmd /c start "vim run cpp" g++.lnk "%:p"'
      elseif has("unix")
        exe '!clear; rm ~/tmp/vim.out 2>/dev/null;' .
           \ 'g++ -g -Wall -std=c++11 "%:p" -o ~/tmp/vim.out && '
           \ '(isGdb="n";read -n1 -t 3 -p "use gdb[yn]?" isGdb; echo "";' .
           \ 'if [ "x$isGdb" = "xy" ]; then ' .
           \ 'gdb ~/tmp/vim.out;else ~/tmp/vim.out;fi;' .
           \ 'read -n1 -p "Press any key to continue...";)'
        " refresh when return from external command
        call RefreshCurrentTab()
      endif
      return ""
    endif
  endfor
  if (&ft == 'sh')
    exe "!source %; read -n1 -p 'Press any key to continue...'"
    call RefreshCurrentTab()
    return "bash"
  endif
  if (&ft == 'markdown') " view in markdown previewer
    if has('mac')
      exe '!killall Mou; mou %:p'
    elseif has('win32')
      exe 'silent !start cmd /c start "markdown" markdown.lnk "%:p"'
    endif
    return "markdown"
  endif
  if (&ft == 'go')
    if has('mac')
      exe '!clear; rm ~/tmp/go.out 2>/dev/null;' .
            \ 'go build -o ~/tmp/go.out "%:p" && ~/tmp/go.out;' .
            \ 'read -n1 -p "Press any key to continue...";'
      call RefreshCurrentTab()
    elseif has("win32")
      exe '!cls & del e:/temp/go.out 2>nul & ' .
            \'go build -o e:/temp/go.out ' . expand("%:p") . ' && ' .
            \'e:/temp/go.out & pause'
    endif
    return "go"
  endif
  if has("win32")
    exe '!start cmd /c start "vim run" nppCompileAndRun.lnk "%:p"'
  elseif has("unix")
"     exe '!g++ -Wall "%:p"'
  elseif has("mac")
    " do nothing
  endif
  return ""
endfunction

map <F5> :silent call Run()<CR>

nmap <F4> :call MakeSurround("normal")<CR>
vmap <F4> <ESC>:call MakeSurround("visual")<CR>

" taglist, make tag file {{{3
function! MakeTags()
  if &ft == "cpp"
"     exe '!ctags -R --langmap=.h.inl.cxx.cc --c++-kinds=+p --fields=+iaSK --extra=+q --languages=c++'
    exe '!ctags -R --exclude=.git --exclude=.svn --langmap=c++:+.inl+.cc+.h+.cxx -h +.inl --c++-kinds=+p --fields=+iaSK --extra=+q --languages=c++'
  elseif &ft == "java"
    exe '!ctags -R --java-kinds=+p --fields=+iaS --extra=+q --languages=java'
  elseif &ft == "php"
    exe '!ctags -R --php-kinds=+cidfvj --fields=+iaSK --fields=-k --extra=+q --languages=php'
  elseif &ft == "javascript"
    exe '!ctags -R --javascript-kinds=+cfv --fields=+iaSK --fields=-k --extra=+q --languages=javascript'
  endif
endfunction

map <F12> :call MakeTags()<CR>

" select all
nmap <C-A> ggVG

" ---------- redirect for ESC {{{3
" imap fds <ESC>
" map fds <ESC>
" omap fds <ESC>
" imap FDS <ESC>:echo "CAPS_LOCK!"<CR><ESC>
" map FDS <ESC>:echo "CAPS_LOCK!"<CR><ESC>
" omap FDS <ESC>:echo "CAPS_LOCK!"<CR><ESC>
" cnoremap fds <C-U><ESC>
" cnoremap FDS <C-U><ESC>:echo "CAPS_LOCK!"<CR><ESC>

" deletion, use backspace as backspace key, using black hole register {{{3
nmap <silent> <BS> h"_x
vmap <silent> <BS> h"_x

" ---------- open selected file {{{3
vnoremap <M-g> "zy:!start cmd /c start npp_open_document.lnk "<C-R>z" "%:p" "vim"<CR>
vmap <M-g> "zy:!start cmd /c start npp_open_document.lnk "<C-R>z" "%:p" "vim"<CR>

" ---------- using * and # search for selected content in visual mode {{{3
vnoremap <silent> * :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy/<C-R><C-R>=substitute(
    \escape(@", '/\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>
vnoremap <silent> # :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy?<C-R><C-R>=substitute(
    \escape(@", '?\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>

" ---------- adjust the window size {{{3
" :resize n or :vertical resize n, where n is the size in height/width
" horizontal size, height
nmap <M-]> :resize +1<CR>
nmap <M-[> :resize -1<CR>
" vertical size, width
nmap <M-=> :vertical resize +1<CR>
nmap <M--> :vertical resize -1<CR>
" maximize window
nmap <F11> :simalt ~x<CR>

" ---------- append ";" at the end of line, for cpp,php,js {{{3
" imap ;; <ESC>A;
" nmap ;; <ESC>A;<ESC>

" ---------- auto complete key map {{{3
autocmd BufRead,BufEnter * call AutoCompletionKeyMap()
function! AutoCompletionKeyMap()
  if &ft == "cpp"
    imap <C-space> <C-x><C-o><C-p>
    imap <C-l> <C-x><C-o><C-p>
  else
    imap <C-space> <C-n><C-p>
    imap <C-l> <C-n><C-p>
  endif
endfunc
imap <C-j> <C-n>
imap <C-k> <C-p>

" ---------- hjkl remap {{{3
nnoremap j gj
nnoremap k gk
nnoremap gj j
nnoremap gk k
vnoremap j gj
vnoremap k gk
vnoremap gj j
vnoremap gk k

" ---------- resize vertical explorer to width 30 {{{3
nmap <F3> :vert res 30<CR>

" ---------- build project {{{3
nmap <F7> :make clean; make -j7<CR>

" ---------- trim
nmap T :T<CR>

" ================================ misc ================================ {{{2
" where the swap file stored {{{3
if has('win32')
  set dir=e:/temp/
elseif has('unix')
  set dir=~/temp/,~/tmp/
endif

" ignore case while search {{{3
set ignorecase " noignorecase
set smartcase " if upper case letters are typed, case sensitive

" language
if has('win32')
  language us
endif

" nocapatible with vi
set nocompatible
set magic
set nobackup
set hlsearch
set incsearch "increase search, search when typing a pattern
filetype on
filetype plugin on
filetype indent on

" ---------- tags, taglist, file explorer {{{3
set tags=tags,./tags,../tags,../../tags,../../../tags
set tags+=E:/Material/C++/SOURCE/cygwin_gcc_c++_tags
set tags+=E:/Material/C++/SOURCE/linux_systags
set tags+=~/cpp_stdlib.tags
set tags+=~/dev/baidu-root/bd_tags
set autochdir
let Tlist_Show_One_File = 1
let Tlist_Exit_OnlyWindow = 1
let Tlist_Use_Right_Window = 1
let Tlist_Enable_Fold_Column = 0

" php dictionary
autocmd filetype php set dictionary-=E:/Material/Linux/Vim/config/php_function_list.txt
autocmd filetype php set dictionary+=E:/Material/Linux/Vim/config/php_function_list.txt

"let g:winManagerWindowLayout='FileExplorer|TagList'
"nmap wm :WMToggle<cr>

" ---------- OmniCppComplete {{{3
" let g:OmniCpp_NamespaceSearch = 1
" let g:OmniCpp_GlobalScopeSearch = 1
" let g:OmniCpp_ShowAccess = 1
let g:OmniCpp_ShowPrototypeInAbbr = 1 " show function parameters
" let g:OmniCpp_MayCompleteDot = 1 " autocomplete after .
" let g:OmniCpp_MayCompleteArrow = 1 " autocomplete after ->
" let g:OmniCpp_MayCompleteScope = 1 " autocomplete after ::
let g:OmniCpp_DefaultNamespaces = ["std", "_GLIBCXX_STD", "__gnu_std"]
let g:OmniCpp_SelectFirstItem = 2 " select first popup item (without inserting it to the text)
" automatically open and close the popup menu / preview window
" au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif
" set completeopt=menuone,menu,longest,preview
set completeopt=menuone,menu
au BufNewFile,BufRead,BufEnter *.cpp,*.hpp,*.h,*.cc set omnifunc=omni#cpp#complete#Main

" ---------- YouCompleteMe
let g:ycm_global_ycm_extra_conf = '~/.ycm_extra_conf.py'

" ---------- virtual edit {{{3
set virtualedit=block

" ---------- text formatting option {{{3
" for multibyte text width line break, for text block: select lines, press Jgqgq
set formatoptions+=m

" ---------- set updatetime shorter, this may cause frequently disk writing,
"  this opation is global only, may be changed by other plugins
set updatetime=200

" ---------- don't search cyclically
set nowrapscan

" ---------- show match () {} [] when typing them
set showmatch

" ---------- enter normal mode delay
set timeoutlen=1000 ttimeoutlen=5

" ================================ commands ============================ {{{2
" ---------- trim the heading/trailing whitespaces {{{3
function! RemoveTrailingWhitespace()
  for lineNo in range(a:firstline, a:lastline)
    let line = getline(lineNo)
    let cleanLine = substitute(line, '\s\+$', '', 'e')
    call setline(lineNo, cleanLine)
  endfor
endfunction
function! RemoveBeginningWhitespace()
  for lineNo in range(a:firstline, a:lastline)
    let line = getline(lineNo)
    let cleanLine = substitute(line, '^\s\+', '', 'e')
    call setline(lineNo, cleanLine)
  endfor
endfunction
command! -range Trim <line1>,<line2>call RemoveTrailingWhitespace()
command! -range T <line1>,<line2>call RemoveTrailingWhitespace()
command! -range TrimLeft <line1>,<line2>call RemoveBeginningWhitespace()
command! -range Tl <line1>,<line2>call RemoveBeginningWhitespace()

" ---------- rename current file {{{3
command! -nargs=+ -bang -complete=file Rename let newName = "<args>"<BAR>
  \let curExt = expand("%:e")<BAR>
  \let oldFullPath = expand("%:p")<BAR>
  \exe "saveas<bang> " . newName<BAR>
  \echo "renamed current file to: " . expand("%:t")<BAR>
  \if newName == expand("%:t")<BAR>
    \echo "suceeded to save the file " . newName<BAR>
    \let delResult =  delete(oldFullPath)<BAR>
    \if delResult != 0<BAR>
      \echo "fail to delete the old file: " . oldFullPath<BAR>
    \endif<BAR>
  \endif<BAR>

nmap <F2> :Rename 

" ---------- make/load session {{{3
" command! -nargs=? -bang Mks mks<bang> $ses
command! -nargs=? -bang Mks silent echo "try to make session"<BAR>
  \if "<args>" != ""<BAR>
    \mks<bang> <args><BAR>
    \echo "made session at: <args>"<BAR>
  \else<BAR>
    \mks<bang> $ses<BAR>
    \echo "made session at: ".$ses<BAR>
  \endif
" command! -nargs=? -bang Loadsession so $ses <args>
command! -nargs=? -bang Loadsession silent echo "try to load session"<BAR>
  \if "<args>" != ""<BAR>
    \so <args><BAR>
    \echo "loaded session from: <args>"<BAR>
  \else<BAR>
    \so $ses<BAR>
    \echo "loaded session from: ".$ses<BAR>
  \endif<BAR>

" ---------- insert current time in the current position, after the cursor box {{{3
command! Time echo strftime("%Y-%m-%d-%a %H:%M:%S")<BAR>
"   \"=strftime("%Y-%m-%d %H:%M:%S")<CR><BAR>
"   \gP
" = register is the expression output register, 6. Expression register "= can only be used onece
" normal mode insert current time, and enter insert mode
nnoremap time "=strftime("%Y-%m-%d-%a %H:%M:%S")<CR>pa
nnoremap timelog "="\n## " . strftime("%Y-%m-%d-%a %H:%M:%S") . "\ntag: \n"<CR>PjjA

" ---------- auto change IME to en {{{3
" for some type of files auto ime is needed
autocmd! InsertLeave *.txt,*.md call ChangeIme(g:autoChangeIme)
let g:autoChangeIme = 1
function! ChangeIme(autoChangeIme)
  if has('win32') && a:autoChangeIme
    exe '!start /MIN cmd /c start "change ime" /MIN changeVimIme2En.lnk'
    exe 'echo "back to normal mode by calling changeVimIme2En.lnk"'
  elseif has('mac') && a:autoChangeIme
    silent exe '!xkbswitch -se US'
  endif
endfunc
command! AutoIme silent echo "toggle auto ime"<BAR>
  \if g:autoChangeIme<BAR>
    \echo "auto change ime disabled"<BAR>
  \else<BAR>
    \echo "auto change ime enabled"<BAR>
  \endif<BAR>
  \let g:autoChangeIme=!g:autoChangeIme

" ---------- get file path into the system's clipboard {{{3
command! FilePath echo 'Get file full path'<BAR>
  \:!start cmd /c start get_current_file_full_path.lnk "%:p" "vim"<CR>

" ---------- spell {{{3
" spell default off, default language is en_US, using spf to change spell
" language
command! Spell silent echo "toggle spell"<BAR>
  \if &spell<BAR>
    \setlocal nospell<BAR>
    \echo "spell check disabled"<BAR>
  \else<BAR>
    \setlocal spell<BAR>
    \echo "spell check enabled"<BAR>
  \endif

" ---------- focus certain window {{{3
" this also can be done with "number <c-w> w" under normal mode
" the win number is assending from top-down left-right seqeunce
command! -count=1 W <count> winc w

" ---------- set vim format footer fo baidu cpp {{{3
command! Baiducpp echo "added baidu cpp vim format footer"<BAR>
  \silent call append('$',  '// vim: tw=80 ts=4 sw=4 cc=80')

" ========================= file type ================================== {{{2
autocmd BufNewFile,BufRead *.alipaylog setf alipaylog
autocmd BufNewFile,BufRead *.md setf markdown
autocmd BufNewFile,BufRead *.md setlocal foldexpr=MarkdownFoldExpr(v:lnum) fdm=expr
autocmd BufNewFile,BufRead *.gitignore setf gitignore
autocmd BufNewFile,BufRead BCLOUD setf conf

" ========================= autocmd ================================== {{{2
augroup netrw " ---------- {{{3
  autocmd WinEnter * let bufnrlist = tabpagebuflist() |
      \if bufname(bufnrlist[0]) =~ "NetrwTreeListing" |
      \  let curWinnr = winnr() |
      \  let winsz = 30 |
      \  exe "1wincmd w" |
      \  exe winsz . "wincmd |" |
      \  exe curWinnr . "wincmd w" |
      \endif
augroup end

" ========================== functions ================================= {{{2
" ---------- judge if current char is the last char {{{3
function! IsLastChar(...)

  let l:isLastChar = 0

  if mode() == "v"
    exe 'norm! l'
    " in visual mode, cursor can move to the linebreak char
    if col('.') == col('$')
      let l:isLastChar = 1
    endif
    exe 'norm! h'
  else
    let l:pos = col('.')
    exe 'norm! l'
    let l:isLastChar = 0
    if col('.') == l:pos
      let l:isLastChar = 1
    else
      exe 'norm! h'
    endif
  endif
  return l:isLastChar

endfunc

" ---------- judge if current char is the first char {{{3
function! IsFirstChar()
  let l:pos = col('.')
  let l:isFirstChar = 0
  if l:pos == 1
    let l:isFirstChar = 1
  endif
  return l:isFirstChar
endfunc

function! GetCurrentChar()
  let l:str = getline('.')
  let l:pos = col('.')
  let l:char = l:str[l:pos - 1]
  return l:char
endfunc


function! MakeSurround1(mode, ...)

  let l:old = getreg('s')

  if a:0 < 2
    let l:delim = input("surround with:")
  else
    let l:delim = a:1
  endif
  if l:delim == ''
    return
  endif
  let l:ldelim = l:delim
  let l:delimDict = {"[":"]", "(":")", "/*":"*/", "{":"}", "<":">"}
  for key in keys(l:delimDict)
    if key == l:delim
      let l:delim = l:delimDict[key]
      break
    endif
  endfor
  let l:rdelim = l:delim

  if a:mode == "visual"
    " go back to visual mode, calling this function will enter normal mode
    norm! "<ESC>"
    let l:startPos = getpos("'<")
    let l:endPos = getpos("'>")
    echo l:endPos
    
    return
    echo getpos('.')
    let l:isLastChar = IsLastChar()
    echo getpos('.')
    exe "norm! gv"
    exe 'norm! "sx'
  else
    " normal mode
    if GetCurrentChar() == ' ' || GetCurrentChar() == '	'
      echo "no surround for white space"
      return
    endif
    if !IsFirstChar()
      " move backward and go to word end
      exe 'norm! he'
    endif
    let l:isLastChar = IsLastChar()
    " echo l:isLastChar
    exe 'norm! "sdiw'
  endif

  let l:str = l:ldelim . getreg('s') . l:rdelim
  call setreg('s', l:str, 'v')

  " if the cursor is at the end of line paste behined
  if l:isLastChar
    exe 'norm! "sp'
  else
    exe 'norm! "sP'
  endif

  call setreg('s', l:old)
endfunc


function! MakeSurround(mode, ...)

  let l:old = getreg('s')

  if a:0 < 2
    let l:delim = input("surround with:")
  else
    let l:delim = a:1
  endif
  if l:delim == ''
    return
  endif
  let l:ldelim = l:delim
  let l:delimDict = {"[":"]", "(":")", "/*":"*/", "{":"}", "<":">"}
  for key in keys(l:delimDict)
    if key == l:delim
      let l:delim = l:delimDict[key]
      break
    endif
  endfor
  let l:rdelim = l:delim

  if a:mode == "visual"
    " go back to visual mode, calling this function will enter normal mode
    exe "norm! gv"
    let l:isLastChar = IsLastChar()
    exe 'norm! "sx'
  else
    " normal mode
    if GetCurrentChar() == ' ' || GetCurrentChar() == '	'
      echo "no surround for white space"
      return
    endif
    if IsFirstChar() == 0
      " move backward and go to word end
      exe 'norm! he'
    endif
    let l:isLastChar = IsLastChar()
    " echo l:isLastChar
    exe 'norm! "sdiw'
  endif

  let l:str = l:ldelim . getreg('s') . l:rdelim
  call setreg('s', l:str, 'v')

  " if the cursor is at the end of line paste behined
  if l:isLastChar
    exe 'norm! "sp'
  else
    exe 'norm! "sP'
  endif

  call setreg('s', l:old)
endfunc

" ---------- GetSelection() {{{3
function! GetSelection()
  " Why is this not a built-in Vim script function?!
  let l:isVisual = 0
  if mode() == 'v'
    let l:isVisual = 1
    norm! "<esc>"
  endif
  let [lnum1, col1] = getpos("'<")[1:2]
  let [lnum2, col2] = getpos("'>")[1:2]
  let lines = getline(lnum1, lnum2)
  let lines[-1] = lines[-1][: col2 - (&selection == 'inclusive' ? 1 : 2)]
  let lines[0] = lines[0][col1 - 1:]
  let l:res =  join(lines, "\n")
  echo l:res
  if l:isVisual
    norm! "gv"
  endif
  return l:res
endfunction

" ---------- RefreshCurrentTab() {{{3
function! RefreshCurrentTab()
  " refresh the current tab
  " tabnew and tabc will make the next tab active if there are more than 1 tabs
  " save the current tabpage number
  let curTabNum = tabpagenr()
  exe 'tabnew'
  exe 'tabc'
  if tabpagenr('$') != curTabNum
    exe 'tabp'
  endif
endfunction

" ---------- MarkdownFoldExpr() {{{3
function! MarkdownFoldExpr(lnum)
  let headingLvl = strlen(substitute(getline(a:lnum), '^\(#*\).*', '\1', ''))
  if headingLvl < 1
    " return foldlevel(v:lnum - 1)
    return '='
  else
    return '>'.headingLvl
endfunction

" ============================ tagbar ==================================== {{{2
let g:tagbar_sort = 0 " do not sort tags by name
let g:tagbar_type_asciidoc = {
    \ 'ctagstype' : 'asciidoc',
    \ 'kinds' : [
      \ 'h:table of contents',
      \ 'a:anchors:1',
      \ 't:titles:1',
      \ 'n:includes:1',
      \ 'i:images:1',
      \ 'I:inline images:1'
    \ ],
    \ 'sort' : 0
\ }

let g:tagbar_type_markdown = {
    \ 'ctagstype' : 'markdown',
    \ 'kinds' : [
      \ 'h:heading',
    \ ],
    \ 'sort' : 0
\ }

let g:tagbar_type_go = {
    \ 'ctagstype' : 'go',
    \ 'kinds' : [
      \ 'f:function',
      \ 'p:package',
      \ 'v:variable',
      \ 't:type',
      \ 'c:const',
    \ ],
					\ 'sro' : '.',
					\ 'kind2scope' : {
					\ 't' : 'ctype',
					\ 'n' : 'ntype'
					\ },
					\ 'scope2kind' : {
					\ 'ctype' : 't',
					\ 'ntype' : 'n'
					\ },
    \ 'sort' : 0
\ }

" ============================ test ====================================== {{{2
command! -nargs=* -bang TestCmd call <bang>TestFunc(<f-args>)
function! TestFunc()
"   exe "q"
  echo expand("<bang>") . "test -bang function"
endfunction
command! -nargs=* -bang TestCmd echo "test cmd"<BAR>
  \if "<bang>" != ""<BAR>
    \echo "test"<BAR>
  \endif<BAR>
  \echo "<lt>bang>" . "\n<bang>"<BAR>
  \let arg = "<args>"<BAR>
  \echo arg<BAR>

" nohlsearch
noh

" vim:tw=80:ts=2:ft=vim:et:foldcolumn=2:foldenable:fdl=2
