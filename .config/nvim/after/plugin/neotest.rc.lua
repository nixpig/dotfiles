local status, neotest = pcall(require, 'neotest')

if not status then
	print 'Failed to load neotest'
	return
end

neotest.setup({
	adapters = {
		require('neotest-jest')({
			jestCommand = "yarn jest",
			jestConfigFile = "jest.config.js",
			env = { CI = true },
			cwd = function(path)
				return vim.fn.getcwd()
			end,
		}),
	}
})
