function item_pickup(entity_item, entity_pickupper, item_name)
  GlobalsSetValue("SpookyMode_red_gem_picked", "1")
  EntityKill(entity_item)
  local x, y = EntityGetTransform(entity_pickupper)
  local gem = EntityLoad("mods/SpookyMode/files/gem_item.xml", x, y)
  GamePickUpInventoryItem(entity_pickupper, gem, false)
end
