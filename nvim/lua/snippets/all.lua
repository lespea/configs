local s = require("luasnip.nodes.snippet").S
local f = require("luasnip.nodes.functionNode").F

return {
	s({
		trig = "date",
		name = "Date",
		dscr = "Date in the form of YYYY-MM-DD",
	}, {
		f(function()
			return os.date("%Y-%m-%d")
		end),
	}),
}
