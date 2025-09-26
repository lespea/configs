return {
	"ahmedkhalf/project.nvim",
	dependencies = {
		"nvim-telescope/telescope.nvim",
	},
	config = function()
		require("project_nvim").setup({
			-- Methods of detecting the root directory. **"lsp"** uses the native neovim
			-- lsp, while **"pattern"** uses vim-rooter like glob pattern matching. Here
			-- order matters: if one is not detected, the other is used as fallback. You
			-- can also delete or rearangne the detection methods.
			detection_methods = { "pattern", "lsp" },

			patterns = {
				".git",
				-- "Makefile",
				-- "build.sbt",
				-- "cargo.toml",
				-- "go.mod",
				-- "package.json",
				-- "requirements.txt",
			},
		})

		local tele = require("telescope")
		vim.keymap.set("n", "<leader>fp", function()
			tele.extensions.projects.projects()
		end)
	end,
}
