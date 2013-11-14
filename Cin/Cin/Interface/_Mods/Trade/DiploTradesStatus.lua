include("IconSupport")
include("SupportFunctions")
include("InstanceManager")
include("CityStateStatusHelper.lua")
include("YieldLibrary.lua")

local log = Events.LuaLogger:New()
log:SetLevel("DEBUG")

local gLabelIM = InstanceManager:new("TradeStatusInstance", "TradeBox", Controls.WindowHeaders)
local gPlayerIM = InstanceManager:new("TradeStatusInstance", "TradeBox", Controls.PlayerBox)
local gAiIM = InstanceManager:new("TradeStatusInstance", "TradeBox", Controls.AiStack)
local gCsIM = InstanceManager:new("CityStateInstance", "TradeBox", Controls.AiStack)

local gSortTable

local resourceList = Game.GetSortedResourceList({ResourceUsageTypes.RESOURCEUSAGE_LUXURY, ResourceUsageTypes.RESOURCEUSAGE_STRATEGIC}, true)
local dealTable = {}
local numResources = 0

for _, resInfo in ipairs(resourceList) do
	numResources = numResources + 1
end

local windowWidth = 1000
local defaultWidth = Game.Round((windowWidth-460) / numResources)
local stackOffset = (windowWidth-80) - (defaultWidth * (numResources + 5) + 100)


function ShowHideHandler(bIsHide, bIsInit)
	if (not bIsInit and not bIsHide) then
		--print("Show DiploTradeStatus")
		gLabelIM:ResetInstances()
		gPlayerIM:ResetInstances()
		gAiIM:ResetInstances()
		gCsIM:ResetInstances()
		
		dealTable = Players[Game.GetActivePlayer()]:GetDeals()
		InitLabels()
		InitPlayer()
		InitAiList()
	end
end
ContextPtr:SetShowHideHandler(ShowHideHandler)

function InitLabels()
	local controlTable = gLabelIM:GetInstance()
	controlTable.CivButton:SetHide(true)
	controlTable.MainStack:DestroyAllChildren()
	
	local button = {}
	
	for _, resInfo in ipairs(resourceList) do
		button = AddButton(controlTable.MainStack, resInfo.IconString, resInfo.IconString .. " " .. Locale.ConvertTextKey(resInfo.Description))
	end
	
	AddButton(controlTable.MainStack)
	AddButton(controlTable.MainStack, "[ICON_TRADE]", "TXT_KEY_DEAL_BORDER_AGREEMENT")
	AddButton(controlTable.MainStack, "[ICON_RESEARCH]", "TXT_KEY_DEAL_RESEARCH_AGREEMENT")
	AddButton(controlTable.MainStack, "[ICON_STRENGTH]", "TXT_KEY_DEAL_DEFENSIVE_PACT")
	AddButton(controlTable.MainStack, "[ICON_TEAM_8]", "TXT_KEY_DEAL_ALLIANCE")
	AddButton(controlTable.MainStack, "[ICON_CAPITAL]", "TXT_KEY_DEAL_EMBASSY_AGREEMENT")
	button = AddButton(controlTable.MainStack, "[ICON_GOLD]", "TXT_KEY_DEAL_GOLD_STORED", false, 50)
	local width = button.Label:GetSizeX()
	button.Label:SetAnchor("R,C")
	button.Button:SetOffsetX(5)
	button.Button:SetSizeX(50)
	button = AddButton(controlTable.MainStack, string.format("+[ICON_GOLD]/%s", Locale.ConvertTextKey("TXT_KEY_DO_TURN")), "TXT_KEY_DEAL_GOLD_PROFIT", false, 50)
	local width = button.Label:GetSizeX()
	button.Label:SetAnchor("L,C")
	button.Button:SetSizeX(50)
	
	controlTable.MainStack:CalculateSize()
	controlTable.MainStack:ReprocessAnchoring()
	controlTable.MainStack:SetOffsetX(stackOffset)
	
	controlTable.Divider:SetHide(true)
end

function InitPlayer()	
	--allButtons[Game.GetActivePlayer()] = {}
	GetCivControl(gPlayerIM, 0, false)
end

function InitAiList()
	local activePlayerID = Game.GetActivePlayer()
	local activePlayer = Players[activePlayerID]
	local activeTeam = Teams[activePlayer:GetTeam()]
	local count = 0

	gSortTable = {}
	
	for playerIDLoop = 0, GameDefines.MAX_MAJOR_CIVS-1, 1 do
		local pOtherPlayer = Players[playerIDLoop]
		local iOtherTeam = pOtherPlayer:GetTeam()
		
		if pOtherPlayer:IsAlive() and playerIDLoop ~= activePlayerID then
			if (activeTeam:IsHasMet(iOtherTeam)) then
				count = count+1
				GetCivControl(gAiIM, playerIDLoop, true)
			end
		end
	end
	
	if InitCsList() then
		count = count+1
	end

	if count == 0 then
		Controls.AiNoneMetText:SetHide(false)
		Controls.AiScrollPanel:SetHide(true)
	else
		Controls.AiStack:SortChildren(ByScore)
		Controls.AiStack:CalculateSize()
		Controls.AiStack:ReprocessAnchoring()
		Controls.AiScrollPanel:CalculateInternalSize()
		Controls.AiNoneMetText:SetHide(true)
		Controls.AiScrollPanel:SetHide(false)
	end
end

function InitCsList()
	local bCsMet = false
	local activePlayerID = Game.GetActivePlayer()
	local activePlayer = Players[activePlayerID]
	local activeTeam = Teams[activePlayer:GetTeam()]

	local controlTable = gCsIM:GetInstance()
	local iMaxY = controlTable.TradeBox:GetSizeY()
	
	controlTable.MainStack:DestroyAllChildren()

	for _, resInfo in ipairs(resourceList) do
		local resStack = {}
		local numCS = 0
		local resID = resInfo.ID
		ContextPtr:BuildInstanceForControl("CityStateResourceStack", resStack, controlTable.MainStack)

		for iCsLoop = GameDefines.MAX_MAJOR_CIVS, GameDefines.MAX_CIV_PLAYERS-1, 1 do
			local minorCiv = Players[iCsLoop]
	
			if (minorCiv:IsAlive() and activeTeam:IsHasMet(minorCiv:GetTeam())) then
				local nearResources = minorCiv:GetNearbyResources()
				local numResourceNear = nearResources[resID]
				if IsCsHasResource(minorCiv, resInfo) or (numResourceNear and numResourceNear > 0) then
					numCS = numCS + 1
					local sTrait = GameInfo.MinorCivilizations[minorCiv:GetMinorCivType()].MinorCivTrait
					local primaryColor, secondaryColor = minorCiv:GetPlayerColors()
					local exports = minorCiv:GetResourceExport(resID)

					local sToolTip = string.format(
						"%s[NEWLINE]%s %s%s %s[ENDCOLOR][NEWLINE]%s", 
						minorCiv:GetName(), 
						resInfo.IconString, 
						minorCiv:GetExportColor(resID, resImproved, resNear), 
						numResourceNear, 
						Locale.ConvertTextKey(resInfo.Description),
						GetCityStateStatus(minorCiv, activePlayer, minorCiv:IsAtWar(activePlayer))
					)
					
					local button = {}
					
					ContextPtr:BuildInstanceForControl("CityStateButtonInstance", button, resStack.Stack)

					--button.CsLuxuryIcon:SetText(resInfo.IconString)
					
					button.CsTraitIcon:SetTexture(GameInfo.MinorCivTraits[sTrait].TraitIcon)
					button.CsTraitIcon:SetColor({x = secondaryColor.x, y = secondaryColor.y, z = secondaryColor.z, w = 1})
					button.CsButton:SetSizeX(defaultWidth)
					button.CsButton:SetToolTipString(sToolTip)
					button.CsButton:SetVoid1(iCsLoop)
					button.CsButton:RegisterCallback(Mouse.eLClick, OnCsSelected)
					button.MouseOverContainer:SetHide(false)
					button.MouseOverContainer:SetSizeX(20 + defaultWidth)
					button.MouseOverAnim:SetSizeX(20 + defaultWidth)
					button.MouseOverGrid:SetSizeX(20 + defaultWidth)
					if minorCiv:IsAllies(activePlayerID) then
						button.CsTraitIcon:SetAlpha(1)
					else
						button.CsTraitIcon:SetAlpha(0.3)
					end
				end

				bCsMet = true
			end
		end
		
		if numCS == 0 then
			AddButton(resStack.Stack)
		end

		resStack.Stack:CalculateSize()
		resStack.Stack:SetSizeX(defaultWidth)
		resStack.Stack:ReprocessAnchoring()

		iMaxY = math.max(iMaxY, resStack.Stack:GetSizeY())
	end 

	if (not bCsMet) then
		controlTable.TradeBox:SetHide(true)
	else
		controlTable.TradeBox:SetSizeY(iMaxY+5)
		controlTable.MainStack:SetOffsetX(stackOffset)
	end
	--]]
	return bCsMet
end

function GetCivControl(im, targetPlayerID, bCanTrade)
	local targetPlayer			= Players[targetPlayerID]
	local tarTeamID			= targetPlayer:GetTeam()
	local tarTeam			= Teams[tarTeamID]
	local tarCivInfo		= GameInfo.Civilizations[targetPlayer:GetCivilizationType()]
	local activePlayerID	= Game.GetActivePlayer()
	local activePlayer		= Players[activePlayerID]
	local activeTeamID		= activePlayer:GetTeam()
	local activeTeam		= Teams[activeTeamID]
	local isActivePlayer	= (activePlayerID == targetPlayerID)
	local isAtWar			= targetPlayer:IsAtWar(activePlayer)	
	
	local pDeal				= UI.GetScratchDeal()
	local button			= {}
	
	local controlTable		= im:GetInstance()
	local sortEntry			= {}
	local turnsLeft			= 0
	local statusIcon		= "[ICON_HAPPINESS_2]"
	local statusColor		= "[COLOR_WHITE]"
	local statusTip			= ""
	
	if isActivePlayer then
		controlTable.CivName:SetText(Locale.ConvertTextKey("TXT_KEY_YOU"))
	elseif targetPlayer:IsHuman() then
		controlTable.CivName:SetText(Locale.TruncateString(targetPlayer:GetNickName(), 20, true))
	else
		if isAtWar then
			statusIcon	= "[ICON_WAR]"
			statusColor	= "[COLOR_RED]"
			statusTip	= "TXT_KEY_DO_AT_WAR"
		elseif targetPlayer:IsDenouncedPlayer(activePlayerID) and activePlayer:IsDenouncedPlayer(targetPlayerID) then
			statusIcon	= "[ICON_TEAM_2]"
			statusColor	= "[COLOR_RED]"
			statusTip	= "TXT_KEY_DEAL_DENOUNCED_BOTH"
		elseif targetPlayer:IsDenouncedPlayer(activePlayerID) then
			statusIcon	= "[ICON_TEAM_9]"
			statusColor	= "[COLOR_PLAYER_ORANGE_TEXT]"
			statusTip	= "TXT_KEY_DEAL_DENOUNCED_US"
		elseif activePlayer:IsDenouncedPlayer(targetPlayerID) then
			statusIcon	= "[ICON_TEAM_9]"
			statusColor	= "[COLOR_PLAYER_ORANGE_TEXT]"
			statusTip	= "TXT_KEY_DEAL_DENOUNCED_THEM"
		elseif targetPlayer:IsDoF(activePlayerID) then
			statusIcon	= "[ICON_TEAM_8]"
			statusColor	= "[COLOR_MENU_BLUE]"			
			statusTip	= "TXT_KEY_DEAL_STATUS_ALLIANCE_NO_TT"
		elseif tarTeam:IsForcePeace(activeTeamID) then
			statusIcon	= "[ICON_TEAM_1]"
			statusTip	= "TXT_KEY_DEAL_PEACE_TREATY"
		else
			local approachID = activePlayer:GetApproachTowardsUsGuess(targetPlayerID)
			if approachID == MajorCivApproachTypes.MAJOR_CIV_APPROACH_HOSTILE then
				statusIcon	= "[ICON_HAPPINESS_4]"
				statusColor	= "[COLOR_PLAYER_ORANGE_TEXT]"
				statusTip	= "TXT_KEY_DIPLO_MAJOR_CIV_DIPLO_STATE_HOSTILE"
			elseif approachID == MajorCivApproachTypes.MAJOR_CIV_APPROACH_GUARDED then
				statusIcon	= "[ICON_HAPPINESS_3]"
				statusColor	= "[COLOR_YELLOW]"
				statusTip	= "TXT_KEY_DIPLO_MAJOR_CIV_DIPLO_STATE_GUARDED"
			elseif approachID == MajorCivApproachTypes.MAJOR_CIV_APPROACH_AFRAID then
				statusIcon	= "[ICON_HAPPINESS_3]"
				statusColor	= "[COLOR_CULTURE_STORED]"
				statusTip	= "TXT_KEY_DIPLO_MAJOR_CIV_DIPLO_STATE_AFRAID"
			elseif approachID == MajorCivApproachTypes.MAJOR_CIV_APPROACH_FRIENDLY then
				statusIcon	= "[ICON_HAPPINESS_1]"
				statusColor	= "[COLOR_GREEN]"
				statusTip	= "TXT_KEY_DIPLO_MAJOR_CIV_DIPLO_STATE_FRIENDLY"
			else
				statusIcon	= "[ICON_HAPPINESS_2]"
				statusTip	= "TXT_KEY_DIPLO_MAJOR_CIV_DIPLO_STATE_NEUTRAL"
			end
		end
			
		controlTable.CivName:SetText(string.format("%s%s[ENDCOLOR]", statusColor, Locale.TruncateString(targetPlayer:GetName(), 20, true)))
		statusTip = string.format("%s%s[ENDCOLOR][NEWLINE]", statusColor, Locale.ConvertTextKey(statusTip))
	end
	
	
	CivIconHookup(targetPlayerID, 32, controlTable.CivSymbol, controlTable.CivIconBG, controlTable.CivIconShadow, false, true)
	controlTable.CivIconBG:SetHide(false)

	local tipDeals = ""
	local dealList = {}
	--[[
	for tradeItem, v in pairs(dealTable) do
		for targetPlayer
	end
	dealTable[TradeableItems.TRADE_ITEM_OPEN_BORDERS][targetPlayerID][1].finalTurn
	--]]
	
	statusTip = string.format(
		"%s%s[NEWLINE]%s %s",
		statusTip,
		Locale.ConvertTextKey(GameInfo.Eras[targetPlayer:GetCurrentEra()].Description),
		targetPlayer:GetScore(),
		Locale.ConvertTextKey("TXT_KEY_POP_SCORE")
	)

	controlTable.StatusIcon:SetText(statusIcon)
	controlTable.CivButton:SetToolTipString(statusTip)

	if bCanTrade then				
		controlTable.CivButton:SetVoid1(targetPlayerID)
		controlTable.CivButton:RegisterCallback(Mouse.eLClick, OnCivSelected)

		gSortTable[tostring(controlTable.TradeBox)] = sortEntry
		sortEntry.PlayerID = targetPlayerID
	else
		controlTable.CivButtonHL:SetHide(true)
	end
	
	controlTable.MainStack:DestroyAllChildren()
	
	if isAtWar then
		button = AddButton(controlTable.MainStack, "TXT_KEY_AT_WAR_LARGE")
		button.Button:SetSizeX(defaultWidth * numResources)
		button.Label:SetAnchor("C,C")
	else
		for _, resInfo in ipairs(resourceList) do
			PopulateResourceInstance(controlTable.MainStack, targetPlayer, resInfo, isActivePlayer)
		end
	end
	
	AddButton(controlTable.MainStack)	
	
	if isActivePlayer then
		AddButton(controlTable.MainStack)
		AddButton(controlTable.MainStack)
		AddButton(controlTable.MainStack)
		AddButton(controlTable.MainStack)
		AddButton(controlTable.MainStack)
		controlTable.Divider:SetHide(true)
	elseif isAtWar then
		AddButton(controlTable.MainStack)
		AddButton(controlTable.MainStack)
		AddButton(controlTable.MainStack)
		AddButton(controlTable.MainStack)
		AddButton(controlTable.MainStack)
	else	
		if tarTeam:IsAllowsOpenBordersToTeam(activeTeamID) and activeTeam:IsAllowsOpenBordersToTeam(tarTeamID) then
			turnsLeft = dealTable[TradeableItems.TRADE_ITEM_OPEN_BORDERS][targetPlayerID][1].finalTurn - Game.GetGameTurn()
			AddButton(
				controlTable.MainStack, 
				turnsLeft,
				string.format("%s[NEWLINE][NEWLINE]%s %s", Locale.ConvertTextKey("TXT_KEY_DEAL_BORDER_AGREEMENT"), turnsLeft, Locale.ConvertTextKey("TXT_KEY_VP_TURNS"))
			)
		elseif tarTeam:IsAllowsOpenBordersToTeam(activeTeamID) then
			AddButton(
				controlTable.MainStack, "[ICON_BLOCKADED]", "TXT_KEY_DEAL_STATUS_BORDERS_US_TT",
				function() UI_StartDeal{
					fromPlayerID = activePlayerID, 
					toPlayerID = targetPlayerID,
					agreement = "OpenBorders"
				} end
			)
		elseif activeTeam:IsAllowsOpenBordersToTeam(tarTeamID) then
			AddButton(
				controlTable.MainStack, "[ICON_BLOCKADED]", "TXT_KEY_DEAL_STATUS_BORDERS_THEM_TT",
				function() UI_StartDeal{
					fromPlayerID = activePlayerID, 
					toPlayerID = targetPlayerID,
					agreement = "OpenBorders"
				} end
			)
		elseif pDeal:IsPossibleToTradeItem(targetPlayerID, activePlayerID, TradeableItems.TRADE_ITEM_OPEN_BORDERS, Game.GetDealDuration()) then
			AddButton(
				controlTable.MainStack, "[ICON_PLUS]", Locale.ConvertTextKey("TXT_KEY_DEAL_STATUS_BORDERS_YES_TT", Game.GetDealDuration()),
				function() UI_StartDeal{
					fromPlayerID = activePlayerID, 
					toPlayerID = targetPlayerID,
					agreement = "OpenBorders"
				} end
			)
		else
			AddButton(controlTable.MainStack)
		end
		
		if tarTeam:IsHasResearchAgreement(activeTeamID) then
			turnsLeft = dealTable[TradeableItems.TRADE_ITEM_RESEARCH_AGREEMENT][targetPlayerID][1].finalTurn - Game.GetGameTurn()
			AddButton(controlTable.MainStack,
				turnsLeft,
				string.format("%s[NEWLINE][NEWLINE]%s %s", Locale.ConvertTextKey("TXT_KEY_DEAL_RESEARCH_AGREEMENT"), turnsLeft, Locale.ConvertTextKey("TXT_KEY_VP_TURNS"))
			)
		elseif pDeal:IsPossibleToTradeItem(targetPlayerID, activePlayerID, TradeableItems.TRADE_ITEM_RESEARCH_AGREEMENT, Game.GetDealDuration()) then
			AddButton(
				controlTable.MainStack, "[ICON_PLUS]", Locale.ConvertTextKey("TXT_KEY_DEAL_STATUS_RA_YES_TT", Game.GetDealDuration()),
				function() UI_StartDeal{
					fromPlayerID = activePlayerID, 
					toPlayerID = targetPlayerID,
					agreement = "ResearchAgreement"
				} end
			)
		else
			AddButton(controlTable.MainStack)
		end	
		
		if tarTeam:IsDefensivePact(activeTeamID) then
			turnsLeft = dealTable[TradeableItems.TRADE_ITEM_DEFENSIVE_PACT][targetPlayerID][1].finalTurn - Game.GetGameTurn()
			AddButton(controlTable.MainStack,
				turnsLeft,
				string.format("%s[NEWLINE][NEWLINE]%s %s", Locale.ConvertTextKey("TXT_KEY_DEAL_DEFENSIVE_PACT"), turnsLeft, Locale.ConvertTextKey("TXT_KEY_VP_TURNS"))
			)
		elseif pDeal:IsPossibleToTradeItem(targetPlayerID, activePlayerID, TradeableItems.TRADE_ITEM_DEFENSIVE_PACT, Game.GetDealDuration()) then
			AddButton(controlTable.MainStack, "[ICON_PLUS]", Locale.ConvertTextKey("TXT_KEY_DEAL_STATUS_DEFENSE_YES_TT", Game.GetDealDuration()),
				function() UI_StartDeal{
					fromPlayerID = activePlayerID, 
					toPlayerID = targetPlayerID,
					agreement = "DefensePact"
				} end
			)
		else
			AddButton(controlTable.MainStack)
		end
		
		if targetPlayer:IsDoF(activePlayerID) then
			button = AddButton(controlTable.MainStack, "[ICON_TEAM_8]", "TXT_KEY_DEAL_ALLIANCE", OnCivSelected)
			button.Button:SetVoid1(targetPlayerID)
		elseif targetPlayer:IsHuman() and targetPlayer:IsHuman() then
			if pDeal:IsPossibleToTradeItem(targetPlayerID, activePlayerID, TradeableItems.TRADE_ITEM_DECLARATION_OF_FRIENDSHIP, Game.GetDealDuration()) then
				AddButton(controlTable.MainStack, "[ICON_PLUS]", Locale.ConvertTextKey("TXT_KEY_DEAL_STATUS_ALLIANCE_YES_TT", Game.GetDealDuration()),
					function() UI_StartDeal{
						fromPlayerID = activePlayerID, 
						toPlayerID = targetPlayerID,
						agreement = "Alliance"
					} end
				)
			else
				AddButton(controlTable.MainStack)
			end
		elseif (not targetPlayer:IsDoF(activePlayerID) and not targetPlayer:IsDoFMessageTooSoon(activePlayerID)) then
			button = AddButton(controlTable.MainStack, "[ICON_PLUS]", Locale.ConvertTextKey("TXT_KEY_DEAL_STATUS_ALLIANCE_YES_TT", Game.GetDealDuration()), OnCivSelected)
			button.Button:SetVoid1(targetPlayerID)
		else
			AddButton(controlTable.MainStack)
		end
		
		if tarTeam:HasEmbassyAtTeam(activeTeamID) and activeTeam:HasEmbassyAtTeam(tarTeamID) then
			AddButton(
				controlTable.MainStack, 
				"[ICON_CAPITAL]",
				Locale.ConvertTextKey("TXT_KEY_DEAL_EMBASSY_AGREEMENT")
			)
		elseif tarTeam:HasEmbassyAtTeam(activeTeamID) then
			AddButton(
				controlTable.MainStack, "[ICON_BLOCKADED]", "TXT_KEY_DEAL_STATUS_EMBASSY_THEM_TT",
				function() UI_StartDeal{
					fromPlayerID = activePlayerID, 
					toPlayerID = targetPlayerID,
					agreement = "Embassy"
				} end
			)
		elseif activeTeam:HasEmbassyAtTeam(tarTeamID) then
			AddButton(
				controlTable.MainStack, "[ICON_BLOCKADED]", "TXT_KEY_DEAL_STATUS_EMBASSY_US_TT",
				function() UI_StartDeal{
					fromPlayerID = activePlayerID, 
					toPlayerID = targetPlayerID,
					agreement = "Embassy"
				} end
			)
		elseif pDeal:IsPossibleToTradeItem(targetPlayerID, activePlayerID, TradeableItems.TRADE_ITEM_ALLOW_EMBASSY, Game.GetDealDuration()) then
			AddButton(
				controlTable.MainStack, "[ICON_PLUS]", Locale.ConvertTextKey("TXT_KEY_DEAL_STATUS_EMBASSY_YES_TT", Game.GetDealDuration()),
				function() UI_StartDeal{
					fromPlayerID = activePlayerID, 
					toPlayerID = targetPlayerID,
					agreement = "Embassy"
				} end
			)
		else
			AddButton(controlTable.MainStack)
		end
	end
	
	button = AddButton(controlTable.MainStack, targetPlayer:GetYieldStored(YieldTypes.YIELD_GOLD), false, false, 50)
	button.Label:SetAnchor("R,C")
	button.Button:SetOffsetX(5)
	
	local goldRate = string.format("[COLOR_CLEAR]+[ENDCOLOR]%s", targetPlayer:GetYieldRate(YieldTypes.YIELD_GOLD))
	button = AddButton(controlTable.MainStack, goldRate, false, false, 50)
	button.Label:SetAnchor("L,C")
	
	controlTable.MainStack:CalculateSize()
	controlTable.MainStack:ReprocessAnchoring()
	controlTable.MainStack:SetOffsetX(stackOffset)

	return controlTable
end

function ByScore(a, b)
	local entryA = gSortTable[tostring(a)]
	local entryB = gSortTable[tostring(b)]

	if ((entryA == nil) or (entryB == nil)) then 
		if ((entryA ~= nil) and (entryB == nil)) then
			return true
		elseif ((entryA == nil) and (entryB ~= nil)) then
			return false
		else
			return (tostring(a) < tostring(b)) -- gotta do something!
		end
	end

	return (Players[entryA.PlayerID]:GetScore() > Players[entryB.PlayerID]:GetScore())
end


function AddButton(control, text, tooltip, callbackFunction, width)
	local button = {}
	width = width or defaultWidth
	ContextPtr:BuildInstanceForControl("ButtonInstance", button, control)
	
	if text then
		text = tostring(text)
		if string.find(text, "TXT_KEY") then
			button.Label:LocalizeAndSetText(text)
		else
			button.Label:SetText(text)
		end
	else
		button.Label:SetText("[ICON_HAPPINESS_2]")
	end
	
	if tooltip then
		tooltip = tostring(tooltip)
		if string.find(tooltip, "TXT_KEY") then
			button.Button:LocalizeAndSetToolTip(tooltip)
		else
			button.Button:SetToolTipString(tooltip)
		end
	else
		button.Button:SetToolTipString("")
	end
	
	button.Button:SetSizeX(width)	
	
	if callbackFunction then
		button.Button:RegisterCallback(Mouse.eLClick, callbackFunction)
		button.MouseOverContainer:SetHide(false)
		button.MouseOverContainer:SetSizeX(20 + width)
		button.MouseOverAnim:SetSizeX(20 + width)
		button.MouseOverGrid:SetSizeX(20 + width)
	else
		button.MouseOverContainer:SetHide(true)
	end
	return button
end

function PopulateResourceInstance(stack, targetPlayer, resInfo, isActivePlayer)
	if (Game.GetResourceUsageType(resInfo.ID) == ResourceUsageTypes.RESOURCEUSAGE_STRATEGIC)
		and (not targetPlayer:HasTech(resInfo.TechReveal) or not targetPlayer:HasTech(resInfo.TechCityTrade)
		) then
		return AddButton(stack)
	end
	
	local control			= {}
	local resID				= resInfo.ID
	local res				= targetPlayer:GetResourceQuantities(resID)
	local name				= Locale.ConvertTextKey(resInfo.Description)	
	local text				= res.Available
	local tip				= Locale.ConvertTextKey("TXT_KEY_DEAL_RESOURCE", resInfo.IconString, name)
	local activePlayerID	= Game.GetActivePlayer()
	local targetPlayerID	= targetPlayer:GetID()

	if isActivePlayer then
		text = string.format("%s%s[ENDCOLOR]", res.Color, text)
		if res.Cities then
			text = "[ICON_FOOD]"
			tip = tip .. "[NEWLINE]" .. Locale.ConvertTextKey("TXT_KEY_RESOURCE_DEMANDED_BY") .. ":[NEWLINE]"
			tip = string.format("%s%s[ENDCOLOR]", res.Color, tip)
			for cityID, city in pairs(res.Cities) do
				tip = tip .. city:GetName() .. ", "
			end
			tip = string.gsub(tip, ", $", "")
		end
		return AddButton(stack, text, tip)
	end
	
	local activeRes = Players[activePlayerID]:GetResourceQuantities(resID)
	local callback = nil
	local tradeQuantity = 1

	local resType = GameInfo.Resources[resID].Type
	
	if res.Tradable > 0 and activeRes.Available <= 0 then
		-- them, not us
		if res.IsStrategic then
			tradeQuantity = math.min(5, res.Tradable)
		end
		tip = Locale.ConvertTextKey("TXT_KEY_DEAL_FROM", resInfo.IconString, name)
		callback = function()
			UI_StartDeal{
				fromPlayerID = targetPlayerID,
				toPlayerID = activePlayerID,
				fromResources = {[resID]=tradeQuantity}
			}
		end
	elseif res.Available > 0 then
		-- them, us
		if res.IsStrategic then
			tradeQuantity = math.min(5, res.Tradable)
		end
		res.Color = "[COLOR_GREY]"
		callback = function()
			UI_StartDeal{
				fromPlayerID = targetPlayerID,
				toPlayerID = activePlayerID,
				fromResources = {[resID]=tradeQuantity}
			}
		end
	elseif (activeRes.Tradable > 0) or 
			(activeRes.Available == 1
			and not activeRes.IsStrategic
			and activeRes.Available ~= activeRes.Citystates
			and activeRes.Available ~= activeRes.Imported
			) then
		-- not them, us
		if res.Available < 0 then
			res.Color = "[COLOR_RED]"
		elseif activeRes.Tradable == 0 then
			res.Color = "[COLOR_DARK_GREY]"
		else
			res.Color = "[COLOR_YELLOW]"
		end
		tip = Locale.ConvertTextKey("TXT_KEY_DEAL_TO", resInfo.IconString, name)
		if res.IsStrategic then
			tradeQuantity = math.min(5, activeRes.Tradable)
			callback = function()
				UI_StartDeal{
					fromPlayerID = activePlayerID,
					toPlayerID = targetPlayerID,
					fromResources = {[resID]=tradeQuantity}
				}
			end
		else
			callback = function()
				UI_StartDeal{
					fromPlayerID = activePlayerID,
					toPlayerID = targetPlayerID,
					fromResources = {[resID]=tradeQuantity}
				}
			end			
		end
	else
		-- not them, not us
		return AddButton(stack)
	end
	
	text = string.format("%s%s[ENDCOLOR]", res.Color, text)
	tip = string.format("%s%s[ENDCOLOR]", res.Color, tip)	
	
	return AddButton(stack, text, tip, callback)
end

function IsCsHasResource(minorCiv, pResource)
	return (GetCsResourceCount(minorCiv, pResource) > 0)
end

function GetCsStrategics(minorCiv)
	local sStrategics = ""
	
	for pResource in GameInfo.Resources() do
		local iResource = pResource.ID

		if (Game.GetResourceUsageType(iResource) == ResourceUsageTypes.RESOURCEUSAGE_STRATEGIC) then
			iAmount = GetCsResourceCount(minorCiv, pResource)

			if (iAmount > 0) then
				if (sStrategics ~= "") then
					sStrategics = sStrategics .. ", "
				end

				sStrategics = sStrategics .. pResource.IconString .. " [COLOR_POSITIVE_TEXT]" .. iAmount .. "[ENDCOLOR]"
			end
		end
	end

	return sStrategics
end

function GetCsResourceCount(minorCiv, pResource)
	return minorCiv:GetNumResourceTotal(pResource.ID, false) + minorCiv:GetResourceExport(pResource.ID)
end

function OnCivSelected(targetPlayerID)
	if (Players[targetPlayerID]:IsHuman()) then
		Events.OpenPlayerDealScreenEvent(targetPlayerID)
	else
		UI.SetRepeatActionPlayer(targetPlayerID)
		UI.ChangeStartDiploRepeatCount(1)
		Players[targetPlayerID]:DoBeginDiploWithHuman()
	end
end

function OnCsSelected(iCs)
	local popupInfo = {
		Type = ButtonPopupTypes.BUTTONPOPUP_CITY_STATE_DIPLO,
		Data1 = iCs
	}
		
	Events.SerialEventGameMessagePopup(popupInfo)
end
