--control.lua

-- Credit:
-- -- The Oddlers Factorio World
-- -- -- The world loader is done via his code
-- -- MojoD -- Frontier Extended
-- -- -- The Pre-Placed Silo is from his work
--
-- You may re-use anything written here. It would be nice to give credit where you can.

local event_handler = require("event_handler")
local mod_gui = require("mod-gui")

require("data/config")
require("data/cities")
require("data/worlds")
require("scripts/coe_init")
require("scripts/coe_actions")
require("scripts/coe_gui")
require("scripts/coe_silo")
require("scripts/coe_utils")
require("scripts/oddler_world_gen")

--==============================================================================

script.on_init(function() OnInit() end)
script.on_configuration_changed( function(event) ConfigurationChanged(event) end )

script.on_event(defines.events.on_gui_click,          function(event) ProcessGuiEvent(event) end)
script.on_event(defines.events.on_runtime_mod_setting_changed, function(event) RuntimeSettingChanged(event) end)

script.on_event(defines.events.on_chunk_generated,    function(event) OnChunkGenerated(event) end)

script.on_event(defines.events.on_research_finished,  function(event) RemoveSiloCrafting(event) end)
script.on_event(defines.events.on_player_created,     function(event) OnPlayerCreated(event) end)
script.on_event(defines.events.on_player_joined_game, function(event) OnPlayerJoined(event) end)
script.on_event(defines.events.on_player_died,        function(event) RecordPlayerDeath(event) end)
script.on_event(defines.events.on_rocket_launched,    function(event) RecordRocketLaunch(event) end)

--------------------------------------------------------------------------------

function OnInit()
  SkipIntro()
  InitWorld(InitSettings())
  for _, player in pairs( game.players ) do
    SetupPlayer( player.index )
  end
end -- OnInit

--------------------------------------------------------------------------------

function OnPlayerCreated(event)
--  local player = game.players[event.player_index]
--  CreateButton_ShowTargets(player)
--  SetupCityNames()
  SetupPlayer( event.player_index )
  local city_name = global.coe.spawn_city_name
  PerformTeleport( event.player_index, city_name )
end -- OnPlayerCreated

--------------------------------------------------------------------------------

function OnPlayerJoined(event)
--  SetupCityNames()
  SetupPlayer( event.player_index )
end -- OnPlayerJoined

--------------------------------------------------------------------------------

function OnChunkGenerated(event)
  GenerateChunk_World(event)
  CheckAndPlaceSilo(event)
end -- OnChunkGenerated

--------------------------------------------------------------------------------

function RecordPlayerDeath(event)
  if global.coe.launches_per_death <= 0 or global.coe.launch_success then return end

  global.coe.launches_to_win = global.coe.launches_to_win + global.coe.launches_per_death
  game.print({"",  {"coe.text-mod-print-name"}, {"coe.text-death-of"}, game.players[event.player_index].name, {"coe.text-increased-launches"}, tostring(global.coe.launches_per_death)})
  game.print({"",  {"coe.text-mod-print-name"}, tostring(global.coe.launches_to_win - global.coe.rockets_launched), {"coe.text-more-rockets"}, ""})
end -- RecordPlayerDeath

--------------------------------------------------------------------------------

function ConfigurationChanged( event )
  -- version migrations
  -- TODO: setup spawn & silo city values on loading saved game
  local city_names = GetCityNames()
  global.coe.spawn_city_index = GetIndex( city_names, global.coe.spawn_city_name )
  for _, player in pairs( game.players ) do
    SetupPlayer( player.index )
  end
  log("~ global.coe.spawn_city_name : " .. global.coe.spawn_city_name)
  log("~ global.coe.spawn_city_index: " .. global.coe.spawn_city_index)
  log("~ global.coe.silo_city_name  : " .. global.coe.silo_city_name)
end -- ConfigurationChanged
  
--------------------------------------------------------------------------------

function RemoveSiloCrafting(event)
  if global.coe.pre_place_silo then
    local recipes = event.research.force.recipes
    if recipes["rocket-silo"] then
      recipes["rocket-silo"].enabled = false
    end
  end
end -- RemoveSiloCrafting

--------------------------------------------------------------------------------

function RuntimeSettingChanged(event)
  if event.setting == "coe2_tp-to-city" then
    if settings.global["coe2_tp-to-city"].value == true then
      game.print({"coe.text-tp-to-city-enabled"})
    else
      game.print({"coe.text-tp-to-city-disabled"})
    end
  end
end -- RuntimeSettingChanged

--------------------------------------------------------------------------------

function SkipIntro()
  -- In "sandbox" mode, freeplay is not available
  if( remote.interfaces["freeplay"] ) then
  -- removes crashsite and cutscene start
  remote.call("freeplay", "set_disable_crashsite", true)
	-- Skips popup message to press tab to start playing
    remote.call("freeplay", "set_skip_intro", true)
  end
end -- SkipIntro

--------------------------------------------------------------------------------
