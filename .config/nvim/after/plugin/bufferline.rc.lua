local keymap = vim.keymap

local status, bufferline = pcall(require, 'bufferline')
if not status then
    print 'Failed to load bufferline'
    return
end


local icons = {
    diagnostics = require('icons').get('diagnostics'),
}

-- bufferline.setup({
--     options = {
--         mode = 'tabs',
--         numbers = 'ordinal',
--         diagnostics = 'nvim_lsp',
--         diagnostics_indicator = function(count, level, diagnostics_dict, context)
--             local s = ' '
--             for e, n in pairs(diagnostics_dict) do
--                 local sym = e == 'error' and icons.diagnostics.Error .. ' ' or
--                     (e == 'warning' and icons.diagnostics.Warning .. ' ' or icons.diagnostics.Information .. ' ')
--                 s = s .. n .. sym
--             end
--             return s
--         end,
--         always_show_bufferline = true,
--         show_buffer_close_icons = false,
--         show_close_icon = false,
--         color_icons = true,
--         show_buffer_icons = true,
--         style_preset = bufferline.style_preset.minimal,
--         offsets = {
--             {
--                 filetype = 'NvimTree',
--                 text = function() return vim.fn.getcwd() end,
--                 highlight = 'Directory',
--                 text_align = 'left'
--             }
--         }
--
--     },
--     highlights = {
--         separator = { fg = '#073642' },
--         separator_selected = { fg = '#073642' },
--         buffer_selected = { bold = true }
--     }
-- })

-- Tab and Shift Tab to switch buffer tabs
keymap.set('n', '<Tab>', '<Cmd>BufferLineCycleNext<CR>', { desc = 'Bufferline: Go to next tab' })
keymap.set('n', '<S-Tab>', '<Cmd>BufferLineCyclePrev<CR>', { desc = 'Bufferline: Go to previous tab' })
