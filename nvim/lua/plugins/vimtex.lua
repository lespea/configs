return {
  'lervag/vimtex',
  lazy = false,
  config = function()
    vim.g.vimtex_compiler_method = "tectonic"
    vim.g.vimtex_view_general_viewer = 'okular'
    vim.g.vimtex_view_general_options = '--unique file:@pdf\\#src:@line@tex'
  end
}
