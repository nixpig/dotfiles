local status, autotag = pcall(require, 'nvim-ts-autotag')
if not status then
	print 'Failed to load ts-autotag'
	return
end

autotag.setup()
