local api = vim.api

local config = require("ntab.config")
local log = require("ntab.logger")
local utils = require("ntab.utils")
local tab = require("ntab.tab")

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

    local lines = api.nvim_buf_get_lines(0, 0, -1, false)
    local pos = api.nvim_win_get_cursor(0)
    local md = tab.out(lines, pos)

    if md then
        utils.set_cursor(md.pos)
    else
        utils.tab()
    end
end

---@param options ntab.user.config
function ntab.setup(options)
    config.setup(options)

    utils.map("i", "<Plug>(ntab.out)", '<Cmd>lua require("ntab").tabout()<CR>')

    if config.user.tabkey ~= "" then
        api.nvim_set_keymap("i", config.user.tabkey, "<Plug>(ntab.out)", { silent = true })
    end

    if config.user.smart_punctuators.enabled then
        api.nvim_create_autocmd("InsertCharPre", {
            callback = require("ntab.punctuators").handle,
        })
    end
end

return ntab
