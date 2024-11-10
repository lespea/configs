return {
  'github/copilot.vim',
  cond = vim.env.NO_VIM_AI ~= "1" and vim.env.USE_COPILOT == "1",
  config = function()
    vim.keymap.set('i', '<s-c-i>', 'copilot#Accept("\\<CR>")', {
      expr = true,
      replace_keycodes = false
    })
    vim.g.copilot_no_tab_map = true
  end,
  event = 'BufEnter'
}
