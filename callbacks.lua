---
-- User callbacks that are run before/after events are stored and executed here.
---
local callbacks = {}

local callbackArrays = {}

local callbackMaps = {}

for event, _ in pairs(constants.Events) do
    for transition, _ in pairs(constants.Transitions) do
        callbackArrays[string.format('%sHandle%s', transition, event)] = {}
        callbackMaps[string.format('%sHandle%s', transition, event)] = {}
    end
end

---
-- Execute any registered callbacks for the provided transition
callbacks.Execute = function(transition, event, action)
    local callbackArray = callbackArrays[transition] or {}
    for _, callbackWrapper in ipairs(callbackArray) do
        for name, callback in pairs(callbackWrapper) do
            logger.Debug(chat.message("Executing ") .. chat.transition(transition) .. chat.message(" callback ") .. chat.callback(name), true)
            local success, err = pcall(callback, action, event)
            if not success then
                logger.Error("Error executing callback - " .. name .. " - " .. err)
            end
        end
    end
end

---
-- Register a callback for an event and transition.
--
-- @param transition When (PreIdle, PostIdle, etc.) to execute the callback
-- @param callback The callback to execute
-- @param name An optional name for the callback
callbacks.Register = function(transition, callback, name)
    local transitionCallbacks = callbackArrays[transition]
    if type(transition) ~= 'string' then
        logger.Error("Failed to register callback - Invalid event transition")
    elseif not transitionCallbacks then
        logger.Error("Failed to register callback - Invalid event transition " .. transition)
    elseif not callback or type(callback) ~= 'function' then
        logger.Error("Failed to register callback - provided callback must be a function")
    elseif name and type(name) ~= 'string' then
        logger.Error("Failed to register callback - provided name must be a string")
    else
        if not name then
            name = string.format("Unnamed_%s_Callback_%s", transition, #transitionCallbacks + 1)
        end
        local callbackMap = callbackMaps[transition]
        if callbackMap[name] then
            callbackMap[name].callback = callback
            logger.Debug(chat.message("Callback ") .. chat.callback(name) .. chat.message(" updated for event transition ") .. chat.transition(transition))
        else
            local callbackWrapper = { [name] = callback }
            table.insert(transitionCallbacks, callbackWrapper)
            callbackMap[name] = callbackWrapper
            logger.Debug(chat.message("Callback ") .. chat.callback(name) .. chat.message(" registered for event transition ") .. chat.transition(transition))
        end
    end
end

callbacks.IsCallbackRegistered = function(transition, name)
    return callbackMaps[transition][name] ~= nil
end

return callbacks
