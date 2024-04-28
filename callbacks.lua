---
-- User callbacks that are run before/after events are stored and executed here.
---
local callbacks = {}

local registered = {}

for event, _ in pairs(constants.Events) do
    for transition, _ in pairs(constants.Transitions) do
        registered[string.format('%sHandle%s', transition, event)] = {}
    end
end

---
-- Execute any registered callbacks for the provided transition
callbacks.Execute = function(transition, event, action)
    local transitionCallbacks = registered[transition] or {}
    for _, callbackTable in ipairs(transitionCallbacks) do
        for name, callback in pairs(callbackTable) do
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
    local transitionCallbacks = registered[transition]
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
        table.insert(transitionCallbacks, {[name] = callback})
        logger.Debug(chat.message("Callback ") .. chat.callback(name) .. chat.message(" registered for event transition ") .. chat.transition(transition))
    end
end

return callbacks
