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
	{
		"olimorris/codecompanion.nvim",
		cond = vim.env.NO_VIM_AI ~= "1" and vim.env.USE_COPILOT == "1",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		keys = {
			{
				"<leader>cc",
				function()
					require("codecompanion").chat()
				end,
				desc = "CodeCompanion: Chat (Current Buffer)",
			},
			{
				"<leader>co",
				function()
					require("codecompanion").toggle()
				end,
				desc = "CodeCompanion: Toggle Chat",
			},
		},
		-- Use config= instead of opts= so we can define a local helper function
		config = function()
			--- Returns true (prompt required) when the tool's target path falls outside
			--- the current working directory. Safe tools inside the project are silent.
			---@param tool table
			---@return boolean
			local function outside_cwd(tool)
				local path = tool.args and (tool.args.filepath or tool.args.path) or ""
				if path == "" then
					return false
				end
				local abs = vim.fn.fnamemodify(path, ":p")
				local cwd = vim.fn.getcwd()
				-- Normalise: ensure cwd ends with a separator so a prefix match is exact
				if cwd:sub(-1) ~= "/" then
					cwd = cwd .. "/"
				end
				return not vim.startswith(abs, cwd)
			end

			require("codecompanion").setup({
				ignore_warnings = true,
				interactions = {
					chat = {
						tools = {
							opts = {
								-- Load the full agent toolset in every new chat automatically
								default_tools = { "agent" },
							},
							groups = {
								-- Extend the agent group's system prompt with our tool-usage rules
								["agent"] = {
									system_prompt = function(group, ctx)
										local default = group.default_system_prompt
											or require("codecompanion.config").interactions.chat.tools.groups["agent"].system_prompt
										return (type(default) == "function" and default(group, ctx) or default or "")
											.. [[
<toolRules>
- grep_search: ALWAYS set is_regexp=true when the query contains | or any regex syntax.
  Without it the pipe is escaped to a literal and returns zero results.
- Prefer native tools over shell commands: use read_file not cat, grep_search not grep,
  file_search not find, get_diagnostics not shell invocations, get_changed_files not git diff.
  Only reach for run_command when no native tool can do the job (builds, tests, etc).
</toolRules>]]
									end,
								},
							},
						},
					},
				},
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
							model = "claude-sonnet-4.6",
						},
						tools = {
							-- No filepath arg; workspace-scoped reads — never prompt
							["grep_search"] = { opts = { require_approval_before = false } },
							["file_search"] = { opts = { require_approval_before = false } },
							["get_diagnostics"] = { opts = { require_approval_before = false } },
							["get_changed_files"] = { opts = { require_approval_before = false } },
							-- Filepath-based tools: only prompt when path escapes the project root
							["read_file"] = { opts = { require_approval_before = outside_cwd } },
							["create_file"] = { opts = { require_approval_before = outside_cwd } },
							["delete_file"] = { opts = { require_approval_before = outside_cwd } },
							["insert_edit_into_file"] = {
								opts = {
									require_approval_before = outside_cwd,
									require_confirmation_after = false, -- git handles this
								},
							},
						},
					},
					inline = { adapter = "copilot" },
					agent = { adapter = "copilot" },
				},
			})
		end,
	},
}
