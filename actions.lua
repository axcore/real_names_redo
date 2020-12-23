---------------------------------------------------------------------------------------------------
-- real_names_redo mod by A S Lewis, based on real_names by Extex101
---------------------------------------------------------------------------------------------------
-- actions.lua
--      Define actions
---------------------------------------------------------------------------------------------------

local S = minetest.get_translator(minetest.get_current_modname())

---------------------------------------------------------------------------------------------------
-- Set up privileges
---------------------------------------------------------------------------------------------------

minetest.register_privilege("change_name", {
    description = S("Allows players to change their 'real name' using /change_name"),
    give_to_singleplayer = false,
})

---------------------------------------------------------------------------------------------------
-- Show new players the formspec
---------------------------------------------------------------------------------------------------

-- When a player joins, show them the formspec, so they can choose a "real" name
minetest.register_on_joinplayer(function(player)

    local player_name = player:get_player_name()

    if rn.data:get_string(player_name) == (nil or "") then
        rn.show_formspec(player_name)
    end

end)

-- Same action for a server
--  minetest.register_globalstep(function()

--      for _, player in ipairs(minetest.get_connected_players()) do

--          local player_name = player:get_player_name()

--          if rn.data:get_string(player_name) == (nil or "") then
--              rn.show_formspec(player_name)
--          end
--      end

--  end)
