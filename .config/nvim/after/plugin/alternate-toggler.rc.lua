keymap = vim.keymap

local status, at = pcall(require, 'alternate-toggler')
if not status then
	print 'Did not load alternate-toggler'
	return
end


at.setup({})

keymap.set('n', '<leader><space>', '<cmd>lua require("alternate-toggler").toggleAlternate()<CR>',
	{ desc = 'Toggle boolean-like value' })
