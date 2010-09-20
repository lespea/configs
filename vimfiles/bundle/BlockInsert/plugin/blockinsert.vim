" Easy Insert/Append to a paragraph of text
"
" Author: Dimitar Dimitrov (mitkofr@yahoo.fr), kurkale6ka
"
" Latest version at:
" http://github.com/kurkale6ka/vimfiles/blob/master/plugin/blockinsert.vim
"
" todo: make the :commands accept a count as their first argument
"
" todo: :Both, :QBoth -> how to give them an empty arg in input:
"       :Both '' Second\ Argument
"
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

    if '_delete_please' != a:text

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

            if v:count1 > 1 && a:text !~ '^[[:space:]]*[[:digit:]]'

                let operation = go_end . v:count1 . a:text . "\<esc>"
            else
                let operation = go_end . a:text . "\<esc>"
            endif

        elseif 'qi' == a:operation

            if v:count1 > 1 && a:text !~ '^[[:space:]]*[[:digit:]]'

                let operation = go_start . v:count1 . a:text . "\<esc>"
            else
                let operation = go_start . a:text . "\<esc>"
            endif
        endif

    elseif a:operation =~ 'a'

        if v:count1 > 1

            let _count = v:count1 - 1
            let go_end = go_end . _count . 'h'
        endif

        let operation = go_end . v:count1 . 'x'

    elseif a:operation =~ 'i'

        let operation = go_start . v:count1 . 'x'
    endif

    if !empty(a:col1)

        let current_line = getline('.')

        let _col1 = a:col1 + 1
        let _col2 = a:col2 + 1

        let str_to_col1 = substitute(current_line, '\%' . _col1 . 'v.*', '', '')
        let str_to_col2 = substitute(current_line, '\%' . _col2 . 'v.*', '', '')

        let _col1 = strlen(str_to_col1)
        let _col2 = strlen(str_to_col2)

        for i in range(1, a:row2 - a:row1 + 1)

            if strpart(getline('.'), _col1 - 1, _col2 - _col1 + 1) =~ '[^[:space:]]\+'

                execute 'normal ' . operation
            endif
            +
        endfor
    else
        for i in range(1, a:row2 - a:row1 + 1)

            if getline('.') !~ '^[[:space:]]*$'

                execute 'normal ' . operation
            endif
            +
        endfor
    endif

endfunction

function! blockinsert#get_text (ope, text1, text2)

    if !empty(a:text1)

        let text1 = a:text1

    elseif a:ope !~ 'u'

        if a:ope =~ 'i' && !&rightleft || a:ope =~ 'a' && &rightleft

            if a:ope !~ 'q'

                let text1 = input('Left text: ')
            else
                let text1 = input('Left actions: ')
            endif
        else
            if a:ope !~ 'q'

                let text1 = input('Right text: ')
            else
                let text1 = input('Right actions: ')
            endif
        endif

    elseif a:ope =~ 'u'

        if !empty(a:text2)

            let text1 = a:text2
        else
            if a:ope !~ 'q'

                let text1 = input('Surround text: ')
            else
                let text1 = input('Surround actions: ')
            endif
        endif
    endif

    if empty(text1)

        let text1 = '_delete_please'
    endif

    return text1

endfunction

function! blockinsert#do (mode, ope1, ope2, col1, col2, row1, row2, text1, text2) range

    if !empty(a:ope1)

        let text1 = blockinsert#get_text (a:ope1, a:text1, '')
    else
        let text1 = ''
    endif

    if !empty(a:ope2)

        let text2 = blockinsert#get_text (a:ope2, a:text2, text1)
    else
        let text2 = ''
    endif

    if (a:ope1 !~ 'u')

        let ope1 = a:ope1
        let ope2 = a:ope2
    else
        let ope1 = substitute(a:ope1, 'u', '', '')
        let ope2 = substitute(a:ope2, 'u', '', '')
    endif

    if 'v' == a:mode

        if "\<c-v>" == visualmode()

            if virtcol("'<") < virtcol("'>")

                let col1 = virtcol("'<")
                let col2 = virtcol("'>")
            else
                let col1 = virtcol("'>")
                let col2 = virtcol("'<")
            endif
        endif

        if !empty(a:col1)

            let col1 = virtcol('.')
            let col2 = col1 + a:col2 - a:col1
        endif
    endif

    if !exists('col1')

        let col1 = 0
        let col2 = 0
    endif

    " no range given
    if empty(a:row1) && 'n' == a:mode

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

    if !empty(ope1) && !empty(ope2)

        let line_bak = line('.')
    endif

    if !empty(ope2)

        call blockinsert#do_exe (a:mode, ope2, col1, col2, row1, row2, text2)

        if !empty(ope1)

            execute line_bak
        endif
    endif

    if !empty(ope1)

        call blockinsert#do_exe (a:mode, ope1, col1, col2, row1, row2, text1)
    endif

    " When enabled (my case :), it is causing problems
    let virtualedit_bak = &virtualedit
    set virtualedit=

    silent! call repeat#set(":\<c-u>call blockinsert#do ('" .
                \         a:mode .
                \"', '" .   ope1 .
                \"', '" .   ope2 .
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

if exists('g:blockinsert_commands') && g:blockinsert_commands == 1

    command! -nargs=* -range BlockInsert
                \ <line1>,<line2>call blockinsert#do ('c', '', 'i',  0, 0, 0, 0, '', <q-args>)

    command! -nargs=* -range BlockAppend
                \ <line1>,<line2>call blockinsert#do ('c', '', 'a',  0, 0, 0, 0, '', <q-args>)

    command! -nargs=* -range BlockQInsert
                \ <line1>,<line2>call blockinsert#do ('c', '', 'qi', 0, 0, 0, 0, '', <q-args>)

    command! -nargs=* -range BlockQAppend
                \ <line1>,<line2>call blockinsert#do ('c', '', 'qa', 0, 0, 0, 0, '', <q-args>)

    command! -nargs=* -range BlockBoth
                \ <line1>,<line2>call blockinsert#do ('c', 'i',  'a',  0, 0, 0, 0, <f-args>)

    command! -nargs=* -range BlockBothSame
                \ <line1>,<line2>call blockinsert#do ('c', 'iu',  'au',  0, 0, 0, 0, <q-args>, '')

    command! -nargs=* -range BlockQBoth
                \ <line1>,<line2>call blockinsert#do ('c', 'qi', 'qa', 0, 0, 0, 0, <f-args>)

    command! -nargs=* -range BlockQBothSame
                \ <line1>,<line2>call blockinsert#do ('c', 'qiu', 'qau', 0, 0, 0, 0, <q-args>, '')
endif

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
vmap <plug>blockinsert-b   :call blockinsert#do ('v', 'i',   'a',   0, 0, 0, 0, '', '')<cr>
vmap <plug>blockinsert-ub  :call blockinsert#do ('v', 'iu',  'au',  0, 0, 0, 0, '', '')<cr>
vmap <plug>blockinsert-qb  :call blockinsert#do ('v', 'qi',  'qa',  0, 0, 0, 0, '', '')<cr>
vmap <plug>blockinsert-uqb :call blockinsert#do ('v', 'qiu', 'qau', 0, 0, 0, 0, '', '')<cr>

nmap <plug>blockinsert-b   :<c-u>call blockinsert#do ('n', 'i',   'a',   0, 0, 0, 0, '', '')<cr>
nmap <plug>blockinsert-ub  :<c-u>call blockinsert#do ('n', 'iu',  'au',  0, 0, 0, 0, '', '')<cr>
nmap <plug>blockinsert-qb  :<c-u>call blockinsert#do ('n', 'qi',  'qa',  0, 0, 0, 0, '', '')<cr>
nmap <plug>blockinsert-uqb :<c-u>call blockinsert#do ('n', 'qiu', 'qau', 0, 0, 0, 0, '', '')<cr>
