return {
	{
		"stevearc/oil.nvim",
		opts = {
			columns = {
				"icon",
				"permissions",
				"size",
				"mtime",
			},
		},
		-- Optional dependencies
		dependencies = { "nvim-tree/nvim-web-devicons" },
	},
	{
		"benomahony/oil-git.nvim",
		dependencies = { "stevearc/oil.nvim" },
		opts = {},
	},
}
