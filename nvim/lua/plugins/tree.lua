return {
  'kyazdani42/nvim-tree.lua',
  dependencies = { 'kyazdani42/nvim-web-devicons' },
  opts = { hijack_directories = { enable = false } },
  keys = {
    {'<leader>tt', '<CMD>NvimTreeToggle<CR>'},
    {'<leader>tr', '<CMD>NvimTreeRefresh<CR>'},
  },
}
