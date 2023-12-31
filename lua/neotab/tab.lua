local utils = require("neotab.utils")
local log = require("neotab.logger")

---@class ntab.tab
local tab = {}

---@param lines string[]
---@param pos integer[]
---@param opts? ntab.out.opts
---
---@return ntab.md | nil
function tab.out(lines, pos, opts)
    opts = vim.tbl_extend("force", {
        ignore_beginning = false,
    }, opts or {})

    local line = lines[pos[1]]

    log.debug("------- TAB -------")

    if not opts.ignore_beginning then
        local before_cursor = line:sub(0, pos[2])
        if vim.trim(before_cursor) == "" then
            return
        end
    end

    -- convert from 0 to 1 based indexing
    local col = pos[2] + 1

    local prev_info = utils.get_info(line:sub(col - 1, col - 1))
    if prev_info then
        local md = utils.find_next(prev_info, line, col)
        if md then
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
end

return tab
