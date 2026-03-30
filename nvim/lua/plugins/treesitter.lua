local languages = {
	"bash",
	"c",
	"cmake",
	"comment",
	"cpp",
	"css",
	"diff",
	"dockerfile",
	"dot",
	"git_rebase",
	"gitattributes",
	"gitcommit",
	"gitignore",
	"go",
	"gomod",
	"gosum",
	"gotmpl",
	"gowork",
	"html",
	"ini",
	"javascript",
	"json",
	"just",
	"kotlin",
	"latex",
	"lua",
	"make",
	"markdown",
	"meson",
	"ninja",
	"norg",
	"passwd",
	"proto",
	"python",
	"regex",
	"rust",
	"scala",
	"scss",
	"sql",
	"svelte",
	"templ",
	"terraform",
	"toml",
	"tsx",
	"typescript",
	"typst",
	"vim",
	"vue",
	"yaml",
	"zig",
}

return {
	{
		"nvim-treesitter/nvim-treesitter-context",
		config = function()
			require("treesitter-context").setup({
				enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
				multiwindow = false, -- Enable multiwindow support.
				max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
				min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
				line_numbers = true,
				multiline_threshold = 20, -- Maximum number of lines to show for a single context
				trim_scope = "outer", -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
				mode = "cursor", -- Line used to calculate context. Choices: 'cursor', 'topline'
				-- Separator between context and content. Should be a single character string, like '-'.
				-- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
				separator = nil,
				zindex = 20, -- The Z-index of the context window
				on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
			})
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		branch = "main",
		init = function()
			-- Disable entire built-in ftplugin mappings to avoid conflicts.
			-- See https://github.com/neovim/neovim/tree/master/runtime/ftplugin for built-in ftplugins.
			vim.g.no_plugin_maps = true

			-- Or, disable per filetype (add as you like)
			-- vim.g.no_python_maps = true
			-- vim.g.no_ruby_maps = true
			-- vim.g.no_rust_maps = true
			-- vim.g.no_go_maps = true
		end,
		config = function()
			-- put your config here
		end,
	},
	{
		"MeanderingProgrammer/treesitter-modules.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		opts = {
			auto_install = true,
			ensure_installed = languages,
			fold = { enable = false },
			highlight = { enable = true },
			incremental_selection = { enable = true },
			indent = { enable = true },
		},
	},
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		branch = "main",
		dependencies = {
			-- "nvim-treesitter/nvim-treesitter-refactor",
			-- "nvim-treesitter/nvim-treesitter-textobjects",
			-- "nvim-treesitter/nvim-treesitter-context",
			"OXY2DEV/markview.nvim",
		},
		lazy = false,
		config = function()
			local sel = require("nvim-treesitter-textobjects.select")

			-- You can use the capture groups defined in `textobjects.scm`
			vim.keymap.set({ "x", "o" }, "af", function()
				sel.select_textobject("@function.outer", "textobjects")
			end)
			vim.keymap.set({ "x", "o" }, "if", function()
				sel.select_textobject("@function.inner", "textobjects")
			end)
			vim.keymap.set({ "x", "o" }, "ac", function()
				sel.select_textobject("@class.outer", "textobjects")
			end)
			vim.keymap.set({ "x", "o" }, "ic", function()
				sel.select_textobject("@class.inner", "textobjects")
			end)
			vim.keymap.set({ "x", "o" }, "aa", function()
				sel.select_textobject("@parameter.outer", "textobjects")
			end)
			vim.keymap.set({ "x", "o" }, "ia", function()
				sel.select_textobject("@parameter.inner", "textobjects")
			end)

			local swap = require("nvim-treesitter-textobjects.swap")

			vim.keymap.set("n", "<leader>pn", function()
				swap.swap_next("@parameter.inner")
			end)
			vim.keymap.set("n", "<leader>pp", function()
				swap.swap_previous("@parameter.outer")
			end)

			-- refactor = {
			--  highlight_definitions = {
			--    enable = true,
			--    -- Set to false if you have an `updatetime` of ~100.
			--    clear_on_cursor_move = true,
			--  },
			--  highlight_current_scope = { enable = false },
			--  smart_rename = {
			--    enable = true,
			--    keymaps = {
			--      smart_rename = "grr",
			--    },
			--  },
			--  navigation = {
			--    enable = true,
			--    keymaps = {
			--      goto_definition = "gnd",
			--      list_definitions = "gnD",
			--      list_definitions_toc = "gO",
			--      goto_next_usage = "<a-*>",
			--      goto_previous_usage = "<a-#>",
			--    },
			--  },
			-- },
		end,
	},
	{
		"Wansmer/treesj",
		lazy = false,
		keys = { "<leader>m", "<space>m" },
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
		},
		config = function()
			-- Terrible, terrible hack but good enough for now.  I feel dirty.

			local tsj_utils = require("treesj.langs.utils")
			local rust = require("treesj.langs.rust")

			local langs = {
				scala = tsj_utils.merge_preset(rust, {}),
			}

			local tj = require("treesj")

			tj.setup({
				use_default_keymaps = true,
				max_join_length = 240,
				langs = langs,
			})

			vim.keymap.set("n", "<leader>m", tj.toggle, { desc = "Toggle split/join args" })
		end,
	},
	{
		"chrisgrieser/nvim-various-textobjs",
		event = "VeryLazy",
		opts = {
			keymaps = {
				useDefaults = true,
			},
		},
	},
}
