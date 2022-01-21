if GlobalsGetValue("SpookyMode_respawn_in_progress", "0") == "1" or GlobalsGetValue("SpookyMode_alligator_beaten", "0") == "1" then

	local entity_id = GetUpdatedEntityID()
	GlobalsSetValue("SpookyMode_alligator_chase_in_progress", "0")
  
	local lua_comps = EntityGetComponent(entity_id, "LuaComponent") or {}
	
	for i, comp in ipairs(lua_comps) do
	
		if ComponentGetValue2(comp, "script_source_file") == "mods/SpookyMode/files/alligator/alligator_temple_attack.lua" or ComponentGetValue2(comp, "script_source_file") == "mods/SpookyMode/files/alligator/alligator_temple_small_attack.lua" then

			EntitySetComponentIsEnabled( entity_id, comp, false )
			
		end
		
	end
	EntityAddComponent( entity_id, "LuaComponent", 
	{ 
		script_source_file="mods/SpookyMode/files/alligator/kill_on_timer.lua",
		execute_every_n_frame = "240"
	} )
end
