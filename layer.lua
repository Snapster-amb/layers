---
-- Layer remove the need to define nested tables in compound mode set declarations.
---
function Layer(parent, name) end

local interimEvents = {}

for k, v in pairs(constants.InterimEvents) do
    interimEvents[v] = k
end

local function setEventsAndCallbacks(layer, event, count)
    if not rawget(layer, '__parent') then
        return
    end
    local name = layer.__name
    local wrapper = groups.GetGroup(name)
    if not wrapper then
        error("Wrapper does not exist for " .. name)
    end
    wrapper.events[name][event] = true
    local transition = "PreHandle" .. event
    if interimEvents[event] ~= nil then
        transition = "PreHandle" .. interimEvents[event]
    end
    if wrapper.implicit and not callbacks.IsCallbackRegistered(transition, name) then
        local predicate = predicates[name]
        if predicate then
            callbacks.Register(transition, function()
                if (predicate()) then
                    wrapper.group:set(name)
                else
                    wrapper.group:set('Off')
                end
            end, name)
        end
    end
    setEventsAndCallbacks(layer.__parent, event, count)
end

local metatable = {
    __index = function (t, k)
        if type(k) == 'string' then
            if constants.Events[k] or interimEvents[k] ~= nil then
                local v = {}
                rawset(t, k, v)
                setEventsAndCallbacks(t, k)
                return v
            elseif #k > 9 and string.sub(k, -9) == '_Priority' then
                error("Level sync sets must terminate set declaration")
            else
                if not groups.GetGroup(k) then
                    local m = groups.CreateImplicitModeGroup(k)
                end
                local v = Layer(t, k)
                rawset(t, k, v)
                return v
            end
        end
    end,
    __newindex = function (t, k, v)
        if type(k) == 'string' then
            if constants.Events[k] or interimEvents[k] then
                rawset(t, k, v)
                setEventsAndCallbacks(t, k)
            elseif (#k > 9 and string.sub(k, -9) == '_Priority') then
                local event = string.sub(k, 1, -10)
                if constants.Events[event] or constants.InterimEvents[event] then
                    if not rawget(t, event) then
                        rawset(t, event, {})
                    end
                    rawset(t, k, v)
                    setEventsAndCallbacks(t, k)
                end
            else
                rawset(t, k, v)
            end
        else
            rawset(t, k, v)
        end
    end,
    __metatable = 'Protected'
}

Layer = function(parent, name)
    local t = {}
    t.__parent = parent
    t.__name = name
    setmetatable(t, metatable)
    return t
end
