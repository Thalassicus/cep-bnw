-- VED_General
-- Author: Thalassicus
-- DateCreated: 4/15/2012 10:15:07 PM
--------------------------------------------------------------

include("ModTools")

local log = Events.LuaLogger:New()
log:SetLevel("INFO")

function ResetCsFriendships(lostPlayerID)
	lostPlayer = Players[lostPlayerID]
	if lostPlayer:IsAlive() or lostPlayer:IsMinorCiv() then
		return
	end
	log:Info("Reset %s friendship with minor civs", lostPlayer:GetName())
	for minorCivID, minorCiv in pairs(Players) do
		if minorCiv:IsMinorCiv() and minorCiv:GetMinorCivFriendshipWithMajor(lostPlayerID) ~= 0 then
			log:Info("  %s", minorCiv:GetName())
			minorCiv:SetFriendship(lostPlayerID, 0)
		end
	end
end

-- The player may have opted for "complete kills"
function OnUnitKilledInCombat(wonPlayerID, lostPlayerID)
	ResetCsFriendships(lostPlayerID)
end
GameEvents.UnitKilledInCombat.Add(OnUnitKilledInCombat) 

function OnCityCaptureComplete(lostPlayerID, isCapital, x, y, wonPlayerID)
	ResetCsFriendships(lostPlayerID)
end
GameEvents.CityCaptureComplete.Add(OnCityCaptureComplete)