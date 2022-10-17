-- helper function to load modules and do error checking
local function require_map(target, failed, success)
	local status, loaded = pcall(require, target)
	if status then success(loaded) else vim.notify(failed, vim.log.levels.ERROR) end
end

-- the default settings passed to server setup
local default_settings = {}
default_settings.on_attach = function(client, bufnr)
	-- highlighting if the client supports it
	if client.server_capabilities.document_highlight then
		vim.api.nvim_exec([[
			augroup lsp_document_highlight
				autocmd! * <buffer>
				autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
				autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
			augroup end
		]], false)
	end

	-- keymaps
	require_map('which-key', 'Failed to load which-key, didn\'t set keybindings for LSP', function(wk)
		local options = {
			mode = 'n',
			prefix = '',
			buffer = bufnr,
			silent = true,
			noremap = true,
			nowait = true,
		}
		local mappings = {
			[ 'K' ] = { '<cmd>lua vim.lsp.buf.hover()<CR>', 'hover' },
			[ '<leader>k' ] = { '<cmd>lua vim.lsp.buf.hover()<CR>', 'hover' },
			[ '[d' ] = { '<cmd>lua vim.diagnostic.goto_prev({ border = "rounded" })<CR>', 'Next diagnostic' },
			[ ']d' ] = { '<cmd>lua vim.diagnostic.goto_next({ border = "rounded" })<CR>', 'Previous diagnostic' },
			[ '<leader>l' ] = {
				name = 'Language Server',
				j = { '<cmd>Telescope lsp_references<CR>', 'References' },
				k = { '<cmd>Telescope lsp_implementations<CR>', 'Implementations' },
				s = { '<cmd>Telescope lsp_document_symbols<CR>', 'Document Symbols' },
				d = { '<cmd>Telescope lsp_definitions<CR>', 'Definitions' },
				w = { '<cmd>Telescope lsp_workspace_symbols<CR>', 'Workspace Symbols' },
				i = { '<cmd>Telescope lsp_incoming_calls<CR>', 'Incoming calls' },
				o = { '<cmd>Telescope lsp_outgoing_calls<CR>', 'Outgoing calls' },
				l = { '<cmd>Telescope diagnostics<CR>', 'Diagnostics' },
				D = { '<cmd>lua vim.lsp.buf.declaration()<CR>', 'Declaration' },
				[ '?' ] = { '<cmd>lua vim.lsp.buf.signature_help()<CR>', 'Signature Help' },
				r = { '<cmd>lua vim.lsp.buf.rename()<CR>', 'Rename' },
				a = { '<cmd>lua vim.lsp.buf.code_action()<CR>', 'Code action' },
			},
		}

		if client.server_capabilities.document_formatting then
			mappings['<leader>l'].f = { '<cmd>lua vim.lsp.buf.formatting()<CR>', 'Format buffer' }
		end

		wk.register(mappings, options)
	end)
end

-- update capabilities if cmp is available
default_settings.capabilities = vim.lsp.protocol.make_client_capabilities()
require_map('cmp_nvim_lsp', 'Failed to load cmp_nvim_lsp', function(cmp)
	default_settings.capabilities = cmp.default_capabilities()
	end
)

require_map('mason-lspconfig', 'Failed to load mason-lspconfig, didn\'t setup any LSP servers', function(mason_lspconfig)
	mason_lspconfig.setup()
	require_map('lspconfig', 'Failed to load lspconfig, didn\'t setup any LSP servers', function(lspconfig)
		mason_lspconfig.setup_handlers({ function(server)
			lspconfig[server].setup(default_settings)
			end,
			['sumneko_lua'] = function()
				lspconfig.sumneko_lua.setup({
					capabilities = default_settings.capabilities,
					on_attach = default_settings.on_attach,
					settings = {
						Lua = {
							diagnostics = { globals = { 'vim', }, },
							workspace = {
								library = {
									[vim.fn.expand("$VIMRUNTIME/lua")] = true,
									[vim.fn.stdpath('config')..'/lua'] = true,
								}
							},
						},
					},
				})
			end,
		})
	end)
end)

-- setup the diagnostic signs
local signs = {
	{ name = 'DiagnosticSignError', text = '' },
	{ name = 'DiagnosticSignWarn', text = '' },
	{ name = 'DiagnosticSignHint', text = '' },
	{ name = 'DiagnosticSignInfo', text = '' },
}
for _, sign in ipairs(signs) do
	vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = '' })
end

-- diagnostic configuration
vim.diagnostic.config({
	virtual_text = false,
	signs = { active = signs, },
	update_in_insert = true,
	underline = true,
	float = {
		focusable = false,
		style = 'minimal',
		border = 'rounded',
		source = 'always',
		header = '',
		prefix = '',
	},
})

-- prettier popups
vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = 'rounded' })
vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = 'rounded' })

