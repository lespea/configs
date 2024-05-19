return {
  {
    'nvim-telescope/telescope.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope-fzf-native.nvim',
      'fdschmidt93/telescope-egrepify.nvim',
      {
        "isak102/telescope-git-file-history.nvim",
        dependencies = { "tpope/vim-fugitive" }
      }
    },
    config = function()
      local builtin = require('telescope.builtin')
      local opts = {}

      vim.keymap.set('n', '<leader>ff', builtin.find_files, opts)
      -- vim.keymap.set('n', '<leader>fg', builtin.live_grep, opts)
      vim.keymap.set('n', '<leader>fb', builtin.buffers, opts)

      local t = require('telescope')
      t.setup {
        extensions = {
          fzf = {
            fuzzy = true,                   -- false will only do exact matching
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = true,    -- override the file sorter
            case_mode = "smart_case",       -- or "ignore_case" or "respect_case"
          }
        },

        pickers = {
          find_files = {
            hidden = true,
            no_ignore = true
          }
        }
      }

      if vim.fn.has('win32') then
        t.load_extension('egrepify', 'git_file_history')
      else
        t.load_extension('egrepify')
        local fh = t.extensions.git_file_history
        vim.keymap.set('n', '<leader>fh', fh.git_file_history, opts)
      end

      local eg = t.extensions.egrepify
      vim.keymap.set('n', '<leader>fg', eg.egrepify, opts)
    end,
  },
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    build =
    'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build',
  },
}
