return {
	{
		"navarasu/onedark.nvim",
		lazy = false, -- make sure we load this during startup if it is your main colorscheme
		priority = 1000, -- make sure to load this before all the other start plugins
		enabled = false,
		-- Set our style and load our colorscheme
		config = function()
			local dark = require("onedark")
			dark.setup({
				style = "darker",
			})
			dark.load()
		end,
	},
	{
		"pauchiner/pastelnight.nvim",
		lazy = false,
		priority = 1000,
		enabled = false,
		config = function()
			local theme = require("pastelnight")
			local c = require("pastelnight.colors").highContrast()

			theme.setup({
				style = "highContrast",
				terminal_colors = false,
			})

			vim.api.nvim_command([[colorscheme pastelnight-highcontrast]])
			vim.api.nvim_set_hl(0, "LspInlayHint", { fg = c.base100 })
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
	{
		"loganswartz/sunburn.nvim",
		enabled = false,
		dependencies = { "loganswartz/polychrome.nvim" },
		-- you could do this, or use the standard vimscript `colorscheme sunburn`
		config = function()
			vim.cmd.colorscheme("sunburn")
		end,
	},
	{
		"dgox16/oldworld.nvim",
		lazy = false,
		priority = 1000,
		enabled = true,
		config = function()
			require("oldworld").setup({
				integrations = {
					neo_tree = false,
				},
			})

			vim.cmd.colorscheme("oldworld")

			local c = require("oldworld.palette")

			vim.api.nvim_set_hl(0, "LspInlayHint", { fg = c.subtext4 })
			vim.api.nvim_set_hl(0, "CursorLine", { bg = c.gray2 })
			vim.api.nvim_set_hl(0, "NeoTreeCursorLine", { bg = c.gray2 })

			vim.api.nvim_set_hl(0, "Ibl1", { fg = c.gray2 })
			vim.api.nvim_set_hl(0, "Ibl2", { fg = c.gray4 })
		end,
	},
}
