return {
	"scalameta/nvim-metals",
	ft = { "java", "scala", "sbt" },
	dependencies = {
		"rachartier/tiny-inline-diagnostic.nvim",
		"saghen/blink.cmp",
	},
	opts = function()
		local metals_config = require("metals").bare_config()

		-- metals_config.init_options.globSyntax = "vscode"
		metals_config.init_options.statusBarProvider = "off" -- Use fidget

		metals_config.settings = {
			showImplicitArguments = true,
			showInferredType = true,
			superMethodLensesEnabled = true,
			showImplicitConversionsAndClasses = true,
			defaultBspToBuildTool = true, -- Use the build tool's BSP server (e.g. sbt) instead of Bloop
			automaticImportBuild = "initial",
			startMcpServer = true, -- Expose MCP so Claude Code can use this instance (writes .metals/mcp.json)
			mcpClient = "claude",
			excludedPackages = { "org.apache.pekko.actor.typed.javadsl" },
			-- Hints are toggled globally via the LspAttach <C-i> mapping in lsp.lua
			inlayHints = {
				inferredTypes = { enable = true },
				implicitArguments = { enable = true },
				implicitConversions = { enable = true },
				typeParameters = { enable = true },
				hintsInPatternMatch = { enable = true },
			},
		}

		if vim.fn.has("mac") == 1 then
			metals_config.settings.serverProperties = { "-Dmetals.macos-max-watch-roots=4096" }
		end

		metals_config.capabilities = require("blink.cmp").get_lsp_capabilities({}, true)

		return metals_config
	end,
	config = function(self, metals_config)
		local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
		vim.api.nvim_create_autocmd("FileType", {
			pattern = self.ft,
			callback = function()
				require("metals").initialize_or_attach(metals_config)
			end,
			group = nvim_metals_group,
		})
	end,
}
