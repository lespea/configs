return {
	"folke/trouble.nvim",
	opts = {},
	cmd = "Trouble",
	init = function()
		local t = require("trouble")
		local set = vim.keymap.set

		t.setup({
			auto_close = true,
			auto_jump = true,
			cycle_results = true,
			follow = false,
		})

		local movOpts = {
			cycle_results = true,
			jump = true,
			mode = "lsp_references",
			skip_groups = true,
		}

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
			t.next(movOpts)
		end, { desc = "Next trouble item" })
		set("n", "<C-S-k>", function()
			t.prev(movOpts)
		end, { desc = "Previous trouble item" })
	end,
}
