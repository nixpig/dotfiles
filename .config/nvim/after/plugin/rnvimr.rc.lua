vim.g.rnvimr_enable_ex = 1        -- Make Ranger replace Netrw and be the file explorer
vim.g.rnvimr_enable_picker = 1    -- Hide ranger after picking a file
vim.g.rnvimr_enable_bw = 1        -- Make Ranger wipe buffers on close
vim.g.rnvimr_shadow_winblend = 70 -- Make the floating window semi-transparent

keymap.set('n', '<C-n>', ':RnvimrToggle<Return>', { desc = 'Ranger: Open and focus' })
