return {
	{
		"dgox16/oldworld.nvim",
		lazy = false,
		priority = 1000,
		enabled = true,
		config = function()
			require("oldworld").setup({
				integrations = {
					neo_tree = false,
					snacks = false,
				},
			})

			vim.cmd.colorscheme("oldworld")

			local c = require("oldworld.palette")

			vim.api.nvim_set_hl(0, "LspInlayHint", { fg = c.subtext4 })
			vim.api.nvim_set_hl(0, "CursorLine", { bg = c.gray2 })
			vim.api.nvim_set_hl(0, "NeoTreeCursorLine", { bg = c.gray2 })

			-- vim.api.nvim_set_hl(0, "Ibl1", { fg = c.gray2 })
			-- vim.api.nvim_set_hl(0, "Ibl2", { fg = c.gray4 })
		end,
	},
	{ "nvim-tree/nvim-web-devicons", lazy = true },
	{
		"rachartier/tiny-devicons-auto-colors.nvim",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
			"dgox16/oldworld.nvim",
		},
		event = "VeryLazy",
		config = function()
			local c = require("oldworld.palette")
			require("tiny-devicons-auto-colors").setup({
				colors = {
					c.red,
					c.green,
					c.yellow,
					c.purple,
					c.magenta,
					c.orange,
					c.blue,
					c.cyan,
				},
			})
		end,
	},
}
