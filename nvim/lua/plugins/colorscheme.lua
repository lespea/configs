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
    config = function()
      local theme = require('pastelnight')
      theme.setup()
      vim.api.nvim_command [[colorscheme pastelnight]]
    end
  },
  { 'kyazdani42/nvim-web-devicons', lazy = true },
}
