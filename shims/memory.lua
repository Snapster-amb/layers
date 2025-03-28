---
-- Windower memory access call wrapper.
--
-- Windower versions of anything that access memory, packets, or libraries should be defined here.
local memory = {}

local res = require("resources")

---
-- Generate a table of valid status effect names
memory.GetStatusEffectNames = function()
    local statusEffects = {}
    for id, buff in pairs(res.buffs) do
        statusEffects[buff.en] = id
    end
    return statusEffects
end

---
-- Generate a table of valid status effect names
memory.GetZoneNames = function()
    local zones = {}
    for id, zone in pairs(res.zones) do
        zones[zone.en] = id
    end
    return zones
end

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

---
-- Get the player's current zone
memory.GetCurrentZone = function()
    return windower.ffxi.get_info().zone
end

---
-- Register a callback with a incoming chunk event
memory.RegisterPacketIn = function(name, func)
    local wrapper = function(id, data, modified, injected, blocked)
        local e = {
            id = id,
            data = data,
            data_modified = modified,
            injected = injected,
            blocked = blocked
        }
        func(e)
    end
    windower.raw_register_event('incoming chunk', wrapper)
end

return memory
