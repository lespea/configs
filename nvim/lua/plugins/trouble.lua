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
		{ "<C-S-j>", "<cmd>Trouble lsp_references next jump=true<cr>", desc = "Next trouble item" },
		{ "<C-S-k>", "<cmd>Trouble lsp_references prev jump=true<cr>", desc = "Previous trouble item" },
	},
}
