" tabops -- A collection of miscellaneous functionalities operating tabs.
"
" Description:
"
"   This script provides tab operation functionalities.
"   Going to some tab, moving some tab and sorting tabs.
"
" Maintainer: Shuhei Kubota <kubota.shuhei+vim@gmail.com>
"
" Usage:
"   1. (optional) set prefix if you want to change. (let g:Tabops_prefix)
"      default: <Tab>
"   2. (optional) let g:Tabops_use??? variables 0 if you want to disable some features.
"   3. start editing
"
"   X. execute :Tabops command with some parameters (see Feature section)
"
" Feature:
"
"   * the default prefix is <Tab>
"
"   if g:Tabops_useGoto == 1 then ...
"       <C-Tab>  : goto the next tab.
"       <S-C-Tab>: goto the prev tab.
"
"       {prefix}1: goto the 1st tab.
"       {prefix}2: goto the 2nd tab.
"          :
"       {prefix}8: goto the 8th tab.
"       {prefix}9: goto the LAST tab.
"
"   if g:Tabops_useMove == 1 then ...
"       {prefix}l: swap the current tab with the right one.
"       {prefix}h: swap the cerrent tab with the left one.
"
"
"   :Tabops [Close | Open | ...]
"       Close
"           Right
"           Left
"               closes right/left tabs except the current tab.
"       Open
"           Siblings [LOADED]
"               scans buffers that are in the same directory, and open them in tabs.
"               with LOADED, only loaded buffers are read in tabs. (not globbed)
"           WndInNewTab
"               (in splitted window) closes the current window and opens it in new tab.
"       Reopen
"           re-opens a closed tab.
"       Sort
"           ByPath
"               sorts tabs comparing their paths.
"           ByBufnr
"               sorts tabs comparing their internal numbers.
"           ByLastChange
"               sorts tabs comparing their recently-changed timestamps.
"               the most recent tab comes to left.
"       Uniq
"           closes duplicate tabs.
"

if !exists('g:Tabops_prefix')
    let g:Tabops_prefix = '<Tab>'
endif

if !exists('g:Tabops_useGoto')
    let g:Tabops_useGoto = 1
endif

if !exists('g:Tabops_useMove')
    let g:Tabops_useMove = 1
endif

if !exists('g:Tabops__closedTabHistory')
    let g:Tabops__closedTabHistory = [] " [{'b': closed bufnr, 't': placed position}]
endif

augroup Tabops
    autocmd!

    "to setting key mappings
    autocmd  BufEnter    * call <SID>Tabops_onBufEnter()

    "to handle closing a tab
    autocmd  BufLeave    * call <SID>Tabops_onBufLeave()
    autocmd  TabLeave    * call <SID>Tabops_onTabLeave()
    autocmd  BufWinLeave * call <SID>Tabops_onBufWinLeave()
augroup END


function! s:Tabops__defineCommandsOnStartup()
    command!  -nargs=+ -complete=customlist,<SID>Tabops__complete  Tabops  :call <SID>Tabops_execute(<q-args>)

    "command!  TabopsSortByPath       :call <SID>Tabops_sortByPath()
    "command!  TabopsSortByBufnr      :call <SID>Tabops_sortByBufnr()
    "command!  TabopsSortByLastChange :call <SID>Tabops_sortByLastChange()
    "command!  TabopsReopenClosedTab  :call <SID>Tabops_reopenClosedTab()
    "command!  TabopsUniq             :call <SID>Tabops_uniq()
    "command!  TabopsCloseRight       :call <SID>Tabops_closeRight()
    "command!  TabopsCloseLeft        :call <SID>Tabops_closeLeft()
    "command!  TabopsOpenWndInNewTab  :call <SID>Tabops_openWndInNewTab()
    "command!  -nargs=? -complete=customlist,<SID>Tabops_openSiblings__complete  TabopsOpenSiblings  :call <SID>Tabops_openSiblings(<q-args>)

    let s:Tabops__commandTree = {
                \   'Close' : {
                    \   'Right' : function('s:Tabops_closeRight')
                    \ , 'Left' : function('s:Tabops_closeLeft')
                    \ }
                \ , 'Open' : {
                    \   'Siblings' : {
                        \   'LOADED' : function('s:Tabops_openSiblingsLoaded')
                        \ , ' ' : function('s:Tabops_openSiblingsUnloaded')
                        \ }
                    \ , 'WndInNewTab' : function('s:Tabops_openWndInNewTab')
                    \ }
                \ , 'Reopen' : function('s:Tabops_reopenClosedTab')
                \ , 'Sort' : {
                    \   'ByPath' : function('s:Tabops_sortByPath')
                    \ , 'ByBufnr' : function('s:Tabops_sortByBufnr')
                    \ , 'ByLastChange' : function('s:Tabops_sortByLastChange')
                    \ }
                \ , 'Uniq' : function('s:Tabops_uniq')
                \ }
endfunction

function! s:Tabops__complete(argLead, cmdLine, cursorPos)
    let args = split(a:cmdLine, '\V\s\+')
    let p = s:Tabops__commandTree
    "echom 'args: ' . join(args, ', ')
    for i in args[1:]
        if !has_key(p, i) || i ==? a:argLead
            return sort(filter(keys(p), 'v:val =~? "^' . a:argLead . '"'))
        endif

        "echom 'p['.i.']:'.string(p[i])
        if type(p[i]) == type({})
            let p = p[i]
        else
            return []
        endif
    endfor

    return sort(keys(p))
endfunction

function! s:Tabops_execute(arg)
    let args = split(a:arg, '\V\s\+')
    let p = s:Tabops__commandTree
    for i in args
        if !has_key(p, i)
            echo 'select command within [' . join(sort(keys(p)), ', ') . ']'
            return
        endif
        "echom 'p['.i.']:'.string(p[i])
        if type(p[i]) == type({})
            "echom 'type{}'
            let p = p[i]
        else
            "echom 'type funcref'
            let Func = p[i]
            call Func()
            return
        endif
    endfor

    "echom string(p)
    let defaultKey = ' '
    if has_key(p, defaultKey) && type(p[defaultKey]) != type({})
        let Func = p[defaultKey]
        call Func()
        return
    endif

    echo 'select command within [' . join(sort(keys(p)), ', ') . ']'
endfunction


function! s:Tabops_openSiblingsLoaded()
    return s:Tabops_openSiblings('LOADED')
endfunction

function! s:Tabops_openSiblingsUnloaded()
    return s:Tabops_openSiblings('')
endfunction

function! s:Tabops_openSiblings(arg)
    let ld = &lazyredraw
    let &lazyredraw = 1
    let s:Tabops__reopening = 1

    tabonly

    let curr = bufnr('%')
    let path = expand('%:p:h')

    " open
    execute 'buffer ' . curr
    for b in range(1, bufnr('$'))
        let bpath = expand('#' . b . ':p:h')

        if buflisted(b) && path == bpath && curr != b
            "echom 'bpath: ' . bpath
            tab split
            execute 'buffer ' . b
        endif
    endfor

    if a:arg == ''
        call s:Tabops_openSiblings__doGLOB()
    endif

    call s:Tabops__goto(1)
    call s:Tabops_uniq()
    call s:Tabops_sortByPath()

    let s:Tabops__reopening = 0
    let &lazyredraw = ld
endfunction

function! s:Tabops_openSiblings__complete(argLead, cmdLine, cursorPos)
    return ['LOADED', '']
endfunction

function! s:Tabops_openSiblings__doGLOB()
    let curr = bufnr('%')
    let path = expand('%:p:h')

    let files = split(glob(path.'/*'))

    " open
    for i in range(len(files))
        if !isdirectory(files[i])
            "echom 'tabedit ' . files[i]
            execute 'tabedit ' . escape(files[i], ' ')
        endif
    endfor
endfunction


function! s:Tabops_onBufEnter()
    if g:Tabops_useGoto
        call s:Tabops__enableCtrlGoto()
        call s:Tabops__enableNumberGoto()
    endif
    if g:Tabops_useMove
        call s:Tabops__enableMove()
    endif
endfunction

"if this is 1, do not record closing tabs.
let s:Tabops__reopening = 0
"nop when these are 0.
let s:Tabops__leavingBufferNumber = 0
let s:Tabops__leavingTabNumber = 0

function! s:Tabops_onBufLeave()
    if s:Tabops__reopening | return | endif
    let s:Tabops__leavingBufferNumber = bufnr('%')
endfunction

function! s:Tabops_onTabLeave()
    if s:Tabops__reopening | return | endif
    let s:Tabops__leavingTabNumber = tabpagenr()
endfunction

function! s:Tabops_onBufWinLeave()
    if s:Tabops__reopening | return | endif
    if s:Tabops__leavingBufferNumber == 0 || s:Tabops__leavingTabNumber == 0 | return | endif

    call insert(g:Tabops__closedTabHistory, {'b': s:Tabops__leavingBufferNumber, 't': s:Tabops__leavingTabNumber}, 0)

    let g:Tabops__closedTabHistory = g:Tabops__closedTabHistory[:4]
endfunction


function! s:Tabops__enableCtrlGoto()
    noremap  <silent>  <C-Tab>   :tabnext<CR>
    noremap  <silent>  <S-C-Tab> :tabprevious<CR>
endfunction

function! s:Tabops__enableNumberGoto()
    execute 'noremap  <buffer><silent>  '.g:Tabops_prefix."1  :call \<SID>Tabops__goto(1)<CR>"
    execute 'noremap  <buffer><silent>  '.g:Tabops_prefix."2  :call \<SID>Tabops__goto(2)<CR>"
    execute 'noremap  <buffer><silent>  '.g:Tabops_prefix."3  :call \<SID>Tabops__goto(3)<CR>"
    execute 'noremap  <buffer><silent>  '.g:Tabops_prefix."4  :call \<SID>Tabops__goto(4)<CR>"
    execute 'noremap  <buffer><silent>  '.g:Tabops_prefix."5  :call \<SID>Tabops__goto(5)<CR>"
    execute 'noremap  <buffer><silent>  '.g:Tabops_prefix."6  :call \<SID>Tabops__goto(6)<CR>"
    execute 'noremap  <buffer><silent>  '.g:Tabops_prefix."7  :call \<SID>Tabops__goto(7)<CR>"
    execute 'noremap  <buffer><silent>  '.g:Tabops_prefix."8  :call \<SID>Tabops__goto(8)<CR>"
    execute 'noremap  <buffer><silent>  '.g:Tabops_prefix.'9  :tablast<CR>'
endfunction

function! s:Tabops__enableMove()
    execute 'noremap  <buffer><silent>  '.g:Tabops_prefix."l  :call \<SID>Tabops__swapNext()<CR>"
    execute 'noremap  <buffer><silent>  '.g:Tabops_prefix."h  :call \<SID>Tabops__swapPrev()<CR>"
endfunction

"
" uniq-ing
"

function! s:Tabops_uniq()
    let tabs = []
    let currtabnr = tabpagenr()

    " fillin each value
    for i in range(1, tabpagenr('$'))
        let value = s:Tabops_sortByBufnr__Evalfunc(i)
        call extend(tabs, [{'nr':i, 'value':value, 'dup':0}])
    endfor

    " sort by bufnr
    call sort(tabs, 's:Tabops_uniq__sortByBufnr')

    " find duplicates & mark latter ones
    for i in range(tabpagenr('$'), 2, -1)
        if tabs[i - 2].value == tabs[i - 1].value
            let tabs[i - 1].dup = 1

            if tabs[i - 1].nr == currtabnr
                let currtabnr = tabs[i - 2].nr
            endif
        endif
    endfor

    " re-sort by tabnr
    call sort(tabs, 's:Tabops_uniq__sortByTabnr')

    " close tabs
    let ld = &lazyredraw
    let &lazyredraw = 1
    for i in range(tabpagenr('$'), 1, -1)
        if tabs[i - 1].dup
            call s:Tabops__goto(tabs[i - 1].nr)
            tabclose
        endif
    endfor

    call s:Tabops__goto(currtabnr)

    let &lazyredraw = ld
endfunction

function! s:Tabops_uniq__sortByBufnr(v1, v2)
    return (a:v1.value . ':' . a:v1.nr) == (a:v2.value . ':' . a:v2.nr) ? 0 : (a:v1.value . ':' . a:v1.nr) > (a:v2.value . ':' . a:v2.nr) ? 1 : -1
endfunction

function! s:Tabops_uniq__sortByTabnr(v1, v2)
    return a:v1.nr == a:v2.nr ? 0 : a:v1.nr > a:v2.nr ? 1 : -1
endfunction


"
" sorting
"

function! s:Tabops_sortByPath()
    call s:Tabops__sortByHoge(function('s:Tabops_sortByPath__Evalfunc'), function('s:Tabops_sortByPath__Cmpfunc'))
endfunction

function! s:Tabops_sortByPath__Evalfunc(tabidx)
    return expand('#'.tabpagebuflist(a:tabidx)[0].':p')
endfunction

function! s:Tabops_sortByPath__Cmpfunc(v1, v2)
    return a:v1.value == a:v2.value ? 0 : a:v1.value > a:v2.value ? 1 : -1
endfunction


function! s:Tabops_sortByLastChange()
    call s:Tabops__sortByHoge(function('s:Tabops_sortByLastChange__Evalfunc'), function('s:Tabops_sortByLastChange__Cmpfunc'))
endfunction

function! s:Tabops_sortByLastChange__Evalfunc(tabidx)
    call s:Tabops__goto(a:tabidx)
    "let currbufnr = bufnr('%')

    "get last changed datetime
    "echom ' ' . bufname('%')
    let last_time = 0
    let ut = undotree()
    if has_key(ut, 'seq_last')
        let seq_last = ut.seq_last
        "echom 'seq_last:' . seq_last
        let ee = copy(ut.entries)
        call filter(ee, 'v:val.seq == ' . seq_last)
        if len(ee) > 0
            let last_time = ee[0].time
            "echom 'last_time:' . last_time
        endif
    endif
    if last_time == 0
        "couldn't fetch time -> try to fetch file timestamp
        let last_time = getftime(expand('%'))
        if last_time == -1
            "new and clean buffers
            let last_time = localtime()
        endif
    endif

    "echom strftime('%Y%m%d %H:%M:%S', last_time)
    return strftime('%Y%m%d %H:%M:%S', last_time)
endfunction

function! s:Tabops_sortByLastChange__Cmpfunc(v1, v2)
    return a:v1.value == a:v2.value ? 0 : a:v1.value < a:v2.value ? 1 : -1
endfunction


function! s:Tabops_sortByBufnr()
    call s:Tabops__sortByHoge(function('s:Tabops_sortByBufnr__Evalfunc'), function('s:Tabops_sortByBufnr__Cmpfunc'))
endfunction

function! s:Tabops_sortByBufnr__Evalfunc(tabidx)
    return tabpagebuflist(a:tabidx)[0]
endfunction

function! s:Tabops_sortByBufnr__Cmpfunc(v1, v2)
    return a:v1.value == a:v2.value ? 0 : a:v1.value > a:v2.value ? 1 : -1
endfunction


function! s:Tabops__sortByHoge(Evalfunc, Cmpfunc)
    let tabs = []

    let currtabnr = tabpagenr()

    let ld = &lazyredraw
    let &lazyredraw = 1

    "fillin each values
    for i in range(1, tabpagenr('$'))
        let value = a:Evalfunc(i)
        call extend(tabs, [{'src':i, 'value':value}])
        "echom i-1.'  src: '.i.', value: '.value
    endfor

    "sort
    call sort(tabs, a:Cmpfunc)

    "where should i goto, after moving
    let desttabidx = 1
    for i in range(1, len(tabs))
        let elem = tabs[i - 1]
        if elem.src == currtabnr
            let desttabidx = i
        endif
    endfor

    "move
    for i in range(1, len(tabs))
        let elem = tabs[i - 1]
        if i != elem.src
            call s:Tabops__goto(elem.src)
            execute 'tabmove ' . string(i - 1)
            for j in range(i + 1, len(tabs))
                if elem.src >= tabs[j - 1].src
                    let tabs[j - 1].src = tabs[j - 1].src + 1
                endif
            endfor
        endif
    endfor

    call s:Tabops__goto(desttabidx)

    let &lazyredraw = ld
endfunction


"
" other operations
"

function! s:Tabops_closeRight()
    " close tabs
    let ld = &lazyredraw
    let &lazyredraw = 1
    for i in range(tabpagenr('$'), tabpagenr() + 1, -1)
        execute 'tabclose! ' . string(i)
    endfor
    let &lazyredraw = ld
endfunction

function! s:Tabops_closeLeft()
    " close tabs
    let ld = &lazyredraw
    let &lazyredraw = 1
    for i in range(tabpagenr() - 1, 1, -1)
        execute 'tabclose! ' . string(i)
    endfor
    let &lazyredraw = ld
endfunction


function! s:Tabops_openWndInNewTab()
    if winnr('$') == 1 | return | endif
    let currbufnr = bufnr('%')

    let ld = &lazyredraw
    let &lazyredraw = 1
    close
    tabedit
    execute currbufnr . 'buffer'
    let &lazyredraw = ld
endfunction


function! s:Tabops_reopenClosedTab()
    if len(g:Tabops__closedTabHistory) == 0 | return | endif

    let top = g:Tabops__closedTabHistory[0]
    let g:Tabops__closedTabHistory = g:Tabops__closedTabHistory[1:]

    let ld = &lazyredraw
    let &lazyredraw = 1

    let s:Tabops__reopening = 1

    silent tablast
    silent tabedit
    silent execute string(top.b).'b '
    for i in range(tabpagenr('$'))
        if i == top.t | continue | endif
        call s:Tabops__swapPrev()
    endfor

    let s:Tabops__reopening = 0
    let s:Tabops__leavingBufferNumber = 0
    let s:Tabops__leavingTabNumber = 0

    let &lazyredraw = ld
endfunction


"
" utilities
"

function! s:Tabops__goto(tabindex)
    silent execute 'tabnext ' . string(a:tabindex)
endfunction


function! s:Tabops__swapNext()
    let lasttabidx = tabpagenr('$') - 1
    let tabidx = tabpagenr() - 1
    if tabidx == lasttabidx
        let desttabidx = 0
    else
        let desttabidx = tabidx + 1
    endif

    execute 'tabmove ' . string(desttabidx)
endfunction

function! s:Tabops__swapPrev()
    let lasttabidx = tabpagenr('$') - 1
    let tabidx = tabpagenr() - 1
    if tabidx == 0
        let desttabidx = lasttabidx
    else
        let desttabidx = tabidx - 1
    endif

    execute 'tabmove ' . string(desttabidx)
endfunction

call s:Tabops__defineCommandsOnStartup()

" vim: set et ft=vim sts=4 sw=4 ts=4 tw=78 : 
