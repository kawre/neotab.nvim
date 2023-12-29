local api = vim.api
local config = require("nvim-tabout.config")
local log = require("nvim-tabout.logger")

---@class ntab.utils
local utils = {}

---@param x integer
---@return string|nil
function utils.adj_char(x)
    local col = (api.nvim_win_get_cursor(0)[2] + 1) + x
    local line = api.nvim_get_current_line()
    return line:sub(col, col)
end

function utils.tab()
    if config.user.act_as_tab then
        api.nvim_feedkeys(utils.replace("<Tab>"), "n", false)
    end
end

function utils.get_info(char)
    if not char then
        return
    end

    local res = vim.tbl_filter(function(o)
        return o.close == char or o.open == char
    end, config.tabbable)

    return not vim.tbl_isempty(res) and res[1] or nil
end

function utils.find_closing(info, line, col)
    if info.open == info.close then
        return line:find(info.close, col + 1, true)
    end

    local c = 1
    for i = col + 1, #line do
        local char = line:sub(i, i)

        if info.open == char then
            c = c + 1
        elseif info.close == char then
            c = c - 1
        end

        if c == 0 then
            return i
        end
    end
end

function utils.valid_pair(info, line, start, endd)
    if info.open == info.close then
        return true
    end

    local c = 1
    for i = start, endd do
        local char = line:sub(i, i)

        if info.open == char then
            c = c + 1
        elseif info.close == char then
            c = c - 1
        end

        if c == 0 then
            return true
        end
    end

    return false
end

function utils.find_opening(info, line, col)
    if info.open == info.close then
        return
    end

    local o, c = 1, 0

    for i = col + 1, #line do
        local char = line:sub(i, i)

        if info.open == char then
            o = o + 1
        elseif info.close == char then
            c = c + 1
        end

        if o == c then
            return i
        end
    end
end

---@param info ntab.pair
---@param line string
---@param col integer
function utils.find_next(info, line, col) --
    local char = line:sub(col, col)

    if info.close == char then
        for i = col + 1, #line do
            char = line:sub(i, i)
            local char_info = utils.get_info(char)

            if char_info then
                return math.max(1, i - col - 1)
            end
        end
    else
        local closing_idx = utils.find_closing(info, line, col) or (#line + 1)

        local l, r = col + 1, closing_idx - 1

        for i = l, r do
            char = line:sub(i, i)
            local char_info = utils.get_info(char)

            if char_info and char == char_info.open then
                if utils.valid_pair(char_info, line, i + 1, r) then
                    return math.max(1, i - col - 1)
                end
            end
        end

        return math.max(1, closing_idx - col - 1)
    end
end

---@param x integer
---@param y integer
function utils.move_cursor(x, y)
    local pos = api.nvim_win_get_cursor(0)

    local line = pos[1] + (y or 0)
    local col = pos[2] + (x or 0)

    api.nvim_win_set_cursor(0, { line, col })
end

---@param str string
function utils.replace(str)
    return api.nvim_replace_termcodes(str, true, true, true)
end

function utils.map(mode, lhs, rhs, opts)
    local options = { noremap = true }

    if opts then
        options = vim.tbl_extend("force", options, opts)
    end

    api.nvim_set_keymap(mode, lhs, rhs, options)
end

return utils
