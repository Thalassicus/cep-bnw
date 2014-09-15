-- BCD - General
-- Author: Thalassicus
-- DateCreated: 1/13/2011 10:45:16 AM
--------------------------------------------------------------

include("ModTools")

local log = Events.LuaLogger:New()
log:SetLevel("WARN")

function FirstFewCitiesBonus(hexPos, playerID, cityID, newPlayerID)
	local player = Players[playerID]
	if not player then
		log:Warn("Player #%s does not exist", playerID)
	end
	local city = player:GetCityByID(cityID);
	if Game.IsBetween(1, player:GetNumCities(), 3) then
		city:SetNumRealBuilding(GameInfo.Buildings.BUILDING_CAPITAL.ID, 1)
	end
end
LuaEvents.NewCity.Add(function(hexPos, playerID, cityID, newPlayerID) return SafeCall(FirstFewCitiesBonus, hexPos, playerID, cityID, newPlayerID) end)