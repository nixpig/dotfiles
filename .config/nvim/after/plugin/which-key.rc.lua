local status, wk = pcall(require, 'which-key')
if not status then
    print 'Failed to load which-key'
    return
end

wk.setup({})
