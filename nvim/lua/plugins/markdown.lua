return {
	{
		"OXY2DEV/markview.nvim",
		enabled = true,
		lazy = false, -- Recommended
		dependencies = {
			"nvim-tree/nvim-web-devicons",
			"saghen/blink.cmp",
		},
		-- For `nvim-treesitter` users.
		priority = 49,
		config = function()
			require("markview").setup()
			require("markview.extras.checkboxes").setup()
			require("markview.extras.headings").setup()
			require("markview.extras.editor").setup()
		end,
	},
}
