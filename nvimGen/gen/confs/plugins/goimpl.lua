require('telescope').load_extension('goimpl')
require('vimp').nnoremap('<leader>im', function()
	return require('telescope').extensions.goimpl.goimpl()
end)
return true
