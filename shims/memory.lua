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

---
-- Get the gearswap version of the provided element name
memory.GetAddonElementName = function(element)
    if element == 'Thunder' then
        return 'Lightning'
    else
        return element
    end
end

---
-- Get the maximum number of items that can be stored in the provided container
memory.GetContainerCountMax = function(container)
    local bag = windower.ffxi.get_bag_info(container)
    return bag.max
end

---
-- Get the current number of items that are stored in the provided container
memory.GetContainerCount = function(container)
    local bag = windower.ffxi.get_bag_info(container)
    return bag.count
end

---
-- Get the item from the provided container and index
memory.GetContainerItem = function(container, index)
    local item = windower.ffxi.get_items(container, index)
    if item then
        return {
            Id = item.id,
        }
    end
end

---
-- Get an item using the provided name
memory.GetItemByName = function(name)
    local search = res.items:name(name)
    local id, resource = next(search, nil)
    if (id ~= nil) then
        return {
            Id = id
        }
    end
end

---
-- Get the filesystem path to the Layers extension root directory.
memory.GetExtensionPath = function()
    return string.format('%saddons\\GearSwap\\libs\\layers', windower.windower_path)
end

---
-- Send a command to the chat client
memory.QueueCommand = function(command)
    windower.chat.input(command)
end

---
-- Reload the extension
memory.Reload = function()
    windower.chat.input('//gs reload')
end

---
-- Return a table containing the players equipment
memory.GetEquipment = function()
    local equipment = {}
    local remapped = {
        ['main'] = 'Main',
        ['sub'] = 'Sub',
        ['range'] = 'Range',
        ['ammo'] = 'Ammo',
        ['head'] = 'Head',
        ['neck'] = 'Neck',
        ['left_ear'] = 'Ear1',
        ['right_ear'] = 'Ear2',
        ['body'] = 'Body',
        ['hands'] = 'Hands',
        ['left_ring'] = 'Ring1',
        ['right_ring'] = 'Ring2',
        ['back'] = 'Back',
        ['waist'] = 'Waist',
        ['legs'] = 'Legs',
        ['feet'] = 'Feet'
    }
    for k, v in pairs(remapped) do
        equipment[v] = player.equipment[k]
    end
    return equipment
end

---
-- Return the description of an item
memory.GetItemDescription = function(item)
    local search = res.items:name(name)
    local id, resource = next(search, nil)
    if (id ~= nil) then
        return resource.en
    else
        return ""
    end
end

return memory
