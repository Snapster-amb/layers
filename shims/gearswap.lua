---
-- Gearswap user event functions are piped to the engine here.
--
-- If the user is running windower/gearswap, the user events need
-- to be captured and pushed into the set building engine.
---
function precast(spell)
    gData.playerAction = spell
    if spell.prefix == '/range' then
        core.HandlePreshot()
    elseif spell.prefix == '/item' then
        core.HandleItem()
    elseif spell.prefix == '/weaponskill' then
        core.HandleWeaponskill()
    elseif spell.prefix == '/pet' or spell.prefix == '/jobability' then
        core.HandleAbility()
    elseif spell.prefix == '/magic' or spell.prefix == '/song' or spell.prefix == '/ninjutsu' then
        core.HandlePrecast()
    else
        logger.Error("Unhandled precast event - " .. spell.name)
    end
end

function midcast(spell)
    gData.playerAction = spell
    if spell.prefix == '/range' then
        core.HandleMidshot()
    elseif spell.prefix == '/item' or spell.prefix == '/pet' or spell.prefix == '/jobability' or spell.prefix == '/weaponskill' then
    elseif spell.prefix == '/magic' or spell.prefix == '/song' or spell.prefix == '/ninjutsu' then
        core.HandleMidcast()
    else
        logger.Error("Unhandled midcast event - " .. spell.name)
    end
end

function aftercast(spell)
    gData.playerAction = nil
    core.HandleDefault()
end

function pet_midcast(spell)
    gData.petAction = spell
    if not gData.playerAction then
        core.HandleDefault()
    end
end

function pet_change(pet, gain)
    if gain then
        core.HandleDefault()
    end
end

function pet_aftercast(spell)
    gData.petAction = nil
    if not gData.playerAction then
        core.HandleDefault()
    end
end

function status_change(new, old)
    core.HandleDefault()
end

function pet_status_change(new, old)
    if not gData.playerAction then
        core.HandleDefault()
    end
end

function file_unload(file_name)
    core.OnUnload()
end

function self_command(command)
    local commands = {}
    for word in command:gmatch("%w+") do table.insert(commands, word) end
    core.HandleCommand(commands)
end

function get_sets()
    for k, v in pairs(core.Sets) do
        sets[k] = v
    end
    utils.EvaluateLevels(core.Sets)
end
