local highlight = {
	"Ibl1",
	"Ibl2",
}

return {
	"lukas-reineke/indent-blankline.nvim",
	enabled = false,
	main = "ibl",
	opts = {
		indent = { highlight = highlight, char = "" },
		whitespace = {
			highlight = highlight,
			remove_blankline_trail = true,
		},
		scope = { enabled = false },
	},
}
