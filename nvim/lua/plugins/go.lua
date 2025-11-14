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
				dap_debug_gui = false,
				dap_debug_keymap = false,
				dap_vt = false,

				diagnostic = false,

				luasnip = true,

				lsp_inlay_hints = {
					enable = false,
				},

				-- lsp_cfg = false,

				lsp_codelens = true,
				lsp_keymaps = true,

				lsp_gofumpt = true,

				lsp_cfg = {
					settings = {
						gopls = {
							analyses = {
								-- Annoying
								QF1001 = false, -- Apply De Morgan’s law
								ST1000 = false, -- Incorrect or missing package comment
								ST1003 = false, -- Poorly chosen identifier
								-- Extras
								QF1006 = true, -- Lift if+break into loop condition
								QF1007 = true, -- Merge conditional assignment into variable declaration
								QF1008 = true, -- Omit embedded fields from selector expression
								S1002 = true, -- Omit comparison with boolean constant
								S1005 = true, -- Drop unnecessary use of the blank identifier
								S1008 = true, -- Simplify returning boolean expression
								S1011 = true, -- Use a single append to concatenate two slices
								S1025 = true, -- Don’t use fmt.Sprintf("%s", x) unnecessarily
								S1029 = true, -- Range over the string directly
								SA1002 = true, -- Invalid format in time.Parse
								SA1003 = true, -- Unsupported argument to functions in encoding/binary
								SA1018 = true, -- strings.Replace called with n == 0, which does nothing
								SA1023 = true, -- Modifying the buffer in an io.Writer implementation
								SA1024 = true, -- A string cutset contains duplicate characters
								SA1032 = true, -- Wrong order of arguments to errors.Is
								SA2002 = true, -- Called testing.T.FailNow or SkipNow in a goroutine, which isn’t allowed
								SA2003 = true, -- Deferred Lock right after locking, likely meant to defer Unlock instead
								SA4005 = true, -- Field assignment that will never be observed. Did you mean to use a pointer receiver
								SA4008 = true, -- The variable in the loop condition never changes, are you incrementing the wrong variable
								SA4010 = true, -- The result of append will never be observed anywhere
								SA4031 = true, -- Checking never-nil value against nil
								SA5000 = true, -- Assignment to nil map
								SA5012 = true, -- Passing odd-sized slice to function expecting even size
								SA9001 = true, -- Defers in range loops may not run when you expect them to
								SA9007 = true, -- Deleting a directory that shouldn’t be deleted0
								SA9008 = true, -- else branch of a type assertion is probably not reading the right value
								ST1005 = true, -- Incorrectly formatted error string
								ST1008 = true, -- A function’s error value should be its last return value¶
								ST1011 = true, -- Poorly chosen name for variable of type time.Duration¶
								ST1012 = true, -- Poorly chosen name for error variable¶
								ST1016 = true, -- Use consistent method receiver names
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
