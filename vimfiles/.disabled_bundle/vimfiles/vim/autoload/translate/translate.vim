" Author: Eric Van Dewoestine
"
" Description: {{{
"   See plugin/translate.vim for a full description.
" }}}
"
" License: {{{
"   Copyright (c) 2009, Eric Van Dewoestine
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

" s:Init() {{{
function s:Init()
  if !exists("s:translate")
    let savewig = &wildignore
    set wildignore=""
    let file = findfile('autoload/translate/translate.vim', escape(&rtp, ' '))
    let &wildignore = savewig

    let separator = has('win32') || has('win64') ? ';' : ':'
    let dir = fnamemodify(file, ':h')
    let cp = substitute(glob(dir . '/*.jar', 1), "\n", separator, 'g')

    " compile Translate.java if necessary.
    if !filereadable(dir . '/Translate.class') ||
      \ (getftime(dir . '/Translate.java') > getftime(dir . '/Translate.class'))
      let cmd = 'javac -cp ' . cp . ' ' . dir . '/Translate.java'
      let result = system(cmd)
      if v:shell_error
        echom 'Failed to compile Translate.java: ' . result
        return
      endif
    endif

    let s:translate = 'java -cp ' . cp . separator . dir . ' Translate '
    let s:complete = 'java -cp ' . cp . separator . dir . ' Translate -c'
  endif
  return 1
endfunction " }}}

" Translate(line1, line2, slang, tlang) {{{
function translate#translate#Translate(line1, line2, slang, tlang)
  if !s:Init()
    return
  endif

  " get the test to send (whole file or visual selection).
  let lines = getline(a:line1, a:line2)
  let mode = visualmode(1)
  if mode != '' && line("'<") == a:line1
    if mode == "v"
      let start = col("'<") - 1
      let end = col("'>")
      let lines[0] = lines[0][start :]
      let lines[-1] = lines[-1][: end]
    elseif mode == "\<c-v>"
      let start = col("'<")
      if col("'>") < start
        let start = col("'>")
      endif
      let start = start - 1
      call map(lines, 'v:val[start :]')
    endif
  endif
  let text = join(lines, "\n")

  " perform the translation.
  let command = s:translate . '"' . text . '" ' . a:slang . ' ' . a:tlang
  let translation = system(command)

  " display the results.
  let s:name = '[Translation]'
  let s:escaped = '[[]Translation[]]'
  if bufwinnr(s:escaped) != -1
    exec bufwinnr(s:escaped) . "winc w"
    setlocal modifiable
    setlocal noreadonly
    silent 1,$delete _
  else
    silent noautocmd exec "botright 10split " . escape(s:name, ' ')
    setlocal nowrap
    setlocal winfixheight
    setlocal noswapfile
    setlocal nobuflisted
    setlocal buftype=nofile
    setlocal bufhidden=delete
    " autocmd to close if last window.
    augroup translate
      autocmd BufEnter * nested
        \ if winnr('$') == 1 && bufwinnr(s:escaped) != -1 |
        \   quit |
        \ endif
    augroup END
  endif

  call append(1, split(translation, "\n"))
  silent 1,1delete _

  setlocal nomodified
  setlocal nomodifiable
  setlocal readonly
endfunction " }}}

" CommandCompleteLanguage(argLead, cmdLine, cursorPos) {{{
" Custom command completion for project names.
function! translate#translate#CommandCompleteLanguage(argLead, cmdLine, cursorPos)
  if !s:Init()
    return []
  endif

  let cmdLine = strpart(a:cmdLine, 0, a:cursorPos)
  let cmdTail = strpart(a:cmdLine, a:cursorPos)
  let argLead = substitute(a:argLead, cmdTail . '$', '', '')

  if !exists('s:langs')
    let s:langs = split(system(s:complete))
  endif

  let langs = copy(s:langs)
  if cmdLine !~ '[^\\]\s$'
    call filter(langs, 'v:val =~ "^' . argLead . '"')
  endif

  return langs
endfunction " }}}

" vim:ft=vim:fdm=marker
