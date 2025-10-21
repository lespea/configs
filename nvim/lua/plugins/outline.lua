-- return {
--   'simrat39/symbols-outline.nvim',
--   opts = {},
--   keys = {
--     { '<leader>so', ':SymbolsOutline<CR>' },
--   },
-- }

return {
	"hedyhli/outline.nvim",
	lazy = true,
	cmd = { "Outline", "OutlineOpen" },
	keys = { -- Example mapping to toggle outline
		{ "<leader>so", "<cmd>OutlineFollow<CR>", desc = "Toggle outline" },
	},
	opts = {
		outline_window = {
			focus_on_open = false,
		},
		preview_window = {
			auto_preview = true,
		},
	},
}
