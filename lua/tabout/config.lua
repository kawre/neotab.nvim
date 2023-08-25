local M = {
	name = "nvim-tabout",
}

local defaults = {
	tabkey = "<Tab>",
	default_to_tab = true, -- defaults to tab if tabout action is not available
	completion = true,
	tabbable = {
		")",
		"]",
		"}",
		"'",
		"`",
		'"',
		"|",
	},
	exclude = {},
}

M.options = {}

M.setup = function(options)
	M.options = vim.tbl_deep_extend("force", {}, defaults, options or {})
end

return M
