--oddler_world_gen
require("data/worlds")
require("worlds/earth_atlantic_normal")
require("worlds/earth_atlantic_detailed")
require("worlds/earth_pacific_normal")
require("worlds/earth_pacific_detailed")


-- Initialize World data
function InitWorld(world_map)
  log("~coe: InitWorld - start")

  -- factorio world code (will be moved to function)
  --Terrain codes should be in sync with the ConvertMap code
  global.coe.terrain_codes = {
    ["_"] = "out-of-map",
    ["o"] = "deepwater",--ocean
    ["O"] = "deepwater-green",
    ["w"] = "water",
    ["W"] = "water-green",
    ["g"] = "grass-1",
    ["m"] = "grass-3",
    ["G"] = "grass-2",
    ["d"] = "dirt-3",
    ["D"] = "dirt-6",
    ["s"] = "sand-1",
    ["S"] = "sand-3"
  }

  local map_data = {
    ["earth_atlantic_normal"]   = map_earth_atlantic_normal,
    ["earth_atlantic_detailed"] = map_earth_atlantic_detailed,
    ["earth_pacific_normal"]    = map_earth_pacific_normal,
    ["earth_pacific_detailed"]  = map_earth_pacific_detailed
  }


  global.coe.repeat_map = false
  global.coe.out_of_map_code = "o" -- The terrain to use for everything outside the map

  -- Set correct world
  -- local terrain_types = nil
  -- if global.coe.map_detail_factor == 1 then
  --   global.coe.terrain_types = map_data_detailed
  -- else
  --   global.coe.terrain_types = map_data_normal
  -- end

  -- Get correct world data
---filename indexes to map data variable name
log("~world_map: " .. world_map)
log("~filename: " .. Worlds[world_map].filename)
  global.coe.terrain_types = map_data[Worlds[world_map].filename]

  ----- Load map
  -- setup
  global.coe.decompressedMapData = {}
  global.coe.map_width = nil
  global.coe.map_height = #global.coe.terrain_types
  for y = 0, #global.coe.terrain_types-1 do
    global.coe.decompressedMapData[y] = {}
  end

  --Decompress one line to get the width
  DecompressLine(0)

  log("~coe: InitWorld - end")
end -- InitWorld

-- Decompress map data
function DecompressLine(y)
  local decompressed_line = global.coe.decompressedMapData[y]
  if(#decompressed_line == 0) then
      --decompress this line
      local total_count = 0
      local line = global.coe.terrain_types[y+1]
      for letter, count in string.gmatch(line, "(%a+)(%d+)") do
          for x = total_count, total_count + count do
              decompressed_line[x] = letter
          end
          total_count = total_count + count
      end
      --check width (all lines must the equal in length)
      if global.coe.map_width == nil then
          global.coe.map_width = total_count
      elseif global.coe.map_width ~= total_count then
          error("Mismatching width: " .. global.coe.map_width .. " vs " .. total_count)
      end
  end
end -- DecrompressLine

-- Helper functions
local function addToTotal(totals, weight, code)
  if totals[code] == nil then
      totals[code] = {code=code, weight=weight}
  else
      totals[code].weight = totals[code].weight + weight
  end
end -- addToTotal

local function getWorldTileCodeRaw(x, y)
  local y_wrap = y % global.coe.map_height
  local x_wrap = x % global.coe.map_width

  if not global.coe.repeat_map and (x ~= x_wrap or y ~= y_wrap) then
      return global.coe.out_of_map_code
  end

  DecompressLine(y_wrap)
  return global.coe.decompressedMapData[y_wrap][x_wrap]
end -- getWorldTileCodeRaw

local function getWorldTileName(x, y)
  local spawn = global.coe.spawn
  local scale = global.coe.map_scale
  local safe_zone_size = 5

  --calculate the safe-zone
  local safe_zone = x >= -safe_zone_size and x < safe_zone_size and y >= -safe_zone_size and y < safe_zone_size

  --spawn
  x = x + spawn.x
  y = y + spawn.y
  --scaling
  x = x / scale
  y = y / scale

  --get cells you're between
  local top = math.floor(y)
  local bottom = (top + 1)
  local left = math.floor(x)
  local right = (left + 1)
  --calc weights
  local sqrt2 = math.sqrt(2)
  local w_top_left = 1 - math.sqrt((top - y)*(top - y) + (left - x)*(left - x)) / sqrt2
  local w_top_right = 1 - math.sqrt((top - y)*(top - y) + (right - x)*(right - x)) / sqrt2
  local w_bottom_left = 1 - math.sqrt((bottom - y)*(bottom - y) + (left - x)*(left - x)) / sqrt2
  local w_bottom_right = 1 - math.sqrt((bottom - y)*(bottom - y) + (right - x)*(right - x)) / sqrt2
  w_top_left = w_top_left * w_top_left + math.random() / math.max(scale / 2, 10)
  w_top_right = w_top_right * w_top_right + math.random() / math.max(scale / 2, 10)
  w_bottom_left = w_bottom_left * w_bottom_left + math.random() / math.max(scale / 2, 10)
  w_bottom_right = w_bottom_right * w_bottom_right + math.random() / math.max(scale / 2, 10)
  --get codes
  local c_top_left = getWorldTileCodeRaw(left, top)
  local c_top_right = getWorldTileCodeRaw(right, top)
  local c_bottom_left = getWorldTileCodeRaw(left, bottom)
  local c_bottom_right = getWorldTileCodeRaw(right, bottom)
  --calculate total weights for codes
  local totals = {}
  addToTotal(totals, w_top_left, c_top_left)
  addToTotal(totals, w_top_right, c_top_right)
  addToTotal(totals, w_bottom_left, c_bottom_left)
  addToTotal(totals, w_bottom_right, c_bottom_right)
  --choose final code
  local code = nil
  local weight = 0
  for _, total in pairs(totals) do
      if total.weight > weight then
          code = total.code
          weight = total.weight
      end
  end
  local terrain_name = global.coe.terrain_codes[code]

  --safezone check
  if safe_zone and string.match(terrain_name, "water") then
      terrain_name = "sand-1"
  end
  return terrain_name
end -- getWorldTileName


-- Chunk generation
function GenerateChunk(event)
    if (event.surface.name ~= "nauvis") then
        return
    end

    local surface = event.surface
    local lt = event.area.left_top
    local rb = event.area.right_bottom

    local w = rb.x - lt.x
    local h = rb.y - lt.y

    local tiles = {}
    for y = lt.y-1, rb.y do
        for x = lt.x-1, rb.x do
            table.insert(tiles, {name=getWorldTileName(x, y), position={x,y}})
        end
    end
    surface.set_tiles(tiles)
    local positions = {event.position}
    surface.destroy_decoratives({area = event.area})
    surface.regenerate_decorative(nil, positions)
    surface.regenerate_entity(nil, positions)
end -- GenerateChunk
