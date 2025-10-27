return {
	"rachartier/tiny-inline-diagnostic.nvim",
	event = "VeryLazy",
	priority = 1000,
	config = function()
		require("tiny-inline-diagnostic").setup({
			preset = "powerline",
			options = {
				set_arrow_to_diag_color = true,
				show_all_diags_on_cursorline = true,

				show_sources = {
					enabled = true,
					if_many = true,
				},
				add_messages = {
					-- display_count = true,
				},
				multilines = {
					enabled = true,
				},
				break_line = {
					enabled = false, -- Enable automatic line breaking
					after = 30, -- Number of characters before inserting a line break
				},
			},
		})
		vim.diagnostic.config({ virtual_text = false }) -- Disable Neovim's default virtual text diagnostics
		vim.diagnostic.open_float = require("tiny-inline-diagnostic.override").open_float
	end,
}
