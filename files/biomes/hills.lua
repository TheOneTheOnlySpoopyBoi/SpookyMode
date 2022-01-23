-- default biome functions that get called if we can't find a a specific biome that works for us
CHEST_LEVEL = 0
dofile_once("data/scripts/director_helpers.lua")
dofile_once("data/scripts/biome_scripts.lua")

RegisterSpawnFunction( 0xffc626dc, "spawn_tree")
RegisterSpawnFunction( 0xff33934c, "spawn_shopitem" )
RegisterSpawnFunction( 0xffd0d0b4, "spawn_treasure" )
RegisterSpawnFunction( 0xff41704d, "spawn_specialshop" )
RegisterSpawnFunction( 0xffffeedd, "init" )
RegisterSpawnFunction( 0xff235a15, "spawn_music_machine" )
RegisterSpawnFunction( 0xffef0000, "spawn_basic_enemies" )
RegisterSpawnFunction( 0xffd7a643, "spawn_rocks" )

------------ BASIC ENEMIES ----------------------------------------------------

g_basic_enemies =
{
	total_prob = 0,
	-- this is air, so nothing spawns at 0.6
	{
		prob   		= 0.0,
		min_count	= 0,
		max_count	= 0,    
		entity 	= ""
	},
	-- add skullflys after this step
	{
		prob   		= 0.3,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "mods/SpookyMode/files/entities/animals/zombie_weak.xml"
	},
	{
		prob   		= 0.01,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/rat.xml"
	},
}


------------ BIG ENEMIES ------------------------------------------------------

------------ ITEMS ------------------------------------------------------------

g_items =
{
	total_prob = 0,
	-- this is air, so nothing spawns at 0.6
	{
		prob   		= 1.2,
		min_count	= 0,
		max_count	= 0,    
		entity 	= ""
	},
	-- add skullflys after this step
}

g_unique_enemy =
{
	total_prob = 0,
	-- this is air, so nothing spawns at 0.6
	{
		prob   		= 0.0,
		min_count	= 0,
		max_count	= 0,    
		entity 	= ""
	},
	-- add skullflys after this step
	{
		prob   		= 0.5,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/zombie.xml"
	},
}

g_ghostlamp =
{
	total_prob = 0,
	-- add skullflys after this step
	{
		prob   		= 1.0,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/props/physics/chain_torch_ghostly.xml"
	},
}

g_stash =
{
	total_prob = 0,
	{
		prob   		= 0.4,
		min_count	= 1,
		max_count	= 1, 
		entity 	= "",
	},
	{
		prob   		= 0.6,
		min_count	= 1,
		max_count	= 1, 
		entity 	= "data/entities/items/pickup/heart.xml",
	},
}


g_candles =
{
	total_prob = 0,
	{
		prob   		= 0.33,
		min_count	= 1,
		max_count	= 1, 
		entity 	= "data/entities/props/physics_candle_1.xml"
	},
	{
		prob   		= 0.33,
		min_count	= 1,
		max_count	= 1, 
		entity 	= "data/entities/props/physics_candle_2.xml"
	},
	{
		prob   		= 0.33,
		min_count	= 1,
		max_count	= 1, 
		entity 	= "data/entities/props/physics_candle_3.xml"
	},
}

g_lamp =
{
	total_prob = 0,
	-- add skullflys after this step
	{
		prob   		= 0.7,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/props/physics_mining_lamp.xml"
	}
}

g_pumpkins =
{
	total_prob = 0,
	{
		prob   		= 5.0,
		min_count	= 1,
		max_count	= 1,    
		entity 	= ""
	},
	{
		prob   		= 1.0,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/props/pumpkin_01.xml"
	},
	{
		prob   		= 1.0,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/props/pumpkin_02.xml"
	},
	{
		prob   		= 1.0,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/props/pumpkin_03.xml"
	},
	{
		prob   		= 1.0,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/props/pumpkin_04.xml"
	},
	{
		prob   		= 1.0,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/props/pumpkin_05.xml"
	}
}

g_rocks =
{
	total_prob = 0,
	{
		prob   		= 0.5,
		min_count	= 1,
		max_count	= 1,    
		offset_y 	= 0,
		entity 	= "data/entities/props/physics_stone_01.xml"
	},
	{
		prob   		= 0.5,
		min_count	= 1,
		max_count	= 1,    
		offset_y 	= 0,
		entity 	= "data/entities/props/physics_stone_02.xml"
	},
	{
		prob   		= 0.5,
		min_count	= 1,
		max_count	= 1,    
		offset_y 	= 0,
		entity 	= "data/entities/props/physics_stone_03.xml"
	},
	{
		prob   		= 0.5,
		min_count	= 1,
		max_count	= 1,    
		offset_y 	= 0,
		entity 	= "data/entities/props/physics_stone_04.xml"
	},
}

------------ MISC --------------------------------------

-- actual functions that get called from the wang generator

function init(x, y, w, h)
	parallel_check( x, y )
	
	-- halloween
	local year, month, day = GameGetDateAndTimeLocal()		
	if y > -1000 and y < 0 and month == 10 and day == 31 then
		-- limit spawn inside this biome pixel
		w = w * 0.5
		x = x + w
		spawn(g_pumpkins, x,y,w)
		spawn(g_pumpkins, x+1,y,w)
		spawn(g_pumpkins, x+2,y,w)
		spawn(g_pumpkins, x+3,y,w)
		spawn(g_pumpkins, x+4,y,w)
		spawn(g_pumpkins, x+5,y,w)
	end
end

function spawn_basic_enemies(x, y)
	spawn(g_basic_enemies,x,y)
end

function spawn_rocks(x, y)
	spawn(g_rocks,x,y)
end

function spawn_big_enemies(x, y)
	-- print("spawn_small_enemies")
	if( y < 0 ) then return 0 end
	-- spawn(g_big_enemies,x,y)
end

function spawn_items(x, y)
	return
end

function spawn_unique_enemy(x, y)
	spawn(g_unique_enemy,x,y)
end

function spawn_lamp(x, y)
	spawn(g_lamp,x,y+6,0,0)
end

function spawn_props(x, y)
	return
end

function spawn_potions( x, y ) end

function spawn_shopitem( x, y )
	if ( y > -3000 ) and ( y < 1000 ) then
		generate_shop_item( x, y, false, 0 )
	else
		SetRandomSeed( x, y )
		
		if ( Random( 1, 30 ) == 1 ) then
			generate_shop_item( x, y, false, 10 )
		end
	end
end

function spawn_specialshop( x, y )
	if ( y > -3000 ) and ( y < 1000 ) then
		generate_shop_item( x, y, false, 0 )
	else
		generate_shop_item( x, y, false, 10 )
	end
end

function spawn_treasure( x, y )
	EntityLoad( "data/entities/misc/towercheck.xml", x, y )
end

function spawn_music_machine( x, y )
	EntityLoad( "data/entities/props/music_machines/music_machine_02.xml", x, y )
end

function spawn_tree(x, y)
  EntityLoad("mods/SpookyMode/files/props/tree1.xml", x, y )
end
