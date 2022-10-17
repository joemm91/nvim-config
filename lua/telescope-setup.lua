local telescope = require('telescope')
telescope.load_extension('media_files')
telescope.load_extension('ui-select')
telescope.setup({
	extensions = {
		media_files = { find_cmd = 'rg', },
		['ui-select'] = { require('telescope.themes').get_dropdown() },
	},
})

local status, wk = pcall(require, 'which-key')
if status then 
	local options = {
		mode = 'n',
		prefix = ',',
		buffer = nil,
		silent = true,
		noremap = true,
		nowait = true,
	}
	local mappings = {
		[','] = { '<cmd>Telescope builtin<CR>', 'Pickers' },
		f = { '<cmd>Telescope find_files<CR>', 'Find files' },
		l = { '<cmd>Telescope live_grep<CR>', 'Live grep' },
		g = { '<cmd>Telescope git_status<CR>', 'git status' },
		b = { '<cmd>Telescope buffers<CR>', 'Buffers' },
		['?'] = { '<cmd>Telescope help_tags<CR>', 'Help' },
		q = { '<cmd>Telescope quickfix<CR>', 'Quickfixes' },
		j = { '<cmd>Telescope jumplist<CR>', 'Jumplist' },
		m = { '<cmd>Telescope keymaps<CR>', 'Keymaps' },
		s = { '<cmd>Telescope spell_suggest<CR>', 'Spelling' },
	}
	wk.register(mappings, options)
end
