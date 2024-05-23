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
    enabled = false,
    event = "VeryLazy",
    opts = {},
    config = function(_, opts) require 'lsp_signature'.setup(opts) end
  },
  {
    "L3MON4D3/LuaSnip",
    build = "make install_jsregexp"
  },
  {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v2.x',
    dependencies = {
      -- LSP Support
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

      lsp.on_attach(function(client, bufnr)
        lsp.default_keymaps({ buffer = bufnr })
        lsp.buffer_autoformat()

        -- Disable by default since we can turn on when needed
        vim.lsp.inlay_hint.enable(false)

        -- quickly toggle inlay hints
        vim.keymap.set({ 'n', 'x' }, '<C-i>',
          function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end)

        vim.keymap.set({ 'n', 'x' }, 'gf', function()
          vim.lsp.buf.format({ async = false, timeout_ms = 10000 })
        end)
      end)

      lsp.setup()

      local cmp = require('cmp')
      local cmp_action = require('lsp-zero').cmp_action()

      local ls = require('luasnip')

      cmp.setup({
        mapping = cmp.mapping.preset.insert({
          ['<C-Y>'] = cmp.mapping.confirm({ select = true }),
          ['<CR>'] = cmp.mapping.confirm({ select = false }),

          ['<Tab>'] = cmp_action.luasnip_supertab(),
          ['<S-Tab>'] = cmp_action.luasnip_shift_supertab(),

          ["<C-k>"] = cmp.mapping.select_prev_item(),
          ["<C-j>"] = cmp.mapping.select_next_item(),
          ['<C-e>'] = cmp.mapping.abort(),

          ['<C-l>'] = cmp.mapping(function()
            if ls.expand_or_locally_jumpable() then
              ls.expand_or_jump()
            end
          end, { 'i', 's' }),

          ['<C-h>'] = cmp.mapping(function()
            if ls.locally_jumpable(-1) then
              ls.jump(-1)
            end
          end, { 'i', 's' }),
        }),
        preselect = 'item',
        completion = {
          completeopt = 'menu,menuone,noinsert'
        },
        snippet = {
          expand = function(args)
            ls.lsp_expand(args.body)
          end,
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        sources = {
          { name = 'luasnip' },
          { name = 'nvim_lsp' },
          { name = 'path' },
          { name = 'buffer' },
        },
        sorting = {
          comparators = {
            cmp.config.compare.offset,
            cmp.config.compare.exact,
            cmp.config.compare.score,
            cmp.config.compare.recently_used,
            cmp.config.compare.kind,
          },
        },
      })


      local fmt = require("luasnip.extras.fmt").fmt
      local rep = require("luasnip.extras").rep

      -- some shorthands...
      local snip = ls.snippet
      local i = ls.insert_node
      local func = ls.function_node

      local date = function()
        return { os.date "%Y-%m-%d" }
      end


      ls.add_snippets(nil, {
        all = {
          snip({
            trig = "date",
            namr = "Date",
            dscr = "Date in the form of YYYY-MM-DD",
          }, {
            func(date, {}),
          }),
          snip({
            trig = "pwd",
            namr = "PWD",
            dscr = "Path to current working directory",
          }, {
            func(bash, {}, { user_args = { "pwd" } }),
          }),
          snip({
            trig = "filename",
            namr = "Filename",
            dscr = "Absolute path to file",
          }, {
            func(filename, {}),
          }),
        },
        go = {
          snip("dfun", fmt('defer func() {{\n\t{}\n}}(){}', { i(1, ""), i(0), })),
          snip("gfun", fmt('go func() {{\n\t{}\n}}(){}', { i(1, ""), i(0), })),

          snip("nl", fmt('{} := logging.NewLogger("{}", "{}"){}', { i(1, "l"), i(2, "name"), i(3, "path"), i(0) })),
          snip("nlp", fmt('logging.NewLoggerP("{}", "{}"){}.Msg("{}"){}', {
            i(1, "name"),
            i(2, "path"),
            i(3, "other"),
            i(4, "msg"),
            i(0),
          })),

          snip("nle", fmt('logging.NewLoggerP("{}", "{}").Err({}){}.Msg("{}"){}', {
            i(1, "name"),
            i(2, "path"),
            i(3, "err"),
            i(4, "other"),
            i(5, "msg"),
            i(0),
          })),

          snip("fs", fmt('fmt.Sprintf("{}", {}){}', { i(1, "fmt"), i(2, "args"), i(0) })),
          snip("fsl", fmt('fmt.Sprintf("{}\\n", {}){}', { i(1, "fmt"), i(2, "args"), i(0) })),
          snip("ffl", fmt('fmt.Printf("{}\\n", {}){}', { i(1, "fmt"), i(2, "args"), i(0) })),
        },
      })

      vim.keymap.set({ "i", "s" }, "<c-space>", function()
        if ls.expand_or_jumpable() then
          ls.expand_or_jump()
        end
      end, { silent = true })

      cmp.setup.filetype("DressingInput", {
        sources = cmp.config.sources { { name = "omni" } },
      })

      require("luasnip.loaders.from_vscode").lazy_load()
    end,
  },
}
