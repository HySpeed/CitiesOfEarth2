# CitiesOfEarth 2
A Factorio mod that adds a city areas list and teleports to Factorio Earth
Release **2** changes the center of the world to the Pacific Ocean. 
Africa is at the far left | America to the right.  The result is the Russia -- Alaska connection is in the center of the map.
This will allow for a small land bridge to be built that connects the two major land masses.
The features have been simplified:
* No alien adjustments - teleporting to a location that has not been cleared of enemy may be dangerous.
* No teams.  This feature can be re-added | but it only allowed for different research progress and didn't seem to be used.
* No "created" resources at city.

## Requirements

**When first starting a new game | there will be a long delay while the map initializes.**


## **Initial Spawn Point**

* City: Africa | Mali | Bamako
* Atlantic Spawn: 1920 | 840
* Pacific Spawn :  100 | 870
* * These numbers will automatically adjust by scale & detail.
* * After map creation | the spawn point is set to 0,0.  All teleports are relative to 0,0.
The game sets the rest of the map based on this.  


## Worlds | Regions | and Cities

There are two 'worlds'.  Both are Earth.  
* Atlantic - The center of the map is the Atlantic Ocean.  This puts America on the 'right' side and Africa & Europe on the 'left' side of the game map.  This is the traditional view of Earth on a map.
* Pacific - The center of the map is the Pacific Ocean.  This puts Africa & Europe on the 'left' side and America on the 'right' side of the game map.  This allows for a connection between Russia and Alaska to be built.

This is a list of the regions and cities | found in 'data/cities.lua':
| Continent       | Region         | City        |
|:----------------|:---------------|:------------|
| Africa          | Mali           | Bamako      |
| Africa          | Congo          | Katanga     |
| Africa          | Chad           | Mongo       |
| Africa          | Egypt          | Cairo       |
| Africa          | Morocco        | Marrakech   |
| Asia            | China          | Beijing     |
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
| Europe          | Russia         | Pechora     |
| Europe          | Russia         | Yakutsk     |
| Europe          | Spain          | Madrid      |
| North America   | Canada         | Brisay      |
| North America   | Canada         | Kapuskasing |
| North America   | Canada         | Saskatoon   |
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

City information was pulled from [Mapcarta](https://mapcarta.com/).


## To Do:
* none

## Known Issues:
* **You must delete mod-settings.dat for changes to cities.lua to appear.**  So if you change a lua data file | you'll need to delete the mod-settings.dat file.

v1.0.0
* Using new map - Pacific | swapped continents to put Russia - Alaska connection in the center.
* Included Factorio World loading code | removing dependency on Factorio Earth.
* Removed teams
* Removed Alien adjustment
* Removed resource spawn


## Helpful commands:
### Charting
* chart around player for 500
* /c local player = game.player; local pos = player.position; local rad=500; player.force.chart(player.surface | {{x = pos.x-rad | y = pos.y-rad} | {x = pos.x+rad | y = pos.y+rad}});
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

### Biters
/c game.map_settings.enemy_evolution.time_factor = 0
