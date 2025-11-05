return {
	{
		"folke/persistence.nvim",
		event = "BufReadPre", -- this will only start session saving when an actual file was opened
		opts = {
			options = { "globals" },
			pre_save = function()
				vim.api.nvim_exec_autocmds("User", { pattern = "SessionSavePre" })
			end,
		},
	},
	---@module 'lazy'
	---@type LazySpec
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		keys = {
			-- Top Pickers & Explorer
			{
				"<leader><space>",
				function()
					Snacks.picker.smart()
				end,
				desc = "Smart Find Files",
			},
			{
				"<leader>,",
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
					Snacks.picker.command_history()
				end,
				desc = "Command History",
			},
			{
				"<leader>sn",
				function()
					Snacks.picker.notifications()
				end,
				desc = "Notification History",
			},
			-- find
			{
				"<leader>fb",
				function()
					Snacks.picker.buffers()
				end,
				desc = "Buffers",
			},
			{
				"<leader>fc",
				function()
					Snacks.picker.files_with_symbols({
						cwd = vim.fn.stdpath("config"),
					})
				end,
				desc = "Find Config File",
			},
			{
				"<leader>fd",
				function()
					Snacks.picker.diagnostics()
				end,
				desc = "Diagnostics",
			},
			{
				"<leader>ff",
				function()
					Snacks.picker.files_with_symbols({
						hidden = true,
						ignored = true,
						exclude = {
							".bloop",
							".idea",
							".metals",
							".venv",
							"__pycache__",
							"findings",
							"node_modules",
							"target",
						},
					})
				end,
				desc = "Find Files",
			},
			{
				"<leader>fg",
				function()
					Snacks.picker.grep({
						hidden = true,
					})
				end,
				desc = "Grep",
			},
			{
				"<leader>fu",
				function()
					Snacks.picker.grep({
						cmd = "rg",
						dirs = { "./scanner/src/main/scala/org/tgt/cfc/pippee/allowlist/rules/" },
						regex = false,
						hidden = true,
						ignored = true,
					})
				end,
				desc = "FP grep",
			},
			{
				"<leader>fk",
				function()
					Snacks.picker.grep({
						dirs = { "./scanner/src/main/scala/org/tgt/cfc/pippee/allowlist/rules/" },
						regex = true,
						hidden = true,
						ignored = true,
						search = '(?-iu)from *= *from(?:Emails|Domains)\\([^)]*"[^()"\\n]*(?i)',
						args = { "-U" },
					})
				end,
				desc = "FP from grep",
			},
			{
				"<leader>fp",
				function()
					Snacks.picker.projects()
				end,
				desc = "Projects",
			},
			{
				"<leader>fr",
				function()
					Snacks.picker.recent()
				end,
				desc = "Recent",
			},
			-- git
			{
				"<leader>gb",
				function()
					Snacks.picker.git_branches()
				end,
				desc = "Git Branches",
			},
			{
				"<leader>gl",
				function()
					Snacks.picker.git_log()
				end,
				desc = "Git Log",
			},
			{
				"<leader>gL",
				function()
					Snacks.picker.git_log_line()
				end,
				desc = "Git Log Line",
			},
			{
				"<leader>gs",
				function()
					Snacks.picker.git_status()
				end,
				desc = "Git Status",
			},
			{
				"<leader>gS",
				function()
					Snacks.picker.git_stash()
				end,
				desc = "Git Stash",
			},
			{
				"<leader>gd",
				function()
					Snacks.picker.git_diff()
				end,
				desc = "Git Diff (Hunks)",
			},
			{
				"<leader>gf",
				function()
					Snacks.picker.git_log_file()
				end,
				desc = "Git Log File",
			},
			-- Grep
			{
				"<leader>sb",
				function()
					Snacks.picker.lines()
				end,
				desc = "Buffer Lines",
			},
			{
				"<leader>sB",
				function()
					Snacks.picker.grep_buffers()
				end,
				desc = "Grep Open Buffers",
			},
			{
				"<leader>sg",
				function()
					Snacks.picker.grep()
				end,
				desc = "Grep",
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
				"<leader>s/",
				function()
					Snacks.picker.search_history()
				end,
				desc = "Search History",
			},
			{
				"<leader>sa",
				function()
					Snacks.picker.autocmds()
				end,
				desc = "Autocmds",
			},
			{
				"<leader>sb",
				function()
					Snacks.picker.lines()
				end,
				desc = "Buffer Lines",
			},
			{
				"<leader>sc",
				function()
					Snacks.picker.command_history()
				end,
				desc = "Command History",
			},
			{
				"<leader>sC",
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
				"<leader>sD",
				function()
					Snacks.picker.diagnostics_buffer()
				end,
				desc = "Buffer Diagnostics",
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
				"<leader>si",
				function()
					Snacks.picker.icons()
				end,
				desc = "Icons",
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
				"<leader>sm",
				function()
					Snacks.picker.marks()
				end,
				desc = "Marks",
			},
			{
				"<leader>sM",
				function()
					Snacks.picker.man()
				end,
				desc = "Man Pages",
			},
			{
				"<leader>sp",
				function()
					Snacks.picker.lazy()
				end,
				desc = "Search for Plugin Spec",
			},
			{
				"<leader>sq",
				function()
					Snacks.picker.qflist()
				end,
				desc = "Quickfix List",
			},
			{
				"<leader>sR",
				function()
					Snacks.picker.resume()
				end,
				desc = "Resume",
			},
			{
				"<leader>su",
				function()
					Snacks.picker.undo()
				end,
				desc = "Undo History",
			},
			{
				"<leader>uC",
				function()
					Snacks.picker.colorschemes()
				end,
				desc = "Colorschemes",
			},
			-- LSP
			{
				"gd",
				function()
					Snacks.picker.lsp_definitions()
				end,
				desc = "Goto Definition",
			},
			{
				"gD",
				function()
					Snacks.picker.lsp_declarations()
				end,
				desc = "Goto Declaration",
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
				"gI",
				function()
					Snacks.picker.lsp_implementations()
				end,
				desc = "Goto Implementation",
			},
			{
				"gy",
				function()
					Snacks.picker.lsp_type_definitions()
				end,
				desc = "Goto T[y]pe Definition",
			},
			{
				"<leader>ss",
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
			-- {
			-- 	"<C-g>",
			-- 	function()
			-- 		Snacks.lazygit()
			-- 	end,
			-- 	desc = "LSP Workspace Symbols",
			-- },
		},

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
					{ icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
					{
						icon = " ",
						title = "Recent Files (cwd)",
						section = "recent_files",
						cwd = true,
						indent = 2,
						padding = 1,
					},
					{ icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
					{ section = "keys", gap = 1 },
					{ section = "startup" },
				},
				animaget = { duration = { total = 250 } },
			},
			dim = { enabled = false },
			explorer = { enabled = false },
			image = { enabled = true },
			indent = {
				enabled = true,
				chunk = { enabled = true },
			},
			input = { enabled = true },
			picker = {
				enabled = true,
				formatters = {
					file = {
						filename_first = true,
						truncate = 120,
					},
				},
				ui_select = true,
				---@class snacks.picker.previewers.Config
				previewers = {
					diff = {
						builtin = false, -- use Neovim for previewing diffs (true) or use an external tool (false)
						cmd = { "delta" }, -- example to show a diff with delta
					},
					git = {
						builtin = false, -- use Neovim for previewing git output (true) or use git (false)
						args = { "-c", "diff.external=difft" }, -- additional arguments passed to the git command. Useful to set pager options using `-c ...`
					},
					file = {
						max_size = 1024 * 1024, -- 1MB
						max_line_length = 500, -- max line length
						ft = nil, ---@type string? filetype for highlighting. Use `nil` for auto detect
					},
					-- man_pager = nil, ---@type string? MANPAGER env to use for `man` preview
				},
				---@diagnostic disable-next-line: missing-fields
				icons = {
					-- diagnostics = Settings.icons.diagnostics,
				},
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
				layout = {
					-- reverse = true,
					preset = "default",
				},
				sources = {
					files_with_symbols = {
						multi = { "files", "lsp_symbols" },
						filter = {
							---@param p snacks.Picker
							---@param filter snacks.picker.Filter
							transform = function(p, filter)
								local symbol_pattern = filter.pattern:match("^.-@(.*)$")
								local line_nr_pattern = filter.pattern:match("^.-:(%d*)$")
								local search_pattern = filter.pattern:match("^.-#(.*)$")
								local pattern = symbol_pattern or line_nr_pattern or search_pattern

								if pattern then
									local item = p:current()
									if item and item.file then
										filter.meta.buf = vim.fn.bufadd(item.file)
									end
								end

								if not filter.meta.buf then
									filter.source_id = 1
									return
								end

								if symbol_pattern then
									filter.pattern = symbol_pattern
									filter.current_buf = filter.meta.buf
									filter.source_id = 2
									return
								end

								if line_nr_pattern then
									filter.pattern = filter.pattern:gsub(":%d*$", "")
									filter.current_buf = filter.meta.buf
									filter.source_id = 1
									local item = p:current()
									if item then
										item.pos = { tonumber(line_nr_pattern) or 1, 0 }
										p.preview:loc()
									end
									return
								end

								if search_pattern then
									filter.pattern = filter.pattern:gsub("#.*$", "")
									filter.current_buf = filter.meta.buf
									filter.source_id = 1
									if search_pattern == "" then
										return
									end
									local item = p:current()
									vim.api.nvim_buf_call(p.preview.win.buf, function()
										vim.api.nvim_win_set_cursor(0, { 1, 0 })
										local search = vim.fn.search(search_pattern, "ncW")
										if search > 0 then
											vim.cmd("/" .. search_pattern)
											if vim.fn.line("w$") < search then
												vim.api.nvim_win_set_cursor(0, { math.max(1, search - 8), 0 })
											end
											item.pos = { search, 0 }
										end
									end)
									return
								end

								filter.source_id = 1
							end,
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
