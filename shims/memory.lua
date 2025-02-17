---
-- Windower memory access call wrapper.
--
-- Windower versions of anything that access memory, packets, or libraries should be defined here.
local memory = {}

local res = require("resources")

---
-- Get the player's current level
--
-- This should return the player's reduced level if under level sync
memory.GetMainJobLevel = function()
    return player.main_job_level
end

---
-- Evaluate an item can be equipped at a provided level
-- @param item The item name (may be a string or table)
-- @param level The player's level
memory.EvaluateItem = function(item, level)
    if type(item) == 'string' then
        local search = res.items:name(item)
        local id, resource = next(search, nil)
        if (id ~= nil) then
            return (level >= resource.level)
        end
    elseif type(item) == 'table' then
        if type(item.level) == 'number' then
            return (level >= item.level)
        else
            local search = res.items:name(item.name)
            local id, resource = next(search, nil)
            if (id ~= nil) then
                return (level >= resource.level)
            end
        end
    end
    return false
end

return memory
