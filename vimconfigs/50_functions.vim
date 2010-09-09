" -----------------------------------------------------
" |  A bunch of custom functions (mostly from forums  |
" -----------------------------------------------------

" ------------------------------
" |  Toggle Relative Numbering  |
" ------------------------------

function! g:ToggleNuMode()
    if(&rnu == 1)
        set nu
    else
        set rnu
    endif
endfunc 


" --------------------
" |  Swap two lines  |
" --------------------

function! s:swap_lines(n1, n2)
    let line1 = getline(a:n1)
    let line2 = getline(a:n2)
    call setline(a:n1, line2)
    call setline(a:n2, line1)
endfunction

function! s:swap_up()
    let n = line('.')
    if n == 1
        return
    endif

    call s:swap_lines(n, n - 1)
    exec n - 1
endfunction

function! s:swap_down()
    let n = line('.')
    if n == line('$')
        return
    endif

    call s:swap_lines(n, n + 1)
    exec n + 1
endfunction

noremap <silent> <c-s-up> :call <SID>swap_up()<CR>
noremap <silent> <c-s-down> :call <SID>swap_down()<CR>

" -----------------
" |  CopyMatches  |
" -----------------

" Copy matches of the last search to a register (default is the clipboard).
" Accepts a range (default is whole file).
" 'CopyMatches'   copies matches to clipboard (each match has \n added).
" 'CopyMatches x' copies matches to register x (clears register first).
" 'CopyMatches X' appends matches to register x.
command! -range=% -register CopyMatches call s:CopyMatches(<line1>, <line2>, '<reg>')
function! s:CopyMatches(line1, line2, reg)
  let reg = empty(a:reg) ? '+' : a:reg
  if reg =~# '[A-Z]'
    let reg = tolower(reg)
  else
    execute 'let @'.reg.' = ""'
  endif
  for line in range(a:line1, a:line2)
    let txt = getline(line)
    let idx = match(txt, @/)
    while idx >= 0
      execute 'let @'.reg.' .= matchstr(txt, @/, idx) . "\n"'
      let end = matchend(txt, @/, idx)
      let idx = match(txt, @/, end)
    endwhile
  endfor
endfunction
