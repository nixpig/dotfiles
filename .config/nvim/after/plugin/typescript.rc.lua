local status, ts = pcall(require, 'typescript')
if not status then
    print 'Did not load typescript plugin'
    return
end

ts.setup({})
