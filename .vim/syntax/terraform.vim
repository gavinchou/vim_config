" https://github.com/hashivim/vim-terraform/blob/master/syntax/terraform.vim
if exists('b:current_syntax')
  finish
endif
runtime! syntax/hcl.vim
unlet b:current_syntax

syn keyword terraType           string bool number object tuple list map set any

hi def link terraType           Type

let b:current_syntax = 'terraform'
