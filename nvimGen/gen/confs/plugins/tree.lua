require('nvim-tree').setup({
	update_to_buf_dir = {
		enable = false
	}
})
local vimp = require('vimp')
vimp.nnoremap('<leader>tt', ':NvimTreeToggle<CR>')
return vimp.nnoremap('<leader>tr', ':NvimTreeRefresh<CR>')
