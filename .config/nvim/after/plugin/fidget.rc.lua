local status, fidget = pcall(require, 'fidget')

if not status then
    print 'Did not load fidget plugin'
    return
end

fidget.setup({})
