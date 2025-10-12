local fmt = require("luasnip.extras.fmt").fmt
local i = require("luasnip.nodes.insertNode").I
local s = require("luasnip.nodes.snippet").S

return {
	s("dfun", fmt("defer func() {{\n\t{}\n}}(){}", { i(1, ""), i(0) })),
	s("gfun", fmt("go func() {{\n\t{}\n}}(){}", { i(1, ""), i(0) })),

	s("nl", fmt('{} := logging.NewLogger("{}", "{}"){}', { i(1, "l"), i(2, "name"), i(3, "path"), i(0) })),
	s(
		"nlp",
		fmt('logging.NewLoggerP("{}", "{}"){}.Msg("{}"){}', {
			i(1, "name"),
			i(2, "path"),
			i(3, "other"),
			i(4, "msg"),
			i(0),
		})
	),

	s(
		"nle",
		fmt('logging.NewLoggerP("{}", "{}").Err({}){}.Msg("{}"){}', {
			i(1, "name"),
			i(2, "path"),
			i(3, "err"),
			i(4, "other"),
			i(5, "msg"),
			i(0),
		})
	),

	s("fs", fmt('fmt.Sprintf("{}", {}){}', { i(1, "fmt"), i(2, "args"), i(0) })),
	s("fsl", fmt('fmt.Sprintf("{}\\n", {}){}', { i(1, "fmt"), i(2, "args"), i(0) })),
	s("ffl", fmt('fmt.Printf("{}\\n", {}){}', { i(1, "fmt"), i(2, "args"), i(0) })),
}
