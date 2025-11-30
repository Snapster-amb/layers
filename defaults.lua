local defaults = {}

defaults.SetMidcastDelay = function(spell)
    if gData.GetBuffCount('Chainspell') > 0 then
        gFunc.SetMidDelay(0)
        return
    end
    local fastCastItems = {
        ["Warlock's Chapeau"] = 10,
        ["Wlk. Chapeau +1"] = 10,
        ["Duelist's Tabard"] = 10,
        ["Dls. Tabard +1"] = 10,
        ["Loquac. Earring"] = 2,
        ["Rostrum Pumps"] = 3,
        ["Homam Cosciales"] = 5
    }
    local songCastItems = {
        ["Sha'ir Manteel"] = 12,
        ["Sheikh Manteel"] = 13,
        ["Minstrel's Ring"] = 25
    }
    local cureCastItems = {
        ["Cure Clogs"] = 15,
        ["Rucke's Rung"] = 10
    }
    local summonCastItems = {
        ["Carbuncle's Cuffs"] = 1,
        ["Evoker's Boots"] = 1
    }
    local fastCast = 0
    local castTimeReduction = 0
    local classifiers = core.GetClassifiers('Spell', spell.Name)
    local equipment = memory.GetEquipment()
    for slot, item in pairs(equipment) do
        if fastCastItems[item] then
            fastCast = fastCast + fastCastItems[item]
        end
        if classifiers['Song'] and songCastItems[item] then
            fastCast = fastCast + songCastItems[item]
        end
        if classifiers['Cure'] and cureCastItems[item] then
            fastCast = fastCast + cureCastItems[item]
        end
        if classifiers['Summoning'] and summonCastItems[item] then
            castTimeReduction = castTimeReduction + summonCastItems[item]
        end
    end
    local player = gData.GetPlayer()
    local level = 0
    if player.SubJob == "RDM" then
        level = player.SubJobSync
        if equipment['Back'] and equipment['Back'] == "Warlock's Mantle" then
            fastCast = fastCast + 2
        end
    elseif player.MainJob == "RDM" then
        level = player.MainJobSync
    end
    if level >= 55 then
        fastCast = fastCast + 20
    elseif level >= 35 then
        fastCast = fastCast + 15
    elseif level >= 15 then
        fastCast = fastCast + 10
    end
    if classifiers['Cure'] and player.MainJob == "WHM" and player.MainJobSync >= 75 then
        local cureCastTimeMerits = merits.GetMeritCount(514)
        if cureCastTimeMerits == nil then
            cureCastTimeMerits = 5
        end
        fastCast = fastCast + 4 * cureCastTimeMerits
    end
    local fastCastValue = fastCast / 100.0
    local minimumBuffer = 0.1
    local packetDelay = 0.4
    local castDelay = (((spell.CastTime - castTimeReduction) * (1 - fastCastValue)) / 1000) - minimumBuffer
    if castDelay >= packetDelay and gData.GetCurrentCall() == "HandleMidcast" then
        gFunc.SetMidDelay(castDelay)
    end
end

defaults.SetMidshotDelay = function()
    local equipment = memory.GetEquipment()
    local description = nil
    local delay = 0
    if equipment['Range'] then
        description = memory.GetItemDescription(equipment['Range'])
    elseif equipment['Ammo'] then
        description = memory.GetItemDescription(equipment['Ammo'])
    end
    if description then
        parsed = string.match(description, "%s+[Dd]elay%s*:%s*(%d+)")
        if parsed then
            delay = tonumber(parsed)
        end
    end
    local aimingDelay = delay / 120.0
    local rapidShotModifier = 0
    local velocityShotModifer = 0
    local player = gData.GetPlayer()
    local level = 0
    if player.SubJob == "RNG" then
        level = player.SubJobSync
    elseif player.MainJob == "RNG" then
        level = player.MainJobSync
    end
    if level >= 15 then
        rapidShotModifier = 0.5
    end
    if gData.GetBuffCount('Velocity Shot') > 0 then
        velocityShotModifer = 0.15
    end
    local minimumBuffer = 0.1
    local packetDelay = 0.4
    local castDelay = aimingDelay * (1 - rapidShotModifier) * (1 - velocityShotModifer) - minimumBuffer
    if castDelay >= packetDelay and gData.GetCurrentCall() == "HandleMidcast" then
        gFunc.SetMidDelay(castDelay)
    end
end

defaults.ChargedItems = {
    "Warp Cudgel",
    "Tavnazian Ring",
    "Return Ring",
    "Homing Ring",
    "Tavnazian Ring",
    "Mea Ring",
    "Dem Ring",
    "Holla Ring",
    "Altep Ring",
    "Yhoat Ring",
    "Vahzl Ring",
    "Warp Ring",
    "Republic Earring",
    "Kingdom Earring",
    "Federation Earring",
    "Tinfoil Hat",
    "Anniversary Ring",
    "Chariot Band",
    "Empress Band",
    "Emperor Band",
    "Powder Boots",
    "Reraise Earring",
    "Reraise Hairpin",
    "Kgd. Signet Staff",
    "Fed. Signet Staff",
    "Rep. Signet Staff",
    "Treat Staff II",
    "Trick Staff II",
    "Mandra. Suit",
    "Dream Mittens +1",
    "Dream Boots +1",
    "Dcl.Grd. Ring",
    "Oscar Scarf",
    "Reviler's Helm",
    "Irn.Msk. Quiver",
    "T.K. Quiver",
    "Cmb.Cst. Quiver",
    "Custom Gilet +1",
    "Custom Top +1",
    "Magna Gilet +1",
    "Magna Top +1",
    "Wonder Maillot +1",
    "Wonder Top +1",
    "Savage Top +1",
    "Elder Gilet +1",
    "Blink Band",
    "Curaga Earring",
    "Ether Tank",
    "Water Tank",
    "Potion Tank",
    "Invisible Mantle",
    "Hi-Potion Tank",
    "Hi-Ether Tank",
    "Zoolater Hat",
    "Reraise Gorget",
}

defaults.EnchantedItems = {
    ["Eld. Bone Hairpin"] = "Enchantment",
    ["Eld. Horn Hairpin"] = "Enchantment",
    ["Breath Mantle"] = "Enchantment",
    ["High Brth. Mantle"] = "Enchantment",
    ["Mighty Ring"] = "Enchantment",
    ["Vision Ring"] = "Enchantment",
    ["Hydra Tiara"] = "Potency",
    ["Hydra Harness"] = "Enchantment",
    ["Hydra Mittens"] = "Enchantment",
    ["Hydra Tights"] = "Haste",
    ["Hydra Spats"] = "Evasion Boost",
    ["Wing Gorget"] = "Regain",
    ["Haste Belt"] = "Enchantment",
    ["Albatross Ring"] = "Enchantment",
    ["Penguin Ring"] = "Enchantment",
    ["Pelican Ring"] = "Enchantment",
}

return defaults
