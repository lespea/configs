return {
  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    dependencies = {
      { 'williamboman/mason.nvim' },
      { 'williamboman/mason-lspconfig.nvim' },
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
        'pyright',
        'ruff',
        'ruff-lsp',
        'rust-analyzer',
        'staticcheck',
        'stylua',
        'typescript-language-server',
      },
      auto_update = true,
      debounce_hours = 5,
    }
  },
  {
    'ray-x/lsp_signature.nvim',
    event = "VeryLazy",
    opts = {},
    config = function(_, opts) require 'lsp_signature'.setup(opts) end
  },
  {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v2.x',
    dependencies = {
      -- LSP Support
      'lvimuser/lsp-inlayhints.nvim',
      'neovim/nvim-lspconfig',
      'williamboman/mason-lspconfig.nvim',
      'williamboman/mason.nvim',

      -- Autocompletion
      'L3MON4D3/LuaSnip',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
      'hrsh7th/nvim-cmp',
      'rafamadriz/friendly-snippets',
      'saadparwaiz1/cmp_luasnip',
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

      local ih = require('lsp-inlayhints')
      ih.setup()

      lsp.on_attach(function(client, bufnr)
        lsp.default_keymaps({ buffer = bufnr })
        lsp.buffer_autoformat()

        vim.keymap.set({ 'n', 'x' }, 'gf', function()
          vim.lsp.buf.format({ async = false, timeout_ms = 10000 })
        end)
      end)

      -- (Optional) Configure lua language server for neovim
      require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls({
        on_attach = function(client, bufnr)
          ih.on_attach(client, bufnr)
        end,
        settings = {
          Lua = {
            hint = {
              enable = true,
            },
          },
        },
      }))

      lsp.setup()

      local cmp = require('cmp')
      local cmp_action = require('lsp-zero').cmp_action()

      cmp.setup({
        mapping = cmp.mapping.preset.insert({
          ['<CR>'] = cmp.mapping.confirm({ select = false }),
          ['<Tab>'] = cmp_action.luasnip_supertab(),
          ['<S-Tab>'] = cmp_action.luasnip_shift_supertab(),
        }),
        preselect = 'item',
        completion = {
          completeopt = 'menu,menuone,noinsert'
        },
        snippet = {
          expand = function(args)
            require('luasnip').lsp_expand(args.body)
          end,
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        }
      })

      cmp.setup.filetype("DressingInput", {
        sources = cmp.config.sources { { name = "omni" } },
      })

      require("luasnip.loaders.from_vscode").lazy_load()
    end,
  },
}
