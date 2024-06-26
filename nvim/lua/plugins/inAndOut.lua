return {
  "ysmb-wtsg/in-and-out.nvim",
  config = function()
    local i = require("in-and-out")
    vim.keymap.set("i", "<C-CR>", i.in_and_out)
  end,
}
