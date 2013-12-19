-- Trigger
-- Author: Thalassicus
-- Based on work by: Hipfot, Skodkim, Spatzimaus, and VeyDer
--------------------------------------------------------------

include("TriggerUtils.lua")

local log = Events.LuaLogger:New()
log:SetLevel("WARN")

MapModData.VEM.TriggerTable		= {}
MapModData.VEM.TriggerLogTable	= {}
MapModData.VEM.TriggerSchedule	= {}

function TriggerHandler()
	log:Info("TriggerHandler")
	
	if not MapModData.VEM.HasEventRunPlot then
		MapModData.VEM.HasEventRunPlot = {}
		for plotID, plot in Plots() do
			MapModData.VEM.HasEventRunPlot[plotID] = LoadValue("MapModData.VEM.HasEventRunPlot[%s]", plotID)
		end
	end

	if Game.GetGameTurn() < (CiVUP.EVENTS_EARLIEST_TURN * GameInfo.GameSpeeds[Game.GetGameSpeedType()].VictoryDelayPercent / 100) then
		--return
	end
	
	-- events scheduled for a given turn
	local schedule		= MapModData.VEM.TriggerSchedule[Game.GetGameTurn()] or {}
	local is_scheduled	= false
	if #schedule > 0 then
		-- deal with scheduled events
		is_scheduled = TriggerHandlerProcess(schedule, true)
	end
	
	if not is_scheduled then
		-- randomize the order of the events
		local event_table	= {}
		for _i, event in pairs(MapModData.VEM.TriggerTable) do
			table.insert(event_table, event)
			log:Trace("Insert %s", _i)
		end
		_Shuffle(event_table)
		TriggerHandlerProcess(event_table, false)
	end
end
Events.ActivePlayerTurnStart.Add(TriggerHandler)

function TriggerHandlerProcess(event_table, scheduled)
	log:Info("TriggerHandlerProcess")
	local func_ret	= false
	local aID	= Game.GetActivePlayer()

	for index,pPlayer in pairs(Players) do
		--pPlayer = Players[aID] -- debug
		if (pPlayer:IsAlive() and not (pPlayer:IsMinorCiv() or pPlayer:IsBarbarian())) then
			-- Don't want dead civs, minor civs, or barbarians to get events.
			local playerID	= pPlayer:GetID()

			-- cycle through events
			for event_i, event in pairs(event_table) do
				log:Trace("Checking %s", event_i)

				-- perform an event condition check, only if the event would occur
				-- The old logic would block the event if you gave this condition to all outcomes, but this is faster
				local event_valid = true
				if type(event.condition) == "function" then
					event_valid = event.condition(pPlayer)
					log:Trace(" condition==function : %s", event_valid)
				end
				if (event.this_event_limit ~= nil) then
					-- Sometimes, we want an event to lock itself out for a time.
					local thisLimit = event.this_event_limit
					local CheckThis = UserEventLastAppeared(event.id, playerID)
					--if (playerID == 0) then
						--print(playerID, event.id, thisLimit, CheckThis)
					--end
					if (thisLimit > 0) then
					-- a positive value means ban if this particular event has happened recently
						if ((Game:GetGameTurn() - CheckThis) < thisLimit) then
							log:Trace(" occured recently")
							event_valid = false
						end
					elseif (thisLimit < 0) then
					-- a value of -1 means ban if this event has EVER occurred
						if (CheckThis >= 0) then
							log:Trace(" occured ever")
							event_valid = false
						end
					end
				end
				if (event.any_event_limit ~= nil) then
					-- Sometimes, we want events to ALL lock each other out for a brief period.
					local TimeCheckAny = Game:GetGameTurn() - AnyUserEventLastAppeared(playerID) -- No two events should be within a few turns of each other, ever.
					if (TimeCheckAny < event.any_event_limit) then
						log:Trace(" any event recently")
						event_valid = false
					end
				end

				if (event_valid) then
					log:Trace("%s prob = %s", event.id, event.probability)
					local rand_res = math.random(20000) / (20000.0)
					local test_prob = event.probability
					--print(" before: ", event.id, test_prob)
--					test_prob = test_prob * AlignMult(playerID, event.alignment) -- ranges from 0.5 to 1.5, more or less.
					test_prob = test_prob -- ranges from 0.5 to 1.5, more or less.
					--print(" after: ", event.id, test_prob)
					if scheduled or rand_res < test_prob then
						local is_valid_event	= false
						local valid_elems		= {}

						for option_i, option in pairs(event.options) do
							local is_valid_option	= true
							if type(option.condition) == "function" then
								is_valid_option	= false
								-- check the cities and surrounding plots
								for city in pPlayer:Cities() do
									local cityID	= city:GetID()

									for i = 0, city:GetNumCityPlots() - 1, 1 do
										local plot	= city:GetCityIndexPlot(i)
										if plot ~= nil and plot:GetOwner() == playerID then
											if not MapModData.VEM.HasEventRunPlot[Plot_GetID(plot)] then
												local params	= { playerID, cityID, nil, { x = plot:GetX(), y = plot:GetY() } }
												local cond_res	= option.condition(pPlayer, city, nil, plot)
												if cond_res then
													is_valid_option	= true
													table.insert(valid_elems, params)
												end
											end
										end
									end -- for i
								end -- for city

								-- check the units
								for unit in pPlayer:Units() do
									local unitID	= unit:GetID()
									local unit_plot	= unit:GetPlot()
									local unit_params	= { playerID, nil, unitID, { x = unit_plot:GetX(), y = unit_plot:GetY() } }
									local cond_res	= option.condition(pPlayer, nil, unit, unit_plot)
									if cond_res then
										is_valid_option	= true
										table.insert(valid_elems, unit_params)
									end
								end -- for unit
							end -- if type (option.condition) == "function"

							MapModData.VEM.TriggerTable[event.id].options[option_i].is_valid	= is_valid_option
							if is_valid_option then
								is_valid_event = true
							end
						end -- for option_i, option
			
						if is_valid_event then
							_Shuffle(valid_elems)
							MapModData.VEM.TriggerTable[event.id]._elem = valid_elems[1]
							local plotID = MapModData.VEM.TriggerTable[event.id]._elem[4]
							if plotID then
								plotID = Plot_GetID(Map.GetPlot(plotID.x, plotID.y))
								MapModData.VEM.HasEventRunPlot[plotID] = true
								SaveValue(true, "MapModData.VEM.HasEventRunPlot[%s]", plotID)
							end
							UserEventLog(event.id, playerID)
							LuaEvents.TriggerPopupBuild(event)

							func_ret = true
							if not scheduled then
								break
							end
						end
					end -- if scheduled or rand_res < event.probability
				end -- If we met the event condition (if any)
			end -- for event_i, event
		end -- Valid player?
	end -- loop over players
	return func_ret
end


function UserEventAdd(event_data)
	log:Trace("UserEventAdd: %s", event_data.id)
	-- data manipulation / sanitizing goes here

	-- add the event to the events table
	MapModData.VEM.TriggerTable[event_data.id]	= event_data
	
end

function UserEventAddSchedule(event_id, game_turn)
	local turn_schedule = MapModData.VEM.TriggerSchedule[game_turn] or {}
	for _, event in pairs(MapModData.VEM.TriggerTable) do
		if event.id == event_id then
			table.insert(turn_schedule, event)
			break
		end
	end
	MapModData.VEM.TriggerSchedule[game_turn] = turn_schedule

end

function UserEventHasAppeared(event_id)
	for log_event_id, _ in pairs(MapModData.VEM.TriggerLogTable) do
		if log_event_id == event_id then
			return true
		end
	end
	return false
end

function UserEventLastAppeared(event_id, player_id)
	local event_log	= MapModData.VEM.TriggerLogTable[event_id]
--print("UserEventLastAppeared ", event_id, player_id)

	if event_log == nil or not #event_log.history then
		return -99
	end
--print("UserEventLastAppeared # ",#event_log.history)

	event_log	= event_log.history

	local game_turn	= -99
	for _, log_entry in pairs(event_log) do
--print("log check: ",log_entry.player,log_entry.turn)
		if log_entry.player == player_id and log_entry.turn > game_turn then
			game_turn	= log_entry.turn
		end
	end
--	if game_turn == -99 then
--		return nil
--	end
	return game_turn
end

function AnyUserEventLastAppeared(player_id)
-- I made this!
	local game_turn = -99
	if(player_id ~= nil) then
		local log_event_id=""
		local event_log

		for log_event_id, _ in pairs(MapModData.VEM.TriggerLogTable) do
			if (log_event_id ~= 0) then
				local testval = UserEventLastAppeared(log_event_id, player_id)
				if (testval > game_turn) then game_turn = testval end
			end
		end
	end

	return game_turn
end

function UserEventLog(event_id, player_id)
	--print("UserEventLog",event_id,player_id)
	local log_entry	= MapModData.VEM.TriggerLogTable[event_id] or {}

	local game_turn		= Game.GetGameTurn()
	log_entry.last_on	= game_turn
	log_entry.turn	= game_turn
	local event_history	= log_entry.history or {}
	table.insert(event_history, { player	= player_id, turn	= game_turn })
	log_entry.history	= event_history

	MapModData.VEM.TriggerLogTable[event_id] = log_entry
end

function UserEventNumAppeared(event_id)
	local event_log = MapModData.VEM.TriggerLogTable[event_id]
	if event_log == nil then
		return 0
	end
	return #event_log.history
end

function UserEventNumAppearedForPlayer(event_id, player_id)
	local event_log	= MapModData.VEM.TriggerLogTable[event_id]
	if event_log == nil or not #event_log.history then
		return 0
	end

	event_log	= event_log.history

	local cnt	= 0
	for _, log_entry in pairs(event_log) do
		if log_entry.player == player_id then
			cnt	= cnt + 1
		end
	end
	return cnt
end

