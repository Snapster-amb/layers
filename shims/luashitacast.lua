---
-- Luashitacast to gearswap global table method invocations are defined here.
---
gFunc = {}

gFunc.EquipSet = function(set)
    equip(set)
end

gFunc.InterimEquipSet = function(set)
    -- TODO make this work for gearswap
end

gFunc.Combine = function(lhs, rhs)
    return set_combine(lhs, rhs)
end

gFunc.LoadFile = function(path)
    return require(string.gsub(path, "\\", "/"), _G)
end

gFunc.EvaluateItem = function(item, level)
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
            local search = res.items:name(item)
            local id, resource = next(search, nil)
            if (id ~= nil) then
                return (level >= resource.level)
            end
        end
    end
    return false
end

gFunc.EvaluateLevels = function(sets, level)
    local buffer = {}
    for name, set in pairs(sets) do
        if (#name > 9) and (string.sub(name, -9) == '_Priority') then
            local newSet = {}
            for slotName, slotEntries in pairs(set) do
                if (constants.Slots[slotName] ~= nil) then
                    if type(slotEntries) == 'string' then
                        newSet[slotName] = slotEntries
                    elseif type(slotEntries) == 'table' then
                        if slotEntries[1] == nil then
                            newSet[slotName] = slotEntries
                        else
                            for _, potentialEntry in ipairs(slotEntries) do
                                if gFunc.EvaluateItem(potentialEntry, level) then
                                    newSet[slotName] = potentialEntry
                                    break
                                end
                            end
                        end
                    end
                end
            end
            local newKey = string.sub(name, 1, -10)
            buffer[newKey] = newSet
        end
    end
    for key,val in pairs(buffer) do
        sets[key] = val
    end
end

gData = {
    petAction = nil,
    playerAction = nil
}

gData.GetAction = function()
    if gData.playerAction then
        return {
            Name = gData.playerAction.name,
        }
    end
end

gData.GetPet = function()
    if pet.isvalid then
        return {
            Name = pet.name,
            Status = pet.status
        }
    end
end

gData.GetPlayer = function()
    return {
        Status = player.status,
        MainJobLevel = player.main_job_level
    }
end

gData.GetPetAction = function()
    if gData.petAction then
        local actionType = 'Ability'
        if gData.petAction.prefix == '/magic' or gData.petAction.prefix == '/song' or gData.petAction.prefix == '/ninjutsu' then
            actionType = 'Magic'
        end
        return {
            Name = gData.petAction.name,
            ActionType = actionType
        }
    end
end

gData.GetCurrentCall = function()
    return 'N/A'
end

gEquip = {}

gEquip.ClearBuffer = function()
end

gEquip.ProcessBuffer = function()
end

gEquip.ProcessImmediateBuffer = function()
end