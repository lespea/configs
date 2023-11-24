-----------------------------------------------------------
-- General Neovim settings and configuration
-----------------------------------------------------------

local g = vim.g     -- Global variables
local o = vim.o     -- Set options init
local opt = vim.opt -- Set options (global/buffer/windows-scoped)

-----------------------------------------------------------
-- General
-----------------------------------------------------------
-- Setup our leaders
opt.mouse = 'a'                               -- Enable mouse support
-- opt.clipboard = 'unnamedplus'                 -- Copy/paste to system clipboard
opt.swapfile = false                          -- Don't use swapfile
opt.backup = false                            -- No backup files
opt.writebackup = false                       -- No backup files
opt.undofile = false                          -- No undo file

opt.completeopt = 'menuone,noinsert,noselect' -- Autocomplete options

opt.foldenable = false                        -- Disable folding by default
opt.foldlevel = 4                             -- Limit folding to 4 levels
opt.foldmethod = 'syntax'                     -- Use language syntax to generate folds

-- Setup windows shell
if vim.fn.has('win32') ~= 0 then
  local powershell_options = {
    shell = vim.fn.executable "pwsh" == 1 and "pwsh" or "powershell",
    shellcmdflag =
    "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;",
    shellredir = "-RedirectStandardOutput %s -NoNewWindow -Wait",
    shellpipe = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode",
    shellquote = "",
    shellxquote = "",
  }

  for option, value in pairs(powershell_options) do
    vim.opt[option] = value
  end
else
  opt.shell = 'fish'
end

opt.diffopt:append({ 'algorithm:histogram' }) -- Diff algorithm


-----------------------------------------------------------
-- Neovim UI
-----------------------------------------------------------
opt.cursorline     = true -- Highlight current line
opt.number         = true -- Show line number
opt.numberwidth    = 3 -- always reserve 3 spaces for line number
opt.relativenumber = true -- Relative numbering
opt.showcmd        = true -- display command in bottom bar
opt.signcolumn     = 'yes' -- keep 1 column for coc.vim check
opt.title          = true -- Set the window title
opt.termguicolors  = true -- Enable 24-bit RGB colors

opt.showmatch      = true -- show matching brackets
opt.scrolloff      = 3 -- always show 3 rows from edge of the screen
opt.laststatus     = 2 -- always show status line

opt.startofline    = true -- Move cursor to "start" of each line
opt.wrap           = false -- Do not wrap lines even if very long
opt.showbreak      = '↴' -- Character to show when line is broken

opt.wildmenu       = true -- On tab, complete options for system command
opt.splitright     = true -- Vertical split to the right
opt.splitbelow     = true -- Horizontal split to the bottom
opt.ignorecase     = true -- Ignore case letters when search
opt.smartcase      = true -- Ignore lowercase for the whole pattern
opt.incsearch      = true -- Starts searching as soon as typing, without enter needed
opt.gdefault       = true -- Global replace by default
opt.matchtime      = 2 -- Delay before showing matching paren
o.mps              = o.mps .. ',<:>' -- Add angle brackets to matching pairs

opt.list           = true
opt.listchars      = {
  eol = '↴',
  nbsp = '⦸', -- CIRCLED REVERSE SOLIDUS (U+29B8, UTF-8: E2 A6 B8)
  extends = '»', -- RIGHT-POINTING DOUBLE ANGLE QUOTATION MARK (U+00BB, UTF-8: C2 BB)
  precedes = '«', -- LEFT-POINTING DOUBLE ANGLE QUOTATION MARK (U+00AB, UTF-8: C2 AB)
  tab = '▶-', --
  trail = '•', -- BULLET (U+2022, UTF-8: E2 80 A2)
  space = ' ',
}


-----------------------------------------------------------
-- Tabs, indent
-----------------------------------------------------------
opt.expandtab = true   -- Use spaces instead of tabs
opt.shiftwidth = 4     -- Shift 4 spaces when tab
opt.tabstop = 4        -- 1 tab == 4 spaces
opt.smartindent = true -- Autoindent new lines
opt.autoindent = true
opt.shiftround = true
opt.formatoptions =
'qnj1' -- q  - comment formatting; n - numbered lists; j - remove comment when joining lines; 1 - don't break after one-letter word

-----------------------------------------------------------
-- Memory, CPU
-----------------------------------------------------------
opt.hidden = true     -- Enable background buffers
opt.history = 100     -- Remember N lines in history
opt.lazyredraw = true -- Faster scrolling
opt.synmaxcol = 240   -- Max column for syntax highlight
opt.updatetime = 250  -- ms to wait for trigger an event

-- Timeouts
opt.timeout = true
opt.ttimeout = true
opt.ttimeoutlen = 100

-----------------------------------------------------------
-- Startup
-----------------------------------------------------------
-- Disable nvim intro
opt.shortmess:append "sI"

-- -- Disable builtin plugins
local disabled_built_ins = {
  "2html_plugin",
  "getscript",
  "getscriptPlugin",
  --"gzip",
  "logipat",
  --"netrw",
  "netrwPlugin",
  "netrwSettings",
  "netrwFileHandlers",
  "matchit",
  --"tar",
  --"tarPlugin",
  "rrhelper",
  --"spellfile_plugin",
  "vimball",
  "vimballPlugin",
  --"zip",
  --"zipPlugin",
  "tutor",
  "rplugin",
  "synmenu",
  --"optwin",
  "compiler",
  "bugreport",
  "ftplugin",
}

for _, plugin in pairs(disabled_built_ins) do
  g["loaded_" .. plugin] = 1
end

pyenv_home = os.getenv('PYENV_ROOT')
if pyenv_home ~= nil and pyenv_home ~= '' then
  g.python3_host_prog = pyenv_home .. '/versions/nvim3/bin/python'
end

g.loaded_python_provider = 0
g.loaded_ruby_provider = 0
g.loaded_perl_provider = 0

return true
