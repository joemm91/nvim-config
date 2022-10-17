-- set vim options in this table
local options = {
	-- length of tab in spaces
	tabstop = 4,
	-- disable the softtabstop feature
	softtabstop = 0,
	-- use tabstop as shiftwidth
	shiftwidth = 0,

	-- use neovims smartindent for indentation
	smartindent = true,
	-- uncomment if tabstop is not the same as shiftwidth and softtabstop
	-- smarttab = true,
	-- always show the tabline
	showtabline = 2,
	-- show line number
	number = true,
	-- show line numbers relative to the current line
	relativenumber = true,
	-- draw signs in the number column so they don't shift the window when drawn
	signcolumn = 'number',
	-- wrap lines
	wrap = true,
	-- the minimum number of lines above and below the cursor
	scrolloff = 8,
	-- show matching brackets
	showmatch = true,
	-- the time matching brackets are show for
	matchtime = 2,
	-- the time to update on inactivity
	updatetime = 1000,

	-- highlight search results
	hlsearch = true,
	-- ignore the case in searches, add \C to pattern to search case sensitive
	ignorecase = true,
	-- shows results while typing search pattern
	incsearch = true,

	-- always enable mouse support
	mouse = 'a',
	-- the blinks in all modes with the same frequency
	guicursor = 'a:blinkon500',
	-- 25-bit RGB color support in TUI
	termguicolors = true,
	-- bigger command bar
	cmdheight = 2,
	
	-- enable syntax highlighting
	syntax = 'on',
	-- internal encoding
	encoding = 'UTF-8',
	-- use system clipboard for yanks
	clipboard = 'unnamedplus',

	-- show completion menu for single match only insert on explicit selection
	completeopt = { 'menuone', 'noselect', 'noinsert' },
	-- do not conceal text
	conceallevel = 0,
	-- popup menu maximum height
	pumheight = 8,
	-- do not show current mode
	showmode = false,

	-- new windows split below
	splitbelow = true,
	-- new windows split to the right
	splitright = true,

	-- do not use a swapfile
	swapfile = false,
	-- use an undofile
	undofile = true,
	-- use a backup file when writing to a file
	writebackup = true,

	-- mapping wait
	timeoutlen = 200,

	-- use abbreviations
	shortmess = 'sTIF',
}

-- have neovim check if the terminal size changed when taking control
vim.cmd [[autocmd VimEnter * :silent exec "!kill -s SIGWINCH $PPID"]]

-- takes the options defined in options and sets them
for opt, val in pairs(options) do 
	vim.opt[opt] = val
end
