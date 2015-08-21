" this plugin formats the selected text table written in markdown syntax, say:
" the original table text is:
"
" header1|header2|header3
" -----|-----|-----
" aaa|b\|bb|cc
" dd|eeeee|ffffff
"
" each tabll collumn in the above table will be aligned as following:
"
" header1|header2|header3
" -----  |-----  |-----
" aaa    |b\|bb  |cc
" dd     |eeeee  |ffffff
"
" note: this plugin has capability with '\|'
"
" usage:
" 1. select the table
" 2. type the command 'Table'
"
" author: Gavin chou
" email: gavineaglechou@gmail.com

" this plugin format the table with the following steps:
" 1 find the longest element of each collumn
" 2 move '|' to the end of the element
" 3 <, > get the start and end line, and replace it with formatted mdTable
" 4 delete it and append new table

" change this to define your own command
command! -range Table <line1>, <line2> call FormatMarkdownTable()

" implementation
function! FormatMarkdownTable()
  " dubug switch, reading the whole code before switching this on after
  let isDebug = 0
  if (isDebug)
    echohl WarningMsg | echo "debug mode: " . isDebug | echohl None
    let mdTable =  ['选项|意义|其他',
          \'------|-----',
          \'data_retention_time|数据保留时间|',
          \'crash_check_interval|故障查看间隔|sdfds',
          \'gc_interval|垃圾回收间隔|中国年问',
          \'enable_reblance|是否自动负载均衡|fjdksalj',
          \'|负载均衡间隔|fjdksal',
          \'||']
"     let mdTable =  ['选项|意义|其他',
"           \'------|-----|-----',
"           \'data_retention_time|数据保留时间|fdsja',
"           \'crash_check_interval|故障查看间隔|sdfds',
"           \'gc_interval|垃圾回收间隔|中国年问',
"           \'enable_reblance|是否自动负载均衡|fjdksalj',
"           \'|负载均衡间隔|fjdksal',
"           \'||']
"     let mdTable =  ['选项|意义',
"           \'------|-----',
"           \'data_retention_time|数据保留时间',
"           \'crash_check_interval|故障查看间隔',
"           \'gc_interval|垃圾回收间隔',
"           \'enable_reblance|是否自动负载均衡',
"           \'fdsa|负载均衡间隔',
"           \'abc|def']
    let mdTable =  ['选项\||意义|其他',
          \'------|-----',
          \'data_retention_time|数据保\|留时间|fdsjakfldjsakl',
          \'crash_check_interval|故障查看间隔',
          \'||']
    echo mdTable
    let lineCount = 4
  else
    let startLine = getpos("'<")[1]
    let endLine = getpos("'>")[1]
    " in case of inverse selection
    if (startLine > endLine)
      let startLine = endLine
      let endLine = getpos("'<")
    endif
    let mdTable = getline(startLine, endLine)
    let lineCount = endLine - startLine + 1
  endif

  let colCount = 0
  " record the max length of each collumn
  let maxElementLength = []
  let newMdTable = []
  let done = 0

  " build a new list to store each element of the table in a 2-d array
  let i = 0
  while (i < lineCount)
    call insert(newMdTable, [])
    let i = i + 1
  endwhile
  " for each collumn
  while (1)

    " find a proper bar for table delimiter
    let fakeBarPos = stridx(mdTable[0], '\|')
    let barPos = stridx(mdTable[0], "|")
    while (1)
      " there is escaped bar
      if (fakeBarPos > -1) 
        " no escaped bar before the first true bar
        if (fakeBarPos > barPos) 
          break

        " continue to find a proper bar
        else
          let barPos = stridx(mdTable[0], "|", fakeBarPos + 2)
        endif
      else
        break
      endif
      " a proper bar found, or there are no more true bars
      if (barPos > fakeBarPos || barPos < 0)
        break
      endif
    endwhile
    let maxColWidth = 0

    if (barPos > -1)
      " when using unicode, strlen() returns the byte length
      " strdisplaywidth() returns the actual display width of the string
      " use the table header to separate each collumn
      let tmpWidth = strdisplaywidth(strpart(mdTable[0], 0, barPos))
      call add(newMdTable[0], [strpart(mdTable[0], 0, barPos), tmpWidth])
      let mdTable[0] = strpart(mdTable[0], barPos + 1, strlen(mdTable[0]) - barPos)

      let i = 1
      let maxColWidth = tmpWidth
      while (i < lineCount)

        " find a proper bar for table delimiter
        let fakeBarPos = stridx(mdTable[i], '\|')
        let barPos = stridx(mdTable[i], "|")
        while (1)
          " there is escaped bar
          if (fakeBarPos > -1) 
            " no escaped bar before the first true bar
            if (fakeBarPos > barPos) 
              break
            " find a proper bar
            else
              let barPos = stridx(mdTable[i], "|", fakeBarPos + 2)
            endif
          else
            break
          endif
          " a proper bar found, or there are no more true bars
          if (barPos > fakeBarPos || barPos < 0)
            break
          endif
        endwhile

        " add new collumn to a line
        " in case of the columns in table less then the headers'
        if (barPos == -1)
          let tmpWidth = strdisplaywidth(mdTable[i])
          call add(newMdTable[i], [mdTable[i], tmpWidth])
          let mdTable[i] = ''
        else
          let tmpWidth = strdisplaywidth(strpart(mdTable[i], 0, barPos))
          call add(newMdTable[i], [strpart(mdTable[i], 0, barPos), tmpWidth])
          let mdTable[i] = strpart(mdTable[i], barPos + 1, strlen(mdTable[i]) - barPos)
        endif
        if (tmpWidth > maxColWidth)
          let maxColWidth = tmpWidth
        endif
        let i = i + 1
      endwhile
    else
      " the last collumn, find the max length of it in each line
      let done = 1
      let i = 0
      let maxColWidth = 0
      while (i < lineCount)
        let tmpWidth = strdisplaywidth(mdTable[i])
        call add(newMdTable[i],  [mdTable[i], tmpWidth])
        if (tmpWidth > maxColWidth)
          let maxColWidth = tmpWidth
        endif
        let i = i + 1
      endwhile
    endif

    " record max collum length of each collum
    call add(maxElementLength, [])
    let maxElementLength[colCount] = maxColWidth
    let colCount = colCount + 1
    if (done)
      break
    endif
  endwhile

  " make each collumn in the new 2-d md table to the max length, and append
  " "|" to the end of it
  let i = 0
  let outputTable = ""
  while (i < lineCount)
    let line = ""
    let j = 0
    while (j < colCount - 1)
      " append spaces to align, make each collumn to the corresponding max length
      " echo  newMdTable[i][j]
      let space2AddNum = maxElementLength[j] - newMdTable[i][j][1]
      let k = 0
      let spaces = ""
      while (k < space2AddNum)
        let spaces = spaces . " "
        let k = k + 1
      endwhile
      let line = line . newMdTable[i][j][0] . spaces . "|"
      let j = j + 1
    endwhile
    let line = line . newMdTable[i][j][0]
    let outputTable = outputTable . line . "\n"
    " echo newMdTable[0][:][0]
    if (!isDebug)
      " append(endLine + i, line)
      call setline(startLine + i, line)
    endif
    let i = i + 1
  endwhile
  if (isDebug)
    echo outputTable
  endif

endfunction
