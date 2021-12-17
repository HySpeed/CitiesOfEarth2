-- coe_gui.lua

function ProcessGuiEvent(event)
  if not event.element then return end

  local player = game.players[event.player_index]
  local element = event.element

  if element.name == "coe_button_show_targets" then
    ShowTargetChoices(event, player)
  elseif element.name == "coe_button_city_go" then
    TPtoCity(player, element.parent)
    element.parent.parent.parent.destroy()
  elseif element.name == "coe_button_player_go" then
    TPtoPlayer(player, element.parent)
    element.parent.parent.parent.destroy()
  elseif element.name == "coe_button_cancel" then
    element.parent.parent.destroy()
  elseif element.name == "coe_button_info_close" then
    element.parent.destroy()
  end
end -- ProcessGuiEvent


function CreateButton_ShowTargets(player)
  local flow = MOD_GUI.get_button_flow(player)
  if not flow.coe_button_show_targets then
    local button = flow.add({
      type = "sprite-button",
      name = "coe_button_show_targets",
      style = MOD_GUI.button_style,
      sprite = "show_targets_list",
      tooltip = {"coe-tooltip.button-show-targets"}
    })
  end
end -- CreateButton_ShowTargets


function TPtoCity(player, frame)
  local ui_city_list = frame.coe_cities_dropdown
  local dest_name = ui_city_list.get_item(ui_city_list.selected_index)
  local destination = CalcTPOffset(dest_name)

  PerformTeleport(player, destination, dest_name)
end -- TPtoCity


function TPtoPlayer(player, frame)
  local ui_player_list = frame.coe_players_dropdown
  local target_player_name = ui_player_list.get_item(ui_player_list.selected_index)
  local target_player = GetPlayerByName(target_player_name)
  local destination = target_player.position

  PerformTeleport(player, destination, target_player_name)
end -- TPtoPlayer


-- teleports player after checking if target is safe - loops until success / limit
function PerformTeleport(player, destination, dest_name) 

  CheckAndCreateChunk(destination)

  -- loop until valid teleport destination can be found
  local valid_dest = false
  local count = 0
  while valid_dest == false and count <= 100 do
    if global.coe.surface.can_place_entity({name="character", position = destination}) then
      valid_dest = true
    else
      destination.x = destination.x + GetRandomAmount(WOBBLE/2)
      destination.y = destination.y + GetRandomAmount(WOBBLE/2)
    end
    count = count + 1 -- limits to prevent infinate loop
  end

  local result = false
  if valid_dest then
    game.print({"", {"coe.teleported"}, player.name, {"coe.to"}, dest_name, "  (", destination.x, ",", destination.y, ") "})
    result = player.teleport(destination, global.coe.surface)
  end
  
  if result == false then
    player.print({"", {"coe.unable-to-teleport"}, player.name, {"coe.to"}, dest_name, "  (", destination.x, ",", destination.y, ") ", {"coe.count"}, count})
  end
end -- PerformTeleport


function CheckAndCreateChunk(position)
  local surface = global.coe.surface
  if surface.is_chunk_generated(position) then return end
  surface.request_to_generate_chunks(position, 1)
  surface.force_generate_chunk_requests()
end -- CheckAndCreateChunk


function ShowTargetChoices(event, player)
  local gui = player.gui.center
  if gui.coe_choose_target == nil then
    BuildTargetListFrame(gui, player)
  end -- if
end -- ShowTargetChoices


-- given the destination, global spawn - lookup the x&y of each, calculate the difference
function CalcTPOffset(target_city_name)
  local target_city_loc = Cities[target_city_name][global.coe.map_index]
  local spawn_city_loc = Cities[global.coe.spawn_city_name][global.coe.map_index]
  local dest_offsets = {
    x = -(spawn_city_loc.x - target_city_loc.x),
    y = -(spawn_city_loc.y - target_city_loc.y)
  }

  -- Adjust destination for map-scale factor and detail level
  dest_offsets = {
      x = dest_offsets.x * global.coe.size_multipler,
      y = dest_offsets.y * global.coe.size_multipler
  }

  return dest_offsets
end -- CalcTPOffset


function BuildTargetListFrame(gui, player)
  local frame = gui.add({
    type = "frame",
    name = "coe_choose_target",
    style = "frame",
    direction = "vertical",
    caption = {"coe.title-choose-target"}
  })

  local city_and_player_flow = frame.add({
    type = "flow",
    name = "coe_city_and_player_flow",
    direction = "horizontal"
  })

  local city_flow = city_and_player_flow.add({
    type = "flow",
    name = "coe_city_flow",
    direction = "vertical"
  })

  city_flow.add({
    type = "drop-down",
    name = "coe_cities_dropdown",
    items = global.coe.gui_city_names,
    selected_index = 1
  })

  city_flow.add({
    type = "button",
    name = "coe_button_city_go",
    caption = {"coe.button-city-go"}
  })
  -- only enable if enabled in settings
  if settings.global["coe2_tp-to-city"].value == true then
    city_flow["coe_button_city_go"].enabled = true
    city_flow["coe_button_city_go"].caption = {"coe.button-city-go-enabled"}
  else
    city_flow["coe_button_city_go"].enabled = false
    city_flow["coe_button_city_go"].caption = {"coe.button-city-go-disabled"}
  end


  local player_flow = city_and_player_flow.add({
    type = "flow",
    name = "coe_player_flow",
    direction = "vertical"
  })

  local player_names = BuildPlayerNameList()
  player_flow.add({
    type = "drop-down",
    name = "coe_players_dropdown",
    items = player_names,
    selected_index = 1
  })

  player_flow.add({
    type = "button",
    name = "coe_button_player_go"
  })
  -- only enable if enabled in settings
  if settings.global["coe2_tp-to-player"].value == true then
    player_flow["coe_button_player_go"].enabled = true
    player_flow["coe_button_player_go"].caption = {"coe.button-player-go-enabled"}
  else
    player_flow["coe_button_player_go"].enabled = false
    player_flow["coe_button_player_go"].caption = {"coe.button-player-go-disabled"}
  end

  local controls_flow = frame.add({
    type = "flow",
    name = "coe_controls_flow",
    direction = "horizontal"
  })

  controls_flow.add({
    type = "button",
    name = "coe_button_cancel",
    caption = {"coe.button-cancel"}
  })

  frame.add({
    type = "label",
    name = "coe_note_delay_1",
    caption = {"coe.note-delay-1"}
  })

  frame.add({
    type = "label",
    name = "coe_note_delay_2",
    caption = {"coe.note-delay-2"}
  })

end -- BuildTargetListFrame
