local set = vim.keymap.set

return {
	"LudoPinelli/comment-box.nvim",
	config = function()
		local box = require("comment-box")
		box.setup({
			doc_width = 120,
			box_width = 80,
		})

		local nv = { "n", "v" }

		-- `:` (not <cmd>) so a visual selection passes its range to the command
		set(nv, "<leader>bb", ":CBllbox<CR>", { desc = "Comment box (left-aligned line)" })
		set(nv, "<leader>bc", ":CBlcbox<CR>", { desc = "Comment box (centered)" })
		set("n", "<leader>bl", "<cmd>CBline<CR>", { desc = "Comment line" })
	end,
}
