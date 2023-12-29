---@class ntab.config
local config = {}

---@alias ntab.pair { open: string, close: string }

---@class ntab.user.config
local defaults = {
    tabkey = "<Tab>",
    act_as_tab = true, -- defaults to tab if tabout action is not available
    behavior = "nested",
    debug = false,
    pairs = { ---@type ntab.pair[]
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

---@type ntab.user.config
config.user = {}

---@type ntab.pair[]
config.tabbable = {}

config.debug = false

config.name = "nvim-tabout"

config.setup = function(options)
    config.user = vim.tbl_deep_extend("force", defaults, options or {})
    config.debug = config.user.debug
    config.tabbable = config.user.pairs
end

return config
