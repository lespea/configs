return {
	"tpope/vim-abolish",
	"tpope/vim-repeat",
	-- 'tpope/vim-speeddating',
	"tpope/vim-unimpaired",
	-- 'triglav/vim-visual-increment',
	{
		"wellle/targets.vim",
		init = function()
			-- nvim 0.12 maps in/an to treesitter node objects, which shadows targets'
			-- "next" modifier (din( / can" / ...). Prefer targets; various-textobjs'
			-- in/an are disabled for the same reason (see treesitter.lua).
			--
			-- NOTE: `:checkhealth targets` still warns that aa/ia collide with the
			-- treesitter @parameter objects. That's intentional: treesitter wins for
			-- plain ia/aa, while targets still provides ina/ana/ila/ala.
			pcall(vim.keymap.del, { "x", "o" }, "in")
			pcall(vim.keymap.del, { "x", "o" }, "an")
		end,
	},
}
