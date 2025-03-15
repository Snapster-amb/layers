---
-- AshitaCore memory access call wrapper.
--
-- Anything that access memory, packets, or libraries in a windower/gearswap incompatible way should be defined here.
local memory = {}

---
-- Generate a table of valid status effect names
memory.GetStatusEffectNames = function()
    local statusEffects = {}
    local resourceManager = AshitaCore:GetResourceManager()
    for i = 1, 700 do
        local statusEffect = resourceManager:GetString('buffs.names', i)
        if statusEffect then
            statusEffects[statusEffect] = i
        end
    end
    return statusEffects
end

---
-- Generate a table of valid status effect names
memory.GetZoneNames = function()
    local zones = {}
    local resourceManager = AshitaCore:GetResourceManager()
    for i = 1, 700 do
        local zone = resourceManager:GetString('zones.names', i)
        if zone then
            zones[zone] = i
        end
    end
    return zones
end

---
-- Get the player's current level
--
-- This should return the player's reduced level if under level sync
memory.GetMainJobLevel = function()
    return AshitaCore:GetMemoryManager():GetPlayer():GetMainJobLevel()
end

---
-- Evaluate an item can be equipped at a provided level
-- @param item The item name (may be a string or table)
-- @param level The player's level
memory.EvaluateItem = function(item, level)
    if type(item) == 'string' then
        local resource = AshitaCore:GetResourceManager():GetItemByName(item, 0);
        if (resource ~= nil) then
            return (level >= resource.Level);
        end
    elseif type(item) == 'table' then
        if type(item.Level) == 'number' then
            return (level >= item.Level);
        else
            local resource = AshitaCore:GetResourceManager():GetItemByName(item.Name, 0);
            if (resource ~= nil) then
                return (level >= resource.Level);
            end
        end
    end
    return false;
end

return memory
