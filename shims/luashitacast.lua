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