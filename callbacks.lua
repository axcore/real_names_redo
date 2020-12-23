---------------------------------------------------------------------------------------------------
-- real_names_redo mod by A S Lewis, based on real_names by Extex101
---------------------------------------------------------------------------------------------------
-- callbacks.lua
--      Define callbacks
---------------------------------------------------------------------------------------------------

local S = minetest.get_translator(minetest.get_current_modname())

---------------------------------------------------------------------------------------------------
-- Handle formspec callbacks
---------------------------------------------------------------------------------------------------

minetest.register_on_player_receive_fields(function(player, form_name, fields)

    local first_list
    local last_list
    local new_first
    local new_last
    local new_lang_flag
    local old_name

    -- Sanity check
    if form_name ~= rn.name .. ":form" then
        return
    end

    -- When the "Save" button is clicked, store the generated name (but don't change anything if
    --      the user is keeping their old name)
    if fields.save then

        old_name = player:get_player_name()

        if rn.data:get_string(old_name) == (nil or "") then

            minetest.chat_send_all(S("Welcome to a new player: ") .. rn.full_name)
            rn.data:set_string(old_name, rn.full_name)

        elseif rn.data:get_string(old_name) ~= rn.full_name then

            minetest.chat_send_all(old_name .. S(" has changed their name to ") .. rn.full_name)
            rn.data:set_string(old_name, rn.full_name)

        end

    end

    -- Handle the 'escape' key (or disconnection from the server)
    if fields.quit then
        return
    end

    -- When the user changes the gender (by clicking the buttons) or changes the "language" (by
    --      using the dropdown), update global variables
    if fields.is_boy then
        rn.current_gender = "boy"
    elseif fields.is_girl then
        rn.current_gender = "girl"
    end

    if fields.category ~= rn.lang_name then
        new_lang_flag = true
        rn.lang_name = fields.category
        rn.lang_type = rn.config_dict[rn.lang_name]
    end

    -- When any widget besides the "Save" button is clicked, generate a new name
    if new_lang_flag or fields.is_boy or fields.is_girl or fields.reroll_first
    or fields.reroll_last then

        if rn.current_gender == "boy" then

            -- Prepare a boy's name
            first_list = rn.name_dict[rn.lang_name]["first_boy"]
            last_list = rn.name_dict[rn.lang_name]["last"]

        else

            -- Prepare a girl's name
            first_list = rn.name_dict[rn.lang_name]["first_girl"]
            if rn.lang_type == "slavic" then
                last_list = rn.name_dict[rn.lang_name]["last_girl"]
            else
                last_list = rn.name_dict[rn.lang_name]["last"]
            end

        end

        -- Generate the name
        new_first = first_list[math.random(1, #first_list)]
        new_last = last_list[math.random(1, #last_list)]

        -- Update global variables, depending on which button was clicked
        if new_lang_flag or rn.first_name == "" or fields.is_boy or fields.is_girl
        or fields.reroll_first then
            rn.first_name = new_first
        end

        if new_lang_flag or rn.last_name == "" or fields.is_boy or fields.is_girl
        or fields.reroll_last then
            rn.last_name = new_last
        end

        rn.full_name = rn.get_full_name()

        -- Update the formspec
        rn.show_formspec(player:get_player_name())

    end

end)
