local api = vim.api

local config = require("nvim-tabout.config")
local log = require("nvim-tabout.logger")
local utils = require("nvim-tabout.utils")

---@class ntab
local ntab = {}

local enabled = true

function ntab.toggle()
    enabled = not enabled
end

function ntab.tabout()
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

---@param options ntab.user.config
function ntab.setup(options)
    config.setup(options)

    utils.map("i", "<Plug>(Tabout)", "<Cmd>lua require(\"nvim-tabout\").tabout()<CR>")

    if config.user.tabkey ~= "" then
        api.nvim_set_keymap("i", config.user.tabkey, "<Plug>(Tabout)", { silent = true })
    end
end

return ntab
