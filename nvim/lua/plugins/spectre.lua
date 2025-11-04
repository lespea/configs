return {
	"nvim-pack/nvim-spectre",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	keys = {
		{ "<leader>S", '<cmd>lua require("spectre").toggle()<CR>', desc = "Open spectre" },
	},
}
