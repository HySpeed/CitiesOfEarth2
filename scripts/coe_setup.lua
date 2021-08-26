--coe_setup.lua
require("data/cities")

function BuildCityNameList()
  local city_names = {}
  for city_name, _ in pairs(Cities) do
      table.insert(city_names, city_name)
  end
  return city_names
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

-- return a random amount to vary teleporting
function GetRandomAmount(max)
  local result = 0
  while (result == 0) do
    result = math.random(-max, max)
  end
  return result
end

