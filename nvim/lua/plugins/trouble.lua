return {
	"folke/trouble.nvim",
	opts = {},
	init = function()
		local t = require("trouble")
		local set = vim.keymap.set

		set("n", "<leader>xx", function()
			t.toggle()
		end, { desc = "Toggle Trouble" })
		set("n", "<leader>xw", function()
			t.open("workspace_diagnostics")
		end, { desc = "Workspace diagnostics" })
		set("n", "<leader>xd", function()
			t.open("document_diagnostics")
		end, { desc = "Document diagnostics" })
		set("n", "<leader>xq", function()
			t.open("quickfix")
		end, { desc = "Quickfix list" })
		set("n", "<leader>xl", function()
			t.open("loclist")
		end, { desc = "Location list" })

		set("n", "gR", function()
			t.open("lsp_references")
		end, { desc = "LSP references" })

		set("n", "<C-S-j>", function()
			t.next({ skip_groups = true, jump = true })
		end, { desc = "Next trouble item" })
		set("n", "<C-S-k>", function()
			t.previous({ skip_groups = true, jump = true })
		end, { desc = "Previous trouble item" })
	end,
}
