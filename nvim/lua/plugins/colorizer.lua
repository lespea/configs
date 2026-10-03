return {
	"catgoose/nvim-colorizer.lua",
	event = "BufReadPost",
	opts = {
		-- Terminal buffers (lazygit etc.) redraw in place, so highlights get stuck on stale text
		filetypes = { "*", "!toggleterm", "!snacks_terminal" },
		buftypes = { "!terminal" },
		user_default_options = {
			names = false,
		},
	},
}
