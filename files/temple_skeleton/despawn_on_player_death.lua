if GlobalsGetValue("SpookyMode_respawn_in_progress", "0") == "1" then
  local entity_id = GetUpdatedEntityID()
  print("DEPSANWD!!!!")
  GlobalsSetValue("SpookyMode_temple_skeleton_chase_in_progress", "0")
  EntityKill(entity_id)
end
