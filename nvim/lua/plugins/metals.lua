return {
  'scalameta/nvim-metals',
  dependencies = {
    'nvim-lua/plenary.nvim'
  },
  ft = { 'scala', 'sbt', 'java' },
  config = function()
    local metals = require('metals')

    local conf = metals.bare_config()
    conf.settings = {
      showImplicitArguments = true,
      showInferredType = true,
      superMethodLensesEnabled = true,
      showImplicitConversionsAndClasses = true,
    }

    conf.capabilities = require("lsp-zero").default_capabilities()

    -- metals.initialize_or_attach(conf)
    local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
    vim.api.nvim_create_autocmd("FileType", {
      -- NOTE: You may or may not want java included here. You will need it if you
      -- want basic Java support but it may also conflict if you are using
      -- something like nvim-jdtls which also works on a java filetype autocmd.
      pattern = { "scala", "sbt", "java" },
      callback = function()
        require("metals").initialize_or_attach(conf)
      end,
      group = nvim_metals_group,
    })
  end
}
