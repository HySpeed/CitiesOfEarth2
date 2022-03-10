-- coe_init
-- initialization functions

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

  -- global.coe.surface = game.surfaces[SURFACE_NAME]
  -- GetCityNames()

-----  -----  ----- ----- -----  -----  ----- ----- -----  -----  ----- -----

-- Load mod startup settings
  -- Which World Map to use ('Worlds' is defined in "data/worlds.lua")
  local world_map = settings.startup["coe2_world-map"].value
  global.coe.map_index = Worlds[world_map].map_index
  local detail_factor = Worlds[world_map].detail_factor

  -- Spawn location
  local city_names = GetCityNames()
  local spawn_city_name = settings.startup["coe2_spawn-position"].value
  local spawn_city_index = GetIndex( city_names, spawn_city_name )
  if spawn_city_name == RANDOM_CITY then
    spawn_city_index = math.random( 1, #city_names )
    spawn_city_name = city_names[spawn_city_index]
  end
  global.coe.spawn_city_name = spawn_city_name
  global.coe.spawn_city_index = spawn_city_index
  log("~spawn : " .. global.coe.spawn_city_name)
  
  -- Map Scaling factor
  global.coe.map_scale = settings.startup["coe2_map-scale"].value
  global.coe.size_multipler = global.coe.map_scale * detail_factor

  -- Pre-Place Silo
  global.coe.pre_place_silo = settings.startup["coe2_pre-place-silo"].value
  local silo_city_name = settings.startup["coe2_silo-position"].value
  local silo_city_index = GetIndex( city_names, silo_city_name )
  if silo_city_name == RANDOM_CITY then
    silo_city_index = math.random( 1, #city_names )
    silo_city_name = city_names[silo_city_index]
  end
  global.coe.silo_city_name = silo_city_name
  global.coe.silo_city_index = silo_city_index
  log("~silo : " .. global.coe.silo_city_name)

  -- Launches per Death
  global.coe.launches_per_death = settings.startup["coe2_launches-per-death"].value
  -- disable 'freeplay' rocket launch victory so they can be tied to extra launches
  if global.coe.launches_per_death > 0 then
    remote.call("silo_script", "set_no_victory", true)
  end

  -- Enable teleport controls (stored for displaying messages later)
  global.coe.tp_to_city = settings.global["coe2_tp-to-city"].value

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

--------------------------------------------------------------------------------

function SetupPlayer( player_index )
  if not global.coe then
    global.coe = {}
  end
  if not global.coe[player_index] then -- ui button
    global.coe[player_index] = {
      teleport_control_visible = false
    }
  end
  if not global.coe.surface then
    global.coe.surface = game.surfaces[SURFACE_NAME]
  end
  SetupPlayerUI( player_index )
end -- SetupPlayer

--------------------------------------------------------------------------------
