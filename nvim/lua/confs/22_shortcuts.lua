local set = vim.keymap.set

local optRS = {
  silent = true,
}

local optES = {
  noremap = false,
  expr    = true,
  silent  = true,
}

local optR = {}

set('n', 'Q', 'gqap', optRS)

-- Cleanup
set('n', '<F9>', ':StripWhitespace<CR>', optR)
set('n', '<F10>', ':set expandtab<CR>:retab<CR>', optR)

-- Buffs / Tabs
set('n', '<A-l>', ':tabnext<CR>', optRS)
set('n', '<A-h>', ':tabprevious<CR>', optRS)
set('n', '<C-t>', ':tabnew<CR>', optRS)

-- Windows

set('n', '<C-n>', 'h', optRS)
set('n', '<C-j>', 'j', optRS)
set('n', '<C-k>', 'k', optRS)
set('n', '<C-m>', 'l', optRS)
set('n', '<C-p>', '', optRS)


-- Copy/Paste
set('n', '<C-S-V>', '"+p', optR)
set('v', '<C-S-C>', '"+y', optR)
set('v', '<leader>cc', '"+y', optR)
set({ 'i', 'n', 'v' }, '<leader>cp', '"+p', optR)


-- Misc
set('v', ',u', ':Sort u<CR>', optRS)
set('n', ',u', 'vib:Sort u<CR>', optRS)
set('n', ',U', 'viB:Sort u<CR>', optRS)
set('n', '\\u', ':sort u<CR>:g/^$/d<CR>', optRS)
set('n', 'cd', ':cd %:p:h<CR>', optR)

-- Easy quit all
set('n', '\\qa', ":qa!<CR>", optRS)


-- Deal with wrapped lines
set('n', 'k', "v:count == 0 ? 'gk' : 'k'", optES)
set('n', 'j', "v:count == 0 ? 'gj' : 'j'", optES)


-- resize up and down
set('n', ';k', ':resize +3 <CR>', optRS)
set('n', ';j', ':resize -3 <CR>', optRS)


-- resize right and left
set('n', ';l', ':vertical resize +3 <CR>', optRS)
set('n', ';h', ':vertical resize -3 <CR>', optRS)


--[[
      easier moving of code blocks
      Try to go into visual mode (v), thenselect several lines of code
      here and then press ``>`` several times.
--]]
set('v', '<', '<gv', optRS)
set('v', '>', '>gv', optRS)

set("x", "p", function() return 'pgv"' .. vim.v.register .. "y" end, { remap = false, expr = true })


return true
