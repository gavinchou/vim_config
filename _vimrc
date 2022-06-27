" nocapatible with vi
set nocompatible
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
" set et " extendtab by default
set modelines=5

" --------- display as more lines as possible, do not use @@ {{{3
set display=lastline " dy=lastline

set backspace=indent,eol,start
set number
set encoding=utf-8
set fencs=utf8,gbk,gb2312,cp936,gb18030

" scrolling {{{3
set scrolloff=3 "margin of moving to top or bot of current screen
set sidescroll=1 " horizontal scroll step, continous scroll

" ---------- folding option {{{3
" marker manual indent
set foldmethod=marker
set foldenable
set fdl=3
" foldlevel

" --------- status line, command line {{{3
" ATTN: statusline configuration is overriden by plugin statusline.vim
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
let g:netrw_indicate_current_file = 1 " auto change cursor of the tree in netrw
let g:netrw_winsize_ratio = 0.166666 " auto resize netrw width when change window
let g:netrw_show_path = 1

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
" if &term == 'screen'
  set t_Co=256
" end
colorscheme Monokai_Gavin
set guifont=Consolas:h13
" echo &t_Co
syntax enable
syntax on

" show white spaces {{{3
set listchars=tab:>-,trail:-
" set listchars=tab:\|\ ,trail:-
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

" copy current file full path
nnoremap yp :let fullPath = expand('%:p')<BAR>
  \ if has('clipboard') <BAR> let register = "*" <BAR> else <BAR> let register = '"' <BAR>endif <BAR>
  \ call setreg(register, fullPath)<BAR>
  \ echo "copied full path: " . fullPath<CR>
" copy current directory
nnoremap yd :let fullPath = expand('%:p')<BAR>
  \ if has('win32') <BAR> let slash = '\'<BAR> else <BAR> let slash = '/' <BAR> endif<BAR>
  \ let lastSlash = strridx(fullPath, slash) <BAR>
  \ if lastSlash > 0 <BAR> let path = strpart(fullPath, 0, lastSlash) <BAR> else <BAR> let path = fullPath <BAR> endif<BAR>
  \ if has('clipboard') <BAR> let register = "*" <BAR> else <BAR> let register = '"' <BAR>endif <BAR>
  \ call setreg(register, path)<BAR>
  \ echo "copied directory: " . path . slash<CR>

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
  elseif a:mode == g:UNCOMMENT " uncomment
    exe 's/^\(\s*\)' . l:cs . ' \{0,1\}\(.*\)' . l:cse . '/\1\2/e'
  endif
  exe 'noh'
endfunction

function! Comment(mode)
  " comment string is //
  for tmp in ["cpp", "c", "java", "php", "javascript", "go", "scss", "proto",
        \ "thrift", "yacc", "dot", "gv", "rust", "lex", "flex", "verilog",
        \ "typescript", "groovy"]
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
      \ "gitignore", "zsh", "config", "jproperties", "properties", "yaml",
      \ "cmake", "crontab", "awk", "expect", "gitconfig", "applescript", "perl",
      \ "gnuplot"]
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
  for tmp in ["html", "xml", "axml", "htm", "xhtml", "ant", "svg"]
    if &ft == tmp
      call CommentImpl("xml", a:mode)
      return "xml"
    endif
  endfor

  " comment string is %
  if &ft == "matlab" || &ft == "tex"
    call CommentImpl("%", a:mode)
    return "matlab"
  endif

  " comment string is --
  if &ft == "lua" || &ft == "haskell" || &ft == "sql"
    call CommentImpl("--", a:mode)
    return &ft
  endif

  " lisp ;;
  if &ft == "lisp"
    call CommentImpl(";;", a:mode)
    return "lisp"
  endif

  echohl Error
  echo "No comment command support for " . &ft . " --- Gavin"
  echohl None
endfunction

nmap <silent> cc :call Comment(COMMENT_1)<CR>
vmap <silent> cc :call Comment(COMMENT_1)<CR>
nmap <silent> CC :call Comment(COMMENT_2)<CR>
vmap <silent> CC :call Comment(COMMENT_2)<CR>
nmap <silent> cz :call Comment(UNCOMMENT)<CR>
nmap <silent> cx :call Comment(UNCOMMENT)<CR>
vmap <silent> cz :call Comment(UNCOMMENT)<CR>
vmap <silent> cx :call Comment(UNCOMMENT)<CR>

" executes building and running scripts according to the file type
function! Run()
  if !exists('g:argv')
    let g:argv = ''
  endif
  if type(g:argv) == type([])
    let argv = ''
    for i in g:argv
      let argv = argv . " " . i
    endfor
  elseif type(g:argv) == type('')
    let argv = g:argv
  else
    let argv = ''
  endif

  let cmd = ""
  if &ft == "vim"
    exe 'source %'
    return "vim"
  endif
  for ext in ["cc", "cpp", "c", "cxx", "h", "hpp"]
    if &ft == ext
      if has("win32")
        exe '!start cmd /c start "vim run cpp" g++.lnk "%:p"'
      elseif has("unix") || has('linux') && executable('g++')
        exe 'silent !clear; rm ~/tmp/vim.out 2>/dev/null;'
           " 'isGdb="n";read -n 1 -t 3 -p "use gdb[yn]?" isGdb; echo "";' .
        " let cmd = '!g++1000 -g -ggdb3 -Wall -latomic -pthread -std=c++2a "%:p" -o ~/tmp/vim.out;' .
        let cmd = '!g++ -g -ggdb3 -Wall -pthread -std=c++2a "%:p" -o ~/tmp/vim.out;' .
           \ 'if [ $? -eq 0 ]; then ' .
           \ 'isGdb="n";read -t 3 "isGdb?use GDB?[y/n]? "; echo "";' .
           \ 'if [ "x$isGdb" = "xy" ]; then '
        " let cmd = '!g++ -std=c++17 -g -ggdb3 -Wall -pthread -lstdc++fs -static-libstdc++ -static-libgcc "%:p" -o ~/tmp/vim.out;' .
        if has("unix")
          let cmd = cmd . 'lldb -- ~/tmp/vim.out ' . argv . ';'
        else
          let cmd = cmd . 'gdb --args ~/tmp/vim.out ' . argv . ';'
        endif
        let cmd = cmd . 'else ~/tmp/vim.out ' . argv . ';fi;fi;'
        exe cmd
      endif
      return &ft
    endif
  endfor
  if (&ft == 'sh')
    exe "!sh %;"
    return "sh"
  endif
  if (&ft == 'bash')
    exe "!bash %;"
    return "bash"
  endif
  if (&ft == 'expect')
    exe "!expect %;"
    return "expect"
  endif
  if (&ft == 'markdown') " view in markdown previewer
    if has('mac')
"       exe '!killall Mou; mou %:p'
"       exe '!killall MacDown; MacDown %:p'
      exe '!killall Typora; typora %:p'
    elseif has('win32')
      exe 'silent !start cmd /c start "markdown" markdown.lnk "%:p"'
    endif
    return "markdown"
  endif
  if (&ft == 'go')
    if has('mac') || has('unix')
      exe 'silent !clear; rm /tmp/go.out 2>/dev/null;'
      exe '!export GOPATH=$GOPATH:`pwd`:`pwd`/..;' .
            \ '(go build -o /tmp/go.out "%:p"  && /tmp/go.out) || (clear; go test "%:p");'
    elseif has("win32")
      exe '!cls & del e:/temp/go.out 2>nul & ' .
            \'go build -o e:/temp/go.out ' . expand("%:p") . ' && ' .
            \'e:/temp/go.out & pause'
    endif
    return "go"
  endif
  if (&ft == 'python')
    if has('linux') || has('unix')
      exe '!python "%:p";'
    endif
    return &ft
  endif
  for tmp in ["html", "xml", "axml", "htm", "xhtml", "js", "javascript", "svg"]
    if (&ft == tmp)
      if has('unix')
        exe '!chrome "file://%:p";'
      elseif has('win32')
        exe '!chrome.lnk "file://%:p";'
      endif
      return tmp
    endif
  endfor
  if &ft == "haskell"
    if executable('ghc') || has('linux') || has('unix')
      exe 'silent !clear; rm /tmp/haskell.out /tmp/Main.o 2>/dev/null;'
      exe '!ghc -o /tmp/haskell.out -odir /tmp/ -hidir /tmp/ "%:p" && /tmp/haskell.out;'
    endif
    return &ft
  endif

  if &ft == "java"
    if executable("javac") && executable("java") && (has('linux') || has('unix'))
      let mainclass = expand("%:r")
      " let mainclass = input("Class to run: ")
      let outdir = '/tmp'
      let javafile = expand("%:p")
      let classfile = outdir . '/' . mainclass . '.class'
      " classpath is directory which contains jar files for classes neede
      let classpath = outdir . ':' . getcwd()
      let jarfile = outdir . '/java.jar'
      exe 'silent !clear; rm ' . classfile . ' 2>/dev/null;'
      exe '!javac ' . javafile . ' -d ' . outdir .
            \ ' -classpath ' . classpath .
            \ ' -sourcepath ' . getcwd() .
            \ ' -encoding UTF8 ' .
            \ ' && echo "Build successfully: ' . classfile . '"'
            \ ' && cd ' . outdir .
            \ ' && java -classpath ' . classpath .
            \ ' ' . mainclass .
            \ ' ' . g:argv
    else
      echohl Error
      echo "Support linux/unix env with binary javac and java only!"
      echohl None
    endif
  endif

  if &ft == "awk"
    if !executable("awk")
      echohl Error
      echo "No executable awk found"
      echohl None
    endif
    exe '!awk -f ' . expand("%:p")
    return 'awk'
  endif

  if &ft == "dot" || &ft == "gv"
    if !HasRequiredCmd("dot")
      return &ft
    endif
    if g:argv == "0"
      let cmd='!dot -o ~/tmp/tmp.svg -Tsvg ' . expand("%:p") . ' && chrome ~/tmp/tmp.svg'
    else
      let cmd='!callgraph ' . expand("%:p") . ' ~/tmp/tmp.svg && chrome ~/tmp/tmp.svg'
    endif
    call RunWithPlat(cmd, '', '')
    return 'dot'
  endif

  if &ft == "tex"
    if !HasRequiredCmd('xelatex')
      return &ft
    endif
    let cmd = '!xelatex ' . expand("%:p") . " -output-directory ~/tmp/" .
      \ ' && mv ' . expand('%:r') . '.pdf ~/tmp/tmp.pdf && open ~/tmp/tmp.pdf'
    call RunWithPlat(cmd, '', '')
    return &ft
  endif

  if &ft == "gnuplot"
    if !HasRequiredCmd("gnuplot")
      return &ft
    endif
    " the output tmp path is set in gnuplot scirpt file, that's a contract
    " between vim script and gnuplot script
    let cmd='!gnuplot -c ' . expand("%:p") . ' && chrome ~/tmp/tmp.svg'
    call RunWithPlat(cmd, '', '')
    return &ft
  endif

  echohl Error
  echo "Run() does not support " . &ft
  echohl None
  return ""
endfunction

" TODO: cmd is a list of commands
function! HasRequiredCmd(cmd)
  if executable(a:cmd)
    return 1
  endif
  echohl Error
  echo "No executable " . a:cmd . " found"
  echohl None
  return 0
endfunction

function! RunWithPlat(mac, linux, win)
  if has("mac")
    exe a:mac
  elseif has("unix") && has("linux")
    exe a:linux
  elseif has("win32")
    exe a:win
  else
    echohl Error
    echo "This plat is not supported by Run(), command not run"
    echohl None
  endif
endfunction

map <F5> :call Run()<CR>

let g:default_surround_mark='`'
nmap <F4> :call MakeSurround("normal")<CR>
vmap <F4> <ESC>:call MakeSurround("visual")<CR>
nmap <F8> :call MakeSurround("normal", g:default_surround_mark)<CR>
vmap <F8> <ESC>:call MakeSurround("visual", g:default_surround_mark)<CR>

" taglist, make tag file {{{3
function! MakeTags()
  if &ft == "cpp"
"     exe '!ctags -R --langmap=.h.inl.cxx.cc --c++-kinds=+p --fields=+iaSK --extra=+q --languages=c++'
    exe '!ctags -R --exclude=.git --exclude=.svn --langmap=c++:+.inl+.cc+.h+.cxx -h +.inl --c++-kinds=+p --fields=+iaSK --extra=+q --languages=c++'
  elseif &ft == "java"
    exe '!ctags -R --exclude=.git --exclude=.svn --java-kinds=+p --fields=+iaS --extra=+q --languages=java'
  elseif &ft == "php"
    exe '!ctags -R --exclude=.git --exclude=.svn --php-kinds=+cidfvj --fields=+iaSK --fields=-k --extra=+q --languages=php'
  elseif &ft == "javascript"
    exe '!ctags -R --exclude=.git --exclude=.svn --javascript-kinds=+cfv --fields=+iaSK --fields=-k --extra=+q --languages=javascript'
  endif
endfunction

map <F12> :call MakeTags()<CR>

" select all
" nmap <C-A> ggVG

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
nmap <F3> :exe "vert res " . float2nr(g:netrw_winsize_ratio * g:max_win_width)<CR>

" ---------- build project {{{3
nmap <F7> :make clean; make -j7<CR>

" ---------- trim
nmap T :T<CR>

" ================================ misc ================================ {{{2
" where the swap file stored {{{3
if has('win32')
  set dir=e:/temp/
elseif has('unix')
  set dir=~/temp/,~/tmp/,/tmp/
endif

" ignore case while search {{{3
set ignorecase " noignorecase
set smartcase " if upper case letters are typed, case sensitive

" language
if has('win32')
  language us
endif

set magic
set nobackup
set hlsearch
set incsearch "increase search, search when typing a pattern
filetype on
filetype plugin on
filetype indent on
if v:version >= 704
  set noundofile
endif

" ---------- tags, taglist, file explorer {{{3
set tags=tags,./tags,../tags,../../tags,../../../tags
set tags+=~/cpp_stdlib.tags
set autochdir
let Tlist_Show_One_File = 1
let Tlist_Exit_OnlyWindow = 1
let Tlist_Use_Right_Window = 1
let Tlist_Enable_Fold_Column = 0

" php dictionary, not used anymore
" autocmd filetype php set dictionary-=E:/Material/Linux/Vim/config/php_function_list.txt
" autocmd filetype php set dictionary+=E:/Material/Linux/Vim/config/php_function_list.txt

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

" ---------- YouCompleteMe {{{3
let g:ycm_global_ycm_extra_conf = '~/.ycm_extra_conf.py'
let g:ycm_confirm_extra_conf = 0
" generate and use .cache folder in the working directory
let g:ycm_clangd_uses_ycmd_caching = 0
let g:ycm_clangd_args = ['-j=8']
" mapping should be put to 'after' folder and check if exists('g:loaded_youcompleteme')
command! YcmOn let g:ycm_show_diagnostics_ui=1 <BAR>
  \let g:ycm_auto_trigger = 1 <BAR>
  \let g:ycm_auto_hover = 1 <BAR>
  \let g:ycm_enable_diagnostic_signs = 1 <BAR>
  \let g:ycm_enable_diagnostic_highlighting = 1 <BAR>
  \set signcolumn=auto <BAR>
  \exe 'nmap <c-]> :YcmCompleter GoTo<CR>'<BAR>
  \exe 'YcmRestartServer' <BAR>
  \exe 'YcmForceCompileAndDiagnostics'
command! YcmOff let g:ycm_show_diagnostics_ui = 0 <BAR>
  \set signcolumn=no <BAR>
  \let g:ycm_auto_trigger = 0 <BAR>
  \let g:ycm_auto_hover = 0 <BAR>
  \let g:ycm_enable_diagnostic_signs = 0 <BAR>
  \let g:ycm_enable_diagnostic_highlighting = 0 <BAR>
  \exe 'nunmap <c-]>' <BAR>
  \exe 'YcmRestartServer'

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

" ---------- config spell
set spellsuggest=file:~/.vim/spell/spellsuggest.txt,best
set spelllang+=cjk

" ---------- vim 8.0+ may miss the helptags
" Built-in doc
if isdirectory($VIMRUNTIME . '/doc')
  helptags $VIMRUNTIME/doc
endif
" User defined help doc
if isdirectory($HOME . '/doc')
  helptags $HOME/.vim/doc
endif

" ================================ commands ============================ {{{2
" ---------- trim the heading/trailing whitespaces {{{3
function! RemoveTrailingWhitespace()
  let lineNo = line(".")
  let oldLine = getline(lineNo)
  let newLine = substitute(oldLine, '\s\+$', '', 'e')
  if strlen(oldLine) == strlen(newLine)
    return
  endif
  call setline(lineNo, newLine)
endfunction

function! RemoveBeginningWhitespace()
  let lineNo = line(".")
  let oldLine = getline(lineNo)
  let newLine = substitute(oldLine, '^\s\+', '', 'e')
  if strlen(oldLine) == strlen(newLine)
    return
  endif
  call setline(lineNo, newLine)
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
    \mks<bang> ~/tmp/tmp.ses<BAR>
    \echo "made session at: ~/tmp/tmp.ses"<BAR>
  \endif
" command! -nargs=? -bang Loadsession so $ses <args>
command! -nargs=? -bang Loadsession silent echo "try to load session"<BAR>
  \if "<args>" != ""<BAR>
    \so <args><BAR>
    \echo "loaded session from: <args>"<BAR>
  \else<BAR>
    \so ~/tmp/tmp.ses<BAR>
    \echo "loaded session from: ~/tmp/tmp.ses"<BAR>
  \endif<BAR>

" ---------- insert current time in the current position, after the cursor box {{{3
command! Time echo strftime("%Y-%m-%d-%a %H:%M:%S")<BAR>
"   \"=strftime("%Y-%m-%d %H:%M:%S")<CR><BAR>
"   \gP
" = register is the expression output register, 6. Expression register "= can only be used onece
" normal mode insert current time, and enter insert mode
nnoremap time "=strftime("%Y-%m-%d-%a %H:%M:%S")<CR>pa
nnoremap timelog "="\n## " . strftime("%Y-%m-%d-%a %H:%M:%S") . "\ntag: \n"<CR>PjjA
nnoremap todo gg"="\n## [ ] \ncreate: " . strftime("%Y-%m-%d-%a %H:%M:%S") . "\nstart: \nend: \ndesc: \n"<CR>PjA

" ---------- grep current keyword, the silver searcher
" The Silver Searcher
if executable('ag')
  " Use ag over grep
  set grepprg=ag\ --nogroup\ --nocolor
  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0
endif
" add ! to override "prevent vim grep from opening first matching file"
" and "press Enter to continue"
nnoremap K :grep! "<C-R><C-W>"<CR>:rightbelow cw<CR>
vmap K :grep! "<C-R><C-W>"<CR>:rightbelow cw<CR>

" ---------- auto change IME to en {{{3
" for some type of files auto ime is needed
autocmd! InsertLeave *.txt,*.md,*.tex,*.log call ChangeIme(g:autoChangeIme)
let g:autoChangeIme = 1
function! ChangeIme(autoChangeIme)
  if has('win32') && a:autoChangeIme
    exe '!start /MIN cmd /c start "change ime" /MIN changeVimIme2En.lnk'
    exe 'echo "back to normal mode by calling changeVimIme2En.lnk"'
  elseif has('mac') && a:autoChangeIme
    silent exe '!xkbswitch -se ABC'
    " let cmd="!osascript -e 'tell application @System Events@' -e 'keystroke @ @ using {command down}' -e 'end tell'"
    " let cmd=substitute(cmd, '@', '"', 'g')
    " silent exe cmd " not working
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
    \setlocal spelllang=en spell<BAR>
    \echo "spell check enabled"<BAR>
  \endif

" ---------- focus certain window {{{3
" this also can be done with "number <c-w> w" under normal mode
" the win number is assending from top-down left-right seqeunce
command! -count=1 W <count> winc w

" ---------- set vim format footer fo baidu cpp {{{3
command! Baiducpp echo "add baidu cpp file vim mode lines"<BAR>
  \silent call append('$',  '// vim: et tw=80 ts=4 sw=4 cc=80:')<BAR>
  \exe ":w"<BAR>
  \exe ":e"
command! Googlecpp echo "add google cpp file vim mode lines"<BAR>
  \silent call append('$',  '// vim: et tw=80 ts=2 sw=2 cc=80:')<BAR>
  \exe ":w"<BAR>
  \exe ":e"

" ---------- Sum the selected text {{{3
" sum the numbers selected block, result will be stored in default register
command! -range -nargs=? Sum let col = str2nr("<args>")<BAR>
  \ if col == 0 | let col += 1 | endif<BAR>
  \ call CalculateVisualBlock(col, '+')<BAR>

command! -range -nargs=? Mul let col = str2nr("<args>")<BAR>
  \ if col == 0 | let col += 1 | endif<BAR>
  \ call CalculateVisualBlock(col, '*')<BAR>

function! CalculateVisualBlock(col, operator)
  let regz = getreg('z')
  let reg = '*'
  exe "norm! gv"
  exe 'norm! "' . reg . 'y'
  let text = getreg(reg)
  let line_list = []
  let idx = stridx(text, "\n")
  while idx > 0
    " add a space to the head of every line to match the pattern, tricky!
"     call add(line_list, ' ' . strpart(text, 0, idx))
    call add(line_list, strpart(text, 0, idx))
    let text = strpart(text, idx + 1)
    let idx = stridx(text, "\n")
  endwhile
  if len(text) > 0
    call add(line_list, text)
  endif
  if a:operator == '+'
    let result = 0
  else
    let result = 1
  endif
  " let pat = '\<-\?[0-9]\+\(\.*[0-9]\+\)\?\>'
  let pat = '\([\<<>?`~=+!@#$%^&*() \[\]{}\t/\|,;:"' . "'" . ']'. '\|^\)\zs-\?\d\+\(\.\d\+\)\?'
  " process on line, one line
  if len(line_list) == 1
    let line = line_list[0]
    while (1)
"       let result += str2float(matchstr(line, pat))
      exe "let result = result " . a:operator . " str2float(matchstr(line, pat))"
      let idx = matchend(line, pat)
      if idx < 0
        break
      endif
      let line = strpart(line, idx + 1)
    endwhile
  else " process on coloumns
    for i in line_list
      let line = i
      for j in range(2, a:col, 1)
        let idx = matchend(line, pat)
        if idx < 0
          break
        endif
        let line = strpart(line, idx + 1)
      endfor
"       let result += str2float(matchstr(line, pat))
      exe "let result = result " . a:operator . " str2float(matchstr(line, pat))"
    endfor
  endif
  call setreg(reg, string(result))
  echo result
endfunc

" ---------- Find line with certain tags {{{3
command! -nargs=+ FindTags let keys = split("<args>", " ")<BAR>
  \let pat = '\('<BAR>
  \for i in keys<BAR>
  \  let pat = pat . i . '\|'<BAR>
  \endfor<BAR>
  \let pat = strpart(pat, -2, strlen(pat))<BAR>
  \let pat = pat . '\)'<BAR>
  \let pat_line = ''<BAR>
  \for i in range(len(keys))<BAR>
  \  let pat_line = pat_line . '.\{-}' . pat<BAR>
  \endfor<BAR>
  \let pat_line .= '.\{-}'<BAR>
  \exe "/" . pat_line<BAR>
" .*\(c++\|time\).*\1.*

" ---------- Run {{{3
command! Run call Run()

command! Cw exe ":belowright cw"
" command! Cw exe ":botright cw"

" ---------- Blame, git blame  {{{3
" Toggle git blame for the current file
function! BlameImpl()
  let path = expand('%:p') " Get path of current file immediately
  " Backup source window status
  if !exists('b:scb_bak') | let b:scb_bak = &scb | endif
  if !exists('b:crb_bak') | let b:crb_bak = &crb | endif
  let cur_pos = getcurpos()[1:2] " We need line and column only
  if exists('t:blame_bufnr')
    let cur_win_buf = bufnr() " Backup current window nr
    " Go to blame window of current tab
    exe ":" . bufwinnr(t:blame_bufnr) . "wincmd w"
    if (bufnr() == t:blame_bufnr) " Double check
      silent! exe ":q!"
      unlet t:blame_bufnr
      " Go back to window which calls this function
      exe ":" . bufwinnr(cur_win_buf) . "wincmd w"
      " Restore status
      if b:scb_bak | set scb | else | set noscb | endif
      if b:crb_bak | set crb | else | set nocrb | endif
      unlet b:scb_bak 
      unlet b:crb_bak 
    endif
    return
  endif
  " We must set the cursor of src file to :0 before vsplit and scroll binding,
  " otherwise the cursor may be out of sync even 'scb' and 'crb' are set
  exe ":0"
  exe ":40vsp __git_blame__"
  let t:blame_bufnr = bufnr()
  setl winfixwidth
  setl nonu nocursorcolumn nowrap
  setl stl=%=B%nW%{winnr()}
  " exe ":%!git blame " . path . " | awk '" . '{print $3" "$4" "$1" "$2}' . "'"
  " silent! exe ":%!git blame " . path . " | cut -b1-40"
  silent! exe ":%!git blame " . path . " | sed -r '" . 's/^(\S+) [^(]* ?\(([^(]+  *[0-9]{4}-[0-9]{2}-[0-9]{2}).*\) .*/\2 \1/'. "'"
  exe ":0"
  setl scb cursorbind
  setl readonly
  " Active source code window
  wincmd l
  setl scb cursorbind
  call cursor(cur_pos)
endfunc
" Toggle or reload
function! Blame(reload)
  if !exists('t:blame_bufnr') || !a:reload " Hack in to impl, t:blame_bufnr
    call BlameImpl()
    return
  endif
  " if a:reload, the only situation left
  call BlameImpl()
  call BlameImpl()
endfunc
command! -bang Blame if "<bang>" == "" <BAR> call Blame(0) <BAR> else <BAR> call Blame(1) <BAR> endif

" ---------- Diff, git diff  {{{3
" Call `git difftool` for current file or directory
function! Diff(isdir)
  " ATTN: we are intent to skip checking &readonly property in case the source
  "       file may be edited in diff session
  let num_buf = len(filter(range(1, bufnr('$')), 'buflisted(v:val)'))
  if num_buf == 2 && &diff " This is a diff sesstion, quit
    exe ":qa"
    return
  elseif &diff
    echohl Error
    echo "In a diff session that may be not initiated by ':Diff', please exit this session manually."
    echohl None
    return
  endif
  if !HasRequiredCmd('vimdiff') || !HasRequiredCmd('git')
    return
  endif
  " Launch a separate session showing diff content
  if a:isdir
    silent! exe "!git difftool --tool=vimdiff -y"
  else
    silent! exe "!git difftool --tool=vimdiff -y %"
  endif
  edit! " Reload current buffer, because it may be edited in diff session
  redraw! " We need to redraw due to silient running external command
endfunction
command! -bang Diff if "<bang>" == "" <BAR> call Diff(0) <BAR> else <BAR> call Diff(1) <BAR> endif

" ========================= file type ================================== {{{2
autocmd BufNewFile,BufRead *.alipaylog setf alipaylog
autocmd BufNewFile,BufRead *.md setlocal foldexpr=MarkdownFoldExpr(v:lnum) fdm=expr
autocmd BufNewFile,BufRead BCLOUD setf python
autocmd BufNewFile,BufRead *.git/COMMIT_EDITMSG setl spelllang=en spell
autocmd BufNewFile,BufRead *.dot,*.gv setl makeprg=dot\ -Tsvg\ -oa.svg\ %
" autocmd BufEnter * set et
autocmd BufEnter,BufRead,WinEnter *.md setl noet
" quickfix key map, p: preview
autocmd WinEnter * if &ft == "qf" | nmap <buffer> p <CR>gbw | endif
" if the error to open is not in the same window of current tab, open a newtab
set switchbuf=usetab,newtab

" ---------  Unique, unique all lines {{{3
command! Unique exe 'g/^\(.*\)\n\1$/d'

" ---------  Half-width, make all full-width symbols half-width {{{3
command! -range=% Halfwidth echo "" |
  \let rep = {'：': ': ', '　': ' ', '，':', ', '、':', ', '。':'. ', '．':'. ', '？':'? ', '！':'! ', '～':'\~ ', '＄':'$ ', '％':'% ', '＠':'@ ', '＆':'\& ', '＃':'# ', '＊':'* ', '；':'; ', '︰':': ', '…':'... ', '‥':'. ', '﹐':', ', '﹒':'. ', '˙':'. ', '‘':"' ", '’':"' ", '“':'"', '”':'"', '〝':'"', '〞':'"', '（':'(', '）':')', '－': '-'} |
  \for key in keys(rep) |
  \   silent! exe "<line1>,<line2>s/" . key . "/" . rep[key] . "/g" |
  \endfor

" -------- make/remove anchor for markdown
command! -range=% MarkdownAddAnchor echo "add anchor for markdown" |
  \if &ft == "markdown" |
  \  exe '<line1>,<line2>s/^\(#\+ *\)\(.*\)/\1[\2](id:\2)/gc' |
  \endif
command! -range=% MarkdownRemoveAnchor echo "remove anchor for markdown" |
  \if &ft == "markdown" |
  \  exe '<line1>,<line2>s/^\(#\+ *\)\[\(.*\)\](id:.*)/\1\2/gc' |
  \endif
command! -range=% MarkdownMakeToc echo "make table of content for markdown" |
  \if &ft == "markdown" |
  \  exe 'MarkdownRemoveAnchor' |
  \  exe 'MarkdownAddAnchor' |
  \  exe '<line1>,<line2>s/^\(#\+ *\)\[\(.*\)\](id:.*)/\1\2/gc' |
  \endif

" -------- inter-convert under_score to/from camel
command! -range ToUpperCamel s#\<\(_*\)\([a-zA-Z]\)\|_\+\([0-9A-Za-z]\)#\1\u\2\u\3#g | noh
command! -range ToLowerCamel s#\<\(_*\)\([a-zA-Z]\)\|_\+\([0-9A-Za-z]\)#\1\l\2\u\3#g | noh
command! -range ToLowerUnderscore s#\<\@<!\([A-Z]\)#_\l\1#g | noh
command! -range ToUpperUnderscore s#\<\@<!\([A-Z]\)#_\u\1#g | noh

" ========================= autocmd ================================== {{{2
" this command has bug when create new window, say tagbar
augroup netrw " ---------- {{{3
  autocmd WinEnter * let bufnrlist = tabpagebuflist() |
      \if bufname(bufnrlist[0]) =~ "NetrwTreeListing" |
      \  let curWinnr = winnr() |
      \  let winsz = float2nr(g:netrw_winsize_ratio * g:max_win_width) |
      \  exe "1wincmd w" |
      \  exe winsz . "wincmd |" |
      \  exe curWinnr . "wincmd w" |
      \endif
augroup end

" netrw bug: No write since last change for buffer
autocmd FileType netrw setl bufhidden=delete

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

  " a:0 is the number of EXTRA arguments
  if a:0 < 1
    let l:delim = input("surround with:")
  else
    let l:delim = a:1
  endif
  if l:delim == ''
    let l:delim=g:default_surround_mark
    echo l:delim
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
function! GetSelection() range
  " Why is this not a built-in Vim script function?!
  let l:isVisual = 0
  if mode() == 'v' || mode() == 'V' || mode() == "CTRL-V"
    let l:isVisual = 1
    norm! "<esc>"
  endif
  let [lnum1, col1] = getpos("'<")[1:2]
  let [lnum2, col2] = getpos("'>")[1:2]
  let lines = getline(lnum1, lnum2)
  let lines[-1] = lines[-1][: col2 - (&selection == 'inclusive' ? 1 : 2)]
  let lines[0] = lines[0][col1 - 1:]
  let l:res =  join(lines, "\n")
  " echo l:res
  if l:isVisual
    norm! "gv"
  endif
  return l:res
endfunction

" ---------- RefreshCurrentTab() {{{3
" DEPRECATED, and will be remove some day, `:redraw!` can do the job
function! RefreshCurrentTab()
  " refresh the current tab
  " tabnew and tabc will make the next tab active if there are more than 1 tabs
  " save the current tabpage number
  if exists("g:last_tab_num")
    let tmpTabNum = g:last_tab_num
  endif
  let curTabNum = tabpagenr()
  exe 'tabnew'
  exe 'tabc'
  if tabpagenr('$') != curTabNum
    exe 'tabp'
  endif
  if exists("tmpTabNum")
    let g:last_tab_num = tmpTabNum
  endif
endfunction

" ---------- MarkdownFoldExpr() {{{3
function! MarkdownFoldExpr(lnum)
  let headingLvl = strlen(substitute(getline(a:lnum), '^\(#*\).*', '\1', ''))
  if headingLvl < 1
    return '='
  else
    return '>'.headingLvl
endfunction

" ---------- PrintableThriftFoldExpr() {{{3
function! PrintableThriftFoldExpr(lnum)
  let line = getline(a:lnum)
  let headingLvl = strlen(substitute(line, '^\( \+\).*\s*$', '\1', ''))
  if match(line, '^\( \+\)},\s*$', 0) >= 0
    let headingLvl += 2
  elseif headingLvl == strlen(line)
    let headingLvl = 0
  endif
  let headingLvl = headingLvl / 2
  if headingLvl < 1
    return '='
  else
    return '>'.headingLvl
endfunction

" ---------- SwitchTab() {{{3
let g:last_tab_num = tabpagenr()
nmap gbt :exe 'normal! ' . g:last_tab_num . 'gt' <BAR>echo "go back to last tab"<CR>
autocmd TabLeave * let g:last_tab_num = tabpagenr()

" ---------- switch window {{{3
let g:last_win_num = tabpagewinnr(tabpagenr())
autocmd TabEnter * call GenLastWinNum()
" autocmd TabLeave <tab> tabclose
nmap gbw :exe t:last_win_num . 'wincmd w' <BAR>echo "go back to last window: " . t:last_win_num<CR>
autocmd WinLeave * let t:last_win_num = tabpagewinnr(tabpagenr())
" TODO: make it work even if tab changed
function! GenLastWinNum()
  if !exists('t:last_win_num')
    let t:last_win_num = tabpagewinnr(tabpagenr())
  endif
endfunc
function! ChangeLastWinNum()
  let t:last_win_num = tabpagewinnr(tabpagenr())
endfunc

" ---------- Generate header number for markdown
" parsing section numbers is a procedure of stacking and popping heading levels
" TODO: add param to specify whether this call is to generate or
"       to update section numbers
function! GenMarkdownSectionNum()
  if &ft != "markdown"
    echohl Error
    echo "filetype is not markdown"
    echohl None
    return
  endif

  let lvl = []
  let sect = []
  let out = ""
  for i in range(1, line('$'), 1)
    let line = getline(i)
    let heading_lvl = strlen(substitute(line, '^\(#*\).*', '\1', ''))
    if heading_lvl < 2
      continue
    endif
    " there should be only 1 H1, topmost, on a conventional web page
    " we should generate section numbers begin with the first heading level 2
    if len(lvl) == 0
      if heading_lvl != 2 " count from level 2
        echohl Error
        echo "subsection must have parent section, ignore illegal heading line at line " . i
        echohl None
        continue
      endif
      call add(sect, 1)
      call add(lvl, heading_lvl)
    else
      if lvl[-1] == heading_lvl
        let sect[-1] = sect[-1] + 1
      elseif lvl[-1] > heading_lvl " pop all lvl less than heading_lvl from tail
        while len(lvl) != 0 && lvl[-1] > heading_lvl
          call remove(lvl, -1)
          call remove(sect, -1)
        endwhile
        let sect[-1] = sect[-1] + 1
      elseif lvl[-1] < heading_lvl
        if heading_lvl - lvl[-1] != 1
          echohl Error
          echo "subsection must have parent section, ignore illegal heading line at line " . i
          echohl None
          continue
        endif
        call add(sect, 1)
        call add(lvl, heading_lvl)
      endif
    endif

    let cur_sect = ""
    for j in sect
      let cur_sect = cur_sect . "." . j
    endfor
    let cur_sect = cur_sect[1:]
    let out = out . " " . cur_sect
    call setline(i, substitute(line, '^\(#\+\) \?\([0-9.]\+ \)\? *\(.*\)', '\1 ' . cur_sect . ' \3', line))
  endfor
  " echo lvl sect out
  echo out
endfunc

command! MarkdownAddSection call GenMarkdownSectionNum()

" ---------- GetMaxWindowSize() {{{3
"Returns a list contains [max_height, max_width, ...]
" let g:max_win_height = 0
" let g:max_win_width = 0
function! GetMaxWindowSize()
  if exists("g:last_tab_num")
    let tmpTabNum = g:last_tab_num
  endif
  tabnew
  let g:max_win_height = winheight('.')
  let g:max_win_width = winwidth('.')
  tabc
  if exists("tmpTabNum")
    let g:last_tab_num = tmpTabNum
  endif
  return [g:max_win_height, g:max_win_width]
endfunc
call GetMaxWindowSize()

" ============================ tagbar ==================================== {{{2
let g:tagbar_sort = 0 " do not sort tags by name
" g:tagb_type_${filetype} = {}
let g:tagbar_type_asciidoc = {
    \ 'ctagstype' : 'asciidoc',
    \ 'ctagsbin' : 'ctags',
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
    \ 'ctagsbin' : 'ctags',
    \ 'kinds' : [
      \ 'h:heading',
    \ ],
    \ 'sort' : 0
\ }

let g:tagbar_type_go = {
    \ 'ctagstype' : 'go',
    \ 'ctagsbin' : 'ctags',
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

let g:tagbar_type_proto = {
    \ 'ctagstype' : 'protobuf',
    \ 'ctagsbin' : 'ctags',
    \ 'kinds' : [
      \ 'p:package',
      \ 'm:message',
      \ 'f:field',
      \ 's:service',
      \ 'e:enumerator',
      \ 'g:enum',
      \ 'r:rpc'
    \ ],
    \ 'sro' : '.',
    \ 'sort' : 0
\ }

if executable('ctags_haskell')
    let g:tagbar_type_haskell = {
        \ 'ctagsbin' : 'ctags_haskell',
        \ 'ctagsargs' : '--ignore-parse-error --',
        \ 'kinds' : [
            \ 'm:module:0',
            \ 'e:exports:1',
            \ 'i:imports:1',
            \ 't:declarations:0',
            \ 'd:declarations:1',
            \ 'n:declarations:1',
            \ 'f:functions:0',
            \ 'c:constructors:0'
        \ ],
        \ 'sro' : '.',
        \ 'kind2scope' : {
            \ 'd' : 'data',
            \ 'n' : 'newtype',
            \ 'c' : 'constructor',
            \ 't' : 'type'
        \ },
        \ 'scope2kind' : {
            \ 'data' : 'd',
            \ 'newtype' : 'n',
            \ 'constructor' : 'c',
            \ 'type' : 't'
        \ }
    \ }
endif

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

" vim:tw=80:ts=2:ft=vim:et:foldcolumn=2:foldenable:fdl=3
