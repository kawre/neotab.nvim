local api = vim.api
local config = require("nvim-tabout.config")
local log = require("nvim-tabout.logger")

---@class ntab.utils
local utils = {}

---@param x integer
---@param pos? integer[]
---@return string|nil
function utils.adj_char(x, pos)
    pos = pos or api.nvim_win_get_cursor(0)
    local col = pos[2] + x + 1

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

function utils.find_opening(info, line, col)
    if info.open == info.close then
        return line:reverse():find(info.open, 1, true)
    end

    local c = 1
    for i = col, 1, -1 do
        local char = line:sub(i, i)

        -- log.debug({
        --     line = line:sub(0, col),
        --     i = i,
        --     char = char,
        -- })

        if info.open == char then
            c = c - 1
        elseif info.close == char then
            c = c + 1
        end

        if c == 0 then
            return i
        end
    end
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

---@alias ntab.pos { cursor: integer, char: integer }

---@param info ntab.info
---@param line string
---@param col integer
---
---@return ntab.pos | nil
function utils.find_next_nested(info, line, col) --
    local char = line:sub(col - 1, col - 1)

    if info.open == info.close or info.close == char then
        log.debug("---- TAB 1")
        for i = col, #line do
            char = line:sub(i, i)
            local char_info = utils.get_info(char)

            if char_info then
                return { cursor = i, next = i }
            end
        end
    else
        log.debug("---- TAB 2")
        local closing_idx = utils.find_closing(info, line, col - 1)
        local l, r = col, (closing_idx or #line)

        for i = l, r do
            char = line:sub(i, i)
            local char_info = utils.get_info(char)

            if char_info and char == char_info.open then
                if utils.valid_pair(char_info, line, i + 1, r) then
                    return { cursor = i, next = i }
                end
            end
        end

        log.debug({
            closing_idx = closing_idx,
        }, "TAB 3 - closing_idx")
        return closing_idx and { cursor = closing_idx, next = closing_idx }
    end
end

---@param info ntab.info
---@param line string
---@param col integer
function utils.find_next_closing(info, line, col) --
    local char = line:sub(col, col)

    local i
    if info.open == info.close then
        i = line:find(info.close, col + 1, true) --
    elseif info.close ~= char then
        i = utils.find_closing(info, line, col) --
            or line:find(info.close, col + 1, true)
    end

    return i or utils.find_next_nested(info, line, col)
end

---@param info ntab.info
---@param line string
---@param col integer
---
---@return ntab.md | nil
function utils.find_next(info, line, col) --
    local pos

    if config.user.behavior == "closing" then
        pos = utils.find_next_closing(info, line, col)
    else
        pos = utils.find_next_nested(info, line, col)
    end

    if pos then
        local prev = {
            pos = col - 1,
            char = line:sub(col - 1, col - 1),
        }

        local next = {
            pos = pos.next,
            char = line:sub(pos.next, pos.next),
        }

        return {
            prev = prev,
            next = next,
            pos = math.max(col + 1, pos.cursor),
        }
    end
end

---@param x? integer
---@param y? integer
function utils.set_cursor(x, y) --
    if not y or not x then
        local pos = api.nvim_win_get_cursor(0)
        x = x or (pos[2] + 1)
        y = y or (pos[1] + 1)
    end

    api.nvim_win_set_cursor(0, { y - 1, x - 1 })
end

---@param x integer
---@param y? integer
---@param pos? integer[]
function utils.move_cursor(x, y, pos)
    pos = pos or api.nvim_win_get_cursor(0)

    local line = pos[1] + (y or 0)
    local col = pos[2] + (x or 0)

    api.nvim_win_set_cursor(0, { line, col })

    return x
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
