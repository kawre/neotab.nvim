# ntab.nvim

Simple yet convenient Neovim plugin for tabbing in and out of brackets, parentheses, quotes, and more.

## why `ntab.nvim`

...

<!-- ## 💡 Expected behaviour -->

<!---->

<!-- | Before | Key | After | Setting | -->

<!-- | --- | --- | --- | --- | -->

<!-- | `{\|}` | `<Tab>` | `{}\| ` | - | -->

<!-- | `\|"string"` | `<Tab>` | `"\|string" ` | - | -->

<!-- | `"str\|ing"` | `<Tab>` | `"str  \|ing"` | - | -->

<!-- | `"str\|ing"` | `<Tab>` | `"str\|ing"` | `default_to_tab = false` | -->

<!-- | `fn foo(bar\|) {}` | `<Tab>` | `fn foo(bar)\| {}` | - | -->

<!-- | `{\|foo}` | `<Tab>` | `{foo\|}` | - | -->

## 📬 Requirements

- [Neovim] >= 0.5.0

## 📦 Installation

- [lazy.nvim]

```lua
{
    "kawre/ntab.nvim",
    event = "InsertEnter",
    opts = {
        -- configuration goes here
    },
}
```

## 🛠️ Configuration

### ⚙️ default configuration

```lua
{
    tabkey = "<Tab>",

    act_as_tab = true, -- defaults to tab if tabout action is not available

    behavior = "nested", ---@type ntab.behavior

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
```

### tabkey

key switch triggers tabout

```lua
tabkey = "<Tab>",
```

### act_as_tab

fallback to tab, if tabout is not available

```lua
act_as_tab = true,
```

### behavior

#### nested

prioritize nested pair first

#### closing

prioritize closing pair first

[lazy.nvim]: https://github.com/folke/lazy.nvim
[neovim]: https://github.com/neovim/neovim
