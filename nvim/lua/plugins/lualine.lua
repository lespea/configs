return {
  'nvim-lualine/lualine.nvim',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
    'folke/noice.nvim',
  },
  event = { "BufReadPost", "BufNewFile" },
  config = function()
    local colors = require("oldworld.palette")

    local modecolor = {
      n = colors.bright_green,
      i = colors.lavender,
      v = colors.purple,
      ["␖"] = colors.purple,
      V = colors.red,
      c = colors.yellow,
      no = colors.red,
      s = colors.yellow,
      S = colors.yellow,
      ["␓"] = colors.yellow,
      ic = colors.yellow,
      R = colors.bright_red,
      Rv = colors.purple,
      cv = colors.red,
      ce = colors.red,
      r = colors.red,
      rm = colors.red,
      ["r?"] = colors.cyan,
      ["!"] = colors.red,
      t = colors.bright_red,
    }

    local modes = {
      "mode",
      color = function()
        local mode_color = modecolor
        return { bg = mode_color[vim.fn.mode()], fg = colors.bg_dark, gui = "bold" }
      end,
      separator = { left = "", right = "" },
    }

    local theme = {
      normal = {
        a = { fg = colors.bg_dark, bg = colors.blue },
        b = { fg = colors.blue, bg = colors.white },
        c = { fg = colors.white, bg = colors.bg_dark },
        z = { fg = colors.white, bg = colors.bg_dark },
      },
      insert = { a = { fg = colors.bg_dark, bg = colors.orange } },
      visual = { a = { fg = colors.bg_dark, bg = colors.green } },
      replace = { a = { fg = colors.bg_dark, bg = colors.red } },
    }

    local function getLspName()
      local buf_clients = vim.lsp.buf_get_clients()
      local buf_ft = vim.bo.filetype
      if next(buf_clients) == nil then
        return "  No servers"
      end
      local buf_client_names = {}

      for _, client in pairs(buf_clients) do
        if client.name ~= "null-ls" then
          table.insert(buf_client_names, client.name)
        end
      end

      local lint_s, lint = pcall(require, "lint")
      if lint_s then
        for ft_k, ft_v in pairs(lint.linters_by_ft) do
          if type(ft_v) == "table" then
            for _, linter in ipairs(ft_v) do
              if buf_ft == ft_k then
                table.insert(buf_client_names, linter)
              end
            end
          elseif type(ft_v) == "string" then
            if buf_ft == ft_k then
              table.insert(buf_client_names, ft_v)
            end
          end
        end
      end

      local ok, conform = pcall(require, "conform")
      local formatters = table.concat(conform.list_formatters_for_buffer(), " ")
      if ok then
        for formatter in formatters:gmatch("%w+") do
          if formatter then
            table.insert(buf_client_names, formatter)
          end
        end
      end

      local hash = {}
      local unique_client_names = {}

      for _, v in ipairs(buf_client_names) do
        if not hash[v] then
          unique_client_names[#unique_client_names + 1] = v
          hash[v] = true
        end
      end
      local language_servers = table.concat(unique_client_names, ", ")

      return "  " .. language_servers
    end

    local macro = {
      require("noice").api.status.mode.get,
      cond = require("noice").api.status.mode.has,
      color = { fg = colors.red, bg = colors.bg_dark, gui = "italic,bold" },
    }

    local dia = {
      "diagnostics",
      sources = { "nvim_diagnostic" },
      symbols = { error = " ", warn = " ", info = " ", hint = " " },
      diagnostics_color = {
        error = { fg = colors.red },
        warn = { fg = colors.yellow },
        info = { fg = colors.purple },
        hint = { fg = colors.cyan },
      },
      color = { bg = colors.gray2, fg = colors.blue, gui = "bold" },
      separator = { left = "" },
    }

    local lsp = {
      function()
        return getLspName()
      end,
      separator = { left = "", right = "" },
      color = { bg = colors.purple, fg = colors.bg, gui = "italic,bold" },
    }

    require("lualine").setup({
      options = {
        icons_enabled = true,
        theme = theme,
      },
      sections = {
        lualine_a = { 'hostname', modes },
        lualine_b = { 'branch', 'diff', 'diagnostics' },
        lualine_c = { 'filename', 'lsp_progress' },
        lualine_x = {
          '%b/0x%B',
          'encoding',
          { 'fileformat', icons_enabled = false },
          'filetype',
        },
        lualine_y = { 'progress', macro },
        lualine_z = { 'location', dia, lsp },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { 'filename' },
        lualine_x = { 'location' },
        lualine_y = {},
        lualine_z = {},
      },
      tabline = {},
      extensions = {},
    })
  end
}
