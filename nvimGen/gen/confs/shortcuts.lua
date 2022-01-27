local setMap = vim.api.nvim_set_keymap
local optRES = {
	noremap = true,
	expr = true,
	silent = true
}
local optRS = {
	noremap = true,
	silent = true
}
local optS = {
	silent = true
}
local optES = {
	expr = true,
	silent = true
};
setMap('n', '\\qa', ":qa!<CR>", optRS);
setMap('n', 'k', "v:count == 0 ? 'gk' : 'k'", optES);
setMap('n', 'j', "v:count == 0 ? 'gj' : 'j'", optES);
setMap('n', ';k', ':resize +3 <CR>', optS);
setMap('n', ';j', ':resize -3 <CR>', optS);
setMap('n', ';l', ':vertical resize +3 <CR>', optS);
setMap('n', ';h', ':vertical resize -3 <CR>', optS);
setMap('v', '<', '<gv', optRS);
setMap('v', '>', '>gv', optRS)
return true
