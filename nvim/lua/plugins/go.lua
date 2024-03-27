return {
  {
    -- 'fatih/vim-go',
    'ray-x/go.nvim',
    dependencies = { -- optional packages
      "ray-x/guihua.lua",
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
      'folke/trouble.nvim',
      'L3MON4D3/LuaSnip',
    },
    config = function()
      require("go").setup({
        dap_debug = false,
        dap_debug_keymap = false,

        lsp_codelens = false,
        lsp_keymaps = false,

        luasnip = true,
        trouble = true,

        lsp_inlay_hints = {
          enable = true,
        },

        lsp_cfg = true

        -- lsp_cfg = {
        --   settings = {
        --     gopls = {
        --       analyses = {
        --         ST1003 = false,
        --       },
        --     },
        --   },
        -- },
      })
    end,
    event = { "CmdlineEnter" },
    ft = { "go", 'gomod' },
    -- build = ':lua require("go.install").update_all_sync()' -- if you need to install/update all binaries
  },
  {
    'edolphin-ydf/goimpl.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-lua/popup.nvim',
      'nvim-telescope/telescope.nvim',
      'nvim-treesitter/nvim-treesitter',
    },
    config = function()
      local t = require('telescope')
      t.load_extension('goimpl')
      vim.keymap.set('n', '<leader>im', function() t.extensions.goimpl.goimpl() end)
    end,
    ft = { "go", 'gomod' },
  }
}
