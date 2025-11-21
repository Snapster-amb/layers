---
-- Layer removes the need to define nested tables in compound mode set declarations.
---
function Layer(parent, name) end

local interimEvents = {}

for k, v in pairs(constants.InterimEvents) do
    interimEvents[v] = k
end

local function setEventAndCallback(wrapper, name, event)
    wrapper.events[name][event] = true
    local transition = "PreHandle" .. event
    if interimEvents[event] ~= nil then
        transition = "PreHandle" .. interimEvents[event]
    end
    if wrapper.implicit and not callbacks.IsCallbackRegistered(transition, name) then
        local predicate = utils.CreateCompoundPredicate(name)
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
end

local function setEventsAndCallbacks(layer, event)
    if not rawget(layer, '__parent') then
        return
    end
    local name = layer.__name
    local wrapper = groups.GetGroup(name)
    if not wrapper then
        error("Wrapper does not exist for " .. name)
    end
    setEventAndCallback(wrapper, name, event)
    setEventsAndCallbacks(layer.__parent, event)
end

local function createItemEventsAndCallbacks(when, event)
    local wrapper = groups.GetGroup(when)
    if not wrapper then
        local predicate = utils.CreateCompoundPredicate(when)
        if predicate then
            groups.CreateImplicitModeGroup(when)
            wrapper = groups.GetGroup(when)
        end
    end
    setEventAndCallback(wrapper, when, event)
end

local function scanItemSetForRules(root, event)
    for k, v in pairs(root) do
        if type(k) == 'string' and constants.Slots[k] then
            if type(v) == 'table' and v[1] ~= nil then
                for _, t in ipairs(v) do
                    if type(t) == 'table' then
                        if t.When then
                            createItemEventsAndCallbacks(t.When, event)
                        end
                    end
                end
            elseif type(v) == 'table' and v.When then
                createItemEventsAndCallbacks(v.When, event)
            end
        end
    end
end

local eventMetatable = {
    __newindex = function(t, k, v)
        rawset(t, k, v)
        local event = rawget(t, '__eventName')
        if event and type(v) == 'table' then
            scanItemSetForRules(v, event)
        end
    end,
    __metatable = 'Protected'
}

local metatable = {
    __index = function (t, k)
        if type(k) == 'string' then
            if constants.Events[k] or interimEvents[k] then
                local v = {}
                rawset(v, '__eventName', k)
                setmetatable(v, eventMetatable)
                rawset(t, k, v)
                setEventsAndCallbacks(t, k)
                return v
            elseif #k > 9 and string.sub(k, -9) == '_Priority' then
                error("Level sync sets must terminate set declaration")
            else
                if not groups.GetGroup(k) and utils.CreateCompoundPredicate(k) then
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
                if type(v) == 'table' and getmetatable(v) == nil then
                    rawset(v, '__eventName', k)
                    setmetatable(v, eventMetatable)
                end
                rawset(t, k, v)
                setEventsAndCallbacks(t, k)
                scanItemSetForRules(v, k)
            elseif (#k > 9 and string.sub(k, -9) == '_Priority') then
                local event = string.sub(k, 1, -10)
                if constants.Events[event] or constants.InterimEvents[event] then
                    rawset(t, k, v)
                    setEventsAndCallbacks(t, event)
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
