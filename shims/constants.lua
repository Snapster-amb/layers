---
-- Gearswap slot names must be defined.
---
constants.Slots = {
    main = true,
    sub = true,
    ranged = true,
    range = true,
    ammo = true,
    head = true,
    neck = true,
    lear = true,
    ear1 = true,
    learring = true,
    left_ear = true,
    rear = true,
    ear2 = true,
    rearring = true,
    right_ear = true,
    body = true,
    hands = true,
    lring = true,
    ring1 = true,
    left_ring = true,
    rring = true,
    ring2 = true,
    right_ring = true,
    back = true,
    waist = true,
    legs = true,
    feet = true
}

constants.InvalidModeNames = {
    Normal = true,
    Off = true,
    off = true,
    On = true,
    on = true
}

for slot, _ in pairs(constants.Slots) do
    constants.InvalidModeNames[slot] = true
end
