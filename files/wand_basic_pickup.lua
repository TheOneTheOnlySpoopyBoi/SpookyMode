dofile_once("mods/SpookyMode/files/util.lua")

function item_pickup(entity_item, entity_pickupper, item_name)
  -- GlobalsSetValue("SpookyMode_portal_unlocked_03", "1")
  -- GamePrintImportant(item_name, "You gained the ")
  local x, y = EntityGetTransform(entity_pickupper)
  LoadGameEffectEntityTo( entity_pickupper, "mods/SpookyMode/files/effect_edit_wands_everywhere.xml" )
  GlobalsSetValue("SpookyMode_respawn_x", x)
  GlobalsSetValue("SpookyMode_respawn_y", y)
end
