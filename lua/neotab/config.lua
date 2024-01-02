---@class ntab.config
local config = {
    user = {}, ---@type ntab.user.config
    pairs = {}, ---@type ntab.pair[]
    debug = false,
    name = "neotab.nvim",
}

---@class ntab.user.config
config.defaults = {
    tabkey = "<Tab>",
    act_as_tab = true,
    behavior = "nested", ---@type ntab.behavior
    pairs = { ---@type ntab.pair[]
        { open = "(", close = ")" },
        { open = "[", close = "]" },
        { open = "{", close = "}" },
        { open = "<", close = ">" },
        { open = "'", close = "'" },
        { open = '"', close = '"' },
        { open = "`", close = "`" },
    },
    exclude = {},
    smart_punctuators = {
        enabled = false,
        semicolon = {
            enabled = false,
            ft = { "cs", "c", "cpp", "java" },
        },
        escape = {
            enabled = false,
            triggers = {}, ---@type table<string, ntab.trigger>
        },
    },
}

function config.setup(options)
    config.user = vim.tbl_deep_extend("force", config.defaults, options or {})
    config.debug = config.user.debug
    config.pairs = config.user.pairs
end

return config
