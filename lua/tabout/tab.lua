local api = vim.api

local config = require("tabout.config")
local utils = require("tabout.utils")
local logger = require("tabout.logger")

local M = {}

M.tab = function()
	logger.debug("tab")

	if config.options.default_to_tab then
		api.nvim_feedkeys(utils.replace("<Tab>"), "n", false)
	end
end

M.out = function()
	logger.debug("tabout")

	if not utils.can_tabout() then
		return M.tab()
	end

	utils.move_cursor(1, 0)
end

return M
