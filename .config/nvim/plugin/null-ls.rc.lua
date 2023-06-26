local api = vim.api
local lsp = vim.lsp

local status, null_ls = pcall(require, 'null-ls')
if not status then
    print 'Failed to load null-ls'
    return
end

local augroup = api.nvim_create_augroup('LspFormatting', {})

local lsp_formatting = function(bufnr)
    lsp.buf.format({
        filter = function(client) return client.name == 'null-ls' end,
        bufnr = bufnr
    })
end

null_ls.setup {
    sources = {
        null_ls.builtins.formatting.prettierd,
        null_ls.builtins.formatting.tidy
    },
    on_attach = function(client, bufnr)
        if client.supports_method('textDocument/formatting') then
            api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
            api.nvim_create_autocmd('BufWritePre', {
                group = augroup,
                buffer = bufnr,
                callback = function() lsp_formatting(bufnr) end
            })
        end
    end
}

api.nvim_create_user_command('DisableLspFormatting', function()
    api.nvim_clear_autocmds({ group = augroup, buffer = 0 })
end, { nargs = 0 })
