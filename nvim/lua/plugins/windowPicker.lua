local function pickWin()
	local id = require("window-picker").pick_window({
		filter_rules = {
			include_current_win = true,
			bo = {
				-- if the file type is one of following, the window will be ignored
				filetype = {
					-- "neo-tree",
					-- "neo-tree-popup",
					"notify",
					"snacks_notif",
				},
				-- if the buffer type is one of following, the window will be ignored
				buftype = {
					-- "terminal",
					-- "quickfix",
				},
			},
		},
	})

	vim.api.nvim_set_current_win(id)
end

return {
	{
		"s1n7ax/nvim-window-picker",
		event = "VeryLazy",
		version = "2.*",
		opts = {
			hint = "floating-big-letter",
			filter_rules = {
				include_current_win = false,
				autoselect_one = true,
				-- filter using buffer options
				bo = {
					-- if the file type is one of following, the window will be ignored
					filetype = { "neo-tree", "neo-tree-popup", "notify", "snacks_notif" },
					-- if the buffer type is one of following, the window will be ignored
					buftype = { "terminal", "quickfix" },
				},
			},
		},
		keys = {
			{ "<leader>fw", pickWin, desc = "Choose window" },
			{ "<space><space>", pickWin, desc = "Choose window" },
		},
	},
}
