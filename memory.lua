---
-- AshitaCore memory access call wrapper.
--
-- Anything that access memory, packets, or libraries in a windower/gearswap incompatible way should be defined here.
local memory = {}

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
