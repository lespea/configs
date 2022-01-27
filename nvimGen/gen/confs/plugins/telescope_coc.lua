require('telescope').load_extension('coc')
local vimp = require('vimp')
vimp.nnoremap('<leader>fd', function()
	return require('telescope').extensions.coc.definitions({ })
end)
return true
