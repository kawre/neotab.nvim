<div align="center">

# 🧩 neotab.nvim

Simple yet convenient Neovim plugin for tabbing in and out of brackets,
parentheses, quotes, and more.

</div>

https://github.com/kawre/neotab.nvim/assets/69250723/86754608-352e-4d6f-b2a6-cf5b6fd848a9

## why `neotab.nvim`

Unlike other similar plugins that tabout out of `treesitter` nodes,
`neotab.nvim` uses simple logic to move in and out of pairs or
find the next best matching pair.

This approach ensures a consistent behavior regardless of the file type
or the state of the parsed `treesitter` tree.

This plugin doesn't aim to replace existing similar plugins.
Instead, it offers a different, less fancy but more predictable
and consistent method for tabbing out of pairs.

<!-- ## 📬 Requirements -->

<!---->

<!-- - [Neovim] >= 0.8.0 -->

## 📦 Installation

- [lazy.nvim]

```lua
{
    "kawre/neotab.nvim",
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
    act_as_tab = true, -- fallback to tab, if `tabout` action is not available
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
        escape = {
            enabled = false,
            triggers = {}, ---@type table<string, ntab.trigger>
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

fallback to tab, if `tabout` action is not available

```lua
act_as_tab = true,
```

### behavior

#### nested

prioritize valid nested pairs first

https://github.com/kawre/neotab.nvim/assets/69250723/3ad6c1ef-814f-431c-a8c0-fcdc85b560cf

#### closing

prioritize closing pair first

https://github.com/kawre/neotab.nvim/assets/69250723/fdb7158d-ec09-437e-9c20-580cdff0719a

### exclude

ignore these filetypes for `tabout`

```lua
exclude = {},
```

## smart punctuators

### semicolon

intellij like behavior for semicolons

```lua
semicolon = {
    enabled = false,
    ft = { "cs", "c", "cpp", "java" },
},
```

### escape

escapes pairs with specified punctuators

configuration from `demo.mp4`

```lua
escape = {
    enabled = true,
    triggers = { ---@type table<string, ntab.trigger>
        ["+"] = {
            pairs = {
                { open = '"', close = '"' },
            },
            space = { before = true, after = true },
            ft = { "java" },
        },
        [","] = {
            pairs = {
                { open = "'", close = "'" },
                { open = '"', close = '"' },
            },
            space = { after = true },
        },
    },
},
```

When the `ft` is defined, the corresponding trigger will apply to the specified
file types. Otherwise, it will be effective no matter the file type.

## 🚀 Usage

There is a high chance [neotab.nvim] won't work out of the box, because of other
plugins/config overriding the [tabkey](#tabkey) keymap.

To help you find the location that overrides the [tabkey](#tabkey) you can use

```
:verbose imap <Tab>
```

## 🍴 Recipes

### [LuaSnip] and [lazy.nvim] integration example

1. set [tabkey](#tabkey) to `""`

2. set `<Plug>(neotab-out)` as a fallback to luasnip

```lua
{
    "L3MON4D3/LuaSnip",
    build = "make install_jsregexp",
    dependencies = {
        "neotab.nvim",
    },
    keys = {
        {
            "<Tab>",
            function()
                return require("luasnip").jumpable(1)
                    and "<Plug>luasnip-jump-next"
                    or "<Plug>(neotab-out)"
            end,
            expr = true,
            silent = true,
            mode = "i",
        },
    },
}
```

### [nvim-cmp] and [luasnip] integration example

1. set [tabkey](#tabkey) to `""`

2. set `require("neotab").tabout()` as a fallback to both nvim-cmp and luasnip

```lua
["<Tab>"] = function()
  if cmp.visible() then
    cmp.confirm({
        behavior = cmp.ConfirmBehavior.Insert,
        select = true
      })
  elseif require("luasnip").jumpable(1) then
    require("luasnip").jump(1)
  else
    require("neotab").tabout()
  end
end,
```

## 🙌 Credits

- [tabout.nvim](https://github.com/abecodes/tabout.nvim)

- [TabOut plugin for vscode](https://github.com/albertromkes/tabout)

[lazy.nvim]: https://github.com/folke/lazy.nvim
[luasnip]: https://github.com/L3MON4D3/LuaSnip
[neotab.nvim]: https://github.com/kawre/neotab.nvim
[nvim-cmp]: https://github.com/hrsh7th/nvim-cmp
