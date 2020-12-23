---------------------------------------------------------------------------------------------------
-- real_names_redo mod by A S Lewis, based on real_names by Extex101
---------------------------------------------------------------------------------------------------
-- form.lua
--      Handle the formspec
---------------------------------------------------------------------------------------------------

local S = minetest.get_translator(minetest.get_current_modname())

---------------------------------------------------------------------------------------------------
-- Display the formspec, when required
---------------------------------------------------------------------------------------------------

function rn.show_formspec(player_name)

    local dropdown_string = ""
    local dropdown_index = 1
    local count = 0

    -- (If a name was generated during a previous session, then make sure it is visible in the
    --      formspec. Separate first/last names are not stored between sessions, so cannot be
    --      displayed)
    if rn.data:get_string(player_name) ~= (nil or "") and rn.full_name == "" then
        rn.full_name = rn.data:get_string(player_name)
    end

    -- Prepare the formspec
    for lang_name, lang_type in pairs(rn.config_dict) do

        count = count + 1

        if dropdown_string == "" then
            dropdown_string = lang_name
        else
            dropdown_string = dropdown_string .. "," .. lang_name
        end

        if lang_name == rn.lang_name then
            dropdown_index = count
        end

    end

    local form = "size[5,5]" ..

        "image[2,0;1,1;logo.png]" ..
        "image[0.55,1;4.5,0.5;menu_header.png]" ..

        "dropdown[0,1.75;3,0.5;category;" .. dropdown_string .. ";" .. tostring(dropdown_index)
            .. "]" ..

        "button[3,1.65;1,1;is_boy;" .. S("Boy") .. "]" ..
        "button[4,1.65;1,1;is_girl;" .. S("Girl") .. "]" ..

        "label[0,2.8;" .. S("Given name") .. "]" ..
        "field[1.5,2.9;2.75,1;first_name;;" .. rn.first_name .. "]" ..
        "field_close_on_enter[first_name;false]" ..
        "button[4,2.6;1,1;reroll_first;" .. S("Roll") .. "]" ..

        "label[0,3.7;" .. S("Family name") .. "]" ..
        "field[1.5,3.8.3;2.75,1;last_name;;" .. rn.last_name .. "]" ..
        "field_close_on_enter[last_name;false]" ..
        "button[4,3.5;1,1;reroll_last;" .. S("Roll") .. "]" ..

        "field[0.25,4.7;4,1;full_name;;" .. rn.full_name .. "]"

    -- (The "Save" button is not visible until a name has been generated)
    if rn.full_name ~= "" then
        form = form .. "button_exit[4,4.4;1,1;save;" .. S("Save") .. "]"
    end

    -- Create the formspec
    minetest.show_formspec(player_name, rn.name .. ":form", form)

end
