---
-- Cannonical taxonomy classifiers are defined accessed and accessed here.
--
-- The classifiers for all of the entries in the taxonomy were created by
-- first flattening hand-made hierarchical taxonomies and then appending
-- the elemental affinity and damage type (or some other type if the spell
-- did not do damage.)
---
local taxonomy = {
    Spell = gFunc.LoadFile('layers\\classifiers\\spells'),
    Ability = gFunc.LoadFile('layers\\classifiers\\abilities'),
    Weaponskill = gFunc.LoadFile('layers\\classifiers\\weaponskills'),
    Pet = gFunc.LoadFile('layers\\classifiers\\pets'),
    PetWeaponskill = gFunc.LoadFile('layers\\classifiers\\petweaponskills')
}

---
-- Retrieve an unordered set of classifiers for something in the taxonomy.
-- @param category The taxonomy (Spell, Ability, Weaponskill, Pet, PetWeaponskill) to search
-- @param spell The spell, ability, weaponskill, pet weaponskill, or pet name.
-- @return A table of classifiers indexed by the classifier name
taxonomy.GetClassifiers = function(category, spell)
    local classifiers = {}
    for k, v in ipairs(taxonomy[category][string.gsub(spell, '\0', '')] or {}) do
        classifiers[v] = true
    end
    return classifiers
end

---
-- Retrieve an ordered set of classifiers for something in the taxonomy.
-- @param category The taxonomy (Spell, Ability, Weaponskill, Pet, PetWeaponskill) to search
-- @param spell The spell, ability, weaponskill, pet weaponskill, or pet name.
-- @return A table of classifiers indexed their rank in the taxonomy
taxonomy.GetOrderedClassifiers = function(category, spell)
    local classifiers = {}
    for k, v in ipairs(taxonomy[category][string.gsub(spell, '\0', '')] or {}) do
        classifiers[k] = v
    end
    return classifiers
end

---
-- Identical to GetOrderedClassifiers but no copy is made.
-- @param category The taxonomy (Spell, Ability, Weaponskill, Pet, PetWeaponskill) to search
-- @param spell The spell, ability, weaponskill, pet weaponskill, or pet name.
-- @return A table of classifiers indexed their rank in the taxonomy
taxonomy.GetRawClassifiers = function(category, spell)
    return taxonomy[category][string.gsub(spell, '\0', '')] or {}
end

return taxonomy
