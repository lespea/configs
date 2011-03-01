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

set statusline+=%f/
set statusline+=%h%m%r%w
set statusline+=[%{strlen(&ft)?&ft:'none'},
set statusline+=%{strlen(&fenc)?&fenc:&enc},
set statusline+=%{&fileformat}]
set statusline+=%=
set statusline+=%b,0x%-8B
set statusline+=%c,%l/
set statusline+=%L\ %P


"  Color function
function! InsertStatuslineColor(mode)
  if a:mode == 'i'
    hi statusline guibg=#9b601a
  elseif a:mode == 'r'
    hi statusline guibg=#9b3535
  elseif a:mode == 'v'
    hi statusline guibg=#a7a863
  else
    hi statusline guibg=#727272
endif
endfunction

"  Insert mode defines the color of the statusline
au InsertEnter * call InsertStatuslineColor(v:insertmode)
au InsertLeave * call InsertStatuslineColor('n')
