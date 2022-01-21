function collision_trigger(colliding_entity_id)
  GlobalsSetValue("SpookyMode_alligator_beaten", "1")
  
  local entity_id = GetUpdatedEntityID()
  local x, y = EntityGetTransform( entity_id )
  
  GlobalsSetValue("SpookyMode_respawn_x", x)
  GlobalsSetValue("SpookyMode_respawn_y", y)
  
  EntityLoad("data/entities/misc/loose_chunks_workshop.xml", x - 369, y + 127)

  EntityLoad("mods/SpookyMode/files/cutscene.xml", x, y)
end
