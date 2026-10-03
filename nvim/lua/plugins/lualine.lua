local function cursor_line()
	local total_lines = vim.fn.line("$")
	local line_str = "Line: %s (%d%%%%)"
	local line_num = vim.fn.line(".")
	if total_lines == 1 then
		return line_str:format("Top", 0)
	elseif total_lines == line_num then
		return line_str:format("Bot", 100)
	else
		local line_pct = math.floor(line_num / total_lines * 100)
		return line_str:format(("%d/%d"):format(line_num, total_lines), line_pct)
	end
end

local function cursor_col()
	return ("Col: %d/%d"):format(vim.fn.charcol("."), vim.fn.charcol("$"))
end

local function getLspName()
	local buf_client_names = vim.tbl_map(function(client)
		return client.name
	end, vim.lsp.get_clients({ bufnr = 0 }))
	if #buf_client_names == 0 then
		return "  No servers"
	end

	local lint_s, lint = pcall(require, "lint")
	if lint_s then
		local linters = lint.linters_by_ft[vim.bo.filetype]
		if type(linters) == "string" then
			table.insert(buf_client_names, linters)
		elseif type(linters) == "table" then
			vim.list_extend(buf_client_names, linters)
		end
	end

	local ok, conform = pcall(require, "conform")
	if ok then
		vim.list_extend(buf_client_names, conform.list_formatters_for_buffer())
	end

	return "  " .. table.concat(vim.list.unique(buf_client_names), ", ")
end

local function project_root()
	return "  " .. vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
end

return {
	"nvim-lualine/lualine.nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		"folke/noice.nvim",
		"ThorstenRhau/token",
	},
	event = "VeryLazy",
	config = function()
		local palette = require("token.palettes.meridian")("dark")
		local colors = vim.tbl_extend("force", palette, {
			bg_dark = palette.bg1,
			bg = palette.bg3,
			white = palette.fg0,
			lavender = palette.bright_purple,
			bright_red = palette.red,
		})

		local modecolor = {
			n = colors.bright_green,
			i = colors.lavender,
			v = colors.purple,
			["\22"] = colors.purple,
			V = colors.red,
			c = colors.yellow,
			no = colors.red,
			s = colors.yellow,
			S = colors.yellow,
			["\19"] = colors.yellow,
			ic = colors.yellow,
			R = colors.bright_red,
			Rv = colors.purple,
			cv = colors.red,
			ce = colors.red,
			r = colors.red,
			rm = colors.red,
			["r?"] = colors.cyan,
			["!"] = colors.red,
			t = colors.bright_red,
		}

		-- shared by everything in section a so it all follows the mode
		local function mode_color()
			local m = vim.fn.mode()
			-- mode() can return longer variants (niI, nt, ix, Rc, ...) so fall back to the first char
			local bg = modecolor[m] or modecolor[m:sub(1, 1)] or modecolor.n
			return { bg = bg, fg = colors.bg_dark, gui = "bold" }
		end

		local modes = {
			"mode",
			color = mode_color,
			separator = { left = "", right = "" },
		}

		local hostname = {
			"hostname",
			color = mode_color,
			cond = function()
				return vim.env.SSH_CONNECTION ~= nil
			end,
		}

		local theme = {
			normal = {
				a = { fg = colors.bg_dark, bg = colors.blue },
				b = { fg = colors.blue, bg = colors.bg4 },
				c = { fg = colors.white, bg = colors.bg_dark },
				z = { fg = colors.white, bg = colors.bg_dark },
			},
		}

		-- noice builds status objects dynamically, so spell out the shape for lua_ls
		---@class NoiceStatusEntry
		---@field has fun(): boolean
		---@field get fun(): string?
		local noice_status = require("noice").api.status
		local noice_mode = noice_status.mode --[[@as NoiceStatusEntry]]
		local noice_command = noice_status.command --[[@as NoiceStatusEntry]]

		-- cmdheight=0 hides both of these, so surface them here
		local macro = {
			noice_mode.get,
			cond = noice_mode.has,
			color = { fg = colors.red, bg = colors.bg_dark, gui = "italic,bold" },
		}
		local pending_keys = {
			noice_command.get,
			cond = noice_command.has,
			color = { fg = colors.yellow, bg = colors.bg_dark },
		}

		local lazy_updates = {
			require("lazy.status").updates,
			cond = require("lazy.status").has_updates,
			color = { fg = colors.orange, bg = colors.bg_dark },
		}

		local lsp = {
			getLspName,
			separator = { left = "", right = "" },
			color = { bg = colors.purple, fg = colors.bg, gui = "italic,bold" },
		}

		local codeSpinner = require("lualine.component"):extend()

		local spinner_symbols = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }

		function codeSpinner:init(options)
			codeSpinner.super.init(self, options)
			self.active_requests = 0
			self.spinner_index = 1
			-- lualine only redraws every 1s on its own; drive the animation while a request is running
			self.timer = assert(vim.uv.new_timer())

			vim.api.nvim_create_autocmd("User", {
				pattern = { "CodeCompanionRequestStarted", "CodeCompanionRequestFinished" },
				group = vim.api.nvim_create_augroup("LualineCodeCompanionSpinner", {}),
				callback = function(request)
					if request.match == "CodeCompanionRequestStarted" then
						self.active_requests = self.active_requests + 1
						if not self.timer:is_active() then
							self.timer:start(0, 100, vim.schedule_wrap(require("lualine").refresh))
						end
					else
						self.active_requests = math.max(self.active_requests - 1, 0)
						if self.active_requests == 0 then
							self.timer:stop()
							require("lualine").refresh()
						end
					end
				end,
			})
		end

		function codeSpinner:update_status()
			if self.active_requests > 0 then
				self.spinner_index = (self.spinner_index % #spinner_symbols) + 1
				return spinner_symbols[self.spinner_index]
			end
		end

		require("lualine").setup({
			options = {
				theme = theme,
				ignore_focus = {
					"Outline",
					"codecompanion",
					"neo-tree",
					"qf",
					"toggleterm",
					"trouble",
				},
				globalstatus = true,
			},
			sections = {
				lualine_a = { hostname, modes },
				lualine_b = {
					{ "b:gitsigns_head", icon = "" },
					{
						"diff",
						source = function()
							local gs = vim.b.gitsigns_status_dict
							if gs then
								return { added = gs.added, modified = gs.changed, removed = gs.removed }
							end
						end,
						symbols = { added = " ", modified = " ", removed = " " },
						diff_color = {
							added = { fg = colors.gsign_add },
							modified = { fg = colors.gsign_change },
							removed = { fg = colors.gsign_del },
						},
					},
					"diagnostics",
				},
				lualine_c = { project_root, { "filename", path = 1 } },
				lualine_x = { pending_keys, lazy_updates, "%b/0x%B", "encoding", "filetype" },
				lualine_y = { macro },
				lualine_z = { cursor_line, cursor_col, "selectioncount", codeSpinner, lsp },
			},
			extensions = { "lazy", "man", "mason", "neo-tree", "quickfix", "toggleterm", "trouble" },
		})
	end,
}
