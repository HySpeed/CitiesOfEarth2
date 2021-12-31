--control.lua

-- Credit:
-- -- The Oddlers Factorio World
-- -- -- The world loader is done via his code
-- -- MojoD -- Frontier Extended
-- -- -- The Pre-Placed Silo is from his work
--
-- Feel free to re-use anything you want. It would be nice to give credit where you can.

if script.active_mods["gvv"] then require("__gvv__.gvv")() end

local event_handler = require("event_handler")
MOD_GUI = require("mod-gui")

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
script.on_event(defines.events.on_gui_click,          function(event) ProcessGuiEvent(event) end)

script.on_event(defines.events.on_chunk_generated,    function(event) OnChunkGenerated(event) end)
script.on_event(defines.events.on_research_finished,  function(event) RemoveSiloCrafting(event) end)
script.on_event(defines.events.on_player_created,     function(event) OnPlayerCreated(event) end)
script.on_event(defines.events.on_player_joined_game, function(event) OnPlayerJoined(event) end)
script.on_event(defines.events.on_player_died,        function(event) RecordPlayerDeath(event) end)
script.on_event(defines.events.on_rocket_launched,    function(event) RecordRocketLaunch(event) end)
script.on_event(defines.events.on_runtime_mod_setting_changed, function(event) RuntimeSettingChanged(event) end)

--------------------------------------------------------------------------------

function OnInit()

  SkipIntro()
  InitWorld(InitSettings())

end -- OnInit

--------------------------------------------------------------------------------

function OnPlayerCreated(event)
  if event.player_index == nil then return end

  local player = game.players[event.player_index]
  CreateButton_ShowTargets(player)
  TPtoCity(player, nil, global.coe.spawn_city_name)

end -- OnPlayerCreated


--------------------------------------------------------------------------------

function OnPlayerJoined(event)
  global.coe.surface = game.surfaces[SURFACE_NAME]
  if global.coe.city_names == nil then
    SetupCityNames()
  end
  
-- TODO: ONLY ENABLE IN DEV
-- EnableDevConfiguration()
-- TODO: ONLY ENABLE IN DEV
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

  if event.setting == "coe2_tp-to-player" then
    if settings.global["coe2_tp-to-player"].value == true then
      game.print({"coe.text-tp-to-player-enabled"})
    else
      game.print({"coe.text-tp-to-player-disabled"})
    end
  end

  if event.setting == "coe2_show-offline-players" then
    if settings.global["coe2_show-offline-players"].value == true then
      game.print({"coe.text-show-offline-players-enabled"})
    else
      game.print({"coe.text-show-offline-players-disabled"})
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

function EnableDevConfiguration()
  -- DEV: disable aliens
  local mgs = global.coe.surface.map_gen_settings
  mgs.autoplace_controls["enemy-base"].size = 0
  global.coe.surface.map_gen_settings = mgs
  for _, entity in pairs(global.coe.surface.find_entities_filtered({force="enemy"})) do
    entity.destroy()
  end
  game.print("! development mode enabled !")
end -- EnableDevConfiguration
