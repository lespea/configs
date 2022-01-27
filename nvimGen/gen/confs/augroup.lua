vim.cmd([[  augroup cline
      au!
      au WinLeave * set nocursorline
      au WinEnter * set cursorline
      au InsertEnter * set nocursorline
      au InsertLeave * set cursorline
  augroup END
]])
vim.cmd([[	augroup YankHighlight
		autocmd!
    	autocmd TextYankPost * silent! lua vim.highlight.on_yank{higroup='IncSearch', timeout=500, on_visual=true}
	augroup end
]])
vim.cmd([[	au CursorHold * checktim
]])
vim.cmd([[	au BufRead * set rnu
]])
return true
