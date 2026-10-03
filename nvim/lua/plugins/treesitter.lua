local languages = {
	"bash",
	"c",
	"cmake",
	"comment",
	"cpp",
	"css",
	"diff",
	"dockerfile",
	"dot",
	"git_rebase",
	"gitattributes",
	"gitcommit",
	"gitignore",
	"go",
	"gomod",
	"gosum",
	"gotmpl",
	"gowork",
	"html",
	"ini",
	"javascript",
	"json",
	"just",
	"kotlin",
	"latex",
	"lua",
	"make",
	"markdown",
	"meson",
	"nickel",
	"ninja",
	-- "norg",
	"passwd",
	"proto",
	"python",
	"regex",
	"rust",
	"scala",
	"scss",
	"sql",
	"svelte",
	"templ",
	"terraform",
	"toml",
	"tsx",
	"typescript",
	"typst",
	"vim",
	"vue",
	"yaml",
	"zig",
}

return {
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		branch = "main",
		init = function()
			-- Disable entire built-in ftplugin mappings to avoid conflicts.
			-- See https://github.com/neovim/neovim/tree/master/runtime/ftplugin for built-in ftplugins.
			vim.g.no_plugin_maps = true

			-- Or, disable per filetype (add as you like)
			-- vim.g.no_python_maps = true
			-- vim.g.no_ruby_maps = true
			-- vim.g.no_rust_maps = true
			-- vim.g.no_go_maps = true
		end,
		config = function()
			-- put your config here
		end,
	},
	-- {
	--  "MeanderingProgrammer/treesitter-modules.nvim",
	--  dependencies = { "nvim-treesitter/nvim-treesitter" },
	--  opts = {
	--    auto_install = true,
	--    ensure_installed = languages,
	--    fold = { enable = false },
	--    highlight = { enable = true },
	--    incremental_selection = { enable = true },
	--    indent = { enable = true },
	--  },
	-- },
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		branch = "main",
		dependencies = {
			-- "nvim-treesitter/nvim-treesitter-refactor",
			-- "nvim-treesitter/nvim-treesitter-textobjects",
			-- "nvim-treesitter/nvim-treesitter-context",
			"OXY2DEV/markview.nvim",
		},
		lazy = false,
		config = function()
			-- replicate `ensure_installed`, runs asynchronously, skips existing languages
			require("nvim-treesitter").install(languages)

			vim.api.nvim_create_autocmd("FileType", {
				group = vim.api.nvim_create_augroup("treesitter.setup", {}),
				callback = function(args)
					local buf = args.buf
					local filetype = args.match

					-- you need some mechanism to avoid running on buffers that do not
					-- correspond to a language (like oil.nvim buffers), this implementation
					-- checks if a parser exists for the current language
					local language = vim.treesitter.language.get_lang(filetype) or filetype
					if not vim.treesitter.language.add(language) then
						return
					end

					-- replicate `fold = { enable = true }`
					-- vim.wo.foldmethod = "expr"
					-- vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"

					-- replicate `highlight = { enable = true }`
					vim.treesitter.start(buf, language)

					-- replicate `indent = { enable = true }`
					vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
				end,
			})

			local sel = require("nvim-treesitter-textobjects.select")

			-- You can use the capture groups defined in `textobjects.scm`
			local textobjs = {
				af = { "@function.outer", "Function (outer)" },
				["if"] = { "@function.inner", "Function (inner)" },
				ac = { "@class.outer", "Class (outer)" },
				ic = { "@class.inner", "Class (inner)" },
				aa = { "@parameter.outer", "Argument (outer)" },
				ia = { "@parameter.inner", "Argument (inner)" },
			}
			for lhs, spec in pairs(textobjs) do
				vim.keymap.set({ "x", "o" }, lhs, function()
					sel.select_textobject(spec[1], "textobjects")
				end, { desc = spec[2] })
			end

			local swap = require("nvim-treesitter-textobjects.swap")

			vim.keymap.set("n", "<leader>pn", function()
				swap.swap_next("@parameter.inner")
			end, { desc = "Swap argument with next" })
			vim.keymap.set("n", "<leader>pp", function()
				swap.swap_previous("@parameter.inner")
			end, { desc = "Swap argument with previous" })
		end,
	},
	{
		"Wansmer/treesj",
		-- <space>m/j/s come from use_default_keymaps; listed here so they trigger loading
		keys = {
			{ "<leader>m", desc = "Toggle split/join" },
			{ "<space>m", desc = "Toggle split/join" },
			{ "<space>j", desc = "Join node" },
			{ "<space>s", desc = "Split node" },
		},
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
		},
		config = function()
			local tsj_utils = require("treesj.langs.utils")

			local langs = {
				scala = {
					-- class/object/trait bodies: `{ ... }`
					template_body = tsj_utils.set_preset_for_statement(),
					class_definition = { target_nodes = { "template_body" } },
					object_definition = { target_nodes = { "template_body" } },
					trait_definition = { target_nodes = { "template_body" } },

					-- `enum Foo { ... }` body. NOTE: deliberately not handling
					-- `enum_case_definitions` (the `case A, B, C` shorthand) --
					-- its leading `case` keyword confuses treesj's generic
					-- list-item/separator counting and joining it back drops a
					-- comma, silently corrupting the enum.
					enum_body = tsj_utils.set_preset_for_statement(),
					enum_definition = { target_nodes = { "enum_body" } },

					-- `{ ... }` code blocks and `match { case ... }` bodies.
					-- NOTE: deliberately not handling `indented_block`/
					-- `indented_cases` (Scala 3's brace-less indentation
					-- syntax) -- joining them to one line produces invalid
					-- Scala since there's nothing to frame the joined
					-- statements without braces.
					block = tsj_utils.set_preset_for_statement(),
					case_block = tsj_utils.set_preset_for_statement(),

					-- parameter / argument / tuple lists
					class_parameters = tsj_utils.set_preset_for_args({ split = { last_separator = true } }),
					parameters = tsj_utils.set_preset_for_args({ split = { last_separator = true } }),
					arguments = tsj_utils.set_preset_for_args({ split = { last_separator = true } }),
					tuple_expression = tsj_utils.set_preset_for_args({ split = { last_separator = true } }),
					bindings = tsj_utils.set_preset_for_args({ split = { last_separator = true } }),
					lambda_expression = { target_nodes = { "bindings" } },

					-- `import foo.bar.{Baz, Qux}`
					namespace_selectors = tsj_utils.set_preset_for_list(),
					import_declaration = { target_nodes = { "namespace_selectors" } },
				},
				-- Nickel records ({ ... }) live on `uni_record`, but array
				-- literals ([ ... ]) don't get their own node type -- they're
				-- just an `atom` with a `terms` field. `atom` is also used for
				-- bools/idents/parenthesized terms/etc, so gate it on actually
				-- having `terms` to split/join.
				nickel = {
					uni_record = tsj_utils.set_preset_for_dict(),
					atom = tsj_utils.set_preset_for_list({
						both = {
							enable = function(node)
								return not vim.tbl_isempty(node:field("terms"))
							end,
						},
					}),
				},
			}

			local tj = require("treesj")

			tj.setup({
				use_default_keymaps = true,
				max_join_length = 240,
				langs = langs,
			})

			vim.keymap.set("n", "<leader>m", tj.toggle, { desc = "Toggle split/join args" })
		end,
	},
	{
		"chrisgrieser/nvim-various-textobjs",
		event = "VeryLazy",
		opts = {
			keymaps = {
				useDefaults = true,
				disabledDefaults = {
					-- these override builtin visual/operator-pending keys
					"!", -- filter through shell cmd
					"r", -- visual r{char}
					"R", -- visual replace lines
					"C", -- visual change lines
					"Q",
					"n", -- next search match
					"|", -- go to column
					"gw", -- format lines
					"gW",
					-- these collide with targets.vim (next-modifier and separator objects)
					"in",
					"an",
					"i,",
					"a,",
					"i_",
					"a_",
					"i#",
					"a#",
					"iq",
					"aq",
				},
			},
		},
	},
}
