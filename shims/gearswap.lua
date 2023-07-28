---
-- Gearswap user event functions are piped to the engine here.
--
-- If the user is running windower/gearswap, the user events need
-- to be captured and pushed into the set building engine.
---
local lastEventFunction = function() end

local function handleEvent(eventFunction)
    lastEventFunction = eventFunction
    eventFunction()
end

function precast(spell)
    gData.playerAction = spell
    if spell.prefix == '/range' then
        handleEvent(core.HandlePreshot)
    elseif spell.prefix == '/item' then
        handleEvent(core.HandleItem)
    elseif spell.prefix == '/weaponskill' then
        handleEvent(core.HandleWeaponskill)
    elseif spell.prefix == '/pet' or spell.prefix == '/jobability' then
        handleEvent(core.HandleAbility)
    elseif spell.prefix == '/magic' or spell.prefix == '/song' or spell.prefix == '/ninjutsu' then
        handleEvent(core.HandlePrecast)
    else
        logger.Error("Unhandled precast event - " .. spell.name)
    end
end

function midcast(spell)
    gData.playerAction = spell
    if spell.prefix == '/range' then
        handleEvent(core.HandleMidshot)
    elseif spell.prefix == '/item' or spell.prefix == '/pet' or spell.prefix == '/jobability' or spell.prefix == '/weaponskill' then
    elseif spell.prefix == '/magic' or spell.prefix == '/song' or spell.prefix == '/ninjutsu' then
        handleEvent(core.HandleMidcast)
    else
        logger.Error("Unhandled midcast event - " .. spell.name)
    end
end

function aftercast(spell)
    gData.playerAction = nil
    handleEvent(core.HandleDefault)
end

function pet_midcast(spell)
    gData.petAction = spell
    if not gData.playerAction then
        handleEvent(core.HandleDefault)
    end
end

function pet_change(pet, gain)
    if gain then
        handleEvent(core.HandleDefault)
    end
end

function pet_aftercast(spell)
    gData.petAction = nil
    if not gData.playerAction then
        handleEvent(core.HandleDefault)
    end
end

function status_change(new, old)
    handleEvent(core.HandleDefault)
end

function pet_status_change(new, old)
    if not gData.playerAction then
        handleEvent(core.HandleDefault)
    end
end

function file_unload(file_name)
    core.OnUnload()
end

function self_command(command)
    local commands = {}
    for word in command:gmatch("%w+") do table.insert(commands, word) end
    core.HandleCommand(commands)
    lastEventFunction()
end

function get_sets()
    for k, v in pairs(core.Sets) do
        sets[k] = v
    end
end
