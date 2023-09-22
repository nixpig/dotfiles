local status, rt = pcall(require, "rust-tools")
if not status then
	return "Did not load rust-tools"
end

rt.setup({
	tools = {
		runnables = {
			use_telescope = true
		},
		inlay_hints = {
			auto = true,
			show_parameter_hints = false,
			parameters_hints_prefix = "",
			other_hints_prefix = "",
		}
	},
	server = {
		on_attach = function(client, buffer) end,
		settings = {
			['rust-analyzer'] = {
				checkOnSave = {
					command = 'clippy'
				},
			}
		}
	}
})