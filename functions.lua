---------------------------------------------------------------------------------------------------
-- real_names_redo mod by A S Lewis, based on real_names by Extex101
---------------------------------------------------------------------------------------------------
-- functions.lua
--      Define functions
---------------------------------------------------------------------------------------------------

local S = minetest.get_translator(minetest.get_current_modname())

---------------------------------------------------------------------------------------------------
-- Generate the full name
---------------------------------------------------------------------------------------------------

-- Generate a full name, with the given/family names in the correct order, according to the value of
--      rn.lang_type
function rn.get_full_name()

    if rn.lang_type == "asian" then
        return rn.last_name .. " " .. rn.first_name
    else
        return rn.first_name .. " " .. rn.last_name
    end

end
