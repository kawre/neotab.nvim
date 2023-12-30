---@class ntab.config
local config = {}

---@alias ntab.info { open: string, close: string }

---@alias ntab.behavior "nested" | "closing"

---@class ntab.user.config
local defaults = {
    tabkey = "<Tab>",
    act_as_tab = true, -- defaults to tab if tabout action is not available
    behavior = "nested", ---@type ntab.behavior
    pairs = { ---@type ntab.info[]
        { open = "(", close = ")" },
        { open = "[", close = "]" },
        { open = "{", close = "}" },
        { open = "'", close = "'" },
        { open = "\"", close = "\"" },
        { open = "`", close = "`" },
        { open = "<", close = ">" },
    },
    exclude = {},
    smart_punctuators = {
        enabled = false,

        semicolon = {
            enabled = false,
            ft = { "cs", "c", "cpp", "java", "javascript", "typescript", "go", "dart" },
        },

        comma = {
            enabled = false,
            triggers = {
                { open = "'", close = "'" },
                { open = "\"", close = "\"" },
            },
            exclude = {},
        },
    },
}

---@type ntab.user.config
config.user = {}

---@type ntab.info[]
config.tabbable = {}

config.debug = false

config.name = "nvim-tabout"

config.setup = function(options)
    config.user = vim.tbl_deep_extend("force", defaults, options or {})
    config.debug = config.user.debug
    config.tabbable = config.user.pairs
end

return config
