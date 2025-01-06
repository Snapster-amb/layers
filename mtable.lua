---
-- MTables remove the need to define nested tables in compound mode set declarations.
---
function MTable() end

local metatable = {
    __index = function (t, k)
        local v = rawget(t, k)
        if v then
            return v
        elseif type(k) == 'string' then
            local v = MTable()
            rawset(t, k, v)
            return v
        end
    end,
    __metatable = 'Protected'
}

MTable = function()
    local t = {}
    for event, _ in pairs(constants.Events) do
        t[event] = {}
    end
    for _, event in pairs(constants.InterimEvents) do
        t[event] = {}
    end
    setmetatable(t, metatable)
    return t
end
