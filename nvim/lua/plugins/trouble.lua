return {
  'folke/trouble.nvim',
  opts = {},
  keys = {
    {'<leader>xx', '<CMD>TroubleToggle'},

    {'<leader>xw', '<CMD>TroubleToggle workspace_diagnostics'},
    {'<leader>xd', '<CMD>TroubleToggle document_diagnostics'},
    {'<leader>xq', '<CMD>TroubleToggle quickfix'},
    {'<leader>xl', '<CMD>TroubleToggle loclist'},
  }
}
