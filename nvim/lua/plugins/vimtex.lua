return {
	"lervag/vimtex",
	enabled = false,
	lazy = false,
	config = function()
		-- vim.g.vimtex_compiler_method = "lualatex"
		-- vim.g.vimtex_view_general_viewer = 'okular'
		vim.g.vimtex_view_general_viewer = "zathura"
		-- vim.g.vimtex_view_general_options = '--unique file:@pdf\\#src:@line@tex'
		-- vim.g.vimtex_compiler_latexmk = {
		--   build_dir = '.out',
		--   options = {
		--     '-shell-escape',
		--     '-verbose',
		--     '-file-line-error',
		--     '-interaction=nonstopmode',
		--     '-synctex=1'
		--   }
		-- }
	end,
}
