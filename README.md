# CitiesOfEarth 2
A Factorio mod that adds a city areas list and teleports to Factorio Earth
Release **2** changes the center of the world to the Pacific Ocean. 
Africa is at the far left | America to the right.  The result is the Russia -- Alaska connection is in the center of the map.
This will allow for a small land bridge to be built that connects the two major land masses.
* Added optional "Pre-Place Silo".  The Rocket Silo will be built at map creation and cannot be crafted by players.
* Added optional "death increase number of rocket launches to win" (set to 0 to disable)

The features have been simplified:
* No alien adjustments - teleporting to a location that has not been cleared of enemy may be dangerous.
* No teams.  This feature can be re-added | but it only allowed for different research progress and didn't seem to be used.
* No "created" resources at city.

## Requirements

**When first starting a new game there will be a long delay while the map initializes.**


## Worlds, Regions, and Cities

There are two 'worlds'.  Both are Earth.  
* Atlantic - The center of the map is the Atlantic Ocean.  This puts America on the 'right' side and Africa & Europe on the 'left' side of the game map.  This is the traditional view of Earth on a map.
* Pacific - The center of the map is the Pacific Ocean.  This puts Africa & Europe on the 'left' side and America on the 'right' side of the game map.  This allows for a connection between Russia and Alaska to be built.

This is a list of the regions and cities | found in 'data/cities.lua':
| Continent       | Region         | City        |
|:----------------|:---------------|:------------|
| Africa          | Mali           | Bamako      |
| Africa          | Chad           | Mongo       |
| Africa          | Egypt          | Cairo       |
| Africa          | Gauteng        | Johannesburg|
| Asia            | China          | Kunming     |
| Asia            | Georgia        | Tbilisi     |
| Asia            | India          | Delhi       |
| Asia            | Saudi Arabia   | Riyadh      |
| Asia            | Mongolia       | Moron       |
| Europe          | Czech Republic | Prague      |
| Europe          | Russia         | Aktobe      |
| Europe          | Russia         | Bilibino    |
| Europe          | Russia         | Moscow      |
| Europe          | Russia         | Omsk        |
| Europe          | Russia         | Yakutsk     |
| Europe          | Spain          | Madrid      |
| Europe          | UK             | London      |
| North America   | Canada         | Brisay      |
| North America   | Canada         | Churchill   |
| North America   | Canada         | Nahanni     |
| North America   | Greenland      | Summit Camp |
| North America   | Mexico         | Mexico City |
| North America   | United States  | Boise       |
| North America   | United States  | Scranton    |
| North America   | United States  | Topeka      |
| North America   | United States  | Ungalik     |
| South America   | Brazil         | Manaus      |
| South America   | Argentina      | Cordoba     |
| Oceania         | Australia      | Broome      |
| Oceania         | Australia      | Sydney      |

Note: Selecting a 'detailed' version of a world map will multiply all values by 2.  You do not need to make any other changes - the values will be adjusted automatically.

Earth image processing by [The Oddler](https://mods.factorio.com/user/TheOddler)
City information was pulled from [Mapcarta](https://mapcarta.com/).


## To Do:
* none

## Known Issues:
* **You must delete mod-settings.dat for changes to cities.lua to be available.**  If you change a lua data file, you'll need to delete the mod-settings.dat file.
* * **GAMES STARTED WITH 1.3.0 WILL NEED TO BE RESTARTED** (sorry)








## Helpful commands:
#### chart, day mode, free movement, 10x speed
* /c local player = game.player; local pos = player.position; local rad=500; player.force.chart(player.surface, {{x = pos.x-rad, y = pos.y-rad}, {x = pos.x+rad, y = pos.y+rad}});
game.player.surface.always_day=true;
game.player.character=nil;
game.speed=10

### Charting
* chart around player for 500
* /c local player = game.player; local pos = player.position; local rad=500; player.force.chart(player.surface, {{x = pos.x-rad, y = pos.y-rad}, {x = pos.x+rad, y = pos.y+rad}});
* /c game.player.surface.always_day=true
  Print the object 'area':
* /c game.print(serpent.block(event.area))

### Players
* get player index based on name: ( /*player_index*/ == hyspeed --> 1  )
* /c for k | v in pairs(game.players) do game.player.print(v.name .. " --> " .. k) end

* get player's current position
* /c local p = game.player.position; game.print( p.x..","..p.y)

* teleport player id to a location:
* /c game.players[z].teleport({x,y})

* 'god mode'
* /c game.player.character=nil
* undo 'god mode':
*` /c game.player.create_character()
`
### Speed
* speed up the game for mapping and moving during testing
* /c game.speed=10

### Items
* add items to the player's inventory:
* /c game.player.insert{name="grenade" | count=10}
* /c game.player.insert{name="car" | count=1}
* /c game.player.insert{name="rocket-fuel" | count=10}

### Unlocks & settings
/c local player = game.player
  player.surface.always_day=true
  player.force.research_all_technologies()
  player.cheat_mode=true

#### Equipment
/c	local player = game.player
player.insert{name="power-armor-mk2", count = 1}
local p_armor = player.get_inventory(5)[1].grid
	p_armor.put({name = "fusion-reactor-equipment"})
	p_armor.put({name = "fusion-reactor-equipment"})
	p_armor.put({name = "fusion-reactor-equipment"})
	p_armor.put({name = "exoskeleton-equipment"})
	p_armor.put({name = "exoskeleton-equipment"})
	p_armor.put({name = "exoskeleton-equipment"})
	p_armor.put({name = "exoskeleton-equipment"})
	p_armor.put({name = "energy-shield-mk2-equipment"})
	p_armor.put({name = "energy-shield-mk2-equipment"})
	p_armor.put({name = "personal-roboport-mk2-equipment"})
	p_armor.put({name = "night-vision-equipment"})
	p_armor.put({name = "battery-mk2-equipment"})
	p_armor.put({name = "battery-mk2-equipment"})
player.insert{name="construction-robot", count = 25}

#### Power & Silo
/c local player = game.player
  player.insert({name="nuclear-reactor", count=1})
  player.insert({name="heat-exchanger", count=2})
  player.insert({name="steam-turbine", count=4})
  player.insert({name="offshore-pump", count=1})
  player.insert({name="pipe", count=1})
  player.insert({name="uranium-fuel-cell", count=50})
  player.insert({name="substation", count=10})
  player.insert({name="stack-inserter", count=10})
  player.insert({name="roboport", count=5})
  player.insert({name="logistic-robot", count=200})
  player.insert({name="beacon", count=20})
  player.insert({name="speed-module-3", count=50})
  player.insert({name="logistic-chest-requester", count=10})

  player.insert({name="rocket-silo", count=1})
  player.insert({name="", count=1})


#### Create chests of these items where the player is standing
/c local s = game.surfaces[1] local p = game.player.position local f = game.player.force l = "logistic-chest-passive-provider"
  for i = 1, 25 do
    local rf_c  = s.create_entity({name=l, position={p.x+1,p.y+i}, force=f, move_stuck_players=true}) rf_c.insert({name="rocket-fuel", count=40})
    local rcu_c = s.create_entity({name=l, position={p.x+2,p.y+i}, force=f, move_stuck_players=true}) rcu_c.insert({name="rocket-control-unit", count=40})
    local lds_c = s.create_entity({name=l, position={p.x+3,p.y+i}, force=f, move_stuck_players=true}) lds_c.insert({name="low-density-structure", count=40})
  end

#### Create a silo
/c game.surfaces[1].create_entity({name="rocket-silo", position=game.player.position, force=game.player.force, move_stuck_players=true})
-- doesn't work /c local silo = game.surfaces[1].create_entity({name="rocket-silo", position=game.player.position, force=game.player.force, move_stuck_players=true})  silo.insert({name="rocket", count=1})
-- doesn't work /c local silo = game.surfaces[1].create_entity({name="rocket-silo", position=game.player.position, force=game.player.force, move_stuck_players=true})  silo.insert({name="rocket-part", count=100})

#### Big setup
/c local player = game.player
  player.surface.always_day=true
  player.force.research_all_technologies()
  player.cheat_mode=true

/c local player = game.player
  player.insert{name="rocket-launcher", count = 1}
  player.insert{name="atomic-bomb", count = 1}
  player.insert{name="power-armor-mk2", count = 1}
  local armor = player.get_inventory(5)[1].grid
    armor.put({name = "fusion-reactor-equipment"})
    armor.put({name = "fusion-reactor-equipment"})
    armor.put({name = "fusion-reactor-equipment"})
    armor.put({name = "exoskeleton-equipment"})
    armor.put({name = "exoskeleton-equipment"})
    armor.put({name = "exoskeleton-equipment"})
    armor.put({name = "exoskeleton-equipment"})
    armor.put({name = "personal-roboport-mk2-equipment"})
    armor.put({name = "personal-roboport-mk2-equipment"})
    armor.put({name = "personal-roboport-mk2-equipment"})
    armor.put({name = "personal-roboport-mk2-equipment"})
    armor.put({name = "battery-mk2-equipment"})
    armor.put({name = "battery-mk2-equipment"})
  player.insert{name="construction-robot", count = 100}
  player.insert{name="landfill", count = 500}

  player.insert({name="nuclear-reactor", count=1})
  player.insert({name="heat-exchanger", count=2})
  player.insert({name="steam-turbine", count=4})
  player.insert({name="offshore-pump", count=1})
  player.insert({name="pipe", count=1})
  player.insert({name="uranium-fuel-cell", count=50})
  player.insert({name="substation", count=10})
  player.insert({name="stack-inserter", count=10})
  player.insert({name="roboport", count=5})
  player.insert({name="logistic-robot", count=200})
  player.insert({name="beacon", count=20})
  player.insert({name="speed-module-3", count=50})
  player.insert({name="logistic-chest-requester", count=10})




### Biters
/c game.map_settings.enemy_evolution.time_factor = 0
