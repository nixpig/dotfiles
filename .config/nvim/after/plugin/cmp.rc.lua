local status_cmp, cmp = pcall(require, 'cmp')
if not status_cmp then
    print 'Failed to load cmp'
    return
end

local icons = {
    ui = require("icons").get("ui"),
}

local status_lspkind, lspkind = pcall(require, 'lspkind')
if not status_lspkind then print 'Failed to load lspkind' end

-- local function formatForTailwindCSS(entry, vim_item)
--     if vim_item.kind == 'Color' and entry.completion_item.documentation then
--         local _, _, r, g, b = string.find(entry.completion_item.documentation,
--             '^rgb%((%d+), (%d+), (%d+)')
--         if r then
--             local color =
--                 string.format('%02x', r) .. string.format('%02x', g) ..
--                 string.format('%02x', b)
--             local group = 'Tw_' .. color
--             if vim.fn.hlID(group) < 1 then
--                 vim.api.nvim_set_hl(0, group, { fg = '#' .. color })
--             end
--             vim_item.kind = icons.ui.BigCircle
--             vim_item.kind_hl_group = group
--             return vim_item
--         end
--     end
--     vim_item.kind = lspkind.symbolic(vim_item.kind) and
--         lspkind.symbolic(vim_item.kind) or vim_item.kind
--     return vim_item
-- end
cmp.setup({
    sources = cmp.config.sources({
        { name = 'copilot' },
        { name = 'nvim_lsp' },
        { name = 'buffer' },
        { name = 'path' },
        -- { name = 'luasnip' },
        { name = 'vsnip' },
        { name = 'lab.quick_data',       keyword_length = 4 },
        { name = 'vim-dadbod-completion' },
    }),
    snippet = {
        expand = function(args)
            -- require('luasnip').lsp_expand(args.body)
            vim.fn['vsnip#anonymous'](args.body)
        end
    },
    completion = { completeopt = 'menu,menuone,noinsert,preview' },
    mapping = cmp.mapping.preset.insert({
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<Esc>'] = cmp.mapping.close(),
        ["<C-j>"] = cmp.mapping(cmp.mapping.select_next_item({
            behavior = cmp.SelectBehavior.Select
        }), { "i", "c" }),
        ["<C-k>"] = cmp.mapping(cmp.mapping.select_prev_item({
            behavior = cmp.SelectBehavior.Select
        }), { "i", "c" }),
        ['<Tab>'] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Select,
            select = true
        }),
        -- Force open of cmp menu
        ["<C-s>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
        -- ['<Enter>'] = cmp.mapping.confirm({
        --     behavior = cmp.ConfirmBehavior.Replace,
        --     select = true
        -- })
    }),
    formatting = {
        format = lspkind.cmp_format({
            maxwidth = 50,
            before = function(entry, vim_item)
                -- vim_item = formatForTailwindCSS(entry, vim_item)
                return vim_item
            end
        })
    },
    preselect = cmp.PreselectMode.None,
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
})

vim.cmd([[
  set completeopt=menu,menuone,noinsert,preview
  highlight! default link CmpItemKind CmpItemMenuDefault
]])

-- vim.api.nvim_create_autocmd("CursorHoldI", {

--     group = vim.api.nvim_create_augroup("cmp_complete_on_space", {}),
--     callback = function()
--         local line = vim.api.nvim_get_current_line()
--         local cursor = vim.api.nvim_win_get_cursor(0)[2]
--
--         if string.sub(line, cursor, cursor + 1) == " " then
--             require("cmp").complete()
--         end
--     end,
-- })
