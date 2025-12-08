return {
	{
		"github/copilot.vim",
		cond = vim.env.NO_VIM_AI ~= "1" and vim.env.USE_COPILOT == "1",
		config = function()
			vim.keymap.set("i", "<s-c-i>", 'copilot#Accept("\\<CR>")', {
				expr = true,
				replace_keycodes = false,
				desc = "Accept Copilot suggestion",
			})
			vim.g.copilot_no_tab_map = true
		end,
		event = "BufEnter",
	},
	-- {
	--  "ravitemer/mcphub.nvim",
	--  dependencies = {
	--    "nvim-lua/plenary.nvim",
	--  },
	--  build = "npm install -g mcp-hub@latest", -- Installs `mcp-hub` node binary globally
	--  config = function()
	--    require("mcphub").setup({
	--      auto_approve = function(params)
	--        -- Respect CodeCompanion's auto tool mode when enabled
	--        if vim.g.codecompanion_auto_tool_mode == true then
	--          return true -- Auto approve when CodeCompanion auto-tool mode is on
	--        end
	--
	--        -- -- Auto-approve GitHub issue reading
	--        -- if params.server_name == "github" and params.tool_name == "get_issue" then
	--        --  return true -- Auto approve
	--        -- end
	--        --
	--        -- -- Block access to private repos
	--        -- if params.arguments.repo == "private" then
	--        --  return "You can't access my private repo" -- Error message
	--        -- end
	--
	--        -- Auto-approve safe file operations in current project
	--        if params.tool_name == "read_file" then
	--          local path = params.arguments.path or ""
	--          if path:match("^" .. vim.fn.getcwd()) then
	--            return true -- Auto approve
	--          end
	--        end
	--
	--        -- Check if tool is configured for auto-approval in servers.json
	--        if params.is_auto_approved_in_server then
	--          return true -- Respect servers.json configuration
	--        end
	--
	--        return false -- Show confirmation prompt
	--      end,
	--    })
	--  end,
	-- },
	{
		"olimorris/codecompanion.nvim",
		cond = vim.env.NO_VIM_AI ~= "1" and vim.env.USE_COPILOT == "1",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			-- "ravitemer/mcphub.nvim",
		},
		keys = {
			-- Open the chat window for the current buffer
			{
				"<leader>cc",
				function()
					require("codecompanion").chat()
				end,
				desc = "CodeCompanion: Chat (Current Buffer)",
			},

			-- Toggle the visibility of the current chat window
			{
				"<leader>co",
				function()
					require("codecompanion").toggle()
				end,
				desc = "CodeCompanion: Toggle Chat",
			},
		},
		opts = {
			ignore_warnings = true,
			-- extensions = {
			--  mcphub = {
			--    callback = "mcphub.extensions.codecompanion",
			--    opts = {
			--      -- MCP Tools
			--      make_tools = true, -- Make individual tools (@server__tool) and server groups (@server) from MCP servers
			--      show_server_tools_in_chat = true, -- Show individual tools in chat completion (when make_tools=true)
			--      add_mcp_prefix_to_tool_names = false, -- Add mcp__ prefix (e.g `@mcp__github`, `@mcp__neovim__list_issues`)
			--      show_result_in_chat = true, -- Show tool results directly in chat buffer
			--      format_tool = nil, -- function(tool_name:string, tool: CodeCompanion.Agent.Tool) : string Function to format tool names to show in the chat buffer
			--      -- MCP Resources
			--      make_vars = true, -- Convert MCP resources to #variables for prompts
			--      -- MCP Prompts
			--      make_slash_commands = true, -- Add MCP prompts as /slash commands
			--    },
			--  },
			-- },
			memory = {
				default = {
					description = "Collection of common files for all projects",
					files = {
						".clinerules",
						".cursorrules",
						".goosehints",
						".rules",
						".windsurfrules",
						".github/copilot-instructions.md",
						"AGENT.md",
						"AGENTS.md",
						{ path = "CLAUDE.md", parser = "claude" },
						{ path = "CLAUDE.local.md", parser = "claude" },
						{ path = "~/.claude/CLAUDE.md", parser = "claude" },
					},
				},
			},
			strategies = {
				chat = {
					adapter = {
						name = "copilot",
						model = "claude-sonnet-4.5",
						-- model = "claude-sonnet-4",
						-- model = "gemini-2.5-pro",
					},
					-- adapater = "copilot",
					tools = {
						-- ["mcp"] = {
						--  callback = function()
						--    return require("mcphub.extensions.codecompanion")
						--  end,
						--  description = "Call tools and resources from the MCP servers",
						--  opts = {
						--    show_result_in_chat = true,
						--    make_vars = true,
						--    make_slash_commands = true,
						--  },
						-- },
					},
				},
				inline = {
					adapter = "copilot",
				},
				agent = {
					adapter = "copilot",
				},
			},
		},
	},
}
