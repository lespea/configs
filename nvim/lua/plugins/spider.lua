return {
	"chrisgrieser/nvim-spider",
	keys = {
		{
			"e",
			"<cmd>lua require('spider').motion('e')<CR>",
			mode = { "n", "o", "x" },
			desc = "Spider-e motion",
		},
		{
			"w",
			"<cmd>lua require('spider').motion('w')<CR>",
			mode = { "n", "o", "x" },
			desc = "Spider-w motion",
		},
		{
			"b",
			"<cmd>lua require('spider').motion('b')<CR>",
			mode = { "n", "o", "x" },
			desc = "Spider-b motion",
		},
	},
}

