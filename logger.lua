---
-- Logs information to chatlog.
--
-- The logger can be muted, but only logging calls made with the mutable parameter will be muted.
-- This is used to silenced spammy logging messages when LuAshitacast is used, as it will call one of the
-- callbacks on every outgoing packet.
---
local logger = {}

logger.levels = {
    Trace = 1,
    Debug = 2,
    Info = 3,
    Warn = 4,
    Error = 5,
    Off = 6
}

logger.level = M('Trace', 'Debug', 'Info', 'Warn', 'Error', 'Fatal', 'Off')

local muted = false

local function logMessage(loggingLevel, message, mutable)
    if logger.level.index <= logger.levels[loggingLevel] and (not mutable or not muted) then
        print(chat.header("Layers:" .. loggingLevel) .. message)
    end
end

for level, value in pairs(logger.levels) do
    if level == 'Warn' then
        logger[level] = function(message, event) logMessage(level, chat.warn(message), event) end
    elseif level == 'Error' then
        logger[level] = function(message, event) logMessage(level, chat.error(message), event) end
    else
        logger[level] = function(message, event) logMessage(level, message, event) end
    end
end

---
-- Mute the logger for any future calls with the mutable parameter
logger.Mute = function()
    muted = true
end

---
-- Unmute the logger
logger.Unmute = function()
    muted = false
end

logger.level:set('Info')

return logger
