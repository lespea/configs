local function cursor_line()
	local total_lines = vim.fn.line("$")
	if total_lines <= 0 then
		return ""
	end

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
	local line_len = vim.fn.charcol("$")
	if line_len <= 0 then
		return ""
	end

	local col_num = vim.fn.charcol(".")
	local col_pct = math.floor(col_num / line_len * 100)
	return ("Col: %d/%d (%d%%%%)"):format(col_num, line_len, col_pct)
end

local function getLspName()
	local buf_clients = vim.lsp.get_clients()
	local buf_ft = vim.bo.filetype
	if next(buf_clients) == nil then
		return "  No servers"
	end
	local buf_client_names = {}

	for _, client in pairs(buf_clients) do
		if client.name ~= "null-ls" then
			table.insert(buf_client_names, client.name)
		end
	end

	local lint_s, lint = pcall(require, "lint")
	if lint_s then
		for ft_k, ft_v in pairs(lint.linters_by_ft) do
			if type(ft_v) == "table" then
				for _, linter in ipairs(ft_v) do
					if buf_ft == ft_k then
						table.insert(buf_client_names, linter)
					end
				end
			elseif type(ft_v) == "string" then
				if buf_ft == ft_k then
					table.insert(buf_client_names, ft_v)
				end
			end
		end
	end

	local ok, conform = pcall(require, "conform")
	local formatters = table.concat(conform.list_formatters_for_buffer(), " ")
	if ok then
		for formatter in formatters:gmatch("%w+") do
			if formatter then
				table.insert(buf_client_names, formatter)
			end
		end
	end

	local hash = {}
	local unique_client_names = {}

	for _, v in ipairs(buf_client_names) do
		if not hash[v] then
			unique_client_names[#unique_client_names + 1] = v
			hash[v] = true
		end
	end
	local language_servers = table.concat(unique_client_names, ", ")

	return "  " .. language_servers
end

local function project_root()
	local path = vim.fn.getcwd()
	return "  " .. vim.fn.fnamemodify(path, ":t")
end

return {
	"nvim-lualine/lualine.nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		"folke/noice.nvim",
		"ThorstenRhau/token",
	},
	event = { "BufReadPost", "BufNewFile" },
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
			["␖"] = colors.purple,
			V = colors.red,
			c = colors.yellow,
			no = colors.red,
			s = colors.yellow,
			S = colors.yellow,
			["␓"] = colors.yellow,
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

		local modes = {
			"mode",
			color = function()
				local mode_color = modecolor
				return { bg = mode_color[vim.fn.mode()], fg = colors.bg_dark, gui = "bold" }
			end,
			separator = { left = "", right = "" },
		}

		local theme = {
			normal = {
				a = { fg = colors.bg_dark, bg = colors.blue },
				b = { fg = colors.blue, bg = colors.bg4 },
				c = { fg = colors.white, bg = colors.bg_dark },
				z = { fg = colors.white, bg = colors.bg_dark },
			},
			insert = { a = { fg = colors.bg_dark, bg = colors.orange } },
			visual = { a = { fg = colors.bg_dark, bg = colors.green } },
			replace = { a = { fg = colors.bg_dark, bg = colors.red } },
		}

		local macro = {
			require("noice").api.status.mode.get,
			cond = require("noice").api.status.mode.has,
			color = { fg = colors.red, bg = colors.bg_dark, gui = "italic,bold" },
		}

		local lsp = {
			function()
				return getLspName()
			end,
			separator = { left = "", right = "" },
			color = { bg = colors.purple, fg = colors.bg, gui = "italic,bold" },
		}

		local codeSpinner = require("lualine.component"):extend()

		codeSpinner.processing = false
		codeSpinner.spinner_index = 1

		local spinner_symbols = {
			"⠋",
			"⠙",
			"⠹",
			"⠸",
			"⠼",
			"⠴",
			"⠦",
			"⠧",
			"⠇",
			"⠏",
		}
		local spinner_symbols_len = 10

		-- Initializer
		function codeSpinner:init(options)
			codeSpinner.super.init(self, options)

			local group = vim.api.nvim_create_augroup("CodeCompanionHooks", {})

			vim.api.nvim_create_autocmd({ "User" }, {
				pattern = "CodeCompanionRequest*",
				group = group,
				callback = function(request)
					if request.match == "CodeCompanionRequestStarted" then
						self.processing = true
					elseif request.match == "CodeCompanionRequestFinished" then
						self.processing = false
					end
				end,
			})
		end

		-- Function that runs every time statusline is updated
		function codeSpinner:update_status()
			if self.processing then
				self.spinner_index = (self.spinner_index % spinner_symbols_len) + 1
				return spinner_symbols[self.spinner_index]
			else
				return nil
			end
		end

		require("lualine").setup({
			options = {
				icons_enabled = true,
				theme = theme,
				ignore_focus = {
					"Outline",
					"codecompanion",
					"edgy",
					"neo-tree",
					"qf",
					"terminal",
					"TERMINAL",
					"toggleterm",
					"trouble",
				},
				globalstatus = true,
			},
			sections = {
				lualine_a = { "hostname", modes },
				lualine_b = {
					"branch",
					{
						"diff",
						symbols = { added = " ", modified = " ", removed = " " },
						diff_color = {
							added = { fg = colors.gsign_add },
							modified = { fg = colors.gsign_change },
							removed = { fg = colors.gsign_del },
						},
					},
					"diagnostics",
				},
				lualine_c = { project_root, "filename", "lsp_progress" },
				lualine_x = {
					"%b/0x%B",
					"encoding",
					-- { "fileformat", icons_enabled = false },
					"filetype",
				},
				lualine_y = { macro },
				lualine_z = { cursor_line, cursor_col, "selectioncount", codeSpinner, lsp },
				-- lualine_z = { cursor_line, cursor_col, "selectioncount", dia, lsp },
			},
			inactive_sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = { "filename" },
				lualine_x = { "location" },
				lualine_y = {},
				lualine_z = {},
			},
			tabline = {},
			extensions = { "trouble" },
		})
	end,
}
