local status, rt = pcall(require, "rust-tools")
if not status then
	return "Did not load rust-tools"
end

local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())


local function on_attach(client, buffer)
	vim.api.nvim_create_autocmd('BufWritePre', {
		pattern = { '*.rs' },
		callback = function()
			vim.lsp.buf.format({ timeout_ms = 100 })
		end,
		group = vim.api.nvim_create_augroup('MyAutocmdsRustFormatting', {}),
	})
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
		on_attach = on_attach,
		capacities = capabilities,
		settings = {
			['rust-analyzer'] = {
				checkOnSave = {
					command = 'clippy'
				},
			}
		}
	}
})
