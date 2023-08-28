local M = { name = "nvim-tabout" }

---@class TaboutOptions
local defaults = {
	tabkey = "<Tab>",
	default_to_tab = true, -- defaults to tab if tabout action is not available
	completion = true,
	debug = true,
	tabbable = {
		"(",
		")",
		"[",
		"]",
		"{",
		"}",
		"'",
		"`",
		'"',
		"|",
	},
	exclude = {},
}

M.options = {}
M.tabbable = {}
M.debug = false

M.setup = function(options)
	M.options = vim.tbl_deep_extend("force", {}, defaults, options or {})
	M.tabbable = vim.tbl_extend("force", {}, M.options.tabbable)
end

return M
