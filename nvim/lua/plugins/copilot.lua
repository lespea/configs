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

			--- Returns true (prompt required) when the tool's target path looks like a
			--- secret, credential, lockfile, CI/CD config, or shell startup file — even
			--- when that path is safely inside the project. Reading these into an LLM's
			--- context, or letting it silently rewrite them, is risky regardless of cwd.
			---@param tool table
			---@return boolean
			local function sensitive_path(tool)
				local path = tool.args and (tool.args.filepath or tool.args.path) or ""
				if path == "" then
					return false
				end
				local sensitive_patterns = {
					-- Env / secrets / credentials
					"%.env$",
					"%.env%.",
					"secrets?%.",
					"credentials",
					"%.pem$",
					"%.key$",
					"%.p12$",
					"%.pfx$",
					"id_rsa",
					"id_ed25519",
					"%.ssh/",
					"%.aws/",
					"%.gnupg/",
					"%.netrc$",
					"%.npmrc$",
					"%.pypirc$",
					"kubeconfig",
					"%.kube/config",

					-- Shell / editor startup files (execute on every new shell/session)
					"%.bashrc$",
					"%.bash_profile$",
					"%.zshrc$",
					"%.zprofile$",
					"%.profile$",
					"%.zshenv$",

					-- Git internals (hooks run arbitrary code; config controls remotes/signing)
					"%.git/hooks/",
					"%.git/config$",

					-- CI/CD pipeline definitions (often carry deploy secrets/permissions)
					"%.github/workflows/",
					"%.gitlab%-ci%.yml$",
					"Jenkinsfile$",
					"%.circleci/",
					"azure%-pipelines%.yml$",

					-- Lockfiles (silent edits here can smuggle in dependency changes)
					"package%-lock%.json$",
					"yarn%.lock$",
					"pnpm%-lock%.yaml$",
					"Gemfile%.lock$",
					"poetry%.lock$",
					"Cargo%.lock$",
					"go%.sum$",

					-- Infra-as-code state (contains resource IDs/secrets, drives real infra)
					"%.tfstate",
				}
				for _, pattern in ipairs(sensitive_patterns) do
					if path:match(pattern) then
						return true
					end
				end
				return false
			end

			--- Combined guard for file tools: prompt if the path escapes cwd OR looks sensitive.
			---@param tool table
			---@return boolean
			local function outside_cwd_or_sensitive(tool)
				return outside_cwd(tool) or sensitive_path(tool)
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
					-- Git: publishing / history rewriting / irreversible local ops
					"git%s+push",
					"git%s+reset%s+.*%-%-hard",
					"git%s+clean%s+.*%-[dfx]",
					"git%s+checkout%s+.*%-%-force",
					"git%s+branch%s+.*%-D",
					"git%s+tag%s+.*%-d",
					"git%s+rebase",
					"git%s+filter%-branch",
					"git%s+filter%-repo",
					"git%s+update%-ref",
					"git%s+reflog%s+.*expire",
					"git%s+gc%s+.*%-%-prune",
					"git%s+submodule%s+.*%-%-force",
					"git%s+stash%s+.*drop",
					"git%s+stash%s+.*clear",

					-- GitHub / GitLab CLI: state-changing / destructive actions
					"gh%s+repo%s+delete",
					"gh%s+pr%s+merge",
					"gh%s+release%s+delete",
					"gh%s+workflow%s+.*disable",

					-- Filesystem: deletion, permissions, ownership, moves
					"%f[%a]rm%f[%A].*%-r",
					"%f[%a]rm%f[%A].*%-f",
					"%f[%a]rmdir%f[%A]",
					"%f[%a]mv%f[%A]",
					"%f[%a]shred%f[%A]",
					"chmod",
					"chown",
					"chgrp",
					"%f[%a]truncate%f[%A]",

					-- Privilege escalation / system control
					"%f[%a]sudo%f[%A]",
					"%f[%a]su%f[%A]",
					"%f[%a]doas%f[%A]",
					"systemctl",
					"launchctl",
					"%f[%a]kill%f[%A]%s*%-9",
					"killall",
					"pkill",
					"shutdown",
					"reboot",
					"%f[%a]halt%f[%A]",

					-- Disk / block device operations
					"%f[%a]dd%f[%A]",
					"mkfs",
					"fdisk",
					"diskutil%s+.*erase",
					"diskutil%s+.*partition",

					-- Package managers: installs/uninstalls/global changes/publishing
					"brew%s+uninstall",
					"brew%s+install",
					"npm%s+install%s+.*%-g",
					"npm%s+uninstall%s+.*%-g",
					"npm%s+publish",
					"yarn%s+global",
					"pnpm%s+add%s+.*%-g",
					"pip%s+uninstall",
					"pip%s+install%s+.*%-%-user%f[%A]",
					"gem%s+uninstall",
					"apt%-?get?%s+remove",
					"apt%-?get?%s+install",

					-- Infra / cloud CLIs: provisioning & teardown
					"terraform%s+destroy",
					"terraform%s+apply",
					"kubectl%s+delete",
					"kubectl%s+apply",
					"kubectl%s+drain",
					"docker%s+push",
					"docker%s+rm",
					"docker%s+rmi",
					"docker%s+system%s+prune",
					"docker%-compose%s+down",
					"aws%s+.*delete",
					"aws%s+s3%s+rm",
					"gcloud%s+.*delete",
					"az%s+.*delete",

					-- Databases: destructive statements
					"drop%s+table",
					"drop%s+database",
					"truncate%s+table",
					"delete%s+from",

					-- Network: outbound transfer / exfiltration / remote exec
					"%f[%a]scp%f[%A]",
					"rsync%s+.*::",
					"%f[%a]ssh%f[%A]",
					"curl%s+.*|%s*sh",
					"curl%s+.*|%s*bash",
					"wget%s+.*|%s*sh",
					"wget%s+.*|%s*bash",
					"%f[%a]nc%f[%A]%s+%-l",

					-- Credentials / secrets / sensitive config paths
					"%.ssh",
					"%.aws",
					"%.gnupg",
					"%.netrc",
					"id_rsa",
					"id_ed25519",
					"printenv",
					"%f[%a]env%f[%A]$",
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
							-- Filepath-based tools: prompt when the path escapes the project root OR
							-- looks like a secret/credential/lockfile/CI config/shell rc file, even
							-- if it's inside the project (see sensitive_path above).
							["read_file"] = { opts = { require_approval_before = outside_cwd_or_sensitive } },
							["create_file"] = { opts = { require_approval_before = outside_cwd_or_sensitive } },
							["delete_file"] = { opts = { require_approval_before = outside_cwd_or_sensitive } },
							["insert_edit_into_file"] = {
								opts = {
									require_approval_before = outside_cwd_or_sensitive,
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
