local M = {}

---@alias Tabout.set { open: string, close: string }

---@class Tabout.Config
local defaults = {
    tabkey = "<Tab>",
    default_to_tab = true, -- defaults to tab if tabout action is not available
    debug = false,
    tabbable = { ---@type Tabout.set
        { open = "(", close = ")" },
        { open = "[", close = "]" },
        { open = "{", close = "}" },
        { open = "'", close = "'" },
        { open = "\"", close = "\"" },
        { open = "`", close = "`" },
        { open = "<", close = ">" },
    },
    exclude = {},
}

---@type Tabout.Config
M.user = {}
M.tabbable = {}
M.debug = true
M.name = "nvim-tabout"

M.setup = function(options)
    M.user = vim.tbl_deep_extend("force", {}, defaults, options or {})

    M.tabbable = M.user.tabbable
end

return M
