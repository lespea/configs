return {
  'kyazdani42/nvim-tree.lua',
  dependencies = { 'kyazdani42/nvim-web-devicons' },
  keys = {
    {'<leader>tt', '<CMD>NvimTreeToggle<CR>'},
    {'<leader>tr', '<CMD>NvimTreeRefresh<CR>'},
  },
  opts = {
    hijack_directories = { enable = false },
    sync_root_with_cwd = true,
    respect_buf_cwd = true,
    update_focused_file = {
      enable = true,
      update_root = true,
    },
  },
}
