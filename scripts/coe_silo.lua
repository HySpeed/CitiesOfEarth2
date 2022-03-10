-- coe_silo.lua

-- MojoD's work to place the silo
function SetSiloTiles(surface, tiles_position)
  -- put tiles at target
  local tiles = {}
  local i = 1
  for dx = -6,6 do
    for dy = -6,6 do
      tiles[i] = {name = "concrete", position = {tiles_position.x+dx+SILO_SHIFT, tiles_position.y+dy+SILO_SHIFT}}
      i=i+1
    end
  end
  for df = -6,6 do
    tiles[i]   = {name = "hazard-concrete-left", position = {tiles_position.x+df+SILO_SHIFT, tiles_position.y-7+SILO_SHIFT}}
    tiles[i+1] = {name = "hazard-concrete-left", position = {tiles_position.x+df+SILO_SHIFT, tiles_position.y+7+SILO_SHIFT}}
    tiles[i+2] = {name = "hazard-concrete-left", position = {tiles_position.x-7+SILO_SHIFT, tiles_position.y+df+SILO_SHIFT}}
    tiles[i+3] = {name = "hazard-concrete-left", position = {tiles_position.x+7+SILO_SHIFT, tiles_position.y+df+SILO_SHIFT}}
    i=i+4
  end
  surface.set_tiles(tiles, true)

end -- SetSiloTiles


function PlaceSilo(surface, silo_position)
  -- Clean the destination area so we can actually create the silo there, hope you didn't have anything there
    for _, entity in pairs(surface.find_entities_filtered{area = {{silo_position.x+10, silo_position.y+11},{silo_position.x+18, silo_position.y+19}}}) do
      if entity.type ~= "character" then entity.destroy() end -- Don't go destroying players
    end

    -- Remove enemy bases
    for _, entity in pairs(surface.find_entities_filtered{area = {{silo_position.x+7, silo_position.y+7},{silo_position.x+21, silo_position.y+21}}, force="enemy"}) do
      if entity.type ~= "character" then entity.destroy() end -- Don't go destroying (enemy) players
    end

    -- Create the silo first to create the chunk (otherwise tiles won't be settable)
    local silo = surface.create_entity{name = "rocket-silo", position = {silo_position.x+SILO_SHIFT, silo_position.y+SILO_SHIFT}, force = "player", move_stuck_players=true}
    silo.destructible = false
    silo.minable = false
    global.coe.silo_created = true;

    log("~Silo Created: " .. silo_position.x .. ", " .. silo_position.y)
end -- PlaceSilo
