return {
	{
		"altermo/ultimate-autopair.nvim",
		event = { "InsertEnter" },
		branch = "v0.6",
		opts = {
			bs = {
				overjumps = true, --(|foo) > bs > |foo
				space = "balance",
				indent_ignore = true,
			},
			cr = { autoclose = true },
			space = {},
			close = { enable = false },
			config_internal_pairs = {
				{ "[", "]", cmap = false },
				{ "(", ")", cmap = false },
				{ "{", "}", cmap = false },
				{ '"', '"', cmap = false },
				{ "'", "'", cmap = false },
				{ "`", "`", cmap = false },
			},
			extensions = {
				filetype = { tree = false },
				utf8 = false,
			},
		},
	},
}
