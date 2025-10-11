return {
	"goolord/alpha-nvim",
	enabled = false,
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		require("alpha").setup(require("alpha.themes.startify").config)
	end,
}
