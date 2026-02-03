local keymap = vim.keymap
local fn = vim.fn

local status_dapui, dapui = pcall(require, 'dapui')
if not status_dapui then
	print 'Failed to load dapui'
	return
end

local status_dap, dap = pcall(require, 'dap')
if not status_dap then print 'Failed to load dap' end

dapui.setup()

dap.listeners.after.event_initialized["dapui_config"] =
		function() dapui.open({}) end
dap.listeners.before.event_terminated["dapui_config"] = function()
	dapui.close({})
end
dap.listeners.before.event_exited["dapui_config"] =
		function() dapui.close({}) end

keymap.set('n', '<leader>ui', require 'dapui'.toggle)

local icons = {
	dap = require('icons').get('dap'),
}

vim.api.nvim_set_hl(0, 'DapBreakpointSide', { ctermbg = 0, fg = '#f38ba8', bg = '#313244' })
vim.api.nvim_set_hl(0, 'DapBreakpointMain', { ctermbg = 0, fg = '', bg = '#313244' })
vim.api.nvim_set_hl(0, 'DapLogPointSide', { ctermbg = 0, fg = '#89b4fa', bg = '#313244' })
vim.api.nvim_set_hl(0, 'DapLogPointMain', { ctermbg = 0, fg = '', bg = '#313244' })
vim.api.nvim_set_hl(0, 'DapStoppedSide', { ctermbg = 0, fg = '#a6e3a1', bg = '#313244' })
vim.api.nvim_set_hl(0, 'DapStoppedMain', { ctermbg = 0, fg = '', bg = '#313244' })

vim.fn.sign_define('DapBreakpoint',
	{
		text = icons.dap.Breakpoint,
		texthl = 'DapBreakpointSide',
		linehl = 'DapBreakpointMain',
		numhl = 'DapBreakpointMain'
	})
vim.fn.sign_define('DapBreakpointCondition',
	{
		text = icons.dap.BreakpointCondition,
		texthl = 'DapBreakpointSide',
		linehl = 'DapBreakpointMain',
		numhl = 'DapBreakpointMain'
	})
vim.fn.sign_define('DapBreakpointRejected',
	{
		text = icons.dap.BreakpointRejected,
		texthl = 'DapBreakpointSide',
		linehl = 'DapBreakpointMain',
		numhl = 'DapBreakpointMain'
	})
vim.fn.sign_define('DapLogPoint',
	{ text = icons.dap.LogPoint, texthl = 'DapLogPointSide', linehl = 'DapLogPointMain', numhl = 'DapLogPointMain' })
vim.fn.sign_define('DapStopped',
	{ text = icons.dap.Stopped, texthl = 'DapStoppedSide', linehl = 'DapStoppedMain', numhl = 'DapStoppedMain' })
