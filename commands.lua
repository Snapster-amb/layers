---
-- User commands passed through gearswap or LuAshitacast are handled here
---
local commands = {}

local function handleModeGroupCommand(command, args)
    if #args == 0 then
        logger.Error(string.format("Unable to complete %s command - No group name provided", command))
    else
        local name = args[1]
        local groupWrapper = groups.GetGroupByGroupName(name)
        if groupWrapper then
            local group = groupWrapper.group
            if command == "cycle" then
                group:cycle()
            elseif command == "cycleback" then
                group:cycleback()
            elseif command == "reset" then
                group:reset()
            elseif command == "set" then
                if #args == 1 then
                    return logger.Error(string.format("Unable to complete %s command - No mode provided", command))
                else
                    group:set(args[2])
                end
            end
            local current = chat.highlight(group.current)
            if constants.InvalidModeNames[group.current] then
                current = chat.invalid(group.current)
            end
            logger.Info(chat.group(name) .. chat.message(" group mode set to ") .. current)
            globals.CurrentEventHandler()
        else
            logger.Error(string.format("Unabled to completed %s command - Unable to find group named %s", command, name))
        end
    end
end

local function handleLoggingCommand(args)
    if #args == 0 or not logger.levels[args[1]] then
        logger.level:cycle()
    else
        logger.level:set(args[1])
    end
    print(chat.header("Layers") .. chat.message("Logging level set to ") .. chat.group(logger.level.current))
end

local function handleUpdateCommand()
    local function exec(cmd)
        local ok, _, code = os.execute(cmd)
        if ok == true or ok == 0 then
            return true
        end
        if type(ok) == 'number' and ok == 0 then
            return true
        end
        if ok == true and code == 0 then
            return true
        end
        return false
    end
    local extensionPath = memory.GetExtensionPath()
    if not extensionPath then
        return print(chat.header("Layers") .. chat.error("Unable to determine extension path."))
    end

    local function withPath(command)
        return string.format('cd /d "%s" && %s', extensionPath, command)
    end

    if not exec(withPath("git --version >nul 2>&1")) or exec(withPath("git --version >/dev/null 2>&1")) then
        return print(chat.header("Layers") .. chat.error("Unable to determine git version."))
    end

    if not exec(withPath("git rev-parse --is-inside-work-tree >nul 2>&1")) or exec(withPath("git rev-parse --is-inside-work-tree >/dev/null 2>&1")) then
        return print(chat.header("Layers") .. chat.error("Extension directory is not a git repository."))
    end

    if exec(withPath("git pull")) then
        print(chat.header("Layers") .. chat.message("Extension is up to date."))
        memory.Reload()
    else
        print(chat.header("Layers") .. chat.error("Failed to update ."))
    end
end

local function handleValidateCommand()
    local itemsByName = utils.CollectSetItems(core.Sets)
    itemsByName["Empty"] = nil
    itemsByName["Ignore"] = nil
    local itemList = {}
    local totalItems = 0

    for name, count in pairs(itemsByName) do
        totalItems = totalItems + count
        table.insert(itemList, { name = name, count = count })
    end

    table.sort(itemList, function(a, b)
        return a.name:lower() < b.name:lower()
    end)

    print(chat.header("Layers") .. chat.message("Identified ") .. chat.highlight(tostring(totalItems)) .. chat.message(" required items and ") .. chat.highlight(tostring(#itemList)) .. chat.message(" required unique items"))
    local requiredByName = {}
    local requiredById = {}
    for _, entry in ipairs(itemList) do
        local meta = {
            name = entry.name,
            required = entry.count,
            remaining = entry.count
        }
        local resource = memory.GetItemByName(entry.name)
        if resource and resource.Id then
            meta.id = resource.Id
            requiredById[resource.Id] = meta
        else
            meta.unknown = true
        end
        requiredByName[entry.name] = meta
    end

    local possessed = {}
    local located = {}

    local function record(bucket, name, containerName, count)
        local list = bucket[name]
        if not list then
            list = {}
            bucket[name] = list
        end
        table.insert(list, { container = containerName, count = count })
    end

    local function scanContainers(containerNames, bucket)
        for _, containerName in ipairs(containerNames) do
            local containerId = constants.Containers[containerName]
            if containerId then
                local max = memory.GetContainerCountMax(containerId)
                for index = 1, max do
                    local item = memory.GetContainerItem(containerId, index)
                    if item and item.Id and item.Id ~= 0 then
                        local req = requiredById[item.Id]
                        if req and req.remaining and req.remaining > 0 then
                            local available = item.Count or 1
                            local take = available
                            if take > req.remaining then
                                take = req.remaining
                            end
                            if take > 0 then
                                record(bucket, req.name, containerName, take)
                                req.remaining = req.remaining - take
                            end
                        end
                    end
                end
            end
        end
    end

    local primaryContainers = {
        'Inventory',
        'Satchel',
        'Sack',
        'Case',
        'Wardrobe',
        'Wardrobe2',
        'Wardrobe3',
        'Wardrobe4',
        'Wardrobe5',
        'Wardrobe6',
        'Wardrobe7',
        'Wardrobe8'
    }
    scanContainers(primaryContainers, possessed)

    local secondaryContainers = {
        'Safe',
        'Storage',
        'Locker',
        'Safe2'
    }
    scanContainers(secondaryContainers, located)

    local function sumCounts(entries)
        local total = 0
        for _, e in ipairs(entries) do
            total = total + (e.count or 1)
        end
        return total
    end

    local flatLocated = {}
    local totalLocated = 0
    for name, entries in pairs(located) do
        for _, e in ipairs(entries) do
            local count = e.count or 1
            local containerName = e.container or 'Unknown'
            for i = 1, count do
                totalLocated = totalLocated + 1
                table.insert(flatLocated, {
                    name = name,
                    container = containerName,
                })
            end
        end
    end

    table.sort(flatLocated, function(a, b)
        if a.container == b.container then
            return a.name:lower() < b.name:lower()
        end
        return (a.container or '') < (b.container or '')
    end)

    local missingList = {}
    local totalMissing = 0

    for name, meta in pairs(requiredByName) do
        if meta.remaining and meta.remaining > 0 then
            totalMissing = totalMissing + meta.remaining
            table.insert(missingList, { name = name, count = meta.remaining })
        end
    end

    table.sort(missingList, function(a, b)
        return a.name:lower() < b.name:lower()
    end)
    print(chat.header("Layers") .. chat.message("Located ") .. chat.highlight(tostring(totalItems - totalLocated - totalMissing)) .. chat.message(" accessible items"))
    print(chat.header("Layers") .. chat.message("Located ") .. chat.highlight(tostring(totalLocated)) .. chat.message(" stored items"))
    if #flatLocated > 0 then
        for _, entry in ipairs(flatLocated) do
            print(chat.header("Layers") .. "  " .. chat.location(entry.name) .. " " .. string.char(0x81, 0xC3) .. " " .. chat.charged(entry.container))
            coroutine.sleep(0.05)
        end
    end

    print(chat.header("Layers") .. chat.message("Identified ") .. chat.highlight(tostring(totalMissing)) .. chat.message(" missing items"))
    if #missingList > 0 then
        for _, entry in ipairs(missingList) do
            if entry.count > 1 then
                print(chat.header("Layers") .. "  " .. chat.location(entry.name) .. chat.message(" x ") .. chat.highlight(tostring(entry.count)))
            else
                print(chat.header("Layers") .. "  " .. chat.location(entry.name))
            end
            coroutine.sleep(0.05)
        end
    end
end

---
-- Retrieve an unordered set of classifiers for something in the taxonomy.
-- @param args A table containing the split user command indexed by command word order ({[1] = 'cycle', [2] = 'modeGroup'})
--
-- The following commands are valid
-- cycle modeGroup - Cycles the mode for a modeGroup
-- cycleback modeGroup -- Cycles the mode for modeGroup (reversed)
-- reset modeGroup - Resets the provided modeGroup to the default value
-- set modeGroup mode - Sets the mode for the provided modeGroup
-- logging [mode] - Sets the logging mode to the provided level (Debug, Trace, etc.) or cycles it if no level is provided.
commands.HandleCommand = function(args)
    local command = table.remove(args, 1)
    local modeGroupCommands = {
        cycle = true,
        cycleback = true,
        reset = true,
        set = true
    }
    if modeGroupCommands[command] then
        handleModeGroupCommand(command, args)
    elseif command == 'logging' then
        handleLoggingCommand(args)
    elseif command == 'update' or command == 'u' then
        handleUpdateCommand()
    elseif command == 'validate' or command == 'v' then
        handleValidateCommand()
    end
end

return commands
