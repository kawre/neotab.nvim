local tab = require("neotab.tab")
local utils = require("neotab.utils")
local log = require("neotab.logger")
local config = require("neotab.config").user.smart_punctuators
local api = vim.api

---@class ntab.punctuators
local punctuators = {}

function punctuators.semicolon() --
    local lines = api.nvim_buf_get_lines(0, 0, -1, false)
    local pos = api.nvim_win_get_cursor(0)
    local line = lines[pos[1]]

    -- check if cursor is inside foor loop
    local _, for_e = line:find("^%s*for%s*%(")
    if for_e then
        local info = utils.get_pair("(")
        local s2 = utils.find_closing(info, line, for_e)
        if s2 and pos[2] + 1 <= s2 then
            return
        end
    end

    -- check if cursor is inside a block
    local bracket = line:find("}", pos[2] + 1, true)
    if bracket then
        line = line:sub(0, bracket - 1)
    end

    ---@return ntab.md?
    local function tabout_rec(cursor)
        local md = tab.out(lines, { pos[1], cursor - 1 }, { ignore_beginning = true })

        if not md or md.next.char ~= ")" then
            return
        end

        local between = line:sub(cursor, md.next.pos - 1)
        if vim.trim(between) ~= "" then
            return
        end

        return tabout_rec(md.next.pos + 1) or md
    end

    local md = tabout_rec(pos[2] + 1)

    if md then
        local after_tabout = line:sub(md.next.pos + 1)
        if vim.trim(after_tabout) == "" then
            utils.set_cursor(md.next.pos + 1)
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

    punc = (trigger.format or "%s"):format(punc)
    local line = vim.api.nvim_get_current_line()

    local after_punc = line:sub(pos[2] + 2, pos[2] + 1 + punc:len())
    if after_punc:find(vim.trim(punc), 1, true) then
        return
    end

    local oi = utils.find_opening(info, line, pos[2])
    if not oi then
        return
    end

    local cond = trigger.cond
    if cond and not line:sub(oi + 1, pos[2]):match(cond) then
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
