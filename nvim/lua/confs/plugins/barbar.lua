local b=vim.api.nvim_set_keymap;require('bufferline').setup()b('n','<S-h>',':BufferPrevious<CR>',{noremap=true,silent=true})b('n','<S-l>',':BufferNext<CR>',{noremap=true,silent=true})b('n','<A-c>',':BufferClose<CR>',{noremap=true,silent=true})b('n','<A-<>',':BufferMovePrevious<CR>',{noremap=true,silent=true})b('n','<A->>',':BufferMoveNext<CR>',{noremap=true,silent=true})b('n','<A-1>',':BufferGoto 1<CR>',{noremap=true,silent=true})b('n','<A-2>',':BufferGoto 2<CR>',{noremap=true,silent=true})b('n','<A-3>',':BufferGoto 3<CR>',{noremap=true,silent=true})b('n','<A-4>',':BufferGoto 4<CR>',{noremap=true,silent=true})b('n','<A-5>',':BufferGoto 5<CR>',{noremap=true,silent=true})b('n','<A-6>',':BufferGoto 6<CR>',{noremap=true,silent=true})b('n','<A-7>',':BufferGoto 7<CR>',{noremap=true,silent=true})b('n','<A-8>',':BufferGoto 8<CR>',{noremap=true,silent=true})return true