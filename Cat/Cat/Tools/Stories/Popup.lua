-- TriggerPopup.lua
-- Author: Thalassicus
-- Based on work by: Hipfot, Skodkim, Spatzimaus, and VeyDer
--------------------------------------------------------------

include("InstanceManager");
include("IconSupport");
include("FLuaVector");
include("GameplayUtilities");
include("TriggerUtils");
include( "ThalsUtilities.lua" );

local log = Events.LuaLogger:New()
log:SetLevel("WARN")

function TriggerPopup(player, trigID, targetID)
	local playerID			= player:GetID()
	local activePlayerID	= Game.GetActivePlayer()
	local activeTeamID		= Game.GetActiveTeam()
	local tipTitle			= "TXT_KEY_TRIGGER_" ..trigID
	local tipDesc			= "TXT_KEY_TRIGGER_" ..trigID.. "_DESC"
	local tipPlayer			= Teams[player:GetTeam()]:IsHasMet(activeTeamID) and player:GetName() or Locale.ConvertTextKey("TXT_KEY_DISTANT_PLAYER")
	local tipTarget			= ""
	local trigInfo			= GameInfo.Triggers[trigID]
	local targetType		= trigInfo.TargetClass
	local tarCity, tarPlot, tarHex, tarUnit, tarPlayer
	if trigInfo.UnitClass then
		tarUnitClass		= GameInfo.UnitClasses[trigInfo.UnitClass].Type
		targetType			= targetType or "TARGET_UNIT"
	elseif trigInfo.BuildingClass then
		tarBuildingClass	= GameInfo.BuildingClasses[trigInfo.BuildingClass].Type
		targetType			= targetType or "TARGET_CITY"
	elseif trigInfo.ImprovementType then
		tarImprovement		= GameInfo.Improvements[trigInfo.ImprovementType].ID
		targetType			= targetType or "TARGET_CITY_PLOT"
	elseif trigInfo.Turn then
		if Game.GetGameTurn() ~= trigInfo.Turn then
			return false
		end
	end
	targetType = targetType or "TARGET_GENERIC"
	
	if targetType == "TARGET_CITY" or trigInfo.BuildingClass then
		tarCity		= Map_GetCityByID(targetID)
		tipTarget	= tarCity:IsRevealed(activeTeamID) and tarCity:GetName() or Locale.ConvertTextKey("TXT_KEY_DISTANT_CITY")
	elseif targetType == "TARGET_ANY_PLOT" or targetType == "TARGET_OWNED_PLOT" or trigInfo.ImprovementType then
		tarPlot		= Map.GetPlotByIndex(targetID)
		tarHex		= ToHexFromGrid(Vector2(plot_coords.x, plot_coords.y))
		local nearestCity = tarPlot:GetWorkingCity()
		if nearestCity then
			tipTarget = nearestCity:IsRevealed(activeTeamID) and nearestCity:GetName() or Locale.ConvertTextKey("TXT_KEY_DISTANT_CITY")
		end
	elseif targetType == "TARGET_UNIT" or trigInfo.UnitClass then
		tarUnit		= player:GetUnitByID(targetID)
		tipTarget	= (not tarUnit:IsInvisible(activeTeamID)) and Locale.ConvertTextKey(GameInfo.Units[tarUnit:GetUnitType()].Description) or Locale.ConvertTextKey("TXT_KEY_DISTANT_UNIT")
	elseif targetType == "TARGET_PLAYER" or targetType == "TARGET_CITYSTATE"
		tarPlayer	= Players[targetID]
		tipTarget	= Teams[tarPlayer:GetTeam()]:IsHasMet(activeTeamID) and tarPlayer:GetName() or Locale.ConvertTextKey("TXT_KEY_DISTANT_PLAYER")
	end
	
	if (playerID == activePlayerID) then
		Events.SerialEventHexHighlight(hex, true, Vector4(1.0, 1.0, 0.0, 1))
		UI.LookAt(tarPlot)

		local controlTable	= {}
		Controls.TriggerTitle:LocalizeAndSetText(tipTitle, tipPlayer, tipTarget)
		Controls.TriggerDescription:LocalizeAndSetText(tipDesc, tipPlayer, tipTarget)
		CivIconHookup(playerID, 64, Controls.CivIcon, Controls.CivIconBG, Controls.CivIconShadow, false, true)
		Controls.Triggeroutcomestack:DestroyAllChildren()
	end
	
	if playerID == activePlayerID then
		for outID, outType in ipairs(MapModData.VEM.TrigOutcomes[playerID][trigID][itemID]) do
			local outTitle	= string.format("%s_%s", tipTitle, outID)
			local outDesc	= string.format("%s_OUTCOME_%s", tipTitle, outID)
			local outTip	= string.format("%s_TIP_%s", tipTitle, outID)
			local screenSizeX, screenSizeY = UIManager:GetScreenSizeVal() 

			ContextPtr:BuildInstanceForControl("TriggerOutcomeInstance", out, Controls.TriggerOptionStack)

			out.Name:LocalizeAndSetText(outDesc, tipPlayer, tipTarget)
			local height = out.Name:GetSizeY() + 20
			out.Button:SetSizeY(height)

			if outType == -1 then
				out.MouseOverContainer:SetHide(true)
				out.Button:SetAlpha(0.6)
			else
				out.MouseOverContainer:SetHide(false)
				out.MouseOverContainer:SetSizeY(height + 5)
				out.MouseOverAnim:SetSizeY(height + 5)
				out.MouseOverGrid:SetSizeY(height + 5)
				out.Button:SetAlpha(1.0)
				out.Button:RegisterCallback(
					Mouse.eLClick,
					function()
						assert(loadstring("return " .. GameInfo.Outcomes[outType].Action))(player, targetID)
						outInfo.Action(player, targetID) 
						Events.GameplayFX(hex.x, hex.y, -1)
						Controls.BGBlock:SetHide(true)
					end
					)
			end

			out.Button:LocalizeAndSetToolTip(outTip, tipPlayer, tipTarget)
		end
		Controls.TriggerOptionStack:CalculateSize()
		Controls.TriggerOptionStack:ReprocessAnchoring()
		Controls.TriggerStack:CalculateSize()
		Controls.TriggerStack:ReprocessAnchoring()
		Controls.MainGrid:SetSizeY(100 + Controls.TriggerStack:GetSizeY())
		Controls.MainGrid:SetOffsetY(0.5 * screenSizeY + 10)
		Controls.BGBlock:SetSizeY(Controls.MainGrid:GetSizeY())
		Controls.BGBlock:SetHide(false)
	else
		-- AI player
		local outIndex = 0
		local outIDs = {}
		local outWeight = {}
		local totalWeight = 0.0

		local alignmentWeight = {1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0,1.0}
		local leaderType = GameInfo.Leaders[player:GetLeaderType()].Type

		for outID, outType in ipairs(MapModData.VEM.TrigOutcomes[playerID][trigID][itemID]) do
			if outType ~= -1 then
				outInfo = GameInfo.Outcomes[outType]
				outIndex = outIndex + 1
				outIDs[outIndex] = outID
				outWeight[outIndex] = alignmentWeight[outID] * 1.0
				
				for flavorInfo in GameInfo.Outcome_Flavors(string.format("OutcomeType = '%s'", outType)) do
					for row in GameInfo.Leader_Flavors(string.format("LeaderType = '%s' and FlavorType = '%s'", leaderType, flavorInfo.Type)) do
						outWeight[outIndex] = outWeight[outIndex] * (CiVUP.OUTCOME_FLAVOR_CONSTANT + row.Flavor * CiVUP.OUTCOME_FLAVOR_MULTIPLIER)
					end
				end

				totalWeight = totalWeight + outWeight[outIndex]
			end
		end
		if (totalWeight < 0.01) then
			-- No alignment had any choices.
			outWeight = {1.0,1.0,1.0,1.0}
			totalWeight = outIndex * 1.0
		end
		local chance = Map.Rand(totalWeight * 100,"AI trigger outcome") / 100.0
		for i=1, outIndex do
			if chance < 0 then
				break
			end
			if chance < outWeight[i] then
				for outID, outType in ipairs(MapModData.VEM.TrigOutcomes[playerID][trigID][itemID]) do
					if outType ~= -1 and outID == outIDs[i] then
						log:Debug("AI triggering outcome : triggerID=%s outID=%s action=%s", trigID, outIDs[i], GameInfo.Outcomes[outType].Action)
						assert(loadstring("return " .. GameInfo.Outcomes[outType].Action))(player, targetID)
						chance = -999.0
					end
				end
			else
				chance = chance - outWeight[i]
			end
		end
	end
end