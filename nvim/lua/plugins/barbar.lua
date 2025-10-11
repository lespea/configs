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
			-- Use the default values: {event = 'BufWinLeave', text = '', align = 'left'}
			NvimTree = true,
			-- Or, specify the text used for the offset:
			undotree = {
				text = "undotree",
				align = "center", -- *optionally* specify an alignment (either 'left', 'center', or 'right')
			},
			-- Or, specify the event which the sidebar executes when leaving:
			["neo-tree"] = { event = "BufWipeout" },
			-- Or, specify all three
			Outline = { event = "BufWinLeave", text = "symbols-outline", align = "right" },
		},
	},
	lazy = false,
	keys = {
		-- Move to previous/next
		{ "<S-h>", "<Cmd>BufferPrevious<CR>", opts },
		{ "<S-l>", "<Cmd>BufferNext<CR>", opts },

		-- Re-order to previous/next
		{ "<A-<>", "<Cmd>BufferMovePrevious<CR>", opts },
		{ "<A->>", "<Cmd>BufferMoveNext<CR>", opts },

		-- Close
		{ "<A-c>", "<Cmd>BufferClose<CR>", opts },

		-- Goto buffer in position...
		{ "<A-1>", "<Cmd>BufferGoto 1<CR>", opts },
		{ "<A-2>", "<Cmd>BufferGoto 2<CR>", opts },
		{ "<A-3>", "<Cmd>BufferGoto 3<CR>", opts },
		{ "<A-4>", "<Cmd>BufferGoto 4<CR>", opts },
		{ "<A-5>", "<Cmd>BufferGoto 5<CR>", opts },
		{ "<A-6>", "<Cmd>BufferGoto 6<CR>", opts },
		{ "<A-7>", "<Cmd>BufferGoto 7<CR>", opts },
		{ "<A-8>", "<Cmd>BufferGoto 8<CR>", opts },
		{ "<A-9>", "<Cmd>BufferGoto 9<CR>", opts },
		{ "<A-0>", "<Cmd>BufferLast<CR>", opts },

		{ ",cab", "<Cmd>BufferCloseAllButCurrent<CR>", opts },
	},
}
