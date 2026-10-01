local colors = {}

local palettes = {
  mocha = {
    rosewater = '#f5e0dc',
    flamingo = '#f2cdcd',
    pink = '#f5c2e7',
    mauve = '#cba6f7',
    red = '#f38ba8',
    maroon = '#eba0ac',
    peach = '#fab387',
    yellow = '#f9e2af',
    green = '#a6e3a1',
    teal = '#94e2d5',
    sky = '#89dceb',
    sapphire = '#74c7ec',
    blue = '#89b4fa',
    lavender = '#b4befe',
    text = '#cdd6f4',
    subtext1 = '#bac2de',
    subtext0 = '#a6adc8',
    overlay2 = '#9399b2',
    overlay1 = '#7f849c',
    overlay0 = '#6c7086',
    surface2 = '#585b70',
    surface1 = '#45475a',
    surface0 = '#313244',
    base = '#1e1e2e',
    mantle = '#181825',
    crust = '#11111b',
  },
}

-- Default to mocha
local current_palette = 'mocha'

---Get a color from the current palette.
---@param name string Color name (e.g., 'red', 'blue', 'text')
---@return string hex color value
function colors.get(name)
  return palettes[current_palette][name]
end

---Get the entire current palette.
---@return table<string, string>
function colors.palette()
  return palettes[current_palette]
end

---Set the active palette.
---@param name "mocha" Palette name
function colors.set_palette(name)
  if palettes[name] then
    current_palette = name
  else
    vim.notify('Unknown palette: ' .. name, vim.log.levels.WARN)
  end
end

return colors
