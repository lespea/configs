return {
	{
		"nvim-telescope/telescope.nvim",
		enabled = false,
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope-fzf-native.nvim",
			"fdschmidt93/telescope-egrepify.nvim",
			{
				"isak102/telescope-git-file-history.nvim",
				dependencies = { "tpope/vim-fugitive" },
			},
		},
		config = function()
			local ts = require("telescope")
			local builtin = require("telescope.builtin")
			local opts = {}

			vim.keymap.set("n", "<leader>fb", builtin.buffers, opts)
			vim.keymap.set("n", "<leader>fc", builtin.command_history, opts)
			vim.keymap.set("n", "<leader>fd", builtin.diagnostics, opts)
			vim.keymap.set("n", "<leader>ff", builtin.find_files, opts)
			vim.keymap.set("n", "<leader>fh", builtin.help_tags, opts)
			vim.keymap.set("n", "<leader>fo", builtin.oldfiles, opts)
			vim.keymap.set("n", "<leader>fq", builtin.quickfix, opts)
			vim.keymap.set("n", "<leader>fr", builtin.lsp_references, opts)
			vim.keymap.set("n", "<leader>ft", function()
				builtin.treesitter({ jump_type = "never" })
			end, opts)
			vim.keymap.set("n", "<leader>fn", function()
				ts.extensions.notify.notify({})
			end, opts)

			local previewers = require("telescope.previewers")
			local themes = require("telescope.themes")

			local delta = previewers.new_termopen_previewer({
				get_command = function(entry)
					if entry.status == "??" or "A " then
						return { "git", "dt", entry.value }
					end

					return { "git", "dt", entry.value .. "^!" }
				end,
			})

			vim.keymap.set("n", "<leader>fz", function()
				builtin.git_status({
					previewer = delta,
					layout_strategy = "horizontal",
				})
			end, opts)

			local t = require("telescope")
			t.setup({
				extensions = {
					fzf = {
						fuzzy = true, -- false will only do exact matching
						override_generic_sorter = true, -- override the generic sorter
						override_file_sorter = true, -- override the file sorter
						case_mode = "smart_case", -- or "ignore_case" or "respect_case"
					},
				},

				pickers = {
					find_files = {
						hidden = true,
						no_ignore = false,
					},
				},
				defaults = {
					mappings = {
						i = {
							["<C-h>"] = "which_key",
						},
					},
				},
			})

			if vim.fn.has("win32") == 1 then
				t.load_extension("egrepify", "git_file_history")
			else
				t.load_extension("egrepify")
				local fh = t.extensions.git_file_history
				vim.keymap.set("n", "<leader>fi", fh.git_file_history, opts)
			end

			local eg = t.extensions.egrepify
			vim.keymap.set("n", "<leader>fg", eg.egrepify, opts)
		end,
	},
	{
		enabled = false,
		"nvim-telescope/telescope-fzf-native.nvim",
		build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release",
	},
}
