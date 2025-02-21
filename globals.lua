---
-- Stores data that that multiple modules need access to.
local globals = {}

globals.ModeGroups = {}
globals.CurrentEventHandler = function() end
globals.LastPlayerLevel = 0

return globals