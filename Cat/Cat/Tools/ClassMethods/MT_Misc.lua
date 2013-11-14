-- MT_Misc
-- Author: Thalassicus
-- DateCreated: 2/29/2012 8:19:17 AM
--------------------------------------------------------------

include("MT_LuaLogger.lua")
local log = Events.LuaLogger:New()
log:SetLevel("INFO")


--
-- Locale
--
-- Ideally replace vanilla functions, but Locale table is sadly read-only

ModLocale = {}

function ModLocale.ConvertTextKey(...)
	local arg = {...}
	if not arg[1] or arg[1] == "" then
		return ""
	end
	return Locale.ConvertTextKey(unpack(arg))
end

function ModLocale.ComparePriority(a, b)
	log:Debug("ComparePriority %30s=%2s %30s=%2s", a.Type, a.ListPriority, b.Type, b.ListPriority)
	if a.ListPriority and b.ListPriority and a.ListPriority ~= b.ListPriority then
		return a.ListPriority > b.ListPriority
	end
	return Locale.Compare(a.Name, b.Name) < 0
end

--
-- Game
--

----------------------------------------------------------------
function Game.AlertIfActive(alertText, player)
	if player and player ~= Players[Game.GetActivePlayer()] then
		return
	end
	Events.GameplayAlertMessage(alertText)
end



----------------------------------------------------------------
-- Game.GetAdjustedTurn()
--
function Game.GetAdjustedTurn()
	return Game.GetGameTurn() / (Game.GetSpeedInfo().VictoryDelayPercent / 100)
end

----------------------------------------------------------------
-- Game.GetAverageHumanEra()
--
function Game.GetAverageHumanEra()
	local eraSum = 0
	local numHumans = 0
	for playerID, player in pairs(Players) do
		if player:IsHuman() then
			numHumans = numHumans + 1
			eraSum = eraSum + player:GetCurrentEra()
		end
	end
	return Game.Round(eraSum / math.max(1, numHumans))
end

----------------------------------------------------------------
-- Game.GetAverageHumanHandicap()
--
function Game.GetAverageHumanHandicap()
	local sum = 0
	local numHumans = 0
	for playerID, player in pairs(Players) do
		if player:IsHuman() then
			numHumans = numHumans + 1
			sum = sum + player:GetHandicapType()
		end
	end
	return Game.Round(sum / math.max(1, numHumans))
end

----------------------------------------------------------------
--[[ Game.GetActiveHuman() usage example:
local playerActiveHuman = Game.GetActiveHuman()
]]
function Game.GetActiveHuman()
	local iPlayerID = Game.GetActivePlayer()
	if (iPlayerID < 0) then
		print("FATAL:  Game.GetActiveHuman player index not correct")
		return nil
	end

	if (not Players[iPlayerID]:IsHuman()) then
		print("FATAL:  Game.GetActiveHuman active player is not human")
		return nil
	end

	return Players[iPlayerID]
end

---------------------------------------------------------------------
--[[ Game.GetResourceIDsOfUsage(usageType) usage example:

local resIDs = Game.GetResourceIDsOfUsage(ResourceUsageTypes.RESOURCEUSAGE_STRATEGIC)
	
for _, resID in pairs(resIDs) do
	plotList[resID] = {}
end
]]
function Game.GetResourceIDsOfUsage(usageType)
	local resIDs = {}
	for resInfo in GameInfo.Resources() do
		if Game.GetResourceUsageType(resInfo.ID) == usageType then
			table.insert(resIDs, resInfo.ID)
		end
	end
	return resIDs
end

---------------------------------------------------------------------
-- Game.GetSortedResourceList(sort)
-- returns a sorted list of {resID, resInfo} pairs
--
-- sort is a table:		sort by order of usage types in the table
-- sort is true:		sort by all default usage types
-- sort is false/nil:	sort by name only
--
function Game.GetSortedResourceList(sort, reverseNames)
	local resources = {}
	for resInfo in GameInfo.Resources() do
		local resID = resInfo.ID
		local resUsage = Game.GetResourceUsageType(resInfo.ID)
		if type(sort) == "table" then
			for usageIndex, usage in ipairs(sort) do
				if usage == resUsage then
					--log:Debug("resUsage=%s usageIndex=%s usage=%s", resUsage, usageIndex, usage)
					table.insert(resources, {
						ID		= resID,
						Info	= resInfo,
						Name	= Locale.ConvertTextKey(resInfo.Description),
						Usage	= usageIndex
					})
				end
			end
		else
			table.insert(resources, {
				ID		= resID,
				Info	= resInfo,
				Name	= Locale.ConvertTextKey(resInfo.Description),
				Usage	= sort and (ResourceUsageTypes.NUM_RESOURCEUSAGE_TYPES - resUsage) or 0
			})
		end
	end
	table.sort(resources,
		function(a, b)
			if a and b then
				if a.Usage ~= b.Usage then
					return a.Usage < b.Usage
				end
				if reverseNames then
					return a.Name < b.Name
				else
					return a.Name > b.Name
				end
			else
				return a
			end
		end
	)
	for key, data in ipairs(resources) do
		resources[key] = data.Info
	end
	return resources
end

---------------------------------------------------------------------
--[[ Game.GetSpeedYieldMod(yieldID) usage example:

]]
function Game.GetSpeedYieldMod(yieldID)
	if yieldID == YieldTypes.YIELD_FOOD then
		return 0.01 * Game.GetSpeedInfo().GrowthPercent
	elseif yieldID == YieldTypes.YIELD_PRODUCTION then
		return 0.01 * Game.GetSpeedInfo().TrainPercent
	elseif yieldID == YieldTypes.YIELD_GOLD then
		return 0.01 * Game.GetSpeedInfo().GoldPercent
	elseif yieldID == YieldTypes.YIELD_SCIENCE then
		return 0.01 * Game.GetSpeedInfo().ResearchPercent
	elseif yieldID == YieldTypes.YIELD_CULTURE then
		return 0.01 * Game.GetSpeedInfo().CulturePercent
	elseif yieldID == YieldTypes.YIELD_FAITH then
		return 0.01 * Game.GetSpeedInfo().FaithPercent
	end
	return 0
end


--
-- UI
--


----------------------------------------------------------------
--[[ UI_StartDeal{args} usage example:

UI_StartDeal{
	fromPlayerID = player:GetID(),
	toPlayerID = Game.GetActivePlayer(),
	fromResources = {[resID]=tradeQuantity}
}
--]]

function UI_StartDeal(arg)	
	local fromPlayerID	= arg.fromPlayerID
	local toPlayerID	= arg.toPlayerID
	local fromGold		= arg.fromGold or 0
	local toGold		= arg.toGold or 0
	local fromGoldRate	= arg.fromGoldRate or 0
	local toGoldRate	= arg.toGoldRate or 0
	local fromResources	= arg.fromResources or {}
	local toResources	= arg.toResources or {}
	local agreement		= arg.agreement	or ""
	local otherPlayerID	= (fromPlayerID == Game.GetActivePlayer()) and toPlayerID or fromPlayerID	
	
	--[[
	if Players[toPlayerID]:IsHuman() then
		Events.OpenPlayerDealScreenEvent(toPlayerID)
	else
		UI.SetRepeatActionPlayer(toPlayerID)
		UI.ChangeStartDiploRepeatCount(1)
		Players[toPlayerID]:DoBeginDiploWithHuman()
	end
	--[==[]]
	
	if not fromPlayerID then
		log:Fatal("UI_StartDeal fromPlayerID=nil")
	end
	if not toPlayerID then
		log:Fatal("UI_StartDeal toPlayerID=nil")
	end
	
	log:Debug("UI_StartDeal fromP=%s toP=%s activeID=%s otherPlayerID=%s", fromPlayerID, toPlayerID, Game.GetActivePlayer(), otherPlayerID)
	--[[
	if Players[otherPlayerID]:IsHuman() then
		Events.OpenPlayerDealScreenEvent(otherPlayerID)
	else
		UI.SetRepeatActionPlayer(playerID)
		UI.ChangeStartDiploRepeatCount(1)
		Players[otherPlayerID]:DoBeginDiploWithHuman()
	end
	--]]

	local deal			= UI.GetScratchDeal()
	local dealDuration	= Game.GetDealDuration()

	deal:ClearItems()
	deal:SetFromPlayer(fromPlayerID)
	deal:SetToPlayer(toPlayerID)
	
	if fromGold > 0 then
		deal:AddGoldTrade(fromPlayerID, fromGold)
	end
	if toGold > 0 then
		deal:AddGoldTrade(toPlayerID, toGold)
	end
	for resID, resNum in pairs(fromResources) do
		--log:Debug("resID=%s resNum=%s", resID, resNum)
		deal:AddResourceTrade(fromPlayerID, resID, resNum, dealDuration)
	end
	for resID, resNum in pairs(toResources) do
		--log:Debug("resID=%s resNum=%s", resID, resNum)
		deal:AddResourceTrade(toPlayerID, resID, resNum, dealDuration)
	end
	if agreement == "Embassy" then
		deal:AddAllowEmbassy(fromPlayerID, dealDuration)
		deal:AddAllowEmbassy(toPlayerID, dealDuration)
	elseif agreement == "OpenBorders" then
		deal:AddOpenBorders(fromPlayerID, dealDuration)
		deal:AddOpenBorders(toPlayerID, dealDuration)
	elseif agreement == "DefensePact" then
		deal:AddDefensivePact(fromPlayerID, dealDuration)
		deal:AddDefensivePact(toPlayerID, dealDuration)
	elseif agreement == "ResearchAgreement" then
		deal:AddResearchAgreement(fromPlayerID, dealDuration)
		deal:AddResearchAgreement(toPlayerID, dealDuration)
	elseif agreement == "Alliance" then
		deal:AddDeclarationOfFriendship(fromPlayerID, dealDuration)
		deal:AddDeclarationOfFriendship(toPlayerID, dealDuration)
	end
	
	UI.DoEqualizeDealWithHuman()
	--[[
	if not Players[otherPlayerID]:IsHuman() then
		DisplayDeal()
		--UI.DoEqualizeDealWithHuman()
	end
	--]]
	--]==]
end





--
-- Misc
--

----------------------------------------------------------------
--[[ Plots(sort) usage example:

-- GenerateCoasts function
for i, plot in Plots() do
	if(plot:IsWater()) then
		if(plot:IsAdjacentToLand()) then
			plot:SetTerrainType(shallowWater, false, false)
		else
			plot:SetTerrainType(deepWater, false, false)
		end
	end
end
]]
local _plots = _plots or {}
function Plots(sort)
	local _indices = {}
	for i = 0, Map.GetNumPlots(), 1 do
		_indices[i] = i - 1
	end	
	
	if(sort) then
		sort(_indices)
	end
	
	local cur = 0
	local function it()
		cur = cur + 1
		local index = _indices[cur]
		local plot
		
		if(index) then
			plot = _plots[index] or Map.GetPlotByIndex(index)
			_plots[index] = plot
		end
		return index, plot
	end
	
	return it
end
------------------------------------------------------------------
--[[ Game.HasValue(conditionList, tableName) usage: returns true where CONDITIONS in TABLE
Game.HasValue( {BuildingType=pBuildingInfo.Type}, GameInfo.Building_LakePlotYieldChanges )
]]
function Game.HasValue(conditionList, tableName)
	if tableName then
		for tableEntry in tableName() do
			local isMatch = true
			for k,v in pairs(conditionList) do
				if tableEntry[k] ~= v then
					isMatch = false
					break
				end
			end
			if isMatch then
				return true
			end
		end
	end
	return false
end

------------------------------------------------------------------
--[[ Game.GetValue(valueName, conditionList, tableName) usage: returns VALUE where CONDITONS in TABLE
Game.GetValue( "Yield", {BuildingType=pBuildingInfo.Type, YieldType="YIELD_FOOD"}, Game.Building_LakePlotYieldChanges )
]]
function Game.GetValue(valueName, conditionList, tableName)
	if not tableName then
		log:Error("Game.GetValue valueName=%s tableName=nil", valueName)
		return nil
	end
	for tableEntry in tableName() do
		local isMatch = true
		for k,v in pairs(conditionList) do
			if tableEntry[k] ~= v then
				isMatch = false
				break
			end
		end
		if isMatch then
			return tableEntry[valueName]
		end
	end
	return 0
end

------------------------------------------------------------------
--[[ Building_IsWonder(buildingType) usage: Building_IsWonder(buildingType)
if Building_IsWonder(GameInfo.Buildings.BUILDING_GREAT_LIBRARY) then
]]

function Building_IsWonder(buildingType, onlyWorldWonders)
	local buildingClassInfo = GameInfo.BuildingClasses[GameInfo.Buildings[buildingType].BuildingClass]
	return (buildingClassInfo.MaxGlobalInstances == 1) or (buildingClassInfo.MaxTeamInstances == 1) or (not onlyWorldWonders and buildingClassInfo.MaxPlayerInstances == 1)
end

------------------------------------------------------------------
-- Building_IsAddon(buildingType)
--

function Building_IsAddon(buildingType)
	return Game.HasValue({BuildingType=buildingType}, GameInfo.Building_Addons)
end

------------------------------------------------------------------
-- Building_IsAlreadyBuilt(buildingType)
--
function Building_IsAlreadyBuilt(buildingType, targetPlayer)
	local buildingInfo		= GameInfo.Buildings[buildingType]
	local buildingClassInfo	= GameInfo.BuildingClasses[buildingInfo.BuildingClass]

	if targetPlayer and buildingClassInfo.MaxPlayerInstances == 1 and targetPlayer:HasBuilding(buildingInfo.ID) then
		return true
	end
	if buildingClassInfo.MaxGlobalInstances == 1 then
		local wonderIsBuilt = false
		for playerID, player in pairs(Players) do
			if player:HasBuilding(buildingInfo.ID) then
				return true
			end
		end
	end
	return false
end

------------------------------------------------------------------
--[[ Improvement_GetBuildInfo(improvementType)
]]

function Improvement_GetBuildInfo(improvementType)
	local improvementType = GameInfo.Improvements[improvementType].Type
	for buildInfo in GameInfo.Builds(string.format("ImprovementType = '%s'", improvementType)) do
		return buildInfo
	end
	return -1
end