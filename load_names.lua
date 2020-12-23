---------------------------------------------------------------------------------------------------
-- real_names_redo mod by A S Lewis, based on real_names by Extex101
---------------------------------------------------------------------------------------------------
-- load_names.lua
--      Loads lists of names
---------------------------------------------------------------------------------------------------

local S = minetest.get_translator(minetest.get_current_modname())

---------------------------------------------------------------------------------------------------
-- Notes
---------------------------------------------------------------------------------------------------

-- Let's divide the world into "languages", each with their own characteristic names
--
-- The file .../names/config.txt provides a list of "languages". Each "language" is defined on a
--      separate line. To add a new language, just add a new line
--
-- Each line is in the form
--      language_type language_name
-- For example
--      western French
--
-- "language_type" specifies how the language handles names. There are three possible values:
--      "western", "slavic" and "asian"
-- For "western", we expect west European names, e.g. "Adam Smith" and "Alice Smith"
-- For "slavic", we expect Slavic names, e.g. "Tomas Novák" and "Jana Nováková"
-- For "asian", we expect the surname first, e.g. "Nguyễn Chi" and "Nguyễn Chau"
-- "language_name" can be any text (including multiple words)
--
-- For each "language", we add a sub-folder with the same "language_name"
-- Each folder contains one or more of the following files:
--      firstboy.txt
--      firstgirl.txt
--      last.txt
--      lastgirl.txt
-- All files are optional. The lastgirl.txt file is only used when "language_type" is "slavic"
-- Each file consists of a list of names, one name per line. Empty lines are ignored

---------------------------------------------------------------------------------------------------
-- Functions
---------------------------------------------------------------------------------------------------

local function read_config_file(path)

    local file = io.open(path, "r")

    if not file then
        minetest.log("[" .. rn.name .. "] failed to read config file")
        return nil
    end

    for line in io.lines(path) do

        local lang_type = string.match(line, "(%w+)%s")
        local lang_name = string.match(line, "%w+%s+(.*)")
        rn.config_dict[lang_name] = lang_type
        rn.name_dict[lang_name] = {}

        -- (The first "language" loaded is the default one)
        if rn.lang_name == nil then
            rn.lang_name = lang_name
            rn.lang_type = lang_type
        end

    end

    file:close()

end

local function read_names(path)

    local name_list = {}

    local file = io.open(path, "r")
    if file then

        for line in io.lines(path) do

            -- Empty lines are ignored
            if string.match(line, "%w") then
                table.insert(name_list, line)
            end
        end

        file:close()

    end

    return name_list

end

---------------------------------------------------------------------------------------------------
-- Load and process files
---------------------------------------------------------------------------------------------------

-- Load the config file
read_config_file(rn.path .. "/names/config.txt");

-- For each 'language' specified by the config file, load lists of names
for lang_name, lang_type in pairs (rn.config_dict) do

    rn.name_dict[lang_name]["first_boy"]
        = read_names(rn.path .. "/names/" .. lang_name .. "/firstboy.txt")
    rn.name_dict[lang_name]["first_girl"]
        = read_names(rn.path .. "/names/" .. lang_name .. "/firstgirl.txt")
    rn.name_dict[lang_name]["last"]
        = read_names(rn.path .. "/names/" .. lang_name .. "/last.txt")
    rn.name_dict[lang_name]["last_girl"]
        = read_names(rn.path .. "/names/" .. lang_name .. "/lastgirl.txt")

end
