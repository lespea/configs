return {
  'ntpeters/vim-better-whitespace',
  init = function()
    local g = vim.g
    g.strip_whitespace_on_save = 1
    g.strip_whitelines_at_eof = 0
    g.strip_whitespace_confirm = 0
    g.strip_max_file_size = 1000
    g.show_spaces_that_precede_tabs = 1
  end
}
