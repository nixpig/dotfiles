local status, pf = pcall(require, 'pretty-fold')
if not status then
	print 'Failed to load pretty-fold'
	return
end

pf.setup({})
