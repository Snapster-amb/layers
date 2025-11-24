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
        local action = gData.playerAction
        local mpAfterCast = player.mp
        local mppAfterCast = player.mpp
        if action.mp_cost and action.mp_cost > 0 then
            mpAfterCast = player.mp - action.mp_cost
            mppAfterCast = mpAfterCast/player.max_mp
        end
        return {
            Name = action.name,
            MpAftercast = mpAfterCast,
            MppAftercast = mppAfterCast
        }
    end
end

gData.GetEnvironment = function()
    local weather = world.weather or "Unknown"
    local rawWeather = world.real_weather or "Unknown"
    if world.weather_intensity and world.weather_intensity > 1 then
        weather = weather .. " x2"
        rawWeather = rawWeather .. " x2"
    end
    return {
        Day = world.day,
        DayElement = world.day_element,
        Weather = weather,
        WeatherElement = world.weather_element or "Unknown",
        RawWeather = rawWeather,
        RawWeatherElement = world.real_weather_element or "Unknown",
        Area = world.zone,
        MoonPhase = world.moon,
        MoonPercent = world.moon_pct,
        Time = world.time
    }
end

gData.GetPet = function()
    if pet.isvalid then
        local x = player.x - pet.x
        local y = player.y - pet.y
        return {
            Name = pet.name,
            Status = pet.status,
            HPP = pet.hpp,
            TP = pet.tp,
            Distance = math.sqrt(x * x + y * y)
        }
    end
end

gData.GetPlayer = function()
    return {
        Status = player.status,
        MainJobLevel = player.main_job_level,
        MainJobSync = player.main_job_level,
        HPP = player.hpp,
        HP = player.hp,
        MaxHP = player.max_hp,
        MPP = player.mpp,
        MP = player.mp,
        MaxMP = player.max_mp,
        TP = player.tp,
        SubJob = player.sub_job,
        SubJobLevel = player.sub_job_level,
        SubJobSync = player.sub_job_level
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

gData.GetTarget = function()
    local target = player.target
    if target and target.valid_target then
        local targetType = "PC"
        if target.type == "MONSTER" then
            targetType = "Monster"
        elseif target.type == "SELF" then
            targetType = "PC"
        elseif target.ispartymember then
            targetType = "Party"
        elseif target.isallymember then
            targetType = "Alliance"
        elseif target.is_npc then
            targetType = "NPC"
        end
        return {
            Name = target.name,
            Type = targetType,
            Distance = target.distance,
            HPP = target.hpp,
            Status = target.status
        }
    end
end

gData.GetActionTarget = function()
    local action = gData.playerAction
    if action and action.target and action.target.valid_target then
        local target = action.target
        local targetType = "PC"
        if target.type == "MONSTER" then
            targetType = "Monster"
        elseif target.type == "SELF" then
            targetType = "PC"
        elseif target.ispartymember then
            targetType = "Party"
        elseif target.isallymember then
            targetType = "Alliance"
        elseif target.is_npc then
            targetType = "NPC"
        end
        return {
            Name = action.target.name,
            Type = targetType,
            Distance = action.target.distance,
            HPP = action.target.hpp,
            Status = action.target.status
        }
    end
end

gData.GetBuffCount = function(buff)
    if type(buff) == 'string' then
        return buffactive[buff] or 0
    else
        local player = windower.ffxi.get_player()
        local count = 0
        for _, buffId in pairs(player.buffs) do
            if buff == buffId then
                count = count + 1
            end
        end
        return count
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
