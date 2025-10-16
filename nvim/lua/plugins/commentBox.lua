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

		set(nv, "<leader>bb", function()
			box.llbox()
		end, { desc = "Comment box (left-aligned line)" })
		set(nv, "<leader>bc", function()
			box.lcbox()
		end, { desc = "Comment box (centered)" })
		set("n", "<leader>bl", function()
			box.line()
		end, { desc = "Comment line" })
	end,
}
