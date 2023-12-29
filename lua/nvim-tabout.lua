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

function Tabout.fallback()
    if config.user.act_as_tab then
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
        Tabout.fallback()
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
