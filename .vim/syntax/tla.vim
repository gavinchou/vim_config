" Vim syntax file
" Language: TLA+ specification language
" Maintainer: Diego Ongaro <ongaro@cs.stanford.edu>
" Last Change: Sun Feb 17 14:07:00 PST 2013
" Version: 2
"
" Version 2:
" - adds TRUE and FALSE as booleans
" - fixes highlighting ----- when there's not an even multiple of four
" - fixes highlighting of nested multi-line comments

if exists("b:current_syntax")
  finish
endif

" Keep these in alphabetical order.
syn keyword tlaKeyword       ACTION
syn keyword tlaKeyword       ASSUME
syn keyword tlaKeyword       ASSUMPTION
syn keyword tlaKeyword       AXIOM
syn keyword tlaKeyword       BY
syn keyword tlaKeyword       CASE
syn keyword tlaKeyword       CHOOSE
syn keyword tlaKeyword       CONSTANT
syn keyword tlaKeyword       CONSTANTS
syn keyword tlaKeyword       DEF
syn keyword tlaKeyword       DEFINE
syn keyword tlaKeyword       DEFS
syn keyword tlaKeyword       DOMAIN
syn keyword tlaKeyword       ELSE
syn keyword tlaKeyword       ENABLED
syn keyword tlaKeyword       EXCEPT
syn keyword tlaKeyword       EXTENDS
syn keyword tlaKeyword       HAVE
syn keyword tlaKeyword       HIDE
syn keyword tlaKeyword       IF
syn keyword tlaKeyword       IN
syn keyword tlaKeyword       INSTANCE
syn keyword tlaKeyword       LAMBDA
syn keyword tlaKeyword       LEMMA
syn keyword tlaKeyword       LET
syn keyword tlaKeyword       LOCAL
syn keyword tlaKeyword       MODULE
syn keyword tlaKeyword       NEW
syn keyword tlaKeyword       OBVIOUS
syn keyword tlaKeyword       OMITTED
syn keyword tlaKeyword       OTHER
syn keyword tlaKeyword       PICK
syn keyword tlaKeyword       PROOF
syn keyword tlaKeyword       PROPOSITION
syn keyword tlaKeyword       PROVE
syn keyword tlaKeyword       QED
syn keyword tlaKeyword       RECURSIVE
syn keyword tlaKeyword       SF_
syn keyword tlaKeyword       STATE
syn keyword tlaKeyword       SUBSET
syn keyword tlaKeyword       SUFFICES
syn keyword tlaKeyword       TAKE
syn keyword tlaKeyword       TEMPORAL
syn keyword tlaKeyword       THEN
syn keyword tlaKeyword       THEOREM
syn keyword tlaKeyword       UNCHANGED
syn keyword tlaKeyword       UNION
syn keyword tlaKeyword       USE
syn keyword tlaKeyword       VARIABLE
syn keyword tlaKeyword       VARIABLES
syn keyword tlaKeyword       WF_
syn keyword tlaKeyword       WITH
syn keyword tlaKeyword       WITNESS

syn keyword tlaKeyword \approx
syn keyword tlaKeyword \asymp
syn keyword tlaKeyword \bigcirc
syn keyword tlaKeyword \bullet
syn keyword tlaKeyword \cap
syn keyword tlaKeyword \cdot
syn keyword tlaKeyword \circ
syn keyword tlaKeyword \cong
syn keyword tlaKeyword \cup
syn keyword tlaKeyword \div
syn keyword tlaKeyword \doteq
syn keyword tlaKeyword \equiv
syn keyword tlaKeyword \geq
syn keyword tlaKeyword \gg
syn keyword tlaKeyword \in
syn keyword tlaKeyword \intersect
syn keyword tlaKeyword \land
syn keyword tlaKeyword \leq
syn keyword tlaKeyword \ll
syn keyword tlaKeyword \lnot
syn keyword tlaKeyword \lor
syn keyword tlaKeyword \neg
syn keyword tlaKeyword \notin
syn keyword tlaKeyword \o
syn keyword tlaKeyword \odot
syn keyword tlaKeyword \ominus
syn keyword tlaKeyword \oplus
syn keyword tlaKeyword \oslash
syn keyword tlaKeyword \otimes
syn keyword tlaKeyword \prec
syn keyword tlaKeyword \preceq
syn keyword tlaKeyword \propto
syn keyword tlaKeyword \sim
syn keyword tlaKeyword \simeq
syn keyword tlaKeyword \sqcap
syn keyword tlaKeyword \sqcup
syn keyword tlaKeyword \sqsubset
syn keyword tlaKeyword \sqsubseteq
syn keyword tlaKeyword \sqsupset
syn keyword tlaKeyword \sqsupseteq
syn keyword tlaKeyword \star
syn keyword tlaKeyword \subset
syn keyword tlaKeyword \subseteq
syn keyword tlaKeyword \succ
syn keyword tlaKeyword \succeq
syn keyword tlaKeyword \supset
syn keyword tlaKeyword \supseteq
syn keyword tlaKeyword \union
syn keyword tlaKeyword \uplus
syn keyword tlaKeyword \wr


syntax case ignore
syn keyword tlaTodo contained todo xxx fixme
syntax case match

syn keyword tlaBoolean FALSE
syn keyword tlaBoolean TRUE
syn match tlaNumber "\<\d\+\>"
syn region tlaString start=+"+ skip=+\\"+ end=+"+

syn match tlaOperator "[!,:<>=~\-|^+*&\$#%\./\\]"
syn match tlaOperator "\[\]"
syn match tlaOperator "!!"
syn match tlaOperator "??"
syn match tlaOperator "@@"
syn match tlaOperator "\\A"
syn match tlaOperator "\\E"

syn match tlaSpecial "[{}'\[]]"

syn match tlaDelimiter "-\{4,\}"

" Comments. This is defined so late so that it overrides previous matches.
syn region tlaComment start="\\\*" end="$" contains=tlaTodo
syn region tlaComment start="(\*" end="\*)" contains=tlaTodo,tlaComment

" Link the rules to some groups.
highlight link tlaBoolean        Boolean
highlight link tlaComment        Comment
highlight link tlaDelimiter      Delimiter
highlight link tlaKeyword        Keyword
highlight link tlaNumber         Number
highlight link tlaOperator       Operator
highlight link tlaSpecial        Special
highlight link tlaString         String
highlight link tlaTodo           Todo

let b:current_syntax = "tla"
