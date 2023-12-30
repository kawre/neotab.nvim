local tab = require("nvim-tabout.tab")
local utils = require("nvim-tabout.utils")
local log = require("nvim-tabout.logger")
local config = require("nvim-tabout.config").user.smart_punctuators
local api = vim.api

---@class ntab.punctuators
local punctuators = {}

function punctuators.semicolon() --
    if not vim.tbl_contains(config.semicolon.ft, vim.bo.ft) then
        return
    end

    local lines = api.nvim_buf_get_lines(0, 0, -1, false)
    local pos = api.nvim_win_get_cursor(0)

    local bracket = lines[pos[1]]:find("}", pos[2], true)
    if bracket then
        lines[pos[1]] = lines[pos[1]]:sub(0, bracket - 1)
    end

    local function tabout_rec(cursor, dg)
        local md = tab.out(lines, { pos[1], cursor })

        if not md or md.next.char ~= ")" then
            return
        end

        local newlb = utils.find_opening({ open = "(", close = ")" }, lines[pos[1]], dg)
        if newlb then
            return tabout_rec(md.next.pos, newlb - 1) or (md.next.pos + 1)
        end
    end

    local cursor = tabout_rec(pos[2], pos[2])

    if cursor then
        local after_tabout = lines[pos[1]]:sub(cursor)
        if vim.trim(after_tabout) == "" then
            utils.set_cursor(cursor)
        end
    end
end

function punctuators.comma()
    if vim.tbl_contains(config.comma.exclude, vim.bo.filetype) then
        return
    end

    local pos = api.nvim_win_get_cursor(0)

    local char = utils.adj_char(0, pos)
    if not vim.tbl_contains(config.comma.triggers, char) then
        return
    end

    if utils.adj_char(1, pos) ~= "," then
        utils.move_cursor(1, 0, pos)
    end
end

function punctuators.handle()
    local char = vim.v.char

    if char == ";" then
        return punctuators.semicolon()
    elseif char == "," then
        return punctuators.comma()
    end
end

return punctuators
