local api = vim.api
local config = require("tabout.config")

local M = {}

---@param x number
M.get_adj_char = function(x)
	local col = api.nvim_win_get_cursor(0)[2] + x
	local line = api.nvim_get_current_line()

	return line:sub(col, col)
end

---@return boolean
M.can_tabout = function()
	if vim.tbl_contains(config.options.exclude, vim.bo.filetype) then
		return false
	end

	local next_char = M.get_adj_char(1)
	return vim.tbl_contains(config.options.tabbable, next_char)
end

---@param x number
---@param y number
M.move_cursor = function(x, y)
	local pos = api.nvim_win_get_cursor(0)
	local line = pos[1] + y
	local col = pos[2] + x

	api.nvim_win_set_cursor(0, { line, col })
end

---@param str string
M.replace = function(str)
	return api.nvim_replace_termcodes(str, true, true, true)
end

return M
