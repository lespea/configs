return {
	"chrishrb/gx.nvim",
	keys = {
		{ "gx", "<cmd>Browse<cr>", mode = { "n", "x" }, desc = "Open links" },
	},
	cmd = { "Browse" },
	init = function()
		vim.g.netrw_nogx = 1 -- disable netrw gx
	end,
	dependencies = { "nvim-lua/plenary.nvim" }, -- Required for Neovim < 0.10.0
	submodules = false, -- not needed, submodules are required only for tests

	-- you can specify also another config if you want
	config = function()
		require("gx").setup({
			select_prompt = true, -- shows a prompt when multiple handlers match; disable to auto-select the top one

			handlers = {
				go = true, -- open pkg.go.dev from an import statement (uses treesitter)
				plugin = true, -- open plugin links in lua (e.g. packer, lazy, ..)
				github = true, -- open github issues
				brewfile = false, -- open Homebrew formulaes and casks
				package_json = true, -- open dependencies from package.json
				search = false, -- search the web/selection on the web if nothing else is found
			},
			handler_options = {
				search_engine = "google", -- you can select between google, bing, duckduckgo, ecosia and yandex
				select_for_search = false, -- if your cursor is e.g. on a link, the pattern for the link AND for the word will always match. This disables this behaviour for default so that the link is opened without the select option for the word AND link
				git_remotes = { "upstream", "origin" }, -- list of git remotes to search for git issue linking, in priority
			},
		})
	end,
}
