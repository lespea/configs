return {
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    -- commit = '97997c928bb038457f49343ffa5304d931545584',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-refactor',
      'nvim-treesitter/nvim-treesitter-textobjects',
      'OXY2DEV/markview.nvim',
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
          'gotmpl',
          'html',
          'ini',
          'javascript',
          'json',
          'just',
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
              ["aa"] = "@parameter.outer",
              ["ia"] = "@parameter.inner",
              ["ai"] = "@block.outer",
              ["ii"] = "@block.inner",
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
    'Wansmer/treesj',
    lazy = false,
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
    },
    config = function()
      -- Terrible, terrible hack but good enough for now.  I feel dirty.

      local tsj_utils = require('treesj.langs.utils')
      local rust = require('treesj.langs.rust')

      local langs = {
        scala = tsj_utils.merge_preset(rust, {})
      }

      require('treesj').setup({
        max_join_length = 160,
        langs = langs,
      })
    end,
  },
  {
    "chrisgrieser/nvim-various-textobjs",
    event = "VeryLazy",
    opts = {
      keymaps = {
        useDefaults = true
      }
    },
  },
}
