" Easy Insert/Append to a paragraph of text
"
" Author: Dimitar Dimitrov (mitkofr@yahoo.fr), kurkale6ka
"
" Latest version at:
" http://github.com/kurkale6ka/vimfiles/blob/master/plugin/blockinsert.vim
"
" todo: make :Both and :QBoth accept two arguments,
"       use text2 and <f-args> (<f-args>[0]?) ...
"
" todo: make the :commands accept a count as their first argument
" todo: see what happens when aborting (<esc> or ^c)
" todo: autoload...

if exists('g:loaded_blockinsert')
    finish
endif
let g:loaded_blockinsert = 1

function! blockinsert#do (operation, com, _count, text) range

    let virtualedit_bak = &virtualedit
    set virtualedit=

    " Called from a :command
    if !empty(a:com)

        let text = a:text
    else
        let text = input('Enter text: ')
    endif

    if !empty(a:_count)

        let _count = a:_count
    else
        let _count = v:count1
    endif

    if !empty(text)

        if 'a' == a:operation

            let operation = _count . 'A' . text . "\<esc>"

        elseif 'i' == a:operation

            let operation = _count . 'I' . text . "\<esc>"

        elseif 'qa' == a:operation

            let operation = _count . '$' . text . "\<esc>"

        elseif 'qi' == a:operation

            let operation = _count . '^' . text . "\<esc>"
        endif

    elseif 'a' == a:operation

        set virtualedit=onemore

        let operation = '$l' . _count . 'X'

    elseif 'i' == a:operation

        let operation = '^' . _count . 'x'
    endif

    if a:firstline == a:lastline

        '{

        " at BOF
        " todo: take into account paragraph macros
        if getline('.') =~ '[^[:space:]]'

            let start = 1
        else
            +
            let start = line('.')
        endif

        if getline("'}") =~ '[^[:space:]]'

            let end = line('$')
        else
            let end = line("'}") - 1
        endif

    else
        let start = a:firstline
        let end   = a:lastline
    endif

    for i in range(start, end)

        if getline('.') !~ '^[[:space:]]*$'

            execute 'normal ' . operation
        endif
        +
    endfor

    if empty(text) && 'a' == a:operation

        let &virtualedit = virtualedit_bak
    endif

    silent! call repeat#set("\<plug>blockinsert-" . a:operation , _count)

endfunction

command! -nargs=* -range Insert
            \ <line1>,<line2>call blockinsert#do ('i',  1, '', <q-args>)

command! -nargs=* -range Append
            \ <line1>,<line2>call blockinsert#do ('a',  1, '', <q-args>)

command! -nargs=* -range QInsert
            \ <line1>,<line2>call blockinsert#do ('qi', 1, '', <q-args>)

command! -nargs=* -range QAppend
            \ <line1>,<line2>call blockinsert#do ('qa', 1, '', <q-args>)

command! -nargs=* -range Both
            \ <line1>,<line2>call blockinsert#do ('i',  1, '', <q-args>)<bar>
            \ <line1>,<line2>call blockinsert#do ('a',  1, '', <q-args>)

command! -nargs=* -range QBoth
            \ <line1>,<line2>call blockinsert#do ('qi', 1, '', <q-args>)<bar>
            \ <line1>,<line2>call blockinsert#do ('qa', 1, '', <q-args>)

" Insert / Append
vmap <plug>blockinsert-i  :call blockinsert#do ('i',  '', '', '')<cr>
vmap <plug>blockinsert-a  :call blockinsert#do ('a',  '', '', '')<cr>
vmap <plug>blockinsert-qi :call blockinsert#do ('qi', '', '', '')<cr>
vmap <plug>blockinsert-qa :call blockinsert#do ('qa', '', '', '')<cr>

" Insert / Append
nmap <plug>blockinsert-i  :<c-u>call blockinsert#do ('i',  '', '', '')<cr>
nmap <plug>blockinsert-a  :<c-u>call blockinsert#do ('a',  '', '', '')<cr>
nmap <plug>blockinsert-qi :<c-u>call blockinsert#do ('qi', '', '', '')<cr>
nmap <plug>blockinsert-qa :<c-u>call blockinsert#do ('qa', '', '', '')<cr>

" Both Insert & Append
vmap <plug>blockinsert-b :call blockinsert#do ('i', '', '', '')<bar>
            \*call blockinsert#do ('a', '', '', '')<cr>

vmap <plug>blockinsert-qb :call blockinsert#do ('qi', '', '', '')<bar>
            \*call blockinsert#do ('qa', '', '', '')<cr>

nmap <plug>blockinsert-b :<c-u>call blockinsert#do ('i', '', '', '')<bar>
            \call blockinsert#do ('a', '', '', '')<cr>

nmap <plug>blockinsert-qb :<c-u>call blockinsert#do ('qi', '', '', '')<bar>
            \call blockinsert#do ('qa', '', '', '')<cr>
