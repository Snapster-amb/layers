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
local profile = require('layers/layers')
```

Sample Ninja LUA

```lua
local layers = gFunc.LoadFile('layers\\layers.lua')

local evasionMode = layers.CreateModeGroup('Evasion', {'Off', 'Evasion'}, '@e')
local weaponMode = layers.CreateModeGroup('Weapon', {'SenjiFudo', 'Mamushitos', 'Staves'}, '@w')
local pdtMode = layers.CreateModeGroup('PDT', {'Off', 'PDT'}, '@2')
local mdtMode = layers.CreateModeGroup('MDT', {'Off', 'MDT'}, '@1')
local regenMode = layers.CreateModeGroup('Regen', {'Off', 'Regen'}, '@p')
local buffaloMode = layers.CreateModeGroup('Buffalo', {'Off', 'Buffalo'}, '@b')
local refreshMode = layers.CreateModeGroup('Refresh', {'Off', 'Refresh'}, '@r')
local ninjutsuMode = layers.CreateModeGroup('Ninjutsu', {'Off', 'HighHP'}, '@n')

local PDT = {
    Head = "Arh. Jinpachi +1",
    Body = "Arhat's Gi +1",
    Hands = "Seiryu's Kote",
    Legs = "Dst. Subligar +1",
    Feet = "Dst. Leggings +1",
    Neck = "Evasion Torque",
    Waist = "Steppe Sash",
    Back = "Resentment Cape",
    Ammo = "Happy Egg",
    Ear1 = "Pigeon Earring",
    Ear2 = "Pigeon Earring",
    Ring1 = "Sattva Ring",
    Ring2 = "Jelly Ring"
}

local MDT = gFunc.Combine(PDT, {
    Neck = "Jeweled Collar",
    Back = "Resentment Cape",
    Ear1 = "Merman's Earring",
    Ear2 = "Merman's Earring",
    Ring2 = "Merman's Ring"
})

local Enmity = {
    Head = "Arh. Jinpachi +1",
    Body = "Arhat's Gi +1",
    Hands = "Yasha Tekko",
    Legs = "Arhat's Hakama +1",
    Feet = "Yasha Sune-Ate",
    Waist = "Warwolf Belt",
    Neck = "Harmonia's Torque",
    Back = {Name = "Gigant Mantle", Priority = 99},
    Ear1 = "Eris' Earring +1",
    Ear2 = "Eris' Earring +1",
    Ring1 = "Sattva Ring",
    Ring2 = {Name = "Bomb Queen Ring", Priority = 100},
    Range = "Empty",
    Ammo = "Nokizaru Shuriken"
}

local Haste = {
    Head = "Panther Mask",
    Legs = "Byakko's Haidate",
    Feet = "Sarutobi Kyahan",
    Waist = "Koga Sarashi"
}

layers.Sets.Engaged = {
    Head = "Panther Mask",
    Body = "Ninja Chainmail",
    Hands = "Ochimusha Kote",
    Legs = "Byakko's Haidate",
    Feet = "Sarutobi Kyahan",
    Neck = "Peacock Amulet",
    Waist = "Koga Sarashi",
    Back = "Amemet Mantle",
    Ear1 = "Stealth Earring",
    Ear2 = "Eris' Earring +1",
    Ring1 = "Jaeger Ring",
    Ring2 = "Venerer Ring",
    Range = "Empty",
    Ammo = "Bailathorn"
}

layers.Sets.Weaponskill = {
    Head = "Voyager Sallet",
    Body = "Kirin's Osode",
    Hands = "Ochimusha Kote",
    Legs = "Byakko's Haidate",
    Feet = "Luisant Sollerets",
    Neck = "Spike Necklace",
    Waist = "Warwolf Belt",
    Back = "Amemet Mantle",
    Ear1 = "Suppanomimi",
    Ear2 = "Merman's Earring",
    Ring1 = "Courage Ring",
    Ring2 = "Courage Ring",
    Range = "Empty",
    Ammo = "Bailathorn"
}

layers.Sets.Weaponskill['Blade: Chi'] = {
    Neck = "Thunder Gorget"
}

layers.Sets.Weaponskill['Blade: Jin'] = {
    Neck = "Thunder Gorget"
}

layers.Sets.Midshot = {
    Hands = "Seiryu's Kote",
    Legs = "Ninja Hakama",
    Feet = "Nin. Kyahan +1",
    Neck = "Peacock Amulet",
    Ring1 = "Merman's Ring"
}

layers.Sets.Ability = Enmity
layers.Sets.Idle = PDT
layers.Sets.Midcast = PDT

layers.Sets.Evasion.Idle = {
    Body = "Scorpion Harness",
    Hands = "Rasetsu Tekko",
    Neck = "Evasion Torque",
    Waist = "Scouter's Rope",
    Back = "Boxer's Mantle",
    Ear1 = "Suppanomimi",
    Ring1 = "Sattva Ring",
    Ring2 = "Emerald Ring",
    Range = "Ungur Boomerang",
    Ammo = "Empty"
}

layers.Sets.Evasion.Engaged = layers.Sets.Evasion.Idle

layers.Sets.Midcast.Ninjutsu = {
    Head = "Ninja Hatsuburi",
    Body = "Kirin's Osode",
    Hands = "Kog. Tekko +1",
    Legs = "Yasha Hakama",
    Feet = "Kog. Kyahan +1",
    Neck = "Ninjutsu Torque",
    Waist = "Koga Sarashi",
    Back = "Astute Cape",
    Ear1 = "Stealth Earring",
    Ring1 = "Diamond Ring",
    Ring2 = "Diamond Ring",
    Ammo = "Phtm. Tathlum"
}

layers.Sets.Midcast['Elemental Ninjutsu'] = {
    Head = "Yasha Jinpachi",
    Feet = "Kog. Kyahan +1",
    Ear1 = "Moldavite Earring",
    Ear2 = "Stealth Earring"
}

layers.Sets.HighHP.Midcast['Elemental Ninjutsu'] = {
    Hands = { Name = "Seiryu's Kote", Priority = 100},
    Waist = { Name = "Steppe Sash", Priority = 100},
    Back = { Name = "Gigant Mantle", Priority = 100}
}

layers.Sets.Midcast['Enfeebling Magic'] = {
    Head = "Yasha Jinpachi",
    Body = "Kirin's Osode",
    Legs = "Yasha Hakama",
    Feet = "Yasha Sune-Ate",
    Waist = "Ryl.Kgt. Belt",
    Ring1 = "Diamond Ring",
    Ring2 = "Diamond Ring",
    Ammo = "Phtm. Tathlum"
}
layers.Sets.Midcast.Utsusemi = gFunc.Combine(PDT, gFunc.Combine(Haste, {
    Back = {Name = "Gigant Mantle", Priority = 99},
}))

layers.Sets.PDT.Engaged = PDT
layers.Sets.PDT.Midcast.Enfeebling = Enmity
layers.Sets.PDT.Midcast.Stun = gFunc.Combine(Enmity, Haste)
layers.Sets.PDT.Midcast['Enfeebling Ninjutsu'] = Enmity
layers.Sets.PDT.Midcast['Utsusemi: Ichi'] = gFunc.Combine(PDT, {
    Waist = "Koga Sarashi",
    Back = {Name = "Gigant Mantle", Priority = 99},
})

layers.Sets.MDT.Engaged = MDT
layers.Sets.MDT.Idle = MDT
layers.Sets.MDT.Midcast['Utsusemi: Ichi'] = gFunc.Combine(MDT, {
    Waist = "Koga Sarashi",
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
}

layers.Sets.Staves.Engaged = layers.Sets.Staves.Idle
layers.Sets.Staves.Midcast['Elemental Ninjutsu'] = {
    Main = "Crimson Blade",
    Sub = "Crimson Blade"
}
layers.Sets.Staves.Midcast['Ice Magic Damage'] = { Main = "Ice Staff" }
layers.Sets.Staves.Midcast['Lightning Magic Damage'] = { Main = "Thunder Staff" }
layers.Sets.Staves.Midcast['Earth Magic Damage'] = { Main = "Earth Staff" }
layers.Sets.Staves.Midcast['Wind Magic Damage'] = { Main = "Wind Staff" }
layers.Sets.Staves.Midcast['Fire Magic Damage'] = { Main = "Vulcan's Staff" }
layers.Sets.Staves.Midcast['Water Magic Damage'] = { Main = "Neptune's Staff" }

layers.Sets.Midcast.Stoneskin = {
    Body = "Kirin's Osode",
    Feet = "Suzaku's Sune-Ate",
    Neck = "Enhancing Torque"
}

layers.Sets.Regen.Idle = {
    Head = "President. Hairpin",
    Body = "War Shinobi Gi",
    Waist = "Muscle Belt"
}

layers.Sets.Regen.Engaged = layers.Sets.Regen.Idle

layers.RegisterCallback("PostHandleIdle", function()
    local environment = gData.GetEnvironment()
    if environment.Time >= 17.00 or environment.Time <= 7.00 then
        gFunc.Equip("Feet", "Nin. Kyahan +1")
    end
end, "Equip Ninja Kyahan")

layers.RegisterCallback("PostHandleEngaged", function()
    local player = gData.GetPlayer()
    if player.HPP <= 75 and (pdtMode.current ~= "PDT" and mdtMode.current ~= "MDT") then
        gFunc.Equip("Ring2", "Shinobi Ring")
    end
end, "Engaged Shinobi Ring")

layers.RegisterCallback("PostHandleMidcast", function(spell)
    local player = gData.GetPlayer()
    if player.HPP <= 75 and (layers.GetClassifiers('Spell', spell.Name)['Utsusemi']) and (spell.Name ~= "Utsusemi: Ichi" or (pdtMode.current ~= "PDT" and mdtMode.current ~= "MDT")) then
        gFunc.Equip("Ring2", "Shinobi Ring")
    end
end, "Midcast Shinobi Ring")

layers.RegisterCallback("PostHandleMidcast", function(spell)
    if spell.MppAftercast <= 50 and layers.GetClassifiers('Spell', spell.Name)['Elemental Ninjutsu'] then
        gFunc.Equip("Neck", "Uggalepih Pendant")
    end
end, "Midcast Uggalepih Pendant")

layers.RegisterCallback("PostHandleMidcast", function(spell)
    local player = gData.GetPlayer()
    if player.HPP <= 25 then
        gFunc.Equip("Ear2", "Shinobi Earring")
        if layers.GetClassifiers('Spell', spell.Name)['Elemental Ninjutsu'] then
            gFunc.Equip("Waist", "Ryl.Kgt. Belt")
        end
    end
end, "Midcast Shinobi Earring")

layers.RegisterCallback("PostHandleIdle", function()
    local player = gData.GetPlayer()
    if player.HP <= 238 and buffaloMode.current == "Buffalo" then
        gFunc.EquipSet(layers.Sets.Regen.Idle)
    end
end, "Equip Regen 25% Idle")

layers.RegisterCallback("PostHandleEngaged", function()
    local player = gData.GetPlayer()
    if player.HP <= 238 and buffaloMode.current == "Buffalo" then
        gFunc.EquipSet(layers.Sets.Regen.Idle)
    end
end, "Engaged Regen 25% Engaged")

layers.RegisterCallback("PostHandleIdle", function()
    local player = gData.GetPlayer()
    if player.MP <= 38 and refreshMode.current == "Refresh" then
        gFunc.EquipSet({ Body = "Blue Cotehardie" })
    end
end, "Equip Refresh 25% Idle")

layers.RegisterCallback("PostHandleEngaged", function()
    local player = gData.GetPlayer()
    if player.MP <= 38 and refreshMode.current == "Refresh" then
        gFunc.EquipSet({ Body = "Blue Cotehardie" })
    end
end, "Engaged Refresh 25% Engaged")

layers.RegisterCallback("PostHandleWeaponskill", function()
    local environment = gData.GetEnvironment()
    if environment.Time >= 17.00 or environment.Time <= 7.00 then
        gFunc.Equip("Hands", "Kog. Tekko +1")
    end
end, "Equip Koga Tekko Weaponskill")

layers.RegisterCallback("PostHandleWeaponskill", function()
    local environment = gData.GetEnvironment()
    if environment.Time >= 17.00 or environment.Time <= 7.00 then
        gFunc.Equip("Feet", "Kog. Kyahan +1")
    end
end, "Equip Koga Kyahan Weaponskill")

layers.RegisterCallback("PostHandleWeaponskill", function()
    local environment = gData.GetEnvironment()
    if environment.Time >= 18.00 or environment.Time <= 6.00 then
        gFunc.Equip("Ear1", "Vampire Earring")
        gFunc.Equip("Ear2", "Vampire Earring")
    end
end, "Equip Vampire Earring Weaponskill")

layers.RegisterCallback("PostHandleEngaged", function()
    local environment = gData.GetEnvironment()
    if (pdtMode.current ~= "PDT" and mdtMode.current ~= "MDT") and (environment.Time >= 17.00 or environment.Time <= 7.00) then
        gFunc.Equip("Hands", "Kog. Tekko +1")
    end
end, "Equip Koga Tekko Engaged")

layers.RegisterCallback("PostHandleIdle", function()
    local environment = gData.GetEnvironment()
    local bastok = {
        ['Bastok Markets'] = true,
        ['Bastok Mines'] = true,
        ['Port Bastok'] = true,
        ['Metalworks'] = true
    }
    if bastok[environment.Area] then
        gFunc.Equip("Body", "Republic Aketon")
    end
end, "Equip Republic Aketon")

layers.RegisterCallback("PostHandleIdle", function()
    if evasionMode.current == 'Evasion' and gData.GetBuffCount('Blindness') > 0 then
        gFunc.EquipSet({
            Ear1 = "Bat Earring",
            Ear2 = "Bat Earring"
        })
    end
end, "Equip Bat Earrings")

layers.RegisterCallback("PostHandleIdle", function()
    local environment = gData.GetEnvironment()
    if evasionMode.current == 'Evasion' and (environment.Time >= 18.00 or environment.Time <= 6.00) then
        gFunc.Equip("Legs", "Ninja Hakama")
    end
end, "Equip Evasion Legs")

layers.RegisterCallback("PostHandleIdle", function()
    local environment = gData.GetEnvironment()
    if evasionMode.current == 'Evasion' and weaponMode.current == 'Staves' then
        gFunc.Equip("Main", "Wind Staff")
    end
end, "Equip Evasion Weapon")

return layers
```
