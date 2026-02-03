local keymap = vim.keymap
local cmd = vim.cmd

-- Here is a utility function that closes any floating windows when you press escape
-- Source: https://gist.github.com/benfrain/97f2b91087121b2d4ba0dcc4202d252f#file-mappings-lua
local function close_floating()
	for _, win in pairs(vim.api.nvim_list_wins()) do
		if vim.api.nvim_win_get_config(win).relative == "win" then
			vim.api.nvim_win_close(win, false)
		end
	end
end

-- Jumping
keymap.set('n', '[[', '_i', { desc = 'Jump to first non-blank character on line' })
keymap.set('n', ']]', '$a', { desc = 'Jump to end of line' })

-- Scrolling
-- keymap.set('n', '<C-j>', 'j<C-e>', { desc = 'Scroll down and maintain line position' })
-- keymap.set('n', '<C-k>', 'k<C-y>', { desc = 'Scroll up and maintain line position' })

-- Increment/Decrement number under cursor
keymap.set('n', '+', '<C-a>', { desc = 'Increment number under cursor' })
keymap.set('n', '-', '<C-x>', { desc = 'Decrement number under cursor' })

-- Selections
keymap.set('n', '<C-a>', 'gg<S-v>G', { desc = 'Select all in current buffer' })

-- Buffers
keymap.set('n', '<leader>d', ':bd<CR>', { desc = 'Delete current buffer' })
keymap.set('n', '<leader>D', ':bd!<CR>', { desc = 'Force delete current buffer' })

-- Tabs
keymap.set('n', 'te', ':tabedit<Return>', { desc = 'Create new tab' })
keymap.set('n', 'tc', ':tabclose<Return>', { desc = 'Close tab' })

-- Split window
keymap.set('n', 'sh', ':split<Return><C-w>w', { desc = 'Split window horizontally' })
keymap.set('n', 'sv', ':vsplit<Return><C-w>w', { desc = 'Split window vertically' })
keymap.set('n', 'sc', ':only<Return>', { desc = 'Close all other splits' })

-- Resize window
keymap.set('n', '<leader><S-h>', '<C-w><', { desc = 'Resize window Left' })
keymap.set('n', '<leader><S-j>', '<C-w>-', { desc = 'Resize window Down' })
keymap.set('n', '<leader><S-k>', '<C-w>+', { desc = 'Resize window Up' })
keymap.set('n', '<leader><S-l>', '<C-w>>', { desc = 'Resize window Right' })

-- Close floating windows
keymap.set("n", "<esc>", function()
	close_floating()
	cmd(":noh")
end, { silent = true, desc = "Remove Search Highlighting, Dismiss Popups" })


-- Remove all console.log statements
keymap.set("n", "<Leader>xc", ":g/console.lo/d<cr>",
	{ desc = "Remove all console.log statements" })

-- Paste on line above/below
keymap.set({ "n", "x" }, "[p", '<Cmd>exe "put! " . v:register<CR>',
	{ desc = "Paste on line above" })
keymap.set({ "n", "x" }, "]p", '<Cmd>exe "put "  . v:register<CR>',
	{ desc = "Paste on line below" })

-- Move line under cursor
keymap.set('n', '<S-Up>', ':m-2<CR>', { desc = 'Move current line up' })
keymap.set('n', '<S-k>', ':m-2<CR>', { desc = 'Move current line up' })
keymap.set('n', '<S-Down>', ':m+<CR>', { desc = 'Move current line down' })
keymap.set('n', '<S-j>', ':m+<CR>', { desc = 'Move current line down' })

-- Move selected lines up/down
keymap.set('v', '<S-Down>', ":m '>+1<CR>gv=gv", { desc = 'Move selected region up' })
keymap.set('v', '<S-j>', ":m '>+1<CR>gv=gv", { desc = 'Move selected region down' })
keymap.set('v', '<S-Up>', ":m '<-2<CR>gv=gv", { desc = 'Move selected region down' })
keymap.set('v', '<S-k>', ":m '<-2<CR>gv=gv", { desc = 'Move selected region up' })

-- Move character under cursor left/right
keymap.set('n', '<S-l>', 'xp', { desc = 'Move character under cursor right' })
keymap.set('n', '<S-h>', 'xhhp', { desc = 'Move character under cursor left' })

-- Move selected text left/right
keymap.set('v', '<S-l>', "dpgvlol", { desc = 'Move selected text right' })
keymap.set('v', '<S-h>', "dhhpgvhoh", { desc = 'Move selected text left' })

-- Place cursor back after yanking
keymap.set("v", "y", "ygv<Esc>", { desc = "Yank and reposition cursor" })

-- Use uppercase 'U' to redo
keymap.set('n', 'U', '<C-r>', { desc = 'Redo' })

-- Make file executable
keymap.set('', '<leader>x', ':!chmod +x %<CR>', { desc = "Make file in current buffer executable (chmod +x)" })

-- Open lazygit for project of current file
keymap.set('n', '<leader>gl', ':LazyGit<CR>', { desc = 'Open lazygit for project' })

-- cprev and cnext
keymap.set('n', '<M-j>', ':cnext<CR>', { desc = 'Next item in quickfix list' })
keymap.set('n', '<M-k>', ':cprev<CR>', { desc = 'Previous item in quickfix list' })


-- Trigger tmux-sessionizer
keymap.set('n', '<C-f>', '<Cmd>silent !tmux neww tmux-sessionizer<CR>', { desc = 'Trigger tmux-sessionizer' })

-- Trigger tldr.sh
keymap.set('n', '<C-_>', '<Cmd>silent ![[ "$TMUX" ]] && tmux split-window -h -p 30 tldr.sh<CR>',
	{ desc = 'Trigger tldr.sh' })

keymap.set('i', '<C-e>', 'if err != nil {\n\treturn nil, err\n}')
