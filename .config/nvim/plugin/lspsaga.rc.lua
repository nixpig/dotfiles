local keymap = vim.keymap

local status, saga = pcall(require, 'lspsaga')
if not status then
    print 'Failed to load lspsaga'
    return
end

local icons = {
    ui = require("icons").get("ui"),
}

saga.setup({
    ui = { winblend = 10, border = 'rounded', colors = { normal_bg = '#002b36' }, code_action = '' },
    symbol_in_winbar = { enable = true, separator = ' ' .. icons.ui.ArrowClosed .. ' ', respect_root = true }
})

local opts = { noremap = true, silent = false }

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = "rounded",
    style = "minimal",
})

keymap.set('n', ']w', '<Cmd>Lspsaga diagnostic_jump_next<CR>', opts)     -- Jump to next diagnostic
keymap.set('n', '[w', '<Cmd>Lspsaga diagnostic_jump_prev<CR>', opts)     -- Jump to previous diagnostic
keymap.set('n', 'gl', '<Cmd>Lspsaga show_line_diagnostics<CR>', opts)    -- Show diagnostics for line
keymap.set('n', 'gs', '<Cmd>lua vim.lsp.buf.signature_help()<CR>', opts) -- Show signature help
keymap.set('n', 'gk', '<Cmd>Lspsaga hover_doc<CR>', opts)                -- Show docs
-- keymap.set('n', 'gk', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)          -- Show docs
keymap.set('n', 'gh', '<Cmd>Lspsaga finder<CR>', opts)                   -- Show definition and usage
keymap.set('n', 'gp', '<Cmd>Lspsaga peek_definition<CR>', opts)          -- Peek at definition
keymap.set('n', 'gr', '<Cmd>Lspsaga rename<CR>', opts)                   -- Rename all occurrences of hovered word in current file
keymap.set('n', 'gd', '<Cmd>Lspsaga goto_definition<CR>', opts)          -- Go to definition
keymap.set('n', 'go', '<Cmd>Lspsaga outline<CR>', opts)                  -- Show outline
keymap.set({ 'n', 'v' }, 'ga', '<Cmd>Lspsaga code_action<CR>', opts)     -- Code action
keymap.set('n', 'gt', '<Cmd>Lspsaga term_toggle<CR>', opts)              -- Toggle floating terminal
