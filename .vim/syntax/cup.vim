" Vim syntax file
" Language:         CUP
" Maintainer:       Jon Siddle <jon@trapdoor.org>
" Last Change:      21/3/2007

" Adapted from the jflex syntax file by Gerwin Klein

" Quit when a syntax file was already loaded	{{{
if exists("b:current_syntax")
	finish
endif
"}}}

" Include java syntax {{{
if version >= 600
	runtime! syntax/java.vim
	unlet b:current_syntax 
else
	so $VIMRUNTIME/syntax/java.vim
endif
"}}}

syn cluster cupOptions contains=cupDef,cupClass,cupTerm,cupNonTerm,cupNonTermDef,cupVarLabel,cupOperator,cupCodeInclude,cupComment,cupActionCode

syn region cupStart start="" end="" contains=@cupOptions


syn match cupTerm "\<[A-Z]\+\>" contained
syn match cupNonTerm "\<[a-z]\+\>" contained
syn match cupNonTermDef "^[a-z]\+\>" contained
syn match cupClass "\<[A-Z][a-z]\+\>" contained

syn match cupDef "^package.*$" contained
syn match cupDef "^import.*$" contained
syn match cupDef "^precedence left" contained
syn match cupDef "^precedence right" contained
syn match cupDef "^precedence nonassoc" contained
syn match cupDef "^terminal" contained
syn match cupDef "^non terminal" contained

syn region cupVarLabel matchgroup=cupVarLabelMark start=":" end="\s" contains=cupVar contained
syn match cupVar "[a-z]\+\>" contained

syn match cupOperator "::=" contained

syn region cupCodeInclude matchgroup=cupCodeIncludeMark start="^parser code {:" end=":}" contains=@javaTop contained
syn region cupCodeInclude matchgroup=cupCodeIncludeMark start="^action code {:" end=":}" contains=@javaTop contained
syn region cupCodeInclude matchgroup=cupCodeIncludeMark start="^init code {:" end=":}" contains=@javaTop contained

" take out comments
syn match cupComment "//.*" contained
syn region cupComment start="/\*" end="\*/" contained contains=cupComment

" action code (only after states braces and macro use)
syn region cupActionCode matchgroup=Delimiter start="{:" end=":}" contained contains=@javaTop,cupJavaBraces

" keep braces in actions balanced
syn region cupJavaBraces start="{" end="}" contained contains=@javaTop,cupJavaBraces

" syncing
syn sync clear
syn sync minlines=10

" highlighting
hi link cupOption      Special
hi link cupMacroIdent  Ident
hi link cupOptionError Error
hi link cupComment     Comment
hi link cupOperator    Operator
hi link cupRuleStates  Special
hi link cupDef      Keyword
hi link cupTerm      Macro
hi link cupNonTermDef      Typedef
hi link cupNonTerm      Function
hi link cupVar      Label
hi link cupClass      Type
" hi cupSectionSep guifg=yellow ctermfg=yellow guibg=blue ctermbg=blue gui=bold cterm=bold
hi link cupCodeIncludeMark Delimiter

let b:current_syntax="cup"
