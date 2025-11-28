---
-- A collection of small functions that are common in other parts of then
-- extension.
---
local utils = {}

utils.TableLength = function(t)
    local count = 0
    for _ in pairs(t) do
        count = count + 1
    end
    return count
end

utils.MergeSets = function(lhs, rhs)
    local selected = utils.SelectItems(rhs)
    for slot, item in pairs(selected) do
        if constants.Slots[slot] then
            lhs[slot] = item
        end
    end
    return lhs
end

utils.CopyTable = function(t, filter)
    local copy = {}
    local exclude = filter or {}
    for k, v in ipairs(t) do
        if not exclude[v] then
            table.insert(copy, v)
        end
    end
    return copy
end

utils.GetSetItemCount = function(set)
    local count = 0
    for k, v in pairs(set) do
        if constants.Slots[k] then
            count = count + 1
        end
    end
    return count
end

utils.LogSetDetails = function(baseSet, event, mode, classifierName)
    if logger.level.index <= logger.levels['Trace'] then
        local count = utils.GetSetItemCount(baseSet) 
        local found
        if count > 0 then
            found = chat.highlight(string.format("%d items found", count))
        else
            found = chat.invalid(string.format("%d items found", count))
        end
        local location
        if mode then
            location = "profile.Sets." .. mode .. "." .. event
        else
            location = "profile.Sets." .. event
        end
        local location = "profile.Sets"
        if mode then
            location = location .. "." .. mode
        end
        location = location .. "." .. event
        if classifierName then
            location = location .. "." .. classifierName
        end
        logger.Trace(chat.message("Searching ") .. chat.location(location) .. chat.message(" for items - ") .. found, true)
    end
end

utils.EvaluateSet = function(set, level)
    local t = {}
    for slotName, slotEntries in pairs(set) do
        if (constants.Slots[slotName] ~= nil) then
            if type(slotEntries) == 'string' then
                t[slotName] = slotEntries
            elseif type(slotEntries) == 'table' then
                if slotEntries[1] == nil then
                    t[slotName] = slotEntries
                else
                    for _, potentialEntry in ipairs(slotEntries) do
                        if memory.EvaluateItem(potentialEntry, level) then
                            t[slotName] = potentialEntry
                            break
                        end
                    end
                end
            end
        end
    end
    return t
end

utils.EvaluateSets = function(root, level)
    for k, v in pairs(root) do
        if type(k) == 'string' and type(v) == 'table' and k ~= '__parent' then
            if (#k > 9) and (string.sub(k, -9) == '_Priority') then
                local base = string.sub(k, 1, -10)
                local t = rawget(root, base)
                if not t then
                    t = {}
                    rawset(root, base, t)
                end
                for slot, item in pairs(utils.EvaluateSet(v, level)) do
                    t[slot] = item
                end
            elseif not constants.Slots[k] then
                utils.EvaluateSets(v, level)
            end
       end
   end
end

utils.EvaluateLevels = function(sets)
    local level = memory.GetMainJobLevel()
    if level ~= globals.LastPlayerLevel and level ~= 0 then
        logger.Info(chat.message("Player level set to " .. chat.highlight(level)))
        utils.EvaluateSets(sets, level)
        globals.LastPlayerLevel = level
    end
end

utils.SelectItem = function(items)
    if type(items) == 'string' then
        return items
    end
    if type(items) == 'table' and items.Name then
        if items.When then
            local wrapper = groups.GetGroup(items.When)
            local mode = wrapper.group.current
            if (wrapper.implicit and not constants.InvalidModeNames[mode]) or (not wrapper.implicit and mode == items.When) then
                return items
            end
        else
            return items
        end
    end
    for _, item in ipairs(items) do
        if type(item) == 'table' and item.When then
            local wrapper = groups.GetGroup(item.When)
            local mode = wrapper.group.current
            if (wrapper.implicit and not constants.InvalidModeNames[mode]) or (not wrapper.implicit and mode == item.When) then
                return item
            end
        elseif type(item) == 'table' then
            return item
        end
    end
end

utils.SelectItems = function(set)
    local selectedItems = {}
    for slotName, slotEntries in pairs(set) do
        if constants.Slots[slotName] then
            local item = utils.SelectItem(slotEntries)
            if item then
                selectedItems[slotName] = utils.SelectItem(slotEntries)
            end
        end
    end
    return selectedItems
end

utils.CollectSetItems = function(root)
    local items = {}
    local function addTableItems(t)
        local localCounts = {}

        for slotName, slotValue in pairs(t) do
            if type(slotName) == 'string' and constants.Slots[slotName] then
                local slotNames = {}

                if type(slotValue) == 'string' then
                    if slotValue ~= '' then
                        slotNames[slotValue] = true
                    end
                elseif type(slotValue) == 'table' then
                    if slotValue[1] ~= nil then
                        for _, entry in ipairs(slotValue) do
                            if type(entry) == 'string' then
                                if entry ~= '' then
                                    slotNames[entry] = true
                                end
                            elseif type(entry) == 'table' and type(entry.Name) == 'string' and entry.Name ~= '' then
                                slotNames[entry.Name] = true
                            end
                        end
                    else
                        if type(slotValue.Name) == 'string' and slotValue.Name ~= '' then
                            slotNames[slotValue.Name] = true
                        end
                    end
                end

                for name, _ in pairs(slotNames) do
                    localCounts[name] = (localCounts[name] or 0) + 1
                end
            end
        end

        for name, count in pairs(localCounts) do
            if not items[name] or count > items[name] then
                items[name] = count
            end
        end
    end

    local visited = {}
    local stack = { root }

    while #stack > 0 do
        local current = table.remove(stack)
        if type(current) == 'table' and not visited[current] then
            visited[current] = true

            addTableItems(current)

            for k, v in pairs(current) do
                if type(v) == 'table' and k ~= '__parent' and k ~= '__name' and not constants.Slots[k] then
                    table.insert(stack, v)
                end
            end
        end
    end

    return items
end

utils.CreateCompoundPredicate = function(input)
    local function parse_expression(expression)
        if expression == "" then
            error("Empty expression is not allowed")
        end

        -- Trim whitespace from the expression
        expression = expression:match("^%s*(.-)%s*$")

        -- Validate parentheses are balanced
        local parens_level = 0
        for i = 1, #expression do
            local char = expression:sub(i, i)
            if char == "(" then
                parens_level = parens_level + 1
            elseif char == ")" then
                parens_level = parens_level - 1
                if parens_level < 0 then
                    error("Mismatched parentheses: Extra closing parenthesis")
                end
            end
        end
        if parens_level > 0 then
            error("Mismatched parentheses: Missing closing parenthesis")
        end

        -- First, look for top-level operators (outside parentheses)
        -- && has higher precedence than ||, so we search for || first (lower precedence)
        -- then && (higher precedence), processing right-to-left to maintain left-associativity
        local op_pos, op
        local operators_low_prec = {"||"}  -- Lower precedence operators
        local operators_high_prec = {"&&"}  -- Higher precedence operators
        parens_level = 0

        -- First, look for lower precedence operators (||) at top level
        for i = #expression, 1, -1 do
            local char = expression:sub(i, i)
            if char == ")" then
                parens_level = parens_level + 1
            elseif char == "(" then
                parens_level = parens_level - 1
            elseif parens_level == 0 then
                for _, operator in ipairs(operators_low_prec) do
                    if expression:sub(i, i + #operator - 1) == operator then
                        op_pos, op = i, operator
                        break
                    end
                end
            end
            if op_pos then break end
        end

        -- If no lower precedence operator found, look for higher precedence operators (&&)
        if not op_pos then
            parens_level = 0
            for i = #expression, 1, -1 do
                local char = expression:sub(i, i)
                if char == ")" then
                    parens_level = parens_level + 1
                elseif char == "(" then
                    parens_level = parens_level - 1
                elseif parens_level == 0 then
                    for _, operator in ipairs(operators_high_prec) do
                        if expression:sub(i, i + #operator - 1) == operator then
                            op_pos, op = i, operator
                            break
                        end
                    end
                end
                if op_pos then break end
            end
        end



        -- If we found an operator, split and recurse
        if op then
            local left = expression:sub(1, op_pos - 1):match("^%s*(.-)%s*$")
            local right = expression:sub(op_pos + #op):match("^%s*(.-)%s*$")
            if left == "" or right == "" then
                error("Invalid syntax: Missing operand around operator '" .. op .. "'")
            end
            local left_pred = parse_expression(left)
            local right_pred = parse_expression(right)
            if op == "&&" then
                return function() return left_pred() and right_pred() end
            elseif op == "||" then
                return function() return left_pred() or right_pred() end
            end
        end

        -- Strip outer parentheses if the entire expression is wrapped
        if expression:sub(1, 1) == "(" and expression:sub(-1) == ")" then
            local inner = expression:sub(2, -2):match("^%s*(.-)%s*$")
            return parse_expression(inner)
        end

        -- Handle negation operator (only applies to atomic expressions)
        if expression:sub(1, 1) == "~" then
            local rest = expression:sub(2):match("^%s*(.-)%s*$")
            if rest == "" then
                error("Invalid syntax: Negation operator requires an operand")
            end
            -- Parse the rest as an atomic expression (could be a predicate or parenthesized expression)
            local inner_pred = parse_expression(rest)
            return function()
                return not inner_pred()
            end
        end

        -- At this point, we should have an atomic predicate (no operators, no negation, no outer parentheses)
        if expression:find("[%(%)]") then
            error("Invalid syntax: Mismatched or unexpected parentheses")
        end
        local trimmed = expression:match("^%s*(.-)%s*$")
        local predicate = predicates[trimmed]
        if predicate then
            return predicate
        else
            local wrapper = groups.GetGroup(trimmed)
            if not wrapper then
                error("Unable to create compound predicate - [" .. input .. "] contains invalid input [" .. trimmed .. "] in subexpression [" .. expression .."]")
            end
            local predicate = function()
                return wrapper.group.current == trimmed
            end
            return predicate
        end
    end

    return parse_expression(input)
end

return utils
