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

mason.setup({})

lspconfig.setup({
    ensure_installed = {
        'astro',
        -- 'azure_pipelines_ls',
        'bashls',
        'cssls',
        'lua_ls',
        'tailwindcss',
        'tsserver',
        'eslint',
        'ansiblels',
        'cssmodules_ls',
        'cucumber_language_server',
        'custom_elements_ls',
        'docker_compose_language_service',
        'rust_analyzer',
        'stylelint_lsp',
        'bashls',
        'jsonls',
        'html',
        'dockerls',
        'gopls',
        'yamlls',
        'jdtls',
        'gradle_ls',
        'helm_ls',
        'kotlin_language_server',
        -- 'nginx-language-server',
        'terraformls',
    }
})
