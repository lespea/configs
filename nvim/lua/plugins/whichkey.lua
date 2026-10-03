return {
	"folke/which-key.nvim",
	dependencies = {
		{ "echasnovski/mini.icons", version = false },
	},
	event = "VeryLazy",
	init = function()
		vim.o.timeout = true
		vim.o.timeoutlen = 300
	end,
	opts = {
		spec = {
			{ "<leader>b", group = "buffers / comment box" },
			{ "<leader>c", group = "clipboard / chat", mode = { "n", "v" } },
			{ "<leader>e", group = "edgy" },
			{ "<leader>f", group = "find" },
			{ "<leader>g", group = "git" },
			{ "<leader>G", group = "go" },
			{ "<leader>h", group = "git hunks", mode = { "n", "v" } },
			{ "<leader>p", group = "params / term copy" },
			{ "<leader>r", group = "run in terminal" },
			{ "<leader>s", group = "search" },
			{ "<leader>t", group = "toggles" },
			{ "<leader>x", group = "trouble" },
			{ "\\t", group = "terminals" },
			{ ";", group = "resize" },
			{ "<space>", group = "treesj / window" },
		},
	},
}
