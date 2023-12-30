local tab = require("ntab.tab")
local utils = require("ntab.utils")
local log = require("ntab.logger")
local config = require("ntab.config").user.smart_punctuators
local api = vim.api

---@class ntab.punctuators
local punctuators = {}

function punctuators.semicolon() --
    if not vim.tbl_contains(config.semicolon.ft, vim.bo.ft) then
        return
    end

    log.debug("---------- SMART SEMICOLON")

    local lines = api.nvim_buf_get_lines(0, 0, -1, false)
    local pos = api.nvim_win_get_cursor(0)

    local bracket = lines[pos[1]]:find("}", pos[2], true)
    if bracket then
        lines[pos[1]] = lines[pos[1]]:sub(0, bracket - 1)
    end

    local function tabout_rec(cursor, dg)
        local md = tab.out(lines, { pos[1], cursor - 1 })

        log.debug({
            cursor = cursor,
            dg = dg,
            md = md,
        }, "md")

        if not md or md.next.char ~= ")" then
            return
        end

        local between = lines[pos[1]]:sub(cursor, md.next.pos - 1)
        if vim.trim(between) ~= "" then
            return
        end

        local open_idx = utils.find_opening({ open = "(", close = ")" }, lines[pos[1]], dg)
        if open_idx then
            log.debug({
                open_idx = open_idx,
                md = md,
            }, "open_idx")

            return tabout_rec(md.next.pos + 1, open_idx - 1) or (md.next.pos + 1)
        end
    end

    local col = pos[2] + 1
    local cursor = tabout_rec(col, col - 1)

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

    local info = vim.tbl_filter(function(o)
        return char == o.close
    end, config.comma.triggers)[1]

    if not info then
        return
    end

    local next_char = utils.adj_char(1, pos)
    if next_char == "," then
        return
    end

    local line = vim.api.nvim_get_current_line()
    local oi = utils.find_opening(info, line, pos[2])

    if oi then
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
