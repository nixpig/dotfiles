local opt = vim.opt
local g = vim.g
local cmd = vim.cmd

local status, indent_blankline = pcall(require, 'indent_blankline')
if not status then
	print 'Did not load indent-blankline plugin'
	return
end

indent_blankline.setup({
	show_current_context = true,
	show_current_context_start = true,
	show_end_of_line = true,
	space_char_blankline = ' ',
	char_highlight_list = {
		"IndentBlanklineIndent0",
		"IndentBlanklineIndent1",
		"IndentBlanklineIndent2",
		"IndentBlanklineIndent3",
		"IndentBlanklineIndent4",
		"IndentBlanklineIndent5",
		"IndentBlanklineIndent6",
		"IndentBlanklineIndent7",
		"IndentBlanklineIndent8",
		"IndentBlanklineIndent9",
	}
})

g.indent_blankline_buftype_exclude = { 'terminal', 'nofile' }
opt.termguicolors = true
opt.list = true
opt.listchars:append "space:·"
opt.listchars:append "tab:» "
opt.listchars:append "extends:›"
opt.listchars:append "precedes:‹"
opt.listchars:append "nbsp:␣"
opt.listchars:append "trail:·"
opt.listchars:append "eol:󰌑"

cmd([[highlight IndentBlanklineIndent0 guifg=#b4befe gui=nocombine]])
cmd([[highlight IndentBlanklineIndent1 guifg=#f38ba8 gui=nocombine]])
cmd([[highlight IndentBlanklineIndent2 guifg=#fab387 gui=nocombine]])
cmd([[highlight IndentBlanklineIndent3 guifg=#a6e3a1 gui=nocombine]])
cmd([[highlight IndentBlanklineIndent4 guifg=#89dceb gui=nocombine]])
cmd([[highlight IndentBlanklineIndent5 guifg=#89b4fa gui=nocombine]])
cmd([[highlight IndentBlanklineIndent6 guifg=#cba6f7 gui=nocombine]])
cmd([[highlight IndentBlanklineIndent7 guifg=#f5c2e7 gui=nocombine]])
cmd([[highlight IndentBlanklineIndent8 guifg=#cdd6f4 gui=nocombine]])
cmd([[highlight IndentBlanklineIndent9 guifg=#eba0ac gui=nocombine]])
