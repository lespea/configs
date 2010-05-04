" File:     repeater.vim
" Desc:     Repeats an item {n} times
" Author:   Jon-Michael Deldin <dev@jmdeldin.com>
" Homepage: http://github.com/jmdeldin/repeater

function! s:Repeater(sep, ...)
    let sep = a:sep
    " if a separator and count is specified
    if a:0 == 1
        let ct = a:1
    " If a count is not specified, use the preceding line's length
    else
        " previous line #
        let ln = line('.')-1
        " # of columns
        let ct = col([ln,"$"])-1
    endif

    let out=""
    for i in range(ct)
        let out=out.sep
    endfor
    exe 'norm! i'.out
endfunction

command -nargs=+ Repeater :call <SID>Repeater(<f-args>)

