" ------------------------------------
" |  Configures the status bar text  |
" ------------------------------------

"  Clear the statusline
set statusline=


" file name
" flags
" filetype
" encoding
" file format

" left/right separator

" current char
" cursor column/total lines
" total lines/percentage in file

set statusline+=%f\
set statusline+=%h%m%r%w
set statusline+=[%{strlen(&ft)?&ft:'none'},
set statusline+=%{strlen(&fenc)?&fenc:&enc},
set statusline+=%{&fileformat}]
set statusline+=%=
set statusline+=%b,0x%-8B\
set statusline+=%c,%l/
set statusline+=%L\ %P


"  Color function
function! InsertStatuslineColor(mode)
  if a:mode == 'i'
    hi statusline guibg=purple
  elseif a:mode == 'r'
    hi statusline guibg=red
  elseif a:mode == 'v'
    hi statusline guibg=blue
  else
    hi statusline guibg=black
  endif
endfunction

"  Insert mode defines the color of the statusline
au InsertEnter * call InsertStatuslineColor(v:insertmode)
au InsertLeave * call InsertStatuslineColor('n')
