local merits = {}

local counts = {}

memory.RegisterPacketIn("Record Merit Points", function (e)
    if (e.id == 0x008C) then
        local count = struct.unpack("H", e.data, 0x04 + 1)
        for i = 1, count do
            local offset = 9 + (i - 1) * 4
            local merit = struct.unpack("H", e.data, offset)
            local count = struct.unpack("B", e.data, offset + 3)
            counts[merit] = count
        end
    end
end)

merits.GetMeritCount = function(id)
    return counts[id]
end

return merits