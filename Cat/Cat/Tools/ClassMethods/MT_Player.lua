-- MT_Player
-- Author: Thalassicus
-- DateCreated: 2/29/2012 8:19:24 AM
--------------------------------------------------------------

include("MT_LuaLogger.lua")
local log = Events.LuaLogger:New()
log:SetLevel("INFO")


PlayerClass = getmetatable(Players[0]).__index

---------------------------------------------------------------------
-- player:CanFoundFaith()
--
function PlayerClass.CanFoundFaith(player)	
	return (player:CanCreatePantheon(false) and not player:HasCreatedPantheon())
		or (Game.GetNumReligionsStillToFound() > 0 and not player:HasCreatedReligion())
end
---------------------------------------------------------------------
--[[ player:GetBuildingAddonLevel(buildingID) usage example:

]]
function PlayerClass.GetBuildingAddonLevel(player, buildingID)
	local parentClass = Game.GetValue("ParentBuildingClass", {BuildingType=GameInfo.Buildings[buildingID].Type}, GameInfo.Building_Addons) 
	if parentClass then
		return (1 + player:GetBuildingAddonLevel(player:GetUniqueBuildingID(parentClass)))
	end
	return 0
end

---------------------------------------------------------------------
function PlayerClass.GetCivName(player)
	if player:IsMinorCiv() then
		return Locale.ConvertTextKey(GameInfo.MinorCivilizations[player:GetMinorCivType()].Description)
	end
	local civInfo = GameInfo.Civilizations[player:GetCivilizationType()]			
	return (Locale.ConvertTextKey(civInfo.Description))
end

---------------------------------------------------------------------
-- PlayerClass:GetCapitalCity()
-- fixes bug with vanilla version
--
if not PlayerClass.VanillaGetCapitalCity then
	PlayerClass.VanillaGetCapitalCity = PlayerClass.GetCapitalCity
	function PlayerClass.GetCapitalCity(player)
		local capital = player:VanillaGetCapitalCity()
		if not capital then
			for city in player:Cities() do
				if city then
					capital = city
					City_SetNumBuildingClass(city, "BUILDINGCLASS_PALACE", 1)
					log:Warn("%20s capital set to %-s", player:GetName(), city:GetName())
					break
				end
			end
		end
		return capital
	end
end


---------------------------------------------------------------------
-- player:GetDeals()
--
DealTypes = {
	[TradeableItems.TRADE_ITEM_PEACE_TREATY]				= "TRADE_ITEM_PEACE_TREATY",
	[TradeableItems.TRADE_ITEM_OPEN_BORDERS]				= "TRADE_ITEM_OPEN_BORDERS",
	[TradeableItems.TRADE_ITEM_RESEARCH_AGREEMENT]			= "TRADE_ITEM_RESEARCH_AGREEMENT",
	[TradeableItems.TRADE_ITEM_DEFENSIVE_PACT]				= "TRADE_ITEM_DEFENSIVE_PACT",
	[TradeableItems.TRADE_ITEM_DECLARATION_OF_FRIENDSHIP]	= "TRADE_ITEM_DECLARATION_OF_FRIENDSHIP",
	[TradeableItems.TRADE_ITEM_ALLOW_EMBASSY]				= "TRADE_ITEM_ALLOW_EMBASSY",
	[TradeableItems.TRADE_ITEM_THIRD_PARTY_PEACE]			= "TRADE_ITEM_THIRD_PARTY_PEACE",
	[TradeableItems.TRADE_ITEM_THIRD_PARTY_WAR]				= "TRADE_ITEM_THIRD_PARTY_WAR",
	[TradeableItems.TRADE_ITEM_CITIES]						= "TRADE_ITEM_CITIES",
	[TradeableItems.TRADE_ITEM_RESOURCES]					= "TRADE_ITEM_RESOURCES",
	[TradeableItems.TRADE_ITEM_GOLD]						= "TRADE_ITEM_GOLD",
	[TradeableItems.TRADE_ITEM_GOLD_PER_TURN]				= "TRADE_ITEM_GOLD_PER_TURN"
}

function PlayerClass.GetDeals(player)
	local activePlayerID = Game.GetActivePlayer()
	local playerID = player:GetID()
	local deal = UI.GetScratchDeal()
	local dealTable = {}
	for index, name in ipairs(TradeableItems) do
		dealTable[index] = {}
		for playerID, player in pairs(Players) do
			dealTable[index][playerID] = {}
		end
	end

    local numDeals = UI:GetNumCurrentDeals(playerID) --works only for active player?
    if numDeals > 0 then
	    for dealID = 0, numDeals - 1 do
			UI.LoadCurrentDeal(playerID, dealID)
			deal:ResetIterator()
			local itemID, duration, finalTurn, data1, data2, fromPlayerID = deal:GetNextItem()
			local priority, iconString, help, toPlayerID
			while itemID do
				--log:Debug("activePlayerID=%s fromPlayer=%s", Game.GetActivePlayer(), Players[fromPlayerID]:GetName())
				--log:Debug("itemID=%s duration=%s finalTurn=%s data1=%s data2=%s fromPlayerID=%s", itemID, duration, finalTurn, data1, data2, fromPlayerID)
				
				local dealInfo	= DealTypes[itemID]
				
				if dealInfo and GameInfo.Deals[dealInfo] then
					dealInfo	= GameInfo.Deals[dealInfo]
					priority	= dealInfo.Priority
					iconString	= dealInfo.IconString
					help		= dealInfo.Help
				else
					priority	= 99
					iconString	= string.format("[%s]", itemID)
					help		= iconString					
				end
				
				if itemID == TradeableItems.TRADE_ITEM_RESOURCES then
					iconString = data2 .. GameInfo.Resources[data1].IconString
					help = iconString .. " " .. Locale.ConvertTextKey(GameInfo.Resources[data1].Description)
				elseif itemID == TradeableItems.TRADE_ITEM_CITIES then
					local plot = Map.GetPlot( data1, data2 )
					if plot and plot:GetPlotCity() then
						iconString = string.format("City(%s)", plot:GetPlotCity():GetName())
						help = iconString
					end
					data1, data2 = nil, nil
				end
				
				if duration and duration > 0 then
					iconString	= string.format("%s(%s)", iconString, duration)
					help		= string.format("%s(%s)", iconString, duration)
				end
				if data1 and data1 ~= 0 then
					iconString	= string.format("%s 1[%s]", iconString, data1)
					help		= string.format("%s 1[%s]", iconString, data1)
				end
				if data2 and data2 ~= 0  then
					iconString	= string.format("%s 2[%s]", iconString, data2)
					help		= string.format("%s 2[%s]", iconString, data2)
				end
				
				dealTable[itemID] = dealTable[itemID] or {}
				dealTable[itemID][fromPlayerID] = dealTable[itemID][fromPlayerID] or {}
				
				table.insert( dealTable[itemID][fromPlayerID], {
					duration		= duration, 
					finalTurn		= finalTurn, 
					data1			= data1, 
					data2			= data2, 
					fromPlayerID	= fromPlayerID,
					toPlayerID		= (fromPlayerID == activePlayerID) and playerID or activePlayerID,
					priority		= priority,
					iconString		= iconString,
					help			= help
				})
				
				itemID, duration, finalTurn, data1, data2, fromPlayerID = deal:GetNextItem()
			end
		end
	end
	return dealTable
end

---------------------------------------------------------------------
-- player:GetPossibleDeals()
--
function PlayerClass.GetPossibleDeals(player)
	local playerID = player:GetID()
	local deals = {
		{icon="[ICON_CAPITAL]",		num=0, name=Locale.ConvertTextKey("TXT_KEY_EMBASSIES")},
		{icon="[ICON_TRADE]",		num=0, name=Locale.ConvertTextKey("TXT_KEY_BORDER_DEALS")},
		{icon="[ICON_RESEARCH]",	num=0, name=Locale.ConvertTextKey("TXT_KEY_RESEARCH_DEALS")},
		{icon="[ICON_STRENGTH]",	num=0, name=Locale.ConvertTextKey("TXT_KEY_DEFENSE_PACTS")},
		{icon="[ICON_TEAM_8]",		num=0, name=Locale.ConvertTextKey("TXT_KEY_ALLIANCES")}
	}
	local deal = UI.GetScratchDeal()
	for targetPlayerID, targetPlayer in pairs(Players) do
		if targetPlayer:IsAliveCiv() and targetPlayerID ~= playerID and not targetPlayer:IsMinorCiv() and targetPlayer:IsAtPeace(player) then
			if deal:IsPossibleToTradeItem(targetPlayerID, playerID, TradeableItems.TRADE_ITEM_ALLOW_EMBASSY, Game.GetDealDuration()) then
				log:Debug("%15s embassy", targetPlayer:GetName())
				deals[1].num = deals[1].num + 1
			end
			if deal:IsPossibleToTradeItem(targetPlayerID, playerID, TradeableItems.TRADE_ITEM_OPEN_BORDERS, Game.GetDealDuration()) then
				log:Debug("%15s border deal", targetPlayer:GetName())
				deals[2].num = deals[2].num + 1
			end
			if deal:IsPossibleToTradeItem(targetPlayerID, playerID, TradeableItems.TRADE_ITEM_RESEARCH_AGREEMENT, Game.GetDealDuration()) then
				log:Debug("%15s research deal", targetPlayer:GetName())
				deals[3].num = deals[3].num + 1
			end
			if deal:IsPossibleToTradeItem(targetPlayerID, playerID, TradeableItems.TRADE_ITEM_DEFENSIVE_PACT, Game.GetDealDuration()) then
				log:Debug("%15s defense deal", targetPlayer:GetName())
				deals[4].num = deals[4].num + 1
			end
			if player:IsHuman() and targetPlayer:IsHuman() then
				if deal:IsPossibleToTradeItem(targetPlayerID, playerID, TradeableItems.TRADE_ITEM_DECLARATION_OF_FRIENDSHIP, Game.GetDealDuration()) then
					log:Debug("%15s alliance", targetPlayer:GetName())
					deals[5].num = deals[5].num + 1
				end
			elseif (not targetPlayer:IsDoF(playerID) and not targetPlayer:IsDoFMessageTooSoon(playerID)) then
				log:Debug("%15s alliance", targetPlayer:GetName())
				deals[5].num = deals[5].num + 1
			end
		end
	end
	return deals
end

------------------------------------------------------------------
-- approachType:GetMinorApproach()
--
function PlayerClass.GetMinorApproach(player, approachType)
	for row in GameInfo.Leader_MinorCivApproachBiases(
			string.format(
				"LeaderType='%s' AND MinorCivApproachType='%s'", 
				GameInfo.Leaders[player:GetLeaderType()].Type,
				approachType
			)
		) do
		return row.bias
	end
	log:Fatal("player:GetMinorApproach: %s not a valid approach type!", approachType)	
	return false
end

------------------------------------------------------------------
-- player:GetRivalInfluence(minorCiv) returns the ID and influence of player's rival for minorCiv
--
function PlayerClass.GetRivalInfluence(player, minorCiv)
	local playerID 			= player:GetID()
	local rivalID			= -1
	local rivalInfluence	= 0
	for majorCivID, majorCiv in pairs(Players) do
		if majorCiv:IsAliveCiv() and not majorCiv:IsMinorCiv() and majorCivID ~= playerID then
			local influence = minorCiv:GetMinorCivFriendshipWithMajor(majorCivID)
			if influence > rivalInfluence then
				rivalID = majorCivID
				rivalInfluence = influence
			end
		end
	end
	return rivalInfluence, rivalID
end

---------------------------------------------------------------------
--[[ player:GetPurchaseCostMod usage example:

]]
function PlayerClass.GetPurchaseCostMod(player, baseCost, hurryCostMod)
	local costMultiplier = -1
	if hurryCostMod == -1 then
		return costMultiplier
	end
	costMultiplier = math.pow(baseCost * GameDefines.GOLD_PURCHASE_GOLD_PER_PRODUCTION, GameDefines.HURRY_GOLD_PRODUCTION_EXPONENT)
	costMultiplier = costMultiplier * (1 + hurryCostMod / 100)
	local empireMod = 100

	for row in GameInfo.Building_HurryModifiers() do
		for city in player:Cities() do
			if city:IsHasBuilding(GameInfo.Buildings[row.BuildingType].ID) then
				empireMod = empireMod + row.HurryCostModifier
			end
		end
	end
	for row in GameInfo.Policy_HurryModifiers() do
		if player:HasPolicy(GameInfo.Policies[row.PolicyType].ID) then
			empireMod = empireMod + row.HurryCostModifier
		end
	end
	costMultiplier = (costMultiplier * empireMod) / 100
	costMultiplier = Game.Round(costMultiplier / baseCost * 100, -1)
	return costMultiplier
end


---------------------------------------------------------------------
-- player:GetResourceQuantities(resID)
--
function PlayerClass.GetResourceQuantities(player, resID)
	local res	= {
		IsStrategic	= (Game.GetResourceUsageType(resID) == ResourceUsageTypes.RESOURCEUSAGE_STRATEGIC),
		IsLuxury	= (Game.GetResourceUsageType(resID) == ResourceUsageTypes.RESOURCEUSAGE_LUXURY),
		isBonus		= (Game.GetResourceUsageType(resID) == ResourceUsageTypes.RESOURCEUSAGE_BONUS),
		Tradable	= player:GetNumResourceTotal(resID, false),
		Available	= player:GetNumResourceAvailable(resID, true),
		Used		= player:GetNumResourceUsed(resID, true),
		Imported	= player:GetResourceImport(resID),
		Exported	= player:GetResourceExport(resID),
		Citystates	= player:GetResourceFromMinors(resID)
	}

	if not res.IsStrategic and (res.Available > 0) and (res.Available == res.Tradable) then
		res.Tradable = res.Tradable - 1
	end

	res.Active = false
	res.Color = (res.Available == 0) and "[COLOR_GREY]" or "[COLOR_WHITE]"
	
	if res.Tradable > 0 then
		res.Color = "[COLOR_GREEN]"
	elseif res.IsStrategic then
		if res.Available < 0 then
			res.Color = "[COLOR_RED]"
		end
	elseif res.Available == 0 then
		if res.Exported > 0 then
			res.Color = "[COLOR_RED]"
		end
		if player:GetID() == Game.GetActivePlayer() then
			res.Cities, res.NumCities = player:GetCitiesDemandingResource(resID)
			if res.Cities then
				res.Color = "[COLOR_YELLOW]"
			end
		end
	end
	return res
end


---------------------------------------------------------------------
-- player:GetCitiesDemandingResource(resourceID)
-- returns a table of {cityID, city} pairs
function PlayerClass.GetCitiesDemandingResource(player, resourceID)
	local cities = nil
	local numCities = 0
	for city in player:Cities() do
		if city:GetWeLoveTheKingDayCounter() == 0 and city:GetResourceDemanded(true) == resourceID then
			cities = cities or {}
			cities[City_GetID(city)] = city
			numCities = numCities + 1
		end
	end
	return cities, numCities
end

------------------------------------------------------------------
--[[ usage: somePlayer:GetTraitInfo()
local trait = somePlayer:GetTraitInfo()
]]

function PlayerClass.GetTraitInfo(player)
	if not GameInfo.Leaders[player:GetLeaderType()] then
		log:Error("%s is not a leader", player:GetName())
		return nil
	end
	local leaderType = GameInfo.Leaders[player:GetLeaderType()].Type
	local traitType = GameInfo.Leader_Traits("LeaderType ='" .. leaderType .. "'")().TraitType
	return GameInfo.Traits[traitType]
end

------------------------------------------------------------------
-- player:GetPersonalityInfo()
--
function PlayerClass.GetPersonalityInfo(player)
	local leaderInfo = GameInfo.Leaders[player:GetLeaderType()]
	if not leaderInfo then
		log:Error("%s is not a leader", player:GetName())
		return nil
	elseif not leaderInfo.Personality then
		log:Error("%s has no personality", player:GetName())
		return nil
	end
	return GameInfo.Personalities[leaderInfo.Personality]
end

---------------------------------------------------------------------
--[[ player:GetTurnAcquired(city) usage example:

]]
function PlayerClass.GetTurnAcquired(player, city)
	if not city then
		log:Fatal("player:GetTurnAcquired city=nil")
		return nil
	end
	local playerID = player:GetID()
	local cityID = City_GetID(city)
	MapModData.Cep_TurnAcquired[playerID] = MapModData.Cep_TurnAcquired[playerID] or {}
	return MapModData.Cep_TurnAcquired[playerID][City_GetID(city)]
end

function PlayerClass.SetTurnAcquired(player, city, turn)
	if not city then
		log:Fatal("player:SetTurnAcquired city=nil")
		return nil
	end
	local playerID = player:GetID()
	local cityID = City_GetID(city)
	MapModData.Cep_TurnAcquired[playerID] = MapModData.Cep_TurnAcquired[playerID] or {}
	MapModData.Cep_TurnAcquired[playerID][cityID] = turn
	SaveValue(turn, "MapModData.Cep_TurnAcquired[%s][%s]", playerID, cityID)
end

function UpdateTurnAcquiredFounding(hexPos, playerID, cityID, cultureType, eraType, continent, populationSize, size, fowState)
	local player = Players[playerID]
	local plot = Map.GetPlot(ToGridFromHex(hexPos.x, hexPos.y))
	player:SetTurnAcquired(plot:GetPlotCity(), Game.GetGameTurn())
end

function UpdateTurnAcquiredCapture(hexPos, lostPlayerID, cityID, wonPlayerID)
	local player = Players[wonPlayerID]
	local plot = Map.GetPlot(ToGridFromHex(hexPos.x, hexPos.y))
	local city = plot:GetPlotCity()
	if city then
		player:SetTurnAcquired(city, Game.GetGameTurn())
	else
		log:Error("UpdateTurnAcquiredCapture: plot #%s is not a city?", Plot_GetID(plot))		
	end	
end

---------------------------------------------------------------------
--[[ player:GetUniqueUnitID(itemClass) usage example:
player:InitUnit( player:GetUniqueUnitID("UNITCLASS_ARCHER"),  x, y )
capitalCity:SetNumRealBuilding(player:GetUniqueBuildingID("BUILDINGCLASS_MARKET"), 1)
]]

function PlayerClass.GetUniqueUnitID(player, itemClass)
	local civType = GameInfo.Civilizations[player:GetCivilizationType()].Type
	if not itemClass then
		log:Error("Invalid unit class: %s", itemClass)
		return nil
	end
	if not GameInfo.UnitClasses[itemClass] then
		log:Error("Invalid unit class: %s", itemClass)
		return nil
	end
	
	local itemType = GameInfo.UnitClasses[itemClass].DefaultUnit
	if civType ~= "CIVILIZATION_MINOR" and civType ~= "CIVILIZATION_BARBARIAN" then
		local query = string.format("CivilizationType = '%s' AND UnitClassType = '%s'", civType, itemClass)
		for itemInfo in GameInfo.Civilization_UnitClassOverrides(query) do
			itemType = itemInfo.UnitType
			break
		end
	end
	return GameInfo.Units[itemType].ID
end

function PlayerClass.GetUniqueBuildingID(player, itemClass)
	if not player then
		log:Error("player:GetUniqueBuildingID player=nil")
		return nil
	end
	if not GameInfo.Civilizations[player:GetCivilizationType()] then
		log:Error("player:GetUniqueBuildingID invalid civilization: player=%s itemClass=%s", player:GetName(), itemClass)
		return nil
	end
	local civType = GameInfo.Civilizations[player:GetCivilizationType()].Type
	if not GameInfo.BuildingClasses[itemClass] then
		log:Error("Invalid building class: %s", itemClass)
		return nil
	end
	
	local itemType = GameInfo.BuildingClasses[itemClass].DefaultBuilding
	if civType ~= "CIVILIZATION_MINOR" and civType ~= "CIVILIZATION_BARBARIAN" then
		local query = string.format("CivilizationType = '%s' AND BuildingClassType = '%s'", civType, itemClass)
		for itemInfo in GameInfo.Civilization_BuildingClassOverrides(query) do
			itemType = itemInfo.BuildingType
			break
		end
	end
	return GameInfo.Buildings[itemType].ID
end

------------------------------------------------------------------
--
function PlayerClass.GetExportColor(minorCiv, resID, resImproved, resNear)
	local activePlayerID = Game.GetActivePlayer()
	local allyID = minorCiv:GetAlly()
	if allyID == activePlayerID then
		-- allied
		if resImproved == resNear then
			return "[COLOR_POSITIVE_TEXT]"
		else
			return "[COLOR_WHITE]"
		end
	elseif (not resID) or (minorCiv:GetNumResourceTotal(resID, false) > 0) then
		if allyID and allyID ~= -1 then
			-- rival ally
			if minorCiv:GetMinorCivFriendshipWithMajor(activePlayerID) >= GameDefines.FRIENDSHIP_THRESHOLD_ALLIES then
				return "[COLOR_NEGATIVE_TEXT]"
			else
				return "[COLOR_PLAYER_ORANGE_TEXT]"
			end
		else
			-- no ally
			return "[COLOR_YELLOW]"
		end
	end
	return "[COLOR_GREY]"
end

------------------------------------------------------------------
--
function PlayerClass.GetNearbyResources(minorCiv)
	local minorCivID = minorCiv:GetID()
	local capital = minorCiv:GetCapitalCity()
	local resList = {}
	
	if capital then
		local centerX = capital:GetX()
		local centerY = capital:GetY()
		local radius = 5
		local closeRange = 2
		for x = -radius, radius, 1 do
			for y = -radius, radius, 1 do
				local tarPlot = Map.GetPlotXY(centerX, centerY, x, y)
				if tarPlot ~= nil then
					local ownerID = tarPlot:GetOwner()
					if (ownerID == minorCivID or ownerID == -1) then
						local plotX = tarPlot:GetX()
						local plotY = tarPlot:GetY()
						local plotDistance = Map.PlotDistance(centerX, centerY, plotX, plotY)
						if plotDistance <= radius and (plotDistance <= closeRange or ownerID == minorCivID) then
							local resID = tarPlot:GetResourceType(Game.GetActiveTeam())
							if resID ~= -1 and Game.GetResourceUsageType(resID) ~= ResourceUsageTypes.RESOURCEUSAGE_BONUS then
								resList[resID] = (resList[resID] or 0) + tarPlot:GetNumResource()
							end
						end
					end
				end
			end
		end
	end

	return resList
end


------------------------------------------------------------------
-- minorCiv:GetMinorYieldString(showDetails)
--
function PlayerClass.GetMinorYieldString(minorCiv, showDetails)
	local yieldString		= ""
	local query				= ""
	local activePlayerID	= Game.GetActivePlayer()
	local activePlayer		= Players[activePlayerID]
	local traitID			= minorCiv:GetMinorCivTrait()
	local friendLevel		= minorCiv:GetMinorCivFriendshipLevelWithMajor(activePlayerID)
	local yieldColor		= minorCiv:GetExportColor()
	local yieldList, yieldsIfAlly = activePlayer:GetCitystateYields(traitID, friendLevel)
	if friendLevel <= 0 then
		yieldList = yieldsIfAlly
	end
	--log:Trace("GetCitystateYields(%s, %s) = %s", GameInfo.MinorCivTraits[traitID].Type, friendLevel, yieldList)
	for yieldInfo in GameInfo.Yields() do
		yieldID = yieldInfo.ID
		local yieldName = ""
		local yield = 0
		if showDetails then
			yieldName = Locale.ConvertTextKey(yieldInfo.Description) .. " "
		end
		if yieldID == YieldTypes.YIELD_SCIENCE and friendLevel >= 2 then
			for policyInfo in GameInfo.Policies("MinorScienceAllies = 1") do
				if activePlayer:HasPolicy(policyInfo.ID) then
					if showDetails then
						yieldName = yieldName .. "[NEWLINE]"
					end
					yield = yield + Game.Round(0.25 * minorCiv:GetYieldRate(yieldID))
				end
			end
		elseif yieldID == YieldTypes.YIELD_HAPPINESS_NATIONAL then
			query = string.format("FriendLevel = %s AND YieldType = '%s'", friendLevel, yieldInfo.Type)
			for row in GameInfo.Policy_MinorCivBonuses(query) do
				if activePlayer:HasPolicy(GameInfo.Policies[row.PolicyType].ID) then
					if showDetails then
						yieldName = yieldName .. "[NEWLINE]"
					end
					yield = yield + row.Yield
				end
			end
		elseif yieldID == YieldTypes.YIELD_PRODUCTION then
			query = string.format("FriendLevel = %s AND YieldType = '%s'", friendLevel, yieldInfo.Type)
			for row in GameInfo.Policy_MinorCivBonuses(query) do
				if activePlayer:HasPolicy(GameInfo.Policies[row.PolicyType].ID) then
					if showDetails then
						yieldName = string.format("%s(%s)[NEWLINE]", yieldName, Locale.ConvertTextKey("TXT_KEY_PER_CITY"))
					end
					yield = yield + row.Yield
				end
			end
		end
		if yieldList[yieldID] > 0 and yieldID ~= YieldTypes.YIELD_CS_MILITARY then
			if showDetails then
				if yieldID == YieldTypes.YIELD_EXPERIENCE then
					yieldName = string.format("%s(%s)[NEWLINE]", yieldName, Locale.ConvertTextKey("TXT_KEY_MILITARY_UNIT_REWARDS"))
				elseif yieldID == YieldTypes.YIELD_FOOD or yieldID == YieldTypes.YIELD_CULTURE then
					yieldName = string.format("%s(%s)[NEWLINE]", yieldName, Locale.ConvertTextKey("TXT_KEY_SPLIT_AMONG_CITIES"))
				end
			end
			yield = yield + yieldList[yieldID]
		end
		if yield > 0 then
			yieldString = string.format(
				"%s%s%s%s[ENDCOLOR] %s",
				yieldString,
				yieldInfo.IconString,
				yieldColor,
				yield,
				yieldName
			)
		end
	end
	if showDetails then
		yieldString = yieldString .. minorCiv:GetCitystateThresholdString()
	end
	return Game.RemoveExtraNewlines(yieldString)
end

------------------------------------------------------------------
-- minorCiv:GetCitystateThresholdString()
--
function PlayerClass.GetCitystateThresholdString(minorCiv)
	local csString = ""
	local activePlayerID = Game.GetActivePlayer()
	local activePlayer = Players[activePlayerID]
	if not (minorCiv:IsAllies(activePlayerID) or minorCiv:IsFriends(activePlayerID)) then
		return ""
	end
	
	local traitID 		= minorCiv:GetMinorCivTrait()
	local yieldType		= nil
	local yieldStored	= 0
	local yieldNeeded	= 0
	local yieldRate		= 0
	local turnsLeft		= "-"
	
	--print("GetCitystateThresholdString")
	if Cep.MINOR_CIV_MILITARISTIC_REWARD_NEEDED ~= 0 and traitID == MinorCivTraitTypes.MINOR_CIV_TRAIT_MILITARISTIC then
		yieldType		= YieldTypes.YIELD_CS_MILITARY
		yieldStored		= activePlayer:GetYieldStored(yieldType)
		yieldNeeded		= activePlayer:GetYieldNeeded(yieldType)
		yieldRate		= activePlayer:GetYieldRate(yieldType)
		turnsLeft		= "-"

		if yieldRate > 0 then
			turnsLeft = math.ceil((yieldNeeded - yieldStored) / yieldRate)
			yieldRate = "[COLOR_POSITIVE_TEXT] +" .. yieldRate .. "[ENDCOLOR]"
		else
			yieldRate = ""
		end
		
		--log:Debug("yieldStored=%s yieldNeeded=%s yieldRate=%s", yieldStored, yieldNeeded, yieldRate)
		csString = csString .. Locale.ConvertTextKey("TXT_KEY_DIPLO_STATUS_MILITARISTIC_REWARD_TT", turnsLeft, yieldStored, yieldNeeded, yieldRate) .. "[NEWLINE]"
	end

	if Cep.MINOR_CIV_GREAT_PERSON_REWARD_NEEDED ~= 0  then
		yieldType 		= YieldTypes.YIELD_CS_GREAT_PEOPLE
		yieldStored		= activePlayer:GetYieldStored(yieldType)
		yieldNeeded		= activePlayer:GetYieldNeeded(yieldType)
		yieldRate		= activePlayer:GetYieldRate(yieldType)
		turnsLeft		= "-"

		if yieldRate > 0 then
			turnsLeft = math.ceil((yieldNeeded - yieldStored) / yieldRate)
			yieldRate = "[COLOR_POSITIVE_TEXT] +" .. yieldRate .. "[ENDCOLOR]"
		
			--log:Debug("yieldStored=%s yieldNeeded=%s yieldRate=%s", yieldStored, yieldNeeded, yieldRate)
			csString = csString .. Locale.ConvertTextKey("TXT_KEY_DIPLO_STATUS_GREAT_PERSON_REWARD_TT", turnsLeft, yieldStored, yieldNeeded, yieldRate) .. "[NEWLINE]"
		end
	end
	return csString
end

---------------------------------------------------------------------
--[[ player:HasBelief(belief) usage example:

]]
function PlayerClass.HasBelief(player, beliefType)	
	if not beliefType or not GameInfo.Beliefs[beliefType] then
		log:Fatal("PlayerClass.HasBelief invalid belief=%s", beliefType)
	end
	local beliefID = GameInfo.Beliefs[beliefType].ID

	if player:HasCreatedReligion() then
		local religionID = player:GetReligionCreatedByPlayer()
		for i, religionBeliefID in ipairs(Game.GetBeliefsInReligion(religionID)) do
			if religionBeliefID == beliefID then
				return true
			end
		end
	elseif player:HasCreatedPantheon() and player:GetBeliefInPantheon() == beliefID then
		return true
	end
	return false
end

---------------------------------------------------------------------
-- player:HasBuilding(buildingType)
--
function PlayerClass.HasBuilding(player, buildingType)
	local buildingID = GameInfo.Buildings[buildingType].ID
	for city in player:Cities() do
		if city:IsHasBuilding(buildingID) then
			return true
		end
	end
	return false
end

---------------------------------------------------------------------
--[[ player:HasTech(tech) usage example:

]]
function PlayerClass.HasTech(player, tech)
	return Teams[player:GetTeam()]:IsHasTech(GameInfo.Technologies[tech].ID)
end

---------------------------------------------------------------------
-- player:GetImprovableResources()
--
function PlayerClass.GetImprovableResources(player)
	local playerID = player:GetID()
	local plotList = nil
	local activePlayer = Players[Game.GetActivePlayer()]
	for city in player:Cities() do
		if not city:IsRazing() then
			for plot in Plot_GetPlotsInCircle(city:Plot(), 1, 4) do
				local resID = plot:GetResourceType(Game.GetActiveTeam())
				if plot:GetOwner() == playerID and resID ~= -1 and Game.GetResourceUsageType(resID) ~= ResourceUsageTypes.RESOURCEUSAGE_BONUS then
					local query = string.format("ResourceType = '%s'", GameInfo.Resources[resID].Type)
					for info in GameInfo.Improvement_ResourceTypes(query) do
						local improveInfo = GameInfo.Improvements[info.ImprovementType]
						local techType = Game.GetValue("PrereqTech", {ImprovementType=improveInfo.Type}, GameInfo.Builds)
						if (not improveInfo.CreatedByGreatPerson
							and not improveInfo.SpecificCivRequired
							and (improveInfo.Water == plot:IsWater())
							and (plot:IsImprovementPillaged() or plot:GetImprovementType() ~= improveInfo.ID)
							and (not techType or activePlayer:HasTech(techType))
							) then
							plotList = plotList or {}
							plotList[Plot_GetID(plot)] = improveInfo.ID
						end
					end
				end
			end				
		end
	end
	return plotList
end

function PlayerClass.ImproveResources(player, plotList)
	plotList = plotList or player:GetImprovableResources()
	if not plotList then
		return
	end
	for plotID, improveID in pairs(plotList) do
		local plot = Map.GetPlotByIndex(plotID)
		if plot:IsImprovementPillaged() then
			plot:SetImprovementPillaged(false)
		else
			Plot_BuildImprovement(plot, improveID)
		end
	end
end

---------------------------------------------------------------------
--[[ player:SetHasTech(tech) usage example:

]]
function PlayerClass.SetHasTech(player, tech, isResearched)
	local techID = GameInfo.Technologies[tech].ID
	Teams[player:GetTeam()]:GetTeamTechs():SetHasTech(techID, isResearched)
	player:SetResearchingTech(techID, not isResearched)
end

---------------------------------------------------------------------
--[[ player:HasBuilding(building) usage example:

]]
function PlayerClass.HasBuilding(player, building)
	for city in player:Cities() do
		if City_GetNumBuilding(city, building) ~= 0 then
			return true
		end
	end
	return false
end

---------------------------------------------------------------------
--[[ player:InitUnitType(unit, plot, experience) usage example:

local availableIDs	= City_GetBuildableUnitIDs(player)
local newUnitID		= availableIDs[1 + Map.Rand(#availableIDs, "InitUnitFromList")]
local capitalPlot	= capitalCity:Plot()
local exp			= (1 + player:GetCurrentEra()) * Cep.MINOR_CIV_MILITARISTIC_XP_PER_ERA
player:InitUnitType(newUnitID, capitalPlot, exp)
]]



function PlayerClass.InitUnitType(player, unit, plot, exp)
	local newUnit = player:InitUnit(GameInfo.Units[unit].ID, plot:GetX(), plot:GetY())
	if exp then
		newUnit:ChangeExperience(exp)
		newUnit:SetPromotionReady(newUnit:GetExperience() >= newUnit:ExperienceNeeded())
	end
	return newUnit
end

---------------------------------------------------------------------
--[[ player:InitUnitClass(unititemClass, plot, experience) usage example:

local availableIDs	= City_GetBuildableUnitIDs(player)
local newUnitID		= availableIDs[Map.Rand(#availableIDs, "InitUnitFromList")]
local capitalPlot	= capitalCity:Plot()
local exp			= (1 + player:GetCurrentEra()) * Cep.MINOR_CIV_MILITARISTIC_XP_PER_ERA
player:InitUnitType(newUnitID, capitalPlot, exp)
]]

function PlayerClass.InitUnitClass(player, unititemClass, plot, exp)
	if not unititemClass then
		log:Error("%s InitUnitClass unititemClass=nil", player:GetName())
		return
	end
	local newUnit = player:InitUnit( player:GetUniqueUnitID(unititemClass), plot:GetX(), plot:GetY() )
	if exp then
		newUnit:ChangeExperience(exp)
	end
	return newUnit
end

----------------------------------------------------------------
--[[ player:IsAliveCiv() usage example:
for playerID,player in pairs(Players) do
	if player:IsAliveCiv() and player:IsMinorCiv() then
		local capitalCity = player:GetCapitalCity()
		player:InitUnit( GameInfo.Units.UNIT_ARCHER.ID, capitalCity:GetX(), capitalCity:GetY() )
		player:InitUnit( GameInfo.Units.UNIT_WARRIOR.ID, capitalCity:GetX(), capitalCity:GetY() )
		player:InitUnit( GameInfo.Units.UNIT_WARRIOR.ID, capitalCity:GetX(), capitalCity:GetY() )
	end
end
]]

function PlayerClass.IsAliveCiv(player)
	return player and player:IsAlive() and not player:IsBarbarian()
end

---------------------------------------------------------------------
-- player:IsBudgetGone(goldMin)
--
function PlayerClass.IsBudgetGone(player, goldMin, extraCost)
	return player:GetYieldStored(YieldTypes.YIELD_GOLD) < math.max(goldMin, (goldMin - 20 * ( player:GetYieldRate(YieldTypes.YIELD_GOLD)-(extraCost or 0) )))
end

---------------------------------------------------------------------
--[[ AI Functions

]]

function PlayerClass.IsMilitaristicLeader(player)
	if player:IsMinorCiv() then
		return player:GetMinorCivTrait() == MinorCivTraitTypes.MINOR_CIV_TRAIT_MILITARISTIC
	end
	return GameInfo.Leaders[player:GetLeaderType()].Boldness >= 5
	--[[
	local personality = player:GetPersonalityInfo().Type
	return (personality == "PERSONALITY_CONQUEROR" or personality == "PERSONALITY_COALITION")
	--]]
end

function PlayerClass.IsReligiousLeader(player)
	if player:IsMinorCiv() then
		return false
	end
	local leaderInfo = GameInfo.Leaders[player:GetLeaderType()]
	for row in GameInfo.Leader_Flavors{LeaderType = leaderInfo.Type, FlavorType = "FLAVOR_RELIGION"} do
		return row.Flavor >= 7
	end	
	return false
end

function PlayerClass.IsAtWarWithHuman(player)
	for otherPlayerID, otherPlayer in pairs(Players) do
		if otherPlayer:IsAliveCiv() and player:IsAtWar(otherPlayer) and otherPlayer:IsHuman() then
			return true
		end
	end
	return false
end

function PlayerClass.IsAtWarWithAny(player)
	for otherPlayerID, otherPlayer in pairs(Players) do
		if otherPlayer:IsAliveCiv() and player:IsAtWar(otherPlayer) then
			return true
		end
	end
	return false
end

function PlayerClass.EverAtWarWithHuman(player)
	return (MapModData.Cep_EverAtWarWithHuman[player:GetID()] == 1)
end

---------------------------------------------------------------------
--[[ player:Is

]]
function PlayerClass.HasMet(player, otherPlayer)
	if not player or not otherPlayer then
		log:Fatal("player:HasMet player=%s otherPlayer=%s", player, otherPlayer)
		return
	end
	return Teams[player:GetTeam()]:IsHasMet(otherPlayer:GetTeam())
end

function PlayerClass.IsAtWar(player, otherPlayer)
	if not player or not otherPlayer then
		log:Fatal("player:IsAtWar player=%s otherPlayer=%s", player, otherPlayer)
		return
	end
	return Teams[player:GetTeam()]:IsAtWar(otherPlayer:GetTeam())
end

function PlayerClass.IsAtPeace(player, otherPlayer)
	if not player or not otherPlayer then
		log:Fatal("player:IsAtPeace player=%s otherPlayer=%s", player, otherPlayer)
		return
	end
	return player:HasMet(otherPlayer) and not player:IsAtWar(otherPlayer)
end

---------------------------------------------------------------------
--[[ minorCiv:SetFriendship(majorCivID, friendship) usage example:

]]
function PlayerClass.SetFriendship(minorCiv, majorCivID, friendship)
	minorCiv:ChangeMinorCivFriendshipWithMajor(majorCivID, friendship - minorCiv:GetMinorCivFriendshipLevelWithMajor(majorCivID))
end









--
-- Initialization
--

--function InitTurnAcquired()
	if not MapModData.Cep_TurnAcquired then
		--print("InitTurnAcquired()")
		MapModData.Cep_TurnAcquired = {}
		startClockTime = os.clock()
		for playerID, player in pairs(Players) do
			MapModData.Cep_TurnAcquired[playerID] = {}
			if player:IsAliveCiv() then
				for city in player:Cities() do
					local cityID = City_GetID(city)
					if UI:IsLoadedGame() then
						MapModData.Cep_TurnAcquired[playerID][cityID] = LoadValue("MapModData.Cep_TurnAcquired[%s][%s]", playerID, cityID) 
					end
					if not MapModData.Cep_TurnAcquired[playerID][cityID] then
						player:SetTurnAcquired(city, city:GetGameTurnAcquired())
					end
				end
			end
		end
		if UI:IsLoadedGame() then
			log:Info("%3s ms loading TurnAcquired", Game.Round((os.clock() - startClockTime)*1000))
		end
	end
--end

--[[
if not MapModData.Cep_InitTurnAcquired then
	MapModData.Cep_InitTurnAcquired = true
	LuaEvents.MT_Initialize.Add(InitTurnAcquired)
end
--]]