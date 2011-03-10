"
" PreciseJump aka '[count] motion' on drugs
" version: 2011-03-07
"
" required vim 7.2+
"
" author: Bartlomiej Podolak <bartlomiej (a) gmail com>

"{{{ TODO
" TODO: find & highlight only on visible text - not whole line ?
" TODO: make it work as custom motion (:omap)
" TODO: investigate what happens when user doesn't have highilithasdfasdts on
" TODO: should we search for a match in whole line or starting from cursor position
" TODO: function shouldn't affect undo list
" TODO: option for case insensitive f jump ( let re = '\c' . re )
" TODO: operator mode
" TODO: JumpE - bad regex - doesnt find target at the very end of line
" TODO: JumpW - bad regex - doesnt find target at the very begining of line
" TODO: Jump[WE] goes wrong with folding
" TODO: cursor is moved when prompting for char is cancelled
" TODO: handle syntax (on/off) more gracefully
" }}}

"{{{ DONE
" DONE: <strike>DOESNT</strike> WORK WELL WITH FOLDS!!!!!!
" DONE: make it work for visual modes (v, V, <ctrl-v>)
" DONE: handle Jump('.') better; maximum numer of marked targets?
" DONE: f([^$.]) - fixed
" DONE: W over multiple lines ?
" DONE: customise target markers 'a'..'z' vs. 1 .. 9 vs. most convinient keys
"       on keyboard

" DONE: make it work on 'not modifable' buffers
" DONE: ctrl-c during Fc execution can leave a mess
" DONE: check if match_rule can contain \\%_l only once
"}}}

"if exists('s:mdod_loaded')
"    finish
"endif
let s:mdod_loaded = 1

if version >= 700

"{{{xxxxxxxx   CONFIGURATION   xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
"xxxxxxxx   CONFIGURATION   xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

let s:target_keys  = ''
let s:target_keys .= 'abcdefghijklmnopqrstuwxz'
let s:target_keys .= '123456789'
let s:target_keys .= "[];'\,./"
"let s:target_keys .= 'ABCDEFGHIJKLMNOPQRSTUWXZ'
"let s:target_keys .= '{}:"|<>?'
"let s:target_keys .= '!@#$%^&*()_+'

"if !exists('g:cmodMatchTargetHi')
    let g:cmodMatchTargetHi = 'PmenuSel'
"endif
"if !exists('g:cmodGroupMatchTargetHi')
    let g:cmodGroupMatchTargetHi = 'ErrorMsg'
"endif

nmap f :call JumpF(0)<cr>
vmap f :call JumpF(1)<cr>

"xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
"}}}

"{{{ initialization stuff
let s:index_to_key = split(s:target_keys, '\zs')
let s:key_to_index = {}

let index = 0
for i in s:index_to_key
    let s:key_to_index[i] = index
    let index += 1
endfor
"}}}

"{{{ motion functions
function! JumpW(vismode)
    call Jump('\(\_^\|\s\)\zs\S', a:vismode) " FIXME - doesn't find words at the begining of line
endfunction

function! JumpE(vismode)
    call Jump('\S\ze\(\s\|\_$\)', a:vismode)
endfunction

function! JumpF(vismode)
    let re = nr2char( getchar() )
    redraw
    let re =  re == '.' ? '\.' : re "fixme
    let re =  re == '$' ? '\$' : re "fixme
    let re =  re == '^' ? '\^' : re "fixme
    let re =  re == '~' ? '\~' : re "fixme

    call Jump(re, a:vismode)
endfunction

function! JumpF(vismode)
    echo "char> "
    let re = nr2char( getchar() )
    redraw
    let re =  re == '.' ? '\.' : re "fixme
    let re =  re == '$' ? '\$' : re "fixme
    let re =  re == '^' ? '\^' : re "fixme
    let re =  re == '~' ? '\~' : re "fixme
    call Jump(re, a:vismode)
endfunction

function! JumpT(vismode)
    let re = '.' . nr2char( getchar() )
    redraw
    let re =  re == '.' ? '\.' : re "fixme
    let re =  re == '$' ? '\$' : re "fixme
    let re =  re == '^' ? '\^' : re "fixme
    let re =  re == '~' ? '\~' : re "fixme
    call Jump(re, a:vismode)
endfunction
"}}}

"xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
" jump to l-th col and c-th char in current line
"{{{ function! s:JumpToCoords(l, c, vismode)
function! s:JumpToCoords(l, c, vismode)
    let ve = &virtualedit
    setl virtualedit=""
    if a:vismode
        execute "normal! gv"
    endif
    execute "normal! " . a:l . "gg"
    normal! "0|"
    if a:c > 1
        execute "normal! " . (a:c - 1) . "l"
    endif
    execute "silent setl virtualedit=" . ve
    echo "Jumping to [" . a:l . ", " . a:c . "]"
endfunction
"}}}

"xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
" function returns list of places ([line, column]),
" that match regular expression 're'
" in lines of numbers from list 'line_numbers'
"{{{ function! s:FindTargets(re, line_numbers)
function! s:FindTargets(re, line_numbers)
    let targets = []
    for l in a:line_numbers
        let column = match(getline(l), a:re, 0)
        while column != -1
            call add(targets, [l, column + 1])
            let column = match(getline(l), a:re, column + 1)
        endwhile
    endfor
    return targets
endfunction
"}}}

"xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
" split 'list' into groups (list of lists) of
" 'group_size' length
"{{{ function! s:SplitListIntoGroups(list, group_size)
function! s:SplitListIntoGroups(list, group_size)
    let groups = []
    let i = 0
    while i < len(a:list)
        call add(groups, a:list[i : i + a:group_size - 1])
        let i += a:group_size
    endwhile
    return groups
endfunction
"}}}

"xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
"{{{ function! s:GetLinesFromCoordList(list)
function! s:GetLinesFromCoordList(list)
    let lines_seen = {}
    let lines_no = []
    for [l, c] in a:list
        if !has_key(lines_seen, l)
            call add(lines_no, l)
            let lines_seen[l] = 1
        endif
    endfor
    return lines_no
endfunction
"}}}

"xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
"{{{ function! s:CreateHighlightRegex(coords)
function! s:CreateHighlightRegex(coords)
    let tmp = []
    for [l, c] in a:coords
        call add(tmp, '\%' . l . 'l\%' . c . 'c')
    endfor
    return join(tmp, '\|')
endfunction
"}}}

"xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
"{{{ function! s:Flatten(list)
function! s:Flatten(list)
    let res = []
    for elem in a:list
        call extend(res, elem)
    endfor
    return res
endfunction
"}}}

"xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
"{{{ function! s:AskForGroup(groups)
function! s:AskForGroup(groups) abort
    let lines = s:GetLinesFromCoordList(s:Flatten(a:groups))

   " making backup of lines
    let lines_org = {}
    for l in lines
        let lines_org[l] = getline(l)
    endfor

   " adding targets
    let lines_with_markers = {}
    for l in lines
        let lines_with_markers[l] = split(getline(l), '\zs')
    endfor

    let groups = a:groups[0 : len(s:index_to_key) - 1] "FIXME not enough targets

    for i in range(0, len(groups) - 1)
        for [l, c] in groups[i]
            let lines_with_markers[l][c - 1] = s:index_to_key[i]
        endfor
    endfor

   " create highlight
    let hi_regex = s:CreateHighlightRegex(s:Flatten(groups))
    let user_char = ''
    let modifiable = &modifiable
    let readonly = &readonly

    try
        "syntax off
        let match_id = matchadd(g:cmodGroupMatchTargetHi, hi_regex, -1)
        if modifiable == 0
            silent setl modifiable
        endif
        if readonly == 1
            silent setl noreadonly
        endif

        for [lnum, linee] in items(lines_with_markers)
            call setline(lnum, join(linee, ''))
        endfor
        redraw
        echo "group char> "
        let user_char = nr2char( getchar() )
    finally
        "syntax on
        silent normal! u
        call matchdelete(match_id)
        redraw
        if modifiable == 0
            silent setl nomodifiable
        endif
        if readonly == 1
            silent setl readonly
        endif
    endtry
    if has_key(s:key_to_index, user_char)
        return [ groups[ s:key_to_index[user_char] ] ]
    else
        return []
    endif
endfunction
"}}}

"xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
" get a list of coordinates [ [1,2], [2,5] ]
"{{{ function! s:AskForTarget(group)
function! s:AskForTarget(group)

    let lines = s:GetLinesFromCoordList(a:group)

   " making backup of lines
    let lines_org = {}
    for l in lines
        let lines_org[l] = getline(l)
    endfor


   " adding targets
    let lines_with_markers = {}
    for l in lines
        let lines_with_markers[l] = split(getline(l), '\zs')
    endfor

    let i = 0
    for [l, c] in a:group
        let lines_with_markers[l][c - 1] = s:index_to_key[i]
        let i += 1
    endfor

   " create highlight
    let hi_regex = s:CreateHighlightRegex(a:group)

    let user_char = ''
    let modifiable = &modifiable
    let readonly = &readonly

    try
        "syntax off
        let match_id = matchadd(g:cmodMatchTargetHi, hi_regex, -1)
        if modifiable == 0
            silent setl modifiable
        endif
        if readonly == 1
            silent setl noreadonly
        endif

        for [lnum, linee] in items(lines_with_markers)
            call setline(lnum, join(linee, ''))
        endfor
        redraw
        echo "target char>"
        let user_char = nr2char( getchar() )
        redraw
    finally
        "syntax on
        silent normal! u
        call matchdelete(match_id)
        redraw
        if modifiable == 0
            silent setl nomodifiable
        endif
        if readonly == 1
            silent setl readonly
        endif

        if has_key(s:key_to_index, user_char)
            return a:group[ s:key_to_index[user_char] ]
        else
            return []
        endif
    endtry
endfunction
"}}}

"xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
"{{{ function! s:LinesAllSequential()
function! s:LinesAllSequential()
    return filter( range(line('w0'), line('w$')), 'foldclosed(v:val) == -1' )
endfunction
" }}}

"xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
"{{{ function! s:LinesSurrondingAll(a:surrounding_lines)
" FIXME: folds
function! s:LinesSurrondingAll(surrounding_lines)
    let cur_line = line('.')
    let line_numbers = [ cur_line ]
    let i = 1
    while 1
        let leave = 1
        if cur_line - i >= line('w0')
            call add(line_numbers, cur_line - i)
            let leave = 0
        endif

        if cur_line + i <= line('w$')
            call add(line_numbers, cur_line + i)
            let leave = 0
        endif

        if leave
            break
        endif
        let i += 1
    endwhile
    return line_numbers
endfunction
"}}}

"xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
"{{{ function! Jump()
function! Jump(re, vismode)
    let group_size = len(s:index_to_key)
    let lnums = s:LinesAllSequential()
    let groups = s:SplitListIntoGroups( s:FindTargets(a:re, lnums), group_size )

    if len(groups) == 0
        echo "No such pattern on the screen"
        return
    endif

    if len(groups) == 1 && len(groups[0]) == 1
        call s:JumpToCoords(groups[0][0][0], groups[0][0][1], a:vismode) " FIXME - ugly
        return
    endif

    if len(groups) > 1
        let groups = s:AskForGroup(groups)
    endif

    if len(groups) == 1
        let coords = s:AskForTarget(groups[0])
        if  len(coords) > 0
            call s:JumpToCoords(coords[0], coords[1], a:vismode)
        else
            echo "Cancelled1"
        endif
    else
        echo "Cancelled2"
    endif
endfunction
"}}}



endif " if version >= 700


finish

function! DelMatches()
    for m in getmatches()
        call matchdelete(m.id)
    endfor
endfunction


":" " Are you brave enough to uncomment those?
"vmap f <esc>:call JumpF(1)<cr>
":" "nmap w :call JumpW(0)<cr>
":" "nmap e :call JumpE(0)<cr>
":" "nmap t :call JumpT(0)<cr>
":"
":" "" !! EXPERIMENTAL !!
":" " omap _f :call JumpF(0)<cr>
":" " omap _w :call JumpW(0)<cr>
":" " omap _t :call JumpT(0)<cr>

