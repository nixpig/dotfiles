local status, icons = pcall(require, 'nvim-web-devicons')
if not status then
    print 'Failed to load web-devicons'
    return
end

icons.setup {override = {}, default = true}
