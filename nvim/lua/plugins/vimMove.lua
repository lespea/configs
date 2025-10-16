return {
	"matze/vim-move",
	init = function()
		vim.g.move_map_keys = 0

		local set = vim.keymap.set

		set("v", "<C-S-Up>", "<Plug>MoveBlockUp", { desc = "Move block up" })
		set("v", "<C-S-Down>", "<Plug>MoveBlockDown", { desc = "Move block down" })
	end,
}
