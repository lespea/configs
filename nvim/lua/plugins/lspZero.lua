return {
  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    dependencies = {
      {'williamboman/mason.nvim'},
      {'williamboman/mason-lspconfig.nvim'},
    },
    opts = {
      ensure_installed = {
        'clang-format',
        'eslint-lsp',
        'eslint_d',
        'flake8',
        'gofumpt',
        'gopls',
        'hadolint',
        'lua-language-server',
        'luacheck',
        'luaformatter',
        'prettier',
        'pyflakes',
        'python-lsp-server',
        'rust-analyzer',
        'rustfmt',
        'staticcheck',
        'stylua',
        'typescript-language-server',
      },

      auto_update = true,
      debounce_hours = 5,
    }
  },
  {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v2.x',
    dependencies = {
      -- LSP Support
      {'neovim/nvim-lspconfig'},             -- Required
      {'williamboman/mason.nvim'},           -- Optional
      {'williamboman/mason-lspconfig.nvim'}, -- Optional

      -- Autocompletion
      {'hrsh7th/nvim-cmp'},     -- Required
      {'hrsh7th/cmp-nvim-lsp'}, -- Required
      {'L3MON4D3/LuaSnip'},     -- Required
    },
    config = function()
      local lsp = require('lsp-zero').preset {
        name = 'recommended',
        manage_nvim_cmp = {
          set_sources = 'recommended',
          set_basic_mappings = true,
          set_extra_mappings = true,
          use_luasnip = true,
          set_format = true,
          documentation_window = true,
        },
      }

      lsp.use('gopls', {
        settings = {
          gopls = {
            gofumpt = true
          },
        }
      })

      lsp.on_attach(function(client, bufnr)
        lsp.default_keymaps({buffer = bufnr})
      end)

      -- (Optional) Configure lua language server for neovim
      require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())

      lsp.setup()
    end,
  },
}
