return {
  'akinsho/toggleterm.nvim',
  opts = {
    shell = 'fish',
    autochdir = true,
  },
  init = function()
    local term = require('toggleterm.terminal').Terminal

    local lazygit = term:new({ cmd = 'lazygit', hidden = true, direction = 'float' })
    local termFloat = term:new({ cmd = 'fish', hidden = true, direction = 'float' })

    local set = vim.keymap.set

    set({ 'n', 't' }, '~', function() termFloat:toggle() end)
    set({ 'n', 't' }, '<C-g>', function() lazygit:toggle() end)
  end
}
