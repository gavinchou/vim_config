" NeatStatus (c) 2012 Lukasz Grzegorz Maciak
" Neat and simple status line - because Powerline is overrated
"    _   _            _   ____  _        _
"   | \ | | ___  __ _| |_/ ___|| |_ __ _| |_ _   _ ___
"   |  \| |/ _ \/ _` | __\___ \| __/ _` | __| | | / __|
"   | |\  |  __/ (_| | |_ ___) | || (_| | |_| |_| \__ \
"   |_| \_|\___|\__,_|\__|____/ \__\__,_|\__|\__,_|___/
"   Vim plugin by Luke Maciak (c) 2012
"
" Loosely based on a script by Tomas Restrepo (winterdom.com)
" Original available here:
" http://winterdom.com/2007/06/vimstatusline
" Modified by Gavin:
" <https://github.com/gavinchou/vim_config>

" finish

set ls=2 " Always show status line
let g:last_mode=""

" Color Scheme Settings
" You can redefine these in your .vimrc

" Black on Green
if !exists('g:NeatStatusLine_color_normal')   | let g:NeatStatusLine_color_normal   = 'guifg=#000000 guibg=#7dcc7d gui=NONE ctermfg=0 ctermbg=2 cterm=NONE'    | endif
" White on Red
if !exists('g:NeatStatusLine_color_insert')   | let g:NeatStatusLine_color_insert   = 'guifg=#ffffff guibg=#ff0000 gui=NONE ctermfg=15 ctermbg=9 cterm=NONE'   | endif
" Yellow on Blue
if !exists('g:NeatStatusLine_color_replace')  | let g:NeatStatusLine_color_replace  = 'guifg=#ffff00 guibg=#5b7fbb gui=NONE ctermfg=190 ctermbg=67 cterm=NONE' | endif
" White on Purple
if !exists('g:NeatStatusLine_color_visual')   | let g:NeatStatusLine_color_visual   = 'guifg=#ffffff guibg=#810085 gui=NONE ctermfg=15 ctermbg=53 cterm=NONE'  | endif
" White on Black
if !exists('g:NeatStatusLine_color_position') | let g:NeatStatusLine_color_position = 'guifg=#ffffff guibg=#000000 ctermfg=15 ctermbg=0'                       | endif
" White on Pink
if !exists('g:NeatStatusLine_color_modified') | let g:NeatStatusLine_color_modified = 'guifg=#ffffff guibg=#ff00ff ctermfg=15 ctermbg=5'                       | endif
" Pink on Black
if !exists('g:NeatStatusLine_color_line')     | let g:NeatStatusLine_color_line     = 'guifg=#ff00ff guibg=#000000 gui=NONE ctermfg=207 ctermbg=0 cterm=NONE'  | endif
" Black on dark Cyan
if !exists('g:NeatStatusLine_color_filetype') | let g:NeatStatusLine_color_filetype = 'guifg=#000000 guibg=#5fafdf gui=NONE ctermfg=0 ctermbg=74 cterm=NONE'   | endif

"==============================================================================

" Set up the colors for the status bar
function! SetNeatstatusColorscheme()

    " Basic color presets
"     exec 'hi User1 '.g:NeatStatusLine_color_normal
"     exec 'hi User2 '.g:NeatStatusLine_color_replace
"     exec 'hi User3 '.g:NeatStatusLine_color_insert
"     exec 'hi User4 '.g:NeatStatusLine_color_visual
"     exec 'hi User5 '.g:NeatStatusLine_color_position
"     exec 'hi User6 '.g:NeatStatusLine_color_modified
"     exec 'hi User7 '.g:NeatStatusLine_color_line
"     exec 'hi User8 '.g:NeatStatusLine_color_filetype

    let g:black_on_green = g:NeatStatusLine_color_normal
    let g:yellow_on_blue = g:NeatStatusLine_color_replace
    let g:white_on_red = g:NeatStatusLine_color_insert
    let g:white_on_purple = g:NeatStatusLine_color_visual
    let g:white_on_black = g:NeatStatusLine_color_position
    let g:white_on_pink = g:NeatStatusLine_color_modified
    let g:pink_on_black = g:NeatStatusLine_color_line
    let g:black_on_cyan = g:NeatStatusLine_color_filetype

    exec 'hi User1 '.g:black_on_green
    exec 'hi User2 '.g:yellow_on_blue
    exec 'hi User3 '.g:white_on_red
    exec 'hi User4 '.g:white_on_purple
    exec 'hi User5 '.g:white_on_black
    exec 'hi User6 '.g:white_on_pink
    exec 'hi User7 '.g:pink_on_black
    exec 'hi User8 '.g:black_on_cyan

endfunc

" pretty mode display - converts the one letter status notifiers to words
function! statusline#Mode()
    redraw
    let l:mode = mode()
    " exec 'hi Test guifg=#000000 guibg=#7dcc7d gui=NONE ctermfg=0 ctermbg=2 cterm=NONE'
    " return mode()
    " the following statement may take too long to exec
    if     mode ==# "n"  | exec 'hi User1 '.g:NeatStatusLine_color_normal  | return "N"
    elseif mode ==# "i"  | exec 'hi User1 '.g:NeatStatusLine_color_insert  | return "I"
    elseif mode ==# "R"  | exec 'hi User1 '.g:NeatStatusLine_color_replace | return "R"
    elseif mode ==# "" | exec 'hi User1 '.g:NeatStatusLine_color_visual  | return "VB"
    else                 | return l:mode
    endif
endfunc

function! statusline#ModeChange(mode)
    let stl = &stl
    let stl = strpart(stl, 5)
    if     a:mode ==# "normal"  | let stl="%1* N".stl | exe "hi StatusLine ". g:StatusLineNormal
    elseif a:mode ==# "insert"  | let stl="%3* I".stl | exe "hi StatusLine ". g:StatusLineInsert
    else | return
    endif
    let stl = escape(stl, ' ')
    " echo stl
    exec "setlocal stl=".stl
endfunc

if has('statusline')

  augroup statusline
    au InsertEnter * call statusline#ModeChange("insert")
    au InsertLeave * call statusline#ModeChange("normal")
  augroup end

    let g:StatusLineNormal = 'ctermfg=16 ctermbg=154 cterm=NONE guifg=#000000 guibg=#afff00 gui=NONE'
    let g:StatusLineInsert = 'ctermfg=16 ctermbg=202 cterm=NONE guifg=#000000 guibg=#ff4a2f gui=NONE'

    " set up color scheme now
    call SetNeatstatusColorscheme()

    " Status line detail:
    " -------------------
    "
    " %f    file name
    " %F    file path
    " %y    file type between braces (if defined)
    "
    " %{v:servername}   server/session name (gvim only)
    "
    " %<    collapse to the left if window is to small
    "
    " %( %) display contents only if not empty
    "
    " %1*   use color preset User1 from this point on (use %0* to reset)
    "
    " %([%R%M]%)   read-only, modified and modifiable flags between braces
    "
    " %{'!'[&ff=='default_file_format']}
    "        shows a '!' if the file format is not the platform default
    "
    " %{'$'[!&list]}  shows a '*' if in list mode
    " %{'~'[&pm=='']} shows a '~' if in patchmode
    "
    " %=     right-align following items
    "
    " %{&fileencoding}  displays encoding (like utf8)
    " %{&fileformat}    displays file format (unix, dos, etc..)
    " %{&filetype}      displays file type (vim, python, etc..)
    "
    " #%n   buffer number
    " %l/%L line number, total number of lines
    " %p%   percentage of file
    " %c%V  column number, absolute column number
    " &modified         whether or not file was modified
    "
    " %-5.x - syntax to add 5 chars of padding to some element x

    function! SetStatusLineStyle()

        let stl=""
        " mode (changes color)
        " let stl.="%1* %{Mode()} %0*"
        let stl.="%1* N %0*"
        " file path
        let stl.=" %<%F "
        " read only, modified, modifiable flags in brackets
        let stl.="%6*%(%{(&modified!=0? ' + ':'')}%)"
        let stl.="%6*%{(&ro!=0? ' RO ':'')}"

        " file type (eg. python, ruby, etc..)
        let stl.="%8*%( %{&filetype} %)%0*"
        " file format (eg. unix, dos, etc..) file encoding (eg. utf8, latin1, etc..)
        let stl.="%2* %{statusline#GetFileFormat()} "
        let stl.="%(%{(&fenc!=''?&fenc:&enc)} %)%0*"

        " right-aligh everything past this point
        let stl.="%= "
        " byte value
        let stl.="0x%-2.B "
        " line number (pink) / total lines, col virtual col
        let stl.="%5* %7*L%l%5*/%L\ "
        let stl.="%7*C%c%5*%V/%{strwidth(getline('.'))} %0*"
        " buffer number, winnr
        let stl.=" B%nW%{winnr()} "

        " echo stl
        let stl=escape(stl, ' ')
        " set stl=%1*\ %{Mode()}\ %0*\ %<%F\ %6*%(%{(&modified!=0?\ '\ +\ ':'')}%)%6*%{(&ro!=0?\ '\ RO\ ':'')}%8*%(\ %{&filetype}\ %)%0*\ %{&fileformat}\ %(%{(&fenc!=''?&fenc:&enc)}\ %)%=\ 0x%-2.B\ %5*\ %7*%l%5*/%L\ %0*\ %c%V\ [b%nw%{winnr()}]
        " exec "setlocal stl=" . stl
        exec 'set stl='.stl

    endfunc

    "FIXME: hack to fix the repeated statusline issue in console version
"     if !has('gui_running')
"         au InsertEnter  * redraw!
"         au InsertChange * redraw!
"         au InsertLeave  * redraw!
"     endif

    " whenever the color scheme changes re-apply the colors
    au ColorScheme * call SetNeatstatusColorscheme()

    " Make sure the statusbar is reloaded late to pick up servername
    au ColorScheme,VimEnter * call SetStatusLineStyle()

    " Switch between the normal and vim-debug modes in the status line
    call SetStatusLineStyle()
    " Window title
    if has('title')
        set titlestring="%t%(\ [%R%M]%)".expand(v:servername)
    endif

endif

function! statusline#GetFileFormat()
  if &fileformat == 'unix'
    return '\n'
  elseif &fileformat == 'dos'
    return '\r\n'
  elseif &fileformat == 'mac'
    return '\r'
  endif
endfunc

" ====== future use, fix the problem all the mode display change when change
" mode in only one window
"
" function! InsertStatuslineColor(mode)
"   if a:mode == 'i'
"     hi Statusline guibg=Cyan ctermfg=6 guifg=Black ctermbg=0
"   elseif a:mode == 'r'
"     hi Statusline guibg=Purple ctermfg=5 guifg=Black ctermbg=0
"   else
"     hi Statusline guibg=DarkRed ctermfg=1 guifg=Black ctermbg=0
"   endif
" endfunction
" 
" au InsertEnter * call InsertStatuslineColor(v:insertmode)
" au InsertLeave * hi StatusLine ctermfg=226 ctermbg=241 cterm=bold guifg=#ffff00 guibg=#64645e gui=bold
" 
" " default the statusline to green when entering Vim
" hi statusline guibg=DarkGrey ctermfg=8 guifg=White ctermbg=15

