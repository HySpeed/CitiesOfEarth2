-- coe_init

--==============================================================================

function InitSettings()

  -- coe data structure
  global.coe = {
    city_count = 0,
    ["cities"] = {},
    ["players"] = {},
    launches_to_win = 1,
    rockets_launched = 0,
    launch_success = false
  }

  global.coe.surface = game.surfaces[SURFACE_NAME]
  if global.coe.city_names == nil then
    SetupCityNames()
  end

-----  -----  ----- ----- -----  -----  ----- ----- -----  -----  ----- -----

-- Load mod startup settings
  -- Which World Map to use ('Worlds' is defined in "data/worlds.lua")
  local world_map = settings.startup["coe2_world-map"].value
  global.coe.map_index = Worlds[world_map].map_index
  local detail_factor = Worlds[world_map].detail_factor

  -- Spawn location
  local spawn_city_name = settings.startup["coe2_spawn-position"].value
  if spawn_city_name == "Random City Location" then
    local spawn_index = 1 -- default to Africa
    spawn_index = math.random(2, global.coe.city_count) - 1 -- skip first entry "random"
    spawn_city_name = global.coe.city_names[spawn_index]
  end
  global.coe.spawn_city_name = spawn_city_name
  log("~spawn : " .. global.coe.spawn_city_name)
  
  -- Map Scaling factor
  global.coe.map_scale = settings.startup["coe2_map-scale"].value
  global.coe.size_multipler = global.coe.map_scale * detail_factor

  -- Pre-Place Silo
  global.coe.pre_place_silo = settings.startup["coe2_pre-place-silo"].value
  local silo_city_name = settings.startup["coe2_silo-position"].value
  if silo_city_name == "Random City Location" then
    local silo_index = 1 -- default to Africa
    silo_index = math.random(2, global.coe.city_count) -1 -- skip first entry "random"
    silo_city_name = global.coe.city_names[silo_index]
  end
  global.coe.silo_city_name = silo_city_name
  log("~silo : " .. global.coe.silo_city_name)

  -- Launches per Death
  global.coe.launches_per_death = settings.startup["coe2_launches-per-death"].value
  -- disable 'freeplay' rocket launch victory so they can be tied to extra launches
  if global.coe.launches_per_death > 0 then
    remote.call("silo_script", "set_no_victory", true)
  end

  -- Enable teleport controls (stored for displaying messages later)
  global.coe.tp_to_city = settings.global["coe2_tp-to-city"].value
  global.coe.tp_to_player = settings.global["coe2_tp-to-player"].value

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
