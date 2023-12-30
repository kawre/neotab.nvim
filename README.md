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

- [Neovim] >= 0.8.0

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

            ft = { "cs", "c", "cpp", "java" },
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

https://github.com/kawre/nvim-tabout/assets/69250723/31c0d687-170e-40d8-a2d8-49cd237cb15b

prioritize valid nested pairs first

#### closing

https://github.com/kawre/nvim-tabout/assets/69250723/70c79dda-ddf6-4505-9838-0ce85d9d3fe6

prioritize closing pair first

### exclude

ignore these filetypes for `tabout`

```lua
exclude = {},
```

## smart punctuators

### semicolon

intellij like behavior for semicolons

https://github.com/kawre/nvim-tabout/assets/69250723/12d08d02-666c-4da6-a9b7-59f9f104bf58

[lazy.nvim]: https://github.com/folke/lazy.nvim
[neovim]: https://github.com/neovim/neovim
