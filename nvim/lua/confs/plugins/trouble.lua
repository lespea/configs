require('trouble').setup()local b=require('vimp')b.nnoremap('<leader>xx','<cmd>TroubleToggle<CR>')b.nnoremap('<leader>xw','<cmd>TroubleToggle workspace_diagnostics<CR>')b.nnoremap('<leader>xd','<cmd>TroubleToggle document_diagnostics<CR>')b.nnoremap('<leader>xq','<cmd>TroubleToggle quickfix<CR>')b.nnoremap('<leader>xl','<cmd>TroubleToggle loclist<CR>')return true