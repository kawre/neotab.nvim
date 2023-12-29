local api = vim.api

local config = require("nvim-tabout.config")
local log = require("nvim-tabout.logger")
local utils = require("nvim-tabout.utils")
local tab = require("nvim-tabout.tab")

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
    local offset = tab.out(line, pos)

    if offset then
        utils.move_cursor(offset, 0, pos)
    else
        utils.tab()
    end
end

---@param options ntab.user.config
function ntab.setup(options)
    config.setup(options)

    utils.map("i", "<Plug>(Tabout)", "<Cmd>lua require(\"nvim-tabout\").tabout()<CR>")

    if config.user.tabkey ~= "" then
        api.nvim_set_keymap("i", config.user.tabkey, "<Plug>(Tabout)", { silent = true })
    end

    if config.user.smart_punctuators.enabled then
        api.nvim_create_autocmd("InsertCharPre", {
            callback = require("nvim-tabout.punctuators").handle,
        })
    end
end

return ntab
