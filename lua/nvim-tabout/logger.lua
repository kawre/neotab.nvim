local config = require("nvim-tabout.config")
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
---@param show? boolean
---@return any
logger.debug = function(msg, show)
    if not config.debug then
        return msg
    end

    local lvl = (show == nil or not show) and lvls.DEBUG or lvls.ERROR
    logger.log(msg, lvl)

    return msg
end

return logger
