local opts = { silent = true }

return {
	"romgrk/barbar.nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	opts = {
		auto_hide = false,
		icons = {
			preset = "slanted",
		},
		sidebar_filetypes = {
			["neo-tree"] = { event = "BufWipeout" },
		},
	},
	lazy = false,
	keys = {
		-- Move to previous/next
		{ "<S-h>", "<Cmd>BufferPrevious<CR>", opts, desc = "Previous buffer" },
		{ "<S-l>", "<Cmd>BufferNext<CR>", opts, desc = "Next buffer" },

		-- Re-order to previous/next
		{ "<A-.>", "<Cmd>BufferMovePrevious<CR>", opts, desc = "Move buffer left" },
		{ "<A-,>", "<Cmd>BufferMoveNext<CR>", opts, desc = "Move buffer right" },

		-- Close
		{ "<A-c>", "<Cmd>BufferClose<CR>", opts, desc = "Close buffer" },

		-- Goto buffer in position...
		{ "<A-1>", "<Cmd>BufferGoto 1<CR>", opts, desc = "Goto buffer 1" },
		{ "<A-2>", "<Cmd>BufferGoto 2<CR>", opts, desc = "Goto buffer 2" },
		{ "<A-3>", "<Cmd>BufferGoto 3<CR>", opts, desc = "Goto buffer 3" },
		{ "<A-4>", "<Cmd>BufferGoto 4<CR>", opts, desc = "Goto buffer 4" },
		{ "<A-5>", "<Cmd>BufferGoto 5<CR>", opts, desc = "Goto buffer 5" },
		{ "<A-6>", "<Cmd>BufferGoto 6<CR>", opts, desc = "Goto buffer 6" },
		{ "<A-7>", "<Cmd>BufferGoto 7<CR>", opts, desc = "Goto buffer 7" },
		{ "<A-8>", "<Cmd>BufferGoto 8<CR>", opts, desc = "Goto buffer 8" },
		{ "<A-9>", "<Cmd>BufferGoto 9<CR>", opts, desc = "Goto buffer 9" },
		{ "<A-0>", "<Cmd>BufferLast<CR>", opts, desc = "Goto last buffer" },

		{ "<leader>cab", "<Cmd>BufferCloseAllButCurrent<CR>", opts, desc = "Close all but current buffer" },

		{ "<leader>bs", "<Cmd>BufferOrderByName<CR>", opts, desc = "Order buffer by name" },
		{ "<leader>bd", "<Cmd>BufferOrderByDirectory<CR>", opts, desc = "Order buffer by dir" },
	},
}
