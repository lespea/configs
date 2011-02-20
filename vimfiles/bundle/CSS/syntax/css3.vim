" Vim syntax file
" Language:	CSS 3
" Maintainer: lepture <sopheryoung@gmail.com>
" Last Change:	Feb 19, 2010

" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

if !exists("main_syntax")
  let main_syntax = 'css'
endif

if version < 600
  so <sfile>:p:h/css.vim
else
  runtime! syntax/css.vim
  unlet b:current_syntax
endif


syn keyword cssColorProp contained opacity
syn keyword cssColorProp contained currentColor
"syn keyword cssColorProp contained hsl hsla rgb rgba
syn match cssColor contained "\<rgb\s*(\s*\d\+\(\.\d*\)\=%\=\s*,\s*\d\+\(\.\d*\)\=%\=\s*,\s*\d\+\(\.\d*\)\=%\=\s*)"
syn match cssColor contained "\<rgba\s*(\s*\d\+\(\.\d*\)\=%\=\s*,\s*\d\+\(\.\d*\)\=%\=\s*,\s*\d\+\(\.\d*\)\=%\=\s*,\s*\d\+\(\.\d*\)\=%\=\s*)"
syn match cssColor contained "\<hsl\s*(\s*\d\+\(\.\d*\)\=%\=\s*,\s*\d\+\(\.\d*\)\=%\=\s*,\s*\d\+\(\.\d*\)\=%\=\s*)"
syn match cssColor contained "\<hsla\s*(\s*\d\+\(\.\d*\)\=%\=\s*,\s*\d\+\(\.\d*\)\=%\=\s*,\s*\d\+\(\.\d*\)\=%\=\s*,\s*\d\+\(\.\d*\)\=%\=\s*)"
syn match cssTextProp contained "\<word-wrap\>"
syn match cssTextProp contained "\<break-word\>"
syn match cssTextProp contained "\<break-all\>"
syn match cssTextProp contained "\<text-overflow\>"
syn match cssBoxProp contained "\<box-shadow\>"
syn match cssBoxProp contained "\<box-sizing\>"
syn match cssBoxProp contained "\<border-radius\>"
syn match cssBoxProp contained "\<border-image\>"
syn match cssBoxProp contained "\<border-\(\(top-left\|top-right\|bottom-right\|bottom-left\)-radius\)\>"

let b:current_syntax = "css3"
