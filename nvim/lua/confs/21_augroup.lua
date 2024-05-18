local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd


-- Global settings
--------------------------
--

-- Highlight on yank
local yankGrp = augroup("YankHighlight", { clear = true })
autocmd("TextYankPost", {
  command = "silent! lua vim.highlight.on_yank{higroup='IncSearch', timeout=500, on_visual=true}",
  group = yankGrp,
})

-- show cursor line only in active window
-- local cursorGrp = augroup("CursorLine", { clear = true })
-- autocmd(
--   { "InsertLeave", "WinEnter" },
--   { pattern = "*", command = "set cursorline", group = cursorGrp }
-- )
-- autocmd(
--   { "InsertEnter", "WinLeave" },
--   { pattern = "*", command = "set nocursorline", group = cursorGrp }
-- )


local bufSettingsGrp = augroup("Settings", { clear = true })

-- Check for updates
autocmd("CursorHold", {
  pattern = "*",
  command = "checktim",
  group = bufSettingsGrp,
})

-- Relative line numbering
autocmd("BufRead", {
  pattern = "*",
  command = "set rnu",
  group = bufSettingsGrp,
})


-- Settings for filetypes:
--------------------------

-- Disable line length marker
augroup('setLineLength', { clear = true })
autocmd('Filetype', {
  group = 'setLineLength',
  pattern = { 'text', 'markdown', 'html', 'xhtml', 'javascript', 'typescript' },
  command = 'setlocal cc=0'
})

-- Set indentation to 2 spaces
augroup('setIndent', { clear = true })
autocmd('Filetype', {
  group = 'setIndent',
  pattern = { 'xml', 'html', 'xhtml', 'css', 'scss', 'javascript', 'typescript',
    'yaml', 'lua'
  },
  command = 'setlocal shiftwidth=2 tabstop=2'
})
