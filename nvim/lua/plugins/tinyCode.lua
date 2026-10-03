return {
	"rachartier/tiny-code-action.nvim",
	dependencies = {
		{ "folke/snacks.nvim" },
	},
	event = "LspAttach",
	keys = {
		{
			"<F4>",
			function()
				require("tiny-code-action").code_action()
			end,
			mode = { "n", "x" },
			desc = "Code action (with diff preview)",
		},
	},
	opts = {
		-- delta isn't installed on every machine; the vim backend needs nothing extra
		backend = vim.fn.executable("delta") == 1 and "delta" or "vim",
		picker = "snacks",
	},
}
