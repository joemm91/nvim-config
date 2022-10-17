local cmp = require('cmp')

-- helper function to load modules with error checking
local function require_map(target, failed, success)
	local status, loaded = pcall(require, target)
	if status then success(loaded) else vim.notify(failed, vim.log.levels.ERROR) end
end

local icons = {
  Text = "",
  Method = "m",
  Function = "",
  Constructor = "",
  Field = "",
  Variable = "",
  Class = "",
  Interface = "",
  Module = "",
  Property = "",
  Unit = "",
  Value = "",
  Enum = "",
  Keyword = "",
  Snippet = "",
  Color = "",
  File = "",
  Reference = "",
  Folder = "",
  EnumMember = "",
  Constant = "",
  Struct = "",
  Event = "",
  Operator = "",
  TypeParameter = "",
}

local config = {
	mapping = {
		['<C-p>'] = cmp.mapping.select_prev_item(),
		['<C-n>'] = cmp.mapping.select_next_item(),
		['<C-k>'] = cmp.mapping(cmp.mapping.scroll_docs(-1), { 'i', 'c' }),
		['<C-j>'] = cmp.mapping(cmp.mapping.scroll_docs(1), { 'i', 'c' }),
		['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
		['<CR>'] = cmp.mapping.confirm { select = true },
	},
	formatting = {
		fields = { 'kind' , 'abbr', 'menu' },
		format = function(entry, item)
			item.kind = icons[item.kind]
			item.menu = ({
				nvim_lsp = '[LSP]',
				nvim_lua = '[Lua nvim]',
				luasnip = '[Snippet]',
				path = '[Path]',
				calc = '[Calc]'
			})[entry.source.name]
			return item
		end,
	},
	sources = {
		{ name = 'nvim_lsp' },
		{ name = 'nvim_lsp_signature_help' },
		{ name = 'luasnip' },
		{ name = 'calc' },
		{ name = 'path' },
		{ name = 'fonts', option = { space_filter = '-', }, },
		{ name = 'lua-latex-symbols', option = { cache = true, }, },
		{ name = 'emoji' },
	},
	confirm_opts = {
		behavior = cmp.ConfirmBehavior.Replace,
		select = false,
	},
	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	},
}

require_map('luasnip/loaders/from_vscode', 'Failed to load snippets', function(snippets)
	snippets.lazy_load()
end)

require_map('luasnip', 'Failed to load luasnip', function(luasnip)
	config.snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	}
	config.mapping['<Tab>'] = cmp.mapping(function(fallback)
		if cmp.visible() then
			cmp.select_next_item()
		elseif luasnip.expandable() then
			luasnip.expand()
		elseif luasnip.expand_or_jumpable() then
			luasnip.expand_or_jump()
		else
			fallback()
		end
	end, { 'i', 's' })
	config.mapping['<S-Tab>'] = cmp.mapping(function(fallback)
		if cmp.visible() then
			cmp.select_prev_item()
		elseif luasnip.jumpable(-1) then
			luasnip.jump(-1)
		else
			fallback()
		end
	end, { 'i', 's' })
end)

cmp.setup(config)
