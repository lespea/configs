return {
	{ "nvim-tree/nvim-web-devicons", lazy = true },
	{
		"rachartier/tiny-devicons-auto-colors.nvim",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
			-- "dgox16/oldworld.nvim",
			"ThorstenRhau/token",
		},
		event = "VeryLazy",
		config = function()
			local c = require("token.palettes.meridian")("dark")
			require("tiny-devicons-auto-colors").setup({
				colors = {
					c.blue,
					c.cyan,
					c.green,
					c.olive,
					c.orange,
					c.purple,
					c.red,
					c.yellow,
				},
			})
		end,
	},
	{
		"ThorstenRhau/token",
		enabled = true,
		priority = 1000,
		lazy = false,
		config = function()
			require("token").setup({
				terminal_colors = true,
				plugins = {
					all = true,
				},
			})

			vim.cmd.colorscheme("token-meridian")
		end,
	},
}
