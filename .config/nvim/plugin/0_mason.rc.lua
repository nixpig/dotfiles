local status_mason, mason = pcall(require, 'mason')
if not status_mason then
    print 'Failed to load mason'
    return
end

local status_mason_lspconfig, lspconfig = pcall(require, 'mason-lspconfig')
if not status_mason_lspconfig then
    print 'Failed to load mason-lspconfig'
    return
end

local status_mason_installer, installer = pcall(require, 'mason-tool-installer')
if not status_mason_installer then
    print 'Failed to load mason-tool-installer'
    return
end

mason.setup({})

lspconfig.setup({
    ensure_installed = {
        'bashls',
        'cssls',
        'lua_ls',
        'tailwindcss',
        'ts_ls',
        'eslint',
        'ansiblels',
        'cssmodules_ls',
        'docker_compose_language_service',
        'stylelint_lsp',
        'jsonls',
        'html',
        'dockerls',
        'gopls',
        'yamlls',
        'jdtls',
        'gradle_ls',
        'helm_ls',
        'terraformls',
        'tflint',
        'templ',
        'asm_lsp',
    }
})

installer.setup({
    'codelldb'
})
