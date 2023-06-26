local status, lab = pcall(require, 'lab')
if not status then
    print 'Did not load code lab plugin'
    return
end

lab.setup({
    code_runner = {
        enabled = true
    }
})

vim.keymap.set('n', '<leader>cr', ':Lab code run<CR>', { desc = 'Run code in lab' })
vim.keymap.set('n', '<leader>cs', ':Lab code stop<CR>', { desc = 'Stop code in lab' })
vim.keymap.set('n', '<leader>cp', ':Lab code panel<CR>', { desc = 'Toggle code panel in lab' })
