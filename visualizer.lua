---
-- Mode group value visualizer.
--
-- The overlay is configured from the job file, which is where the mode groups
-- themselves are defined:
--
--   layers.visualizer({
--       Enabled = true,
--       Position = { X = 60, Y = 200 },
--       Scale = 1.25,
--       BackgroundColor = { 0.0, 0.0, 0.0, 0.65 },
--       NameColor = { 0.75, 0.75, 0.75, 1.0 },
--       Groups = {
--           'Weapon',
--           { Name = 'Defense', DisplayName = 'Def', Colors = { PDT = { 0.6, 0.9, 0.6, 1.0 } } },
--       },
--   })
--
-- Groups are displayed in the order they are listed, so the Groups list also
-- decides which mode groups are shown.  Without a Groups list every mode group
-- that was not created implicitly is shown in the order it was created.
--
-- An entry can set DisplayName to show a name other than the mode group's own.
--
-- The overlay is as wide as the longest possible row, so switching a group to a
-- shorter value does not resize it.  Rows are measured with the name that is
-- displayed, so a DisplayName changes the width the same way the group name
-- would.  Values are red when the group is set to Off and blue otherwise.
-- OffColor and DefaultColor change those two defaults.  A group can replace the
-- default for its own values with Color, and replace the color of individual
-- values with Colors.  BackgroundColor sets the color and opacity of the window
-- itself, and defaults to black at half opacity.
--
-- The overlay is shown once it has been configured.  Pass Enabled = false to
-- configure it without showing it.  The commands are:
--
-- /lac fwd visualizer        -- Cycle the overlay on or off
-- /lac fwd visualizer on     -- Show the overlay
-- /lac fwd visualizer off    -- Hide the overlay
local visualizer = {}

local eventName = 'd3d_present'
local eventAlias = 'layers_mode_visualizer'
local windowName = '##layers_mode_visualizer'

local defaultX = 60
local defaultY = 200
local maxWindowSize = 1000000

local offColor = { 1.0, 0.35, 0.35, 1.0 }
local defaultValueColor = { 0.4, 0.7, 1.0, 1.0 }
local emptyColor = { 0.65, 0.65, 0.65, 1.0 }
local defaultBackgroundColor = { 0.0, 0.0, 0.0, 0.5 }

-- Every option the configuration table understands.  Anything else is a typo
-- in the job file and is reported rather than ignored.
local knownOptions = {
    BackgroundColor = true,
    DefaultColor = true,
    Enabled = true,
    Groups = true,
    NameColor = true,
    OffColor = true,
    Position = true,
    Scale = true
}

visualizer.Enabled = false
visualizer.X = defaultX
visualizer.Y = defaultY
visualizer.Scale = 1.0
visualizer.BackgroundColor = defaultBackgroundColor
visualizer.NameColor = nil
visualizer.Groups = nil
visualizer.OffColor = offColor
visualizer.DefaultColor = defaultValueColor
visualizer.Width = nil

---
-- Return whether the provided value can be used as an ImGui color.
local function isColor(value)
    return type(value) == 'table'
        and type(value[1]) == 'number'
        and type(value[2]) == 'number'
        and type(value[3]) == 'number'
end

---
-- Copy a color so later changes to the configuration table cannot reach it.
local function toColor(value)
    return { value[1], value[2], value[3], value[4] or 1.0 }
end

---
-- Build the display entry for one entry of the Groups list.
-- @param entry A mode group name, or a table containing the name and colors.
local function normalizeEntry(entry)
    local name = entry
    if type(entry) == 'table' then
        name = entry.Name
    end
    if type(name) ~= 'string' then
        return nil
    end

    local display = { name = name, wrapper = groups.GetGroupByGroupName(name) }
    if type(entry) == 'table' then
        if type(entry.DisplayName) == 'string' and entry.DisplayName ~= '' then
            display.label = entry.DisplayName
        end
        if isColor(entry.Color) then
            display.color = toColor(entry.Color)
        end
        if type(entry.Colors) == 'table' then
            display.colors = {}
            for value, color in pairs(entry.Colors) do
                if isColor(color) then
                    display.colors[value] = toColor(color)
                end
            end
        end
    end
    return display
end

---
-- Configure the overlay.
-- @param options A table containing the overlay configuration.
visualizer.Configure = function(options)
    if type(options) ~= 'table' then
        return logger.Error('Unable to configure the mode group visualizer - options must be a table')
    end

    local unknown = {}
    for key, _ in pairs(options) do
        if not knownOptions[key] then
            table.insert(unknown, tostring(key))
        end
    end
    if #unknown > 0 then
        table.sort(unknown)
        logger.Error(string.format('Unrecognized mode group visualizer option %s', table.concat(unknown, ', ')))
    end

    -- Configuring the overlay turns it on unless the profile says otherwise.
    visualizer.Enabled = options.Enabled == nil or options.Enabled == true

    local position = options.Position
    if type(position) == 'table' then
        visualizer.X = tonumber(position.X or position.x) or defaultX
        visualizer.Y = tonumber(position.Y or position.y) or defaultY
    end

    local scale = tonumber(options.Scale)
    if scale and scale > 0 then
        visualizer.Scale = scale
    end

    if isColor(options.BackgroundColor) then
        visualizer.BackgroundColor = toColor(options.BackgroundColor)
    end
    if isColor(options.NameColor) then
        visualizer.NameColor = toColor(options.NameColor)
    end
    if isColor(options.OffColor) then
        visualizer.OffColor = toColor(options.OffColor)
    end
    if isColor(options.DefaultColor) then
        visualizer.DefaultColor = toColor(options.DefaultColor)
    end

    if type(options.Groups) == 'table' then
        local configured = {}
        for _, entry in ipairs(options.Groups) do
            local display = normalizeEntry(entry)
            if display then
                table.insert(configured, display)
            end
        end
        visualizer.Groups = configured
    end

    -- The width depends on the groups and the scale.
    visualizer.Width = nil
end

---
-- Return whether the overlay can be drawn by the host addon.
visualizer.IsAvailable = function()
    return imgui ~= nil and ashita ~= nil and ashita.events ~= nil
end

---
-- Show or hide the overlay.
-- @param enabled Whether the overlay should be visible.
visualizer.SetEnabled = function(enabled)
    visualizer.Enabled = enabled == true
    return visualizer.Enabled
end

---
-- Toggle the overlay on or off.
visualizer.Toggle = function()
    return visualizer.SetEnabled(not visualizer.Enabled)
end

---
-- Return the configured display entries, or every mode group when the profile
-- did not provide a Groups list.
local function getDisplayGroups()
    if visualizer.Groups then
        return visualizer.Groups
    end

    local display = {}
    for _, wrapper in ipairs(groups.groupWrapperArray) do
        if not wrapper.implicit then
            table.insert(display, { name = wrapper.name, wrapper = wrapper })
        end
    end
    return display
end

---
-- Return the mode group for a display entry, or nil when the profile named a
-- group that does not exist.
local function resolveWrapper(display)
    if not display.wrapper then
        display.wrapper = groups.GetGroupByGroupName(display.name)
    end
    return display.wrapper
end

---
-- Return every value the mode group can display.
--
-- The overlay is wide enough for all of them, so changing a group to a shorter
-- value does not resize the overlay.
local function getPossibleValues(mode)
    local values = {}

    if mode._type == 'boolean' then
        values[1] = tostring(mode[true])
        values[2] = tostring(mode[false])
    else
        for _, value in ipairs(mode) do
            if type(value) == 'string' then
                table.insert(values, value)
            end
        end
        if #values == 0 then
            values[1] = tostring(mode.current)
        end
    end
    return values
end

---
-- Return the name to show for a display entry.
local function getDisplayName(display, wrapper)
    return display.label or wrapper.name
end

---
-- Return the color to draw a value with.
local function getValueColor(display, value, isOff)
    if display.colors and display.colors[value] then
        return display.colors[value]
    end
    if isOff then
        return visualizer.OffColor
    end
    if display.color then
        return display.color
    end
    return visualizer.DefaultColor
end

---
-- Build the rows that will be displayed in the overlay.
local function buildRows()
    local rows = {}
    for _, display in ipairs(getDisplayGroups()) do
        local wrapper = resolveWrapper(display)
        if wrapper then
            local value = tostring(wrapper.group.current)
            table.insert(rows, {
                name = getDisplayName(display, wrapper) .. ':',
                value = value,
                color = getValueColor(display, value, value:lower() == 'off')
            })
        end
    end
    return rows
end

---
-- Measure how wide the overlay has to be to fit the longest possible row.
--
-- This runs on the first frame and whenever the configuration changes, because
-- the text size depends on the scale that is currently pushed.
local function measureWidth()
    local style = imgui.GetStyle()
    local padding = style.WindowPadding and style.WindowPadding.x or 8
    local spacing = style.ItemSpacing and style.ItemSpacing.x or 8

    local widest = 0
    for _, display in ipairs(getDisplayGroups()) do
        local wrapper = resolveWrapper(display)
        if wrapper then
            local nameWidth = imgui.CalcTextSize(getDisplayName(display, wrapper) .. ':')
            for _, value in ipairs(getPossibleValues(wrapper.group)) do
                local width = nameWidth + spacing + imgui.CalcTextSize(value)
                if width > widest then
                    widest = width
                end
            end
        end
    end
    if widest == 0 then
        widest = imgui.CalcTextSize('No mode groups')
    end

    return math.floor(widest + padding * 2 + 2)
end

---
-- Push the configured scale, and return whether the stack changed.
local function pushScale()
    if visualizer.Scale == 1.0 then
        return false
    end

    imgui.PushFont(nil, imgui.GetFontSize() * visualizer.Scale)
    return true
end

---
-- Draw the mode group list.
local function draw()
    if not visualizer.Enabled or not imgui or not imguiWindowFlags then
        return
    end

    -- The overlay takes no input, so clicks pass through it to the game.
    local flags = imguiWindowFlags.NoDecoration
        + imguiWindowFlags.AlwaysAutoResize
        + imguiWindowFlags.NoSavedSettings
        + imguiWindowFlags.NoInputs

    -- The width is measured on the first frame with the configured scale pushed,
    -- then pinned so the overlay cannot resize as values change.
    if visualizer.Width then
        imgui.SetNextWindowSizeConstraints(
            { visualizer.Width, 0 },
            { visualizer.Width, maxWindowSize })
    end

    imgui.SetNextWindowPos({ visualizer.X, visualizer.Y }, imguiCondAlways)
    local useBackground = visualizer.BackgroundColor ~= nil and imguiColWindowBg ~= nil
    if useBackground then
        imgui.PushStyleColor(imguiColWindowBg, visualizer.BackgroundColor)
    end

    if imgui.Begin(windowName, true, flags) then
        local pushed = pushScale()
        if not visualizer.Width then
            visualizer.Width = measureWidth()
        end

        local rows = buildRows()
        if #rows == 0 then
            imgui.TextColored(emptyColor, 'No mode groups')
        else
            for _, row in ipairs(rows) do
                if visualizer.NameColor then
                    imgui.TextColored(visualizer.NameColor, row.name)
                else
                    imgui.Text(row.name)
                end
                imgui.SameLine()
                imgui.TextColored(row.color, row.value)
            end
        end
        if pushed then
            imgui.PopFont()
        end
    end
    imgui.End()

    if useBackground then
        imgui.PopStyleColor(1)
    end
end

---
-- Register the overlay draw handler, replacing any handler from a previous load.
visualizer.Register = function()
    if not ashita or not ashita.events or not imgui then
        return
    end

    pcall(ashita.events.unregister, eventName, eventAlias)
    local success, err = pcall(ashita.events.register, eventName, eventAlias, draw)
    if not success then
        logger.Error(string.format('Unable to register the mode group visualizer - %s', tostring(err)))
    end
end

---
-- Remove the overlay draw handler.
visualizer.Unregister = function()
    if not ashita or not ashita.events then
        return
    end
    pcall(ashita.events.unregister, eventName, eventAlias)
end

visualizer.Register()

return visualizer
