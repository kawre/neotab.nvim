---@alias ntab.info { pos: integer, char: string }

---@alias ntab.pair { open: string, close: string }

---@alias ntab.out.opts { ignore_beginning?: boolean }

---@alias ntab.behavior
---| "nested"
---| "closing"

---@class ntab.md
---@field prev ntab.info
---@field next ntab.info
---@field pos integer

---@class ntab.trigger
---@field pairs ntab.pair[]
---@field space? { before?: boolean, after?: boolean }
---@field ft? string[]
