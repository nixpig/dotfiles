local cmd = vim.cmd
local api = vim.api

local status, catppuccin = pcall(require, 'catppuccin')
if not status then
	print 'Failed to load catppuccin'
	return
end

catppuccin.setup({
	comment_italics = true,
	integrations = {
		indent_blankline = { enabled = true, colored_indent_levels = false },
		mason = true,
		treesitter = true,
		native_lsp = {
			enabled = true,
			virtual_text = {
				errors = { "italic" },
				hints = { "italic" },
				warnings = { "italic" },
				information = { "italic" },
			},
			underlines = {
				errors = { "underline" },
				hints = { "underline" },
				warnings = { "underline" },
				information = { "underline" },
			},
		},
		cmp = true,
		dap = { enabled = true, enable_ui = false },
		fidget = true,
		gitsigns = true,
		lsp_saga = true,
		neotest = true,
		notify = true,
		nvimtree = true,
		telescope = true,
		treesitter_context = true,
		which_key = true,
	}
})

api.nvim_command([[
	augroup ChangeBackgroundColour
		autocmd colorscheme * :hi normal #0a0a0a
	augroup END
]])

cmd([[silent! colorscheme catppuccin]])

-- Remove background colour
cmd([[ hi Normal guibg=NONE ctermbg=NONE ]])
