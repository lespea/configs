local Settings = require("settings")

return {
	{
		"folke/persistence.nvim",
		event = "BufReadPre", -- this will only start session saving when an actual file was opened
		opts = {},
	},
	---@module 'lazy'
	---@type LazySpec
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		keys = function()
			local keys = {
				{
					"[l",
					function()
						Snacks.words.jump(-1, true)
					end,
					desc = "Prev LSP highlight",
				},
				{
					"]l",
					function()
						Snacks.words.jump(1, true)
					end,
					desc = "Next LSP highlight",
				},
				{
					"<leader>cc",
					function()
						Snacks.scratch()
					end,
					desc = "Scratch pad",
				},
				{
					"<leader>cC",
					function()
						Snacks.scratch.select()
					end,
					desc = "Select scratch pad",
				},
				{
					"<leader>cP",
					function()
						Snacks.profiler.scratch()
					end,
					desc = "Profiler Scratch Buffer",
				},
				{
					"<leader>sp",
					function()
						Snacks.notifier.show_history({ reverse = true })
					end,
					desc = "Show notifs",
				},
				{
					"<leader>wp",
					function()
						Snacks.notifier.hide()
					end,
					desc = "Dismiss popups",
				},
				{
					"<leader>e",
					function()
						Snacks.picker.explorer()
					end,
					desc = "Explorer",
				},
				{
					"<leader>bd",
					function()
						Snacks.bufdelete()
					end,
					desc = "Close buffer",
				},
			}
			if vim.g.picker_engine ~= "snacks" then
				return keys
			end

			local picker_keys = {
				{
					"<leader><leader>",
					function()
						Snacks.picker.buffers()
					end,
					desc = "Buffers",
				},
				{
					"<leader>/",
					function()
						Snacks.picker.grep()
					end,
					desc = "Grep",
				},
				{
					"<leader>:",
					function()
						Snacks.picker.command_history({ layout = { preset = "select" } })
					end,
					desc = "Command History",
				},
				{
					"<leader>sf",
					function()
						Snacks.picker.files()
					end,
					desc = "Find Files",
				},
				-- find
				{
					"<leader>sB",
					function()
						Snacks.picker.pickers()
					end,
					desc = "Pickers",
				},
				{
					"<leader>sG",
					function()
						Snacks.picker.git_files()
					end,
					desc = "Find Git Files",
				},
				{
					"<leader>s.",
					function()
						Snacks.picker.recent()
					end,
					desc = "Recent",
				},
				-- git
				{
					"<leader>sgc",
					function()
						Snacks.picker.git_log()
					end,
					desc = "Git Log",
				},
				{
					"<leader>sgl",
					function()
						Snacks.picker.git_log()
					end,
					desc = "Git Log",
				},
				{
					"<leader>sgL",
					function()
						Snacks.picker.git_log_line()
					end,
					desc = "Git Log Line",
				},
				{
					"<leader>sgf",
					function()
						Snacks.picker.git_log_file()
					end,
					desc = "Git Log File",
				},
				{
					"<leader>sgs",
					function()
						Snacks.picker.git_status()
					end,
					desc = "Git Status",
				},
				{
					"<leader>sgb",
					function()
						Snacks.picker.git_branches()
					end,
					desc = "Git Branches",
				},
				{
					"<leader>sgz",
					function()
						Snacks.picker.git_stash()
					end,
					desc = "Git Stash",
				},
				{
					"gX",
					function()
						Snacks.gitbrowse()
					end,
					desc = "Git browse",
					mode = { "n", "x" },
				},
				-- Grep
				{
					"<leader>sz",
					function()
						Snacks.picker.lines()
					end,
					desc = "Fuzzy find in buffer",
				},
				{
					"<leader>sb",
					function()
						Snacks.picker.grep_buffers()
					end,
					desc = "Grep Open Buffers",
				},
				{
					"<leader>sw",
					function()
						Snacks.picker.grep_word()
					end,
					desc = "Visual selection or word",
					mode = { "n", "x" },
				},
				-- search
				{
					'<leader>s"',
					function()
						Snacks.picker.registers()
					end,
					desc = "Registers",
				},
				{
					"<leader>sa",
					function()
						Snacks.picker.autocmds()
					end,
					desc = "Autocmds",
				},
				{
					"<leader>sc",
					function()
						Snacks.picker.command_history({ layout = { preset = "select" } })
					end,
					desc = "Command History",
				},
				{
					"<leader>sv",
					function()
						Snacks.picker.commands()
					end,
					desc = "Commands",
				},
				{
					"<leader>sd",
					function()
						Snacks.picker.diagnostics()
					end,
					desc = "Diagnostics",
				},
				{
					"<leader>sh",
					function()
						Snacks.picker.help()
					end,
					desc = "Help Pages",
				},
				{
					"<leader>sH",
					function()
						Snacks.picker.highlights()
					end,
					desc = "Highlights",
				},
				{
					"<leader>sj",
					function()
						Snacks.picker.jumps()
					end,
					desc = "Jumps",
				},
				{
					"<leader>sk",
					function()
						Snacks.picker.keymaps()
					end,
					desc = "Keymaps",
				},
				{
					"<leader>sl",
					function()
						Snacks.picker.loclist()
					end,
					desc = "Location List",
				},
				{
					"<leader>sM",
					function()
						Snacks.picker.man()
					end,
					desc = "Man Pages",
				},
				{
					"<leader>sm",
					function()
						Snacks.picker.marks()
					end,
					desc = "Marks",
				},
				{
					"<leader>s'",
					function()
						Snacks.picker.marks()
					end,
					desc = "Marks",
				},
				{
					"<leader>sr",
					function()
						Snacks.picker.resume()
					end,
					desc = "Resume search",
				},
				{
					"<leader>.",
					function()
						Snacks.picker.resume()
					end,
					desc = "Resume search",
				},
				{
					"<leader>sq",
					function()
						Snacks.picker.qflist()
					end,
					desc = "Quickfix List",
				},
				{
					"<leader>sC",
					function()
						Snacks.picker.colorschemes()
					end,
					desc = "Colorschemes",
				},
				{
					"<leader>su",
					function()
						Snacks.picker.undo()
					end,
					desc = "Undotree",
				},
				{
					"<leader>u",
					function()
						Snacks.picker.undo()
					end,
					desc = "Undotree",
				},
				-- { '<leader>qp', function() Snacks.picker.projects() end, desc = 'Projects' },
				-- LSP
				{
					"gd",
					function()
						Snacks.picker.lsp_definitions()
					end,
					desc = "Definition",
				},
				{
					"grd",
					function()
						Snacks.picker.lsp_definitions()
					end,
					desc = "Definition",
				},
				{
					"gr",
					function()
						Snacks.picker.lsp_references()
					end,
					nowait = true,
					desc = "References",
				},
				{
					"grr",
					function()
						Snacks.picker.lsp_references()
					end,
					nowait = true,
					desc = "References",
				},
				{
					"gri",
					function()
						Snacks.picker.lsp_implementations()
					end,
					desc = "Implementation",
				},
				{
					"grt",
					function()
						Snacks.picker.lsp_type_definitions()
					end,
					desc = "Type Definition",
				},
				-- gO
				-- gW
				{
					"<leader>ss",
					function()
						Snacks.picker.lsp_symbols()
					end,
					desc = "LSP Symbols",
				},
				{
					"gO",
					function()
						Snacks.picker.lsp_symbols()
					end,
					desc = "LSP Symbols",
				},
				{
					"<leader>sS",
					function()
						Snacks.picker.lsp_workspace_symbols()
					end,
					desc = "LSP Workspace Symbols",
				},
				{
					"gW",
					function()
						Snacks.picker.lsp_workspace_symbols()
					end,
					desc = "LSP Workspace Symbols",
				},

				-- Notifications
				-- { '<leader>sP', function() Snacks.picker.notifications() end, desc = 'Search notifs' },
			}

			for _, entry in ipairs(picker_keys) do
				table.insert(keys, entry)
			end

			return keys
		end,

		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
			bigfile = {
				enabled = true,
				size = 50 * 1024 * 1024, -- 50 MiB
			},
			dashboard = {
				enabled = true,
				autokeys = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ", -- autokey sequence
				sections = {
					{ section = "header" },
					{ icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 2 },
					{ icon = " ", title = "Projects", section = "projects", indent = 2, padding = 2 },
					{ section = "keys", gap = 1 },
					{ section = "startup" },
				},
				animaget = { duration = { total = 250 } },
			},
			dim = { enabled = true },
			explorer = { enabled = false },
			indent = {
				enabled = true,
				chunk = { enabled = true },
			},
			input = { enabled = true },
			picker = {
				enabled = vim.g.picker_engine == "snacks",
				formatters = {
					file = {
						filename_first = true,
					},
				},
				---@class snacks.picker.previewers.Config
				previewers = {
					diff = {
						builtin = false, -- use Neovim for previewing diffs (true) or use an external tool (false)
						cmd = { "delta" }, -- example to show a diff with delta
					},
					git = {
						builtin = false, -- use Neovim for previewing git output (true) or use git (false)
						args = { "dt" }, -- additional arguments passed to the git command. Useful to set pager options usin `-c ...`
					},
					file = {
						max_size = 1024 * 1024, -- 1MB
						max_line_length = 500, -- max line length
						ft = nil, ---@type string? filetype for highlighting. Use `nil` for auto detect
					},
					man_pager = nil, ---@type string? MANPAGER env to use for `man` preview
				},
				---@diagnostic disable-next-line: missing-fields
				icons = {
					diagnostics = Settings.icons.diagnostics,
				},
				layout = function(source)
					--- Use the vertical layout if screen is small
					if vim.o.columns < 120 then
						return { cycle = true, preset = "vertical" }
					end

					-- NOTE: I went back and forth on this. I could just duplicate the text of the
					-- telescope preset here but then I wouldn't get any updates if it changed.
					-- Instead, we make a copy of the preset and tweak a few values. I'm not sure
					-- if that's better but here it is
					-- One side benefit of using a function instead of an actual table is that
					-- Snacks won't merge this layout with a custom set picker layout like it
					-- would if it were just a table
					local telescope = vim.deepcopy(require("snacks.picker.config.layouts").telescope)

					-- enable backdrop
					telescope.layout["backdrop"] = nil

					-- make help preview width wide enough to display all txt
					local preview_widths = {
						help = 0.58,
					}

					-- find the preview box element and make it slightly larger
					for _, elem in ipairs(telescope.layout) do
						if type(elem) == "table" and elem["win"] == "preview" then
							elem["width"] = preview_widths[source] or 0.52
						end
					end
					return telescope
				end,
				win = {
					-- input window
					input = {
						keys = {
							["<Esc>"] = { "close", mode = { "n", "i" } },
							["<C-_>"] = { "toggle_help", mode = { "n", "i" } },
							["<c-p>"] = { "toggle_preview", mode = { "i", "n" } },
							["<pagedown>"] = { "list_scroll_down", mode = { "i", "n" } },
							["<pageup>"] = { "list_scroll_up", mode = { "i", "n" } },
						},
					},
				},
			},
			notifier = {
				top_down = false,
			},
			quickfile = { enabled = true },
			scope = { enabled = true },
			scroll = { enabled = true },
			statuscolumn = { enabled = true },
			words = { enabled = true },
		},
	},
}
