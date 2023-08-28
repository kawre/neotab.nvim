local api = vim.api

local config = require("tabout.config")
local logger = require("tabout.logger")
local tab = require("tabout.tab")

local M = {}
local enabled = true

---@param options TaboutOptions
M.setup = function(options)
	logger.debug("setup")
	config.setup(options)

	api.nvim_create_user_command("Tabout", function()
		require("tabout").tabout()
	end, {})

	if config.options.tabkey ~= "" then
		api.nvim_set_keymap("i", config.options.tabkey, "<cmd>Tabout<cr>", { silent = true, expr = true })
	end
	logger.debug("setup done")
end

local disable = function()
	enabled = false
end

local enable = function()
	enabled = true
end

M.toggle = function()
	if enabled then
		disable()
	else
		enable()
	end
end

M.tabout = function()
	tab.out()
end

return M
