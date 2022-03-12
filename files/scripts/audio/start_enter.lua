function collision_trigger()
	local entity_id    = GetUpdatedEntityID()
	local pos_x, pos_y = EntityGetTransform( entity_id )

	GameTriggerMusicEvent( "music/smokecave/03", true, pos_x, pos_y )
end