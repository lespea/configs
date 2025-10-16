-----------------------------------------------------------
-- General Neovim settings and configuration
-----------------------------------------------------------

local g = vim.g -- Global variables
local o = vim.o -- Set options init
local opt = vim.opt -- Set options (global/buffer/windows-scoped)

-----------------------------------------------------------
-- General
-----------------------------------------------------------
-- Setup our leaders
opt.mouse = "a" -- Enable mouse support
-- opt.clipboard = 'unnamedplus'                 -- Copy/paste to system clipboard
opt.swapfile = false -- Don't use swapfile
opt.backup = false -- No backup files
opt.writebackup = false -- No backup files
opt.undofile = false -- No undo file
opt.undolevels = 10000 -- lots of in-memory undo

opt.completeopt = "menuone,noinsert,noselect" -- Autocomplete options

-- Folding settings (using treesitter)
opt.foldenable = false -- Disable folding by default (use 'zi' to toggle)
opt.foldlevel = 99 -- Start with all folds open when folding is enabled
opt.foldmethod = "expr" -- Use expression for folding
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()" -- Modern treesitter folding

-- Setup windows shell
if vim.fn.has("win32") ~= 0 then
	local powershell_options = {
		shell = vim.fn.executable("pwsh") == 1 and "pwsh" or "powershell",
		shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;",
		shellredir = "-RedirectStandardOutput %s -NoNewWindow -Wait",
		shellpipe = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode",
		shellquote = "",
		shellxquote = "",
	}

	for option, value in pairs(powershell_options) do
		vim.opt[option] = value
	end
else
	opt.shell = "fish"
end

opt.diffopt:append({ "linematch:60" }) -- Diff algorithm

-----------------------------------------------------------
-- Neovim UI
-----------------------------------------------------------
opt.cursorline = true -- Highlight current line
opt.number = true -- Show line number
opt.numberwidth = 3 -- always reserve 3 spaces for line number
opt.relativenumber = true -- Relative numbering
opt.showcmd = false -- display command in bottom bar
opt.cmdheight = 0
opt.signcolumn = "yes" -- keep 1 column for coc.vim check
opt.title = true -- Set the window title
opt.termguicolors = true -- Enable 24-bit RGB colors

opt.showmatch = true -- show matching brackets
opt.scrolloff = 3 -- always show 3 rows from edge of the screen
opt.laststatus = 3 -- always show status line

opt.startofline = true -- Move cursor to "start" of each line
opt.wrap = false -- Do not wrap lines even if very long
opt.showbreak = "⮐  " -- Character to show when line is broken

opt.splitright = true -- Vertical split to the right
opt.splitbelow = true -- Horizontal split to the bottom
opt.ignorecase = true -- Ignore case letters when search
opt.smartcase = true -- Ignore lowercase for the whole pattern
opt.incsearch = true -- Starts searching as soon as typing, without enter needed
opt.gdefault = true -- Global replace by default
opt.matchtime = 2 -- Delay before showing matching paren
o.mps = o.mps .. ",<:>" -- Add angle brackets to matching pairs

opt.list = true
opt.listchars = {
	-- eol = '⬎',
	extends = "»", -- RIGHT-POINTING DOUBLE ANGLE QUOTATION MARK (U+00BB, UTF-8: C2 BB)
	nbsp = "⦸", -- CIRCLED REVERSE SOLIDUS (U+29B8, UTF-8: E2 A6 B8)
	precedes = "«", -- LEFT-POINTING DOUBLE ANGLE QUOTATION MARK (U+00AB, UTF-8: C2 AB)
	space = " ",
	tab = "▶ ", --
	trail = "•", -- BULLET (U+2022, UTF-8: E2 80 A2)
}
opt.fillchars = {
	eob = " ",
	fold = " ",
	foldopen = "",
	foldsep = " ",
	foldclose = "",
	diff = " ",
	vert = "│",
}

opt.sessionoptions = {
	"buffers",
	"curdir",
	"skiprtp",
	"tabpages",
	"winsize",
	-- "folds",
	-- "globals",
}

-----------------------------------------------------------
-- Tabs, indent
-----------------------------------------------------------
opt.expandtab = true -- Use spaces instead of tabs
opt.shiftwidth = 4 -- Shift 4 spaces when tab
opt.tabstop = 4 -- 1 tab == 4 spaces
opt.smartindent = true -- Autoindent new lines
opt.autoindent = true
opt.shiftround = true

-- Formatting options:
-- j = Remove comment leader when joining lines
-- c = Auto-wrap comments using 'textwidth'
-- r = Continue comments when pressing Enter in insert mode
-- o = Continue comments when using 'o' or 'O' in normal mode
-- q = Allow formatting of comments with 'gq'
-- l = Don't break lines that are longer than 'textwidth' when inserting
-- n = Recognize numbered lists for formatting
-- t = Auto-wrap text using 'textwidth' (you can remove this if you hate auto-wrap)
--
-- In practice:
-- - Keeps comment blocks neat
-- - Doesn't randomly insert comment prefixes
-- - Plays nice with lists and manual line breaks
-- - Won't auto-wrap code unless 't' is kept
opt.formatoptions = "jcroqlnt"

-----------------------------------------------------------
-- Memory, CPU
-----------------------------------------------------------
opt.history = 100 -- Remember N lines in history
opt.synmaxcol = 500 -- Max column for syntax highlight (increased for modern displays)
opt.updatetime = 250 -- ms to wait for trigger an event

-- opt.lazyredraw = true -- Faster scrolling

-- Timeouts
opt.timeout = true
opt.ttimeout = true
opt.ttimeoutlen = 100

-----------------------------------------------------------
-- Startup
-----------------------------------------------------------
-- Disable nvim intro
opt.shortmess:append("sI")

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

local pyenv_home = os.getenv("nvim_python_loc") or ""
if pyenv_home ~= "" then
	g.python3_host_prog = pyenv_home .. "/bin/python"
else
	g.loaded_python_provider = 0
end

g.loaded_ruby_provider = 0
g.loaded_perl_provider = 0

g.suda_smart_edit = 1

g.picker_engine = "snacks"

return true
