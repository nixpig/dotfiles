local cmd = vim.cmd
local fn = vim.fn

local status, packer = pcall(require, 'packer')
if not status then
	print('Failed to load packer')
	return
end

-- Start packer in pop-up window
packer.init({
	display = {
		open_fn = function()
			return require("packer.util").float()
		end,
	},
})

cmd([[packadd packer.nvim]])


packer.startup(function(use)
	use 'nvim-lua/plenary.nvim'    -- Common utilities needed by plugins, e.g. Telescope
	use 'wbthomason/packer.nvim'   -- A use-package inspired plugin manager for Neovim
	use 'onsails/lspkind-nvim'     -- vscode-like pictograms for neovim lsp completion items
	use 'nvim-lualine/lualine.nvim' -- A blazing fast and easy to configure neovim statusline plugin written in pure lua
	use 'hrsh7th/nvim-cmp'         -- A completion plugin for neovim coded in Lua
	use 'ray-x/lsp_signature.nvim' -- lsp_signature.nvim is a Neovim plugin that shows the function signature when you type

	use({
		-- nvim-cmp source for neovim builtin LSP client
		'hrsh7th/cmp-nvim-lsp',
		-- nvim-cmp source for filepath
		'hrsh7th/cmp-path',
		-- nvim-cmp source for buffer words
		'hrsh7th/cmp-buffer',
		after = { 'hrsh7th/nvim-cmp' },
		requires = { 'hrsh7th/nvim-cmp' }
	})

	use 'simrat39/rust-tools.nvim'
	use 'neovim/nvim-lspconfig'                                                                    -- Quickstart configs for Nvim LSP
	use 'jose-elias-alvarez/null-ls.nvim'                                                          -- Use Neovim as a language server to inject LSP diagnostics, code actions, and more via Lua
	use 'williamboman/mason.nvim'                                                                  -- Portable package manager for Neovim that runs everywhere Neovim runs
	use 'williamboman/mason-lspconfig.nvim'                                                        -- Extension to mason.nvim that makes it easier to use lspconfig with mason.nvim
	use 'WhoIsSethDaniel/mason-tool-installer.nvim'                                                -- A tool installer for mason.nvim
	use 'glepnir/lspsaga.nvim'                                                                     -- improve neovim lsp experience
	use 'kyazdani42/nvim-web-devicons'                                                             -- Adds file type icons to Vim plugins
	use 'nvim-telescope/telescope.nvim'                                                            -- telescope.nvim is a highly extendable fuzzy finder over lists
	use 'nvim-telescope/telescope-file-browser.nvim'                                               -- File Browser extension for telescope.nvim
	use 'windwp/nvim-autopairs'                                                                    -- A super powerful autopair plugin for Neovim that supports multiple characters
	use 'windwp/nvim-ts-autotag'                                                                   -- Use treesitter to autoclose and autorename html tag, also works with TSX, JSX, etc...
	use 'norcalli/nvim-colorizer.lua'                                                              -- A high-performance color highlighter for Neovim
	use 'akinsho/nvim-bufferline.lua'                                                              -- A snazzy bufferline for Neovim
	use 'lewis6991/gitsigns.nvim'                                                                  -- Super fast git decorations implemented purely in Lua
	use 'dinhhuy258/git.nvim'                                                                      -- git.nvim is the simple clone of the plugin vim-fugitive which is written in Lua
	use 'catppuccin/nvim'                                                                          -- A clean, dark Neovim theme written in Lua, with support for lsp, treesitter and lots of plugins
	use 'christoomey/vim-tmux-navigator'                                                           --
	use 'mfussenegger/nvim-dap'                                                                    -- Debug Adapter Protocol client implementation for Neovim
	use 'mxsdev/nvim-dap-vscode-js'                                                                -- DAP adaptor for Node.js - JavaScript, TypeScript
	use 'leoluz/nvim-dap-go'                                                                       -- DAP adaptor for Go
	use 'jose-elias-alvarez/typescript.nvim'                                                       -- A Lua plugin, written in TypeScript, to write TypeScript (Lua optional)
	use { 'akinsho/git-conflict.nvim', tag = "*" }                                                 -- A plugin to visualise and resolve merge conflicts in neovim
	use 'nvim-treesitter/nvim-treesitter-refactor'                                                 -- Refactor module for nvim-treesitter
	use 'hiphish/rainbow-delimiters.nvim'
	use { 'lukas-reineke/indent-blankline.nvim', tag = "v2.20.8" }                                 -- Indent guides for Neovim
	use 'tpope/vim-repeat'                                                                         -- enable repeating supported plugin maps with "."
	use 'tpope/vim-unimpaired'                                                                     -- Pairs of handy bracket mappings
	use 'tpope/vim-surround'                                                                       -- Delete/change/add parentheses/quotes/XML-tags/much more with ease
	use 'tpope/vim-sleuth'                                                                         -- Heuristically set buffer options
	use 'rmagatti/alternate-toggler'                                                               -- A very small plugin for toggling alternate "boolean" values
	use 'duane9/nvim-rg'                                                                           -- Run ripgrep from Neovim/Vim
	use 'folke/which-key.nvim'                                                                     -- Create key bindings that stick
	use 'nvim-telescope/telescope-symbols.nvim'                                                    -- telescope-symbols provide its users with the ability of picking symbols and insert them at point
	use 'nvim-treesitter/nvim-treesitter-context'                                                  -- Lightweight alternative to context.vim implemented with nvim-treesitter
	use 'nvim-telescope/telescope-ui-select.nvim'                                                  -- It sets vim.ui.select to telescope. That means for example that neovim core stuff can fill the telescope picker.
	use 'debugloop/telescope-undo.nvim'                                                            -- Telescope extension to browse and edit undo history
	-- use { 'j-hui/fidget.nvim', tag = 'legacy' }                                                    -- Standalone UI for nvim-lsp progress
	use 'MunifTanjim/prettier.nvim'                                                                -- Format your code using Prettier
	use { 'L3MON4D3/LuaSnip', run = 'make install_jsregexp' }                                      -- Snippet Engine for Neovim written in Lua
	use { 'saadparwaiz1/cmp_luasnip' }                                                             --
	use 'rafamadriz/friendly-snippets'                                                             -- Snippets collection
	use { "nvim-neotest/nvim-nio" }                                                                -- asynchronous test runner for neovim
	use { "rcarriga/nvim-dap-ui", requires = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" } } -- A nice UI for debugging
	use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }                               -- Nvim Treesitter configurations and abstraction layer
	use { 'nvim-treesitter/nvim-treesitter' }                                                      -- Nvim Treesitter configurations and abstraction layer
	use { 'numToStr/Comment.nvim', requires = { 'JoosepAlviste/nvim-ts-context-commentstring' } }  --  Smart and powerful comment plugin for neovim
	-- Plugin for calling lazygit from within neovim.
	use {
		"kdheepak/lazygit.nvim",
		requires = {
			"nvim-lua/plenary.nvim",
		},
	}
	use "maralla/gomod.vim" -- Go module support for Vim
	use "fatih/vim-go"     -- Go development plugin for Vim

	-- The VS Code JavaScript debugger
	use {
		"microsoft/vscode-js-debug",
		version = "1.x",
		-- Note: I had to git clone into ~/.local/share/nvim/site/pack/packer/opt and run the below manually - https://github.com/microsoft/vscode-js-debug
		run = 'npm i && npm run compile vsDebugServerBundle && mv dist out'
	}

	use "unblevable/quick-scope" -- Lightning fast left-right movement in Vim
end)
