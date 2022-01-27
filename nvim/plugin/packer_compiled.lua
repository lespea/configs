-- Automatically generated packer.nvim plugin loader code

if vim.api.nvim_call_function('has', {'nvim-0.5'}) ~= 1 then
  vim.api.nvim_command('echohl WarningMsg | echom "Invalid Neovim version for packer.nvim! | echohl None"')
  return
end

vim.api.nvim_command('packadd packer.nvim')

local no_errors, error_msg = pcall(function()

  local time
  local profile_info
  local should_profile = false
  if should_profile then
    local hrtime = vim.loop.hrtime
    profile_info = {}
    time = function(chunk, start)
      if start then
        profile_info[chunk] = hrtime()
      else
        profile_info[chunk] = (hrtime() - profile_info[chunk]) / 1e6
      end
    end
  else
    time = function(chunk, start) end
  end
  
local function save_profiles(threshold)
  local sorted_times = {}
  for chunk_name, time_taken in pairs(profile_info) do
    sorted_times[#sorted_times + 1] = {chunk_name, time_taken}
  end
  table.sort(sorted_times, function(a, b) return a[2] > b[2] end)
  local results = {}
  for i, elem in ipairs(sorted_times) do
    if not threshold or threshold and elem[2] > threshold then
      results[i] = elem[1] .. ' took ' .. elem[2] .. 'ms'
    end
  end

  _G._packer = _G._packer or {}
  _G._packer.profile_output = results
end

time([[Luarocks path setup]], true)
local package_path_str = "/home/adam/.cache/nvim/packer_hererocks/2.0.5/share/lua/5.1/?.lua;/home/adam/.cache/nvim/packer_hererocks/2.0.5/share/lua/5.1/?/init.lua;/home/adam/.cache/nvim/packer_hererocks/2.0.5/lib/luarocks/rocks-5.1/?.lua;/home/adam/.cache/nvim/packer_hererocks/2.0.5/lib/luarocks/rocks-5.1/?/init.lua"
local install_cpath_pattern = "/home/adam/.cache/nvim/packer_hererocks/2.0.5/lib/lua/5.1/?.so"
if not string.find(package.path, package_path_str, 1, true) then
  package.path = package.path .. ';' .. package_path_str
end

if not string.find(package.cpath, install_cpath_pattern, 1, true) then
  package.cpath = package.cpath .. ';' .. install_cpath_pattern
end

time([[Luarocks path setup]], false)
time([[try_loadstring definition]], true)
local function try_loadstring(s, component, name)
  local success, result = pcall(loadstring(s), name, _G.packer_plugins[name])
  if not success then
    vim.schedule(function()
      vim.api.nvim_notify('packer.nvim: Error running ' .. component .. ' for ' .. name .. ': ' .. result, vim.log.levels.ERROR, {})
    end)
  end
  return result
end

time([[try_loadstring definition]], false)
time([[Defining packer_plugins]], true)
_G.packer_plugins = {
  ["comment-box.nvim"] = {
    config = { "require('confs/plugins/box')" },
    loaded = true,
    path = "/home/adam/.local/share/nvim/site/pack/packer/start/comment-box.nvim",
    url = "https://github.com/LudoPinelli/comment-box.nvim"
  },
  ["dirbuf.nvim"] = {
    loaded = true,
    path = "/home/adam/.local/share/nvim/site/pack/packer/start/dirbuf.nvim",
    url = "https://github.com/elihunter173/dirbuf.nvim"
  },
  ["fidget.nvim"] = {
    config = { "\27LJ\1\0020\0\0\2\0\3\0\0054\0\0\0%\1\1\0>\0\2\0027\0\2\0@\0\1\0\nsetup\vfidget\frequire\0" },
    loaded = true,
    path = "/home/adam/.local/share/nvim/site/pack/packer/start/fidget.nvim",
    url = "https://github.com/j-hui/fidget.nvim"
  },
  ["goimpl.nvim"] = {
    config = { "require('confs/plugins/goimpl')" },
    load_after = {},
    loaded = true,
    needs_bufread = false,
    path = "/home/adam/.local/share/nvim/site/pack/packer/opt/goimpl.nvim",
    url = "https://github.com/edolphin-ydf/goimpl.nvim"
  },
  ["hop.nvim"] = {
    config = { "require('confs/plugins/hop')" },
    loaded = true,
    path = "/home/adam/.local/share/nvim/site/pack/packer/start/hop.nvim",
    url = "https://github.com/phaazon/hop.nvim"
  },
  lsp = {
    loaded = true,
    path = "/home/adam/.local/share/nvim/site/pack/packer/start/lsp",
    url = "https://github.com/neovim/nvim-lspconfig"
  },
  lua_dev = {
    loaded = true,
    path = "/home/adam/.local/share/nvim/site/pack/packer/start/lua_dev",
    url = "https://github.com/folke/lua-dev.nvim"
  },
  ["lualine.nvim"] = {
    config = { "require('confs/plugins/lualine')" },
    load_after = {},
    loaded = true,
    needs_bufread = false,
    path = "/home/adam/.local/share/nvim/site/pack/packer/opt/lualine.nvim",
    url = "https://github.com/nvim-lualine/lualine.nvim"
  },
  material = {
    after = { "telescope", "lualine.nvim", "treesitter" },
    loaded = true,
    only_config = true
  },
  ["null-ls.nvim"] = {
    config = { "require('confs/plugins/lsp')" },
    load_after = {},
    loaded = true,
    needs_bufread = false,
    path = "/home/adam/.local/share/nvim/site/pack/packer/opt/null-ls.nvim",
    url = "https://github.com/jose-elias-alvarez/null-ls.nvim"
  },
  ["nvim-tree.lua"] = {
    config = { "require('confs/plugins/tree')" },
    loaded = true,
    path = "/home/adam/.local/share/nvim/site/pack/packer/start/nvim-tree.lua",
    url = "https://github.com/kyazdani42/nvim-tree.lua"
  },
  ["nvim-treesitter"] = {
    loaded = true,
    path = "/home/adam/.local/share/nvim/site/pack/packer/start/nvim-treesitter",
    url = "https://github.com/nvim-treesitter/nvim-treesitter"
  },
  ["nvim-treesitter-refactor"] = {
    load_after = {},
    loaded = true,
    needs_bufread = false,
    path = "/home/adam/.local/share/nvim/site/pack/packer/opt/nvim-treesitter-refactor",
    url = "https://github.com/nvim-treesitter/nvim-treesitter-refactor"
  },
  ["nvim-web-devicons"] = {
    loaded = true,
    path = "/home/adam/.local/share/nvim/site/pack/packer/start/nvim-web-devicons",
    url = "https://github.com/kyazdani42/nvim-web-devicons"
  },
  ["packer.nvim"] = {
    loaded = true,
    path = "/home/adam/.local/share/nvim/site/pack/packer/start/packer.nvim",
    url = "https://github.com/wbthomason/packer.nvim"
  },
  ["plenary.nvim"] = {
    loaded = true,
    path = "/home/adam/.local/share/nvim/site/pack/packer/start/plenary.nvim",
    url = "https://github.com/nvim-lua/plenary.nvim"
  },
  ["popup.nvim"] = {
    loaded = true,
    path = "/home/adam/.local/share/nvim/site/pack/packer/start/popup.nvim",
    url = "https://github.com/nvim-lua/popup.nvim"
  },
  ["targets.vim"] = {
    loaded = true,
    path = "/home/adam/.local/share/nvim/site/pack/packer/start/targets.vim",
    url = "https://github.com/wellle/targets.vim"
  },
  telescope = {
    after = { "telescope-fzf-native.nvim", "telescope-coc.nvim", "goimpl.nvim" },
    config = { "require('confs/plugins/telescope')" },
    load_after = {},
    loaded = true,
    needs_bufread = true,
    path = "/home/adam/.local/share/nvim/site/pack/packer/opt/telescope",
    url = "https://github.com/nvim-telescope/telescope.nvim"
  },
  ["telescope-coc.nvim"] = {
    config = { "require('confs/plugins/telescope_coc')" },
    load_after = {},
    loaded = true,
    needs_bufread = false,
    path = "/home/adam/.local/share/nvim/site/pack/packer/opt/telescope-coc.nvim",
    url = "https://github.com/fannheyward/telescope-coc.nvim"
  },
  ["telescope-fzf-native.nvim"] = {
    config = { "require('confs/plugins/telescope_fzf')" },
    load_after = {},
    loaded = true,
    needs_bufread = false,
    path = "/home/adam/.local/share/nvim/site/pack/packer/opt/telescope-fzf-native.nvim",
    url = "https://github.com/nvim-telescope/telescope-fzf-native.nvim"
  },
  ["telescope.nvim"] = {
    loaded = true,
    path = "/home/adam/.local/share/nvim/site/pack/packer/start/telescope.nvim",
    url = "https://github.com/nvim-telescope/telescope.nvim"
  },
  treesitter = {
    after = { "nvim-treesitter-refactor", "goimpl.nvim" },
    config = { "require('confs/plugins/treesitter')" },
    load_after = {},
    loaded = true,
    needs_bufread = true,
    path = "/home/adam/.local/share/nvim/site/pack/packer/opt/treesitter",
    url = "https://github.com/nvim-treesitter/nvim-treesitter"
  },
  ["trouble.nvim"] = {
    config = { "require('confs/plugins/trouble')" },
    load_after = {},
    loaded = true,
    needs_bufread = false,
    path = "/home/adam/.local/share/nvim/site/pack/packer/opt/trouble.nvim",
    url = "https://github.com/folke/trouble.nvim"
  },
  ["vim-move"] = {
    loaded = true,
    path = "/home/adam/.local/share/nvim/site/pack/packer/start/vim-move",
    url = "https://github.com/matze/vim-move"
  },
  ["vim-repeat"] = {
    loaded = true,
    path = "/home/adam/.local/share/nvim/site/pack/packer/start/vim-repeat",
    url = "https://github.com/tpope/vim-repeat"
  },
  ["vim-speeddating"] = {
    loaded = true,
    path = "/home/adam/.local/share/nvim/site/pack/packer/start/vim-speeddating",
    url = "https://github.com/tpope/vim-speeddating"
  },
  ["vim-surround"] = {
    loaded = true,
    path = "/home/adam/.local/share/nvim/site/pack/packer/start/vim-surround",
    url = "https://github.com/tpope/vim-surround"
  },
  ["vim-unimpaired"] = {
    loaded = true,
    path = "/home/adam/.local/share/nvim/site/pack/packer/start/vim-unimpaired",
    url = "https://github.com/tpope/vim-unimpaired"
  },
  ["vim-visual-increment"] = {
    loaded = true,
    path = "/home/adam/.local/share/nvim/site/pack/packer/start/vim-visual-increment",
    url = "https://github.com/triglav/vim-visual-increment"
  },
  vimp = {
    loaded = true,
    path = "/home/adam/.local/share/nvim/site/pack/packer/start/vimp",
    url = "https://github.com/svermeulen/vimpeccable"
  }
}

time([[Defining packer_plugins]], false)
-- Config for: hop.nvim
time([[Config for hop.nvim]], true)
require('confs/plugins/hop')
time([[Config for hop.nvim]], false)
-- Config for: material
time([[Config for material]], true)
require('confs/plugins/material')
time([[Config for material]], false)
-- Config for: fidget.nvim
time([[Config for fidget.nvim]], true)
try_loadstring("\27LJ\1\0020\0\0\2\0\3\0\0054\0\0\0%\1\1\0>\0\2\0027\0\2\0@\0\1\0\nsetup\vfidget\frequire\0", "config", "fidget.nvim")
time([[Config for fidget.nvim]], false)
-- Config for: comment-box.nvim
time([[Config for comment-box.nvim]], true)
require('confs/plugins/box')
time([[Config for comment-box.nvim]], false)
-- Config for: nvim-tree.lua
time([[Config for nvim-tree.lua]], true)
require('confs/plugins/tree')
time([[Config for nvim-tree.lua]], false)
-- Load plugins in order defined by `after`
time([[Sequenced loading]], true)
vim.cmd [[ packadd vimp ]]
vim.cmd [[ packadd lualine.nvim ]]

-- Config for: lualine.nvim
require('confs/plugins/lualine')

vim.cmd [[ packadd treesitter ]]

-- Config for: treesitter
require('confs/plugins/treesitter')

vim.cmd [[ packadd nvim-treesitter-refactor ]]
vim.cmd [[ packadd telescope ]]

-- Config for: telescope
require('confs/plugins/telescope')

vim.cmd [[ packadd telescope-fzf-native.nvim ]]

-- Config for: telescope-fzf-native.nvim
require('confs/plugins/telescope_fzf')

vim.cmd [[ packadd goimpl.nvim ]]

-- Config for: goimpl.nvim
require('confs/plugins/goimpl')

vim.cmd [[ packadd telescope-coc.nvim ]]

-- Config for: telescope-coc.nvim
require('confs/plugins/telescope_coc')

vim.cmd [[ packadd lsp ]]
vim.cmd [[ packadd trouble.nvim ]]

-- Config for: trouble.nvim
require('confs/plugins/trouble')

vim.cmd [[ packadd lua_dev ]]
vim.cmd [[ packadd null-ls.nvim ]]

-- Config for: null-ls.nvim
require('confs/plugins/lsp')

time([[Sequenced loading]], false)
if should_profile then save_profiles() end

end)

if not no_errors then
  vim.api.nvim_command('echohl ErrorMsg | echom "Error in packer_compiled: '..error_msg..'" | echom "Please check your config for correctness" | echohl None')
end
