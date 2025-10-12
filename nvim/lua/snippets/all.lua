local s = require("luasnip.nodes.snippet").S
local f = require("luasnip.nodes.functionNode").F

return {
	s({
		trig = "date",
		namr = "Date",
		dscr = "Date in the form of YYYY-MM-DD",
	}, {
		f(os.date("%Y-%m-%d"), {}),
	}),
}
