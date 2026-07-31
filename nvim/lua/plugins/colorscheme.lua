return {
	{
		"dgox16/oldworld.nvim",
		lazy = false,
		priority = 1000,
		enabled = true,
		config = function()
			require("oldworld").setup({
				integrations = {
					neo_tree = false,
					snacks = false,
				},
			})

			vim.cmd.colorscheme("oldworld")

			local c = require("oldworld.palette")

			vim.api.nvim_set_hl(0, "LspInlayHint", { fg = c.subtext4 })
			vim.api.nvim_set_hl(0, "CursorLine", { bg = c.gray2 })
			vim.api.nvim_set_hl(0, "NeoTreeCursorLine", { bg = c.gray2 })

			-- Barbar tabline highlights tailored for oldworld palette (with powerline support)
			local bg_tabline = c.bg_dark
			local bg_current = c.gray2
			local bg_inactive = c.gray0
			local bg_visible = c.gray1

			local barbar_highlights = {
				-- Tabline fill (empty bar background)
				BufferTabpageFill = { bg = bg_tabline, fg = c.subtext4 },
				BufferTabpages = { bg = bg_tabline, fg = c.blue, bold = true },
				BufferTabpagesSep = { bg = bg_tabline, fg = c.subtext4, bold = true },
				BufferOffset = { bg = bg_tabline, fg = c.subtext4 },

				-- Current / Active tab (highest contrast, easy to spot!)
				BufferCurrent = { bg = bg_current, fg = c.fg, bold = true },
				BufferCurrentIndex = { bg = bg_current, fg = c.blue, bold = true },
				BufferCurrentMod = { bg = bg_current, fg = c.yellow, bold = true },
				BufferCurrentSign = { bg = bg_current, fg = bg_tabline },
				BufferCurrentSignRight = { bg = bg_tabline, fg = bg_current },
				BufferCurrentTarget = { bg = bg_current, fg = c.red, bold = true },
				BufferCurrentBtn = { bg = bg_current, fg = c.subtext4 },
				BufferCurrentIcon = { bg = bg_current, fg = c.fg },
				BufferCurrentERROR = { bg = bg_current, fg = c.red, bold = true },
				BufferCurrentWARN = { bg = bg_current, fg = c.yellow, bold = true },
				BufferCurrentINFO = { bg = bg_current, fg = c.blue, bold = true },
				BufferCurrentHINT = { bg = bg_current, fg = c.cyan, bold = true },
				BufferCurrentADDED = { bg = bg_current, fg = c.green, bold = true },
				BufferCurrentCHANGED = { bg = bg_current, fg = c.yellow, bold = true },
				BufferCurrentDELETED = { bg = bg_current, fg = c.red, bold = true },

				-- Inactive tabs (dimmed, receding into background)
				BufferInactive = { bg = bg_inactive, fg = c.subtext4 },
				BufferInactiveIndex = { bg = bg_inactive, fg = c.subtext4 },
				BufferInactiveMod = { bg = bg_inactive, fg = c.subtext3 },
				BufferInactiveSign = { bg = bg_inactive, fg = bg_tabline },
				BufferInactiveSignRight = { bg = bg_tabline, fg = bg_inactive },
				BufferInactiveTarget = { bg = bg_inactive, fg = c.red, bold = true },
				BufferInactiveBtn = { bg = bg_inactive, fg = c.subtext4 },
				BufferInactiveIcon = { bg = bg_inactive, fg = c.subtext4 },
				BufferInactiveERROR = { bg = bg_inactive, fg = c.red },
				BufferInactiveWARN = { bg = bg_inactive, fg = c.yellow },
				BufferInactiveINFO = { bg = bg_inactive, fg = c.blue },
				BufferInactiveHINT = { bg = bg_inactive, fg = c.cyan },
				BufferInactiveADDED = { bg = bg_inactive, fg = c.green },
				BufferInactiveCHANGED = { bg = bg_inactive, fg = c.yellow },
				BufferInactiveDELETED = { bg = bg_inactive, fg = c.red },

				-- Visible tabs (open in other windows/splits, but not current)
				BufferVisible = { bg = bg_visible, fg = c.subtext2, bold = true },
				BufferVisibleIndex = { bg = bg_visible, fg = c.subtext2, bold = true },
				BufferVisibleMod = { bg = bg_visible, fg = c.yellow, bold = true },
				BufferVisibleSign = { bg = bg_visible, fg = bg_tabline },
				BufferVisibleSignRight = { bg = bg_tabline, fg = bg_visible },
				BufferVisibleTarget = { bg = bg_visible, fg = c.red, bold = true },
				BufferVisibleBtn = { bg = bg_visible, fg = c.subtext4 },
				BufferVisibleIcon = { bg = bg_visible, fg = c.subtext2 },
				BufferVisibleERROR = { bg = bg_visible, fg = c.red, bold = true },
				BufferVisibleWARN = { bg = bg_visible, fg = c.yellow, bold = true },
				BufferVisibleINFO = { bg = bg_visible, fg = c.blue, bold = true },
				BufferVisibleHINT = { bg = bg_visible, fg = c.cyan, bold = true },
				BufferVisibleADDED = { bg = bg_visible, fg = c.green },
				BufferVisibleCHANGED = { bg = bg_visible, fg = c.yellow },
				BufferVisibleDELETED = { bg = bg_visible, fg = c.red },

				-- Alternate buffer tab
				BufferAlternate = { bg = bg_inactive, fg = c.subtext4 },
				BufferAlternateIndex = { bg = bg_inactive, fg = c.subtext4 },
				BufferAlternateMod = { bg = bg_inactive, fg = c.subtext3 },
				BufferAlternateSign = { bg = bg_inactive, fg = bg_tabline },
				BufferAlternateSignRight = { bg = bg_tabline, fg = bg_inactive },
				BufferAlternateTarget = { bg = bg_inactive, fg = c.red, bold = true },
				BufferAlternateBtn = { bg = bg_inactive, fg = c.subtext4 },
				BufferAlternateIcon = { bg = bg_inactive, fg = c.subtext4 },
				BufferAlternateERROR = { bg = bg_inactive, fg = c.red },
				BufferAlternateWARN = { bg = bg_inactive, fg = c.yellow },
				BufferAlternateINFO = { bg = bg_inactive, fg = c.blue },
				BufferAlternateHINT = { bg = bg_inactive, fg = c.cyan },
				BufferAlternateADDED = { bg = bg_inactive, fg = c.green },
				BufferAlternateCHANGED = { bg = bg_inactive, fg = c.yellow },
				BufferAlternateDELETED = { bg = bg_inactive, fg = c.red },
			}

			for group, hl in pairs(barbar_highlights) do
				vim.api.nvim_set_hl(0, group, hl)
			end

			-- vim.api.nvim_set_hl(0, "Ibl1", { fg = c.gray2 })
			-- vim.api.nvim_set_hl(0, "Ibl2", { fg = c.gray4 })
		end,
	},
	{ "nvim-tree/nvim-web-devicons", lazy = true },
	{
		"rachartier/tiny-devicons-auto-colors.nvim",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
			"dgox16/oldworld.nvim",
		},
		event = "VeryLazy",
		config = function()
			local c = require("oldworld.palette")
			require("tiny-devicons-auto-colors").setup({
				colors = {
					c.red,
					c.green,
					c.yellow,
					c.purple,
					c.magenta,
					c.orange,
					c.blue,
					c.cyan,
				},
			})
		end,
	},
}
