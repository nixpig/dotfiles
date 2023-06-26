local status, vimade = pcall(require, 'vimade')

if not status then
	print('Failed to load vimade')
	return
end

vim.g.vimade = {
	enablefocusfading = true
}
