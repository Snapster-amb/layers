---
-- Shim file for gearswap. This feature can't be supported on windower4.
---
local stickyitems = {}

stickyitems.Bind = function() end

stickyitems.AddChargedItem = function(item)
    logger.Error("Unable to add item to charged items set - charged items are not supported on gearswap")
end

stickyitems.RemoveChargedItem = function(item)
    logger.Error("Unable to remove item from charged items set - charged items are not supported on gearswap")
end

stickyitems.AddEnchantedItem = function(item)
    logger.Error("Unable to add item to enchanted items set - enchanted items are not supported on gearswap")
end

stickyitems.RemoveEnchantedItem = function(item)
    logger.Error("Unable to remove item from enchanted items set - enchanted items are not supported on gearswap")
end

return stickyitems
