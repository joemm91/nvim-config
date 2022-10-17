-- shorthand for the keymapping function
local keymap = vim.api.nvim_set_keymap
-- shorthand for default options
local options = { noremap = true, silent = true }

-- set leaders
vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

-- easy move between windows
keymap('n', '<C-h>', '<C-w>h', options)
keymap('n', '<C-j>', '<C-w>j', options)
keymap('n', '<C-k>', '<C-w>k', options)
keymap('n', '<C-l>', '<C-w>l', options)

-- resize windows
keymap('n', '<C-Up>', ':resize +1<CR>', options)
keymap('n', '<C-Down>', ':resize -1<CR>', options)
keymap('n', '<C-Left>', ':vertical resize +1<CR>', options)
keymap('n', '<C-Right>', ':vertical resize -1<CR>', options)

local status, _ = pcall(require, 'nvim-tree')
if status then keymap('n', '<leader>b', '<cmd>NvimTreeToggle<CR>', options) end

