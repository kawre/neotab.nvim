local api = vim.api

local config = require("tabout.config")
local log = require("tabout.logger")
local utils = require("tabout.utils")

---@class tab.Tabout
local Tabout = {}

local enabled = true

Tabout.toggle = function()
    enabled = not enabled
end

function Tabout.fallback()
    if config.user.default_to_tab then
        api.nvim_feedkeys(utils.replace("<Tab>"), "n", false)
    end
end

function Tabout.tabout()
    if not enabled or vim.tbl_contains(config.user.exclude, vim.bo.filetype) then
        return Tabout.fallback()
    end

    local line = api.nvim_get_current_line()
    local pos = api.nvim_win_get_cursor(0)

    local before_cursor = line:sub(0, pos[2])
    if vim.trim(before_cursor) == "" then
        return Tabout.fallback()
    end

    local curr_char = utils.adj_char(0)
    local curr_info = utils.get_info(curr_char)

    if curr_info then
        return utils.move_cursor(1, 0)
    end

    local prev_char = utils.adj_char(-1)
    local prev_info = utils.get_info(prev_char)

    if prev_info then
        local offset = utils.find_next_pos(prev_info, line, pos[2])
        if offset then
            return utils.move_cursor(offset, 0)
        end
    end

    Tabout.fallback()
end

---@param options TaboutOptions
Tabout.setup = function(options)
    config.setup(options)

    utils.map("i", "<Plug>(Tabout)", "<Cmd>lua require(\"tabout\").tabout()<CR>")

    if config.user.tabkey and config.user.tabkey ~= "" then
        api.nvim_set_keymap(
            "i",
            config.user.tabkey,
            "<Plug>(Tabout)",
            { silent = true, expr = true }
        )
    end
end

return Tabout
