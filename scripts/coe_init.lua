-- coe_init

function InitSettings()

  -- coe data structure
  global.coe = {
    ["cities"] = {},
    ["players"] = {},
    launches_to_win = 1,
    rockets_launched = 0,
    launch_success = false
  }

  -- TODO create and use a surface named "Earth"
  -- surface
  global.coe.surface = game.surfaces["nauvis"]


-----  -----  ----- ----- -----  -----  ----- ----- -----  -----  ----- -----
-- Load mod settings
-- Which World Map to use ('Worlds' is defined in "data/worlds.lua")
  local world_map = settings.global["coe2_world-map"].value
  global.coe.map_index = Worlds[world_map].map_index
  local detail_factor = Worlds[world_map].detail_factor

  -- Spawn location
  global.coe.spawn_city_name = settings.global["coe2_spawn-position"].value

  -- Map Scaling factor
  global.coe.map_scale = settings.global["coe2_map-scale"].value
  global.coe.size_multipler = global.coe.map_scale * detail_factor

  -- Pre-Place Silo
  global.coe.pre_place_silo = settings.global["coe2_pre-place-silo"].value
  global.coe.silo_city_name = settings.global["coe2_silo-position"].value

  -- Launches per Death
  global.coe.launches_per_death = settings.global["coe2_launches-per-death"].value
  -- disable 'freeplay' rocket launch victory so they can be tied to extra launches
  if global.coe.launches_per_death > 0 then
    remote.call("silo_script", "set_no_victory", true)
  end

-----  -----  ----- ----- -----  -----  ----- ----- -----  -----  ----- -----
-- Setup based on chosen settings
-- Get spawn by looking up the selection and map index in 'Cities' table
local spawn = Cities[global.coe.spawn_city_name][global.coe.map_index]

-- Adjust spawn for map-scale factor and detail level
spawn = {
    x = spawn.x * global.coe.size_multipler,
    y = spawn.y * global.coe.size_multipler
}

global.coe.spawn = spawn

  --  log("~coe~world_map : " .. world_map)
  --  log("~coe~map_index : " .. global.coe.map_index)
  --  log("~coe~detail    : " .. detail_factor)
  --  log("~coe~scale     : " .. global.coe.map_scale)
  --  log("~coe~spawn_city: " .. global.coe.spawn_city_name)
  --  log("~coe~silo      : " .. tostring(global.coe.pre_place_silo))
  --  log("~coe~silo_city : " .. global.coe.silo_city_name)
  --  log("~coe~lpd       : " .. tostring(global.coe.launches_per_death))

  return world_map
end -- InitSettings
