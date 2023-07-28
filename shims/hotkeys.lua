---
-- Hot keys for easy mode group toggling are created and stored here.
---
local hotkeys = {}
local bindings = {}

---
-- Bind cycling a mode group to a key.
-- @param name The mode group name.
-- @param binding The keystroke, using windower/ashita bind syntax [^!@#~][key], to bind.
hotkeys.Bind = function(name, binding)
    local command = chat.location(string.format('//gs c cycle %s', name))
    logger.Info(chat.header('Layers') .. chat.message("Binding ") .. chat.location(binding) .. chat.message(" to: ") .. command) 
    send_command(string.format("bind %s gs c cycle %s", binding, name))
    bindings[name] = binding
end

---
-- Unbind a hotkey previously bound using a mode group.
-- @param name The mode group name.
hotkeys.Unbind = function(name)
    send_command(string.format("unbind %s", bindings[name]))
    bindings[name] = nil
end

---
-- Unbind all hotkeys bound to mode group names.
hotkeys.UnbindAll = function()
    for name, binding in pairs(bindings) do
        pcall(hotkeys.Unbind, name, binding)
    end
    bindings = {}
end

return hotkeys
