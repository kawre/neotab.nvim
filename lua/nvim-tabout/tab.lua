local utils = require("nvim-tabout.utils")
local log = require("nvim-tabout.logger")
local api = vim.api

---@class ntab.tab
local tab = {}

---@param line string
---@param pos integer[]
---@param opts? table
---
---@return ntab.md | nil
function tab.out(line, pos, opts)
    log.debug("------- TAB -------")
    local before_cursor = line:sub(0, pos[2])
    if vim.trim(before_cursor) == "" then
        return
    end

    -- convert from 0 to 1 based indexing
    local col = pos[2] + 1

    local prev_info = utils.get_info(utils.adj_char(-1))
    if prev_info then
        local md = utils.find_next(prev_info, line, col)

        if md then
            if md.pos == col then
                md.pos = md.pos + 1
            end

            return log.debug(md)
        end
    end

    local curr_info = utils.get_info(line:sub(col, col))
    if curr_info then
        local prev = {
            pos = col,
            char = line:sub(col, col),
            events = "curr",
        }

        local md = {
            prev = prev,
            next = prev,
            pos = col + 1,
        }

        return log.debug(md)
    end

    log.debug("----- TAB END -----")
end

return tab
