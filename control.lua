--control.lua

-- Credit:
-- -- The Oddlers Factorio World
-- -- -- The world loader is done via his code
--
-- Feel free to re-use anything you want. It would be nice to give credit where you can.

local event_handler = require("event_handler")


MOD_GUI = require("mod-gui")
require("data/config")
require("data/cities")
require("data/worlds")
require("scripts/coe_gui")
require("scripts/coe_setup")
require("scripts/oddler_world_gen")


script.on_init(function() OnInit() end)
script.on_event(defines.events.on_gui_click,       function(event) OnGuiClick(event) end)
script.on_event(defines.events.on_player_created,  function(event) OnPlayerCreated(event) end)
script.on_event(defines.events.on_chunk_generated, function(event) OnChunkGenerated(event) end)

-- ---------------------------------


function OnInit()
  -- log("~OnInit")

  SkipIntro()

  -- only do this part if it hasn't been done yet.
  -- if not global.coe then
    local world_map = InitSettings()
    InitWorld(world_map)
    -- BuildCities()
  -- end -- if

-- TODO: CHANGE WHEN DEV COMPLETE
-- EnableDevConfiguration()
-- TODO: CHANGE WHEN DEV COMPLETE

end -- OnInit

function InitSettings()
  -- log("~InitSettings - start")

-- TODO use a surface named "Earth"
  -- surface
  global.surface = game.surfaces["nauvis"]

  -- coe data structure
  global.coe = {["cities"] = {}, ["players"] = {}}

----
-- Load mod settings
-- World Map to use ('Worlds' is defined in "data/worlds.lua")
  local world_map = settings.global["coe2_world-map"].value
  global.coe.map_index = Worlds[world_map].map_index
  local detail_factor = Worlds[world_map].detail_factor

-- Chosen Spawn location
  global.coe.spawn_city_name = settings.global["coe2_spawn-position"].value

  -- Map Scaling factor
  local map_scale = settings.global["coe2_map-scale"].value
  global.coe.size_multipler = map_scale * detail_factor

-- log("~world_map : " .. world_map)
-- log("~map_index : " .. global.coe.map_index)
-- log("~detail    : " .. detail_factor)
-- log("~scale     : " .. map_scale)
-- log("~position  : " .. global.coe.spawn_city_name)

-- Setup based on chosen settings
-- Get spawn by looking up the selection and map index in 'Cities' table
  local spawn = Cities[global.coe.spawn_city_name][global.coe.map_index]

  -- Adjust spawn for map-scale factor and detail level
  spawn = {
      x = spawn.x * global.coe.size_multipler,
      y = spawn.y * global.coe.size_multipler
  }
  -- log("~adjusted spawn: " .. spawn.x .. "," .. spawn.y)

  global.coe.map_scale = map_scale
  global.coe.spawn = spawn
  return world_map
end -- InitSettings

--------------------------------------------------------------------------------

function OnPlayerCreated(event)
  -- log("~OnPlayerCreated - start")
  local player = game.players[event.player_index]
  CreateButton_ShowTargets(player)
  -- CreateShowInfoFrame(player)
end -- OnPlayerCreated

function OnChunkGenerated(event)
  GenerateChunk(event)
end -- OnChunkGenerated

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
  -- global.coe.enemy_enabled = global.surface.map_gen_settings
  local mgs = global.surface.map_gen_settings
  -- log( "~enemy-base: " .. mgs.autoplace_controls["enemy-base"].size )
  mgs.autoplace_controls["enemy-base"].size = 0
  global.surface.map_gen_settings = mgs
  -- log( "~disabled enemy - enemy-base: " .. mgs.autoplace_controls["enemy-base"].size )
  for _, entity in pairs(global.surface.find_entities_filtered({force="enemy"})) do
    entity.destroy()
  end

end -- EnableDevConfiguration
