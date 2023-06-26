local status, rest = pcall(require, 'rest-nvim')
if not status then
    print 'Did not load rest.nvim'
    return
end

rest.setup({
    result_split_in_place = true,
    highlight = {
        enabled = true,
        timeout = 150,
    }
})



keymap.set('n', '<leader>hr', '<Plug>RestNvim', { desc = 'Send HTTP request under cursor' })
keymap.set('n', '<leader>hp', '<Plug>RestNvimPreview', { desc = 'Preview HTTP request under cursor' })
keymap.set('n', '<leader>hl', '<Plug>RestNvimLast', { desc = 'Re-send last HTTP request' })
