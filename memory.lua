---
-- AshitaCore memory access call wrapper.
local memory = {}

---
-- Get the player's current level
--
-- This should return the player's reduced level if under level sync
memory.GetMainJobLevel = function()
    return AshitaCore:GetMemoryManager():GetPlayer():GetMainJobLevel()
end

return memory
