--[[
CityLimits by Kilandor

if GameInfo.Civup.SHOW_CITY_LIMITS.Value ~= 1 then
	return
end

include('FLuaVector');

cityPlots = {};


function OnEnterCityScreen()
	ShowCityLimits();
end
Events.SerialEventEnterCityScreen.Add(OnEnterCityScreen);

function OnExitCityScreen()
	HideCityLimits();
end
Events.SerialEventExitCityScreen.Add(OnExitCityScreen);

function OnSelectUnit()
	ClearTables();
	ShowAllCityLimits();
	ShowCityLimits();
end
Events.UnitSelectionChanged.Add(OnSelectUnit);

function OnUnitMoveHex(playerID, unitID)
	if playerID ~= nil then
		local unit = Players[ playerID ]:GetUnitByID( unitID );
		if unit ~= nil and unit:MovesLeft() > 0 then
			UpdateCityLimits(unit);
		end
	end
end
Events.SerialEventUnitMoveToHexes.Add(OnUnitMoveHex);

function OnUnitMoveTele(i, j, playerID, unitID)
	if playerID ~= nil then
		local unit = Players[ playerID ]:GetUnitByID( unitID );
		if unit ~= nil and unit:MovesLeft() > 0 then
			UpdateCityLimits(unit);
		end
	end
end
Events.SerialEventUnitTeleportedToHex.Add(OnUnitMoveTele);

function UpdateCityLimits(unit)
	local pHeadSelectedUnit = UI.GetHeadSelectedUnit();
	local lastUnit = UI.GetLastSelectedUnit();
	if unit == pHeadSelectedUnit and pHeadSelectedUnit:GetUnitType() == 0 then
		ClearTables();
		ShowAllCityLimits();
		ShowCityLimits();
	elseif unit == lastUnit and lastUnit:GetUnitType() == 0 then
		ClearTables();
		ShowAllCityLimits();
		ShowCityLimits();
	end
end

function ShowCityLimits(city)
	local pHeadSelectedCity = UI.GetHeadSelectedCity();
	local pHeadSelectedUnit = UI.GetHeadSelectedUnit();
	
	local iRange = 3;
	local thisPlot = nil;
	local thisX;
	local thisY;
	local isCity = 0;

	if city ~= nil then
		pHeadSelectedCity = city;
	end

	if pHeadSelectedCity and UI.GetInterfaceMode() ~= InterfaceModeTypes.INTERFACEMODE_CITY_RANGE_ATTACK then
		thisPlot = pHeadSelectedCity:Plot();
		thisX = pHeadSelectedCity:GetX();
		thisY = pHeadSelectedCity:GetY();
		isCity = 1;
	elseif pHeadSelectedUnit and pHeadSelectedUnit:GetUnitType() == 0 then
		thisPlot = pHeadSelectedUnit:GetPlot();
		thisX = pHeadSelectedUnit:GetX();
		thisY = pHeadSelectedUnit:GetY();
	end
	if thisPlot then
		for iDX = -iRange, iRange do
			for iDY = -iRange, iRange do
				local pTargetPlot = Map.GetPlotXY(thisX, thisY, iDX, iDY);

				if pTargetPlot then
					local plotX = pTargetPlot:GetX();
					local plotY = pTargetPlot:GetY();
					local plotDistance = Map.PlotDistance(thisX, thisY, plotX, plotY);
					
					if plotDistance <= iRange then
						local hexID = ToHexFromGrid( Vector2( plotX, plotY) );
						
						if city ~= nil then
							table.insert(cityPlots, pTargetPlot);
						end
						
						if isCity == 1 then
							Events.SerialEventHexHighlight(hexID, true, Color(1, 0, 1, 1), 'MovementRangeBorder'); -- Color doesn't matter
						else
							CheckOverlaps(pTargetPlot);
							Events.SerialEventHexHighlight(hexID, true, Color(1, 0, 1, 1), 'GroupBorder'); -- Color doesn't matter
						end
					end
				end
			end
		end
	end
end

function HideCityLimits()
	Events.ClearHexHighlights();
end

function ShowAllCityLimits()
	local player = Players[Game.GetActivePlayer()]
	for pCity in player:Cities() do
		ShowCityLimits(pCity);
	end
end

function CheckOverlaps(plot)
	for i, tmpPlot in ipairs(cityPlots) do
		if tmpPlot == plot then
			local hexID = ToHexFromGrid( Vector2( plot:GetX(), plot:GetY()) );
			Events.SerialEventHexHighlight(hexID, true, Color(1, 0, 1, 1), 'ValidFireTargetBorder'); -- Color doesn't matter
			break;
		end
	end
end

function ClearTables()
	cityPlots = {};
end
--]]