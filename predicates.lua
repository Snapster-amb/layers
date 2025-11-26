---
-- Predicates for common things users do are defined here.
--
-- If users declare implicit modes that match a predicate name or pattern, a callback will automatically be registered for relevant events using the named predicate.
local predicates = {}

local validElements = {
    Dark = true,
    Light = true,
    Earth = true,
    Fire = true,
    Water = true,
    Wind = true,
    Ice = true,
    Lightning = true,
    Thunder = true
}

local weakElements = {
    Dark = "Light",
    Light = "Dark",
    Earth = "Wind",
    Fire = "Water",
    Water = "Thunder",
    Wind = "Ice",
    Ice = "Fire",
    Lightning = "Earth",
    Thunder = "Earth"
}

local validPetTypes = {
    ['Jug Pet'] = true,
    ['Spirit'] = true,
    ['Avatar'] = true,
    -- ['Wyvern'] = true, TODO add wyvern names to taxonomy
    ['Charm'] = true
}

local nations = {
    ["San'doria"] = {
        [230] = "Southern San d'Oria",
        [231] = "Northern San d'Oria",
        [232] = "Port San d'Oria",
        [233] = "Chateau d'Oraguille"
    },
    ["Bastok"] = {
        [234] = "Bastok Mines",
        [235] = "Bastok Markets",
        [236] = "Port Bastok",
        [237] = "Metalworks"
    },
    ["Windurst"] = {
        [238] = "Windurst Waters",
        [239] = "Windurst Walls",
        [240] = "Port Windurst",
        [241] = "Windurst Woods",
        [242] = "Heavens Tower"
    },
    ["Jeuno"] = {
        [243] = "Ru'Lude Gardens",
        [244] = "Upper Jeuno",
        [245] = "Lower Jeuno",
        [246] = "Port Jeuno"
    }
}

local nationZoneIds = {}

local instances = {
    ["Salvage"] = {
        [73] = "Zhayolm Remnants",
        [74] = "Arrapago Remnants",
        [75] = "Bhaflau Remnants",
        [76] = "Silver Sea Remnants"
    },
    ["Assault"] = {
        [55] = "Ilrusi Atoll",
        [56] = "Periqia",
        [63] = "Lebros Cavern",
        [66] = "Mamool Ja Training Grounds",
        [69] = "Leujaoam Sanctum",
        [77] = "Nyzul Isle"
    },
    ["Dynamis"] = {
        [39] = "Dynamis - Valkurm",
        [40] = "Dynamis - Buburimu",
        [41] = "Dynamis - Qufim",
        [42] = "Dynamis - Tavnazia",
        [134] = "Dynamis - Beaucedine",
        [135] = "Dynamis - Xarcabard",
        [185] = "Dynamis - San d'Oria",
        [186] = "Dynamis - Bastok",
        [187] = "Dynamis - Windurst",
        [188] = "Dynamis - Jeuno"
    }
}

local instanceZoneIds = {}

local function createRegionBasedPredicates(regions, zoneIds)
    for region, zones in pairs(regions) do
        for id, zone in pairs(zones) do
            zoneIds[zone] = id
        end
        predicates["Region == " .. region] = function()
            local zoneId = zoneIds[gData.GetEnvironment().Area]
            return zoneId ~= nil and zones[zoneId] ~= nil
        end
    end
end

createRegionBasedPredicates(nations, nationZoneIds)
createRegionBasedPredicates(instances, instanceZoneIds)

predicates['Nation'] = function()
    return nationZoneIds[gData.GetEnvironment().Area] ~= nil
end

predicates['Inside Nation Control'] = conquest.GetInsideControl

predicates['Outside Nation Control'] = conquest.GetOutsideControl

predicates['Daytime'] = function()
    local environment = gData.GetEnvironment()
    return environment.Time >= 6.00 and environment.Time < 18.00;
end

predicates['Nighttime'] = function()
    local environment = gData.GetEnvironment()
    return environment.Time >= 18.00 or environment.Time < 6.00
end

predicates['Dusk to Dawn'] = function()
    local environment = gData.GetEnvironment()
    return environment.Time >= 17.00 or environment.Time < 7.00
end

predicates['Yellow HP'] = function()
    local player = gData.GetPlayer()
    return player.HPP <= 75
end

predicates['Orange HP'] = function()
    local player = gData.GetPlayer()
    return player.HPP <= 50
end

predicates['Red HP'] = function()
    local player = gData.GetPlayer()
    return player.HPP <= 25
end

predicates['White HP'] = function()
    local player = gData.GetPlayer()
    return player.HPP > 75
end

predicates['Pet Element Matches Day'] = function()
    local pet = gData.GetPet() or {}
    local classifiers = taxonomy.GetClassifiers('Pet', pet.Name or "Unknown")
    local environment = gData.GetEnvironment() or {}
    local dayElement = environment.DayElement or "Unknown"
    return classifiers[dayElement .. ' Affinity'] ~= nil
end

predicates['Pet Element Matches Weather'] = function()
    local pet = gData.GetPet() or {}
    local classifiers = taxonomy.GetClassifiers('Pet', pet.Name or "Unknown")
    local environment = gData.GetEnvironment() or {}
    local weatherElement = environment.WeatherElement or "Unknown"
    return classifiers[weatherElement .. ' Affinity'] ~= nil
end

predicates['Action Element Matches Day'] = function()
    local action = gData.GetAction()
    local environment = gData.GetEnvironment()
    return action and environment and validElements[action.Element] and action.Element == environment.DayElement
end

predicates['Action Element Matches Weather'] = function()
    local action = gData.GetAction()
    local environment = gData.GetEnvironment()
    return action and environment and validElements[action.Element] and action.Element == environment.WeatherElement
end

local jobs = {
    ['WAR'] = 'Warrior',
    ['MNK'] = 'Monk',
    ['WHM'] = 'White Mage',
    ['BLM'] = 'Black Mage',
    ['RDM'] = 'Red Mage',
    ['THF'] = 'Thief',
    ['PLD'] = 'Paladin',
    ['DRK'] = 'Dark Knight',
    ['BST'] = 'Beastmaster',
    ['BRD'] = 'Bard',
    ['RNG'] = 'Ranger',
    ['SAM'] = 'Samurai',
    ['NIN'] = 'Ninja',
    ['DRG'] = 'Dragoon',
    ['SMN'] = 'Summoner',
    ['BLU'] = 'Blue Mage',
    ['COR'] = 'Corsair',
    ['PUP'] = 'Puppetmaster',
    ['DNC'] = 'Dancer',
    ['GEO'] = 'Geomancer',
    ['RUN'] = 'Rune Fencer'
}

for acronym, subjob in pairs(jobs) do
    predicates['Player Subjob == ' .. subjob] = function()
        return gData.GetPlayer().SubJob == acronym
    end
end

local statusEffects = memory.GetStatusEffectNames()

local zones = memory.GetZoneNames()

local numericalOperators = {
    ['<'] = function(lhs, rhs) return lhs < rhs end,
    ['<='] = function(lhs, rhs) return lhs <= rhs end,
    ['=='] = function(lhs, rhs) return lhs == rhs end,
    ['>'] = function(lhs, rhs) return lhs > rhs end,
    ['>='] = function(lhs, rhs) return lhs >= rhs end
}
local identityOperators = {
    ['=='] = function(lhs, rhs) return lhs == rhs end,
}

local function generateComparativePredicate(k, prefix, operands, operators, eval)
    local pattern = "^" .. (prefix ~= "" and prefix .. " " or "") .. "([^%p]+)%s*(%p+)%s*(.+)$"
    local field, operator, value = k:match(pattern)

    if not field or not operator or not value then
        return
    end

    field = field:match("^%s*(.-)%s*$")

    local numericValue = tonumber(value) or value

    local validOperand = false
    for _, v in ipairs(operands) do
        if v == field then
            validOperand = true
            break
        end
    end
    if not validOperand then
        return
    end

    local func = operators[operator]
    if not func then
        return
    end

    local remappedFields = {
        ['MP After Cast'] = "MpAftercast",
        ['MPP After Cast'] = "MppAftercast"
    }

    field = remappedFields[field] or field
    field = string.gsub(field, "%s+", "")

    return function()
        local data = eval()
        return data and func(data[field], numericValue)
    end
end

local metatable = {
    __index = function(t, k)
        local descriptors = {
            { prefix = 'Player', operands = {'MP', 'HP', 'TP', 'MPP', 'HPP', 'Max HP', 'Max MP', 'Main Job Level', 'Sub Job Level', 'Main Job Sync', 'Sub Job Sync'}, operators = numericalOperators, eval = gData.GetPlayer },
            { prefix = 'Player', operands = {'MP After Cast', 'MPP After Cast'}, operators = numericalOperators, eval = gData.GetAction },
            { prefix = 'Player', operands = {'Main', 'Sub', 'Range', 'Ammo', 'Head', 'Body', 'Hands', 'Legs', 'Feet', 'Neck', 'Waist', 'Ear1', 'Ear2', 'Ring1', 'Ring2', 'Back'}, operators = identityOperators, eval = memory.GetEquipment },
            { prefix = '', operands = {'Moon Percent', 'Time'}, operators = numericalOperators, eval = gData.GetEnvironment },
            { prefix = '', operands = {'Weather', 'Raw Weather', 'Weather Element', 'Raw Weather Element', 'Day', 'Day Element'}, operators = identityOperators, eval = gData.GetEnvironment },
            { prefix = '', operands = {'Moon Phase'}, operators = identityOperators, eval = gData.GetEnvironment },
            { prefix = 'Target', operands = {'Distance', 'HPP'}, operators = numericalOperators, eval = gData.GetTarget },
            { prefix = 'Target', operands = {'Name', 'Status', 'Type'}, operators = identityOperators, eval = gData.GetTarget },
            { prefix = 'Action Target', operands = {'Distance', 'HPP'}, operators = numericalOperators, eval = gData.GetActionTarget },
            { prefix = 'Action Target', operands = {'Name', 'Status', 'Type'}, operators = identityOperators, eval = gData.GetActionTarget },
            { prefix = 'Pet', operands = {'Distance', 'HPP', 'TP'}, operators = numericalOperators, eval = gData.GetPet },
            { prefix = 'Pet', operands = {'Name', 'Status'}, operators = identityOperators, eval = gData.GetPet }
        }

        for _, d in ipairs(descriptors) do
            local predicate = generateComparativePredicate(k, d.prefix, d.operands, d.operators, d.eval)
            if predicate then return predicate end
        end
        if k:match("^Pet Element == ") then
            local element = k:sub(16)
            if validElements[element] then
                return function()
                    local pet = gData.GetPet() or {}
                    local classifiers = taxonomy.GetClassifiers('Pet', pet.Name or "Unknown")
                    return classifiers[element .. ' Affinity'] ~= nil
                end
            end
        end
        if k:match("^Pet Type == ") then
            local petType = k:sub(13)
            if validPetTypes[petType] then
                return function()
                    local pet = gData.GetPet() or {}
                    local classifiers = taxonomy.GetClassifiers('Pet', pet.Name or "Unknown")
                    return classifiers[petType]
                end
            end
        end
        if k:match("^Environment Score ") then
            local operator = k:sub(19, 20):gsub("%s+", "")
            local value = k:sub(21):gsub("%s+", "")
            value = tonumber(value)
            if value and numericalOperators[operator] then
                return function()
                    local environment = gData.GetEnvironment() or {}
                    local action = gData.GetAction() or {}
                    local element = action.Element

                    if validElements[element] then
                        local score = 0

                        if environment.DayElement == element then
                            score = score + 10
                        elseif environment.DayElement == weakElements[element] then
                            score = score - 10
                        end

                        if environment.WeatherElement == element then
                            score = score + (environment.Weather:sub(-2) == "x2" and 25 or 10)
                        elseif environment.WeatherElement == weakElements[element] then
                            score = score - (environment.Weather:sub(-2) == "x2" and 25 or 10)
                        end

                        return numericalOperators[operator](score, value)
                    end
                end
            end
        end
        if k:match("Environment Score ") then
            local element, operator, value = k:match("^(%w+)%s+Environment Score%s*([<>=!]+)%s*(%d+)")
            value = tonumber(value)
            if element and value and numericalOperators[operator] and validElements[element] then
                return function()
                    local environment = gData.GetEnvironment() or {}
                    local action = gData.GetAction() or {}

                    if validElements[element] then
                        element = memory.GetAddonElementName(element)
                        local score = 0

                        if environment.DayElement == element then
                            score = score + 10
                        elseif environment.DayElement == weakElements[element] then
                            score = score - 10
                        end

                        if environment.WeatherElement == element then
                            score = score + (environment.Weather:sub(-2) == "x2" and 25 or 10)
                        elseif environment.WeatherElement == weakElements[element] then
                            score = score - (environment.Weather:sub(-2) == "x2" and 25 or 10)
                        end

                        return numericalOperators[operator](score, value)
                    end
                end
            end
        end
        if k:match("^Player Status Effect == ") then
            local buff = k:sub(25)

            if statusEffects[buff] then
                return function() return gData.GetBuffCount(buff) > 0 end
            end
            local buffId = tonumber(buff)
            if buffId then
                return function() return gData.GetBuffCount(buffId) > 0 end
            end
            if buff == "Utsusemi" then
                return function() return gData.GetBuffCount(66) > 0 or gData.GetBuffCount(444) > 0 or gData.GetBuffCount(445) > 0 or gData.GetBuffCount(446) > 0 end
            end
        end
        if k:match("^Area == ") then
            local zone = k:sub(9)
            if zones[zone] then
                return function()
                    local environment = gData.GetEnvironment() or {}
                    return environment.Area == zone
                end
            end
        end
    end
}

setmetatable(predicates, metatable)

return predicates