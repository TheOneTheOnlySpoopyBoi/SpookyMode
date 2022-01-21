dofile_once("mods/SpookyMode/files/util.lua")

function item_pickup(entity_item, entity_pickupper, item_name)
  GlobalsSetValue("SpookyMode_rising_lava_beaten", "1")
end
