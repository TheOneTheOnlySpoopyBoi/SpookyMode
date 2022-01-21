local dialog_system = dofile_once("mods/SpookyMode/lib/DialogSystem/dialog_system.lua")
local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform(entity_id)

function interacting(entity_who_interacted, entity_interacted, interactable_name)
  dialog_system.open_dialog({
    name = "Ancient tablet",
    portrait = "mods/SpookyMode/files/slabs/slab_portrait.png",
    -- typing_sound = "two", -- There are currently 6: default, sans, one, two, three, four and "none" to turn it off, if not specified uses "default"
    text = [[
      {@delay 2}The secrets to manipulating life and the universe itself
      lie in these halls, waiting for those who are worthy.{@pause 30}
      If you want to be given everything, give everything up.
    ]],
  })
end
