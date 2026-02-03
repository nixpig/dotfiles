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
		'java', 'kotlin', 'yaml', 'bash', 'json', 'go', 'yaml', 'hcl', 'terraform', 'swift', 'css',
		'html', 'lua', 'rust', 'python', 'diff', 'dockerfile', 'gitcommit', 'gitattributes', 'gitignore', 'git_rebase',
		'http', 'regex', 'scss', 'sql', 'toml', 'vim', 'c', 'cpp', 'cmake', 'vimdoc', 'query', 'templ', 'vhs', 'asm'
	},
	-- context_commentstring = { enable = true, enable_autocmd = false },
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

parser_config.vhs = {
	install_info = {
		url = "/home/nixpig/projects/tree-sitter-vhs",
		files = { "src/parser.c" },
		-- branch = "set-window-title-command",
		generate_requires_npm = false,
		requires_generate_from_grammar = true,
	},
}

local contextStatus, context = pcall(require, 'treesitter-context')
if not contextStatus then
	print 'Did not load treesitter-context'
	return
end

context.setup()
