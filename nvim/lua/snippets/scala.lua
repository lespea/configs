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
		local v = vim.fn.getreg(name, 1)
		if v == nil then
			v = ""
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
				c(3, {
					t("Domains"),
					t("Emails"),
				}),
				reg(4, "+", false),
				reg(5, '"', false),
				i(6, ""),
			}
		)
	),

	-- fpr date
	s("pdate", fmt("{}", { f(pdate) })),
}
