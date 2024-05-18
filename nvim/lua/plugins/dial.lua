return {
  'monaqa/dial.nvim',
  config = function()
    local d = require("dial.map")
    vim.keymap.set("n", "<C-a>", function()
      d.manipulate("increment", "normal")
    end)
    vim.keymap.set("n", "<C-x>", function()
      d.manipulate("decrement", "normal")
    end)
    vim.keymap.set("n", "g<C-a>", function()
      d.manipulate("increment", "gnormal")
    end)
    vim.keymap.set("n", "g<C-x>", function()
      d.manipulate("decrement", "gnormal")
    end)

    vim.keymap.set("v", "<C-a>", function()
      d.manipulate("increment", "visual")
    end)
    vim.keymap.set("v", "<C-x>", function()
      d.manipulate("decrement", "visual")
    end)
    vim.keymap.set("v", "g<C-a>", function()
      d.manipulate("increment", "gvisual")
    end)
    vim.keymap.set("v", "g<C-x>", function()
      d.manipulate("decrement", "gvisual")
    end)

    local augend = require("dial.augend")
    require("dial.config").augends:register_group {
      -- default augends used when no group name is specified
      default = {
        augend.integer.alias.decimal,  -- nonnegative decimal number (0, 1, 2, 3, ...)
        augend.integer.alias.hex,      -- nonnegative hex number  (0x01, 0x1a1f, etc.)
        augend.constant.alias.bool,    -- bools (true <-> false)
        augend.date.alias["%Y-%m-%d"], -- date (2022/02/19, etc.)
      },
    }
  end
}
