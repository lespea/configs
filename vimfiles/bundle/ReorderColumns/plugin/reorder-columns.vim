" reorder-columns.vim:
" Load Once:
if &cp || exists("g:loaded_reorder_columns")
    finish
endif
let g:loaded_reorder_columns = 1
let s:keepcpo              = &cpo
set cpo&vim
" ---------------------------------------------------------------------

function! ReOrder(...) range
    if len(a:000) < 4
        echohl WarningMsg | echo "usage\n\t :[range]ReOrder {split_pattern} {order} [{delimiter}] \nexample\n\t :%ReOrder , 2431 | \ncause\n\t parameter count error." | echohl None
        return
    endif

    let l:firstline = a:1
    let l:lastline = a:2

    let l:delimiter = a:3
    if len(a:000) < 5
        let l:glue = a:3
    else
        let l:glue = a:5
    endif

    let l:orders = split(a:4, '\zs')
    for l:o in l:orders
        let l:n = str2nr(l:o)
        if l:n == 0
            echohl WarningMsg | echo "usage\n\t :[range]ReOrder {split_pattern} {order} [{delimiter}] \nexample\n\t :%ReOrder , 2431 | \ncause\n\t {order} is not a natural number or 0 error." | echohl None
            return
        endif
    endfor

    let l:i = 0
    while l:i + l:firstline <= l:lastline

        let l:line = getline(l:i + l:firstline)
        let l:columns = split(l:line, l:delimiter, 1)

        let l:newcolumns = []
        for l:o in l:orders
            let l:n = str2nr(l:o)
            if len(l:columns) < l:n
                continue
            endif

            call add(l:newcolumns, l:columns[l:o - 1])
        endfor

        let l:newline = join(l:newcolumns, l:glue)

        call setline(l:i + l:firstline, l:newline)

        let l:i += 1
    endwhile
endfunction

" :[range]ReOrder {splitter} {order} [{delimiter}]
" :ReOrder , 2431 |
command! -range -nargs=* ReOrder call ReOrder(<line1>, <line2>, <f-args>)

" ---------------------------------------------------------------------
let &cpo= s:keepcpo
unlet s:keepcpo

