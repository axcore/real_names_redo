---------------------------------------------------------------------------------------------------
-- real_names_redo mod by A S Lewis, based on real_names by Extex101
---------------------------------------------------------------------------------------------------
-- commands.lua
--      Defines chat commands
---------------------------------------------------------------------------------------------------

local S = minetest.get_translator(minetest.get_current_modname())

---------------------------------------------------------------------------------------------------
-- /name_info
--      Displays your "real" name
-- /name_info <player>
--      Displays the "real" name of <player>
---------------------------------------------------------------------------------------------------

ChatCmdBuilder.new("name_info", function(cmd)

    cmd:sub("", function(caller)

        local real_name = rn.data:get_string(caller)
        return true, S("Your real name is") .. ": " .. real_name

    end)

    cmd:sub(":target", function(name, target)

        local player = minetest.get_player_by_name(target)
        local real_name

        if not player then
            return false, S("Please choose a valid player name")
        else
            return true, target .. S("'s real name is") .. " " .. rn.data:get_string(target)
        end

    end)

end,
    {
        params = "<player>",
        description = S("Get the real name of a player"),
    }
)

---------------------------------------------------------------------------------------------------
-- /change_name
--      Opens the formspec, so the player can set a new "real" name
-- /change_name <player>
--      Shows the formspec to <player>
-- /change_name <player> <first> <second>
--      Changes <player>'s name to <first> <second>. This is independent of the setting of
--          rn.lang_name
---------------------------------------------------------------------------------------------------

ChatCmdBuilder.new("change_name", function(cmd)

    cmd:sub("", function(caller)

        local player = minetest.get_player_by_name(caller)

        if not player then
            return false, "You must be online to do this"
        else
            rn.show_formspec(player:get_player_name())
        end

    end)

    cmd:sub(":target", function(name, target)

        local player = minetest.get_player_by_name(target)

        if not player then
            return false, S("Please choose a valid player name")
        else
            rn.show_formspec(player:get_player_name())
        end

    end)

    cmd:sub(":target :firstname :lastname", function(caller, target, first_name, last_name)

        local player = minetest.get_player_by_name(target)
        local new_name = first_name .. " " .. last_name
        local original_name = rn.data:get_string(target)

        if not player then

            return false, S("Please choose a valid player name")

        else

            rn.data:set_string(player:get_player_name(), new_name)
            minetest.chat_send_all(rn.data:get_string(target) .. ", " .. new_name)

            if rn.data:get_string(target) == tostring(new_name) then

                minetest.chat_send_player(
                    target,
                    S("Your name has been changed to") .. ": " .. new_name
                )

                return true, target .. S("'s name successfully set to") .. ": " .. new_name

            else

                rn.data:set_string(player:get_player_name(), original_name)
                return false, S("Something went wrong, the name has been reset")

            end
        end

    end)

end,
    {
        params = "<player> |<new name>|",
        description = S("Set the player\'s name to <new name>"),
        privs = {
            change_name = true
        },
    }
)
