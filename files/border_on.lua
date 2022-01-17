local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform(entity_id)

local owner = EntityGetRootEntity(entity_id)
    EntityLoad("data/entities/animals/eel.xml", x+10, y+100)
    EntityLoad("data/entities/animals/eel.xml", x, y+100)
    EntityLoad("data/entities/animals/eel.xml", x+-10, y+100)
