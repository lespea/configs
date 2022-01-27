local lsp = require('lspconfig')
local nls = require('null-ls')
local opts = {
	noremap = true,
	silent = true
}
local on_attach
on_attach = function(client, bufnr)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<Cmd>lua vim.lsp.buf.declarations()<CR>', opts);
	vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts);
	vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gh', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts);
	vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<Cmd>lua vim.lsp.buf.implementation()<CR>', opts);
	vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>', '<Cmd>lua vim.lsp.buf.signature_help()<CR>', opts);
	vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rm', '<Cmd>lua vim.lsp.buf.rename()<CR>', opts);
	vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rr', '<Cmd>lua vim.lsp.buf.references()<CR>', opts);
	vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>d', '<Cmd>lua vim.diagnostic.open_float()<CR>', opts);
	vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>i', '<Cmd>lua vim.lsp.buf.code_action()<CR>', opts);
	vim.api.nvim_buf_set_keymap(bufnr, 'n', '[d', '<Cmd>lua vim.diagnostic.goto_prev()<CR>', opts);
	vim.api.nvim_buf_set_keymap(bufnr, 'n', ']d', '<Cmd>lua vim.diagnostic.goto_next()<CR>', opts)
	if client.resolved_capabilities.document_formatting then
		vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>=', '<Cmd>lua vim.lsp.buf.formatting()<CR>', opts);
		vim.api.nvim_buf_set_keymap(bufnr, 'v', '<leader>=', '<Cmd>lua vim.lsp.buf.formatting()<CR>', opts)
		vim.cmd([[				augroup LspFormatting
					autocmd! * <buffer>
					autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()
				augroup END
			]])
	end
	return true
end
nls.setup({
	sources = {
		nls.builtins.formatting.stylua,
		nls.builtins.diagnostics.eslint,
		nls.builtins.completion.spell
	},
	on_attach = on_attach
})
local capabilities = vim.lsp.protocol.make_client_capabilities()
for _, lang in pairs({
	'pyright',
	'gopls',
	'rust_analyzer',
	'metals'
}) do
	lsp[lang].setup({
		on_attach = on_attach,
		capabilities = capabilities
	})
end
return true
