local api = vim.api

local config = require("nvim-tabout.config")
local log = require("nvim-tabout.logger")
local utils = require("nvim-tabout.utils")

---@class Nvim.Tabout
local Tabout = {}

local enabled = true

Tabout.toggle = function()
    enabled = not enabled
end

function Tabout.nested(info, line, col)
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

function Tabout.tabout()
    if not enabled or vim.tbl_contains(config.user.exclude, vim.bo.filetype) then
        return utils.tab()
    end

    local line = api.nvim_get_current_line()
    local pos = api.nvim_win_get_cursor(0)

    local before_cursor = line:sub(0, pos[2])
    if vim.trim(before_cursor) == "" then
        return utils.tab()
    end

    local prev_info = utils.get_info(utils.adj_char(-1))

    if prev_info then
        local offset = utils.find_next(prev_info, line, pos[2])

        if offset then
            return utils.move_cursor(offset, 0)
        end
    end

    local curr_info = utils.get_info(utils.adj_char(0))

    if curr_info then
        utils.move_cursor(1, 0)
    else
        return utils.tab()
    end
end

---@param options ntab
Tabout.setup = function(options)
    config.setup(options)

    utils.map("i", "<Plug>(Tabout)", "<Cmd>lua require(\"nvim-tabout\").tabout()<CR>")

    if config.user.tabkey ~= "" then
        api.nvim_set_keymap("i", config.user.tabkey, "<Plug>(Tabout)", { silent = true })
    end
end

return Tabout
