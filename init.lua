ModLuaFileAppend("data/scripts/status_effects/status_list.lua", "mods/SpookyMode/files/status_list_append.lua")
ModMaterialsFileAdd("mods/SpookyMode/files/materials.xml")
ModRegisterAudioEventMappings("mods/SpookyMode/files/audio/GUIDs.txt")
dofile_once("mods/SpookyMode/lib/DialogSystem/init.lua")("mods/SpookyMode/lib/DialogSystem", {
  disable_controls = true,
  sounds = {
    bones = { bank = "mods/SpookyMode/files/audio/SpookyMode.bank", event = "bones_rattle" },
    stone = { bank = "mods/SpookyMode/files/audio/SpookyMode.bank", event = "golem_speak" },
  }
})
dofile_once("mods/SpookyMode/lib/coroutines.lua")
dofile_once("data/scripts/lib/utilities.lua")
dofile_once("mods/SpookyMode/files/util.lua")
local nxml = dofile_once("mods/SpookyMode/lib/nxml.lua")

-- Overwrite death sound to disable it
GamePlaySound("mods/SpookyMode/files/audio/death.bank", "dummy_sound", 0, 0)

-- Add custom materials
ModMaterialsFileAdd("mods/SpookyMode/files/materials/materials.xml")

local content = ModTextFileGetContent("data/biome/_biomes_all.xml")
local xml = nxml.parse(content)
xml:add_children(nxml.parse_many([[
<Biome
  biome_filename="mods/SpookyMode/files/biomes/hills.xml"
  height_index="0"
  color="ffc1ab5b">
</Biome>
<Biome
  biome_filename="mods/SpookyMode/files/biomes/start_hills.xml"
  height_index="0"
  color="ff34ca17">
</Biome>
<Biome
  biome_filename="mods/SpookyMode/files/biomes/ground.xml"
  height_index="0"
  color="ff877531">
</Biome>
<Biome
  biome_filename="mods/SpookyMode/files/biomes/dark.xml"
  height_index="0"
  color="ff282620">
</Biome>
<Biome
  biome_filename="mods/SpookyMode/files/biomes/pyramid.xml"
  height_index="0"
  color="ffec2b42">
</Biome>
<Biome
  biome_filename="mods/SpookyMode/files/biomes/golem_room.xml"
  height_index="0"
  color="ff986b4f">
</Biome>
]]))
ModTextFileSetContent("data/biome/_biomes_all.xml", tostring(xml))

-- Generate _pixel_scenes.xml from chunks defined in another file
-- Name the chunks according to their position on the map, like:
-- 0_0.png to place it at 0, 0
-- 1_0.png to place it at 512, 0
-- 1_1.png to place it at 512, 512
-- and so forth, then add those numbers (without png) to the chunks_to_load.lua
local chunks = dofile_once("mods/SpookyMode/files/chunks_to_load.lua")

local y_offset = -2 -- Move pixel scenes 2 chunks up
local str = "<PixelScenes><mBufferedPixelScenes>"
local pixel_scenes_root_folder = "mods/SpookyMode/files/pixel_scenes"
for i, chunk in ipairs(chunks) do
  local has_background = chunk[3]
  local has_visual = chunk[4]
  local material_filename = ("%s/%d_%d.png"):format(pixel_scenes_root_folder, chunk[1], chunk[2])
  local background_filename = has_background and ("%s/%d_%d_background.png"):format(pixel_scenes_root_folder, chunk[1], chunk[2]) or ""
  local visual_filename = has_visual and ("%s/%d_%d_visual.png"):format(pixel_scenes_root_folder, chunk[1], chunk[2]) or ""
  str = str .. ([[<PixelScene DEBUG_RELOAD_ME="0" background_filename="%s" clean_area_before="0" colors_filename="%s"
    material_filename="%s" pos_x="%d" pos_y="%d" skip_biome_checks="1" skip_edge_textures="0" />
  ]]):format(background_filename, visual_filename, material_filename,  chunk[1] * 512, (chunk[2]+y_offset) * 512)
end
str = str .. "</mBufferedPixelScenes></PixelScenes>"
print(str)
ModTextFileSetContent("data/biome/_pixel_scenes.xml", str)

local starting_position = 1
local starting_positions = {
  { x = -1542, y = -600 }, -- 1 Intro
}

ModTextFileSetContent("mods/SpookyMode/_virtual/magic_numbers.xml", string.format([[
<MagicNumbers
  DESIGN_PLAYER_START_POS_X="%d"
  DESIGN_PLAYER_START_POS_Y="%d"
  ></MagicNumbers>
]], starting_positions[starting_position].x, starting_positions[starting_position].y))

  -- DEBUG_MATERIAL_AREA_CHECKER="1"
  -- DEBUG_COLLISION_TRIGGERS="1"
ModMagicNumbersFileAdd("mods/SpookyMode/_virtual/magic_numbers.xml")

-- ModLuaFileAppend("data/scripts/gun/gun_actions.lua", "mods/SpookyMode/files/gun_actions_append.lua")

function OnPlayerSpawned(player)
  local x, y = EntityGetTransform(player)

  GlobalsSetValue("SpookyMode_DEBUG_starting_position", starting_position)

  if GlobalsGetValue("SpookyMode_player_initialized", "0") == "0" then
    GlobalsSetValue("SpookyMode_player_initialized", "1")
    local world_state_entity = GameGetWorldStateEntity()
    if starting_position == 1 then
      EntityLoad("mods/SpookyMode/files/intro.xml")
    else
      GlobalsSetValue("SpookyMode_respawn_x", starting_positions[starting_position].x)
      GlobalsSetValue("SpookyMode_respawn_y", starting_positions[starting_position].y)
      EntityAddComponent(world_state_entity, "LuaComponent", {
        script_source_file="mods/SpookyMode/files/music_player.lua",
        execute_every_n_frame=1,
        execute_on_added=1
      })
    end
    local world_state_component = EntityGetFirstComponentIncludingDisabled(world_state_entity, "WorldStateComponent")
    ComponentSetValue2(world_state_component, "intro_weather", true)
    ComponentSetValue2(world_state_component, "time", 1)
    ComponentSetValue2(world_state_component, "fog", 1)
    ComponentSetValue2(world_state_component, "fog_target", 0)
    ComponentSetValue2(world_state_component, "sky_sunset_alpha_target", 0.5)
    ComponentSetValue2(world_state_component, "gradient_sky_alpha_target", 0.5)

    -- Remove crown etc
    local sprite_tags = {
      "player_hat2",
      "player_hat2_shadow",
      "player_hat",
      "player_amulet_gem",
      "player_amulet",
      "lukki_enable",
    }
    for i, tag in ipairs(sprite_tags) do
      local comp = EntityGetFirstComponentIncludingDisabled(player, "SpriteComponent", tag)
      EntityRemoveComponent(player, comp)
    end

    -- Disable jetpack
    -- if starting_position > 1 then
    --   entity_set_component_value(player, "CharacterDataComponent", "fly_time_max", 1)
    -- else
    --   entity_set_component_value(player, "CharacterDataComponent", "fly_time_max", 0)
    -- end
    entity_set_component_value(player, "CharacterDataComponent", "fly_recharge_spd", 0.2)
    entity_set_component_value(player, "CharacterDataComponent", "fly_recharge_spd_ground", 1.0)

    -- Make immortal
    entity_set_component_value(player, "DamageModelComponent", "wait_for_kill_flag_on_death", true)
    EntityAddComponent2(player, "LuaComponent", {
      script_source_file = "mods/SpookyMode/files/player_lethal_damage_watcher.lua",
      script_damage_received = "mods/SpookyMode/files/player_lethal_damage_watcher.lua",
      execute_every_n_frame=-1,
      execute_on_added=true,
      enable_coroutines=true,
    })

    -- Prepare Inventory
    local inventory_quick = EntityGetWithName("inventory_quick")
    local items = EntityGetAllChildren(inventory_quick) or {}
    for i, item in ipairs(items) do
      EntityKill(item)
    end
    local book_explan = EntityLoad("mods/SpookyMode/files/entities/items/books/book_explan.xml")
    EntityAddChild(inventory_quick, book_explan)
    -- GamePickUpInventoryItem(player, book_explan, false)

    -- Add no-item-arm
    EntityAddComponent2(player, "SpriteComponent", {
      _tags="right_arm_root,character",
      image_file="data/enemies_gfx/player_arm_no_item.xml",
      z_index=0.59
    })
  end
end

function handle_arm_sprite()
  local respawn_in_progress = GlobalsGetValue("SpookyMode_respawn_in_progress", "0") == "1"
  local arm_r_entity = EntityGetWithName("arm_r")
  if not respawn_in_progress and arm_r_entity > 0 then
    local inventory_quick = EntityGetWithName("inventory_quick")
    local items = EntityGetAllChildren(inventory_quick)
    local sprite_component = EntityGetFirstComponentIncludingDisabled(arm_r_entity, "SpriteComponent")
    local active_item = get_active_item()
    -- Check if active item still exists, if EntityGetTransform returns nil then it doesn't
    local x = EntityGetTransform(active_item)
    local active_item_exists = x ~= nil
    local show_arm = not items or not active_item_exists
    local player = EntityGetWithTag("player_unit")[1]
    local no_item_arm_sprite_component = EntityGetFirstComponentIncludingDisabled(player, "SpriteComponent", "right_arm_root")
    ComponentSetValue2(no_item_arm_sprite_component, "alpha", show_arm and 1 or 0)
    EntitySetComponentIsEnabled(arm_r_entity, sprite_component, not show_arm)
  end
end

local debug_menu_open = true

function OnWorldPreUpdate()
  dofile("mods/SpookyMode/files/border_watcher.lua")
  local id = 2
  local function new_id()
    id = id + 1
    return id
  end
  gui = gui or GuiCreate()
  GuiStartFrame(gui)

 if GuiButton(gui, new_id(), 2, 200, ":)") then
   debug_menu_open = not debug_menu_open
 end

  if debug_menu_open then
    GuiLayoutBeginVertical(gui, 1, 20)
    local inventory_quick = EntityGetWithName("inventory_quick")
    local player = EntityGetWithTag("player_unit")[1]
    if GuiButton(gui, new_id(), 0, 0, "Give torch") then
      local item = EntityLoad("mods/SpookyMode/files/torch.xml")
      GamePickUpInventoryItem(player, item, false)
    end
    if GuiButton(gui, new_id(), 0, 0, "Give rock") then
      local item = EntityLoad("data/entities/items/pickup/physics_gold_orb_greed.xml")
      GamePickUpInventoryItem(player, item, false)
    end
    if GuiButton(gui, new_id(), 0, 0, "Give gem") then
      local item = EntityLoad("mods/SpookyMode/files/gem_item.xml")
      GamePickUpInventoryItem(player, item, false)
    end
    if GuiButton(gui, new_id(), 0, 0, "Die") then
      local player = EntityGetWithTag("player_unit")[1]
      EntityInflictDamage(player, 999, "DAMAGE_MELEE", "", "NORMAL", 0, 0)
    end
    if GuiButton(gui, new_id(), 0, 0, "Ending teleport") then
      dofile_once("mods/SpookyMode/files/ending_portal.lua")
      local player = EntityGetWithTag("player_unit")[1]
      if player then
        do_teleport(player)
      end
    end
    if GuiButton(gui, new_id(), 0, 0, "Reload world") then
      BiomeMapLoad_KeepPlayer("data/biome_impl/biome_map.png")
    end
    if GuiButton(gui, new_id(), 0, 0, "Print camera position") then
      local cx, cy = GameGetCameraPos()
      print(("Camera is at (%d, %d)"):format(cx, cy))
    end
    if GuiButton(gui, new_id(), 0, 0, "Bones rattling") then
      GamePlaySound("mods/SpookyMode/files/audio/SpookyMode.bank", "bones_rattle", 0, 0)
    end
    if GuiButton(gui, new_id(), 0, 0, "Rattle me bones!") then
      GamePlaySound("mods/SpookyMode/files/audio/SpookyMode.bank", "rattle_me_bones", 0, 0)
    end
    if GuiButton(gui, new_id(), 0, 0, "Swan!!") then
      local player = EntityGetWithTag("player_unit")[1]
      if player then
        local x, y = EntityGetTransform(player)
    GamePlaySound("mods/SpookyMode/files/audio/SpookyMode.bank", "swan_roar_wip", x+-70, y+100)
    EntityLoad("mods/SpookyMode/files/lake_swan/lake_swan.xml", x, y+600)
      end
    end
    if GuiButton(gui, new_id(), 0, 0, "Levi") then
      local player = EntityGetWithTag("player_unit")[1]
      if player then
        local x, y = EntityGetTransform(player)
    EntityLoad("data/entities/animals/boss_fish/fish_giga.xml", x, y+-100)
      end
    end
    if not old_pos then
      if GuiButton(gui, new_id(), 0, 0, "Teleport far away") then
        local player = EntityGetWithTag("player_unit")[1]
        local x, y = EntityGetTransform(player)

        EntitySetTransform(player, x - 100000, y - 100000)
        old_pos = { x = x, y = y }
      end
    else
      if GuiButton(gui, new_id(), 0, 0, "Teleport back") then
        local player = EntityGetWithTag("player_unit")[1]
        EntitySetTransform(player, old_pos.x, old_pos.y)
        old_pos = nil
      end
    end
    GuiLayoutEnd(gui)
  end

  -- Make sure arm doesn't hang weirdly without items
  handle_arm_sprite()
end
