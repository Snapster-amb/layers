local groups = {}

local groupWrapperArray = {}

local groupWrapperMap = {}

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
groups.CreateModeGroup = function(name, modes, binding)
    if not name or type(name) ~= 'string' then
        return logger.Error('Unable to create group - group names must be strings')
    end
    if not modes or type(modes) ~= 'table' then
        return logger.Error('Unable to create group - modes must be table')
    end
    for k, v in pairs(modes) do
        if type(v) ~= 'string' then
            return logger.Error(string.format('Unable to create group %s - mode names must be strings', name))
        elseif groupWrapperMap[k] then
            return logger.Error(string.format('Unable to create group %s - mode %s already exists', name, v))
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
    local wrapper = {
        name = name,
        group = group,
        events = {},
        implicit = false
    }
    for k, v in pairs(modes) do
        if not constants.InvalidModeNames[v] then
            wrapper.events[v] = {}
        end
    end
    table.insert(groupWrapperArray, wrapper)
    for k, v in pairs(modes) do
        if not constants.InvalidModeNames[v] then
            groupWrapperMap[v] = wrapper
        end
    end
    local modeText = chat.invalid(group.current)
    if not constants.InvalidModeNames[group.current] then
        modeText = chat.highlight(group.current)
    end
    logger.Info(chat.group(name) .. chat.message(' mode group created with mode ') .. modeText)
    return group
end

groups.GetGroup = function(modeName)
    return groupWrapperMap[modeName]
end

groups.GetGroupByGroupName = function(gropuName)
    for _, wrapper in pairs(groupWrapperArray) do
        if wrapper.name == gropuName then
            return wrapper
        end
    end
end

groups.CreateImplicitModeGroup = function(name)
    local modes = {'Off', name}
    local group = M(table.unpack(modes))
    local groupWrapper = {
        name = name,
        group = group,
        events = {},
        implicit = true
    }
    groupWrapper.events[name] = {}
    table.insert(groupWrapperArray, groupWrapper)
    for k, v in pairs(modes) do
        if not constants.InvalidModeNames[v] then
            groupWrapperMap[v] = groupWrapper
        end
    end
    logger.Info(chat.group(name) .. chat.message(' implicit mode group created'))
end

groups.groupWrapperArray = groupWrapperArray

return groups