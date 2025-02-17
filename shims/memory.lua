---
-- Windower memory access call wrapper.
local memory = {}

---
-- Get the player's current level
--
-- This should return the player's reduced level if under level sync
memory.GetMainJobLevel = function()
    return player.main_job_level
end

return memory
