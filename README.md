LuAshitacast Directory Structure

```sh
Game
└── config
    └── addons
        └── luashitacast
            └── layers
                ├── classifiers
                |   ├── abilities.lua
                |   ├── pets.lua
                |   ├── petweaponskills.lua
                |   ├── spells.lua
                |   └── weaponskills.lua
                ├── shims
                |   ├── constants.lua
                |   ├── gearswap.lua
                |   ├── hotkeys.lua
                |   └── luashitacast.lua
                ├── callbacks.lua
                ├── chat.lua
                ├── commands.lua
                ├── constants.lua
                ├── core.lau
                ├── globals.lua
                ├── hotkeys.lua
                ├── layers.lua
                ├── logger.lua
                ├── modes.lua
                ├── taxonomy.lua
                └── utils.lua
```

LuAshitacast Include Statement

```lua
local layers = gFunc.LoadFile('layeers\\layers')
```

Gearswap Directory Structure

```sh
Windower
└── addons
    └── GearSwap
        └── libs
            └── layers
                ├── classifiers
                |   ├── abilities.lua
                |   ├── pets.lua
                |   ├── petweaponskills.lua
                |   ├── spells.lua
                |   └── weaponskills.lua
                ├── shims
                |   ├── constants.lua
                |   ├── gearswap.lua
                |   ├── hotkeys.lua
                |   └── luashitacast.lua
                ├── callbacks.lua
                ├── chat.lua
                ├── commands.lua
                ├── constants.lua
                ├── core.lau
                ├── globals.lua
                ├── hotkeys.lua
                ├── layers.lua
                ├── logger.lua
                ├── modes.lua
                ├── taxonomy.lua
                └── utils.lua
```

GearSwap Include Statement


```lua
local profile = require('layers/layers')
```

Sample Ninja LUA

```lua
local layers = gFunc.LoadFile('layers\\layers')

local combatMode = layers.CreateModeGroup('Combat', {'Off', 'Tanking'}, '@t')
local weaponMode = layers.CreateModeGroup('Weapon', {'SenjiFudo', 'Mamushitos', 'Staves'}, '@w')

PDT = {
    Head = "Arh. Jinpachi +1",
    Body = "Arhat's Gi +1",
    Hands = "Dst. Mittens +1",
    Legs = "Dst. Subligar +1",
    Feet = "Yasha Sune-Ate",
    Neck = "Evasion Torque",
    Waist = "Warwolf Belt",
    Ammo = "Happy Egg",
    Ear1 = "Pigeon Earring",
    Ear2 = "Pigeon Earring",
    Ring1 = "Sattva Ring",
    Ring2 = "Jelly Ring"
}

Enmity = {
    Head = "Arh. Jinpachi +1",
    Body = "Arhat's Gi +1",
    Legs = "Yasha Hakama",
    Feet = "Arhat's Hakama +1",
    Waist = "Warwolf Belt",
    Neck = "Harmonia's Torque",
    Ammo = "Nokizaru Shuriken",
    Ear1 = "Eris' Earring +1",
    Ear2 = "Eris' Earring +1",
    Ring1 = "Sattva Ring",
    Ring2 = "Mermaid Ring"
}

layers.Sets.Engaged = {
    Head = "Panther Mask",
    Body = "Ninja Chainmail",
    Hands = "Ochimusha Kote",
    Legs = "Byakko's Haidate",
    Feet = "Sarutobi Kyahan",
    Neck = "Peacock Amulet",
    Waist = "Swift Belt",
    Back = "Amemet Mantle",
    Ear1 = "Eris' Earring +1",
    Ear2 = "Eris' Earring +1",
    Ring1 = "Jaeger Ring",
    Ring2 = "Venerer Ring",
    Ammo = "Bailathorn"
}

layers.Sets.Weaponskill = {
    Head = "Voyager Sallet",
    Body = "Ryl.Kgt. Chainmail",
    Hands = "Ochimusha Kote",
    Legs = "Byakko's Haidate",
    Feet = "Luisant Sollerets",
    Neck = "Spike Necklace",
    Waist = "Warwolf Belt",
    Back = "Amemet Mantle",
    Ear1 = "Beetle Earring +1",
    Ear2 = "Beetle Earring +1",
    Ring1 = "Courage Ring",
    Ring2 = "Courage Ring",
    Ammo = "Bailathorn"
}

layers.Sets.Ability = Enmity
layers.Sets.Idle = PDT
layers.Sets.Midcast = PDT

layers.Sets.Midcast.Ninjutsu = {
    Head = "Ninja Hatsuburi",
    Neck = "Ninjutsu Torque",
    Feet = "Sarutobi Kyahan",
    Waist = "Swift Belt"
}

layers.Sets.Midcast['Elemental Ninjutsu'] = {
    Waist = "Ryl.Kgt. Belt",
    Ring1 = "Eremite's Ring",
    Ring2 = "Eremite's Ring",
    Ear2 = "Moldavite Earring",
    Ammo = "Morion Tathlum"
}

layers.Sets.Midcast.Utsusemi = {
    Head = "Panther Mask",
    Legs = "Byakko's Haidate",
    Feet = "Sarutobi Kyahan",
    Waist = "Swift Belt"
}

layers.Sets.Tanking.Engaged = PDT
layers.Sets.Tanking.Midcast.Enfeebling = Enmity
layers.Sets.Tanking.Midcast['Enfeebling Ninjutsu'] = Enmity
layers.Sets.Tanking.Midcast['Utsusemi: Ichi'] = gFunc.Combine(PDT, {
    Waist = "Swift Belt",
})

layers.Sets.SenjiFudo.Idle = {
    Main = "Senjuinrikio",
    Sub = "Fudo"
}
layers.Sets.SenjiFudo.Engaged = layers.Sets.SenjiFudo.Idle

layers.Sets.Mamushitos.Idle = {
    Main = "Mamushito",
    Sub = "Mamushito"
}

layers.Sets.Mamushitos.Engaged = layers.Sets.Mamushitos.Idle

layers.Sets.Staves.Idle = {
    Main = "Earth Staff",
    Back = "High Brth. Mantle",
}

layers.Sets.Staves.Engaged = layers.Sets.Staves.Idle
layers.Sets.Staves.Midcast['Ice Magic Damage'] = { Main = "Ice Staff" }
layers.Sets.Staves.Midcast['Lightning Magic Damage'] = { Main = "Thunder Staff" }

layers.RegisterCallback("PostHandleIdle", function()
    local environment = gData.GetEnvironment()
    if environment.Time >= 18.00 or environment.Time <= 6.00 then
        gFunc.Equip("Feet", "Ninja Kyahan")
    end
end, "EquipNinjaKyahan")

layers.RegisterCallback("PostHandleEngaged", function()
    local player = gData.GetPlayer()
    if player.HPP <= 75 and combatMode.current ~= "Tanking" then
        gFunc.Equip("Ring2", "Shinobi Ring")
    end
end, "Engaged Shinobi Ring")

layers.RegisterCallback("PostHandleMidcast", function(spell)
    local player = gData.GetPlayer()
    if player.HPP <= 75 and (combatMode.current ~= "Tanking" or spell.Name ~= "Utsusemi: Ichi") then
        gFunc.Equip("Ring2", "Shinobi Ring")
    end
end, "Midcast Shinobi Ring")

return layers
```
