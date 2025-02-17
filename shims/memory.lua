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

local function updatePlayerSyncLevel(id, data, modified, injected, blocked)
    if id == 0x061 then
        local level = data:byte(0x0d + 1)
        if level ~= syncLevel then
            syncLevel = level
        end
    end
end

windower.raw_register_event('incoming chunk', updatePlayerSyncLevel)

return memory
