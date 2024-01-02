local api = vim.api

local config = require("neotab.config")
local log = require("neotab.logger")
local utils = require("neotab.utils")
local tab = require("neotab.tab")

---@class ntab
local neotab = {}

local enabled = true

function neotab.toggle()
    enabled = not enabled
end

function neotab.tabout()
    if not enabled or vim.tbl_contains(config.user.exclude, vim.bo.filetype) then
        return utils.tab()
    end

    local lines = api.nvim_buf_get_lines(0, 0, -1, false)
    local pos = api.nvim_win_get_cursor(0)
    local md = tab.out(lines, pos)
    log.debug(md, "md")

    if md then
        utils.set_cursor(md.pos)
    else
        utils.tab()
    end
end

---@param options ntab.user.config
function neotab.setup(options)
    config.setup(options)

    utils.map("i", "<Plug>(neotab-out)", '<Cmd>lua require("neotab").tabout()<CR>')

    if config.user.tabkey ~= "" then
        api.nvim_set_keymap("i", config.user.tabkey, "<Plug>(neotab-out)", { silent = true })
    end

    if config.user.smart_punctuators.enabled then
        api.nvim_create_autocmd("InsertCharPre", {
            callback = require("neotab.punctuators").handle,
        })
    end
end

return neotab
