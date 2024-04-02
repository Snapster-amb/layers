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

local evasionMode = layers.CreateModeGroup('Evasion', {'Off', 'Evasion'}, '@e')
local weaponMode = layers.CreateModeGroup('Weapon', {'SenjiFudo', 'Staves'}, '@w')
local pdtMode = layers.CreateModeGroup('PDT', {'Off', 'PDT'}, '@2')
local mdtMode = layers.CreateModeGroup('MDT', {'Off', 'MDT'}, '@1')
local regenMode = layers.CreateModeGroup('Regen', {'Off', 'Regen'}, '@p')
local buffaloMode = layers.CreateModeGroup('Buffalo', {'Off', 'Buffalo'}, '@b')
local refreshMode = layers.CreateModeGroup('Refresh', {'Off', 'Refresh'}, '@r')
local ninjutsuMode = layers.CreateModeGroup('Ninjutsu', {'Off', 'HighHP', 'HighINT', 'HighAcc'}, '@n')
local meleeMode = layers.CreateModeGroup('Melee', {'Off', 'Acc'}, '@m')

local PDT = {
    Head = "Arh. Jinpachi +1",
    Body = "Arhat's Gi +1",
    Hands = "Seiryu's Kote",
    Legs = "Dst. Subligar +1",
    Feet = "Dst. Leggings +1",
    Neck = "Bloodbead Amulet",
    Waist = "Steppe Sash",
    Back = "Resentment Cape",
    Ear1 = "Ethereal Earring",
    Ear2 = "Morukaka Earring",
    Ring1 = "Sattva Ring",
    Ring2 = "Jelly Ring",
    Range = "Empty",
    Ammo = "Happy Egg"
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
    Back = {Name = "Gigant Mantle", Priority = 100},
    Ear1 = "Eris' Earring +1",
    Ear2 = "Eris' Earring +1",
    Ring1 = "Sattva Ring",
    Ring2 = {Name = "Bomb Queen Ring", Priority = 100},
    Range = "Empty",
    Ammo = "Nokizaru Shuriken"
}

local Haste = {
    Head = "Panther Mask +1",
    Hands = "Dusk Gloves",
    Legs = "Byakko's Haidate",
    Feet = "Sarutobi Kyahan",
    Waist = "Sprinter's Belt"
}

local FastCast = {
    Ear1 = {Name = "Loquac. Earring", Priority = 1}
}

layers.Sets.Engaged = gFunc.Combine({
    Body = "Ninja Chainmail",
    Neck = "Peacock Amulet",
    Back = "Forager's Mantle",
    Ear1 = "Stealth Earring",
    Ear2 = "Brutal Earring",
    Ring1 = "Jaeger Ring",
    Ring2 = "Venerer Ring",
    Range = "Empty",
    Ammo = "Bomb Core"
}, Haste)

layers.Sets.Acc.Engaged = {
    Body = "Haubergeon"
}

layers.Sets.Weaponskill = {
    Head = "Voyager Sallet",
    Body = "Kirin's Osode",
    Hands = "Ochimusha Kote",
    Legs = "Byakko's Haidate",
    Feet = "Luisant Sollerets",
    Neck = "Spike Necklace",
    Waist = "Warwolf Belt",
    Back = "Forager's Mantle",
    Ear1 = "Suppanomimi",
    Ear2 = "Brutal Earring",
    Ring1 = "Flame Ring",
    Ring2 = "Flame Ring",
    Range = "Empty",
    Ammo = "Bomb Core"
}

layers.Sets.Acc.Weaponskill = {
    Body = "Haubergeon"
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

layers.Sets.Evasion.Idle = {
    Head = "Nin. Hatsuburi +1",
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

layers.Sets.Precast = gFunc.Combine({
    Hands = { Name = "Seiryu's Kote", Priority = 100},
    Waist = { Name = "Steppe Sash", Priority = 100},
    Back = { Name = "Gigant Mantle", Priority = 100}
}, FastCast)

layers.Sets.Midcast.Ninjutsu = {
    Head = "Nin. Hatsuburi +1",
    Body = "Kirin's Osode",
    Hands = "Kog. Tekko +1",
    Legs = "Yasha Hakama",
    Feet = "Kog. Kyahan +1",
    Neck = "Ninjutsu Torque",
    Waist = "Koga Sarashi",
    Back = "Astute Cape",
    Ear1 = "Stealth Earring",
    Ring1 = "Snow Ring",
    Ring2 = "Snow Ring",
    Range = "Empty",
    Ammo = "Phtm. Tathlum"
}

layers.Sets.Midcast['Elemental Ninjutsu'] = {
    Head = "Yasha Jinpachi",
    --Feet = "Nin. Kyahan +1",
    Ear1 = "Novio Earring",
    Ear2 = "Moldavite Earring"
}

layers.Sets.HighAcc.Midcast['Enfeebling Ninjutsu'] = layers.Sets.Midcast.Ninjutsu

layers.Sets.HighAcc.Midcast['Elemental Ninjutsu'] = {
    Head = "Nin. Hatsuburi +1",
    Feet = "Kog. Kyahan +1",
    Back = "Astute Cape",
    Waist = "Koga Sarashi",
    Ear2 = "Stealth Earring"
}

layers.Sets.HighINT.Midcast['Elemental Ninjutsu'] = {
    Back = "Fed. Army Mantle",
    Waist = "Ryl.Kgt. Belt"
}

layers.Sets.HighHP.Midcast['Elemental Ninjutsu'] = {
    Hands = { Name = "Seiryu's Kote", Priority = 100},
    Waist = { Name = "Steppe Sash", Priority = 100},
    Back = { Name = "Gigant Mantle", Priority = 100}
}

layers.Sets.Midcast.Utsusemi = gFunc.Combine(PDT, gFunc.Combine(Haste, gFunc.Combine(FastCast, {
    Back = {Name = "Gigant Mantle", Priority = 100},
    Ring2 = {Name = "Bomb Queen Ring", Priority = 100},
})))

layers.Sets.Midcast.Stun = gFunc.Combine(Enmity, Haste)
layers.Sets.Midcast.Sleep = gFunc.Combine(Enmity, Haste)
layers.Sets.Midcast.Bind = gFunc.Combine(Enmity, Haste)
layers.Sets.Midcast.Aspir = gFunc.Combine(Enmity, Haste)
layers.Sets.Midcast.Cure = Enmity

layers.Sets.PDT.Engaged = PDT
layers.Sets.PDT.Midcast['Enfeebling Ninjutsu'] = Enmity
layers.Sets.PDT.Midcast['Utsusemi: Ichi'] = gFunc.Combine(PDT, gFunc.Combine(FastCast, {
    Waist = "Sprinter's Belt",
    Back = {Name = "Gigant Mantle", Priority = 100},
}))

layers.Sets.MDT.Engaged = MDT
layers.Sets.MDT.Idle = MDT
layers.Sets.MDT.Midcast['Utsusemi: Ichi'] = gFunc.Combine(MDT, {
    Waist = "Sprinter's Belt",
    Back = {Name = "Gigant Mantle", Priority = 100},
})


layers.Sets.SenjiFudo.Idle = {
    Main = "Senjuinrikio",
    Sub = "Fudo"
}
layers.Sets.SenjiFudo.Engaged = layers.Sets.SenjiFudo.Idle

layers.Sets.Staves.Idle = {
    Main = "Terra's Staff",
}

layers.Sets.Staves.Engaged = layers.Sets.Staves.Idle
layers.Sets.Staves.Midcast['Elemental Ninjutsu'] = {
    Main = "Crimson Blade",
    Sub = "Crimson Blade"
}
layers.Sets.Staves.Midcast['Ice Magic Damage'] = { Main = "Aquilo's Staff" }
layers.Sets.Staves.Midcast['Lightning Magic Damage'] = { Main = "Jupiter's Staff" }
layers.Sets.Staves.Midcast['Earth Magic Damage'] = { Main = "Terra's Staff" }
layers.Sets.Staves.Midcast['Wind Magic Damage'] = { Main = "Auster's Staff" }
layers.Sets.Staves.Midcast['Fire Magic Damage'] = { Main = "Vulcan's Staff" }
layers.Sets.Staves.Midcast['Water Magic Damage'] = { Main = "Neptune's Staff" }
layers.Sets.Staves.Midcast['Earth Enfeeblement'] = { Main = "Terra's Staff" }
layers.Sets.Staves.Midcast['Ice Enfeeblement'] = { Main = "Aquilo's Staff" }
layers.Sets.Staves.Midcast['Lightning Enfeeblement'] = { Main = "Jupiter's Staff" }

layers.Sets.Midcast.Stoneskin = {
    Body = "Kirin's Osode",
    Feet = "Suzaku's Sune-Ate",
    Neck = "Enhancing Torque"
}

layers.Sets.Regen.Idle = {
    Head = "President. Hairpin",
    Body = "War Shinobi Gi",
    Waist = "Muscle Belt +1"
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
    if layers.GetClassifiers('Spell', spell.Name)['Elemental Ninjutsu'] and ninjutsuMode.current ~= 'HighAcc' and spell.MppAftercast <= 50 then
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
        --gFunc.Equip("Ear2", "Vampire Earring")
    end
end, "Equip Vampire Earring Weaponskill")

layers.RegisterCallback("PostHandleEngaged", function()
    local environment = gData.GetEnvironment()
    if (pdtMode.current ~= "PDT" and mdtMode.current ~= "MDT" and evasionMode.current ~= "Evasion") and (environment.Time >= 17.00 or environment.Time <= 7.00) then
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
end, "Equip Evasion Legs Idle")

layers.RegisterCallback("PostHandleEngaged", function()
    local environment = gData.GetEnvironment()
    if evasionMode.current == 'Evasion' and (environment.Time >= 18.00 or environment.Time <= 6.00) then
        gFunc.Equip("Legs", "Ninja Hakama")
    end
end, "Equip Evasion Legs Engaged")


layers.RegisterCallback("PostHandleIdle", function()
    local environment = gData.GetEnvironment()
    if evasionMode.current == 'Evasion' and weaponMode.current == 'Staves' then
        gFunc.Equip("Main", "Auster's Staff")
    end
end, "Equip Evasion Weapon Idle")

layers.RegisterCallback("PostHandleEngaged", function()
    local environment = gData.GetEnvironment()
    if evasionMode.current == 'Evasion' and weaponMode.current == 'Staves' then
        gFunc.Equip("Main", "Auster's Staff")
    end
end, "Equip Evasion Weapon Engaged")

return layers
```
