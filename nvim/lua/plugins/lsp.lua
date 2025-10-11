return {
	{
		"neovim/nvim-lspconfig",
		config = function()
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
					-- map("n", "<F2>", "<cmd>lua vim.lsp.buf.rename()<cr>", "Rename symbol")
					map("n", "<F3>", "<cmd>lua vim.lsp.buf.format({async = true})<cr>", "Format file")
					map("x", "<F3>", "<cmd>lua vim.lsp.buf.format({async = true})<cr>", "Format selection")
					map("n", "<F4>", "<cmd>lua vim.lsp.buf.code_action()<cr>", "Execute code action")
				end,
			})
		end,
	},
}
