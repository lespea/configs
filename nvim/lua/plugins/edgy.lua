-- Helper to open right terminal without focusing
local function open_right_term(focus)
	if _G.my_terminals and _G.my_terminals.right then
		local term = _G.my_terminals.right
		if not term:is_open() then
			local saved_win = vim.api.nvim_get_current_win()
			term:open()
			if not focus and vim.api.nvim_win_is_valid(saved_win) then
				vim.schedule(function()
					vim.api.nvim_set_current_win(saved_win)
				end)
			end
		end
	end
end

return {
	"folke/edgy.nvim",
	event = "VeryLazy",
	dependencies = {
		"folke/noice.nvim",
	},
	init = function()
		vim.opt.laststatus = 3
		vim.opt.splitkeep = "screen"

		-- Track which positions were open before hiding all
		local last_visible = { left = true, right = false, bottom = false }

		-- Smart toggle for a position
		local function smart_toggle(pos)
			local current_win = vim.api.nvim_get_current_win()
			local edgy = require("edgy")
			local config = require("edgy.config")

			-- Check current visibility
			local layout = config.layout[pos]
			local is_visible = layout and #layout.wins > 0

			-- Update tracking
			if is_visible then
				last_visible[pos] = false
			else
				last_visible[pos] = true
			end

			edgy.toggle(pos)

			-- Return focus to main window if we were in one
			vim.schedule(function()
				if vim.api.nvim_win_is_valid(current_win) then
					local editor = require("edgy.editor")
					local wins = editor.list_wins()
					if wins.main[current_win] then
						vim.api.nvim_set_current_win(current_win)
					end
				end
			end)
		end

		-- Toggle all edgy windows
		local function toggle_all_edgy()
			local current_win = vim.api.nvim_get_current_win()
			local edgy = require("edgy")
			local config = require("edgy.config")

			-- Check if any are visible
			local any_visible = false
			for _, pos in ipairs({ "left", "right", "bottom" }) do
				local layout = config.layout[pos]
				if layout and #layout.wins > 0 then
					any_visible = true
					break
				end
			end

			if any_visible then
				-- Save what's currently visible and close all
				for _, pos in ipairs({ "left", "right", "bottom" }) do
					local layout = config.layout[pos]
					last_visible[pos] = layout and #layout.wins > 0
					edgy.close(pos)
				end
			else
				-- Restore only what was visible before (default to just left)
				for _, pos in ipairs({ "left", "right", "bottom" }) do
					if last_visible[pos] then
						edgy.toggle(pos)
					end
				end
			end

			-- Return focus to main window if we were in one
			vim.schedule(function()
				if vim.api.nvim_win_is_valid(current_win) then
					local editor = require("edgy.editor")
					local wins = editor.list_wins()
					if wins.main[current_win] then
						vim.api.nvim_set_current_win(current_win)
					end
				end
			end)
		end

		-- Set up keybindings
		vim.keymap.set("n", "<leader>ee", toggle_all_edgy, { desc = "Toggle all Edgy windows" })
		vim.keymap.set("n", "<leader>el", function()
			smart_toggle("left")
		end, { desc = "Toggle left Edgy windows" })
		vim.keymap.set("n", "<leader>er", function()
			smart_toggle("right")
		end, { desc = "Toggle right Edgy windows" })
		vim.keymap.set("n", "<leader>eb", function()
			smart_toggle("bottom")
		end, { desc = "Toggle bottom Edgy windows" })
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
		exit_when_last = true,
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
				pinned = true,
				open = function()
					vim.cmd("Neotree show left")
				end,
			},
			{
				title = function()
					local buf_name = vim.api.nvim_buf_get_name(0) or "[No Name]"
					return vim.fn.fnamemodify(buf_name, ":t")
				end,
				ft = "Outline",
				pinned = true,
				collapsed = false,
				open = "Outline",
			},
			-- any other neo-tree windows
			"neo-tree",
		},
		right = {
			{
				ft = "toggleterm",
				-- exclude floating windows
				pinned = true,
				filter = function(buf, win)
					return vim.api.nvim_win_get_config(win).relative == ""
				end,
				open = function()
					open_right_term(false) -- false = don't focus
				end,
			},
			{
				ft = "codecompanion",
				open = function()
					require("codecompanion").toggle()
				end,
			},
		},
	},
}
