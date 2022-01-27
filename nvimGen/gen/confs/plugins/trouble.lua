require('trouble').setup()
local vimp = require('vimp')
vimp.nnoremap('<leader>xx', '<cmd>TroubleToggle<CR>')
vimp.nnoremap('<leader>xw', '<cmd>TroubleToggle workspace_diagnostics<CR>')
vimp.nnoremap('<leader>xd', '<cmd>TroubleToggle document_diagnostics<CR>')
vimp.nnoremap('<leader>xq', '<cmd>TroubleToggle quickfix<CR>')
vimp.nnoremap('<leader>xl', '<cmd>TroubleToggle loclist<CR>')
return true
