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
augroup("setLineLength", { clear = true })
autocmd("Filetype", {
	group = "setLineLength",
	pattern = { "html", "javascript", "markdown", "text", "typescript", "xhtml" },
	command = "setlocal cc=0",
})

-- Set indentation to 2 spaces
augroup("setIndent", { clear = true })
autocmd("Filetype", {
	group = "setIndent",
	pattern = { "css", "html", "javascript", "lua", "scss", "typescript", "xhtml", "xml", "yaml" },
	command = "setlocal shiftwidth=2 tabstop=2",
})

augroup("setupEdgy", { clear = true })
autocmd("Filetype", {
	group = "setupEdgy",
	once = true,
	pattern = {
		"go",
		"java",
		"javascript",
		"lua",
		"rust",
		"scala",
		"typescript",
	},
	callback = function()
		vim.defer_fn(function()
			local lspconfig = require("lspconfig")
			local root_patterns = { ".git" }
			local root_dir = lspconfig.util.root_pattern(unpack(root_patterns))(vim.fn.expand("%:p"))

			require("neo-tree.command").execute({ action = "show", dir = root_dir })
			vim.cmd("OutlineOpen!")
		end, 2000)
	end,
})
