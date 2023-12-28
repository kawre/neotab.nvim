local M = { name = "nvim-tabout" }

---@alias Tabout.set { open: string, close: string }

---@class TaboutOptions
local defaults = {
    tabkey = nil,
    default_to_tab = true, -- defaults to tab if tabout action is not available
    completion = true,
    debug = true,
    tabbable = { ---@type Tabout.set
        { open = "(", close = ")" },
        { open = "[", close = "]" },
        { open = "{", close = "}" },
        { open = "'", close = "'" },
        { open = "\"", close = "\"" },
        { open = "`", close = "`" },
        { open = "<", close = ">" },
    },
    semicolon = {
        enabled = true,
        triggers = { ";" },
    },
    exclude = {},
}

---@type TaboutOptions
M.user = {}
M.tabbable = {}
M.debug = true
M.name = "nvim-tabout"

M.setup = function(options)
    M.user = vim.tbl_deep_extend("force", {}, defaults, options or {})
    M.tabbable = vim.tbl_extend("force", {}, M.user.tabbable)
end

return M
