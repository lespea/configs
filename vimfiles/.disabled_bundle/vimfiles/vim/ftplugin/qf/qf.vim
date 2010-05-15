" Author:  Eric Van Dewoestine
"
" Description: {{{
"   Provides some additional mappings when working with vim's quickfix,
"   allowing removal of entries or opening of entries in a split window.
" }}}

nnoremap <buffer> <silent> dd :call <SID>Delete()<cr>
nnoremap <buffer> <silent> D :call <SID>Delete()<cr>
nnoremap <buffer> <silent> s :call <SID>Split(1)<cr>
nnoremap <buffer> <silent> S :call <SID>Split(0)<cr>

" s:Delete() {{{
if !exists('*s:Delete')
function! s:Delete ()
  let lnum = line('.')
  let cnum = col('.')
  let qf = getqflist()
  call remove(qf, lnum - 1)
  call setqflist(qf, 'r')
  call cursor(lnum, cnum)
endfunction
endif " }}}

" s:Split(close) {{{
function! s:Split (close)
  let bufnum = bufnr('%')

  let saved = &splitbelow
  set nosplitbelow
  exec "normal \<c-w>\<cr>"
  let &splitbelow = saved

  if a:close
    exec 'bd ' . bufnum
  endif
endfunction " }}}

" vim:ft=vim:fdm=marker
