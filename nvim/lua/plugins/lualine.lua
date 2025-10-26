local function get_buf_count()
	-- local listed_bufs = vim.fn.getbufinfo({'buflisted'})
	-- local loaded_bufs = vim.fn.getbufinfo( 'bufloaded' )

	local listed_bufs = vim.api.nvim_list_bufs()
	local buf_count = 0
	local oil_count = 0

	-- vim.notify(vim.inspect(listed_bufs))
	for i = 1, #listed_bufs do
		local buf = listed_bufs[i]
		local buf_name = vim.api.nvim_buf_get_name(buf)
		-- vim.notify('buf_name: ' .. buf_name)
		-- vim.notify('is loaded: ' .. tostring(vim.api.nvim_buf_is_loaded(v)))

		-- if (buf_name == nil or #buf_name == 0) then
		--     if vim.api.nvim_buf_is_loaded(buf) then
		--         vim.cmd('bd ' .. buf)  -- buffer delete? need to check this
		--     end
		-- elseif string.sub(buf_name, 1, 4) == 'oil:' then
		--     -- print(buf_name)
		--     oil_count = oil_count + 1
		-- else
		--     buf_count = buf_count + 1
		-- end

		if buf_name ~= nil and buf_name:len() > 0 then
			if vim.startswith(buf_name, "oil:") then
				oil_count = oil_count + 1
			else
				buf_count = buf_count + 1
			end
		end
	end

	-- result = 'Buffers: ' .. buf_count
	local result
	if buf_count == 0 and oil_count > 0 then
		result = "Oil Buffers: " .. oil_count
	elseif buf_count > 0 and oil_count == 0 then
		result = "Buffers: " .. buf_count
	elseif buf_count > 0 and oil_count > 0 then
		result = ("Oil Buffers: %d | Buffers: %d"):format(oil_count, buf_count)
	else
		result = nil
	end

	-- print(result)
	return result
	-- print(count)
	-- return count

	-- print(#listed_bufs)
	-- return #listed_bufs
	-- print(dump(loaded_bufs))

	-- local hash = {}
	-- local result = {}
	--
	-- for _,v in ipairs(listed_bufs) do
	--     if (not hash[v]) then
	--         result[#result+1] = v
	--         hash[v] = true
	--     end
	-- end
	--
	-- for _,v in ipairs(loaded_bufs) do
	--     if (not hash[v]) then
	--         result[#result+1] = v
	--         hash[v] = true
	--     end
	-- end
	--
	-- return len(result)
end

local filename = {
	"filename",
	path = 3,
}
local fileformat = {
	"fileformat",
	padding = { left = 1, right = 2 },
}

local custom_fn = vim.custom_fn

local function memory_usage()
	local memory_bytes = vim.uv.resident_set_memory()
	return ("RAM Usage: %s"):format(custom_fn.format_bytes(memory_bytes))
end

local function filesize()
	local size = math.max(vim.fn.line2byte(vim.fn.line("$") + 1) - 1, 0)
	return custom_fn.format_bytes(size)
end

local function cursor_location()
	local total_lines = vim.fn.line("$")
	if total_lines <= 0 then
		return ""
	end

	local line_str = "Line: %s"
	local line_num = vim.fn.line(".")
	if total_lines == 1 then
		line_str = line_str:format("Top")
	elseif total_lines == line_num then
		line_str = line_str:format("Bot")
	else
		local line_pct = math.floor(line_num / total_lines * 100)
		line_str = line_str:format(("%d/%d (%d%%%%)"):format(line_num, total_lines, line_pct))
	end

	local line_len = vim.fn.charcol("$")
	if line_len <= 0 then
		return line_str
	end

	local col_num = vim.fn.charcol(".")
	local col_pct = math.floor(col_num / line_len * 100)
	local col_str = ("Col: %d/%d (%d%%%%)"):format(col_num, line_len, col_pct)

	local ret_str = ("%s | %s"):format(line_str, col_str)
	return ret_str
end

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

local function progress()
	local cur = vim.fn.line(".")
	-- print('cur: '..vim.inspect(cur))
	local total = vim.fn.line("$")
	-- print('total: '..vim.inspect(total))
	if cur == 1 then
		return "Top"
	elseif cur == total then
		return "Bot"
	else
		return string.format("%2d%%%%", math.floor(cur / total * 100))
	end
end

local function location()
	local line = vim.fn.line(".")
	local col = vim.fn.charcol(".")
	return string.format("%3d:%-2d %d %d", line, col, vim.fn.line("$"), vim.fn.charcol("$"))
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

return {
	"nvim-lualine/lualine.nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		"folke/noice.nvim",
	},
	event = { "BufReadPost", "BufNewFile" },
	config = function()
		local colors = require("oldworld.palette")

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
				b = { fg = colors.blue, bg = colors.white },
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

		require("lualine").setup({
			options = {
				icons_enabled = true,
				theme = theme,
			},
			sections = {
				lualine_a = { "hostname", modes },
				lualine_b = { "branch", "diff", "diagnostics" },
				lualine_c = { "filename", "lsp_progress" },
				lualine_x = {
					"%b/0x%B",
					"encoding",
					-- { "fileformat", icons_enabled = false },
					"filetype",
				},
				lualine_y = { macro },
				lualine_z = { cursor_line, cursor_col, "selectioncount", lsp },
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
