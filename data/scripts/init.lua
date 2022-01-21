dofile_once("mods/SpookyMode/lib/coroutines.lua")

function OnWorldPreUpdate()
	wake_up_waiting_threads(1)
end

function OnPlayerDied( player_entity )
	GameDestroyInventoryItems( player_entity )
	GameTriggerGameOver()
end
