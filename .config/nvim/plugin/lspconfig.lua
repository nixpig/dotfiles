-- vim.lsp.set_log_level('debug')
local status, nvim_lsp = pcall(require, 'lspconfig')
if not status then
    print 'Failed to load lspconfig'
    return
end

local protocol = require('vim.lsp.protocol')

local icons = {
    kind = require('icons').get('kind'),
    diagnostics = require('icons').get('diagnostics'),
    ui = require('icons').get('ui')
}

local augroup_format = vim.api.nvim_create_augroup('Format', { clear = true })

local enable_format_on_save = function(_, bufnr)
    vim.api.nvim_clear_autocmds({ group = augroup_format, buffer = bufnr })

    vim.api.nvim_create_autocmd('BufWritePre', {
        group = augroup_format,
        buffer = bufnr,
        callback = function() vim.lsp.buf.format({ bufnr = bufnr }) end
    })
end


local on_attach = function(client, bufnr)
    if client.server_capabilities.documentFormattingProvider then
        enable_format_on_save(client, bufnr)
    end


    vim.api.nvim_create_autocmd('BufWritePre', {
        pattern = { '*.tsx', '*.ts', '*.jsx', '*.js' },
        command = 'silent! EslintFixAll',
        group = vim.api.nvim_create_augroup('MyAutocmdsJavaScriptFormatting', {}),
    })

    vim.api.nvim_create_autocmd('BufWritePre', {
        pattern = { '*.prisma' },
        command = 'silent! yes | prisma format',
        group = vim.api.nvim_create_augroup('MyAutocmdsPrismaFormatting', {}),
    })
end

local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())

protocol.CompletionItemKind = {
    icons.kind.Text,
    icons.kind.Method,
    icons.kind.Function,
    icons.kind.Constructor,
    icons.kind.Field,
    icons.kind.variable,
    icons.kind.Class,
    icons.kind.Interface,
    icons.kind.Module,
    icons.kind.Property,
    icons.kind.Unit,
    icons.kind.Value,
    icons.kind.Enum,
    icons.kind.Keyword,
    icons.kind.Snippet,
    icons.kind.Color,
    icons.kind.File,
    icons.kind.Reference,
    icons.kind.Folder,
    icons.kind.EnumMember,
    icons.kind.Constant,
    icons.kind.Struct,
    icons.kind.Event,
    icons.kind.Operator,
    icons.kind.TypeParameter
}

nvim_lsp.ansiblels.setup { on_attach = on_attach, capabilities = capabilities }
nvim_lsp.cssmodules_ls.setup { on_attach = on_attach, capabilities = capabilities }
nvim_lsp.custom_elements_ls.setup { on_attach = on_attach, capabilities = capabilities }
nvim_lsp.docker_compose_language_service.setup { on_attach = on_attach, capabilities = capabilities }
nvim_lsp.stylelint_lsp.setup { on_attach = on_attach, capabilities = capabilities }
nvim_lsp.flow.setup { on_attach = on_attach, capabilities = capabilities }
nvim_lsp.sourcekit.setup { on_attach = on_attach, capabilities = capabilities }
nvim_lsp.tailwindcss.setup { on_attach = on_attach, capabilities = capabilities }
nvim_lsp.cssls.setup { on_attach = on_attach, capabilities = capabilities }
nvim_lsp.astro.setup { on_attach = on_attach, capabilities = capabilities }
nvim_lsp.jsonls.setup { on_attach = on_attach, capabilities = capabilities }
nvim_lsp.html.setup { on_attach = on_attach, capabilities = capabilities }
nvim_lsp.dockerls.setup { on_attach = on_attach, capabilities = capabilities }
nvim_lsp.gopls.setup { on_attach = on_attach, capabilities = capabilities }
nvim_lsp.gradle_ls.setup { on_attach = on_attach, capabilities = capabilities }
nvim_lsp.helm_ls.setup { on_attach = on_attach, capabilities = capabilities }
nvim_lsp.kotlin_language_server.setup { on_attach = on_attach, capabilities = capabilities }
nvim_lsp.terraformls.setup { on_attach = on_attach, capabilities = capabilities }
nvim_lsp.prismals.setup { on_attach = on_attach, capabilities = capabilities }

nvim_lsp.jdtls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    cmd = { 'jdtls' }
}

nvim_lsp.cucumber_language_server.setup {
    on_attach = on_attach,
    filetypes = { 'cucumber' },
    capabilities = capabilities
}

nvim_lsp.bashls.setup {
    on_attach = on_attach,
    filetypes = { 'sh', 'shell', 'bash', 'zsh', 'fish', 'fsh' },
    capabilities = capabilities
}

nvim_lsp.tsserver.setup {
    on_attach = on_attach,
    filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'typescript.tsx' },
    cmd = { 'typescript-language-server', '--stdio' },
    capabilities = capabilities,
    root_dir = function() return vim.loop.cwd() end
}

nvim_lsp.eslint.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'typescript.tsx' },
    root_dir = function() return vim.loop.cwd() end
}

nvim_lsp.lua_ls.setup {
    on_attach = on_attach,
    capabilities = capabilities,

    settings = {
        Lua = {
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = { 'vim' }
            },

            workspace = {
                -- Make the server aware of Neovim runtime files
                library = vim.api.nvim_get_runtime_file('', true),
                checkThirdParty = false
            }
        }
    }
}

nvim_lsp.yamlls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
        yaml = {
            schemas = {
                ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = {
                    "docker-compose*.yml",
                    "docker-compose*.yaml",
                },
                ["https://raw.githubusercontent.com/instrumenta/kubernetes-json-schema/master/v1.18.0-standalone-strict/all.json"] = "/*.k8s.yaml",
            }
        }
    }
}

vim.lsp.handlers['textDocument/publishDiagnostics'] =
    vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
        underline = true,
        update_in_insert = false,
        virtual_text = { spacing = 4, prefix = icons.ui.BigCircle },
        severity_sort = true
    })


-- Diagnostic symbols in the sign column (gutter)
local signs = {
    Error = icons.diagnostics.Error .. ' ',
    Warn = icons.diagnostics.Warning .. ' ',
    Info = icons.diagnostics.Information .. ' ',
    Hint = icons.diagnostics.Hint .. ' '
}
for type, icon in pairs(signs) do
    local hl = 'DiagnosticSign' .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = '' })
end

vim.diagnostic.config({
    virtual_text = { prefix = icons.ui.BigCircle },
    update_in_insert = true,
    float = {
        source = 'always' -- Or 'if_many'
    }
})
