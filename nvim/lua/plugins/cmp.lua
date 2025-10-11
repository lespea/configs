return {
	{
		"L3MON4D3/LuaSnip",
		build = "make install_jsregexp",
	},
	{
		"onsails/lspkind.nvim",
		opts = {},
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
			blink.setup(opts)

			vim.lsp.config("*", { capabilities = blink.get_lsp_capabilities({}, true) })
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
			keymap = {
				preset = "super-tab",
				["<CR>"] = { "accept", "fallback" },
			},

			appearance = {
				-- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
				-- Adjusts spacing to ensure icons are aligned
				nerd_font_variant = "mono",
			},

			-- (Default) Only show the documentation popup when manually triggered
			completion = {
				menu = {
					behavior = "rounded",
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
										icon = require("lspkind").symbolic(ctx.kind, {
											mode = "symbol",
										})
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
				auto_show = true,
				window = {
					border = "rounded",
				},
			},

			-- Default list of enabled providers defined so that you can extend it
			-- elsewhere in your config, without redefining it, due to `opts_extend`
			sources = {
				default = { "lsp", "path", "snippets", "buffer", "omni" },
				lua = { inherit_defaults = true, "lazydev" },
				providers = {
					lazydev = {
						name = "LazyDev",
						module = "lazydev.integrations.blink",
						-- make lazydev completions top priority (see `:h blink.cmp`)
						score_offset = 100,
					},
				},
			},

			-- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
			-- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
			-- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
			--
			-- See the fuzzy documentation for more information
			fuzzy = { implementation = "rust" },
		},
		opts_extend = { "sources.default" },
	},
	{
		"hrsh7th/nvim-cmp",
		enabled = false,
		dependencies = {
			-- Configs
			"folke/lazydev.nvim",
			"xzbdmw/colorful-menu.nvim",
			-- Autocompletion
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-calc",
			"dmitmel/cmp-digraphs",
			-- Snippets
			"L3MON4D3/LuaSnip",
			"rafamadriz/friendly-snippets",
			"saadparwaiz1/cmp_luasnip",
		},
		config = function()
			local default_caps = vim.lsp.protocol.make_client_capabilities()
			local cmp_caps = require("cmp_nvim_lsp").default_capabilities()
			local capabilities = vim.tbl_deep_extend("force", default_caps, cmp_caps)

			vim.lsp.config("*", {
				capabilities = capabilities,
			})

			local cmp = require("cmp")

			local ls = require("luasnip")

			cmp.setup({
				mapping = cmp.mapping.preset.insert({
					["<C-Y>"] = cmp.mapping.confirm({ select = true }),
					-- ["<CR>"] = cmp.mapping.confirm({ select = false }),

					-- ['<Tab>'] = cmp_action.luasnip_supertab(),
					-- ['<S-Tab>'] = cmp_action.luasnip_shift_supertab(),

					["<C-k>"] = cmp.mapping.select_prev_item(),
					["<C-j>"] = cmp.mapping.select_next_item(),
					["<C-e>"] = cmp.mapping.abort(),

					["<C-l>"] = cmp.mapping(function()
						if ls.expand_or_locally_jumpable() then
							ls.expand_or_jump()
						end
					end, { "i", "s" }),

					["<C-h>"] = cmp.mapping(function()
						if ls.locally_jumpable(-1) then
							ls.jump(-1)
						end
					end, { "i", "s" }),

					["<CR>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							if ls.expandable() then
								ls.expand()
							else
								cmp.confirm({
									select = true,
								})
							end
						else
							fallback()
						end
					end),

					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif ls.locally_jumpable(1) then
							ls.jump(1)
						else
							fallback()
						end
					end, { "i", "s" }),

					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif ls.locally_jumpable(-1) then
							ls.jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),
				}),
				preselect = "item",
				completion = {
					completeopt = "menu,menuone,noinsert",
				},
				snippet = {
					expand = function(args)
						ls.lsp_expand(args.body)
					end,
				},
				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},
				sources = {
					{ name = "luasnip" },
					{ name = "nvim_lsp" },
					{ name = "path" },
					{ name = "buffer" },
					{ name = "digraphs" },
					{ name = "calc" },
					{ name = "lazydev", group_index = 0 },
				},
				sorting = {
					comparators = {
						cmp.config.compare.offset,
						cmp.config.compare.exact,
						cmp.config.compare.score,
						cmp.config.compare.recently_used,
						cmp.config.compare.kind,
					},
				},
				formatting = {
					format = function(entry, vim_item)
						local highlights_info = require("colorful-menu").cmp_highlights(entry)

						-- highlight_info is nil means we are missing the ts parser, it's
						-- better to fallback to use default `vim_item.abbr`. What this plugin
						-- offers is two fields: `vim_item.abbr_hl_group` and `vim_item.abbr`.
						if highlights_info ~= nil then
							vim_item.abbr_hl_group = highlights_info.highlights
							vim_item.abbr = highlights_info.text
						end

						return vim_item
					end,
				},
			})

			local fmt = require("luasnip.extras.fmt").fmt
			local rep = require("luasnip.extras").rep

			-- some shorthands...
			local c = ls.choice_node
			local dy = ls.dynamic_node
			local func = ls.function_node
			local i = ls.insert_node
			local sn = ls.snippet_node
			local snip = ls.snippet
			local t = ls.text_node

			local reg = function(pos, name, insert)
				return dy(pos, function()
					local v = vim.fn.getreg(name, 1, 1)
					if v == nil then
						v = ""
					end

					if insert then
						return sn(nil, i(1, v))
					else
						return sn(nil, t(v))
					end
				end)
			end

			local date = function()
				return { os.date("%Y-%m-%d") }
			end

			local pdate = function()
				return os.date("%Y, %m, %d"):gsub(" 0", " ")
			end

			ls.add_snippets(nil, {
				all = {
					snip({
						trig = "date",
						namr = "Date",
						dscr = "Date in the form of YYYY-MM-DD",
					}, {
						func(date, {}),
					}),
				},
				go = {
					snip("dfun", fmt("defer func() {{\n\t{}\n}}(){}", { i(1, ""), i(0) })),
					snip("gfun", fmt("go func() {{\n\t{}\n}}(){}", { i(1, ""), i(0) })),

					snip(
						"nl",
						fmt('{} := logging.NewLogger("{}", "{}"){}', { i(1, "l"), i(2, "name"), i(3, "path"), i(0) })
					),
					snip(
						"nlp",
						fmt('logging.NewLoggerP("{}", "{}"){}.Msg("{}"){}', {
							i(1, "name"),
							i(2, "path"),
							i(3, "other"),
							i(4, "msg"),
							i(0),
						})
					),

					snip(
						"nle",
						fmt('logging.NewLoggerP("{}", "{}").Err({}){}.Msg("{}"){}', {
							i(1, "name"),
							i(2, "path"),
							i(3, "err"),
							i(4, "other"),
							i(5, "msg"),
							i(0),
						})
					),

					snip("fs", fmt('fmt.Sprintf("{}", {}){}', { i(1, "fmt"), i(2, "args"), i(0) })),
					snip("fsl", fmt('fmt.Sprintf("{}\\n", {}){}', { i(1, "fmt"), i(2, "args"), i(0) })),
					snip("ffl", fmt('fmt.Printf("{}\\n", {}){}', { i(1, "fmt"), i(2, "args"), i(0) })),
				},
				scala = {
					snip(
						"fpr",
						fmt(
							[[
    easyAutoRule(
      name = "{}{}",
      validated = makeDate({}),
      from = from{}("{}"),
      domains = Set(
        {}
      ),
      subjectContains = Seq(
        "{}"
      ),
    )
]],
							{
								reg(1, "+", false),
								i(2, ""),
								func(pdate),
								c(3, {
									t("Domains"),
									t("Emails"),
								}),
								reg(4, "+", false),
								reg(5, '"', false),
								i(6, ""),
							}
						)
					),
					snip("pdate", fmt("{}", { func(pdate) })),
				},
			})

			vim.keymap.set("n", ",pd", function()
				if vim.api.nvim_get_current_line() == "" then
					return
				end

				local start_pos = vim.api.nvim_win_get_cursor(0)

				vim.cmd.normal("{")
				local start_row = vim.api.nvim_win_get_cursor(0)[1] - 1
				vim.cmd.normal("}")
				local end_row = vim.api.nvim_win_get_cursor(0)[1] - 1

				vim.api.nvim_win_set_cursor(0, start_pos)

				local lines = vim.api.nvim_buf_get_lines(0, start_row, end_row, false)
				local rep = "= makeDate(" .. pdate() .. "),"

				for i, line in ipairs(lines) do
					local new_line = string.gsub(line, "= makeDate%([%d, ]+%),$", rep)

					if line ~= new_line then
						vim.api.nvim_buf_set_lines(0, start_row + i - 1, start_row + i, true, { new_line })
						return
					end
				end
			end)

			vim.keymap.set({ "i", "s" }, "<C-j>", function()
				ls.change_choice(1)
			end, {})
			vim.keymap.set({ "i", "s" }, "<C-k>", function()
				ls.change_choice(-1)
			end, {})
			vim.keymap.set({ "i", "s" }, "<C-o>", require("luasnip.extras.select_choice"), {})

			vim.keymap.set({ "i", "s" }, "<c-space>", function()
				if ls.expand_or_jumpable() then
					ls.expand_or_jump()
				end
			end, { silent = true })

			cmp.setup.filetype("DressingInput", {
				sources = cmp.config.sources({ { name = "omni" } }),
			})

			require("luasnip.loaders.from_vscode").lazy_load()
		end,
	},
}
