" Increment / Decrement / Add / Subtract
"
" Author: Dimitar Dimitrov (mitkofr@yahoo.fr), kurkale6ka
"
" Latest version at:
" https://github.com/kurkale6ka/vim-sequence
"
" Todo: repeat.vim for visual mode

if exists('g:loaded_sequence') || &compatible || v:version < 700

   if &compatible && &verbose
      echo "Sequence is not designed to work in compatible mode."
   elseif v:version < 700
      echo "Sequence needs Vim 7.0 or above to work correctly."
   endif

   finish
endif

let g:loaded_sequence = 1

let s:savecpo = &cpoptions
set cpoptions&vim

xmap <silent> <plug>SequenceV_Increment :call arithmetic#sequence('v', 'seq_i')<cr>
xmap <silent> <plug>SequenceV_Decrement :call arithmetic#sequence('v', 'seq_d')<cr>

nmap <silent> <plug>SequenceN_Increment :<c-u>call arithmetic#sequence('n', 'seq_i')<cr>
nmap <silent> <plug>SequenceN_Decrement :<c-u>call arithmetic#sequence('n', 'seq_d')<cr>

xmap <silent> <plug>SequenceAdd      :call arithmetic#sequence('v', 'block_a')<cr>
xmap <silent> <plug>SequenceSubtract :call arithmetic#sequence('v', 'block_x')<cr>

xmap <m-a> <plug>SequenceV_Increment
xmap <m-x> <plug>SequenceV_Decrement
nmap <m-a> <plug>SequenceN_Increment
nmap <m-x> <plug>SequenceN_Decrement

xmap <c-a> <plug>SequenceAdd
xmap <c-x> <plug>SequenceSubtract

let &cpoptions = s:savecpo
unlet s:savecpo
