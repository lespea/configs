---@param bufnr integer
---@param ... string
---@return string
local function first(bufnr, ...)
	local conform = require("conform")
	for i = 1, select("#", ...) do
		local formatter = select(i, ...)
		if conform.get_formatter_info(formatter, bufnr).available then
			return formatter
		end
	end
	return select(1, ...)
end

local pr = { "prettier", stop_after_first = true }

return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	keys = {
		{
			-- Customize or remove this keymap to your liking
			"gf",
			function()
				require("conform").format({ async = true })
			end,
			mode = "",
			desc = "Format buffer",
		},
	},
	-- This will provide type hinting with LuaLS
	---@module "conform"
	---@type conform.setupOpts
	opts = {
		-- Define your formatters
		formatters_by_ft = {
			-- simple
			-- json = { "jq" },
			-- toml = { "taplo" },
			-- scala = { "fallback" },
			fish = { "fish_indent" },
			lua = { "stylua" },
			python = { "isort", "black" },
			rust = { "rustfmt" },
			sh = { "shfmt" },
			templ = { "templ" },
			-- prettier
			javascript = pr,
			javascriptreact = pr,
			typescript = pr,
			typescriptreact = pr,
			vue = pr,
			css = pr,
			scss = pr,
			less = pr,
			html = pr,
			json = pr,
			jsonc = pr,
			yaml = pr,
			handlebars = pr,
			-- custom
			go = function(bufnr)
				-- return { first(bufnr, "gotgtfmt", "gofumpt", "gofmt"), "golines" }
				return { first(bufnr, "gotgtfmt", "gofumpt", "gofmt") }
			end,
			-- all
			-- ["*"] = { "codespell" },
		},
		-- Set default options
		default_format_opts = {
			lsp_format = "fallback",
		},
		-- Set up format-on-save
		format_after_save = {
			async = true,
			lsp_format = "fallback",
			timeout_ms = 5000,
		},
		formatters = {
			gotgtfmt = {
				command = "gotgtfmt",
				args = { "-" },
				stdin = true,
			},
		},
	},
	init = function()
		-- If you want the formatexpr, here is the place to set it
		vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
		local c = require("conform")
		c.formatters.golines = {
			append_args = { "-m", "120", "--base-formatter", "gofmt" },
		}
		c.formatters.prettier = {
			append_args = { "--print-width", "120" },
			options = {
				ft_parsers = {
					javascript = "babel",
					javascriptreact = "babel",
					typescript = "typescript",
					typescriptreact = "typescript",
					vue = "vue",
					css = "css",
					scss = "scss",
					less = "less",
					html = "html",
					json = "json",
					jsonc = "json",
					yaml = "yaml",
					markdown = "markdown",
					["markdown.mdx"] = "mdx",
					graphql = "graphql",
					handlebars = "glimmer",
				},
			},
		}
	end,
}
