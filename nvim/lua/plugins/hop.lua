local set = vim.keymap.set
local opts = { silent = true }

local function add_bind(hop, hint, mode, keys, dir, cur, inc, desc)
	local move_opts = {
		current_line_only = cur,
	}

	if dir == "a" then
		move_opts["direction"] = hint.HintDirection.AFTER_CURSOR
		if not inc then
			move_opts["hint_offset"] = -1
		end
	elseif dir == "b" then
		move_opts["direction"] = hint.HintDirection.BEFORE_CURSOR
		if not inc then
			move_opts["hint_offset"] = 1
		end
	elseif dir ~= "" then
		error("Unknown direction: " .. dir)
	end

	set(mode, keys, function()
		hop.hint_char1(move_opts)
	end, vim.tbl_extend("force", opts, { desc = desc }))
end

return {
	"smoka7/hop.nvim",
	config = function()
		local hop = require("hop")
		hop.setup({})
		local hint = require("hop.hint")

		add_bind(hop, hint, "n", "f", "a", false, true, "Hop to char (forward)")
		add_bind(hop, hint, "n", "F", "b", false, true, "Hop to char (backward)")
		add_bind(hop, hint, "n", "t", "a", false, false, "Hop till char (forward)")
		add_bind(hop, hint, "n", "T", "b", false, false, "Hop till char (backward)")

		-- operator-pending: stay on the current line like builtin f/F/t/T
		add_bind(hop, hint, "o", "f", "a", true, true, "Hop to char (forward, current line)")
		add_bind(hop, hint, "o", "F", "b", true, true, "Hop to char (backward, current line)")
		add_bind(hop, hint, "o", "t", "a", true, false, "Hop till char (forward, current line)")
		add_bind(hop, hint, "o", "T", "b", true, false, "Hop till char (backward, current line)")

		local no = { "n", "o" }

		-- buffer-wide variants (useful as operator targets)
		add_bind(hop, hint, no, ",,f", "a", nil, true, "Hop to char (forward, whole buffer)")
		add_bind(hop, hint, no, ",,F", "b", nil, true, "Hop to char (backward, whole buffer)")
		add_bind(hop, hint, no, ",,t", "a", nil, false, "Hop till char (forward, whole buffer)")
		add_bind(hop, hint, no, ",,T", "b", nil, false, "Hop till char (backward, whole buffer)")

		set(no, ",,h", "<cmd>HopChar2<CR>", { silent = true, desc = "Hop to 2 chars" })
		set(no, ",l", "<cmd>HopLineStart<CR>", { silent = true, desc = "Hop to line" })
	end,
}
