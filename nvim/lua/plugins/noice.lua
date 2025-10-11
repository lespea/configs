return {
	{
		"rcarriga/nvim-notify", -- Notification plugin used by noice.
		event = "VeryLazy",
		opts = {
			render = "wrapped-compact",
			stages = "fade_in_slide_out",
			timeout = 3000,
			top_down = false, -- Notifications start at the bottom to stay out of your way.
		},
	},
	{
		"smjonas/inc-rename.nvim",
		opts = {},
	},
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		opts = {
			-- add any options here
		},
		keys = {
			{
				"<F2>",
				function()
					return ":IncRename " .. vim.fn.expand("<cword>")
				end,
				expr = true,
				desc = "Rename item",
			},
		},
		dependencies = {
			-- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
			"MunifTanjim/nui.nvim",
			-- OPTIONAL:
			--   `nvim-notify` is only needed, if you want to use the notification view.
			--   If not available, we use `mini` as the fallback
			-- "rcarriga/nvim-notify",
			-- Maybe needed?
			-- "hrsh7th/nvim-cmp",
			-- Rename
			"smjonas/inc-rename.nvim",
		},
		config = function()
			require("noice").setup({
				lsp = {
					-- override markdown rendering so that **cmp** and other plugins use **Treesitter**
					override = {
						["vim.lsp.util.convert_input_to_markdown_lines"] = true,
						["vim.lsp.util.stylize_markdown"] = true,
						-- ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
					},
				},
				-- you can enable a preset for easier configuration
				presets = {
					bottom_search = true, -- use a classic bottom cmdline for search
					command_palette = true, -- position the cmdline and popupmenu together
					long_message_to_split = true, -- long messages will be sent to a split
					lsp_doc_border = true, -- add a border to hover docs and signature help
					inc_rename = true, -- nice renaming
				},
				routes = {
					{
						filter = {
							event = "msg_show",
							any = {
								{ find = "%d+L, %d+B" },
								{ find = "%d+ lines yanked" },
								{ find = "%d+ fewer line" },
								{ find = "%d+ more line" },
								{ find = "%d+ line" },
								{ find = '".+" %d+l, %d+b' },
								{ find = " #%d+%s+%d+ seconds? ago" },
								{ find = "; after #%d+%s+" },
								{ find = "; before #%d+%s+" },
								{ find = "--No lines in buffer--" },
								{ find = "%d+ substitutions on %d+ line" },
								{ find = "Already at newest change" },
								{ find = "^E486:" },
								{ find = "Hop" },
							},
						},
						view = "mini",
						opts = { replace = true },
					},
					{
						filter = {
							event = "lsp",
							kind = "message",
							any = {
								{ find = "Compiling" },
								{ find = "Compiled" },
								{ find = "Import" },
								{ find = "Indexing" },
								{ find = "Loading Scalafmt" },
								{ find = "Running.*sbt.*bloop" },
							},
							warning = false,
							error = false,
							cond = function(message)
								if message.opts ~= nil then
									local client = vim.tbl_get(message.opts, "title")
									if client ~= nil then
										return string.find(client, "metals")
									end
								end

								return false
							end,
						},
						view = "mini",
						opts = { replace = true },
					},
				},
			})
		end,
	},
}
