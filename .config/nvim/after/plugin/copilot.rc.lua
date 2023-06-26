local status, copilot = pcall(require, 'copilot')
if not status then
	print 'Did not load copilot plugin'
	return
end


copilot.setup({
	suggestion = {
		enabled = false,
		auto_trigger = true,
	}
})

local status2, copilot_cmp = pcall(require, 'copilot_cmp')
if not status2 then
	print 'Did not load copilot_cmp plugin'
	return
end

copilot_cmp.setup()
