return {
	"monaqa/dial.nvim",
	config = function()
		local d = require("dial.map")
		vim.keymap.set("n", "<C-a>", function()
			d.manipulate("increment", "normal")
		end, { desc = "Increment" })
		vim.keymap.set("n", "<C-x>", function()
			d.manipulate("decrement", "normal")
		end, { desc = "Decrement" })
		vim.keymap.set("n", "g<C-a>", function()
			d.manipulate("increment", "gnormal")
		end, { desc = "Increment (sequential)" })
		vim.keymap.set("n", "g<C-x>", function()
			d.manipulate("decrement", "gnormal")
		end, { desc = "Decrement (sequential)" })

		vim.keymap.set("v", "<C-a>", function()
			d.manipulate("increment", "visual")
		end, { desc = "Increment" })
		vim.keymap.set("v", "<C-x>", function()
			d.manipulate("decrement", "visual")
		end, { desc = "Decrement" })
		vim.keymap.set("v", "g<C-a>", function()
			d.manipulate("increment", "gvisual")
		end, { desc = "Increment (sequential)" })
		vim.keymap.set("v", "g<C-x>", function()
			d.manipulate("decrement", "gvisual")
		end, { desc = "Decrement (sequential)" })

		local dial_config = require("dial.config")
		local augend = require("dial.augend")

		dial_config.augends:register_group({
			-- default augends used when no group name is specified
			default = {
				augend.integer.alias.decimal_int, -- nonnegative decimal number (0, 1, 2, 3, ...)
				augend.integer.alias.hex, -- nonnegative hex number  (0x01, 0x1a1f, etc.)
				augend.constant.alias.bool, -- bools (true <-> false)
				augend.semver.alias.semver, -- semantic versioning
				augend.date.alias["%Y-%m-%d"], -- date (2022/02/19, etc.)

				-- python bools
				augend.constant.new({
					elements = { "True", "False" },
					word = true,
					cyclic = true,
				}),
			},
		})
	end,
}

