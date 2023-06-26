local status, colorizer = pcall(require, 'colorizer')
if not status then
    print 'Failed to load colorizer'
    return
end

colorizer.setup({'*'})
