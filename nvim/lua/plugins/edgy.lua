return {
	"folke/edgy.nvim",
	event = "VeryLazy",
	dependencies = {
		"folke/noice.nvim",
	},
	init = function()
		vim.opt.laststatus = 3
		vim.opt.splitkeep = "screen"
	end,
	keys = {
		-- TODO -- impl something that smartly closes and reopens?
		-- {
		--  "<leader>el",
		--  function()
		--    require("edgy").toggle("left")
		--  end,
		--  { mode = "n", desc = "Toggle Edgy Left" },
		-- },
	},
	opts = {
		options = {
			left = { size = 40 },
			right = { size = 0.36 },
		},
		animate = {
			spinner = require("noice.util.spinners").spinners.circleFull,
		},
		keys = {
			["<C-S-o>"] = function(win)
				win:resize("width", -5)
			end,
			["<C-S-p>"] = function(win)
				win:resize("width", 5)
			end,
		},
		bottom = {
			"Trouble",
			{ ft = "qf", title = "QuickFix", size = { height = 10 } },
			{
				ft = "help",
				size = { height = 0.25 },
				-- only show help buffers
				filter = function(buf)
					return vim.bo[buf].buftype == "help"
				end,
			},
			{ ft = "spectre_panel", size = { height = 0.4 } },
		},
		left = {
			-- Neo-tree filesystem always takes half the screen height
			{
				title = "Neo-Tree",
				ft = "neo-tree",
				filter = function(buf)
					return vim.b[buf].neo_tree_source == "filesystem"
				end,
				size = { height = 0.5 },
			},
			{
				title = function()
					local buf_name = vim.api.nvim_buf_get_name(0) or "[No Name]"
					return vim.fn.fnamemodify(buf_name, ":t")
				end,
				ft = "Outline",
				pinned = true,
				collapsed = false,
				-- open = "SymbolsOutlineOpen",
			},
			-- any other neo-tree windows
			"neo-tree",
		},
		right = {
			{
				ft = "toggleterm",
				-- exclude floating windows
				filter = function(buf, win)
					return vim.api.nvim_win_get_config(win).relative == ""
				end,
			},
			{
				ft = "codecompanion",
				pinned = true,
			},
		},
	},
}
