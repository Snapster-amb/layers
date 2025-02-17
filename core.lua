---
-- The set building engine.
--
-- The engine captures the Precast, Midcast, Preshot, Midshot, Ability, Item, and
-- Weaponskill LuAshitacast events and queries the taxonomy using the event  and
-- action name to get an ordered list of classifiers if a taxonomy exists for the
-- event.  The engine will build a set using Sets.Event as a base and apply any
-- matching classifier sets on top.  The set-building logic is repeated for all
-- mode groups, laying each group set on top of the base set before finally
-- equipping the set.
--
-- In the case of the default (Idle, Resting, Engaged) events, the engine will also
-- check to see if the user has a pet.  Similar logic is performed on the user's pet,
-- which is applied on top of the user's base set.
local core = {}

local function protectTableMethods(innerTable)
    local proxy = {}
    local mt = {
        __index = function (t, k)
            local v = rawget(innerTable, k)
            if v then
                return v
            end
            return rawget(proxy, k)
        end,
        __newindex = function (t, k, v)
            if k == 'Sets' then
                if type(v) ~= 'table' then
                    error("Untable to set field Sets - value must be a table")
                end
                rawset(innerTable, k, v)
            else
                if rawget(innerTable, k) then
                    error("Unable to set protected field " .. k)
                end
                rawset(proxy, k, v)
            end
        end,
        __metatable = 'Protected'
    }
    setmetatable(proxy, mt)
    return proxy
end

---
-- Protect get/set access to the profile that could break the extension
local proxy = protectTableMethods(core)

core.Sets = MTable()

local function buildClassifierSet(baseSets, event, classifiers, mode)
    local set = {}
    local eventSets = baseSets[event] or {}
    utils.LogSetDetails(eventSets, event, mode)
    utils.MergeSets(set, eventSets)
    for _, classifier in ipairs(classifiers) do
        if classifier ~= event then
            local classifierSet = eventSets[classifier] or {}
            utils.LogSetDetails(classifierSet, event, mode, classifier)
            utils.MergeSets(set, classifierSet)
        end
    end
    return set
end

local function buildModes(unvisitedModes, baseModes, sets, outputModes)
    for i, mode in ipairs(unvisitedModes) do
        if rawget(sets, mode) then
            local newBaseModes = utils.CopyTable(baseModes)
            table.insert(newBaseModes, mode)
            local depth = #newBaseModes
            if not outputModes[depth] then
                outputModes[depth] = {}
            end
            table.insert(outputModes[depth], newBaseModes)
            local newUnvisitedModes = utils.CopyTable(unvisitedModes, {[mode] = true})
            buildModes(newUnvisitedModes, newBaseModes, rawget(sets, mode), outputModes)
        end
    end
end

local function buildEventSet(classifiers, event)
    local baseSets = core.Sets or {}
    logger.Debug(chat.message('Building ') .. chat.event(event) .. chat.message(' set'), true)
    local set = buildClassifierSet(baseSets, event, classifiers)
    local activeModes = {}
    local activeModesByName = {}
    for _, group in ipairs(globals.ModeGroups) do
        local mode = group.group.current
        if not constants.InvalidModeNames[mode] and not activeModesByName[mode] then
            table.insert(activeModes, mode)
            activeModesByName[mode] = true
        end
    end
    local outputModes = {}
    buildModes(activeModes, {}, baseSets, outputModes)
    for depth, depthModes in ipairs(outputModes) do
        for _, modes in ipairs(depthModes) do
            local depthSet = baseSets
            for _, mode in ipairs(modes) do
                depthSet = depthSet[mode]
            end
            local modeSet = buildClassifierSet(depthSet, event, classifiers, table.concat(modes, "."))
            utils.MergeSets(set, modeSet)
        end
    end
    return set
end

local function buildEventSetAndEquipWithCallbacks(classifiers, event, action)
    callbacks.Execute(string.format('PreHandle%s', event), event, action)
    local interimEvent = constants.InterimEvents[event]
    if interimEvent then
        local interimSet = buildEventSet(classifiers, interimEvent)
        logger.Debug(chat.message('Equipping ') .. chat.event(event) .. chat.message(' set containing ') .. chat.highlight(string.format('%d items', utils.GetSetItemCount(interimSet))), true)
        gFunc.InterimEquipSet(interimSet)
    end
    local set = buildEventSet(classifiers, event)
    logger.Debug(chat.message('Equipping ') .. chat.event(event) .. chat.message(' set containing ') .. chat.highlight(string.format('%d items', utils.GetSetItemCount(set))), true)
    gFunc.EquipSet(set)
    callbacks.Execute(string.format('PostHandle%s', event), event, action)
end

core.HandleCommand = commands.HandleCommand

local lastPlayerStatus = nil
local lastPetEvent = nil
local lastPlayerLevel = 0

core.HandleDefault = function()
    globals.CurrentEventHandler = core.HandleDefault
    local level = memory.GetMainJobLevel()
    if level ~= lastPlayerLevel and level ~= 0 then
        logger.Info(chat.message("Player level set to " .. chat.highlight(level)))
        utils.EvaluateLevels(core.Sets, level)
        lastPlayerLevel = level
    end
    local player = gData.GetPlayer()
    if not constants.ValidStatus[player.Status] then
        return
    end
    local pet = gData.GetPet()
    local action = gData.GetPetAction()
    local petEvent = nil
    if action then
        if action.ActionType == 'Spell' then
            petEvent = 'PetMidcast'
        else
            petEvent = 'PetWeaponskill'
        end
    elseif pet then
        petEvent = string.format('Pet%s', pet.Status)
    end
    if player.Status == lastPlayerStatus and petEvent == lastPetEvent then
        logger.Mute()
    end
    buildEventSetAndEquipWithCallbacks({player.Status}, player.Status)
    if action then
        if action.ActionType == 'Spell' then
            local classifiers = taxonomy.GetRawClassifiers('Spell', action.Name)
            buildEventSetAndEquipWithCallbacks(classifiers, 'PetMidcast', gData.petAction or action)
        else
            local classifiers = taxonomy.GetRawClassifiers('PetWeaponskill', action.Name)
            buildEventSetAndEquipWithCallbacks(classifiers, 'PetWeaponskill', gData.petAction or action)
        end
    elseif pet and constants.ValidStatus[pet.Status] then
        local classifiers = taxonomy.GetRawClassifiers('Pet', pet.Name)
        buildEventSetAndEquipWithCallbacks(classifiers, petEvent)
    end
    lastPlayerStatus = player.Status
    lastPetEvent = petEvent
    stickyitems.Bind()
    logger.Unmute()
end

core.HandleAbility = function()
    globals.CurrentEventHandler = core.HandleAbility
    lastPlayerStatus = nil
    local action = gData.GetAction()
    local classifiers = taxonomy.GetRawClassifiers('Ability', action.Name)
    buildEventSetAndEquipWithCallbacks(classifiers, 'Ability', gData.playerAction or action)
    stickyitems.Bind()
end

core.HandleItem = function()
    globals.CurrentEventHandler = function() end
    lastPlayerStatus = nil
    local action = gData.GetAction()
    if action then
        local classifiers = {action.Name}
        buildEventSetAndEquipWithCallbacks(classifiers, 'Item', gData.playerAction or action)
    end
    stickyitems.Bind()
end

core.HandlePrecast = function()
    globals.CurrentEventHandler = core.HandlePrecast
    lastPlayerStatus = nil
    local action = gData.GetAction()
    local classifiers = taxonomy.GetRawClassifiers('Spell', action.Name)
    buildEventSetAndEquipWithCallbacks(classifiers, 'Precast', gData.playerAction or action)
    stickyitems.Bind()
end

core.HandleMidcast = function()
    globals.CurrentEventHandler = core.HandleMidcast
    lastPlayerStatus = nil
    local action = gData.GetAction()
    if action then
        local classifiers = taxonomy.GetRawClassifiers('Spell', action.Name)
        local call = gData.GetCurrentCall()
        if call ~= "HandleMidcast" then
            gEquip.ClearBuffer()
        end
        buildEventSetAndEquipWithCallbacks(classifiers, 'Midcast', gData.playerAction or action)
        stickyitems.Bind()
        if call ~= "HandleMidcast" then
            gEquip.ProcessImmediateBuffer()
        end
    end
end

core.HandlePreshot = function()
    globals.CurrentEventHandler = core.HandlePreshot
    lastPlayerStatus = nil
    buildEventSetAndEquipWithCallbacks({}, 'Preshot')
    stickyitems.Bind()
end

core.HandleMidshot = function()
    globals.CurrentEventHandler = core.HandleMidshot
    lastPlayerStatus = nil
    local action = gData.GetAction()
    if action then
        local call = gData.GetCurrentCall()
        if call ~= "HandleMidshot" then
            gEquip.ClearBuffer()
        end
        buildEventSetAndEquipWithCallbacks({}, 'Midshot')
        stickyitems.Bind()
        if call ~= "HandleMidshot" then
            gEquip.ProcessImmediateBuffer()
        end
    end
end

core.HandleWeaponskill = function()
    globals.CurrentEventHandler = core.HandleWeaponskill
    lastPlayerStatus = nil
    local action = gData.GetAction()
    local classifiers = taxonomy.GetRawClassifiers('Weaponskill', action.Name)
    buildEventSetAndEquipWithCallbacks(classifiers, 'Weaponskill', gData.playerAction or action)
    stickyitems.Bind()
end

---
-- Execute the user's UserOnLoad if it exists.
core.OnLoad = function()
    local userOnLoad = rawget(proxy, 'UserOnLoad')
    if userOnLoad and type(userOnLoad) == 'function' then
        local success, err = pcall(userOnLoad)
        if not success then
            logger.Error("Error during UserOnLoad " .. err)
        end
    end
end

---
-- Unbind any keys that were bound and execute the user's UserOnUnload if it exists.
core.OnUnload = function()
    hotkeys.UnbindAll()
    local userOnUnload  = rawget(proxy, 'UserOnUnload')
    if userOnUnload and type(userOnUnload) == 'function' then
        local success, err = pcall(userOnUnload)
        if not success then
            logger.Error("Error during UserOnLoad " .. err)
        end
    end
end

---
-- Create a mode group using the provided name, modes, and optional key binding.
--
-- This should be consumed from users' gearswap or LuAshitacast job files.  User
-- commands can cycle, cycleback, set and reset the mode for the mode group.  The
-- user command to cycle the mode group is set to the provided binding it if is 
-- provided.
-- @param name The modegroup name
-- @param modes A mode name indexed table containing the group modes
-- @param binding An optional windower/ashita key binding.
core.CreateModeGroup = function(name, modes, binding)
    if not name or type(name) ~= 'string' then
        return logger.Error('Unable to create group - group names must be strings')
    end
    if not modes or type(modes) ~= 'table' then
        return logger.Error('Unable to create group - modes must be table')
    end
    for k, v in pairs(modes) do
        if type(v) ~= 'string' then
            return logger.Error(string.format('Unable to create group %s - mode names must be strings', name))
        end
    end
    if utils.TableLength(modes) == 0 then
        return logger.Error(string.format('Unable to create mode %s - no mode names provided', name))
    end
    if binding then
        local status, err = pcall(hotkeys.Bind, name, binding)
        if not status then
            return logger.Error('Unable to create group - key binding error - ' .. err)
        end
    end
    local group = M(table.unpack(modes))
    table.insert(globals.ModeGroups, { ['name'] = name, ['group'] = group })
    local modeText = chat.invalid(group.current)
    if not constants.InvalidModeNames[group.current] then
        modeText = chat.highlight(group.current)
    end
    logger.Info(chat.group(name) .. chat.message(' mode group created with mode ') .. modeText)
    return group
end

---
-- Expose the GetClassifiers method to user job files.
core.GetClassifiers = taxonomy.GetClassifiers

---
-- Expose the GetOrderedClassifiers method to user job files.
core.GetOrderedClassifiers = taxonomy.GetOrderedClassifiers

---
-- Expose the RegisterCallback method to user job files.
core.RegisterCallback = callbacks.Register

---
-- Expose the AddChargedItem method to user job files
core.AddChargedItem = stickyitems.AddChargedItem

---
-- Expose the RemoveChargedItem method to user job files
core.RemoveChargedItem = stickyitems.RemoveChargedItem

---
-- Expose the AddEnchantedItem method to user job files
core.AddEnchantedItem = stickyitems.AddEnchantedItem

---
-- Expose the RemoveEnchantedItem method to user job files
core.RemoveEnchantedItem = stickyitems.RemoveEnchantedItem

---
-- Expose the Conquest module user job files
core.conquest = protectTableMethods(conquest)

return proxy
