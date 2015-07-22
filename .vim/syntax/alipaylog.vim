
" Vim syntax file
" Language:	alipaylog
" Maintainer:	 Gavin Chou <gavineaglechou@gmail.com>
" URL:		<gitlab>
" Last Change:	2015-01-17 15:30:58

let s:isDebug=0


if !s:isDebug

" Quit when a syntax file was already loaded
if !exists("main_syntax")
  if version < 600
    syntax clear
  elseif exists("b:current_syntax")
    finish
  endif
  let main_syntax='alipaylog'
endif

let s:cpo_save = &cpo
set cpo&vim

endif

" don't use standard HiLink, it will not work with included syntax files
if version < 508
  command! -nargs=+ LogHiLink hi link <args>
else
  command! -nargs=+ LogHiLink hi def link <args>
  " command! -nargs=+ LogHiLink hi link <args>
endif

syntax clear

syn match logTime "\d\{4}-\d\{1,2}-\d\{1,2} \d\{1,2}:\d\{1,2}:\d\{1,2},\d\{3}"

syn match logName "\(\([a-z0-9-.]\)\+\)\+\.log\(\.\d\{4}-\d\{2}-\d\{2}\(_\d\{2}\)\?\)\?"

syn match userId "\d\@1<!2088\d\{12}\d\@1!"

syn match timestamp "\<\d\{13}\>"

syn match module "\W\zs[A-Z]\w\+\.\w\+\ze\W"
syn match module "\W\zs[a-z]\w\+\.[A-Z]\w\+\ze\W"

syn match Error "\<ERROR\>"

syn match Url "\zs\(ht\|f\)tp:[0-9a-zA-Z_./]\+\ze[^0-9a-zA-Z_./]"

syn match IPAddress "\d\@1<!\(\(25[0-5]\|2[0-4][0-9]\|1[0-9][0-9]\|[1-9][0-9]\|[0-9]\)\.\)\{3}\(25[0-5]\|2[0-4][0-5]\|1[0-9][0-9]\|[1-9][0-9]\|[0-9]\)\d\@1!"

syn match serviceResult "success=\w\+"
syn match serviceResult "resultCode=\w\+\ze\W"

LogHiLink userId Red
LogHiLink logTime YellowGreen
LogHiLink timestamp Purple
LogHiLink IPAddress UrlLink
LogHiLink module Comment
LogHiLink Error ErrorMsg
LogHiLink Url UrlLink
LogHiLink logName Yellow
LogHiLink serviceResult Cyan


delcommand LogHiLink

if !s:isDebug

let b:current_syntax = "alipaylog"

if main_syntax == 'alipaylog'
  unlet main_syntax
endif

let b:spell_options="contained"
let &cpo = s:cpo_save
unlet s:cpo_save

endif

" vim: ts=2
