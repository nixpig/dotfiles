local status, lualine = pcall(require, 'lualine')
if not status then
    print 'Failed to load lualine'
    return
end

local icons = {
    diagnostics = require("icons").get("diagnostics"),
    git = require("icons").get("git"),
    misc = require("icons").get("misc"),
}

lualine.setup {
    options = {
        icons_enabled = true,
        theme = 'catppuccin',
        --section_separators = {left = '', right = ''},
        section_separators = { left = '', right = '' },
        -- component_separators = { left = '', right = '' },
        component_separators = { left = icons.misc.Vbar, right = icons.misc.Vbar },
        disabled_filetypes = { 'packer', 'NvimTree' },
    },
    sections = {
        lualine_a = { 'mode' },
        lualine_b = { { 'branch', icon = icons.git.Branch }, 'diff' },
        lualine_c = {
            {
                'filename',
                file_status = true, -- displays file status (readonly status, modified status)
                path = 1            -- 0 = just filename, 1 = relative path, 2 = absolute path
            }
        },
        lualine_x = {
            {
                'diagnostics',
                sources = { 'nvim_diagnostic' },
                symbols = {
                    error = icons.diagnostics.Error .. ' ',
                    warn = icons.diagnostics.Warning .. ' ',
                    info = icons.diagnostics.Information .. ' ',
                    hint = icons.diagnostics.Hint .. ' '
                }
            }, 'encoding', 'filetype'
        },
        lualine_y = { 'progress' },
        lualine_z = { 'location' }
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {
            {
                'filename',
                file_status = true, -- displays file status (readonly status, modified status)
                path = 1            -- 0 = just filename, 1 = relative path, 2 = absolute path
            }
        },
        lualine_x = { 'location' },
        lualine_y = {},
        lualine_z = {}
    },
    tabline = {
        -- lualine_a = { 'buffers' },
        -- lualine_z = { 'tabs' }
    },
    extensions = { 'fugitive' }
}
