return {
	{
		"chrisgrieser/nvim-lsp-endhints",
		event = "LspAttach",
		opts = {}, -- required, even if empty
	},
	{
		"folke/lazydev.nvim",
		ft = "lua", -- only load on lua files
		opts = {
			library = {
				-- See the configuration section for more details
				-- Load luvit types when the `vim.uv` word is found
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		},
	},
	{
		"onsails/diaglist.nvim",
		keys = {
			{
				"<leader>dl",
				"<cmd>lua require('diaglist').open_all_diagnostics()<cr>",
				desc = "Toggle Diagnostics List",
			},
		},
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = { "rachartier/tiny-inline-diagnostic.nvim" },
		config = function()
			-- Disable virtual text globally to prevent overlap with tiny-inline-diagnostic
			vim.diagnostic.config({ virtual_text = false })

			-- Manual!
			vim.lsp.enable("fish_lsp")

			-- normal
			vim.lsp.enable("biome")
			vim.lsp.enable("docker_language_server")
			vim.lsp.enable("dprint")
			vim.lsp.enable("golangci_lint_ls")
			vim.lsp.enable("html")
			vim.lsp.enable("just")
			vim.lsp.enable("lua_ls")
			vim.lsp.enable("pyright")
			vim.lsp.enable("ruff")
			vim.lsp.enable("rust_analyzer")
			vim.lsp.enable("stylua")
			vim.lsp.enable("tailwindcss")
			vim.lsp.enable("taplo")
			vim.lsp.enable("templ")
			vim.lsp.enable("ts_ls")

			-- Automatically set filetype and start LSP for specific systemd unit file patterns
			vim.api.nvim_create_autocmd("BufEnter", {
				pattern = { "*.service", "*.mount", "*.device", "*.nspawn", "*.target", "*.timer" },
				callback = function()
					vim.bo.filetype = "systemd"
					vim.lsp.start({
						name = "systemd_ls",
						cmd = { "systemd-lsp" }, -- Update this path to your systemd-lsp binary
						root_dir = vim.fn.getcwd(),
					})
				end,
			})

			vim.lsp.config("gopls", {
				gofumpt = true,
			})
			vim.lsp.enable("gopls")

			vim.lsp.config("tinymist", {
				cmd = { "tinymist" },
				filetypes = { "typst" },
				settings = {
					formatterMode = "typstyle",
				},
			})
			vim.lsp.enable("tinymist")

			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(args)
					local client = vim.lsp.get_client_by_id(args.data.client_id)
					if not client then
						return
					end

					-- Set blink.cmp capabilities for this LSP client
					local blink_ok, blink = pcall(require, "blink.cmp")
					if blink_ok then
						client.server_capabilities = vim.tbl_deep_extend(
							"force",
							client.server_capabilities,
							blink.get_lsp_capabilities({}, true)
						)
					end

					-- Disable by default since we can turn on when needed
					vim.lsp.inlay_hint.enable(false)

					-- quickly toggle inlay hints
					vim.keymap.set({ "n", "x" }, "<C-i>", function()
						vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
					end, { desc = "Toggle inlay hints" })

					-- vim.keymap.set({ "n", "x" }, "gf", function()
					-- 	vim.lsp.buf.format({ async = false, timeout_ms = 10000 })
					-- end)

					local buffer = vim.api.nvim_get_current_buf()

					local map = function(m, lhs, rhs, desc)
						local key_opts = { buffer = buffer, desc = desc, nowait = true }
						vim.keymap.set(m, lhs, rhs, key_opts)
					end

					-- map("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", "Hover documentation")
					-- map("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>", "Show function signature")
					-- map("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", "Go to definition")
					-- map("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", "Go to declaration")
					-- map("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", "Go to implementation")
					-- map("n", "go", "<cmd>lua vim.lsp.buf.type_definition()<cr>", "Go to type definition")
					-- map("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", "Go to reference")
					-- map("n", "<F2>", "<cmd>lua vim.lsp.buf.rename()<cr>", "Rename symbol")
					map("n", "<F3>", "<cmd>lua vim.lsp.buf.format({async = true})<cr>", "Format file")
					map("x", "<F3>", "<cmd>lua vim.lsp.buf.format({async = true})<cr>", "Format selection")
					map("n", "<F4>", "<cmd>lua vim.lsp.buf.code_action()<cr>", "Execute code action")
				end,
			})
		end,
	},
}
