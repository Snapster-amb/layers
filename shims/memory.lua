---
-- Windower memory access call wrapper.
local memory = {}

local syncLevel = player.main_job_level

---
-- Get the player's current level
--
-- This should return the player's reduced level if under level sync
memory.GetMainJobLevel = function()
    return player.main_job_level
end

local function updatePlayerSyncLevel(id, data, modified, injected, blocked)
    if (id == 0x067 and data:byte(0x04 + 1) == 0x02 then
        local id = data:unpack('U', 0x08 + 1)
        if id == player.id then
            syncLevel = data:byte(0x26 + 1)
        end
    end
end

windower.raw_register_event('incoming chunk', updatePlayerSyncLevel)

return memory
