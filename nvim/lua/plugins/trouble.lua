return {
  'folke/trouble.nvim',
  opts = {},
  init = function()
    local t = require('trouble')
    local set = vim.keymap.set

    set("n", "<leader>xx", function() t.toggle() end)
    set("n", "<leader>xw", function() t.toggle("workspace_diagnostics") end)
    set("n", "<leader>xd", function() t.toggle("document_diagnostics") end)
    set("n", "<leader>xq", function() t.toggle("quickfix") end)
    set("n", "<leader>xl", function() t.toggle("loclist") end)

    set("n", "gR", function() t.toggle("lsp_references") end)

    set("n", "<C-S-j>", function() t.next({ skip_groups = true, jump = true }); end)
    set("n", "<C-S-k>", function() t.previous({ skip_groups = true, jump = true }); end)
  end
}
