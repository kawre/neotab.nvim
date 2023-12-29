local utils = require("nvim-tabout.utils")
local log = require("nvim-tabout.logger")
local api = vim.api

---@class ntab.tab
local tab = {}

---@param line string
---@param pos integer[]
---
---@return integer|nil, ntab.pair|nil, string|nil
function tab.out(line, pos)
    local before_cursor = line:sub(0, pos[2])
    if vim.trim(before_cursor) == "" then
        return
    end

    local prev_info = utils.get_info(utils.adj_char(-1))
    if prev_info then
        local offset, char = utils.find_next(prev_info, line, pos[2])

        if offset then
            log.debug({
                char = char,
                from = "prev",
            })
            return offset, prev_info, char
        end
    end

    local curr_info = utils.get_info(utils.adj_char(0))
    if curr_info then
        log.debug({
            char = line:sub(pos[2] + 1, pos[2] + 1),
            from = "curr",
        })
        return 1, curr_info, line:sub(pos[2] + 1, pos[2] + 1)
    end
end

return tab
