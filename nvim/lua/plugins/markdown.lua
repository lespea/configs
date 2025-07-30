return {
  {
    'MeanderingProgrammer/markdown.nvim',
    name = 'render-markdown', -- Only needed if you have another plugin named markdown.nvim
    enabled = false,
    config = function()
      require('render-markdown').setup({
        latex = { enabled = false }
      })
    end,
  },
  {
    "OXY2DEV/markview.nvim",
    enabled = true,
    lazy = false, -- Recommended
    dependencies = {
      "nvim-tree/nvim-web-devicons"
    },
    -- For `nvim-treesitter` users.
    priority = 49,
  }
}
