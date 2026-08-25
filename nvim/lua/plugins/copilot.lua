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

			--- Hard-coded deny/prompt list for shell commands that must NEVER be silently
			--- auto-approved in YOLO mode, no matter what the background LLM judge decides.
			--- This is a deterministic backstop, not a suggestion to the judge.
			---@param tool table
			---@return boolean
			local function requires_hard_confirmation(tool)
				local cmd = tool.args and tool.args.cmd or ""
				if cmd == "" then
					return false
				end
				local unsafe_patterns = {
					"git%s+push",
					"git%s+reset%s+.*%-%-hard",
					"git%s+clean%s+.*%-[dfx]",
					"git%s+checkout%s+.*%-%-force",
					"git%s+branch%s+.*%-D",
					"%f[%a]rm%f[%A].*%-r",
					"%f[%a]rm%f[%A].*%-f",
					"%f[%a]sudo%f[%A]",
					"%f[%a]mv%f[%A]",
					"chmod",
					"chown",
					"%.ssh",
					"%.aws",
				}
				for _, pattern in ipairs(unsafe_patterns) do
					if cmd:match(pattern) then
						return true
					end
				end
				return false
			end

			require("codecompanion").setup({
				ignore_warnings = true,
				interactions = {
					-- Background "judge" gate: when a tool opts into judge_in_yolo_mode and
					-- YOLO mode (gty) is on, this silently asks an LLM whether the specific
					-- command/action is safe instead of prompting you. Encode your own
					-- allow/deny rules here instead of relying on per-command "always allow".
					background = {
						gates = {
							judge = {
								opts = {
									system_prompt = [[You are a security reviewer for an AI coding assistant running
on the user's own machine in "auto-approve" (YOLO) mode. Decide if the pending
tool action is safe to run without asking the user first.

Treat these as SAFE (approve automatically):
- Read-only shell commands: ls, cat, grep/rg, find, git status/diff/log/show,
  npm/yarn/pnpm test or lint, go test, cargo test, make test, curl to localhost.
- Builds/tests that don't touch files outside the current working directory.

Treat these as UNSAFE (require approval):
- Anything destructive or hard to reverse: rm, mv, git push --force, git reset --hard,
  chmod/chown on system paths, sudo, package installs/uninstalls, writes outside cwd.
- Anything touching credentials, SSH keys, ~/.aws, ~/.ssh, environment secrets.
- Any network call other than to localhost/private test servers.

When in doubt, require approval. Reply only through the provided schema.]],
								},
							},
						},
					},
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
							model = "claude-sonnet-5",
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
							-- run_command opts into YOLO mode (gty) and defers to the background
							-- judge (see interactions.background.gates.judge above) for anything
							-- not covered below. But certain commands (git push, rm -rf, sudo,
							-- credential paths, etc.) ALWAYS require explicit approval via
							-- requires_hard_confirmation, regardless of what the judge decides.
							["run_command"] = {
								opts = {
									allowed_in_yolo_mode = true,
									judge_in_yolo_mode = true,
									require_approval_before = requires_hard_confirmation,
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
