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

local bufSettingsGrp = augroup("Settings", { clear = true })

-- Check for updates
autocmd("CursorHold", {
	pattern = "*",
	command = "checktime",
	group = bufSettingsGrp,
})

-- Settings for filetypes:
--------------------------

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
		"sbt",
		"scala",
		"templ",
		"typescript",
	},
	callback = function()
		vim.defer_fn(function()
			local lspconfig = require("lspconfig")
			local root_patterns = { ".git" }
			local root_dir = lspconfig.util.root_pattern(unpack(root_patterns))(vim.fn.expand("%:p"))

			if not root_dir then
				require("neo-tree.command").execute({ action = "show" })
			else
				require("neo-tree.command").execute({ action = "show", dir = root_dir })
			end
			vim.cmd("Outline")
		end, 2000)
	end,
})
