-- setup the mod configuration values on 'New Game'
require("data/cities")
require("data/worlds")

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


data:extend({
  {
    type = "string-setting",
    name = "coe2_world-map",
    setting_type = "runtime-global",
  default_value = world_names[3],
    allowed_values = world_names,
    order = "a"
  },
  {
    type = "string-setting",
    name = "coe2_spawn-position",
    setting_type = "runtime-global",
    default_value = city_names[1],
    allowed_values = city_names,
    order = "b"
  },
  {
    type = "double-setting",
    name = "coe2_map-scale",
    setting_type = "runtime-global",
    minimum_value = 1,
    default_value = 3,
    order = "c"
  },
  {
    type = "bool-setting",
    name = "coe2_pre-place-silo",
    setting_type = "runtime-global",
    default_value = false,
    order = "d"
  },
  {
    type = "string-setting",
    name = "coe2_silo-position",
    setting_type = "runtime-global",
    default_value = city_names[30],
    allowed_values = city_names,
    order = "e"
  },
  {
    type = "double-setting",
    name = "coe2_launches-per-death",
    setting_type = "runtime-global",
    default_value = 1,
    minimum_value = 0,
    order = "f"
  }
})
