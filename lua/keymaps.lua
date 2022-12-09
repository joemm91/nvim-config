-- shorthand for the keymapping function
local keymap = vim.api.nvim_set_keymap
-- helper function to create maps for modules if they exist
local function map_if_required(target, mode, mapping, command, options)
	local status, _ = pcall(require, target)
	if status then keymap(mode, mapping, command, options) end
end
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

map_if_required('nvim-tree', 'n', '<leader>b', '<cmd>NvimTreeToggle<CR>', options)
