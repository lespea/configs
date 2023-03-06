return {
  'edolphin-ydf/goimpl.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-lua/popup.nvim',
    'nvim-telescope/telescope.nvim',
    'nvim-treesitter/nvim-treesitter',
    'fatih/vim-go',
  },
  config = function()
    local set = vim.keymap.set
    require('telescope').load_extension('goimpl')
    set('n', '<leader>im', require('telescope').extensions.goimpl.goimpl)
  end,
}
