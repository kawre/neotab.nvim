local config = require("neotab.config")
local lvls = vim.log.levels

---@class ntab.logger
local logger = {}

local function normalize(msg)
    return type(msg) == "string" and msg or vim.inspect(msg)
end

function logger.log(msg, lvl)
    local title = config.name
    lvl = lvl or lvls.INFO
    msg = normalize(msg)

    if lvl == lvls.DEBUG then
        msg = debug.traceback(msg .. "\n")
    end

    vim.notify(msg, lvl, { title = title })
end

---@param msg any
logger.info = function(msg)
    logger.log(msg)
end

---@param msg any
logger.warn = function(msg)
    logger.log(msg, lvls.WARN)
end

---@param msg any
logger.error = function(msg)
    logger.log(msg, lvls.ERROR)
end

---@param msg any
---@param event? string
---@return any
logger.debug = function(msg, event)
    if not config.debug then
        return msg
    end

    local prev = event and (event .. "\n") or ""
    logger.log(prev .. normalize(msg), lvls.DEBUG)

    return msg
end

return logger
