local ntab = require("nvim-tabout")
local tab = require("nvim-tabout.tab")
local utils = require("nvim-tabout.utils")
local log = require("nvim-tabout.logger")
local config = require("nvim-tabout.config").user.smart_punctuators
local api = vim.api

---@class ntab.punctuators
local punctuators = {}

function punctuators.semicolon() --
    if not vim.tbl_contains(config.semicolon.ft, vim.bo.filetype) then
        return
    end

    local line = api.nvim_get_current_line()
    local pos = api.nvim_win_get_cursor(0)

    local function tabout_rec(offset, dg)
        local k = pos[2] + offset
        local i, _, char = tab.out(line, { pos[1], k })

        if not i or char ~= ")" then
            return offset
        end

        local ndg = utils.find_opening({ open = "(", close = ")" }, line, dg)
        if ndg then
            return tabout_rec(offset + i, ndg - 1)
        end
    end

    local offset = tabout_rec(0, pos[2])

    if offset then
        local after_tabout = line:sub(pos[2] + offset + 1)
        log.debug({ after_tabout = after_tabout })

        if vim.trim(after_tabout) == "" then
            utils.move_cursor(offset, 0, pos)
        end
    end
end

function punctuators.comma()
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
