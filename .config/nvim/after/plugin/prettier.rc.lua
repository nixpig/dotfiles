local status, prettier = pcall(require, 'prettier')
if not status then
    print 'Failed to load prettier'
    return
end

prettier.setup({
    bin = 'prettierd',
    filetypes = {
        'css',
        'javascript',
        'javascriptreact',
        'json',
        'jsonc',
        'less',
        'typescript',
        'typescriptreact',
        'scss'
    }
})
