return {
  "LunarVim/bigfile.nvim",
  event = "VeryLazy",
  config = function()
    require('bigfile').setup {
      filesize = 10,
    }
  end
}
