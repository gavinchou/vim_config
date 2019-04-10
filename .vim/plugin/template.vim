command! -nargs=* FileHeader call template#FileHeader(<f-args>)
command! FuncHeader call template#FunctionHeader()
let g:file_template_header_author="zhoufei"
let g:file_template_header_email="zhoufei05@baidu.com"
" for line number auto increament
let s:file_template_line_num=0
function! template#FileHeader(...)
  let s:file_template_line_num=0
  if a:0 == 2
    let author = a:1
    let email = a:2
  else
    let author = g:file_template_header_author
    let email = g:file_template_header_email
  endif
  for each in ["cpp", "java", "c", "go", "dot"]
    if &ft == each
      silent call append(template#IncLine(), "/**")
      " silent call append(template#IncLine(), " * @file " . expand("%"))
      silent call append(template#IncLine(), " * @brief  ")
      silent call append(template#IncLine(), " * @author " . author)
      silent call append(template#IncLine(), " * @email  " . email)
      silent call append(template#IncLine(), " * @date   " . strftime("%Y-%m-%d-%a"))
      silent call append(template#IncLine(), " */")
      silent call setpos('.', [0, 1, 10, 0])
      return
    endif
  endfor

  if &ft == "vim"
    " silent call append(template#IncLine(), '" @file ' . expand("%"))
    silent call append(template#IncLine(), '" @brief  ')
    silent call append(template#IncLine(), '" @author ' . author)
    silent call append(template#IncLine(), '" @email  ' . email)
    silent call append(template#IncLine(), '" @date   ' . strftime("%Y-%m-%d-%a"))
    silent call append(template#IncLine(), '')
    silent call setpos('.', [0, 1, 10, 0])
    return
  endif

  for each in ["sh", "bash", "python", "conf", "awk", "sed"]
    if &ft == each
      silent call append(template#IncLine(), "#!/bin/bash")
      " silent call append(template#IncLine(), "  * @file " . expand("%"))
      silent call append(template#IncLine(), "## @brief  ")
      silent call append(template#IncLine(), "## @author " . author)
      silent call append(template#IncLine(), "## @email  " . email)
      silent call append(template#IncLine(), "## @date   " . strftime("%Y-%m-%d-%a"))
      silent call append(template#IncLine(), "")
      silent call setpos('.', [0, 1, 11, 0])
      return
    endif
  endfor

endfunc

function! template#FuncHeader()
  for each in ["cpp", "java", "c", "go"]
    if &ft == each
      silent call append(template#IncLine(), "/**")
      silent call append(template#IncLine(), " *  @brief ")
      silent call append(template#IncLine(), " *  @param ")
      silent call append(template#IncLine(), " *  @return ")
      silent call append(template#IncLine(), " */")
      return
    endif
  endfor
endfunc

function! template#IncLine()
  let lineNum = s:file_template_line_num
  let s:file_template_line_num += 1
  return lineNum
endfunction
