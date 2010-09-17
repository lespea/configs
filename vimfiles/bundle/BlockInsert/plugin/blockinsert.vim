" Easy Insert/Append to a paragraph of text
"
" Author: Dimitar Dimitrov (mitkofr@yahoo.fr), kurkale6ka
"
" Latest version at:
" http://github.com/kurkale6ka/vimfiles/blob/master/plugin/blockinsert.vim
"
" todo: make the :commands accept a count as their first argument
" todo: :Both, :QBoth -> how to give them an empty arg in input:
"       :Both '' Second\ Argument
" todo: When hitting <esc> after 'Enter text:', it should abort, not delete

if exists('g:loaded_blockinsert')
    finish
endif
let g:loaded_blockinsert = 1

function! blockinsert#do_exe (mode, operation, col1, col2, row1, row2, text)

    if empty(a:col1)

        let go_start = '^'
        let go_end   = '$'
    else
        let go_start = a:col1 . "|:call search('[^[:space:]]', 'c')\<cr>"
        let go_end   = a:col2 . "|:call search('[^[:space:]]', 'cb')\<cr>"

        let block = 1
    endif

    if !empty(a:text)

        if 'a' == a:operation

            if exists('block')

                let operation = go_end . v:count1 . 'a' . a:text . "\<esc>"
            else
                let operation = v:count1 . 'A' . a:text . "\<esc>"
            endif

        elseif 'i' == a:operation

            if exists('block')

                let operation = go_start . v:count1 . 'i' . a:text . "\<esc>"
            else
                let operation = v:count1 . 'I' . a:text . "\<esc>"
            endif

        elseif 'qa' == a:operation

            let operation = go_end . v:count1 . a:text . "\<esc>"

        elseif 'qi' == a:operation

            let operation = go_start . v:count1 . a:text . "\<esc>"
        endif

    elseif 'a' == a:operation

        if v:count1 > 1

            let _count    = v:count1 - 1
            let operation = go_end . _count . 'hD'
        else
            let operation = go_end . 'x'
        endif

    elseif 'i' == a:operation

        let operation = go_start . v:count1 . 'x'
    endif

    for i in range(0, a:row2 - a:row1)

        if getline('.') !~ '^[[:space:]]*$'

            execute 'normal ' . operation
        endif
        +
    endfor

endfunction

function! blockinsert#do (mode, ope1, ope2, col1, col2, row1, row2, text1, text2) range

    " When enabled (my case :), it is causing problems
    let virtualedit_bak = &virtualedit
    set virtualedit=

    if !empty(a:text1) || empty(a:ope1)

        let text1 = a:text1
    else
        let text1 = input('Enter text: ')
    endif

    if !empty(a:text2) || empty(a:ope2)

        let text2 = a:text2
    else
        let text2 = input('Enter text: ')
    endif

    " edge case: \q[] or \[] in visual block mode
    if 'v' == a:mode

        if "\<c-v>" == visualmode()

            let col1 = virtcol("'<")
            let col2 = virtcol("'>") + len(text1)
        endif

        if !empty(a:col1)

            let col1 = virtcol('.')
            let col2 = col1 + a:col2 - a:col1 + len(text1)
        endif
    endif

    if !exists('col1')

        let col1 = 0
        let col2 = 0
    endif

    " no range given or current line selected (pointless)
    if a:firstline == a:lastline && empty(a:row1)

        '{

        " at BOF
        " todo: take into account paragraph macros
        if getline('.') =~ '[^[:space:]]'

            let row1 = 1
        else
            +
            let row1 = line('.')
        endif

        if getline("'}") =~ '[^[:space:]]'

            let row2 = line('$')
        else
            let row2 = line("'}") - 1
        endif

        let _row1 = 0
        let _row2 = 0

    " use previous range
    elseif !empty(a:row1)

        let  row1 = a:row1
        let  row2 = a:row2
        let _row1 = a:row1
        let _row2 = a:row2
    else
        let  row1 = a:firstline
        let  row2 = a:lastline
        let _row1 = a:firstline
        let _row2 = a:lastline
    endif

    if !empty(a:ope1) && !empty(a:ope2)

        let line_bak = line('.')
    endif

    if !empty(a:ope1)

        call blockinsert#do_exe (a:mode, a:ope1, col1, col2, row1, row2, text1)

        if !empty(a:ope2)

            execute line_bak
        endif
    endif

    if !empty(a:ope2)

        call blockinsert#do_exe (a:mode, a:ope2, col1, col2, row1, row2, text2)
    endif

    silent! call repeat#set(":\<c-u>call blockinsert#do ('" .
                \         a:mode .
                \"', '" . a:ope1 .
                \"', '" . a:ope2 .
                \"',  " .   col1 .
                \" ,  " .   col2 .
                \" ,  " .  _row1 .
                \" ,  " .  _row2 .
                \" , '" .  text1 .
                \"', '" .  text2 .
                \"')\<cr>"
                \)

    let &virtualedit = virtualedit_bak

endfunction

command! -nargs=* -range Insert
            \ <line1>,<line2>call blockinsert#do ('c', '', 'i',  0, 0, 0, 0, '', <q-args>)

command! -nargs=* -range Append
            \ <line1>,<line2>call blockinsert#do ('c', '', 'a',  0, 0, 0, 0, '', <q-args>)

command! -nargs=* -range QInsert
            \ <line1>,<line2>call blockinsert#do ('c', '', 'qi', 0, 0, 0, 0, '', <q-args>)

command! -nargs=* -range QAppend
            \ <line1>,<line2>call blockinsert#do ('c', '', 'qa', 0, 0, 0, 0, '', <q-args>)

command! -nargs=* -range Both
            \ <line1>,<line2>call blockinsert#do ('c', 'i',  'a',  0, 0, 0, 0, <f-args>)

command! -nargs=* -range QBoth
            \ <line1>,<line2>call blockinsert#do ('c', 'qi', 'qa', 0, 0, 0, 0, <f-args>)

" Insert / Append
vmap <plug>blockinsert-i  :call blockinsert#do ('v', '', 'i',  0, 0, 0, 0, '', '')<cr>
vmap <plug>blockinsert-a  :call blockinsert#do ('v', '', 'a',  0, 0, 0, 0, '', '')<cr>
vmap <plug>blockinsert-qi :call blockinsert#do ('v', '', 'qi', 0, 0, 0, 0, '', '')<cr>
vmap <plug>blockinsert-qa :call blockinsert#do ('v', '', 'qa', 0, 0, 0, 0, '', '')<cr>

" Insert / Append
nmap <plug>blockinsert-i  :<c-u>call blockinsert#do ('n', '', 'i',  0, 0, 0, 0, '', '')<cr>
nmap <plug>blockinsert-a  :<c-u>call blockinsert#do ('n', '', 'a',  0, 0, 0, 0, '', '')<cr>
nmap <plug>blockinsert-qi :<c-u>call blockinsert#do ('n', '', 'qi', 0, 0, 0, 0, '', '')<cr>
nmap <plug>blockinsert-qa :<c-u>call blockinsert#do ('n', '', 'qa', 0, 0, 0, 0, '', '')<cr>

" Both Insert & Append
vmap <plug>blockinsert-b  :call blockinsert#do ('v', 'i',  'a',  0, 0, 0, 0, '', '')<cr>
vmap <plug>blockinsert-qb :call blockinsert#do ('v', 'qi', 'qa', 0, 0, 0, 0, '', '')<cr>

nmap <plug>blockinsert-b  :<c-u>call blockinsert#do ('n', 'i',  'a',  0, 0, 0, 0, '', '')<cr>
nmap <plug>blockinsert-qb :<c-u>call blockinsert#do ('n', 'qi', 'qa', 0, 0, 0, 0, '', '')<cr>
