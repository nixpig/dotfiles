local status, dapjs = pcall(require, 'dap-vscode-js')
if not status then
	print 'Failed to load dap-vscode-js'
	return
end

local DEBUGGER_PATH = vim.fn.stdpath "data" .. "/site/pack/packer/opt/vscode-js-debug"

dapjs.setup({
	-- node_path = "node",      -- Path of node executable. Defaults to $NODE_PATH, and then "node"
	debugger_path = DEBUGGER_PATH, -- Path to vscode-js-debug installation.
	-- debugger_cmd = { "extension" }, -- Command to use to launch the debug server. Takes precedence over `node_path` and `debugger_path`.
	adapters = {
		'chrome', 'pwa-node', 'pwa-chrome', 'pwa-msedge', 'node-terminal',
		'pwa-extensionHost'
	}, -- which adapters to register in nvim-dap
	-- log_file_path = "./dap_vscode_js.log", -- Path for file logging
	-- log_file_level = false -- Logging level for output to file. Set to false to disable file logging.
	-- log_console_level = vim.log.levels.INFO -- Logging level for output to console. Set to false to disable console output.
})
