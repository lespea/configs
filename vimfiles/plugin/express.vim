" Vim syntax file
" Language:		express data schema language 	
" Maintainer:	Benoit Cerrina <benoit.cerrina@writeme.com>
" Last Change:	2001 Mar 13
" Quit when a syntax file was already loaded
if exists("b:current_syntax")
  finish
endif

syn case ignore

" The EXPRESS reserved words, defined as keywords.

syn keyword expKeyword	entity inverse end_entity type where self enumeration end_type derive optional subtype supertype schema reference unique end_schema

syn keyword expAggregate array list bag set

syn keyword expOperator andor of for from use as

syn keyword expType	integer real boolean logical string binary

" Numbers:
syn match expNumber		"-\=\<\d*\.\=[0-9_]\>"

" Comments:
syn region expComment    start="(\*"  end="\*)"
syn match expComment	"--.*"

syn sync ccomment expComment

" The default highlighting.
hi def link expComment		Comment
hi def link expKeyword		expSpecial
hi def link expNumber		Number
hi def link expOperator		expStatement
hi def link expSpecial		Special
hi def link expStatement	Statement
hi def link expString		String
hi def link expType		Type
hi def link expAggregate	Type

let b:current_syntax = "express"

" vim: ts=8
