---
-- MTables remove the need to define nested tables in compound mode set declarations.
---
function MTable() end

local metatable = {
    __index = function (t, k)
        local v = rawget(t, k)
        if v then
            return v
        elseif type(k) == 'string' and not constants.Events[k] and not constants.InterimEventNames[k] then
            local v = MTable()
            rawset(t, k, v)
            return v
        end
    end,
    __metatable = 'Protected'
}

MTable = function()
    local t = {}
    setmetatable(t, metatable)
    return t
end
