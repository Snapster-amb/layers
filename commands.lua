---
-- User commands passed through gearswap or LuAshitacast are handled here
---
local commands = {}

local function handleModeGroupCommand(command, args)
    if #args == 0 then
        logger.Error(string.format("Unable to complete %s command - No group name provided", command))
    else
        local name = args[1]
        local group = utils.GetGroup(name)
        if group then
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
    end
end

return commands
