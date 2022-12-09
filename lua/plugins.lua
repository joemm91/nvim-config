-- if packer is not found, install it
local path = vim.fn.stdpath 'data'..'/site/pack/packer/start/packer.nvim'
BOOTSTRAP = false
if vim.fn.empty(vim.fn.glob(path)) > 0 then
	BOOTSTRAP = vim.fn.system {
		'git',
		'clone',
		'--depth',
		'1',
		'https://github.com/wbthomason/packer.nvim',
		path,
	}
	if BOOTSTRAP then
		vim.notify('Installed packer, restart neovim in order to use it', vim.log.levels.INFO)
		vim.cmd [[packadd packer.nvim]]
	else
		vim.notify('Error installing packer', vim.log.levels.INFO)
		return
	end
else
	local packer = require('packer');
	packer.startup({
		-- load the plugins
		function(use)
			local plenary = 'nvim-lua/plenary.nvim'
			-- which-key
			use({
				'folke/which-key.nvim',
				config = function() require('which-key').setup({
					plugins = {
						spelling = {
							enabled = true,
							suggestions = 10,
						},
					},
					icons = { separator = '➝ '},
					window = { border = 'rounded', },
					layout = { align = 'center' },
				})
				end
			})


			-- packer manages itself
			use('wbthomason/packer.nvim')
			-- mason manages external tools
			local mason = 'williamboman/mason.nvim'
			use({
				mason,
				config = function() require('mason').setup({
					ui = {
						border = 'rounded',
						icons = {
							package_installed = '✓',
							package_pending = '➜',
							package_uninstalled = '✗'
						}
					},
				})
				end
			})
			-- LSP
			use({
				'williamboman/mason-lspconfig.nvim',
				requires = { { mason } },
			})
			use({
				'neovim/nvim-lspconfig',
				config = function() require('lsp') end
			})
			use({
				'https://git.sr.ht/~whynothugo/lsp_lines.nvim',
				config = function()
					require('lsp_lines').setup({})
					vim.diagnostic.config({ virtual_lines = true })
					vim.keymap.set("", "<leader>L", require('lsp_lines').toggle, { desc = 'toggle lsp_lines'} )
				end,
			})

			-- latex
			use({
				'https://github.com/lervag/vimtex',
				config = function()
					vim.g.vimtex_syntax_enabled = 0
					vim.g.vimtex_syntax_conceal_disable = 1
					vim.g.vimtex_complete_enabled = 1
					vim.g.tex_flavor = 'latex'
					vim.g.vimtex_view_general_viewer = 'okular'
					vim.g.vimtex_view_general_options = '--unique file:@pdf\\#src:@line@tex'
					vim.g.tex_comment_nospell = 1
				end,
			})
			-- completion
			-- autopairs
			use({
				'windwp/nvim-autopairs',
				after = 'nvim-cmp',
				config = function()
					require('nvim-autopairs').setup({
						check_ts = true,
						disable_filetype = { 'TelescopePrompt', 'spectre_panel', 'vim' }
					})
					local status, cmp = pcall(require, 'cmp')
					if status then
						cmp.event:on('confirm_done', require('nvim-autopairs.completion.cmp').on_confirm_done({ map_char = { tex = '' } }))
					end
				end,
			})
			-- completion plugin
			use({
				'hrsh7th/nvim-cmp',
				config = function() require('completion') end,
			})
			-- cmp sources
			use({
				-- LSP
				'hrsh7th/cmp-nvim-lsp',
				-- LSP signature help
				'hrsh7th/cmp-nvim-lsp-signature-help',
				-- calculator
				'hrsh7th/cmp-calc',
				-- snippet source
				'saadparwaiz1/cmp_luasnip',
				-- snippet plugin
				'L3MON4D3/LuaSnip',
				-- snippet collection
				'rafamadriz/friendly-snippets',
				-- complete file paths
				'hrsh7th/cmp-path',
				-- latex symbols to unicode
				'amarakon/nvim-cmp-lua-latex-symbols',
				-- emoji input
				'hrsh7th/cmp-emoji',
			})
			-- Appearance
			local devicons = 'kyazdani42/nvim-web-devicons'
			use({
				devicons,
				config = function() require('nvim-web-devicons').setup({
					color_icons = true,
					default = true,
				})
				end,
			})
			-- Treesitter
			use({
				'nvim-treesitter/nvim-treesitter',
				run = ':TSUpdate',
				wants = {
					'p00f/nvim-ts-rainbow',
				},
				config = function()
					require('nvim-treesitter.configs').setup({
						-- install all parsers
						ensure_installed = 'all',
						ignore_install = { },

						-- highlight module
						highlight = { enable = true, },
						-- indent module
						indent = { enable = true, },
						-- incremental selection module 
						incremental_selection = {
							enable = true,
							keymaps = {
								init_selection = '<leader>gg',
								node_incremental = '<leader>gk',
								scope_incremental = '<leader>gl',
								node_decremental = '<leader>gj',
							},
						},
						-- highlight delimiters colorful
						rainbow = {
							enable = true,
							-- highlights others delimiters
							extended_mode = true,
						},
						-- highlight definitions
						refactor = {
							highlight_definitions = {
								enable = true,
								clear_on_cursor_move = true,
							},
							highligh_current_scope = { enable = true, },
						},
						-- hightlight pairs
						pairs = {
							enable = true,
							-- highlight as soon as the cursors moves
							highlight_pair_events = { 'CursorMoved', 'CursorMovedI', 'CursorHold', 'CursorHoldI' },
							-- highlights the partner under the cursor
							highlight_self = true,
						},
						-- tag completion
						autotag = { enable = true, }
					})
				end,
			})
			-- treesitter modules
			use({
				'p00f/nvim-ts-rainbow',
				'nvim-treesitter/nvim-treesitter-refactor',
				'theHamsta/nvim-treesitter-pairs',
				'windwp/nvim-ts-autotag',
			})

			-- telescope
			use({
				'nvim-telescope/telescope.nvim',
				requires = { { devicons, plenary }, },
				config = function() require('telescope-setup') end,
			})
			-- telescope extensions
			use({
				-- preview media files
				'nvim-telescope/telescope-media-files.nvim',
				-- neovims ui selection using telescope
				'nvim-telescope/telescope-ui-select.nvim',
			})

			-- popup window api
			use({
				'nvim-lua/popup.nvim',
				requires = { { plenary } }
			})
			-- floating notifications
			use({
				'rcarriga/nvim-notify',
				config = function()
					local notify = require('notify')
					-- set options
					notify.setup({
						stages = 'static',
						timeout = 10000,
					})
					-- set neovims notification system
					vim.notify = notify
				end
			})

			-- colorscheme
			use {
				'catppuccin/nvim',
				as = 'catppuccin',
				config = function ()
					require('catppuccin').setup({
						transparent_background = true,
						flavour = 'frappe' ,
						styles = {
							comments = { },
							conditionals = { },
						}
					})
					vim.api.nvim_command('colorscheme catppuccin-frappe')
				end
			}

			-- status line
			local lualine = 'nvim-lualine/lualine.nvim'
			use({
				lualine,
				config = function() require('lualine').setup({
					options = {
						icons_enabled = true,
						theme = 'auto',
						refresh = { statusline = 1000, },
						disabled_filetypes = { 'packer', 'NvimTree', },
					},
					sections = {
						lualine_a = { 'mode', },
						lualine_b = { 'branch', },
						lualine_c = { 'filename', 'diagnostics', },
						lualine_x = { 'filetype', 'fileformat', 'encoding', },
						lualine_y = { 'progress', },
						lualine_z = { 'location', },
					},
					inactive_sections = {
						lualine_x = { 'filetype', 'fileformat', 'encoding', },
						lualine_y = { 'progress', },
						lualine_z = { 'location', },
					},
				})
				end,
			})
			-- tabline
			use({
				'kdheepak/tabline.nvim',
				requires = { { lualine, devicons }, },
				config = function() require('tabline').setup({
					options = {
						section_separators = { ' ', ' ' },
					},
				}) end,
			})
			-- tree plugin
			use({
				'nvim-tree/nvim-tree.lua',
				requires = { { devicons } },
				config = function()
					require('nvim-tree').setup({
						disable_netrw = true,
						create_in_closed_folder = false,
						hijack_netrw = true,
						sort_by = "name",
						view = {
							adaptive_size = true,
							hide_root_folder = false,
							side = "right",
							preserve_window_proportions = false,
							signcolumn = "yes",
						},
						update_focused_file = {
							enable = true,
						},
						diagnostics = {
							enable = true,
							show_on_dirs = true,
						},
						git = { enable = false, },
					})
				end,
			})

			-- DAP
			use('mfussenegger/nvim-dap')

			if BOOTSTRAP then packer.sync() end
		end,
		config = {
			display = {
				-- floating window for packer
				open_fn = function()
					return require('packer.util').float({ border = 'rounded' })
				end,
			},
		}
	})
end
