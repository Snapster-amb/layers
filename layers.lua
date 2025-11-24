---
-- Load the extension into an isolated environment and return access to the profile.
---
if gearswap then
    local env = {
        print = add_to_chat,
        type = type,
        ipairs = ipairs,
        setmetatable = setmetatable,
        getmetatable = getmetatable,
        pairs = pairs,
        string = string,
        pcall = pcall,
        table = table,
        error = error,
        rawget = rawget,
        rawset = rawset,
        require = require,
        next = next,
        tonumber = tonumber,
        tostring = tostring,
        math = math,
        buffactive = buffactive,
        equip = equip,
        player = player,
        pet = pet,
        send_command = send_command,
        sets = sets,
        windower = windower,
        world = world,
        coroutine = coroutine,
        os = os,
        io = io
    }

    local loadFile = function(path)
        local paths = T{
            path,
            string.format('%s.lua', path),
            string.format('%saddons\\GearSwap\\libs\\%s', windower.windower_path, path),
            string.format('%saddons\\GearSwap\\libs\\%s.lua', windower.windower_path, path),
        };
        for token in string.gmatch(gearswap.package.path, "[^;]+") do
            paths:append(string.gsub(token, '?', path));
        end

        local filePath;
        for _,path in ipairs(paths) do
            if (windower.file_exists(path)) then
                filePath = path;
                break;
            end
        end

        if (filePath == nil) then
            add_to_chat('Layers Error - File not found matching: ' .. path);
            return nil;
        end

        local func, loadError = gearswap.loadfile(filePath);
        if (not func) then
            add_to_chat('Layers - Failed to load file: ' .. filePath);
            add_to_chat('Layers - loadError');
            return nil;
        end
        return func
    end

    local modules = {
        { ['shims/gearswap'] = '' },
        { ['shims/luashitacast'] = '' },
        { ['shims/stickyitems'] = 'stickyitems' },
        { ['shims/struct'] = 'struct' },
        { ['shims/memory'] = 'memory' },
        { ['modes'] = 'modes' },
        { ['chat'] = 'chat' },
        { ['logger'] = 'logger' },
        { ['constants'] = 'constants' },
        { ['commands'] = 'commands' },
        { ['globals'] = 'globals' },
        { ['utils'] = 'utils' },
        { ['callbacks'] = 'callbacks' },
        { ['taxonomy'] = 'taxonomy' },
        { ['conquest'] = 'conquest' },
        { ['layer'] = 'layer' },
        { ['merits'] = 'merits' },
        { ['defaults'] = 'defaults' },
        { ['groups'] = 'groups' },
        { ['core'] = 'core' },
        { ['shims/constants'] = '' },
        { ['shims/hotkeys'] = 'hotkeys' },
        { ['predicates'] = 'predicates' }
    }

    for _, modtable in pairs(modules) do
        for path, mod in pairs(modtable) do
            file = loadFile(string.format('layers/%s', path))
            gearswap.setfenv(file, env)
            if mod ~= '' then
                env[mod] = file()
            else
                file()
            end
        end
    end

    local gearswap_callbacks = {
        'precast',
        'midcast',
        'aftercast',
        'pet_midcast',
        'pet_aftercast',
        'status_change',
        'pet_status_change',
        'file_unload',
        'self_command',
        'get_sets',
        'pet_change'
    }

    -- The gearswap hooks must be visible in the user's job environment
    for k, v in pairs(gearswap_callbacks) do
        _G[v] = env[v]
    end

    return env.core
else
    local loadFile = function(path)
        local paths = T{
            path,
            string.format('%s.lua', path),
            string.format('%sconfig\\addons\\luashitacast\\%s_%u\\%s', AshitaCore:GetInstallPath(), gState.PlayerName, gState.PlayerId, path),
            string.format('%sconfig\\addons\\luashitacast\\%s_%u\\%s.lua', AshitaCore:GetInstallPath(), gState.PlayerName, gState.PlayerId, path),
            string.format('%sconfig\\addons\\luashitacast\\%s', AshitaCore:GetInstallPath(), path),
            string.format('%sconfig\\addons\\luashitacast\\%s.lua', AshitaCore:GetInstallPath(), path),
        };
        for token in string.gmatch(package.path, "[^;]+") do
            paths:append(string.gsub(token, '?', path));
        end

        local filePath;
        for _,path in ipairs(paths) do
            if (ashita.fs.exists(path)) then
                filePath = path;
                break;
            end
        end

        if (filePath == nil) then
            print(chat.header('Layers') .. chat.error('File not found matching: ') .. chat.color1(2, path));
            return nil;
        end

        local func, loadError = loadfile(filePath);
        if (not func) then
            print (chat.header('Layers') .. chat.error('Failed to load file: ') .. chat.color1(2,filePath));
            print (chat.header('Layers') .. chat.error(loadError));
            return nil;
        end
        return func
    end

    local env = {
        gData = gData,
        gFunc = gFunc,
        gEquip = gEquip,
        print = print,
        type = type,
        ipairs = ipairs,
        setmetatable = setmetatable,
        getmetatable = getmetatable,
        pairs = pairs,
        string = string,
        pcall = pcall,
        AshitaCore = AshitaCore,
        table = table,
        error = error,
        rawget = rawget,
        rawset = rawset,
        struct = struct,
        ashita = ashita,
        bit = bit,
        tonumber = tonumber,
        tostring = tostring,
        coroutine = coroutine,
        os = os,
        io = io
    }

    local modules = {
        'modes',
        'chat',
        'logger',
        'hotkeys',
        'constants',
        'commands',
        'globals',
        'utils',
        'callbacks',
        'taxonomy',
        'memory',
        'stickyitems',
        'conquest',
        'predicates',
        'layer',
        'groups',
        'merits',
        'defaults',
        'core'
    }

    for _, mod in pairs(modules) do
        local file = loadFile(string.format('layers\\%s', mod))
        setfenv(file, env)
        env[mod] = file()
    end

    return env.core

end