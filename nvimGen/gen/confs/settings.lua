local g, o, opt = vim.g, vim.o, vim.opt
opt.cursorline = true
opt.termguicolors = true
opt.title = true
g.mapleader = ","
g.maplocalleader = "\\"
o.completeopt = "menuone,preview,noselect"
o.startofline = true
o.timeout = true
o.ttimeout = true
o.ttimeoutlen = 100
o.showmatch = true
o.scrolloff = 3
o.synmaxcol = 300
o.laststatus = 2
o.foldenable = false
o.foldlevel = 4
o.foldmethod = "syntax"
o.wrap = false
o.showbreak = "↴"
o.number = true
o.numberwidth = 3
o.signcolumn = "yes"
o.modelines = 0
o.showcmd = true
o.incsearch = true
o.ignorecase = true
o.smartcase = true
o.matchtime = 2
o.mps = o.mps .. ",<:>"
o.autoindent = true
o.smartindent = true
o.tabstop = 4
o.shiftwidth = 4
o.shiftround = true
o.formatoptions = "qnj1"
o.expandtab = true
o.backup = true
o.writebackup = false
o.swapfile = false
o.wildmenu = true
o.wildignore = table.concat({
	"*.jpg,*.png,*.gif",
	".svn,CVS,.git,.hg",
	"*.doc,*.docx,*.xls,*.xlsx,*.pdf,*",
	"*.o,*.a,*.class,*.mo,*.la,*.so,*.obj,*.aux,*.out,*.toc,*.exe,*.bak,*.pyc,*.class",
	"*.xpm,*.db,*.sqlite,*.sqlite3",
	"*.swp,.DS_Store,*~,*.sw",
	"deps,.viminfo"
}, ",")
local pyenv_home = os.getenv("PYENV_ROOT")
if (pyenv_home ~= nil) ~= "" then
	vim.g.python3_host_prog = tostring(pyenv_home) .. "/versions/nvim3/bin/python"
end
g.python_host_prog = ""
g.loaded_python_provider = 0
return true
