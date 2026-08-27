return {
	"sQVe/sort.nvim",
	event = "VeryLazy",
	opts = {
		ignore_case = true,
	},
	config = function(_, opts)
		require("sort").setup(opts)

		-- `gO` mirrors whatever `go` is bound to (operator, visual, and the
		-- doubled line-wise form) but forces `unique = true` for that one
		-- invocation. Rather than reimplementing sort.nvim's mapping logic,
		-- delegate to the exact callbacks it registered for `go`/`gogo` and
		-- just toggle the config flag around the call, so `gO` automatically
		-- tracks any future change to how `go` behaves.
		local config = require("sort.config")
		local base_key = config.get_user_config().mappings.operator

		local function with_unique(fn)
			local user_config = config.get_user_config()
			local original = user_config.unique
			user_config.unique = true
			local ok, result = pcall(fn)
			user_config.unique = original
			assert(ok, result)
			return result
		end

		local function delegate(mode, lhs)
			local mapping = vim.fn.maparg(lhs, mode, false, true)
			local callback = mapping and mapping.callback
			if not callback then
				vim.notify(
					string.format("sort.lua: no %s-mode mapping found for %q to delegate gO to", mode, lhs),
					vim.log.levels.ERROR
				)
				return function() end
			end
			return callback
		end

		vim.keymap.set("n", "gO", function()
			return with_unique(delegate("n", base_key))
		end, {
			expr = true,
			desc = "Sort operator (unique)",
			silent = true,
		})

		vim.keymap.set("x", "gO", function()
			with_unique(delegate("x", base_key))
		end, {
			desc = "Sort selection (unique)",
			silent = true,
		})

		vim.keymap.set("n", "gOgO", function()
			return with_unique(delegate("n", base_key .. base_key))
		end, {
			expr = true,
			desc = "Sort current line (unique)",
			silent = true,
		})
	end,
}
