-- YieldLibrary - Event Registration
-- Author: Thalassicus
-- DateCreated: 2/12/2011 9:42:55 AM
--------------------------------------------------------------

--include("CustomNotification.lua")
include("YieldLibrary.lua")

local log = Events.LuaLogger:New()
log:SetLevel("INFO")

PlayerClass = getmetatable(Players[0]).__index

LuaEvents.DirtyYieldCacheCity			.Add(ResetYieldCacheCity)
LuaEvents.DirtyYieldCachePlayer			.Add(ResetYieldCachePlayer)
LuaEvents.DirtyYieldCacheAll			.Add(ResetYieldCacheAll)
LuaEvents.NewPolicy						.Add(ResetYieldCacheAll)
LuaEvents.NewTech						.Add(ResetYieldCacheAll)
LuaEvents.PlotChanged					.Add(ResetYieldCacheAll)
LuaEvents.BuildingConstructed			.Add(ResetYieldCacheAll)
LuaEvents.ActivePlayerTurnEnd_Player	.Add(ResetYieldCacheAll)
LuaEvents.ActivePlayerTurnEnd_City		.Add(City_UpdateModdedYields)
--LuaEvents.ActivePlayerTurnStart_Player	.Add(PlayerClass.UpdateModdedHappiness)
--LuaEvents.ActivePlayerTurnEnd_Player	.Add(PlayerClass.UpdateModdedYieldsEnd)
--LuaEvents.ActivePlayerTurnStart_Player	.Add(PlayerClass.UpdateModdedYieldsStart)

--[[
Events.SerialEventGameDataDirty.Add(function()
	for playerID, player in pairs(Players) do
		-- unsure why core CvPlayer::DoUpdateHappiness() function is creating weird happiness values, but this seems to reset things
		player:SetHappiness(player:GetYieldRate(YieldTypes.YIELD_HAPPINESS_NATIONAL) + player:GetUnhappiness())
	end
end)
--]]

--LuaEvents.ActivePlayerTurnStart_Player.Add(UpdatePlayerRewardsFromMinorCivs)

--[[
LuaEvents.NotificationOverrideAddin({
	type="NOTIFICATION_STARVING",
	override=function(tooltip,summary,value1,value2)
		--LuaEvents.CustomStarving();
	end
})
--]]

function FinishAgriculture()
	for playerID, player in pairs(Players) do
		if player:IsAliveCiv() then
			local techID = GameInfo.Technologies.TECH_AGRICULTURE.ID
			player:SetYieldStored(YieldTypes.YIELD_SCIENCE, 1, techID)
			--log:Warn("%s agriculture science = %s/%s", player:GetName(), player:GetYieldStored(YieldTypes.YIELD_SCIENCE, techID), player:GetYieldNeeded(YieldTypes.YIELD_SCIENCE, techID))
		end
	end
end
--Events.SequenceGameInitComplete.Add(FinishAgriculture)