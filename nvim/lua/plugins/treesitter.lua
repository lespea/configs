return {
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    -- commit = '97997c928bb038457f49343ffa5304d931545584',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-refactor',
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    config = function()
      require 'nvim-treesitter.configs'.setup {
        ensure_installed      = {
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
          'latex',
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

        auto_install          = true,

        highlight             = { enable = true },
        indent                = { enable = true },

        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "gnn", -- set to `false` to disable one of the mappings
            node_incremental = "grn",
            scope_incremental = "grc",
            node_decremental = "grm",
          },
        },

        refactor              = {
          highlight_definitions = {
            enable = true,
            -- Set to false if you have an `updatetime` of ~100.
            clear_on_cursor_move = true,
          },
          highlight_current_scope = { enable = false },
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

        textobjects           = {
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
              ["ay"] = "@block.outer",
              ["iy"] = "@block.inner",
              ["aa"] = "@assignment.outer",
              ["asl"] = "@assignment.lhs",
              ["asr"] = "@assignment.rhs",
            },
          },
          swap = {
            enable = true,
            swap_next = {
              ["<leader>pn"] = "@parameter.inner",
            },
            swap_previous = {
              ["<leader>pp"] = "@parameter.inner",
            },
          }
        },
      }
    end,
  },
  {
    -- 'lespea/tree-sitter-just',
    'IndianBoy42/tree-sitter-just',
    enabled = false,
    opts = {},
    lazy = false,
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
    },
  },
  {
    'Wansmer/treesj',
    -- Default keymap is space-m to toggle arguments in a single line or to make multi line (chop down)
    opts = {},
    lazy = false,
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
    },
  },
  {
    "chrisgrieser/nvim-various-textobjs",
    config = function()
      require("various-textobjs").setup {
        useDefaultKeymaps = false
      }
    end,
  },
  -- {
  --   'HiPhish/nvim-ts-rainbow2',
  --   config = function()
  --     require("nvim-treesitter.configs").setup {
  --       rainbow = {
  --         enable = true,
  --         query = 'rainbow-parens',
  --         strategy = require 'ts-rainbow.strategy.global',
  --       }
  --     }
  --   end
  -- }
}
