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

---
-- Get the player's current zone
memory.GetCurrentZone = function()
    return AshitaCore:GetMemoryManager():GetParty():GetMemberZone(0)
end

---
-- Register a callback with a packet_in event
memory.RegisterPacketIn = function(name, func)
    ashita.events.register("packet_in", name, func)
end

---
-- Get the luashitacast version of the provided element name
memory.GetAddonElementName = function(element)
    if element == 'Lightning' then
        return 'Thunder'
    else
        return element
    end
end

---
-- Get the maximum number of items that can be stored in the provided container
memory.GetContainerCountMax = function(container)
    return AshitaCore:GetMemoryManager():GetInventory():GetContainerCountMax(container)
end

---
-- Get the current number of items that are stored in the provided container
memory.GetContainerCount = function(container)
    return AshitaCore:GetMemoryManager():GetInventory():GetContainerCount(container)
end

---
-- Get the item from the provided container and index
memory.GetContainerItem = function(container, index)
    return AshitaCore:GetMemoryManager():GetInventory():GetContainerItem(container, index)
end

---
-- Get an item using the provided name
memory.GetItemByName = function(name)
    return AshitaCore:GetResourceManager():GetItemByName(name, 0)
end

---
-- Get the filesystem path to the Layers extension root directory.
memory.GetExtensionPath = function()
    local base = AshitaCore:GetInstallPath()
    return string.format('%sconfig\\addons\\luashitacast\\layers', base)
end

---
-- Send a command to the chat client
memory.QueueCommand = function(command)
    AshitaCore:GetChatManager():QueueCommand(1, command)
end

---
-- Reload the extension
memory.Reload = function()
    AshitaCore:GetChatManager():QueueCommand(1, '/lac reload')
end

---
-- Return a table containing the players equipment
memory.GetEquipment = function()
    local equipment = {}
    for k, v in pairs(gData.GetEquipment()) do
        equipment[k] = v.Name
    end
    return equipment
end

---
-- Return the description of an item
memory.GetItemDescription = function(item)
    local resource = AshitaCore:GetResourceManager():GetItemByName(item, 0)
    if not resource or resource.Name[1] ~= item then
        logger.Error("Provided item " .. item .. " not found in resources")
        return ""
    else
        return resource.Description[1]
    end
end

return memory
