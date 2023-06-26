local cmd = vim.cmd
local opt = vim.opt
local wo = vim.wo
local api = vim.api

cmd('autocmd!')

-- Set leader key
vim.g.mapleader = ' '

-- Encoding
vim.scriptencoding = 'utf-8'
opt.encoding = 'utf-8'
opt.fileencoding = 'utf-8'

wo.number = true                                       -- Display line number
wo.relativenumber = true                               -- Display relative line numbers
opt.title = true                                       -- Show the title of the file
opt.autoindent = true                                  -- New lines inherit the indentation of previous lines
opt.smartindent = true                                 -- Use smart indent
opt.hlsearch = false                                   -- Enable search highlighting
opt.backup = false                                     -- Don't use backups
opt.showcmd = true                                     -- Show last command after exit
opt.cmdheight = 1                                      -- Command line display height
opt.cursorline = true                                  -- Highlight the cursorline
opt.cursorcolumn = true                                -- Highlight the cursorcolumn
opt.laststatus = 2                                     -- Always displat status bar
opt.expandtab = false                                  -- Don't convert tabs to spaces
opt.scrolloff = 15                                     -- Screen lines to keep visible above and below cursor
opt.shell = 'bash'                                     -- Shell to use when executing commands
opt.backupskip = { '/tmp/*', '/private/tmp/*' }        -- Skip backups for temp directories
opt.inccommand = 'split'                               -- Show replacements in split window before applying changes
opt.ignorecase = true                                  -- Ignore case when searching
opt.smarttab = false                                   -- Don't insert spaces when tab key pressed
opt.breakindent = true                                 -- Add extra indentation to wrapped lines
opt.shiftwidth = 2                                     -- Indent using 4 spaces
opt.tabstop = 2                                        -- Indent using 4 spaces
opt.wrap = false                                       -- Don't wrap lines
opt.backspace = { 'start', 'eol', 'indent' }           -- Backspace over indentation, line breaks and insertion start
opt.wildmenu = true                                    -- Better menu for autocomplete suggestions
opt.termguicolors = true                               -- Use true colours from terminal
opt.winblend = 0                                       -- Transparency of floating windows, e.g. lsp
opt.wildoptions = 'pum'                                -- Use popup menu when completing
opt.pumblend = 5                                       -- Set transparency of pop-up menu
opt.background = 'dark'                                -- Set dark background
opt.signcolumn = 'yes'                                 -- Always show sign column
opt.colorcolumn = '80'                                 -- Show vertical marker at column
opt.path:append { '**' }                               -- Search subdirectories when finding files
opt.wildignore:append { '*/node_modules/*', '^.git/' } -- Ignore node_modules when matching glob patterns
opt.formatoptions:append { 'r' }                       -- Auto-add asterisks in block comments
opt.clipboard = 'unnamedplus'                          -- Use system clipboard

vim.o.timeout = true                                   -- Enable timeout
vim.o.timeoutlen = 500                                 -- Time to wait for a mapped sequence to complete (in milliseconds)
vim.o.updatetime = 250                                 -- Time to wait before triggering CursorHold

-- Add filetypes
vim.filetype.add({
	extension = {
		pcss = "css"
	}
})

-- Improve treesitter code-folding
opt.foldmethod = 'expr'
opt.foldcolumn = '0'
opt.foldexpr = 'nvim_treesitter#foldexpr()'
vim.o.foldenable = false

-- Undercurl
cmd([[let &t_Cs = '\e[4:3m']])
cmd([[let &t_Ce = '\e[4:0m']])

-- Turn off paste mode when leaving insert
api.nvim_create_autocmd('InsertLeave', { pattern = '*', command = 'set nopaste' })

-- Highlight yanked text after yanking for 250ms
cmd([[
  augroup highlight_yank
  autocmd!
  au TextYankPost * silent! lua vim.highlight.on_yank({higroup='Visual', timeout=250})
  augroup END
]])

-- Reload i3 on changes to config
api.nvim_create_autocmd('BufWritePost',
	{ pattern = '*/i3/config', command = ':silent !i3-msg restart' })

-- Resource .tmux.conf on save
api.nvim_create_autocmd('BufWritePost',
	{ pattern = '*/.tmux.conf', command = ':silent !tmux source ~/.tmux.conf' })


-- Set Podfiles filetype to ruby
cmd([[autocmd BufNewFile,BufRead Podfile,*.podspec set filetype=ruby]])
