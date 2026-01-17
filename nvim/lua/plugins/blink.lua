return {
	{
		"onsails/lspkind.nvim",
		opts = {},
		enabled = false,
	},
	{
		"xzbdmw/colorful-menu.nvim",
		config = function()
			-- You don't need to set these options.
			require("colorful-menu").setup({})
		end,
	},
	{
		"saghen/blink.cmp",
		-- optional: provides snippets for the snippet source
		dependencies = {
			"L3MON4D3/LuaSnip",
			"folke/lazydev.nvim",
			"nvim-tree/nvim-web-devicons",
			"rafamadriz/friendly-snippets",
			"xzbdmw/colorful-menu.nvim",
		},

		-- use a release tag to download pre-built binaries
		version = "1.*",
		-- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
		-- build = 'cargo build --release',
		-- If you use nix, you can build from source using latest nightly rust with:
		-- build = 'nix run .#build-plugin',

		config = function(_, opts)
			local blink = require("blink.cmp")
			local ls = require("luasnip")
			local sc = require("luasnip.extras.select_choice")

			opts.keymap = {
				preset = "super-tab",
				["<CR>"] = { "accept", "fallback" },
				-- ["<CR>"] = { "fallback" },
				["<C-f>"] = { "scroll_documentation_up", "fallback" },
				["<C-d>"] = { "scroll_documentation_down", "fallback" },
				["<C-l>"] = { "fallback_to_mappings" },
				["<C-h>"] = { "fallback_to_mappings" },
				["<C-j>"] = { "fallback_to_mappings" },
				["<C-k>"] = { "show_signature", "hide_signature", "fallback_to_mappings" },
				["<C-space>"] = false,
			}

			blink.setup(opts)

			vim.keymap.set({ "i", "s" }, "<C-l>", function()
				if ls.expand_or_jumpable() then
					ls.expand_or_jump()
				end
			end, { desc = "expand snippet or next loc" })

			vim.keymap.set({ "i", "s" }, "<C-h>", function()
				if ls.locally_jumpable(-1) then
					ls.jump(-1)
				end
			end, { desc = "prev snippet loc" })

			vim.keymap.set({ "i", "s" }, "<C-j>", function()
				ls.change_choice(1)
			end, { desc = "next choice" })

			vim.keymap.set({ "i", "s" }, "<C-k>", function()
				ls.change_choice(-1)
			end, { desc = "prev choice" })

			vim.keymap.set(
				{ "i", "s" },
				"<C-o>",
				require("luasnip.extras.select_choice"),
				{ desc = "Select snippet choice" }
			)

			vim.keymap.set({ "i", "s" }, "<c-space>", function()
				if ls.expand_or_jumpable() then
					ls.expand_or_jump()
				end
			end, { silent = true, desc = "expand snippet" })
		end,

		---@module 'blink.cmp'
		---@type blink.cmp.Config
		opts = {
			-- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
			-- 'super-tab' for mappings similar to vscode (tab to accept)
			-- 'enter' for enter to accept
			-- 'none' for no mappings
			--
			-- All presets have the following mappings:
			-- C-space: Open menu or open docs if already open
			-- C-n/C-p or Up/Down: Select next/previous item
			-- C-e: Hide menu
			-- C-k: Toggle signature help (if signature.enabled = true)
			--
			-- See :h blink-cmp-config-keymap for defining your own keymap

			appearance = {
				-- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
				-- Adjusts spacing to ensure icons are aligned
				nerd_font_variant = "mono",
			},

			-- (Default) Only show the documentation popup when manually triggered
			completion = {
				menu = {
					-- behavior = "rounded",
					draw = {
						columns = {
							{ "kind_icon" },
							{ "label", gap = 1 },
						},

						components = {
							kind_icon = {
								text = function(ctx)
									local icon = ctx.kind_icon
									if vim.tbl_contains({ "Path" }, ctx.source_name) then
										local dev_icon, _ = require("nvim-web-devicons").get_icon(ctx.label)
										if dev_icon then
											icon = dev_icon
										end
									else
										-- icon = require("lspkind").symbolic(ctx.kind, {
										--  mode = "symbol",
										-- })
									end

									return icon .. ctx.icon_gap
								end,

								-- Optionally, use the highlight groups from nvim-web-devicons
								-- You can also add the same function for `kind.highlight` if you want to
								-- keep the highlight groups in sync with the icons.
								highlight = function(ctx)
									local hl = ctx.kind_hl
									if vim.tbl_contains({ "Path" }, ctx.source_name) then
										local dev_icon, dev_hl = require("nvim-web-devicons").get_icon(ctx.label)
										if dev_icon then
											hl = dev_hl
										end
									end
									return hl
								end,
							},

							label = {
								text = function(ctx)
									return require("colorful-menu").blink_components_text(ctx)
								end,
								highlight = function(ctx)
									return require("colorful-menu").blink_components_highlight(ctx)
								end,
							},
						},
					},
				},
				documentation = {
					auto_show = false,
					window = {
						border = "rounded",
					},
				},

				ghost_text = { enabled = true },
			},

			signature = {
				window = {
					border = "rounded",
				},
			},

			-- Default list of enabled providers defined so that you can extend it
			-- elsewhere in your config, without redefining it, due to `opts_extend`
			sources = {
				default = { "lazydev", "snippets", "lsp", "path", "buffer", "omni" },
				-- lua = { inherit_defaults = true, "lazydev" },
				providers = {
					lazydev = {
						name = "LazyDev",
						module = "lazydev.integrations.blink",
						-- make lazydev completions top priority (see `:h blink.cmp`)
						score_offset = 100,
					},
				},
			},

			snippets = { preset = "luasnip" },

			-- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
			-- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
			-- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
			--
			-- See the fuzzy documentation for more information
			fuzzy = { implementation = "rust" },
		},
		opts_extend = { "sources.default" },
	},
}
