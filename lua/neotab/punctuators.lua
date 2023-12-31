local tab = require("neotab.tab")
local utils = require("neotab.utils")
local log = require("neotab.logger")
local config = require("neotab.config").user.smart_punctuators
local api = vim.api

---

---@class ntab.punctuators
local punctuators = {}

function punctuators.semicolon() --
    local lines = api.nvim_buf_get_lines(0, 0, -1, false)
    local pos = api.nvim_win_get_cursor(0)

    local bracket = lines[pos[1]]:find("}", pos[2] + 1, true)
    if bracket then
        lines[pos[1]] = lines[pos[1]]:sub(0, bracket - 1)
    end

    local function tabout_rec(cursor, dg)
        local md = tab.out(lines, { pos[1], cursor - 1 }, { ignore_beginning = true })

        if not md or md.next.char ~= ")" then
            return
        end

        local between = lines[pos[1]]:sub(cursor, md.next.pos - 1)
        if vim.trim(between) ~= "" then
            return
        end

        -- local open_idx = utils.find_opening({ open = "(", close = ")" }, lines[pos[1]], dg)
        -- if open_idx then
        --     log.debug({
        --         open_idx = open_idx,
        --         md = md,
        --     }, "open_idx")
        -- end

        return tabout_rec(md.next.pos + 1) or (md.next.pos + 1)
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

---@param punc string
---@param trigger ntab.trigger
function punctuators.escape(punc, trigger)
    local pos = api.nvim_win_get_cursor(0)
    local char = utils.adj_char(0, pos)

    local info = vim.tbl_filter(function(o)
        return char == o.close
    end, trigger.pairs)[1]

    if not info then
        return
    end

    local offset = 1
    if trigger.space then
        if trigger.space.before then
            offset = offset + 1
            punc = " " .. punc
        end
        if trigger.space.after then
            offset = offset + 1
            punc = punc .. " "
        end
    end

    local line = vim.api.nvim_get_current_line()
    local after_punc = line:sub(pos[2] + 2, pos[2] + 1 + offset)
    if after_punc:find(vim.trim(punc), 1, true) then
        return
    end

    if not utils.find_opening(info, line, pos[2]) then
        return
    end

    utils.move_cursor(1, 0, pos)
    vim.v.char = punc
end

function punctuators.handle()
    local punc, ft = vim.v.char, vim.bo.ft
    local trigger = config.escape.triggers[punc]

    if config.semicolon.enabled and punc == ";" then
        if vim.tbl_contains(config.semicolon.ft, ft) then
            punctuators.semicolon()
        end
    end

    if config.escape.enabled and trigger then
        if not trigger.ft or vim.tbl_contains(trigger.ft, ft) then
            punctuators.escape(punc, trigger)
        end
    end
end

return punctuators
