" Increment / Decrement / Add / Subtract
"
" Author: Dimitar Dimitrov (mitkofr@yahoo.fr), kurkale6ka
"
" Latest version at:
" http://github.com/kurkale6ka/vimfiles/blob/master/plugin/sequence.vim
"
" Todo: repeat.vim for visual mode

if exists('g:loaded_sequence') || &compatible || v:version < 700

    if &compatible && &verbose

        echo "Sequence is not designed to work in compatible mode."

    elseif v:version < 700

        echo "Sequence needs Vim 7.0 or above to work correctly."
    endif

    finish
endif

let g:loaded_sequence = 1

let s:savecpo = &cpoptions
set cpoptions&vim

function! s:Sequence(mode, operation) range

    let last_search = histget('search', -1)

    let firstline = a:firstline
    let lastline  = a:lastline

    let digit_pattern = '-\?\d\+'

    if 'n' == a:mode

        " Calculate the range
        if getline(firstline) =~ digit_pattern && firstline == lastline

            while getline(firstline - 1) =~ digit_pattern && firstline > 1

                let firstline -= 1
            endwhile

            while getline(lastline + 1) =~ digit_pattern && lastline < line('$')

                let lastline += 1
            endwhile

            execute firstline
        endif

    elseif "\<c-v>" == visualmode()

        if col("'<") < col("'>")

            let col_start = col("'<")
            let col_end   = col("'>")
        else
            let col_start = col("'>")
            let col_end   = col("'<")
        endif

        if col_end >= col('$')

            let _digit =
                \'\%' . col_start . 'c.\{-}\zs' .
                \digit_pattern
        else
            let col_end += 1

            let _digit =
                \'\%' . col_start . 'c.\{-}\zs' .
                \digit_pattern .
                \'\ze.\{-}\%' . col_end . 'c'
        endif

    endif

    " Subtraction or addition
    if a:operation =~ 'block'

        let counter = v:count1
    else
        let counter = 0
    endif

    " Subtraction
    if 'block_x' == a:operation

        let operation = '-'
    else
        let operation = '+'
    endif

    for i in range(0, lastline - firstline)

        if 'v' == a:mode && "\<c-v>" == visualmode()

            let  digit = matchstr(getline('.'), _digit)
        else
            let  digit = matchstr(getline('.'),  digit_pattern)
            let _digit = digit
        endif

        if '' != digit

            execute 'silent substitute/' . _digit . '/' .
                \'\=' . digit . operation . 'counter/e'

            if 'seq_i' == a:operation

                let counter += v:count1

            elseif 'seq_d' == a:operation

                let counter -= v:count1
            endif
        endif
        +
    endfor

    " Repeat
    let virtualedit_bak = &virtualedit
    set virtualedit=

    if 'n' == a:mode && 'seq_i' == a:operation

        silent! call repeat#set("\<plug>SequenceN_Increment")

    elseif 'n' == a:mode && 'seq_d' == a:operation

        silent! call repeat#set("\<plug>SequenceN_Decrement")
    endif

    " Restore saved values
    let &virtualedit = virtualedit_bak

    if histget('search', -1) != last_search

        call histdel('search', -1)
    endif

endfunction

vmap <silent> <plug>SequenceV_Increment
    \
    \ :call <sid>Sequence('v', 'seq_i')<cr>

vmap <silent> <plug>SequenceV_Decrement
    \
    \ :call <sid>Sequence('v', 'seq_d')<cr>

nmap <silent> <plug>SequenceN_Increment
    \
    \ :<c-u>call <sid>Sequence('n', 'seq_i')<cr>

nmap <silent> <plug>SequenceN_Decrement
    \
    \ :<c-u>call <sid>Sequence('n', 'seq_d')<cr>

vmap <silent> <plug>SequenceAdd      :call <sid>Sequence('v', 'block_a')<cr>
vmap <silent> <plug>SequenceSubtract :call <sid>Sequence('v', 'block_x')<cr>

vmap <m-a> <plug>SequenceV_Increment
vmap <m-x> <plug>SequenceV_Decrement
nmap <m-a> <plug>SequenceN_Increment
nmap <m-x> <plug>SequenceN_Decrement

vmap <c-a> <plug>SequenceAdd
vmap <c-x> <plug>SequenceSubtract

let &cpoptions = s:savecpo
unlet s:savecpo
