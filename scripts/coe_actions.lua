-- coe_actions.lua

--==============================================================================

-- if called from UI, 'frame' will have a link to the UI dropdown
-- if called from OnPlayerJoined, 'destination_name' will have the city name
function TPtoCity(player, frame, destination_name)
  if( destination_name == nil ) then
    local ui_city_list = frame.coe_cities_dropdown
    destination_name = ui_city_list.get_item(ui_city_list.selected_index)
  end
  local destination = CalcTPOffset(destination_name)

  PerformTeleport(player, destination, destination_name)
end -- TPtoCity

--------------------------------------------------------------------------------

function TeleportToPlayer(player, frame)
  local ui_player_list = frame.coe_players_dropdown
  local target_player_name = ui_player_list.get_item(ui_player_list.selected_index)
  local target_player = GetPlayerByName(target_player_name)
  local destination = target_player.position

  PerformTeleport(player, destination, target_player_name)
end -- TeleportToPlayer

--------------------------------------------------------------------------------

-- teleports player after checking if target is safe - loops until success / limit
function PerformTeleport(player, destination, destination_name) 

  CheckAndCreateChunk(destination)

  -- loop until valid teleport destination can be found
  local valid_dest = false
  local count = 0
  while valid_dest == false and count <= 100 do
    if global.coe.surface.can_place_entity({name="character", position = destination}) then
      valid_dest = true
    else
      destination.x = destination.x + GetRandomAmount(WOBBLE/2)
      destination.y = destination.y + GetRandomAmount(WOBBLE/2)
    end
    count = count + 1 -- limits to prevent infinate loop
  end

  local result = false
  if valid_dest then
    game.print({"",  {"coe.text-mod-print-name"}, {"coe.text-teleported"}, player.name, {"coe.text-to"}, destination_name, "  (", destination.x, ",", destination.y, ") "})
    result = player.teleport(destination, global.coe.surface)
  end
  
  if result == false then
    game.print({"",  {"coe.text-mod-print-name"}, {"coe.text-unable-to-teleport"}, player.name, {"coe.text-to"}, destination_name, "  (", destination.x, ",", destination.y, ") ", {"coe.text-count"}, count})
  end
end -- PerformTeleport

--------------------------------------------------------------------------------

function CheckAndCreateChunk(position)
  local surface = global.coe.surface
  if surface.is_chunk_generated(position) then return end
  surface.request_to_generate_chunks(position, 1)
  surface.force_generate_chunk_requests()
end -- CheckAndCreateChunk

--------------------------------------------------------------------------------

function CheckAndPlaceSilo(event)  
  if global.coe.pre_place_silo and not global.coe.silo_created then
    local silo_position = CalcTPOffset(global.coe.silo_city_name)
      --create tiles around silo when generating chunk (for performance, do it only when chunk is generated, not before)
    if ((event.area.left_top.x  <= silo_position.x+7  and silo_position.x+7  <= event.area.right_bottom.x)  or
        (event.area.left_top.x  <= silo_position.x+21 and silo_position.x+21 <= event.area.right_bottom.x)) and
       ((event.area.left_top.y  <= silo_position.y+7  and silo_position.y+7  <= event.area.right_bottom.y)  or
        (event.area.left_top.y  <= silo_position.y+21 and silo_position.y+21 <= event.area.right_bottom.y)) then
          PlaceSilo(global.coe.surface, silo_position)
          SetSiloTiles(global.coe.surface, silo_position)
    end
  end

end -- CheckAndPlaceSilo

--------------------------------------------------------------------------------

function RecordRocketLaunch(event)
  if global.coe.launches_per_death <= 0 then return end

  local rocket = event.rocket
  if not (rocket and rocket.valid) then return end

  global.coe.launch_success = global.coe.launch_success or false
  if global.coe.launch_success then return end

  --  check contents of rocket - do not count empty rockets
  if event.rocket.has_items_inside() then
    global.coe.rockets_launched = global.coe.rockets_launched + 1
    if global.coe.rockets_launched >= global.coe.launches_to_win then
      global.coe.launch_success = true
      game.set_game_state
      {
        game_finished = true,
        player_won = true,
        can_continue = true,
        victorious_force = rocket.force
      }
      return
    else
      game.print({"",  {"coe.text-mod-print-name"}, tostring(global.coe.rockets_launched),  {"coe.text-rockets-launched"}, ""})
      game.print({"",  {"coe.text-mod-print-name"}, tostring(global.coe.launches_to_win - global.coe.rockets_launched), {"coe.text-more-rockets"}, ""})
    end
  else
    game.print({"",  {"coe.text-mod-print-name"}, {"coe.text-empty-rocket"}})
    game.print({"",  {"coe.text-mod-print-name"}, tostring(global.coe.launches_to_win - global.coe.rockets_launched), {"coe.text-more-rockets"}, ""})
  end

end --RecordRocketLaunch

--------------------------------------------------------------------------------

function RecordPlayerDeath(event)
  if global.coe.launches_per_death <= 0 or global.coe.launch_success then return end

  global.coe.launches_to_win = global.coe.launches_to_win + global.coe.launches_per_death
  game.print({"",  {"coe.text-mod-print-name"},  {"coe.text-death-of"}, game.players[event.player_index].name, {"coe.text-increased-launches"}, tostring(global.coe.launches_per_death)})
  game.print({"",  {"coe.text-mod-print-name"},  tostring(global.coe.launches_to_win - global.coe.rockets_launched), {"coe.text-more-rockets"}, ""})
end -- RecordPlayerDeath

--------------------------------------------------------------------------------

