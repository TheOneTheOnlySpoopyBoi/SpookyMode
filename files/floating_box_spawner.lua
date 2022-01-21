function collision_trigger(colliding_entity_id)
  local chase_in_progress = GlobalsGetValue("SpookyMode_poison_challenge_in_progress", "0") == "1"
  local temple_skeleton_beaten = GlobalsGetValue("SpookyMode_poison_challenge_beaten", "0") == "1"
  if not (chase_in_progress or temple_skeleton_beaten) then
	
	local entity_id = GetUpdatedEntityID()
	local x, y = EntityGetTransform( entity_id )
	GlobalsSetValue("SpookyMode_poison_challenge_in_progress", "1")
	EntityLoad("mods/SpookyMode/files/buoyant_box.xml", x + 230, y )
  end
end
