return {
	{
		'nvim-treesitter/nvim-treesitter',
		build = ':TSUpdate',
		dependencies = {
			'nvim-treesitter/nvim-treesitter-refactor',
			'nvim-treesitter/nvim-treesitter-textobjects',
		},
		config = function()
			require'nvim-treesitter.configs'.setup {
				ensure_installed = {
					'bash',
					'c',
					'cmake',
					'cpp',
					'css',
					'diff',
					'dockerfile',
					'dot',
					'git_rebase',
					'gitattributes',
					'gitcommit',
					'gitignore',
					'go',
					'gomod',
					'gosum',
					'html',
					'ini',
					'javascript',
					'json',
					'kotlin',
					'lua',
					'make',
					'meson',
					'ninja',
					'passwd',
					'proto',
					'python',
					'regex',
					'rust',
					'scala',
					'scss',
					'sql',
					'terraform',
					'toml',
					'tsx',
					'typescript',
					'vim',
					'yaml',
					'zig',
				},

				auto_install = true,

				highlight = {enable = true},
				indent    = {enable = true},

				incremental_selection = {
					enable = true,
					keymaps = {
						init_selection = "gnn", -- set to `false` to disable one of the mappings
						node_incremental = "grn",
						scope_incremental = "grc",
						node_decremental = "grm",
					},
				},

				rainbow = {
					enable = true,
					extended_mode = true,
				},

				refactor = {
					highlight_definitions = {
						enable = true,
						-- Set to false if you have an `updatetime` of ~100.
						clear_on_cursor_move = true,
					},

					highlight_current_scope = { enable = true },

					smart_rename = {
						enable = true,
						keymaps = {
							smart_rename = "grr",
						},
					},

					navigation = {
						enable = true,
						keymaps = {
							goto_definition = "gnd",
							list_definitions = "gnD",
							list_definitions_toc = "gO",
							goto_next_usage = "<a-*>",
							goto_previous_usage = "<a-#>",
						},
					},
				},

				textobjects = {
					select = {
						enable = true,

						-- Automatically jump forward to textobj, similar to targets.vim
						lookahead = true,

						keymaps = {
							-- You can use the capture groups defined in textobjects.scm
							["af"] = "@function.outer",
							["if"] = "@function.inner",
							["ac"] = "@class.outer",
							["ic"] = "@class.inner",
							["ap"] = "@parameter.outer",
							["ip"] = "@parameter.inner",
							["ab"] = "@block.outer",
							["ib"] = "@block.inner",
							["aa"] = "@assignment.outer",
							["asl"] = "@assignment.lhs",
							["asr"] = "@assignment.rhs",
						},
					},
				},
			}

		end,
	},
  {
    'IndianBoy42/tree-sitter-just',
    opts = {},
    lazy = false,
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
    },
  },
  {
    "chrisgrieser/nvim-various-textobjs",
    config = function ()
      require("various-textobjs").setup {
        useDefaultKeymaps = true
      }
    end,
  },
  {
    'HiPhish/nvim-ts-rainbow2',
    config = function ()
      require("nvim-treesitter.configs").setup {
        rainbow = {
          enable = true,
          query = 'rainbow-parens',
          strategy = require 'ts-rainbow.strategy.global',
        }
      }
    end
  }
}
