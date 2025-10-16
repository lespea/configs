return {
	"Exafunction/codeium.vim",
	cond = vim.env.NO_VIM_AI ~= "1" and vim.env.USE_CODEIUM == "1",
	config = function()
		vim.g.codeium_filetypes_disabled_by_default = false
		vim.g.codeium_filetypes = {
			go = true,
			lua = true,
			python = true,
			rust = true,
		}

		vim.keymap.set("i", "<s-c-i>", "codeium#Accept()", {
			expr = true,
			silent = true,
			desc = "Accept Codeium suggestion",
		})
	end,
	event = "BufEnter",
}
