-- coe_gui.lua

require("scripts/coe_actions")
require("scripts/coe_utils")

--==============================================================================

function ProcessGuiEvent(event)
  if not event.element then return end

  local player = game.players[event.player_index]
  local element = event.element

  if element.name == "coe_button_show_targets" then
    ShowTargetChoices(event, player)
  elseif element.name == "coe_button_city_go" then
    TPtoCity(player, element.parent, nil)
    element.parent.parent.parent.destroy()
  elseif element.name == "coe_button_player_go" then
    TeleportToPlayer(player, element.parent)
    element.parent.parent.parent.destroy()
  elseif element.name == "coe_button_cancel" then
    element.parent.parent.destroy()
  elseif element.name == "coe_button_info_close" then
    element.parent.destroy()
  end
end -- ProcessGuiEvent

-------------------------------------------------------------------------------

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

-------------------------------------------------------------------------------

function ShowTargetChoices(event, player)
  local gui = player.gui.center
  if gui.coe_choose_target == nil then
    BuildTargetListFrame(gui, player)
  end -- if
end -- ShowTargetChoices

-------------------------------------------------------------------------------

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

  -- local gui_city_names = global.coe.gui_city_names
  -- table.insert(gui_city_names, 1, global.coe.select_target_choice)
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
  if settings.global["coe2_tp-to-city"].value == true then -- and city_flow["coe_cities_dropdown"].selected_index ~= 1 then
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
    name = "coe_text-note_delay_1",
    caption = {"coe.text-note-delay-1"}
  })

  frame.add({
    type = "label",
    name = "coe_text-note_delay_2",
    caption = {"coe.text-note-delay-2"}
  })

end -- BuildTargetListFrame
