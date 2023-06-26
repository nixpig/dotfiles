local status, fp = pcall(require, 'fold-preview')
if not status then
    print 'Failed to load fold-preview'
    return
end

fp.setup({})
