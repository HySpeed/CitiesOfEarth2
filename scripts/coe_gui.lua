-- coe_gui.lua

local mod_gui = require("mod-gui")
require("scripts/coe_actions")
require("scripts/coe_utils")

--==============================================================================

function ProcessGuiEvent( event )
-- if dialog is open, close it.  If closed, open it
  local player = game.players[event.player_index]

  if global.coe and event.element.name == "coe_button_show_targets" then
    if global.coe[event.player_index].teleport_control_visible then
      CloseUI( player )
    else
      OpenUI( player )
    end
  elseif global.coe and event.element.name == "coe_teleport_button" then
    -- get selection lookup city from name
    local ui_city_list = event.element.parent.coe_city_list_dropdown
    local selected_index = ui_city_list.selected_index
    local city_name = ui_city_list.get_item( selected_index )
    PerformTeleport( event.player_index, city_name )
    CloseUI( player )
  end
end -- ProcessGuiEvent

-------------------------------------------------------------------------------

function SetupPlayerUI( player_index )
  local player = game.players[player_index]

  -- remove any old ui frame component
  -- ? is this needed?
  -- if player.gui["left"][player_index .. "_coe_control_frame"] then
  --   player.gui["left"][player_index .. "_coe_control_frame"].destroy()
  -- end

  -- setup new button, start by removing old button if it exists
  if mod_gui.get_button_flow( player ).coe_button_show_targets then
    mod_gui.get_button_flow( player ).coe_button_show_targets.destroy()
  end

  mod_gui.get_button_flow( player ).add {
    name    = "coe_button_show_targets",
    sprite  = "show_targets_list",
    style   = "mod_gui_button",
    tooltip = {"coe-tooltip.button-show-targets"},
    type    = "sprite-button"
  }
end -- SetupPlayerUI

-------------------------------------------------------------------------------

function OpenUI( player )
  local gui = player.gui.left
  local destinations_frame =
      gui.add {
      type = "frame",
      name = "coe_destinations_frame",
      direction = "vertical",
      caption = {"coe.title-choose-target"}
  }
  
  -- add drop down
  destinations_frame.add({
    type = "drop-down",
    name = "coe_city_list_dropdown",
    items = GetCityNames(),
    selected_index = global.coe.spawn_city_index
  })
  
  -- add button for teleport
  destinations_frame.add({
    type = "button",
    name = "coe_teleport_button"
  })

  -- only enable if enabled in settings
  local teleport_button = destinations_frame["coe_teleport_button"]
  if settings.global["coe2_tp-to-city"].value == true then
    teleport_button.enabled = true
    teleport_button.caption = {"coe.button-city-go-enabled"}
  else
    teleport_button.enabled = false
    teleport_button.caption = {"coe.button-city-go-disabled"}
  end
  global.coe[player.index].teleport_control_visible = true
end -- OpenUI

--------------------------------------------------------------------------------

function CloseUI( player )
  if player then
    if player.gui.left.coe_destinations_frame then
      player.gui.left.coe_destinations_frame.destroy()
    end
  end
  global.coe[player.index].teleport_control_visible = false
end -- CloseUI

--------------------------------------------------------------------------------
