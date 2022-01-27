local fn, api = vim.fn, vim.api
local exec = api.nvim_command
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
	fn.system({
		'git',
		'clone',
		'https://github.com/wbthomason/packer.nvim',
		install_path
	})
	exec('packadd packer.nvim')
end
local ok, packer = pcall(require, 'packer')
if not ok then
	return
end
local lsp = 'lsp'
local luaDev = 'lua_dev'
local material = 'material'
local tele = 'telescope'
local trees = 'treesitter'
local vimp = 'vimp'
local reqDevIcons = 'kyazdani42/nvim-web-devicons'
local reqPlenary = 'nvim-lua/plenary.nvim'
return packer.startup(function(use)
	use('wbthomason/packer.nvim');
	use({
		'svermeulen/vimpeccable',
		as = vimp
	});
	use({
		'marko-cerovac/material.nvim',
		config = [[require('confs/plugins/material')]],
		as = material
	});
	use({
		'nvim-lualine/lualine.nvim',
		config = [[require('confs/plugins/lualine')]],
		requires = reqDevIcons,
		after = material
	});
	use({
		'nvim-treesitter/nvim-treesitter',
		config = [[require('confs/plugins/treesitter')]],
		run = ':TSUpdate',
		as = trees,
		after = material
	});
	use({
		'nvim-treesitter/nvim-treesitter-refactor',
		after = trees
	});
	use({
		'neovim/nvim-lspconfig',
		as = lsp
	});
	use({
		'folke/lua-dev.nvim',
		as = luaDev
	});
	use({
		'jose-elias-alvarez/null-ls.nvim',
		config = [[require('confs/plugins/lsp')]],
		after = {
			lsp,
			luaDev
		}
	});
	use({
		'j-hui/fidget.nvim',
		config = function()
			return require('fidget').setup()
		end
	});
	use({
		'folke/trouble.nvim',
		config = [[require('confs/plugins/trouble')]],
		after = lsp
	});
	use({
		'kyazdani42/nvim-tree.lua',
		config = [[require('confs/plugins/tree')]],
		requires = reqDevIcons
	});
	use('elihunter173/dirbuf.nvim');
	use({
		'nvim-telescope/telescope.nvim',
		config = [[require('confs/plugins/telescope')]],
		as = tele,
		requires = reqPlenary,
		after = {
			material,
			vimp
		}
	});
	use({
		'nvim-telescope/telescope-fzf-native.nvim',
		config = [[require('confs/plugins/telescope_fzf')]],
		run = 'make',
		after = tele
	});
	use({
		'fannheyward/telescope-coc.nvim',
		config = [[require('confs/plugins/telescope_coc')]],
		after = tele
	});
	use({
		'phaazon/hop.nvim',
		config = [[require('confs/plugins/hop')]],
		branch = 'v1'
	});
	use('matze/vim-move');
	use({
		'LudoPinelli/comment-box.nvim',
		config = [[require('confs/plugins/box')]]
	});
	use('wellle/targets.vim');
	use('tpope/vim-speeddating');
	use('tpope/vim-surround');
	use('tpope/vim-unimpaired');
	use('triglav/vim-visual-increment')
	use('tpope/vim-repeat');
	use({
		'edolphin-ydf/goimpl.nvim',
		config = [[require('confs/plugins/goimpl')]],
		after = {
			tele,
			trees,
			vimp
		},
		requires = {
			reqPlenary,
			'nvim-lua/popup.nvim',
			'nvim-telescope/telescope.nvim',
			'nvim-treesitter/nvim-treesitter'
		}
	})
	return true
end)
