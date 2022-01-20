local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform(entity_id)

local owner = EntityGetRootEntity(entity_id)
    GamePlaySound("mods/SpookyMode/files/audio/SpookyMode.bank", "swan_roar_wip", x+-70, y+100)
    EntityLoad("mods/SpookyMode/files/lake_swan/lake_swan.xml", x+-70, y+300)
