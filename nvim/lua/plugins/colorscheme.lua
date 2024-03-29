return {
  {
    'navarasu/onedark.nvim',
    lazy = false,    -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    enabled = false,
    -- Set our style and load our colorscheme
    config = function()
      local dark = require('onedark')
      dark.setup {
        style = 'darker'
      }
      dark.load()
    end,
  },
  {
    "pauchiner/pastelnight.nvim",
    lazy = false,
    priority = 1000,
    enabled = false,
    config = function()
      local theme = require('pastelnight')
      theme.setup({
        style = 'highContrast'
      })
      vim.api.nvim_command [[colorscheme pastelnight-highcontrast]]
    end
  },
  { 'nvim-tree/nvim-web-devicons', lazy = true },
  {
    'loganswartz/sunburn.nvim',
    dependencies = { 'loganswartz/polychrome.nvim' },
    -- you could do this, or use the standard vimscript `colorscheme sunburn`
    config = function()
      vim.cmd.colorscheme 'sunburn'
    end,
  }
}
