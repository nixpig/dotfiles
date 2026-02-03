local status, lspkind = pcall(require, 'lspkind')
if not status then
    print 'Failed to load lspkind'
    return
end

local icons = {
    kind = require('icons').get('kind'),
}

lspkind.init({
    mode = 'symbol',

    symbol_map = {
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
        icons.kind.TypeParameter,
        Copilot = icons.kind.Copilot,
    }
})
