local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
	PACKER_BOOTSTRAP = fn.system({
		"git",
		"clone",
		"--depth",
		"1",
		"https://github.com/wbthomason/packer.nvim",
		install_path,
	})
	print("Installing packer close and reopen Neovim...")
	vim.api.nvim_command("packadd packer.nvim")
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
local packer_user_config_group = vim.api.nvim_create_augroup("Packer", { clear = true })
vim.api.nvim_create_autocmd("BufWritePost", {
	pattern = "plugins.lua",
	command = "source <afile> | PackerSync",
	group = packer_user_config_group,
})

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
	vim.notify("packer not found!")
	return
end

-- Have packer use a popup window
packer.init({
	display = {
		open_fn = function()
			return require("packer.util").float({})
		end,
	},
})

-- Install your plugins here
return packer.startup(function(use)
	-- My plugins here
	use("wbthomason/packer.nvim") -- Have packer manage itself
	use("nvim-lua/popup.nvim") -- An implementation of the Popup API from vim in Neovim
	use("nvim-lua/plenary.nvim") -- Useful lua functions used ny lots of plugins
	use("lewis6991/impatient.nvim") -- cache lua modules for better startup time

  -- readline
  use("tpope/vim-rsi")

	-- textobjects
	use({ "kana/vim-textobj-entire", requires = { "kana/vim-textobj-user" } })

	-- Keymaps
	use("folke/which-key.nvim")

	-- Theme
	use("EdenEast/nightfox.nvim")

  -- Dashboard
  use("goolord/alpha-nvim")

	-- completions
	use("hrsh7th/nvim-cmp") -- The completion plugin
	use("hrsh7th/cmp-buffer") -- buffer completions
	use("hrsh7th/cmp-path") -- path completions
	use("hrsh7th/cmp-cmdline") -- cmdline completions
	use("hrsh7th/cmp-nvim-lsp") -- LSP completions
	use("hrsh7th/cmp-nvim-lua") -- neovim lua config completions
	use("saadparwaiz1/cmp_luasnip") -- snippet completions

	-- snippets
	use("L3MON4D3/LuaSnip") --snippet engine
	use("rafamadriz/friendly-snippets") -- a bunch of snippets to use

	-- LSP
	use("neovim/nvim-lspconfig") -- enable LSP
	use("williamboman/nvim-lsp-installer") -- auto install language servers
	use("j-hui/fidget.nvim") -- language server progress indicator
	use("simrat39/symbols-outline.nvim")
	use("mfussenegger/nvim-jdtls") -- advanced jdtls functions

	-- Lint, Format, etc
	use("jose-elias-alvarez/null-ls.nvim")

	-- Treesitter
	use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" }) -- syntax highlights

	-- Components
	use("nvim-telescope/telescope.nvim") -- telescope
	use("nvim-telescope/telescope-ui-select.nvim")
	use("akinsho/toggleterm.nvim") -- terminal
	use("nvim-lualine/lualine.nvim") -- status line
	use("akinsho/bufferline.nvim") -- buffer line

	-- Comment
	use("numToStr/Comment.nvim") -- Easily comment stuff
	use("JoosepAlviste/nvim-ts-context-commentstring") -- context commenting

	-- Indentline indicator
	use("lukas-reineke/indent-blankline.nvim")

	-- Autopairs
	use("windwp/nvim-autopairs") -- Autopairs, integrates with both cmp and treesitter

	-- NvimTree
	use({ "kyazdani42/nvim-tree.lua", requires = { "kyazdani42/nvim-web-devicons" } }) -- Filetree and Icons

	-- Git
	use("lewis6991/gitsigns.nvim")

	-- Automatically set up your configuration after cloning packer.nvim
	-- Put this at the end after all plugins
	if PACKER_BOOTSTRAP then
		require("packer").sync()
	end
end)
