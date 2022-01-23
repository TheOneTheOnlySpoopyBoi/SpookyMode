dofile_once("mods/SpookyMode/lib/coroutines.lua")
dofile_once("mods/SpookyMode/files/util.lua")
dofile_once("mods/SpookyMode/files/camera.lua")

set_controls_enabled(false)
sequence(function()
  local world_state = GameGetWorldStateEntity()
  EntityAddComponent(world_state, "LuaComponent", {
	  script_source_file="mods/SpookyMode/files/music_player.lua",
  	  execute_every_n_frame=1,
  	  execute_on_added=1
  })
  
  set_camera_manual(true)
  -- Need to wait a few frames otherwise setting the camera position won't work for some reason...
  wait(20)
  camera_set_position(-1668, -639)
  wait(160)
  camera_pan_to(-1668, -563, 0.5) -- Pan down with the sinking ship
  wait(180)
  camera_pan_to(-1572, -591, 0.5) -- Pan back up to sleeping player
  wait(250)
  camera_pan_to(-1230, -591, 0.4) -- Follow player
end,
function()
  local player = EntityGetWithTag("player_unit")[1]
  local x, y = EntityGetTransform(player)
  local character_data_component = EntityGetFirstComponentIncludingDisabled(player, "CharacterDataComponent")
  local controls_component = EntityGetFirstComponentIncludingDisabled(player, "ControlsComponent")
  local platform_shooter_player_component = EntityGetFirstComponentIncludingDisabled(player, "PlatformShooterPlayerComponent")
  local wand_angle = 15
  local vx, vy = math.cos(math.rad(wand_angle)), math.sin(math.rad(wand_angle))
  -- ComponentSetValue2(platform_shooter_player_component, "camera_max_distance_from_character", vx, vy)
  -- ComponentSetValue2(platform_shooter_player_component, "center_camera_on_this_entity", vx, vy)    <-- set this to false
  -- ComponentSetValue2(platform_shooter_player_component, "move_camera_with_aim", vx, vy)
  -- ComponentSetValue2(platform_shooter_player_component, "mSmoothedCameraPosition", vx, vy)
  -- ComponentSetValue2(platform_shooter_player_component, "mSmoothedAimingVector", vx, vy)
  -- ComponentSetValue2(platform_shooter_player_component, "mCameraDistanceLerped", vx, vy)
  ComponentSetValue2(platform_shooter_player_component, "mItemTemporarilyHidden", 7)
  -- ComponentSetValue2(platform_shooter_player_component, "mDesiredCameraPos", vx, vy)          <---- this ocntrols camera pos
  ComponentSetValue2(controls_component, "mAimingVector", vx, vy)
  ComponentSetValue2(controls_component, "mAimingVectorNormalized", vx, vy)
  ComponentSetValue2(controls_component, "mAimingVectorNonZeroLatest", vx, vy)
  ComponentSetValue2(controls_component, "mMousePosition", 5000, 0)
  ComponentSetValue2(controls_component, "mMousePositionRaw", 5000, 0)
  ComponentSetValue2(controls_component, "mMousePositionRawPrev", 5000, 0)
  ComponentSetValue2(controls_component, "mFlyingTargetY", -9999)

  wait(20)
  local sinking_ship = EntityLoad("mods/SpookyMode/files/sinking_ship.xml", -1690, -560)

  -- ComponentSetValue2(character_data_component, "effect_hit_ground", false)
  local sprite_component_player = find_component_by_values(player, "SpriteComponent", { image_file = "data/enemies_gfx/player.xml" })
  local sprite_component_player_arm_no_item = find_component_by_values(player, "SpriteComponent", { image_file = "data/enemies_gfx/player_arm_no_item.xml" })
  local sprite_components = { sprite_component_player, sprite_component_player_arm_no_item }
  for i, comp in ipairs(sprite_components) do
    ComponentRemoveTag(comp, "character")
    set_sprite_animation(comp, "intro_sleep")
  end
  -- Make ship float
  for i=1, 200 do
    PhysicsApplyForce(sinking_ship, 0, -34)
    wait(0)
  end
  -- Then slowly sink it
  for i=1, 200 do
    PhysicsApplyForce(sinking_ship, 0, -20)
    wait(0)
  end
  wait(300)
  for i, comp in ipairs(sprite_components) do
    set_sprite_animation(comp, "intro_stand_up", "stand")
  end
  wait(300)

  -- Re-add no-item arm otherwise it displays wrong for whatever reason...
  EntityRemoveComponent(player, sprite_component_player_arm_no_item)
  EntityAddComponent2(player, "SpriteComponent", {
    _tags="right_arm_root,character",
    image_file="data/enemies_gfx/player_arm_no_item.xml",
    z_index=0.59
  })

  for i, comp in ipairs(sprite_components) do
    ComponentAddTag(comp, "character")
  end
  for i=1, 800 do
    local vx, vy = ComponentGetValue2(character_data_component, "mVelocity")
    ComponentSetValue2(character_data_component, "mVelocity", 30, vy)
    ComponentSetValue2(character_data_component, "is_on_ground", true)
    wait(0)
  end
  wait(100)
end
).onDone(function()
  set_camera_manual(false)
  set_controls_enabled(true)
	-- local world_state = GameGetWorldStateEntity()
    -- local variable_storage = EntityGetComponent(world_state, "VariableStorageComponent")
	-- for k, v in pairs(variable_storage)do
		-- local name = ComponentGetValue2(v, "name")

		-- if(name == "current_music")then
			-- current_music = ComponentSetValue2(v, "value_string", "	music/smokecave_not_yet_used/02") 
		-- end
	-- end
end)
