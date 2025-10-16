return {
	{
		"github/copilot.vim",
		cond = vim.env.NO_VIM_AI ~= "1" and vim.env.USE_COPILOT == "1",
		config = function()
			vim.keymap.set("i", "<s-c-i>", 'copilot#Accept("\\<CR>")', {
				expr = true,
				replace_keycodes = false,
				desc = "Accept Copilot suggestion",
			})
			vim.g.copilot_no_tab_map = true
		end,
		event = "BufEnter",
	},
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		cond = vim.env.NO_VIM_AI ~= "1" and vim.env.USE_COPILOT == "1",
		keys = {
			{ "<C-S-c>", "<cmd>CopilotChat<CR>", mode = { "n" }, desc = "Open copilot chat" },
		},
		dependencies = {
			{ "nvim-lua/plenary.nvim", branch = "master" },
		},
		build = "make tiktoken",
		opts = {
			model = "claude-sonnet-4",
		},
	},
}
