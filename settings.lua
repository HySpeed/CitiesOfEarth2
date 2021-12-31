-- settings.lua

-- setup the mod configuration values (startup and runtime)
require("data/cities")
require("data/worlds")

--==============================================================================

-- Get the world names from worlds
local world_names = {}
for world_name, pos in pairs(Worlds) do
    table.insert(world_names, world_name)
end

-- Get only the city names from cities
local city_names = {}
for city_name, _ in pairs(Cities) do
    table.insert(city_names, city_name)
end

-- startup settings
data:extend({
  {
    type = "string-setting",
    name = "coe2_world-map",
    setting_type = "startup",
  default_value = world_names[3],
    allowed_values = world_names,
    order = "a"
  },
  {
    type = "string-setting",
    name = "coe2_spawn-position",
    setting_type = "startup",
    default_value = city_names[1],
    allowed_values = city_names,
    order = "b"
  },
  {
    type = "double-setting",
    name = "coe2_map-scale",
    setting_type = "startup",
    minimum_value = 1,
    default_value = 3,
    order = "c"
  },
  {
    type = "bool-setting",
    name = "coe2_pre-place-silo",
    setting_type = "startup",
    default_value = false,
    order = "d"
  },
  {
    type = "string-setting",
    name = "coe2_silo-position",
    setting_type = "startup",
    default_value = city_names[1],
    allowed_values = city_names,
    order = "e"
  },
  {
    type = "double-setting",
    name = "coe2_launches-per-death",
    setting_type = "startup",
    default_value = 0,
    minimum_value = 0,
    order = "f"
  }
})

-- runtime-global settings (can be changed in game)
data:extend({
  {
    type = "bool-setting",
    name = "coe2_tp-to-city",
    setting_type = "runtime-global",
    default_value = true,
    order = "a"
  },
  {
  type = "bool-setting",
  name = "coe2_tp-to-player",
  setting_type = "runtime-global",
  default_value = true,
  order = "b"
  },
  {
    type = "bool-setting",
    name = "coe2_show-offline-players",
    setting_type = "runtime-global",
    default_value = true,
    order = "c"
    }
})