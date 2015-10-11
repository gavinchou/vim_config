" extend case insensetive search when use key 'f', 'F', ';' and ',' in normal
" mode, 
" AUTHOR: Gavin Chou, gavineaglechou@gmail.com
" DATE: 2015-10-11-Sun
"
" NOTE: this plugin will remap the key 'f', 'F', ';' and ',', take a look at the
"       sricpt for more details
"       if option 'ignorecase' is no set, this plugin will act as the built-in
"       search
"       the built-in key 'f' is not affected by this plugin, say operatin of
"       'yfa' will still key case-sensitive
"
" PROCEDURE: get current line and find the first char behinde or infront of
"            cursor simulate smartcase, if upper letter is specified, only upper
"            case letter will be searched
"
" CALLS: stridx() strridx() toupper() tolower()

" remap all the `f` `F` key
for i in ['a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','r',
      \'s','t','u','v','w','x','y','z']
  exe "nmap f" . i . " :call findchar#FindChar(\"" . i . "\", 'forward')<CR>"
  exe "nmap F" . i . " :call findchar#FindChar(\"" . i . "\", 'backward')<CR>"
endfor
for i in ['A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','R',
      \'S','T','U','V','W','X','Y','Z']
  exe "nmap f" . i . " :call findchar#FindChar(\"" . i . "\", 'forward')<CR>"
  exe "nmap F" . i . " :call findchar#FindChar(\"" . i . "\", 'backward')<CR>"
endfor
for i in ['~','!','@','#','$','%','^','&','*','(',')','_','+','-','=','`','{',
      \'}','\|','[',']','\',';',':','"',',','.','/','<','>','?']
  exe "nmap f" . i . " :call findchar#FindChar('" . i . "', 'forward')<CR>"
  exe "nmap F" . i . " :call findchar#FindChar('" . i . "', 'backward')<CR>"
endfor
nmap f' :call findchar#FindChar("'", 'forward')<CR>
nmap F' :call findchar#FindChar("'", 'backward')<CR>
nmap f<space> :call findchar#FindChar(" ", 'forward')<CR>
nmap F<space> :call findchar#FindChar(" ", 'backward')<CR>
nmap f<tab> :call findchar#FindChar("	", 'forward')<CR>
nmap F<tab> :call findchar#FindChar("	", 'backward')<CR>


" this global var keeps the char last used by FindChar()
let g:findchar_lastFoundChar=''
nmap ; :call findchar#RepeatFind('forward')<CR>
nmap , :call findchar#RepeatFind('backward')<CR>
function! findchar#RepeatFind(dir)
  if g:findchar_lastFoundChar == ''
    return
  endif
  call findchar#FindChar(g:findchar_lastFoundChar, a:dir)
endfunc

function! findchar#FindChar(char, direction)
  let g:findchar_lastFoundChar = a:char
  let curline = getline('.')
  let curcolnum = getpos('.')[2]
  " find non-letter char
  if !(a:char >= 'a' && a:char <= 'z') && !(a:char >= 'A' && a:char <= 'Z')
    if a:direction == 'forward'
      let idxFound = stridx(curline, a:char, curcolnum)
      exe 'normal! f' . a:char
    else
      let idxFound = strridx(curline, a:char, curcolnum > 1 ? curcolnum - 2 : 0)
      exe 'normal! F' . a:char
    endif
    let char = a:char
    if a:char == "	"
      let char = "(tab)"
    elseif a:char == ' '
      let char = '(space)'
    endif
    if idxFound >= 0
      echo a:direction . " found: " . char . " @col " . (idxFound + 1)
    else
      echo a:direction . " not found: " . char
    endif
    return
  endif

  " case-sensitive is on, act as original 'f'
  if !&ignorecase
    if a:direction == 'backward'
      exe 'normal! F' . a:char
    else
      exe 'normal! f' . a:char
    endif
    echo "case sensitive, " . a:direction . " found: " . a:char
    return
  endif

  " case-insensitive
  let caseStatus = 'case-insensitive'
  let isUpper = 0 " for smartcase
  " if ignore case, 'a' == 'A' will be true
  set noignorecase
  if a:char >= 'A' && a:char <= 'Z'
    let isUpper = 1
    let caseStatus = 'case-sensitive'
  endif
  set ignorecase
  let charLower = tolower(a:char)
  let charUpper = toupper(a:char)
  if a:direction == 'backward'
    " curcolnum is based on '1', while stridx is based on zero
    let idxLower = strridx(curline, charLower, curcolnum > 1 ? curcolnum - 2 : 0)
    let idxUpper = strridx(curline, charUpper, curcolnum > 1 ? curcolnum - 2 : 0)
  else
    let idxLower = stridx(curline, charLower, curcolnum)
    let idxUpper = stridx(curline, charUpper, curcolnum)
  endif
  let charCol = idxUpper + 1
  " echo idxLower . " " . idxUpper . " isupper: " . isUpper
  if (idxLower < 0 && idxUpper < 0) || (isUpper && idxUpper < 0)
    " not found, do nothing
    echo caseStatus . ", " . a:direction . " not found: " . a:char
    return
  endif

  if a:direction == 'backward'
    if isUpper
      exe 'normal! F' . a:char
    else
      if (idxLower >= 0 && idxLower > idxUpper) || idxUpper < 0
        let charCol = idxLower
        exe 'normal! F' . charLower
      else
        exe 'normal! F' . charUpper
      endif
    endif
  else
    if isUpper
      exe 'normal! f' . a:char
    else
      if (idxLower >= 0 && idxLower < idxUpper) || idxUpper < 0
        let charCol = idxLower
        exe 'normal! f' . charLower
      else
        exe 'normal! f' . charUpper
      endif
    endif
  endif
  echo caseStatus . ", " . a:direction . " found: " . a:char . " @col " . charCol
endfunc

