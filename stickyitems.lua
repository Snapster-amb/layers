---
-- Manages whitelisted items that stay equipped under certain conditions.
--
-- Charged items stay equipped if their use time remaining <= 0.
-- Enchanted items stay equiped if their use time remaining <= 0 or the player has the Enchantment buff active.
---
local stickyitems = {}

local chargedItems = {}

local enchantedItems = {}

local timePointer = ashita.memory.find('FFXiMain.dll', 0, '8B0D????????8B410C8B49108D04808D04808D04808D04C1C3', 2, 0)

local vanaOffset = 0x3C307D70

local function getTimeUTC()
    local ptr = ashita.memory.read_uint32(timePointer)
    ptr = ashita.memory.read_uint32(ptr)
    return ashita.memory.read_uint32(ptr + 0x0C)
end

local function itemChargeIsReady(item)
    local currentTime = getTimeUTC()
    local useTimeRemaining = (struct.unpack('L', item.Item.Extra, 5) + vanaOffset) - currentTime
    local remainingCharges = item.Item.Extra:byte(2)
    return remainingCharges > 0 and useTimeRemaining <= 0
end

local extraSlots = {
    ["cannot equip hand, leg, or footgear"] = {"Hands", "Legs", "Feet"},
    ["cannot equip handgear"] = {"Hands"},
    ["cannot equip footgear"] = {"Feet"},
    ["cannot equip headgear"] = {"Head"},
    ["cannot equip leggear"] = {"Hands", "Legs", "Feet"}
}

local function getExtraSlots(item)
    local resource = AshitaCore:GetResourceManager():GetItemByName(item, 0)
    local description = string.lower(resource.Description[1])
    for keyphrase, slots in pairs(extraSlots) do
        if string.find(description, keyphrase) then
            return slots
        end
    end
    return {}
end

local function itemIsCharged(item)
    local resource = AshitaCore:GetResourceManager():GetItemByName(item, 0)
    if not resource or resource.Name[1] ~= item then
        logger.Error("Provided item " .. item .. " not found in resources")
        return false
    elseif bit.band(resource.Flags, 2048) == 0 then
        logger.Error("Provided item " .. item .. " is not equippable")
        return false
    elseif resource.MaxCharges == 0 then
        logger.Error("Provided item " .. item .. " is not usable")
        return false
    else
        return true
    end
end

local function bind(item, slot)
    gFunc.Equip(slot, item)
    local extraSlots = getExtraSlots(item.Name)
    for _, extraSlot in pairs(extraSlots) do
        gFunc.Equip(extraSlot, 'ignore')
    end
    local call = gData.GetCurrentCall()
    if call == 'HandleMidcast' or call == 'HandleMidshot' or call == 'N/A' then
        gFunc.InterimEquip(slot, item)
        for _, extraSlot in pairs(extraSlots) do
            gFunc.InterimEquip(extraSlot, 'ignore')
        end
    end
end

---
-- Binds any charged or enchanted items that should remain equipped.
--
-- This should be called after all of the other user event code
stickyitems.Bind = function()
    for slot, item in pairs(gData.GetEquipment()) do
        if chargedItems[item.Name] and itemChargeIsReady(item) then
            logger.Debug(chat.message("Equipping ") .. chat.charged("Charged") .. chat.message(" item ") .. chat.location(item.Name) .. chat.message(" to ") .. chat.group(slot), true)
            bind(item, slot)
        elseif enchantedItems[item.Name] and (itemChargeIsReady(item) or gData.GetBuffCount(enchantedItems[item.Name]) > 0) then
            logger.Debug(chat.message("Equipping ") .. chat.charged("Enchanted") .. chat.message(" item ") .. chat.location(item.Name) .. chat.message(" to ") .. chat.group(slot), true)
            bind(item, slot)
        end
    end
end

---
-- Add an item to the set of charged items.
--
-- @param item The name of the item (i.e. "Warp Cudgel")
stickyitems.AddChargedItem = function(item)
    if type(item) ~= 'string' then
        logger.Error("Unable to add item to charged items set - provided item name is not a string")
    elseif not itemIsCharged(item) then
        logger.Error("Unable to add item to charged items set")
    else
        logger.Debug(chat.message("Added ") .. chat.location(item) .. chat.message(" to ") .. chat.charged("Charged") .. chat.message(" items set"))
        chargedItems[item] = true
    end
end

---
-- Add an item to the set of charged items.
--
-- @param item The name of the item (i.e. "Warp Cudgel")
stickyitems.RemoveChargedItem = function(item)
    if type(item) ~= 'string' then
        logger.Error("Unable to remove item from charged items set - provided item name is not a string")
    elseif not itemIsCharged(item) then
        logger.Error("Unable to remove item from charged items set")
    else
        logger.Info(chat.message("Removed ") .. chat.location(item) .. chat.message(" from ") .. chat.charged("Charged") .. chat.message(" items set"))
        chargedItems[item] = nil
    end
end

---
-- Add an item to the set of enchanted items.
--
-- @param item The name of the item (i.e. "High Brth. Mantle")
stickyitems.AddEnchantedItem = function(item, buff)
    if not buff then
        buff = "Enchantment"
    end
    if type(item) ~= 'string' then
        logger.Error("Unable to add item to enchanted items set - provided item name is not a string")
    elseif not itemIsCharged(item) then
        logger.Error("Unable to add item to enchanted item set")
    else
        logger.Debug(chat.message("Added ") .. chat.location(item) .. chat.message(" to ") .. chat.charged("Enchanted") .. chat.message(" items set"))
        enchantedItems[item] = buff
    end
end

---
-- Add an item to the set of enchanted items.
--
-- @param item The name of the item (i.e. "High Brth. Mantle")
stickyitems.RemoveEnchantedItem = function(item)
    if type(item) ~= 'string' then
        logger.Error("Unable to remove item from enchanted items set - provided item name is not a string")
    elseif not itemIsCharged(item) then
        logger.Error("Unable to remove item from enchanted item set")
    else
        logger.Info(chat.message("Removed ") .. chat.location(item) .. chat.message(" from ") .. chat.charged("Enchanted") .. chat.message(" items set"))
        enchantedItems[item] = nil
    end
end

return stickyitems
