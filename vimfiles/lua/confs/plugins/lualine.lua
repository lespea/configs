require('lualine').setup({
	options = {
		icons_enabled = true,
		theme = 'material'
	},
	sections = {
		lualine_a = {
			'hostname',
			'mode'
		},
		lualine_b = {
			'branch',
			'diff',
			'diagnostics'
		},
		lualine_c = {
			'filename',
			'lsp_progress'
		},
		lualine_x = {
			'encoding',
			{
				'fileformat',
				icons_enabled = false
			},
			'filetype'
		},
		lualine_y = {
			'progress'
		},
		lualine_z = {
			'location'
		}
	},
	inactive_sections = {
		lualine_a = { },
		lualine_b = { },
		lualine_c = {
			'filename'
		},
		lualine_x = {
			'location'
		},
		lualine_y = { },
		lualine_z = { }
	},
	tabline = { },
	extensions = { }
})
return true
