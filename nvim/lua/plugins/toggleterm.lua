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
      persist_size = true,
    })

    local term = require('toggleterm.terminal').Terminal

    local lazygit = term:new({ cmd = 'lazygit', hidden = true, direction = 'float' })
    local termFloat = term:new({ hidden = true, direction = 'float' })
    local termRight = term:new({ hidden = true, direction = 'vertical' })

    local ui = require("toggleterm.ui")
    local set = vim.keymap.set

    for _, key in ipairs({ '<C-.>', '\\tt' }) do
      set({ 'n', 't' }, key, function() termFloat:toggle() end)
    end

    for _, key in ipairs({ '<C-g>', '\\tg' }) do
      set({ 'n', 't' }, key, function() lazygit:toggle() end)
    end

    set({ 'n', 't' }, '<S-Esc>', '<C-\\><C-n>')

    local save = function()
      vim.api.nvim_command [[update]]
    end

    rightTerm = function()
      if termRight:is_open() then
        if termRight:is_focused() then
          ui:goto_previous()
        else
          save()
          termRight:focus()
        end
      else
        save()
        termRight:toggle()
      end
    end

    set({ 'n' }, '<leader>ct', function()
      termRight:close()
      termRight = term:new({ hidden = true, direction = 'vertical' })
    end)

    -- Persistent right term
    for _, key in ipairs({ '<C-,>', '\\tr' }) do
      set({ 'n', 't' }, key, rightTerm)
    end
  end
}
