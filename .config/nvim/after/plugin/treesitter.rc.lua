local status, ts = pcall(require, 'nvim-treesitter.configs')
if not status then
	print 'Failed to load treesitter'
	return
end

ts.setup {
	highlight = { enable = true, disable = {} },
	indent = { enable = true, disable = {} },
	ensure_installed = {
		'markdown', 'markdown_inline', 'tsx', 'typescript', 'javascript',
		'java', 'kotlin', 'yaml', 'bash', 'json', 'yaml', 'swift', 'css',
		'html', 'lua', 'rust', 'python', 'diff', 'dockerfile', 'gitcommit', 'gitattributes', 'gitignore', 'git_rebase',
		'http', 'regex', 'scss', 'sql', 'toml', 'vim', 'c', 'cpp', 'cmake', 'vimdoc', 'query'
	},
	autotag = { enable = true },
	context_commentstring = { enable = true, enable_autocmd = false },
	refactor = {
		enable = true,
		clear_on_cursor_move = true,
		keymaps = { smart_rename = 'grr' },
		navigation = {
			enable = true,
			keymaps = { goto_next_usage = 'gn', goto_previous_usage = 'gu' }
		},
		highlight_definitions = {
			enable = true
		}
	}
}

local parser_config = require 'nvim-treesitter.parsers'.get_parser_configs()
parser_config.tsx.filetype_to_parsername = { 'javascript', 'typescript.tsx' }

-- Workaround to get code fix broken code folding on initial opening
vim.api.nvim_create_autocmd({ "BufEnter" },
	{ pattern = { "*" }, command = "normal zx zR" })

local contextStatus, context = pcall(require, 'treesitter-context')
if not contextStatus then
	print 'Did not load treesitter-context'
	return
end

context.setup()
