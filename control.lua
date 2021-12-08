--control.lua

-- Credit:
-- -- The Oddlers Factorio World
-- -- -- The world loader is done via his code
-- -- MojoD -- Frontier Extended
-- -- -- The Pre-Placed Silo is from his work
--
-- Feel free to re-use anything you want. It would be nice to give credit where you can.

local event_handler = require("event_handler")
MOD_GUI = require("mod-gui")

require("data/config")
require("data/cities")
require("data/worlds")
require("scripts/coe_init")
require("scripts/coe_gui")
require("scripts/coe_setup")
require("scripts/coe_silo")
require("scripts/oddler_world_gen")


script.on_init(function() OnInit() end)
script.on_event(defines.events.on_gui_click,          function(event) ProcessGuiEvent(event) end)

script.on_event(defines.events.on_chunk_generated,    function(event) OnChunkGenerated(event) end)
script.on_event(defines.events.on_research_finished,  function(event) RemoveSiloCrafting(event) end)
script.on_event(defines.events.on_player_created,     function(event) OnPlayerCreated(event) end)
script.on_event(defines.events.on_player_joined_game, function(event) OnPlayerJoined(event) end)
script.on_event(defines.events.on_player_died,        function(event) RecordPlayerDeath(event) end)
script.on_event(defines.events.on_rocket_launched,    function(event) RecordRocketLaunch(event) end)
script.on_event(defines.events.on_runtime_mod_setting_changed, function(event) RuntimeSettingChanged(event) end)

-------------------------------------------------------------------------------

function OnInit()

  SkipIntro()
  InitWorld(InitSettings())

end -- OnInit

--------------------------------------------------------------------------------

function OnPlayerCreated(event)
  if event.player_index == nil then return end

  local player = game.players[event.player_index]
  CreateButton_ShowTargets(player)
  player.teleport({ GetRandomAmount(WOBBLE), GetRandomAmount(WOBBLE) }, game.surfaces[SURFACE_NAME])

end -- OnPlayerCreated


--------------------------------------------------------------------------------

function OnPlayerJoined(event)
  if global.coe.city_names == nil then
    SetupCityNames()
  end
  
-- TODO: CHANGE WHEN DEV COMPLETE
-- EnableDevConfiguration()
-- TODO: CHANGE WHEN DEV COMPLETE
end


--------------------------------------------------------------------------------

function OnChunkGenerated(event)
  GenerateChunk_World(event)
  if global.coe.pre_place_silo and not global.coe.silo_created then
    local silo_position = CalcTPOffset(global.coe.silo_city_name)
      --create tiles around silo when generating chunk (for performance, do it only when chunk is generated, not before)
    if ((event.area.left_top.x  <= silo_position.x+7  and silo_position.x+7  <= event.area.right_bottom.x)  or
        (event.area.left_top.x  <= silo_position.x+21 and silo_position.x+21 <= event.area.right_bottom.x)) and
       ((event.area.left_top.y  <= silo_position.y+7  and silo_position.y+7  <= event.area.right_bottom.y)  or
        (event.area.left_top.y  <= silo_position.y+21 and silo_position.y+21 <= event.area.right_bottom.y)) then
          PlaceSilo(global.coe.surface, silo_position)
          SetSiloTiles(global.coe.surface, silo_position)
    end
  end
end -- OnChunkGenerated

--------------------------------------------------------------------------------

function RecordPlayerDeath(event)
  if global.coe.launches_per_death <= 0 then return end

  global.coe.launches_to_win = global.coe.launches_to_win + global.coe.launches_per_death
  game.print("The death of " .. game.players[event.player_index].name .. " has increased the number of rocket launches needed by: " .. tostring(global.coe.launches_per_death))
  game.print(tostring(global.coe.launches_to_win - global.coe.rockets_launched) .. " more rockets need to be launched.")
end -- RecordPlayerDeath

--------------------------------------------------------------------------------

function RecordRocketLaunch(event)
  if global.coe.launches_per_death <= 0 then return end

  local rocket = event.rocket
  if not (rocket and rocket.valid) then return end

  global.coe.launch_success = global.coe.launch_success or false
  if global.coe.launch_success then return end

  --  check contents of rocket - do not count empty rockets
  if event.rocket.has_items_inside() then
    global.coe.rockets_launched = global.coe.rockets_launched + 1
    if global.coe.rockets_launched >= global.coe.launches_to_win then
      global.coe.launch_success = true
      game.set_game_state
      {
        game_finished = true,
        player_won = true,
        can_continue = true,
        victorious_force = rocket.force
      }
      return
    else
      game.print(tostring(global.coe.rockets_launched) .. " rockets have been launched.")
      game.print(tostring(global.coe.launches_to_win - global.coe.rockets_launched) .. " more rockets need to be launched.")
    end
  else
    game.print("! An empty rocket was launched! -- that doesn't count toward the total!")
    game.print(tostring(global.coe.launches_to_win - global.coe.rockets_launched) .. " more rockets need to be launched.")
  end

end --RecordRocketLaunch

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
      game.print("+ Telporting to Cities enabled +")
    else
      game.print("- Telporting to Cities disabled -")
    end
  end

  if event.setting == "coe2_tp-to-player" then
    if settings.global["coe2_tp-to-player"].value == true then
      game.print("+ Player to Player Telporting disabled +")
    else
      game.print("- Player to Player Telporting disabled -")
    end
  end
end 

--------------------------------------------------------------------------------

function SkipIntro()
  -- removes crashsite and cutscene start
	remote.call("freeplay", "set_disable_crashsite", true)
	-- Skips popup message to press tab to start playing
	remote.call("freeplay", "set_skip_intro", true)
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
