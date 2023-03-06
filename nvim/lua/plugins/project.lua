return {
  'ahmedkhalf/project.nvim',
  config = function()
    require("project_nvim").setup {
      patterns = {
        ".git",
        "Makefile",
        "build.sbt",
        "cargo.toml",
        "go.mod",
        "package.json",
        "requirements.txt",
      },
    }
  end,
}
