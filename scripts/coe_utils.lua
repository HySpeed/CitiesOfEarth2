-- coe_utils
-- utility functions called by other functions

--==============================================================================

function SetupCityNames()
  global.coe.city_names, global.coe.city_count = BuildCityNameList()
  global.coe.gui_city_names = global.coe.city_names
  table.remove(global.coe.gui_city_names, 1) -- "Random City Location"
  table.insert(global.coe.gui_city_names, 1, "Select a Target") -- "Select a target"
end -- SetupCityNames

-------------------------------------------------------------------------------

function BuildCityNameList()
  local city_names = {}
  local city_count = 0
  for city_name, _ in pairs(Cities) do
    table.insert(city_names, city_name)
    city_count = city_count + 1
  end
  return city_names, city_count
end -- BuildCityNameList

-------------------------------------------------------------------------------

function BuildPlayerNameList()
  local player_names = {}
  local player_list = BuildPlayerList()
  for _, player in pairs(player_list) do
    if( player.connected ) then
      table.insert(player_names, player.name)
    else
      local name = player.name .. OFFLINE
      table.insert(player_names, name)
    end
  end
  return player_names
end -- BuildPlayerNameList

-------------------------------------------------------------------------------

function BuildPlayerList()
  local player_list = {}
  local online_players = {}
  local offline_players = {}
  for _, player in pairs(game.players) do
    if( player.connected ) then
      table.insert(online_players, player)
    else
      if( settings.global["coe2_show-offline-players"].value == true ) then
        table.insert(offline_players, player)
      end
    end
  end

  table.sort(online_players, function(player_a, player_b) ComparePlayerNames(player_a, player_b) end)
  player_list = online_players

  if( next(offline_players) ~= nil ) then -- ensure offline is not empty
    table.sort(offline_players, function(player_a, player_b) ComparePlayerNames(player_a, player_b) end)
    for _, offline_player in ipairs(offline_players) do -- append offline to online
      table.insert(player_list, offline_player)
    end
  end

  global.coe.players = player_list
  return player_list
end -- BuildPlayerList

-------------------------------------------------------------------------------

function ComparePlayerNames(playerA, playerB)
  return playerA.name < playerB.name
end -- ComparePlayerNames

-------------------------------------------------------------------------------

-- given the destination, lookup the x&y of each, calculate the difference
function CalcTPOffset(destination_city_name)
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

-------------------------------------------------------------------------------

function GetPlayerByName(chosen_name)
  local search_name = chosen_name

  -- trim the ' (OFFLINE)' from the chosen name if there
  local offline_index = string.find(chosen_name, OFFLINE, 1, true)
  if ( offline_index ~= nil ) then
    search_name = string.sub(chosen_name, 1, offline_index-1)
  end

  for _, player in pairs(global.coe.players) do
    if ( player.name == search_name ) then
      return player
    end
  end
end -- GetPlayerByName

-------------------------------------------------------------------------------

-- return a random non-zero value from negative to positive given value
function GetRandomAmount(limit)
  local result = 0
  while (result == 0) do
    result = math.random(-limit, limit)
  end
  return result
end -- GetRandomAmount
