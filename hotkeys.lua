---
-- Ashitacast to windower global table method invocations are defined here.
---
local hotkeys = {}
local bindings = {}

hotkeys.Bind = function(name, binding)
    AshitaCore:GetChatManager():QueueCommand(1, "/bind " .. binding .. " /lac fwd cycle " .. name)
    bindings[name] = binding
end

hotkeys.Unbind = function(name)
    AshitaCore:GetChatManager():QueueCommand(1, "/unbind " .. bindings[name])
    bindings[name] = nil
end

hotkeys.UnbindAll = function()
    for name, binding in pairs(bindings) do
        pcall(hotkeys.Unbind, name, binding)
    end
    bindings = {}
end

return hotkeys
