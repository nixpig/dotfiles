local status_luasnip, luasnip_loaders = pcall(require, 'luasnip.loaders.from_vscode')
if not status_luasnip then
    print 'Failed to load luasnip loaders'
    return
end

luasnip_loaders.load()

vim.keymap.set('i', '<C-l>', '<CMD>lua require("luasnip").jump(1)<CR>')
vim.keymap.set('i', '<C-h>', '<CMD>lua require("luasnip").jump(-1)<CR>')
