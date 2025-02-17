---
-- A collection of small functions that are common in other parts of then
-- extension.
---
local utils = {}

utils.GetGroup = function(name)
    for _, group in pairs(globals.ModeGroups) do
        if group.name == name then
            return group.group
        end
    end
end

utils.TableLength = function(t)
    local count = 0
    for _ in pairs(t) do
        count = count + 1
    end
    return count
end

utils.MergeSets = function(lhs, rhs)
    for slot, item in pairs(rhs) do
        if constants.Slots[slot] then
            lhs[slot] = item
        end
    end
    return lhs
end

utils.CopyTable = function(t, filter)
    local copy = {}
    local exclude = filter or {}
    for k, v in ipairs(t) do
        if not exclude[v] then
            table.insert(copy, v)
        end
    end
    return copy
end

utils.GetSetItemCount = function(set)
    local count = 0
    for k, v in pairs(set) do
        if constants.Slots[k] then
            count = count + 1
        end
    end
    return count
end

utils.LogSetDetails = function(baseSet, event, mode, classifierName)
    if logger.level.index <= logger.levels['Trace'] then
        local count = utils.GetSetItemCount(baseSet) 
        local found
        if count > 0 then
            found = chat.highlight(string.format("%d items found", count))
        else
            found = chat.invalid(string.format("%d items found", count))
        end
        local location
        if mode then
            location = "profile.Sets." .. mode .. "." .. event
        else
            location = "profile.Sets." .. event
        end
        local location = "profile.Sets"
        if mode then
            location = location .. "." .. mode
        end
        location = location .. "." .. event
        if classifierName then
            location = location .. "." .. classifierName
        end
        logger.Trace(chat.message("Searching ") .. chat.location(location) .. chat.message(" for items - ") .. found, true)
    end
end

local function evaluateSet(root, name, set, level)
    local t = root[string.sub(name, 1, -10)]
    for slotName, slotEntries in pairs(set) do
        if (constants.Slots[slotName] ~= nil) then
            if type(slotEntries) == 'string' then
                t[slotName] = slotEntries
            elseif type(slotEntries) == 'table' then
                if slotEntries[1] == nil then
                    t[slotName] = slotEntries
                else
                    for _, potentialEntry in ipairs(slotEntries) do
                        if memory.EvaluateItem(potentialEntry, level) then
                            t[slotName] = potentialEntry
                            break
                        end
                    end
                end
            end
        end
    end
end

utils.EvaluateLevels = function(t, level)
    for k, v in pairs(t) do
        if type(k) == 'string' and type(v) == 'table' then
            if (#k > 9) and (string.sub(k, -9) == '_Priority') then
                evaluateSet(t, k, v, level)
            elseif not constants.Slots[k] then
                utils.EvaluateLevels(v, level)
            end
       end
   end
end

return utils
