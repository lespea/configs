local set = vim.keymap.set
local opts = { silent = true }

local function add_bind(hop, hint, mode, keys, dir, cur, inc)
  local move_opts = {
    current_line_only = cur,
  }

  if dir == 'a' then
    move_opts['direction'] = hint.HintDirection.AFTER_CURSOR
    if not inc then
      move_opts['hint_offset'] = -1
    end
  elseif dir == 'b' then
    move_opts['direction'] = hint.HintDirection.BEFORE_CURSOR
    if not inc then
      move_opts['hint_offset'] = 1
    end
  elseif dir ~= '' then
    error('Unknown direction: ' .. dir)
  end

  set(mode, keys, function() hop.hint_char1(move_opts) end, opts)
end

return {
  'smoka7/hop.nvim',
  config = function()
    local hop = require('hop')
    hop.setup({})
    local hint = require('hop.hint')

    add_bind(hop, hint, 'n', 'f', 'a', false, true)
    add_bind(hop, hint, 'n', 'F', 'b', false, true)
    add_bind(hop, hint, 'n', 't', 'a', false, false)
    add_bind(hop, hint, 'n', 'T', 'b', false, false)

    add_bind(hop, hint, 'o', 'f', 'a', true, true)
    add_bind(hop, hint, 'o', 'F', 'b', true, true)
    add_bind(hop, hint, 'o', 't', 'a', true, false)
    add_bind(hop, hint, 'o', 'T', 'b', true, false)

    local no = { 'n', 'o' }

    add_bind(hop, hint, no, ',,f', 'a', nil, true)
    add_bind(hop, hint, no, ',,F', 'b', nil, true)
    add_bind(hop, hint, no, ',,t', 'a', nil, false)
    add_bind(hop, hint, no, ',,T', 'b', nil, false)

    set(no, ',,h', function() hop.hint_char2() end, opts)
    set(no, ',l', function() hop.hint_lines_skip_whitespace() end, opts)
  end,
}
