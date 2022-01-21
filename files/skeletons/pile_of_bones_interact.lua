local dialog_system = dofile_once("mods/SpookyMode/lib/DialogSystem/dialog_system.lua")
local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform(entity_id)

function interacting(entity_who_interacted, entity_interacted, interactable_name)
  dialog_system.open_dialog({
    name = "Pile of bones",
    portrait = "mods/SpookyMode/files/skull_portrait.png",
    typing_sound = "bones",
    -- There are currently 6: default, sans, one, two, three, four and "none" to turn it off, if not specified uses "default"
    text = [[
      Yoo what?! You have #TWO# arms?{@delay 30}...{@delay 3} Bruh!{@pause 30}
      Back in my day we only had one arm
      when holding no items!
    ]],
  })
end
