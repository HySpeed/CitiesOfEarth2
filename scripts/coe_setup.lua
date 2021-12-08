-- coe_setup.lua
require("data/cities")


function SetupCityNames()
  global.coe.city_names, global.coe.city_count = BuildCityNameList()
  global.coe.gui_city_names = global.coe.city_names
  table.remove(global.coe.gui_city_names, 1) -- "Random City Location"
end -- SetupCityNames


function BuildCityNameList()
  local city_names = {}
  local city_count = 0
  for city_name, _ in pairs(Cities) do
      table.insert(city_names, city_name)
      city_count = city_count + 1
    end
  return city_names, city_count
end -- BuildCityNameList


function BuildPlayerNameList()
  local result = {}
  BuildPlayerList()
  for index, player in pairs(global.coe.players) do
    result[index] = player.name
  end
  return result
end -- BuildPlayerNameList


function BuildPlayerList()
  global.coe.players = {}
  for _, player in pairs(game.players) do
    table.insert(global.coe.players, player)
  end
end -- BuildPlayerList


function GetPlayerByName(name)
  for _, player in pairs(global.coe.players) do
    if player.name == name then
      return player
    end
  end
end -- GetPlayerByName


-- return a random value
function GetRandomAmount(max)
  local result = 0
  while (result == 0) do
    result = math.random(-max, max)
  end
  return result
end -- GetRandomAmount
