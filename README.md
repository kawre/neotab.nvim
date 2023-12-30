# ntab.nvim

Simple yet convenient Neovim plugin for tabbing in and out of brackets,
parentheses, quotes, and more.

## why `ntab.nvim`

Rather than use `treesitter` nodes like other alike plugins, `ntab.nvim`
uses simple logic to move out of, or find the next best matching pair.

By doing so, you can expect the same consistent behavior
regardless of the file type or state of the parsed `treesitter` tree.

<!-- ## 📬 Requirements -->

<!---->

<!-- - [Neovim] >= 0.8.0 -->

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

    act_as_tab = true,

    behavior = "nested", ---@type ntab.behavior

    pairs = { ---@type ntab.pair[]
        { open = "(", close = ")" },
        { open = "[", close = "]" },
        { open = "{", close = "}" },
        { open = "'", close = "'" },
        { open = '"', close = '"' },
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
                { open = '"', close = '"' },
            },

            exclude = {},
        },
    },
}
```

### tabkey

key which triggers `tabout`

to not bind to any key, set to `""`

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

https://github.com/kawre/ntab.nvim/assets/69250723/31c0d687-170e-40d8-a2d8-49cd237cb15b

prioritize valid nested pairs first

#### closing

https://github.com/kawre/ntab.nvim/assets/69250723/70c79dda-ddf6-4505-9838-0ce85d9d3fe6

prioritize closing pair first

### exclude

ignore these filetypes for `tabout`

```lua
exclude = {},
```

## smart punctuators

### semicolon

intellij like behavior for semicolons

https://github.com/kawre/ntab.nvim/assets/69250723/12d08d02-666c-4da6-a9b7-59f9f104bf58

## 🚀 Usage

There is a high chance [ntab.nvim] won't work out of the box, because of other
plugins/config overriding the [tabkey](#tabkey) keymap.

To help you find the location that overrides the [tabkey](#tabkey) you can use

```
:verbose imap <Tab>
```

## 🍴 Recipes

### [LuaSnip] and [lazy.nvim] integration example

1. set [tabkey](#tabkey) to `""`

2. set `<Plug>(ntab.out)` as a fallback to luasnip

```lua
local M = {
    "L3MON4D3/LuaSnip",
    build = "make install_jsregexp",
    dependencies = {
        "ntab.nvim",
    },
    event = "VeryLazy",
}

M.keys = {
    {
        "<Tab>",
        function()
            return require("luasnip").jumpable(1)
                and "<Plug>luasnip-jump-next"
                or "<Plug>(ntab.out)"
        end,
        expr = true,
        silent = true,
        mode = "i",
    },
}
```

### [nvim-cmp] and [luasnip] integration example

1. set [tabkey](#tabkey) to `""`

2. set `require("ntab").tabout()` as a fallback to both nvim-cmp and luasnip

```lua
["<Tab>"] = function(fallback)
  if cmp.visible() then
    cmp.confirm({
        behavior = cmp.ConfirmBehavior.Insert,
        select = true
      })
  elseif require("luasnip").jumpable(1) then
    require("luasnip").jump(1)
  else
    require("ntab").tabout()
  end
end,
```

## 🙌 Credits

- [tabout.nvim](https://github.com/abecodes/tabout.nvim)

- [TabOut plugin for vscode](https://github.com/albertromkes/tabout)

[lazy.nvim]: https://github.com/folke/lazy.nvim
[luasnip]: https://github.com/L3MON4D3/LuaSnip
[ntab.nvim]: https://github.com/kawre/ntab.nvim
[nvim-cmp]: https://github.com/hrsh7th/nvim-cmp
