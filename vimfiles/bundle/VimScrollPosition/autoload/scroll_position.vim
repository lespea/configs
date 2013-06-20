if exists("g:loaded_scroll_position") || !has('signs')
  finish
endif
let g:loaded_scroll_position = 1

function scroll_position#show()
  let s:types = {}

  if exists("g:scroll_position_jump")
    exec "sign define scroll_position_j text=".g:scroll_position_jump." texthl=ScrollPositionJump"
    let s:types['j'] = "''"
  endif
  if exists("g:scroll_position_change")
    exec "sign define scroll_position_c text=".g:scroll_position_change." texthl=ScrollPositionchange"
    let s:types['c'] = "'."
  endif
  let s:vtypes = copy(s:types)

  " For visual range
  let s:visual         = get(g:, 'scroll_position_visual', 1)
  let s:visual_begin   = get(g:, 'scroll_position_visual_begin', '^')
  let s:visual_middle  = get(g:, 'scroll_position_visual_middle', ':')
  let s:visual_end     = get(g:, 'scroll_position_visual_end', 'v')
  let s:visual_overlap = get(g:, 'scroll_position_visual_overlap', '<>')
  let s:marker         = get(g:, 'scroll_position_marker', '>')

  let s:types['m'] = "."
  exec "sign define scroll_position_m text=".s:marker." texthl=ScrollPositionMarker"

  let s:vtypes['vb'] = "."
  let s:vtypes['ve'] = "v"
  exec "sign define scroll_position_vb text=".s:visual_begin  ." texthl=ScrollPositionVisualBegin"
  exec "sign define scroll_position_vm text=".s:visual_middle ." texthl=ScrollPositionVisualMiddle"
  exec "sign define scroll_position_ve text=".s:visual_end    ." texthl=ScrollPositionVisualEnd"
  exec "sign define scroll_position_vo text=".s:visual_overlap." texthl=ScrollPositionVisualOverlap"
  sign define scroll_position_e

  if !exists("g:scroll_position_exclusion")
    let s:exclusion = "&buftype == 'nofile'"
  endif

  augroup ScrollPosition
    autocmd!
    autocmd BufNewFile,BufRead * call s:fix_sign()
    autocmd WinEnter,CursorMoved,CursorMovedI,VimResized * :call s:update()
  augroup END

  let s:enabled = 1
  let s:put_fmt = "sign place 99999%d line=%d name=scroll_position_%s buffer=%d"
  let s:rem_fmt = "sign unplace 99999%d buffer=%d"
  call s:fix_sign()
  call s:update()
endfunction

function! s:num_sort(a, b)
  return a:a>a:b ? 1 : a:a==a:b ? 0 : -1
endfunction

function! s:fix_sign()
  exec printf("sign place 8888880 line=1 name=scroll_position_e buffer=%d", bufnr('%'))
endfunction

function! s:put_sign(type, pos)
  exec printf(s:put_fmt, a:pos, a:pos, a:type, bufnr('%'))
endfunction

function! s:rem_sign(pos)
  exec printf(s:rem_fmt, a:pos, bufnr('%'))
endfunction

function s:update()
  if eval(s:exclusion)
    return
  endif

  if !exists('b:scroll_position_pplaces')
    let b:scroll_position_pplaces = {}
    let b:scroll_position_pline   = 0
    let b:scroll_position_plines  = 0
    let b:scroll_position_pvisual = -1
  endif

  let lines         = line('$')
  let cline         = line('.')
  let visual        = (mode() ==? 'v' || mode() == '')
  let line_changed  = cline  != b:scroll_position_pline
  let lines_changed = lines  != b:scroll_position_plines
  let mode_changed  = visual != b:scroll_position_pvisual
  if !lines_changed && !line_changed && !mode_changed
    return
  endif
  let b:scroll_position_pline   = cline
  let b:scroll_position_pvisual = visual

  let top    = line('w0')
  let height = line('w$') - top + 1

  if s:visual > 0 && visual
    let types = s:vtypes
  else
    let types = s:types
  endif

  let places  = {}
  let vrange  = []
  let pplaces = b:scroll_position_pplaces
  for [type, l] in items(types)
    let line = line(l)
    if line
      let lineno = top + float2nr(height * (line - 1) / lines)
      if type == 'vb' || type == 've'
        call add(vrange, lineno)
      else
        let places[lineno] = type
      endif
    endif
  endfor

  " Display visual range
  if s:visual > 0 && visual
    let [b, e] = sort(vrange, 's:num_sort')
    if b < e
      let places[b] = 'vb'
      if s:visual > 1
        for l in range(b + 1, e - 1)
          let places[l] = 'vm'
        endfor
      endif
      let places[e] = 've'
    else
      let places[b] = 'vo'
    endif
  endif

  " Remove all previous signs when total number of lines changed
  let pkeys = keys(pplaces)
  let clearing = lines_changed || mode_changed
  if clearing
    for pos in pkeys
      call s:rem_sign(pos)
    endfor
  endif

  " Place signs when required
  " - Total number of lines changed (cleared)
  " - Mode changed (cleared)
  " - New position
  " - Type changed
  for [pos, type] in items(places)
    if clearing || !has_key(pplaces, pos) || type != pplaces[pos]
      call s:put_sign(type, pos)
    endif
  endfor

  " Remove invalidated signs (after placing new signs!)
  if !clearing
    for pp in pkeys
      if !has_key(places, pp)
        call s:rem_sign(pp)
      endif
    endfor
  endif

  let b:scroll_position_plines  = lines
  let b:scroll_position_pplaces = places
endfunction

function scroll_position#hide()
  augroup ScrollPosition
    autocmd!
  augroup END
 " FIXME
  sign unplace *
  unlet b:scroll_position_pplaces
  unlet b:scroll_position_pline
  unlet b:scroll_position_plines
  unlet b:scroll_position_pvisual
  let s:enabled = 0
endfunction

function scroll_position#toggle()
  if s:enabled
    call scroll_position#hide()
  else
    call scroll_position#show()
  endif
endfunction
