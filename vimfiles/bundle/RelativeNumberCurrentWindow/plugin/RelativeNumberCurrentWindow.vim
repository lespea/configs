" RelativeNumberCurrentWindow.vim: Only show relative numbers in the currently active window.
"
" DEPENDENCIES:
"
" Copyright: (C) 2012-2013 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS
"   1.00.004	04-Mar-2013	Fix completely losing line numbering on
"				:EditNext; :setlocal number also resets the
"				global 'relativenumber' value; we need to avoid
"				that.
"	003	23-Nov-2012	ENH: Turn off relative numbering in insert mode.
"				ENH: Turn off relative numbering when the focus
"				is lost.
"				Got the idea from
"				http://jeffkreeftmeijer.com/2012/relative-line-numbers-in-vim-for-super-fast-movement/
"	002	06-Sep-2012	Add autocmd to adapt 'numberwidth' to the buffer
"				size, so that the width of the number column
"				doesn't change when switching windows, because
"				that is visually distracting.
"	001	04-Sep-2012	file creation

" Avoid installing twice or when in unsupported Vim version.
if exists('g:loaded_RelativeNumberCurrentWindow') || (v:version < 700) || ! exists('+relativenumber')
    finish
endif
let g:loaded_RelativeNumberCurrentWindow = 1

"- configuration ---------------------------------------------------------------

if ! exists('g:RelativeNumberCurrentWindow_SameNumberWidth')
    let g:RelativeNumberCurrentWindow_SameNumberWidth = 1
endif
if ! exists('g:RelativeNumberCurrentWindow_OnFocus')
    let g:RelativeNumberCurrentWindow_OnFocus = 1
endif
if ! exists('g:RelativeNumberCurrentWindow_OnInsert')
    let g:RelativeNumberCurrentWindow_OnInsert = 1
endif



"- functions -------------------------------------------------------------------

function! s:LocalNumber()
    return (&l:relativenumber ? 2 : (&l:number ? 1 : 0))
endfunction
function! s:RelativeNumberOnEnter()
"****D echomsg '****' bufnr('').'/'.winnr() s:LocalNumber() exists('w:relativenumber')
    if exists('w:relativenumber') && s:LocalNumber() == 1
	setlocal relativenumber
    endif
endfunction
function! s:RelativeNumberOnLeave()
    if s:LocalNumber() == 2
	" Switching locally to 'number' also resets the global 'relativenumber';
	" we don't want this; on some :edits (especially through my :EditNext),
	" the line numbering is completely lost due to this.
	let l:global_relativenumber = &g:relativenumber
	    setlocal number
	let &g:relativenumber = l:global_relativenumber
	let w:relativenumber = 1
    else
	unlet! w:relativenumber
    endif
endfunction

function! s:AdaptNumberwidth()
    let &l:numberwidth = max([len(string(&lines)), len(string(line('$')))]) + 1
endfunction



"- autocmds --------------------------------------------------------------------

let s:onEnterEvents = 'VimEnter,WinEnter,BufWinEnter'
let s:onLeaveEvents = 'WinLeave'
if g:RelativeNumberCurrentWindow_OnFocus
    let s:onEnterEvents .= ',FocusGained'
    let s:onLeaveEvents .= ',FocusLost'
endif
if g:RelativeNumberCurrentWindow_OnInsert
    let s:onEnterEvents .= ',InsertLeave'
    let s:onLeaveEvents .= ',InsertEnter'
endif

augroup RelativeNumber
    autocmd!
    execute 'autocmd' s:onEnterEvents '* call <SID>RelativeNumberOnEnter()'
    execute 'autocmd' s:onLeaveEvents '* call <SID>RelativeNumberOnLeave()'

    if g:RelativeNumberCurrentWindow_SameNumberWidth
	" For 'relativenumber', take the maximum possible number of 'lines', not
	" the actual 'winheight', so that (frequently occurring) window
	" resizings do not cause width changes, neither.
	execute 'autocmd' s:onEnterEvents '* call <SID>AdaptNumberwidth()'
    endif
augroup END

unlet s:onEnterEvents s:onLeaveEvents

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
