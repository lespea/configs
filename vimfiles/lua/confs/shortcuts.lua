local setMap = vim.api.nvim_set_keymap
local nmap
nmap = function(k, f, o)
	return setMap('n', k, f, o)
end
local optRES = {
	noremap = true,
	expr = true,
	silent = true
}
nmap('k', "v:count == 0 ? 'gk' : 'k'", optRES)
return nmap('j', "v:count == 0 ? 'gj' : 'j'", optRES)
