local movOpts = {
	mode = "lsp_references",
	jump = true,
}

return {
	"folke/trouble.nvim",
	cmd = "Trouble",
	opts = {
		auto_close = true,
		auto_jump = true,
		follow = false,
	},
	keys = {
		{ "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Toggle Trouble" },
		{ "<leader>xw", "<cmd>Trouble diagnostics open<cr>", desc = "Workspace diagnostics" },
		{ "<leader>xd", "<cmd>Trouble diagnostics open filter.buf=0<cr>", desc = "Document diagnostics" },
		{ "<leader>xq", "<cmd>Trouble qflist open<cr>", desc = "Quickfix list" },
		{ "<leader>xl", "<cmd>Trouble loclist open<cr>", desc = "Location list" },
		{ "gR", "<cmd>Trouble lsp_references open<cr>", desc = "LSP references" },
		{
			"<C-S-j>",
			function()
				require("trouble").next(movOpts)
			end,
			desc = "Next trouble item",
		},
		{
			"<C-S-k>",
			function()
				require("trouble").prev(movOpts)
			end,
			desc = "Previous trouble item",
		},
	},
}
