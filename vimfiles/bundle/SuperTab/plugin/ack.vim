" Author: Eric Van Dewoestine
"
" Description: {{{
"   Plugin for invoking ack, using :Ack, and adding the result to vim's
"   quickfix.  Also performs some simple conversions from vim regex patterns
"   to perl's (.\{-} to .*?, \<foo\> to \bfoo\b).
" }}}
"
" License: {{{
"   Copyright (c) 2008 - 2009, Eric Van Dewoestine
"   All rights reserved.
"
"   Redistribution and use of this software in source and binary forms, with
"   or without modification, are permitted provided that the following
"   conditions are met:
"
"   * Redistributions of source code must retain the above
"     copyright notice, this list of conditions and the
"     following disclaimer.
"
"   * Redistributions in binary form must reproduce the above
"     copyright notice, this list of conditions and the
"     following disclaimer in the documentation and/or other
"     materials provided with the distribution.
"
"   * Neither the name of Eric Van Dewoestine nor the names of its
"     contributors may be used to endorse or promote products derived from
"     this software without specific prior written permission of
"     Eric Van Dewoestine.
"
"   THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
"   IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
"   THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
"   PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
"   CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
"   EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
"   PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
"   PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
"   LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
"   NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
"   SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
" }}}

" Command Declarations {{{
if !exists(":Ack")
  command -nargs=+ Ack :call <SID>Ack(<q-args>, 0)
endif
if !exists(":AckRelative")
  command -nargs=+ AckRelative :call <SID>Ack(<q-args>, 1)
endif
" }}}

" s:Ack(args, relative) {{{
" Executes ack and populates the quickfix buffer with the results.
function! s:Ack(args, relative)
  if !executable('ack')
    call s:Echo("'ack' not found on your system path.", 'Error')
    return
  endif

  let vimack = fnamemodify(findfile('scripts/vimack', &rtp), ':p')
  if vimack == ''
    call s:Echo("Unable to find vimack in your vim's runtime path", 'Error')
    return
  endif

  let index = 0
  let args = ''
  let arg = ''
  let quote = ''
  let escape = 0
  let prev = ''
  while index < len(a:args)
    let char = a:args[index]
    " spaces that are not escaped or inside of a quoted expression, delimit
    " args
    if char == ' ' && quote == '' && !escape
      let args .= " '" . arg . "'"
      let arg = ''
    " double or single quote, when not escaped, start or end a quoted
    " expression unless the quote encountered is in a quoted expression
    " started by the other type of quote.
    elseif char =~ "['\"]" && !escape
      if quote != '' && char != quote
        let arg .= char
      else
        let quote = (quote == '' ? char : '')
      endif
    else
      if char == '\'
        let escape = !escape
        " handle escaping of spaces and '\'
        if len(a:args) > index && a:args[index + 1] == ' '
          let index += 1
          continue
        endif
      else
        let escape = 0
      endif

      let arg .= char
    endif
    let prev = char
    let index += 1
  endwhile

  " escaping a single quote in a single quoted string is a bit of a pain.
  " http://bash-hackers.org/wiki/doku.php/syntax/quoting#strong_quoting
  " # wrong
  " echo 'Here's my test'
  " # right
  " echo 'Here'\''s my test'
  " Vim requires several backslashes to get that right.
  let args .= " '" . substitute(arg, "'", "'\\\\''", "g") . "'"

  if a:relative
    let cwd = getcwd()
    exec 'cd ' . expand('%:p:h')
  endif
  let saveerrorformat = &errorformat
  try
    set errorformat=%-Gack:%.%#,%-Gvimack:%.%#,%f:%l:%c:%m,%f:%l:%m,%-G%.%#
    let cmd = '"' . vimack . '" ' . args
    cexpr system(cmd)
    if exists('g:EclimHome')
      call eclim#display#signs#Show('i', 'qf')
    endif
  finally
    let &errorformat = saveerrorformat
    if a:relative
      exec 'cd ' . cwd
    endif
  endtry

  " ack returns 1 on no results found, so errors are greater than that.
  if v:shell_error > 1
    let error = system(cmd)
    call s:Echo(error, 'Error')
  elseif len(getqflist()) == 0
    call s:Echo('No results found: Ack' . args, 'WarningMsg')
  endif
endfunction " }}}

" s:Echo(message, hightlight) {{{
function s:Echo(message, highlight)
  exec "echohl " . a:highlight
  redraw
  for line in split(a:message, '\n')
    echom line
  endfor
  echohl None
endfunction " }}}

" vim:ft=vim:fdm=marker
