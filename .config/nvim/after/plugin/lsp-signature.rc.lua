local status, lsp_signature = pcall(require, 'lsp_signature')

if not status then
	print 'Failed to load lsp_signature'
	return
end

lsp_signature.setup({
	bind = true, -- This is mandatory, otherwise border config won't get registered.
	hint_enable = false,
	always_trigger = true,
	transparency = 50,
	handler_opts = {
		border = "rounded"
	}
})
