local status, telescope = pcall(require, 'telescope')
if not status then
    print 'Failed to load telescope'
    return
end

local extensions = telescope.extensions

local actions = require('telescope.actions')
local builtin = require('telescope.builtin')

local icons = {
    ui = require('icons').get('ui'),
}

local fb_actions = extensions.file_browser.actions

telescope.load_extension('file_browser')
telescope.load_extension('fzf')
telescope.load_extension('ui-select')
telescope.load_extension('undo')

telescope.setup {
    defaults = {
        mappings = { n = { ['q'] = actions.close } },
        prompt_prefix = " " .. icons.ui.Search .. " ",
        selection_caret = " ",
        entry_prefix = " ",
        initial_mode = "insert",
        selection_strategy = "reset",
        sorting_strategy = "ascending",
        layout_strategy = "horizontal",
        layout_config = {
            horizontal = {
                prompt_position = "top",
                preview_width = 0.55,
                results_width = 0.8,
            },
            vertical = {
                mirror = false,
            },
            width = 0.87,
            height = 0.85,
            preview_cutoff = 120,
        },
        set_env = { ['COLORTERM'] = 'truecolor' },
    },
    extensions = {
        ["ui-select"] = {
            require("telescope.themes").get_dropdown({}),
        },
        fzf = {
            fuzzy = true,                   -- false will only do exact matching
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = true,    -- override the file sorter
            case_mode = "smart_case"        -- or "ignore_case" or "respect_case" the default case_mode is "smart_case"

        },
        file_browser = {
            hijack_netrw = true,
            mappings = {
                ['i'] = { ['<C-w>'] = function()
                    vim.cmd('normal vbd')
                end },
                ['n'] = {
                    -- your custom normal mode mappings
                    ['N'] = fb_actions.create,
                    ['h'] = fb_actions.goto_parent_dir,
                    ['/'] = function() vim.cmd('startinsert') end
                }
            }
        },
        undo = {},
    }
}


vim.keymap.set('n', '<leader>f', function()
    builtin.find_files({
        find_command = { 'rg', '--files', '--hidden', '-g', '!.git' },
        no_ignore = false,
        hidden = true
    })
end, { desc = 'Telescope: Find files' })

vim.keymap.set('n', '<leader>r', function()
    builtin.live_grep()
end, { desc = 'Telescope: Live grep' })

vim.keymap.set('n', '<leader>\\', function()
    builtin.buffers({ sort_lastused = true, --[[ ignore_current_buffer = true ]] })
end, { desc = 'Telescope: Browse buffers' })

vim.keymap.set('n', '<leader>t', function()
    builtin.help_tags()
end, { desc = 'Telescope: Browse help tags' })

vim.keymap.set('n', '<leader>;', function()
    builtin.resume()
end, { desc = 'Telescope: Resume session' })

vim.keymap.set('n', '<leader>e', function()
    builtin.diagnostics()
end, { desc = 'Telescope: Browse file diagnostics' })

vim.keymap.set('n', '<leader>b', function()
    extensions.file_browser.file_browser({
        respect_gitignore = false,
        hidden = true,
        grouped = true,
        previewer = false,
        initial_mode = 'insert'
    })
end, { desc = 'Telescope: File browser' })

vim.keymap.set("n", "<leader>m", function()
    builtin.marks()
end, { desc = "Telescope: Browse marks" })

vim.keymap.set("n", "<leader>gc", function()
    builtin.git_bcommits()
end, { desc = "Telescope: Browse git commits" })

vim.keymap.set("n", "<leader>/", function()
    builtin.current_buffer_fuzzy_find()
end, { desc = "Telescope: Fuzzy search current buffer" })

vim.keymap.set('n', '<leader>u', '<cmd>Telescope undo<CR>', { desc = 'Telescope: Browse undo history' })

vim.keymap.set('n', '<leader>k', '<cmd>Telescope keymaps<CR>', { desc = 'Telescope: Browse keymaps' })
