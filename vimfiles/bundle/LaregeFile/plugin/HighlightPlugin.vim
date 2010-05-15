" HighlightPlugin.vim
"   Author: Charles E. Campbell, Jr.
"   Date:   Nov 26, 2008
"   Version: 1b	NOT RELEASED
" ---------------------------------------------------------------------
"  Load Once: {{{1
if &cp || exists("g:loaded_HighlightPlugin")
 finish
endif
let g:loaded_HighlightPlugin = "v1b"
let s:keepcpo                = &cpo
set cpo&vim

" ---------------------------------------------------------------------
"  Public Interface: {{{1
com! -nargs=* -bar		HLcolor			call Highlight#Color(<f-args>)
com! -count=1 -nargs=*	HLsrch			call Highlight#Srch(<count>,<q-args>)
com! -nargs=? -bar		HLclear			call Highlight#Clear(<f-args>)
nmap <silent>			<Leader>HLw		:<c-u>call Highlight#Srch(v:count,expand("<cword>"))<cr>
nmap <silent>			<Leader>HLl		:<c-u>call Highlight#Srch(v:count,'^\%'.line(".").'l.*$')<cr>
vmap <silent>           <Leader>HL		:<c-u>call Highlight#Srch(v:count,'\%'.line("'<").'l\%'.col("'<").'c\_.*\%'.line("'>").'l\%'.(col("'>")+1).'c')<cr>

" ---------------------------------------------------------------------
"  Restore: {{{1
let &cpo= s:keepcpo
unlet s:keepcpo
" vim: ts=4 fdm=marker
