---
-- Several constants used throughout the project are defined here.
---
local constants = {}

constants.Slots = {
    Main = true,
    Sub = true,
    Range = true,
    Ammo = true,
    Head = true,
    Body = true,
    Hands = true,
    Legs = true,
    Feet = true,
    Neck = true,
    Waist = true,
    Ear1 = true,
    Ear2 = true,
    Ring1 = true,
    Ring2 = true,
    Back = true
}

constants.Events = {
    Ability = true,
    Item = true,
    Precast = true,
    Midcast = true,
    Preshot = true,
    Midshot = true,
    Weaponskill = true,
    Idle = true,
    Engaged = true,
    Resting = true,
    PetWeaponskill = true,
    PetMidcast = true,
    PetIdle = true,
    PetEngaged = true,
    PetResting = true
}

constants.InterimEvents = {
    Midcast = "Interimcast",
    Midshot = "Interimshot"
}

constants.Transitions = {
    Pre = true,
    Post = true
}

constants.ValidStatus = {
    Engaged = true,
    Idle = true,
    Resting = true
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

constants.Containers = {
    Inventory  = 0,
    Safe       = 1,
    Storage    = 2,
    Temporary  = 3,
    Locker     = 4,
    Satchel    = 5,
    Sack       = 6,
    Case       = 7,
    Wardrobe   = 8,
    Safe2      = 9,
    Wardrobe2  = 10,
    Wardrobe3  = 11,
    Wardrobe4  = 12,
    Wardrobe5  = 13,
    Wardrobe6  = 14,
    Wardrobe7  = 15,
    Wardrobe8  = 16
}

return constants
