# nvim-tabout
Convenient Neovim plugin for tabbing in and out of brackets, parentheses, quotes, and more.

## 💡 Expected behaviour
| Before | Key | After | Setting |
| --- | --- | --- | --- |
| `{\|}` | `<Tab>` | `{}\| ` | - |
| `\|"string"` | `<Tab>` | `"\|string" ` | - |
| `"str\|ing"` | `<Tab>` | `"str  \|ing"` | - |
| `"str\|ing"` | `<Tab>` | `"str\|ing"` | `default_to_tab = false` |
| `fn foo(bar\|) {}` | `<Tab>` | `fn foo(bar)\| {}` | - |

## 💾 installation
### [lazy](https://github.com/folke/lazy.nvim)
```lua
return {
    "kawre/nvim-tabout",
    cmd = "Tabout",
    opts = {},
}
```
