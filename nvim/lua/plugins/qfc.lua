return {
	"mei28/qfc.nvim",
	config = function()
		require("qfc").setup({
			timeout = 3000, -- Timeout setting in milliseconds
			enabled = true, -- Enable/disable autoclose feature
		})
	end,
	ft = "qf", -- for lazy load
}
