local keymap = vim.keymap

local status, gc = pcall(require, 'git-conflict')
if not status then
	print 'Failed to load git-conflict'
	return
end

gc.setup({
	default_mappings = false,
})

keymap.set('n', 'co', '<Plug>(git-conflict-ours)', { desc = 'git-conflict choose ours' })
keymap.set('n', 'ct', '<Plug>(git-conflict-theirs)', { desc = 'git-conflict choose theirs' })
keymap.set('n', 'cb', '<Plug>(git-conflict-both)', { desc = 'git-conflict choose both' })
keymap.set('n', 'c0', '<Plug>(git-conflict-none)', { desc = 'git-conflict choose none' })
keymap.set('n', ']x', '<Plug>(git-conflict-next-conflict)', { desc = 'git-conflict next conflict' })
keymap.set('n', ']x', '<Plug>(git-conflict-prev-conflict)', { desc = 'git-conflict previous conflict' })
