local api = vim.api
local config = require("tabout.config")
local utils = require("tabout.utils")

local M = {}
local enabled = false

local tab = function()
	if config.options.default_to_tab then
		api.nvim_feedkeys(utils.replace("<Tab>"), "n", false)
	end
end

M.tabout = function()
	if not utils.can_tabout() or not enabled then
		return tab()
	end

	utils.move_cursor(1, 0)
end

M.setup = function(options)
	enabled = true

	config.setup(options)

	api.nvim_create_user_command("Tabout", function()
		require("tabout").tabout()
	end, {})

	api.nvim_set_keymap("i", config.options.tabkey, "<cmd>Tabout<cr>", { silent = true })
end

M.disable = function()
	enabled = false
end

M.enable = function()
	enabled = true
end

M.toggle = function()
	if enabled then
		M.disable()
	else
		M.enable()
	end
end

return M
