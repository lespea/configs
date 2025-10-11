return {
	{
		-- 'fatih/vim-go',
		"ray-x/go.nvim",
		dependencies = { -- optional packages
			"ray-x/guihua.lua",
			"neovim/nvim-lspconfig",
			"nvim-treesitter/nvim-treesitter",
			"folke/trouble.nvim",
			"L3MON4D3/LuaSnip",
		},
		config = function()
			require("go").setup({
				dap_debug = false,
				dap_debug_keymap = false,

				lsp_codelens = false,
				lsp_keymaps = false,

				luasnip = true,
				trouble = true,

				-- lsp_inlay_hints = {
				--   enable = false,
				-- },

				-- lsp_cfg = true

				lsp_cfg = {
					settings = {
						gopls = {
							analyses = {
								ST1003 = false,
								QF1001 = false,
							},
						},
					},
				},
			})
		end,
		event = { "CmdlineEnter" },
		ft = { "go", "gomod" },
		-- build = ':lua require("go.install").update_all_sync()' -- if you need to install/update all binaries
	},
	{
		"fang2hou/go-impl.nvim",
		ft = "go",
		dependencies = {
			"MunifTanjim/nui.nvim",
			"nvim-lua/plenary.nvim",

			-- Choose one of the following fuzzy finder
			"folke/snacks.nvim",
			-- "ibhagwan/fzf-lua",
		},
		opts = {},
		keys = {
			{
				"<leader>Gi",
				function()
					require("go-impl").open()
				end,
				mode = { "n" },
				desc = "Go Impl",
			},
		},
	},
}
