return {
	"ahkohd/difft.nvim",
	keys = {
		{
			"\\d",
			function()
				if Difft.is_visible() then
					Difft.hide()
				else
					Difft.diff()
				end
			end,
			desc = "Toggle Difft",
		},
	},
	config = function()
		require("difft").setup({
			command = "GIT_EXTERNAL_DIFF='difft --color=always' git diff",
			layout = "float", -- nil (buffer), "float", or "ivy_taller"
		})
	end,
}
