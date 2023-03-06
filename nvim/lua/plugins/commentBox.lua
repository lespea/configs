local set = vim.keymap.set

return {
  'LudoPinelli/comment-box.nvim',
  config = function()
      box = require('comment-box.impl')
      box.setup {
        doc_width = 120,
        box_width = 80,
      }

      nv = {'n', 'v'}

      set(nv,  '<leader>bb', function() box.lbox() end)
      set(nv,  '<leader>bc', function() box.cbox() end)
      set('n', '<leader>bl', function() box.line() end)
  end,
}
