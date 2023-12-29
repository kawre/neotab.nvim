local api = vim.api
local config = require("nvim-tabout.config")
local log = require("nvim-tabout.logger")

---@class Tabout.Utils
local Utils = {}

---@param x integer
---@return string|nil
function Utils.adj_char(x)
    local col = (api.nvim_win_get_cursor(0)[2] + 1) + x
    local line = api.nvim_get_current_line()
    return line:sub(col, col)
end

function Utils.get_info(char)
    if not char then
        return
    end

    local res = vim.tbl_filter(function(o)
        return o.close == char or o.open == char
    end, config.tabbable)

    return not vim.tbl_isempty(res) and res[1] or nil
end

---comment
---@param info Tabout.set
---@param line string
---@param col integer
function Utils.find_next(info, line, col) --
    local idx = line:find(info.open, col + 1, true) or line:find(info.close, col + 1, true)

    if not idx then
        for i = col + 1, #line do
            if Utils.get_info(line:sub(i, i)) then
                return math.max(1, i - col - 1)
            end
        end
    else
        return math.max(1, idx - col - 1)
    end
end

---@param x integer
---@param y integer
function Utils.move_cursor(x, y)
    local pos = api.nvim_win_get_cursor(0)

    local line = pos[1] + (y or 0)
    local col = pos[2] + (x or 0)

    api.nvim_win_set_cursor(0, { line, col })
end

---@param str string
function Utils.replace(str)
    return api.nvim_replace_termcodes(str, true, true, true)
end

function Utils.map(mode, lhs, rhs, opts)
    local options = { noremap = true }

    if opts then
        options = vim.tbl_extend("force", options, opts)
    end

    api.nvim_set_keymap(mode, lhs, rhs, options)
end

return Utils
