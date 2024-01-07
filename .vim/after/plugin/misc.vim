" @brief  This is anther vimrc file, loaded after all plugins loaded
" @author Gavin Chou
" @email  gavineaglechou@gmail.com
" @date   2022-06-27-Mon

" ---------- YouCompleteMe {{{3
if exists('g:loaded_youcompleteme')
  exe 'nmap <c-]> :YcmCompleter GoTo<CR>'
endif


" vim: et tw=80 ts=2 sw=2 cc=80:
