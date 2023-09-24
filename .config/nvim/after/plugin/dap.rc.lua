local keymap = vim.keymap

local status, dap = pcall(require, 'dap')
if not status then print 'Failed to load dap' end

-- Set keymaps to control the debugger
keymap.set('n', '<F5>', require 'dap'.continue, { desc = 'DAP: Start/Continue debugging' })
keymap.set('n', '<F10>', require 'dap'.step_over, { desc = 'DAP: Step over' })
keymap.set('n', '<F11>', require 'dap'.step_into, { desc = 'DAP: Step into' })
keymap.set('n', '<F12>', require 'dap'.step_out, { desc = 'DAP: Step out' })
keymap.set('n', '<C-b>', require 'dap'.toggle_breakpoint, { desc = 'DAP: Toggle breakpoint' })
keymap.set('n', '<C-Delete>', require 'dap'.clear_breakpoints, { desc = 'DAP: Clear all breakpoints' })
keymap.set('n', '<C-c>', function()
	require 'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))
end, { desc = 'DAP: Set conditional breakpoint' })

local js_based_languages = { "typescript", "javascript", "javascriptreact", "typescriptreact" }

for _, language in ipairs(js_based_languages) do
	dap.configurations[language] = {
		--
		-- Debug TypeScript file
		{
			type = 'pwa-node',
			request = 'launch',
			name = "Launch TypeScript file",
			cwd = "${workspaceFolder}",
			runtimeExecutable = "ts-node",
			-- runtimeExecutable = "node",
			-- runtimeArgs = { '--loader', 'ts-node/esm' },
			args = { '${file}' },
			sourceMaps = true,
			protocol = 'inspector',
			skipFiles = { '<node_internals>/**', 'node_modules/**' },
			-- resolveSourceMapLocations = { "${workspaceFolder}/**", "!**/node_modules/**" }
		},
		--
		-- Debug JavaScript file
		{
			type = "pwa-node",
			request = "launch",
			name = "Launch file",
			program = "${file}",
			cwd = "${workspaceFolder}"
		},
		--
		-- Debug node processes, e.g. `express` apps
		{
			type = "pwa-node",
			request = "attach",
			name = "Attach",
			processId = require 'dap.utils'.pick_process,
			cwd = "${workspaceFolder}"
		},
		--
		-- Debug web apps
		{
			type = "pwa-chrome",
			request = "launch",
			name = "Start Chrome with \"localhost\"",
			url = "http://localhost:3000",
			webRoot = "${workspaceFolder}",
			userDataDir = "${workspaceFolder}/.vscode/vscode-chrome-debug-userdatadir"
		},
	}
end
