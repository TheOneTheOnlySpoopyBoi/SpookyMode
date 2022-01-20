dofile_once("mods/SpookyMode/files/util.lua")

if GlobalsGetValue("AdventureMode_game_complete", "0") == "0" then

	local min_heatwarp_at_x = -1640
	local max_heatwarp_at_x = -1650

	local player = EntityGetWithTag("player_unit")[1]
	if player then
	  local x, y = EntityGetTransform(player)
	  if x < min_heatwarp_at_x then
		local heat_warp_amount = math.min(1, math.max(0, (min_heatwarp_at_x - x) / (min_heatwarp_at_x - max_heatwarp_at_x)))
		local world_state_entity = GameGetWorldStateEntity()
		local world_state_component = EntityGetFirstComponentIncludingDisabled(world_state_entity, "WorldStateComponent")
		ComponentSetValue2(world_state_component, "fog_target_extra", heat_warp_amount)
		ComponentSetValue2(world_state_component, "intro_weather", false)
		if heat_warp_amount == 1 then
		  -- local count = GameGetGameEffectCount(player, "CUSTOM")
		  -- print("count: " .. type(count) .. " - " .. tostring(count))
		  -- if count < 1 then
			if GlobalsGetValue("AdventureMode_respawn_in_progress", "0") == "0" and not get_child_with_name(player, "border") then
			  local effect_entity = EntityLoad("mods/SpookyMode/files/border_effect.xml", x, y)
			  EntityAddChild(player, effect_entity)
			end
			-- local effect_component_id, effect_entity_id = LoadGameEffectEntityTo(player, "mods/SpookyMode/files/border_effect.xml")
		  -- end
		  -- local effect_component_id, effect_entity_id = GetGameEffectLoadTo(player, "SPOOKYMODE_BORDER", false)
		end
	  elseif GameGetFrameNum() % 60 == 0 then -- Only check once per second
		local border = get_child_with_name(player, "border")
		if border then
		  EntityKill(border)
		end
	  end
	end

end