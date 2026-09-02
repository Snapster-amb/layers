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
local layers = gFunc.LoadFile('layers\\layers.lua')
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
local layers = require('layers/layers')
```

Sample Ninja LUA

```lua
local layers = gFunc.LoadFile('layers\\layers.lua')

layers.CreateModeGroup('Weapon', {'Katanas', 'Staves'}, '@w')
layers.CreateModeGroup('Melee', {'Off', 'Acc'}, '@m')
layers.CreateModeGroup('PDT', {'Off', 'PDT'}, '@2')
layers.CreateModeGroup('MDT', {'Off', 'MDT'}, '@1')
layers.CreateModeGroup('Regen', {'Off', 'Regen'}, '@p')
layers.CreateModeGroup('Buffalo', {'Off', 'Buffalo'}, '@b')
layers.CreateModeGroup('Refresh', {'Off', 'Refresh'}, '@r')
layers.CreateModeGroup('Ninjutsu', {'Off', 'HighHP', 'HighAcc'}, '@n')
layers.CreateModeGroup('Kiting', {'Kiting', 'Off'}, '@k')


-- Add RDM fast cast belt

local PDT = {
    Head = "Arh. Jinpachi +1",
    Body = "Arhat's Gi +1",
    Hands = { Name = "Seiryu's Kote", Priority = 100 },
    Legs = "Dst. Subligar +1",
    Feet = { { Name = "Nin. Kyahan +1", When = "Dusk to Dawn && Kiting" }, { Name = "Dst. Leggings +1" } },
    Neck = { Name = "Bloodbead Amulet", Priority = 100 },
    Waist = { Name = "Steppe Sash", Priority = 100 },
    Back = { Name = "Gigant Mantle", Priority = 102 },
    Ear1 = { Name = "Ethereal Earring", Priority = 100 },
    Ear2 = { Name = "Morukaka Earring", Priority = 100 },
    Ring1 = { Name = "Sattva Ring", Priority = 100 },
    Ring2 = "Jelly Ring",
    Ammo = { { Name = "Fenrir's Stone", When = "Daytime", Priority = 100 }, { Name = "Happy Egg", Priority = 100 } }
}

local MDT = gFunc.Combine(PDT, {
    Back = { { Name = "Resentment Cape", When = "Outside Nation Control" } },
    Ear2 = "Merman's Earring",
    Ring2 = "Merman's Ring"
})

local Enmity = {
    Head = "Yasha Jinpachi +1",
    Body = "Yasha Samue +1",
    Hands = "Yasha Tekko +1",
    Legs = { Name = "Yasha Hakama +1", Priority = 100 },
    Feet = { Name = "Ysh. Sune-Ate +1", Priority = 100 },
    -- Waist = "Warwolf Belt", -- Should be steppe sashe in HP sets
    Waist = { Name = "Steppe Sash", Priority = 100 },
    Neck = "Harmonia's Torque",
    Back = { Name = "Gigant Mantle", Priority = 102 },
    Ear1 = "Eris' Earring +1",
    Ear2 = "Eris' Earring +1",
    Ring1 = { Name = "Sattva Ring", Priority = 100 },
    Ring2 = { Name = "Bomb Queen Ring", Priority = 102 },
    Ammo = { { Name = "Fenrir's Stone", When = "Daytime" }, { Name = "Nokizaru Shuriken" } }
}

local Haste = {
    Head = "Panther Mask +1",
    Hands = { Name = "Dusk Gloves", Priority = 100 },
    Legs = "Byakko's Haidate",
    Feet = { Name = "Fuma Sune-Ate", Priority = 100 },
    Waist = "Sprinter's Belt"
}

local FastCast = {
    Back = { Name = "Warlock's Mantle", When = "Player Subjob == Red Mage" },
    Ear1 = { Name = "Loquac. Earring", Priority = 99 }
}

local Regen = {
    Head = { Name = "Dream Ribbon", When = "(Regen || (Player HP <= 238 && Buffalo)) && Player Status Effect == Utsusemi && Player HPP < 100" },
    Body = { Name = "War Shinobi Gi", When = "(Regen || (Player HP <= 238 && Buffalo)) && Player Status Effect == Utsusemi && Player HPP < 100" },
    Waist = { Name = "Muscle Belt +1", When = "((Regen && Orange HP) || (Player HP <= 238 && Buffalo))" }
}

local Refresh = {
    Body = { Name = "Blue Cotehardie", When = "(Player MP < 41) && Player Status Effect == Utsusemi" }
}

-- Begin Idle Sets --

layers.Sets.Idle = PDT
layers.Sets.MDT.Idle = MDT
layers.Sets.Regen.Idle = Regen
layers.Sets.Refresh.Idle = Refresh
layers.Sets['Region == Bastok'].Idle = { Body = "Republic Aketon" }
layers.Sets.Katanas.Idle = { Main = "Senjuinrikio", Sub = "Fudo" }
layers.Sets.Staves.Idle = { Main = "Terra's Staff" }


-- Begin Engaged Sets --

layers.Sets.Engaged = gFunc.Combine({
    Body = { { Name = "Haubergeon +1", When = "Acc" }, { Name = "Nin. Chainmail +1", Priority = 100 } },
    Neck = "Peacock Amulet",
    Back = "Forager's Mantle",
    Ear1 = "Stealth Earring",
    Ear2 = "Brutal Earring",
    Ring1 = { Name = "Toreador's Ring", Priority = 100 },
    Ring2 = { { Name = "Shinobi Ring", When = "Yellow HP"}, { Name = "Toreador's Ring", Priority = 100 } },
    Ammo = "Bomb Core",
}, Haste)
layers.Sets.PDT.Engaged = PDT
layers.Sets.MDT.Engaged = MDT
layers.Sets.Regen.Engaged = Regen
layers.Sets.Refresh.Engaged = Refresh
layers.Sets.Katanas.Engaged = layers.Sets.Katanas.Idle
layers.Sets.Staves.Engaged = layers.Sets.Staves.Idle

-- Begin Weaponskill Sets --

layers.Sets.Weaponskill = {
    Head = "Maat's Cap",
    Body = { { Name = "Haubergeon +1", When = "Acc"}, { Name = "Kirin's Osode", Priority = 99 } },
    Hands = { { Name = "Kog. Tekko +1", When = "Dusk to Dawn"}, { Name = "Ochimusha Kote" } },
    Legs = "Byakko's Haidate",
    Feet = { { Name = "Kog. Kyahan +1", When = "Dusk to Dawn"}, { Name = "Creek M Clomps", Priority = 100} },
    Neck = "Justice Torque",
    Waist = "Warwolf Belt",
    Back = "Forager's Mantle",
    Ear1 = { { Name = "Vampire Earring", When = "Nighttime", }, { Name = "Suppanomimi" } },
    Ear2 = "Brutal Earring",
    Ring1 = "Flame Ring",
    Ring2 = "Flame Ring",
    Ammo = "Bomb Core"
}
layers.Sets.Weaponskill['Blade: Chi'] = { Neck = "Thunder Gorget" }
layers.Sets.Weaponskill['Blade: Jin'] = { Neck = "Thunder Gorget" }

-- Begin Ability Sets --

layers.Sets.Ability.Yonin = Enmity
layers.Sets.Ability.Provoke = Enmity
layers.Sets.Ability.Warcry = Enmity
layers.Sets.Ability.Souleater = Enmity
layers.Sets.Ability['Last Resort'] = Enmity
layers.Sets.Ability['Weapon Bash'] = Enmity

-- Begin Precast Sets --

layers.Sets.Precast = gFunc.Combine({
    Head = { Name = "Genbu's Kabuto", Priority = 100 },
    Hands = { Name = "Seiryu's Kote", Priority = 100 },
    Waist = { Name = "Steppe Sash", Priority = 100 },
    Ring2 = { Name = "Bomb Queen Ring", Priority = 100 },
}, FastCast)

-- Begin Midcast Sets --

layers.Sets.Midcast.Ninjutsu = gFunc.Combine(Haste, gFunc.Combine(FastCast, {
    Back = { Name = "Gigant Mantle", Priority = 102 },
    Ring2 = { { Name = "Shinobi Ring", When = "Yellow HP" }, { Name = "Bomb Queen Ring", Priority = 102 } },
    Ear2 = { Name = "Shinobi Earring", When = "Red HP" },
}))
layers.Sets.Midcast['Enfeebling Ninjutsu'] = {
    Head = { Name = "Nin. Hatsuburi +1", Priority = 100 },
    Hands = "Kog. Tekko +1",
    Feet = "Kog. Kyahan +1",
    Neck = "Ninjutsu Torque",
    Waist = "Koga Sarashi",
    Back = { Name = "Astute Cape", Priority = 99 },
    Ear1 = "Stealth Earring",
    Ammo = "Ensorcelled Shard"
}
layers.Sets.Midcast['Elemental Ninjutsu'] = {
    Head = "Yasha Jinpachi +1",
    Body = { Name = "Kirin's Osode", Priority = 99 },
    Hands = { { Name = "Seiryu's Kote", When = "HighHP" }, { Name = "Kog. Tekko +1" } },
    Legs = { Name = "Yasha Hakama +1", Priority = 100 },
    Feet = { { Name = "Kog. Kyahan +1", When = "HighAcc || HighHP" }, { Name = "Nin. Kyahan +1", Priority = 100 } },
    Neck = { { Name = "Ninjutsu Torque", When = "HighAcc || HighHP" }, { Name = "Uggalepih Pendant", When = "Player MPP After Cast <= 50" }, { Name = "Prudence Torque" } },
    Waist = { { Name = "Ryl.Kgt. Belt", When = "Red HP" }, { Name = "Steppe Sash", When = "HighHP", Priority = 102 }, { Name = "Koga Sarashi" } },
    Back = { { Name = "Gigant Mantle", When = "HighHP", Priority = 102 }, { Name = "Astute Cape", When = "HighAcc" }, { Name = "Fed. Army Mantle" } },
    Ring1 = "Snow Ring",
    Ring2 = "Snow Ring",
    Ear1 = "Novio Earring",
    Ear2 = { { Name = "Stealth Earring", When = "Red HP" }, { Name = "Stealth Earring", When = "HighAcc || HighHP" }, { Name = "Moldavite Earring" } },
    Ammo = "Ensorcelled Shard"
}

layers.Sets.Midcast.Stoneskin = {
    Head = { { Name = "Maat's Cap", When = "Player HPP <= 95"}, { Name = "Genbu's Kabuto", Priority = 100 } },
    Body = { Name = "Kirin's Osode", Priority = 99 },
    Legs = { Name = "Yasha Hakama +1", Priority = 100 },
    Feet = "Suzaku's Sune-Ate",
    Waist = "Ryl.Kgt. Belt",
    Neck = "Promise Badge",
    Ear1 = "Cmn. Earring",
    Ear2 = "Cmn. Earring",
    Ring1 = "Aqua Ring",
    Ring2 = "Aqua Ring"
}

layers.Sets.Midcast.Stun = gFunc.Combine(gFunc.Combine(Enmity, { Head = { Name = "Genbu's Kabuto", Priority = 100 }, Hands = { Name = "Dusk Gloves", Priority = 100 }, Waist = "Sprinter's Belt" }), { Neck = "Dark Torque" } )
layers.Sets.Midcast.Sleep = gFunc.Combine(Enmity, { Head = { Name = "Genbu's Kabuto", Priority = 100 }, Hands = { Name = "Dusk Gloves", Priority = 100 }, Waist = "Sprinter's Belt" })
layers.Sets.Midcast.Bind = Enmity
layers.Sets.Midcast.Aspir = gFunc.Combine(Enmity, { Head = { Name = "Genbu's Kabuto", Priority = 100 }, Hands = { Name = "Dusk Gloves", Priority = 100 }, Waist = "Sprinter's Belt" })
layers.Sets.Midcast.Cure = Enmity
layers.Sets.Midcast.Dispel = Enmity

layers.Sets.Midcast['Dark Offensive'] = {
    Main = { Name = "Pluto's Staff", When = "Staves" },
    Waist = { Name = "Anrin Obi", When = "Environment Score >= 10" }
}

layers.Sets.Midcast['Earth Offensive'] = {
    Main = { Name = "Terra's Staff", When = "Staves" }
}

layers.Sets.Midcast['Water Offensive'] = {
    Main = { Name = "Neptune's Staff", When = "Staves" }
}

layers.Sets.Midcast['Wind Offensive'] = {
    Main = { Name = "Auster's Staff", When = "Staves" },
    Waist = { Name = "Furin Obi", When = "Environment Score >= 10" }
}

layers.Sets.Midcast['Fire Offensive'] = {
    Main = { Name = "Vulcan's Staff", When = "Staves" }
}

layers.Sets.Midcast['Ice Offensive'] = {
    Main = { Name = "Aquilo's Staff", When = "Staves" },
    Waist = { Name = "Hyorin Obi", When = "Environment Score >= 10" }
}

layers.Sets.Midcast['Lightning Offensive'] = {
    Main = { Name = "Jupiter's Staff", When = "Staves" },
    Waist = { Name = "Rairin Obi", When = "Environment Score >= 10" }
}

-- Begin Preshot Sets

-- Begin Interimcast Sets --

layers.Sets.Interimcast = PDT
layers.Sets.MDT.Interimcast = MDT
layers.Sets.Regen.Interimcast = Regen
layers.Sets.Refresh.Interimcast = Refresh

layers.EnableAutomaticMidcastDelay()
layers.EnableAutomaticMidshotDelay()
layers.EnableDefaultStickyItems()

return layers

return layers
```
