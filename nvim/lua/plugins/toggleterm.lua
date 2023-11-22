return {
  'akinsho/toggleterm.nvim',
  init = function()
    require('toggleterm').setup({
      size = function(term)
        if term.direction == "horizontal" then
          return 15
        elseif term.direction == "vertical" then
          return vim.o.columns * 0.4
        end
      end,

      shell = 'fish'
    })

    local term = require('toggleterm.terminal').Terminal

    local lazygit = term:new({ cmd = 'lazygit', hidden = true, direction = 'float' })
    local termFloat = term:new({ hidden = true, direction = 'float' })
    local termRight = term:new({ hidden = true, direction = 'vertical' })
    local termDown = term:new({ hidden = true, direction = 'horizontal' })

    local ui = require("toggleterm.ui")
    local set = vim.keymap.set

    set({ 'n', 't' }, '<C-.>', function() termFloat:toggle() end)
    set({ 'n', 't' }, '<C-g>', function() lazygit:toggle() end)
    set({ 'n', 't' }, '<S-Esc>', '<C-\\><C-n>')

    -- Persistent right term
    set({ 'n', 't' }, '<C-,>', function()
      if termRight:is_open() then
        if termRight:is_focused() then
          ui:goto_previous()
        else
          termRight:focus()
        end
      else
        termRight:toggle()
      end
    end)
  end
}
