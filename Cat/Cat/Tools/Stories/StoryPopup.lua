-- StoryPopup.lua
-- Author: Thalassicus
-- Based on work by: Hipfot, Skodkim, Spatzimaus, and VeyDer
--------------------------------------------------------------

include("InstanceManager");
include("IconSupport");
include("FLuaVector");
include("GameplayUtilities");
include("YieldLibrary.lua");
include("Story_Events.lua");

local startClockTime = os.clock()

local log = Events.LuaLogger:New()
log:SetLevel("INFO")

function GetAlignmentWeight(player, outcomeOrder)
	return 1.0
end

function DoTriggerPopup(player, trigID, targetID)
	local playerID			= player:GetID()
	local activePlayerID	= Game.GetActivePlayer()
	local activeTeamID		= Game.GetActiveTeam()
	local activePlayer		= Players[activePlayerID]
	local trigInfo			= GameInfo.Triggers[trigID]
	local targetType		= trigInfo.Target
	local tipTitle			= string.format("TXT_KEY_TRIGGER_%s", trigInfo.Type)
	local tipDesc			= string.format("TXT_KEY_TRIGGER_%s_DESC", trigInfo.Type)
	local tipPlayer			= Teams[player:GetTeam()]:IsHasMet(activeTeamID) and player:GetName() or Locale.ConvertTextKey("TXT_KEY_DISTANT_PLAYER")
	local tipTarget			= ""
	local screenSizeX, screenSizeY = UIManager:GetScreenSizeVal() 
	local tarCity, tarPlot, tarHex, tarUnit, tarPlayer
	
	if targetType == "TARGET_CITY" or trigInfo.BuildingClass then
		tarCity		= Map_GetCity(targetID)
		tarPlot		= tarCity:Plot()
		tipTarget	= tarCity:IsRevealed(activeTeamID) and tarCity:GetName() or Locale.ConvertTextKey("TXT_KEY_DISTANT_CITY")
	elseif targetType == "TARGET_ANY_PLOT" or targetType == "TARGET_OWNED_PLOT" or trigInfo.ImprovementType then
		tarPlot		= Map.GetPlotByIndex(targetID)
		local nearestCity = tarPlot:GetWorkingCity()
		if nearestCity then
			tipTarget = nearestCity:IsRevealed(activeTeamID) and nearestCity:GetName() or Locale.ConvertTextKey("TXT_KEY_DISTANT_CITY")
		end
	elseif targetType == "TARGET_UNIT" or trigInfo.UnitClass then
		tarUnit		= player:GetUnitByID(targetID)
		tarPlot		= tarUnit:GetPlot()
		tipTarget	= (not tarUnit:IsInvisible(activeTeamID)) and Locale.ConvertTextKey(GameInfo.Units[tarUnit:GetUnitType()].Description) or Locale.ConvertTextKey("TXT_KEY_DISTANT_UNIT")
	elseif targetType == "TARGET_PLAYER" or targetType == "TARGET_CITYSTATE" then
		tarPlayer	= Players[targetID]
		log:Warn("Citystate Trigger %s", tarPlayer:GetName())
		tipTarget	= activePlayer:HasMet(tarPlayer) and tarPlayer:GetName() or Locale.ConvertTextKey("TXT_KEY_DISTANT_PLAYER")
		if targetType == "TARGET_CITYSTATE" then
			tarPlot	= tarPlayer:GetCapitalCity():Plot()
		end
	end
	
	if playerID == activePlayerID then
		local controlTable	= {}

		if tarPlot then
			tarHex = ToHexFromGrid(Vector2(tarPlot:GetX(), tarPlot:GetY()))
			Events.SerialEventHexHighlight(tarHex, true, Vector4(1.0, 1.0, 0.0, 1))
			UI.LookAt(tarPlot)
		end

		Controls.TriggerTitle:LocalizeAndSetText(tipTitle, tipPlayer, tipTarget)
		--log:Info("%s", Locale.ConvertTextKey(tipDesc, tipPlayer, tipTarget))
		Controls.TriggerDescription:LocalizeAndSetText(tipDesc, tipPlayer, tipTarget)
		CivIconHookup(playerID, 64, Controls.CivIcon, Controls.CivIconBG, Controls.CivIconShadow, false, true)
		Controls.OutcomeStack:DestroyAllChildren()

		for outInfo in GameInfo.Outcomes(string.format("TriggerType = '%s'", trigInfo.Type)) do
			local out			= {}
			local outID			= outInfo.ID
			local outOrder		= outInfo.Order
			local outTitle		= string.format("%s_%s", tipTitle, outOrder)
			local outDesc		= string.format("%s_OUTCOME_%s", tipTitle, outOrder)
			local outTip		= ""
			local outTipExtra	= Locale.ConvertTextKey(string.format("%s_TIP_%s", tipTitle, outOrder), tipPlayer, tipTarget)
			local outCost		= outInfo.GoldCost

			if trigInfo.Target ~= "TARGET_CITYSTATE" then
				outCost = Game.Round(outCost * Game.GetSpeedYieldMod(YieldTypes.YIELD_GOLD), -1)
			end

			if outCost ~= 0 then
				outTip = outTip .. "[NEWLINE]" .. Locale.ConvertTextKey(
					"TXT_KEY_TRIGGER_YIELD_COST",
					"[ICON_GOLD]",
					"",
					outCost
				)
			end
			if outInfo.YieldType then
				local yieldInfo = GameInfo.Yields[outInfo.YieldType]
				outTip = outTip .. "[NEWLINE]" .. Locale.ConvertTextKey(
					"TXT_KEY_TRIGGER_YIELD_PER_TURN",
					yieldInfo.IconString,
					Locale.ConvertTextKey(yieldInfo.Description),
					"+",
					outInfo.Yield
				)
			end
			
			if not string.find(outTipExtra, "TXT_KEY") then
				outTip = outTip .. "[NEWLINE]" .. outTipExtra
			end
			outTip = Game.RemoveExtraNewlines(outTip)

			ContextPtr:BuildInstanceForControl("OutcomeInstance", out, Controls.OutcomeStack)

			out.Button:SetToolTipString(outTip)

			out.Name:LocalizeAndSetText(outDesc, tipPlayer, tipTarget)
			local height = out.Name:GetSizeY() + 20
			out.Button:SetSizeY(height)

			if not MapModData.Cep_TrigOutcomes[playerID][trigID][targetID][outInfo.Order] then
				out.MouseOverContainer:SetHide(true)
				out.Button:SetAlpha(0.6)
			else
				out.MouseOverContainer:SetHide(false)
				out.MouseOverContainer:SetSizeY(height + 5)
				out.MouseOverAnim:SetSizeY(height + 5)
				out.MouseOverGrid:SetSizeY(height + 5)
				out.Button:SetAlpha(1.0)
				if tarPlot then 
					out.Button:RegisterCallback(Mouse.eMouseEnter, function()
						UI.LookAt(tarPlot)
					end)
				end
				out.Button:RegisterCallback(
					Mouse.eLClick,
					function()
						local message = Locale.ConvertTextKey(string.format("%s_ALERT_%s", tipTitle, outOrder), tipPlayer, tipTarget)
						--log:Debug("%s\n", message)
						if tarHex then
							Events.GameplayFX(tarHex.x, tarHex.y, -1)
						end
						Events.GameplayAlertMessage(message)
						Controls.Background:SetHide(true)
						player:ChangeYieldStored(YieldTypes.YIELD_GOLD, -1 * outCost)
						assert(loadstring("return "..outInfo.Action))()(playerID, trigID, targetID, outID)
					end
				)
			end
		end
		Controls.OutcomeStack:CalculateSize()
		Controls.OutcomeStack:ReprocessAnchoring()
		Controls.MainStack:CalculateSize()
		Controls.MainStack:ReprocessAnchoring()
		Controls.MainBox:SetSizeY(100 + Controls.MainStack:GetSizeY())
		--Controls.MainBox:SetOffsetY(0.5 * screenSizeY + 40)
		Controls.Background:SetSizeY(Controls.MainBox:GetSizeY())
		Controls.Background:SetHide(false)
	else
		local outWeights	= {}
		local leaderType	= GameInfo.Leaders[player:GetLeaderType()].Type
		
		-- calculate weights
		for outInfo in GameInfo.Outcomes(string.format("TriggerType = '%s'", trigInfo.Type)) do
			local outID = outInfo.ID
			if not MapModData.Cep_TrigOutcomes[playerID][trigID][targetID][outInfo.Order] then
				outWeights[outID] = 0
			else
				outInfo	= GameInfo.Outcomes[outID]
				outWeights[outID] = GetAlignmentWeight(player, outInfo.Order) * 1.0
				
				for flavorInfo in GameInfo.Outcome_Flavors(string.format("OutcomeType = '%s'", outInfo.Type)) do
					for row in GameInfo.Leader_Flavors(string.format("LeaderType = '%s' and FlavorType = '%s'", leaderType, flavorInfo.OutcomeType)) do
						outWeights[outID] = outWeights[outID] * (Cep.OUTCOME_FLAVOR_CONSTANT + row.Flavor * Cep.OUTCOME_FLAVOR_MULTIPLIER)
					end
				end
				
				outWeights[outID] = math.max(0, outWeights[outID])
			end
		end
		if outWeights == {} then
			log:Error("%15s %20s %3s %-4s empty outcome table for %s", " ", player:GetName(), " ", " ", trigInfo.Type)
			return
		end
		
		local outID = Game.GetRandomWeighted(outWeights)
		if outID == -1 then
			log:Info("%15s %20s %3s %-4s no valid outcomes for %s", " ", player:GetName(), " ", " ", trigInfo.Type)
			return
		end
		local outInfo = GameInfo.Outcomes[outID]
		local outCost = outInfo.GoldCost
		if trigInfo.Target ~= "TARGET_CITYSTATE" then
			outCost = Game.Round(outCost * Game.GetSpeedYieldMod(YieldTypes.YIELD_GOLD), -1)
		end
		local message = Locale.ConvertTextKey(string.format("%s_ALERT_%s", tipTitle, outInfo.Order), tipPlayer, tipTarget)		
		--log:Trace("AI triggering outcome : triggerID=%s outID=%s action=%s", trigID, outID, GameInfo.Outcomes[outID].Action)
		--log:Debug(message)
		
		log:Info("%-15s %20s %3s/%-4s PAID for story                %s", "AIPurchase", player:GetName(), outCost, player:GetYieldStored(YieldTypes.YIELD_GOLD), outInfo.Type)
		player:ChangeYieldStored(YieldTypes.YIELD_GOLD, -1 * outCost)
		assert(loadstring("return " .. outInfo.Action))(playerID, trigID, outID, targetID)
		Events.GameplayAlertMessage(message)
	end
end
LuaEvents.TriggerPopup.Add(DoTriggerPopup)

print(string.format("%3s ms loading StoryPopup.lua", Game.Round((os.clock() - startClockTime)*1000)))