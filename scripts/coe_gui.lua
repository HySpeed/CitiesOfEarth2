--coe_gui.lua

function OnGuiClick(event)
  local player  = game.players[event.player_index]
  local element = event.element

  if element.name == "coe_button_show_targets" then
    ShowTargetChoices(event, player)
  elseif element.name == "coe_button_city_go" then
    SelectCity(player, element.parent)
    element.parent.parent.parent.destroy()
  elseif element.name == "coe_button_player_go" then
    SelectPlayer(player, element.parent)
    element.parent.parent.parent.destroy()
  elseif element.name == "coe_button_cancel" then
    element.parent.parent.destroy()
  elseif element.name == "coe_button_info_close" then
    element.parent.destroy()
  end
end -- OnGuiClick


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


function SelectCity(player, frame)
  local ui_city_list = frame.coe_cities_dropdown
  local chosen_city_name = ui_city_list.get_item(ui_city_list.selected_index)

  local destination = CalcTPOffset(chosen_city_name)

  game.print({"", player.name, ": ", chosen_city_name, "(", destination.x, ",", destination.y, ")"})

  player.teleport({destination.x + GetRandomAmount(WOBBLE), destination.y + GetRandomAmount(WOBBLE)}, global.surface)
end -- SelectCity


-- given the destination, global spawn - lookup the x&y of each, calculate the difference
function CalcTPOffset(chosen_city_name)
  local chosen_city_loc = Cities[chosen_city_name][global.coe.map_index]
  local spawn_city_loc = Cities[global.coe.spawn_city_name][global.coe.map_index]

  local dest_offsets = {
    x = -(spawn_city_loc.x - chosen_city_loc.x),
    y = -(spawn_city_loc.y - chosen_city_loc.y)
  }

  -- Adjust destination for map-scale factor and detail level
  dest_offsets = {
      x = dest_offsets.x * global.coe.size_multipler,
      y = dest_offsets.y * global.coe.size_multipler
  }

  log("~d_o: " .. dest_offsets.x .. "," .. dest_offsets.y)

  return dest_offsets
end -- CalcTPOffset


function SelectPlayer(player, frame)
  local ui_player_list = frame.coe_players_dropdown
  local target_player_name = ui_player_list.get_item(ui_player_list.selected_index)
  local target_player = GetPlayerByName(target_player_name)
  local destination = target_player.position

  game.print({"", player.name, " -> ", target_player.name, "(", destination.x, ",", destination.y, ")"})
  player.teleport({destination.x + GetRandomAmount(WOBBLE), destination.y + GetRandomAmount(WOBBLE)}, global.surface)
end -- SelectPlayer


function ShowTargetChoices(event, player)
  local gui = player.gui.center
  if gui.coe_choose_target == nil then
-- (not needed?)    local spawn_configured = IsValidSpawnSettings() -- error is displayed if setup is wrong
    local spawn_configured = true
    BuildTargetListFrame(gui, player, spawn_configured)
  end -- if
end -- ShowTargetChoices


function BuildTargetListFrame(gui, player, spawn_configured)
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

  -- local city_names = BuildCityNameList(global.coe.cities)
  local city_names = BuildCityNameList()
  city_flow.add({
    type = "drop-down",
    name = "coe_cities_dropdown",
    items = city_names,
    selected_index = 1
  })

  city_flow.add({
    type = "button",
    name = "coe_button_city_go",
    caption = {"coe.button-city-go"}
  })

  local player_flow = city_and_player_flow.add({
    type = "flow",
    name = "coe_player_flow",
    direction = "vertical"
  })

  -- only show player list if not in 'lobby'
  if player.surface == global.surface then
    local player_names = BuildPlayerNameList()
    player_flow.add({
      type = "drop-down",
      name = "coe_players_dropdown",
      items = player_names,
      selected_index = 1 -- 0?
    })

    player_flow.add({
      type = "button",
      name = "coe_button_player_go",
      caption = {"coe.button-player-go"}
    })
  end -- if

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

