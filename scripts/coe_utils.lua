-- coe_utils
-- utility functions called by other functions

--==============================================================================

function CalcTPOffset(destination_city_name)
-- given the destination, lookup the x&y of each, calculate the difference
  local target_city_loc = Cities[destination_city_name][global.coe.map_index]
  local spawn_city_loc = Cities[global.coe.spawn_city_name][global.coe.map_index]
  local destination_offsets = {
    x = -(spawn_city_loc.x - target_city_loc.x),
    y = -(spawn_city_loc.y - target_city_loc.y)
  }

  -- Adjust destination for map-scale factor and detail level
  destination_offsets = {
      x = destination_offsets.x * global.coe.size_multipler,
      y = destination_offsets.y * global.coe.size_multipler
  }

  return destination_offsets
end -- CalcTPOffset

--------------------------------------------------------------------------------

function GetCityNames()
  local city_names = {}
  for city_name, _ in pairs(Cities) do
    table.insert(city_names, city_name)
  end
  return city_names
end -- GetCityNames

-------------------------------------------------------------------------------

function GetIndex( table, search )
  local result = 1
  for index, value in ipairs( table ) do
    if value == search then
      result = index
      break
    end
  end
  return result
end -- GetIndex

--------------------------------------------------------------------------------

-- return a random non-zero value from negative to positive given value
function GetRandomAmount(limit)
  local result = 0
  while (result == 0) do
    result = math.random(-limit, limit)
  end
  return result
end -- GetRandomAmount
