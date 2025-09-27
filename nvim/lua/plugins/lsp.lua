return {
	{
		"L3MON4D3/LuaSnip",
		build = "make install_jsregexp",
	},
	{
		"chrisgrieser/nvim-lsp-endhints",
		event = "LspAttach",
		opts = {}, -- required, even if empty
	},
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			-- Configs
			"neovim/nvim-lspconfig",
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

			-- Manual!
			vim.lsp.enable("fish_lsp")

			-- normal
			vim.lsp.enable("docker_language_server")
			vim.lsp.enable("dprint")
			vim.lsp.enable("eslint")
			vim.lsp.enable("golangci_lint_ls")
			vim.lsp.enable("html")
			vim.lsp.enable("just")
			vim.lsp.enable("lua_ls")
			vim.lsp.enable("pyright")
			vim.lsp.enable("ruff")
			vim.lsp.enable("rust_analyzer")
			vim.lsp.enable("stylua")
			vim.lsp.enable("systemd_ls")
			vim.lsp.enable("tailwindcss")
			vim.lsp.enable("taplo")
			vim.lsp.enable("templ")
			vim.lsp.enable("ts_ls")

			vim.lsp.config("gopls", {
				gofumpt = true,
			})
			vim.lsp.enable("gopls")

			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(args)
					local client = vim.lsp.get_client_by_id(args.data.client_id)
					if not client then
						return
					end

					-- Disable by default since we can turn on when needed
					vim.lsp.inlay_hint.enable(false)

					-- quickly toggle inlay hints
					vim.keymap.set({ "n", "x" }, "<C-i>", function()
						vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
					end)

					vim.keymap.set({ "n", "x" }, "gf", function()
						vim.lsp.buf.format({ async = false, timeout_ms = 10000 })
					end)

					local buffer = vim.api.nvim_get_current_buf()

					local map = function(m, lhs, rhs, desc)
						local key_opts = { buffer = buffer, desc = desc, nowait = true }
						vim.keymap.set(m, lhs, rhs, key_opts)
					end

					map("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", "Hover documentation")
					map("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>", "Show function signature")
					map("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", "Go to definition")
					map("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", "Go to declaration")
					map("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", "Go to implementation")
					map("n", "go", "<cmd>lua vim.lsp.buf.type_definition()<cr>", "Go to type definition")
					map("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", "Go to reference")
					map("n", "<F2>", "<cmd>lua vim.lsp.buf.rename()<cr>", "Rename symbol")
					map("n", "<F3>", "<cmd>lua vim.lsp.buf.format({async = true})<cr>", "Format file")
					map("x", "<F3>", "<cmd>lua vim.lsp.buf.format({async = true})<cr>", "Format selection")
					map("n", "<F4>", "<cmd>lua vim.lsp.buf.code_action()<cr>", "Execute code action")
				end,
			})

			local cmp = require("cmp")

			local ls = require("luasnip")

			cmp.setup({
				mapping = cmp.mapping.preset.insert({
					["<C-Y>"] = cmp.mapping.confirm({ select = true }),
					["<CR>"] = cmp.mapping.confirm({ select = false }),

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
