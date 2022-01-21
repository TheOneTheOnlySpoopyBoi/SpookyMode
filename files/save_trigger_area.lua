function collision_trigger(colliding_entity_id)
  local entity_id = GetUpdatedEntityID()
  local x, y = EntityGetTransform(entity_id)

  GlobalsSetValue("SpookyMode_respawn_x", x)
  GlobalsSetValue("SpookyMode_respawn_y", y)
end
