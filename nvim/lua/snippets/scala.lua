local s = require("luasnip.nodes.snippet").S
local sn = require("luasnip.nodes.snippet").SN
local t = require("luasnip.nodes.textNode").T
local i = require("luasnip.nodes.insertNode").I
local f = require("luasnip.nodes.functionNode").F
local c = require("luasnip.nodes.choiceNode").C
local d = require("luasnip.nodes.dynamicNode").D
local fmt = require("luasnip.extras.fmt").fmt

local reg = function(pos, name, insert)
	return d(pos, function()
		local v = vim.fn.getreg(name, 1, 1)
		if v == nil then
			v = { "" }
		end

		if insert then
			return sn(nil, i(1, v))
		else
			return sn(nil, t(v))
		end
	end)
end

local pdate = function()
	return os.date("%Y, %m, %d"):gsub(" 0", " ")
end

-- Defaults to "Emails" if the "+" register looks like it contains an email
-- address (i.e. has an "@" in it), otherwise defaults to "Domains". Either
-- way, the choice can still be cycled with <c-n>/<c-p> as usual.
local from_kind_choice = function(pos)
	return d(pos, function()
		local reg_val = table.concat(vim.fn.getreg("+", 1, 1), "\n")
		local domains, emails = t("Domains"), t("Emails")

		if reg_val:find("@") then
			return sn(nil, c(1, { emails, domains }))
		end

		return sn(nil, c(1, { domains, emails }))
	end)
end

vim.keymap.set("n", "<leader>pd", function()
	if vim.api.nvim_get_current_line() == "" then
		return
	end

	local start_pos = vim.api.nvim_win_get_cursor(0)

	vim.cmd.normal("{")
	local start_row = vim.api.nvim_win_get_cursor(0)[1] - 1
	vim.cmd.normal("}")
	local end_row = vim.api.nvim_win_get_cursor(0)[1] - 1

	vim.api.nvim_win_set_cursor(0, start_pos)

	local lines = vim.api.nvim_buf_get_lines(0, start_row, end_row, false)
	local rep = "= makeDate(" .. pdate() .. "),"

	for idx, line in ipairs(lines) do
		local new_line = string.gsub(line, "= makeDate%([%d, ]+%),$", rep)

		if line ~= new_line then
			vim.api.nvim_buf_set_lines(0, start_row + idx - 1, start_row + idx, true, { new_line })
			return
		end
	end
end, { desc = "update fpr date" })

return {
	-- new fpr
	s(
		"fpr",
		fmt(
			[[
    easyAutoRule(
      name = "{}{}",
      validated = makeDate({}),
      from = from{}("{}"),
      domains = Set(
        {}
      ),
      subjectContains = Seq(
        "{}"
      ),
    )
]],
			{
				reg(1, "+", false),
				i(2, ""),
				f(pdate),
				from_kind_choice(3),
				reg(4, "+", false),
				reg(5, '"', false),
				i(6, ""),
			}
		)
	),

	-- fpr date
	s("pdate", fmt("{}", { f(pdate) })),
}
