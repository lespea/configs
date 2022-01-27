local enabled = {
	enabled = true
}
return require('nvim-treesitter.configs').setup({
	ensure_installed = {
		'go',
		'python',
		'rust',
		'scala'
	},
	highlight = enabled,
	indent = enabled
})
