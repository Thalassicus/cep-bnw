-- YieldLibrary
-- Author: Thalassicus
-- DateCreated: 5/4/2011 10:43:09 AM
--------------------------------------------------------------

include("ModTools.lua")

if Game == nil or IncludedYieldLibrary then
	--print("Game is nil")
	return
end

--print("Initializing YieldLibrary.lua")

--IncludedYieldLibrary = true

local showTimers = Cep.DEBUG_TIMER_LEVEL
local timeStart = os.clock()

local log = Events.LuaLogger:New()
log:SetLevel("DEBUG")

PlayerClass	= getmetatable(Players[0]).__index
--PlotClass	= getmetatable(Map.GetPlotByIndex(0)).__index

do -- globals
	MapModData.Cep_AvoidModifier		= MapModData.Cep_AvoidModifier		or {}
	MapModData.Cep_CityWeights			= MapModData.Cep_CityWeights		or {}
	MapModData.Cep_MinorCivRewards		= MapModData.Cep_MinorCivRewards	or {}
	MapModData.Cep_PlayerCityIDs		= MapModData.Cep_PlayerCityIDs		or {}
	MapModData.Cep_PlayerCityWeights	= MapModData.Cep_PlayerCityWeights	or {}
	MapModData.Cep_UnitSupplyCurrent	= MapModData.Cep_UnitSupplyCurrent	or {}
	MapModData.Cep_UnitSupplyMax		= MapModData.Cep_UnitSupplyMax		or {}

	YieldTypes.YIELD_FOOD				= YieldTypes.YIELD_FOOD
	YieldTypes.YIELD_PRODUCTION			= YieldTypes.YIELD_PRODUCTION
	YieldTypes.YIELD_GOLD				= YieldTypes.YIELD_GOLD
	YieldTypes.YIELD_SCIENCE			= YieldTypes.YIELD_SCIENCE
	YieldTypes.YIELD_CULTURE			= GameInfo.Yields.YIELD_CULTURE.ID
	YieldTypes.YIELD_FAITH				= GameInfo.Yields.YIELD_FAITH.ID
	YieldTypes.YIELD_HAPPINESS_CITY		= GameInfo.Yields.YIELD_HAPPINESS_CITY.ID
	YieldTypes.YIELD_HAPPINESS_NATIONAL	= GameInfo.Yields.YIELD_HAPPINESS_NATIONAL.ID
	YieldTypes.YIELD_GREAT_PEOPLE		= GameInfo.Yields.YIELD_GREAT_PEOPLE.ID
	YieldTypes.YIELD_EXPERIENCE			= GameInfo.Yields.YIELD_EXPERIENCE.ID
	YieldTypes.YIELD_LAW				= GameInfo.Yields.YIELD_LAW.ID
	YieldTypes.YIELD_CS_MILITARY		= GameInfo.Yields.YIELD_CS_MILITARY.ID
	YieldTypes.YIELD_CS_GREAT_PEOPLE	= GameInfo.Yields.YIELD_CS_GREAT_PEOPLE.ID
	YieldTypes.YIELD_POPULATION			= GameInfo.Yields.YIELD_POPULATION.ID

	doUpdate = false

	CityYieldFocusTypes = {}
	CityYieldFocusTypes[YieldTypes.YIELD_FOOD]				= CityAIFocusTypes.CITY_AI_FOCUS_TYPE_FOOD
	CityYieldFocusTypes[YieldTypes.YIELD_PRODUCTION]		= CityAIFocusTypes.CITY_AI_FOCUS_TYPE_PRODUCTION
	CityYieldFocusTypes[YieldTypes.YIELD_GOLD]				= CityAIFocusTypes.CITY_AI_FOCUS_TYPE_GOLD
	CityYieldFocusTypes[YieldTypes.YIELD_SCIENCE]			= CityAIFocusTypes.CITY_AI_FOCUS_TYPE_SCIENCE
	CityYieldFocusTypes[YieldTypes.YIELD_CULTURE]			= CityAIFocusTypes.CITY_AI_FOCUS_TYPE_CULTURE
	CityYieldFocusTypes[YieldTypes.YIELD_FAITH]				= CityAIFocusTypes.CITY_AI_FOCUS_TYPE_FAITH
	CityYieldFocusTypes[YieldTypes.YIELD_HAPPINESS_CITY]	= -2
	CityYieldFocusTypes[YieldTypes.YIELD_HAPPINESS_NATIONAL]= -2
	CityYieldFocusTypes[YieldTypes.YIELD_GREAT_PEOPLE]		= CityAIFocusTypes.CITY_AI_FOCUS_TYPE_GREAT_PERSON
	CityYieldFocusTypes[YieldTypes.YIELD_EXPERIENCE]		= -2
	CityYieldFocusTypes[YieldTypes.YIELD_LAW]				= -2
	CityYieldFocusTypes[YieldTypes.YIELD_CS_MILITARY]		= -2
	CityYieldFocusTypes[YieldTypes.YIELD_CS_GREAT_PEOPLE]	= -2
	CityYieldFocusTypes[YieldTypes.YIELD_POPULATION]		= -2
end

---------------------------------------------------------------------
-- Yield Cache
---------------------------------------------------------------------

MapModData.YieldCache			= {}
LuaEvents.DirtyYieldCacheCity	= LuaEvents.DirtyYieldCacheCity or function() end
LuaEvents.DirtyYieldCachePlayer	= LuaEvents.DirtyYieldCachePlayer or function() end
LuaEvents.DirtyYieldCacheAll	= LuaEvents.DirtyYieldCacheAll or function() end

local yieldLevels = {
	"baseRate"					,
	"baseBuildingRate"			,
	"baseBuildingMod"			,
	"specialistRate"			,
	"surplusRate"				,
	"surplusMod"				,
	"surplusModFromBuildings"	,
	"totalRate"					,
	"playerRate"
}
for k, yieldLevel in pairs(yieldLevels) do
	MapModData.YieldCache[yieldLevel] = {}
	for yieldType, yieldID in pairs(YieldTypes) do
		MapModData.YieldCache[yieldLevel][yieldID] = {}
	end
end

function ResetYieldCacheCity(city)
	if not Players[Game.GetActivePlayer()]:IsTurnActive() then return end
	if not city then
		log:Error("ResetYieldCacheCity city=nil")
		return
	end
	--log:Info("ResetYieldCacheCity %s", city:GetName())
	cityID = City_GetID(city)
	for k, yieldLevel in pairs(yieldLevels) do
		for yieldType, yieldID in pairs(YieldTypes) do
			MapModData.YieldCache[yieldLevel][yieldID][cityID] = false
		end
	end	
end

function ResetYieldCachePlayer(player)
	if not player or not Players[Game.GetActivePlayer()]:IsTurnActive() then return end
	player:GetYieldsFromCitystates(true)
	player:UpdateModdedHappiness()
	for yieldInfo in GameInfo.Yields() do
		player:GetSupplyModifier(yieldInfo.ID, true)
		for city in player:Cities() do
			City_GetWeight(city, yieldInfo.ID, true)
		end
	end
	for k, yieldLevel in pairs(yieldLevels) do
		for yieldType, yieldID in pairs(YieldTypes) do
			MapModData.YieldCache[yieldLevel][yieldID][player:GetID()] = false
		end
	end	
	for city in player:Cities() do
		ResetYieldCacheCity(city)
	end
end

function ResetYieldCacheAll()
	if not Players[Game.GetActivePlayer()]:IsTurnActive() then return end
	for playerID, player in pairs(Players) do
		ResetYieldCachePlayer(player)
	end
end

function InitYieldCacheLevel(yieldLevel, yieldID)
	if not MapModData.YieldCache[yieldLevel] then
		log:Warn("yieldLevel %s does not exist!", yieldLevel)
		MapModData.YieldCache[yieldLevel] = {}
		for yieldType, yieldID in pairs(YieldTypes) do
			MapModData.YieldCache[yieldLevel][yieldID] = {}
		end
	end
	if not MapModData.YieldCache[yieldLevel][yieldID] then
		log:Error("%s does not exist for %s!", GameInfo.Yields[yieldID].Type, yieldLevel)
		MapModData.YieldCache[yieldLevel][yieldID] = {}
	end
end

function GetYieldCache(object, yieldLevel, yieldID, itemTable, itemID, queueNum)
	if itemTable then
		return false
	end	
	InitYieldCacheLevel(yieldLevel, yieldID)
	if yieldLevel == "playerRate" then
		return MapModData.YieldCache[yieldLevel][yieldID][object:GetID()]
	end
	return MapModData.YieldCache[yieldLevel][yieldID][City_GetID(object)]
end

function SetYieldCache(object, yieldLevel, yieldID, yield, itemTable, itemID, queueNum)
	if itemTable then
		return false
	end	
	InitYieldCacheLevel(yieldLevel, yieldID)
	if yieldLevel == "playerRate" then
		MapModData.YieldCache[yieldLevel][yieldID][object:GetID()] = yield
		--[[
		if yieldID == YieldTypes.YIELD_HAPPINESS_NATIONAL then
			local city = object:GetCapitalCity()
			if city then
				city:SetNumRealBuilding(GameInfo.Buildings.BUILDING_HAPPINESS_NATIONAL.ID, yield)
			end
		end
		--]]
	else
		MapModData.YieldCache[yieldLevel][yieldID][City_GetID(object)] = yield
		--[[
		if yieldID == YieldTypes.YIELD_HAPPINESS_CITY then
			if yield < 0 then
				log:Warn("SetYieldCache %s city happiness = %s", object:GetName(), yield)
			end
			object:SetNumRealBuilding(GameInfo.Buildings.BUILDING_HAPPINESS_CITY.ID, yield)
		end
		--]]
	end
end

--[[
function City_UpdateCityYieldCache(city)
	if showTimers == 3 then timeStart = os.clock() end
	if not city then
		log:Fatal("City_UpdateCityYieldCache city=nil")
	end
	local cityID = City_GetID(city)
	if not cityID then
		log:Fatal("City_UpdateCityYieldCache cityID=nil for %s", city:GetName())
	end
	
	MapModData.Cep_UpdateCityYieldCache = true	
	for yieldInfo in GameInfo.Yields() do
		City_GetYieldRate(city, yieldInfo.ID)
	end
	MapModData.Cep_UpdateCityYieldCache = false
	Events.SerialEventCityInfoDirty()
	
	if showTimers == 3 then print(string.format("%3s ms for City_UpdateCityYieldCache", math.floor((os.clock() - timeStart) * 1000))) end
end

function PlayerClass.UpdateCityYieldCache(player)
	if type(player) == "number" then
		log:Error("UpdateCityYieldCache player=%s", player)
		return nil
	end
	local activePlayer = Players[Game.GetActivePlayer()]
	if MapModData.YieldCacheDirty then
		if player == activePlayer then
			MapModData.YieldCacheDirty = false
		else
			activePlayer:UpdateCityYieldCache()
		end
	end
	
	if showTimers == 3 then timeStart = os.clock() end
	
	MapModData.Cep_UpdateCityYieldCache = true
	player:GetYieldsFromCitystates(true)
	player:UpdateModdedHappiness()
	for yieldInfo in GameInfo.Yields() do
		player:GetSupplyModifier(yieldInfo.ID, true)
		for city in player:Cities() do
			City_GetWeight(city, yieldInfo.ID, true)
		end	
	end
	for city in player:Cities() do
		City_UpdateCityYieldCache(city)
	end	
	MapModData.Cep_UpdateCityYieldCache = false
	
	if showTimers == 3 then print(string.format("%3s ms for PlayerClass.UpdateCityYieldCache", math.floor((os.clock() - timeStart) * 1000))) end
end
--]]

---------------------------------------------------------------------
-- Base Cost
---------------------------------------------------------------------

function City_GetCostMod(city, yieldID, itemTable, itemID)
	local costMod = 1
	if itemTable == nil then
		if city:GetProductionUnit() ~= -1 then
			itemID = city:GetProductionUnit()
			itemTable = GameInfo.Units
		end
		if city:GetProductionBuilding() ~= -1 then
			itemID = city:GetProductionBuilding()
			itemTable = GameInfo.Buildings
		end
		if city:GetProductionProject() ~= -1 then
			itemID = city:GetProductionProject()
			itemTable = GameInfo.Projects
		end
	end
	if yieldID == YieldTypes.YIELD_PRODUCTION then
		if itemTable == GameInfo.Buildings and itemID then
			costMod = 1 + city:GetPopulation() * itemTable[itemID].PopCostMod / 100
		end
		-- add new cost modifier here
	end
	return costMod
end

---------------------------------------------------------------------
-- Base Yield
---------------------------------------------------------------------

function City_GetBaseYieldRate(city, yieldID, itemTable, itemID, queueNum)
	if city == nil then
		log:Fatal("City_GetBaseYieldRate city=nil")
	elseif itemTable and not itemID then
		log:Fatal("City_GetBaseYieldRate itemID=nil")
	end
	--log:Debug("City_GetBaseYieldRate %15s %15s", city:GetName(), GameInfo.Yields[yieldID].Type)
	
	
	local baseRate = GetYieldCache(city, "baseRate", yieldID, itemTable, itemID, queueNum)
	if baseRate then
		return baseRate
	end	
	if showTimers == 3 then timeStart = os.clock() end
	
	baseRate = 0
	if false then --yieldID == YieldTypes.YIELD_HAPPINESS_CITY then	
		baseRate = City_GetBaseYieldFromTerrain(city, yieldID)
	else
		baseRate = (
			  City_GetBaseYieldFromTerrain		(city, yieldID)
			+ City_GetBaseYieldFromReligion		(city, yieldID)
			+ City_GetBaseYieldFromProcesses	(city, yieldID)
			+ City_GetBaseYieldFromBuildings	(city, yieldID)
			+ City_GetBaseYieldFromPopulation	(city, yieldID)
			+ City_GetBaseYieldFromSpecialists	(city, yieldID)
			+ City_GetBaseYieldFromPolicies		(city, yieldID)
			+ City_GetBaseYieldFromTraits		(city, yieldID)
			+ City_GetBaseYieldFromMinorCivs	(city, yieldID)
		)
	end
	if yieldID == YieldTypes.YIELD_HAPPINESS_CITY then	
		baseRate = math.min(baseRate, city:GetPopulation())
	end
	SetYieldCache(city, "baseRate", yieldID, baseRate, itemTable, itemID, queueNum)
	if showTimers == 3 then print(string.format("%3s ms for City_GetBaseYieldRate", math.floor((os.clock() - timeStart)*1000))) end
	return baseRate
end

function PlayerClass.GetBuildingYield(player, buildingID, yieldID, city)
	local buildingInfo = GameInfo.Buildings[buildingID]
	local yield = 0
	local yieldType = GameInfo.Yields[yieldID].Type
	local query = ""
	if yieldID == nil then
		log:Fatal("PlayerClass.GetBuildingYield yieldID=nil")
	end
	if buildingID == nil then
		log:Fatal("PlayerClass.GetBuildingYield buildingID=nil")
	end
	--if showTimers == 3 then timeStart = os.clock() end
	
	if yieldID == YieldTypes.YIELD_HAPPINESS_CITY then 
		yield = yield + player:GetExtraBuildingHappinessFromPolicies(buildingID)
		yield = yield + buildingInfo.Happiness
		
		query = string.format("BuildingType = '%s' AND YieldType = '%s'", buildingInfo.Type, yieldType)
		for row in GameInfo.Building_YieldChanges(query) do
			yield = yield + row.Yield
		end		
	elseif yieldID == YieldTypes.YIELD_HAPPINESS_NATIONAL then 
		yield = yield + buildingInfo.UnmoddedHappiness
		
		query = string.format("BuildingType = '%s' AND YieldType = '%s'", buildingInfo.Type, yieldType)
		for row in GameInfo.Building_YieldChanges(query) do
			yield = yield + row.Yield
		end
	else
		yield = yield + Game.GetBuildingYieldChange(buildingID, yieldID)
	end
	
	query = string.format("BuildingClassType = '%s' AND YieldType = '%s'", buildingInfo.BuildingClass, yieldType)
	for row in GameInfo.Policy_BuildingClassYieldChanges(query) do
		if player:HasPolicy(GameInfo.Policies[row.PolicyType].ID) then
			yield = yield + row.YieldChange
		end
	end
	
	query = string.format("BuildingClassType = '%s' AND YieldType = '%s'", buildingInfo.BuildingClass, yieldType)
	for row in GameInfo.Building_BuildingClassYieldChanges(query) do
		if player:HasBuilding(GameInfo.Buildings[row.BuildingType].ID) then
			yield = yield + row.YieldChange
		end
	end
	
	
	if Building_IsWonder(buildingID, true) then
		query = string.format("YieldType = '%s'", yieldType)
		for row in GameInfo.Belief_YieldChangeWorldWonder(query) do
			if player:HasBelief(row.BeliefType) then
				yield = yield + row.Yield
			end
		end
	end

	local beliefID = nil
	if city then
		query = string.format("BuildingClassType = '%s' AND YieldType = '%s'", buildingInfo.BuildingClass, yieldType)
		for row in GameInfo.Belief_BuildingClassYieldChanges(query) do
			local beliefInfo = GameInfo.Beliefs[row.BeliefType]
			local followers = City_GetBeliefFollowers(city, beliefInfo.Type)
			if followers >= math.max(1, beliefInfo.MinFollowers) then
				beliefID = beliefInfo.ID
				--log:Error("Belief_BuildingClassYieldChanges %s gets +%s %s from %s followers of %s in %s", buildingInfo.BuildingClass, row.YieldChange, yieldType, followers, GameInfo.Beliefs[beliefID].Type, city:GetName())
				yield = yield + row.YieldChange
			end
		end

		if yieldID == YieldTypes.YIELD_HAPPINESS_CITY then
			query = string.format("BuildingClassType = '%s'", buildingInfo.BuildingClass, yieldType)
			for row in GameInfo.Belief_BuildingClassHappiness(query) do
				local beliefInfo = GameInfo.Beliefs[row.BeliefType]
				local followers = City_GetBeliefFollowers(city, beliefInfo.Type)
				if followers >= math.max(1, beliefInfo.MinFollowers) then
					beliefID = beliefInfo.ID
					yield = yield + row.Happiness
				end
			end
		end
	end
	
	--if showTimers == 3 then print(string.format("%3s ms for PlayerClass.GetBuildingYield", math.floor((os.clock() - timeStart)*1000))) end
	return yield, beliefID
end

function PlayerClass.GetBuildingYieldMod(player, buildingID, yieldID, city)
	local buildingInfo = GameInfo.Buildings[buildingID]
	local yield = 0
	local query = ""
	if yieldID == nil then
		log:Fatal("PlayerClass.GetBuildingYieldMod yieldID=nil")
	end
	local yieldType = GameInfo.Yields[yieldID].Type
	--if showTimers == 3 then timeStart = os.clock() end
	
	if yieldID == YieldTypes.YIELD_CULTURE then
		yield = yield + buildingInfo.CultureRateModifier
		query = string.format("BuildingType = '%s' AND YieldType = '%s'", buildingInfo.Type, yieldType)
		for row in GameInfo.Building_YieldModifiers(query) do
			yield = yield + row.Yield
		end
	--[[elseif yieldID == YieldTypes.YIELD_GOLD then
		query = string.format("BuildingType = '%s' AND YieldType = '%s'", buildingInfo.Type, yieldType)
		for row in GameInfo.Building_YieldModifiers(query) do
			yield = yield + row.Yield
		end--]]
	else
		--yield = yield + Game.GetBuildingYieldModifier(buildingID, yieldID)
	end

	--[[if (yieldID == YieldTypes.YIELD_CULTURE) or (yieldID == YieldTypes.YIELD_FAITH) then
		query = string.format("BuildingClassType = '%s' AND YieldType = '%s'", buildingInfo.BuildingClass, yieldType)
		for row in GameInfo.Policy_BuildingClassYieldModifiers(query) do
			if player:HasPolicy(GameInfo.Policies[row.PolicyType].ID) then
				--log:Trace("%30s %20s %5s", buildingInfo.BuildingClass, yieldType, row.YieldMod)
				yield = yield + row.YieldMod
			end
		end--]]

		query = string.format("BuildingClassType = '%s' AND YieldType = '%s'", buildingInfo.BuildingClass, yieldType)
		for row in GameInfo.Building_BuildingClassYieldModifiers(query) do
			if player:HasBuilding(GameInfo.Buildings[row.BuildingType].ID) then
				yield = yield + row.Yield
			end
		end
	--end
	
	--if showTimers == 3 then print(string.format("%3s ms for PlayerClass.GetBuildingYieldMod", math.floor((os.clock() - timeStart)*1000))) end
	return yield
end

function City_GetBaseYieldFromTerrain(city, yieldID)
	local yield = 0
	if yieldID == YieldTypes.YIELD_HAPPINESS_CITY then	
		for i = 0, city:GetNumCityPlots() - 1 do
			local plot = city:GetCityIndexPlot(i)
			if plot and city:IsWorkingPlot(plot) then
				--log:Warn("%20s %5s city happiness from plot #%s", city:GetName(), Plot_GetYield(plot, yieldID), i)
				yield = yield + Plot_GetYield(plot, yieldID)
			end
		end
		--log:Warn("%20s %5s city happiness from mod", city:GetName(), yield)
		if yield < 0 then
			log:Warn("City_GetBaseYieldFromTerrain %s city happiness is %s", object:GetName(), yield)
		end
		City_SetNumBuildingClass(city, "BUILDINGCLASS_HAPPINESS_CITY", yield)
	elseif yieldID == YieldTypes.YIELD_HAPPINESS_NATIONAL then
		-- todo
	else
		yield = city:GetBaseYieldRateFromTerrain(yieldID)
	end
	return yield
end

function City_GetBaseYieldFromReligion(city, yieldID)
	if yieldID == YieldTypes.YIELD_HAPPINESS_CITY or yieldID == YieldTypes.YIELD_HAPPINESS_NATIONAL then
		return 0
	end
	yield = city:GetBaseYieldRateFromReligion(yieldID)
	
	return yield
end

function City_GetBaseYieldFromPopulation(city, yieldID)
	local yield = 0
	--yield = city:GetPopulation() * city:GetYieldPerPopTimes100(yieldID) / 100  -- returns incorrect values for science
	if yieldID == YieldTypes.YIELD_SCIENCE then
		yield = yield + city:GetPopulation() * GameDefines.SCIENCE_PER_POPULATION
	end
	for buildingInfo in GameInfo.Building_YieldChangesPerPop(string.format("YieldType = '%s'", GameInfo.Yields[yieldID].Type)) do
		if City_GetNumBuilding(city, buildingInfo.BuildingType) > 0 then
			yield = yield + buildingInfo.Yield * city:GetPopulation() / 100
		end
	end
	return yield
end

function City_GetBaseYieldFromProcesses(city, yieldID)
	local yield = 0
	if yieldID ~= YieldTypes.YIELD_PRODUCTION then
		local processID = city:GetProductionProcess()
		if processID ~= -1 then
			local processInfo = GameInfo.Processes[processID]
			local query = string.format("ProcessType = '%s' AND YieldType = '%s'", processInfo.Type, GameInfo.Yields[yieldID].Type)
			for row in GameInfo.Process_ProductionYields(query) do
				yield = yield + row.Yield / 100 * math.max(0, City_GetYieldRate(city, YieldTypes.YIELD_PRODUCTION))
			end
		end
	end
	return yield
end

function City_GetBaseYieldFromBuildings(city, yieldID)
	local yield = GetYieldCache(city, "baseBuildingRate", yieldID, itemTable, itemID, queueNum)
	if yield then
		return yield
	end
	yield = 0
	local player = Players[city:GetOwner()]
	for buildingInfo in GameInfo.Buildings("CheckWithYieldLibrary = 1") do
		local numBuilding = City_GetNumBuilding(city, buildingInfo.ID)
		if numBuilding > 0 then
			yield = yield + player:GetBuildingYield(buildingInfo.ID, yieldID, city) * numBuilding
		end
	end
	if yieldID == YieldTypes.YIELD_HAPPINESS_CITY then
		for buildingInfo in GameInfo.Buildings("HappinessPerCity <> 0") do
			if player:HasBuilding(buildingInfo.Type) then
				yield = yield + buildingInfo.HappinessPerCity
			end
		end
	end
	SetYieldCache(city, "baseBuildingRate", yieldID, yield, itemTable, itemID, queueNum)
	return yield
end

function City_GetBaseYieldModFromBuildings(city, yieldID)
	local yield = GetYieldCache(city, "baseBuildingMod", yieldID, itemTable, itemID, queueNum)
	if yield then
		return yield
	end
	local yield = 0
	local player = Players[city:GetOwner()]
	for building in GameInfo.Buildings() do
		local numBuilding = City_GetNumBuilding(city, building.ID)
		if numBuilding > 0 then
			yield = yield + player:GetBuildingYieldMod(building.ID, yieldID, city) * numBuilding
		end
	end
	SetYieldCache(city, "baseBuildingMod", yieldID, yield, itemTable, itemID, queueNum)
	return yield
end


function City_GetBaseYieldFromSpecialists(city, yieldID)
	local yield = GetYieldCache(city, "specialistRate", yieldID, itemTable, itemID, queueNum)
	if yield then
		return yield
	end
	yield = 0
	local citizenID = GameDefines.DEFAULT_SPECIALIST
	for specialistInfo in GameInfo.Specialists() do
		yield = yield + city:GetSpecialistCount(specialistInfo.ID) * City_GetSpecialistYield(city, yieldID, specialistInfo.ID)
	end
	SetYieldCache(city, "specialistRate", yieldID, yield, itemTable, itemID, queueNum)
	return yield
end

function City_GetBaseYieldFromPolicies(city, yieldID)
	local player = Players[city:GetOwner()]
	local query = ""
	local yield = 0
	if yieldID == YieldTypes.YIELD_CULTURE then
		yield = city:GetJONSCulturePerTurnFromPolicies()
	elseif yieldID == YieldTypes.YIELD_FAITH then
		yield = city:GetFaithPerTurnFromPolicies()
		for policyInfo in GameInfo.Policy_CityYieldChanges{YieldType = GameInfo.Yields[yieldID].Type} do
			if player:HasPolicy(GameInfo.Policies[policyInfo.PolicyType].ID) then
				yield = yield + policyInfo.Yield 
			end
		end
	elseif yieldID == YieldTypes.YIELD_PRODUCTION then
		for policyInfo in GameInfo.Policy_CityWithSpecialistYieldChanges{YieldType = GameInfo.Yields[yieldID].Type} do
			if player:HasPolicy(GameInfo.Policies[policyInfo.PolicyType].ID) and City_GetSpecialistCount(city, policyInfo.SpecialistType) >= policyInfo.SpecialistCount then
				yield = yield + policyInfo.Yield 
			end
		end
	elseif yieldID == YieldTypes.YIELD_FOOD then
		--[[
		-- This goes directly to the base terrain and cannot be reported separately.
		if city:IsCapital() then			
			query = string.format("YieldType = '%s'", GameInfo.Yields[yieldID].Type)
			for row in GameInfo.Policy_CapitalYieldChanges(query) do
				if player:HasPolicy(GameInfo.Policies[row.PolicyType].ID) then
					yield = yield + row.Yield
				end
			end
		end 
		--]]
	end
	return yield
end


function City_GetBaseYieldFromTraits(city, yieldID)
	if yieldID == YieldTypes.YIELD_CULTURE then
		return city:GetJONSCulturePerTurnFromTraits()
	elseif yieldID == YieldTypes.YIELD_FAITH then
		return city:GetFaithPerTurnFromTraits()
	else
		return 0
	end
end

function City_GetBaseYieldFromMisc(city, yieldID)
	if yieldID == YieldTypes.YIELD_CULTURE or yieldID == YieldTypes.YIELD_SCIENCE or yieldID == YieldTypes.YIELD_HAPPINESS_CITY or yieldID == YieldTypes.YIELD_HAPPINESS_NATIONAL then
		return 0
	else
		return city:GetBaseYieldRateFromMisc(yieldID)
	end
end


function City_GetBaseYieldFromMinorCivs(city, yieldID)
	local player = Players[city:GetOwner()]
	local yield = 0
	if player:IsMinorCiv() or yieldID == YieldTypes.YIELD_FAITH then
		return 0
	end
	if Cep.ENABLE_DISTRIBUTED_MINOR_CIV_YIELDS then
		yield = player:GetYieldsFromCitystates()[yieldID]
		if not yield then
			log:Fatal("player:GetYieldsFromCitystates %s %s is nil", player:GetName(), GameInfo.Yields[yieldID].Type)
		end
		if yield ~= 0 then
			yield = yield * City_GetWeight(city, yieldID) / player:GetTotalWeight(yieldID)
		end

		--[[
		for row in GameInfo.Policy_MinorCivBonuses(string.format("YieldType = '%s'", GameInfo.Yields[yieldID].Type)) do
			if player:HasPolicy(GameInfo.Policies[row.PolicyType].ID) then
				for minorCivID,minorCiv in pairs(Players) do
					if minorCiv:IsAliveCiv() and minorCiv:IsMinorCiv() then
						if row.FriendLevel == minorCiv:GetMinorCivFriendshipLevelWithMajor(player:GetID()) then
							yield = yield + row.Yield
						end
					end
				end
			end
		end
		--]]
	--[[
	-- This goes directly to the base terrain and cannot be reported separately.
	elseif yieldID == YieldTypes.YIELD_FOOD then
		local isRenaissance = (player:GetCurrentEra() >= GameInfo.Eras.ERA_RENAISSANCE.ID)
		local yieldLevel	= {}
		yieldLevel[-1]		= 0
		yieldLevel[0]		= 0
		yieldLevel[1]		= 0
		yieldLevel[2]		= 0
		if city:IsCapital() then
			if isRenaissance then
				yieldLevel[1] = GameDefines.FRIENDS_CAPITAL_FOOD_BONUS_AMOUNT_POST_RENAISSANCE
			else
				yieldLevel[1] = GameDefines.FRIENDS_CAPITAL_FOOD_BONUS_AMOUNT_PRE_RENAISSANCE
			end
			yieldLevel[2] = yieldLevel[1] + GameDefines.ALLIES_CAPITAL_FOOD_BONUS_AMOUNT
		else
			if isRenaissance then
				yieldLevel[1] = GameDefines.FRIENDS_OTHER_CITIES_FOOD_BONUS_AMOUNT_POST_RENAISSANCE
			else
				yieldLevel[1] = GameDefines.FRIENDS_OTHER_CITIES_FOOD_BONUS_AMOUNT_PRE_RENAISSANCE
			end
			yieldLevel[2] = yieldLevel[1] + GameDefines.ALLIES_OTHER_CITIES_FOOD_BONUS_AMOUNT
		end

		for minorCivID,minorCiv in pairs(Players) do
			if minorCiv:IsAliveCiv() and minorCiv:IsMinorCiv() then
				yield = yield + yieldLevel[minorCiv:GetMinorCivFriendshipLevelWithMajor(player:GetID())] / 100
			end
		end
	--]]
	end
	return yield
end

function City_GetSpecialistYield(city, yieldID, specialistID)
	if specialistID == nil then
		log:Fatal("City_GetSpecialistYield specialistID=nil")
	end
	if type(specialistID) ~= "number" and type(specialistID) ~= "string" then
		log:Fatal("City_GetSpecialistYield specialistID=%s", specialistID)
	end
	local yield		= 0
	local yieldInfo = GameInfo.Yields[yieldID]
	local player	= Players[city:GetOwner()]
	local traitInfo	= player:GetTraitInfo()
	local specType	= GameInfo.Specialists[specialistID].Type
	local query		= nil
	
	--[[if (yieldID == YieldTypes.YIELD_FAITH) or (yieldID == YieldTypes.YIELD_CULTURE) then
		query = string.format("YieldType = '%s' AND SpecialistType = '%s'", yieldInfo.Type, specType)
		for row in GameInfo.Building_SpecialistYieldChanges(query) do
			if player:HasBuilding(GameInfo.Buildings[row.BuildingType].ID) then
				yield = yield + row.Yield
			end
		end
	end--]]

--[[
	query = string.format("YieldType = '%s' AND SpecialistType = '%s'", yieldInfo.Type, specType)
	for row in GameInfo.Policy_SpecialistYieldChanges(query) do
		if player:HasPolicy(GameInfo.Policies[row.PolicyType].ID) then
			yield = yield + row.Yield
		end
	end
	
	query = string.format("YieldType = '%s'", yieldInfo.Type)
	for row in GameInfo.Belief_YieldChangeAnySpecialist(query) do
		if player:HasBelief(BeliefType) then
			yield = yield + row.Yield
		end
	end
]]--

	if yieldID == YieldTypes.YIELD_HAPPINESS_CITY then
		-- todo
	elseif yieldID == YieldTypes.YIELD_HAPPINESS_NATIONAL then
		-- todo
	elseif yieldID == YieldTypes.YIELD_GREAT_PEOPLE then
		--yield = yield + GameInfo.Specialists[specialistID].GreatPeopleRateChange
	elseif yieldID == YieldTypes.YIELD_EXPERIENCE then
		yield = yield + GameInfo.Specialists[specialistID].Experience
	elseif GameInfo.Yields[yieldID].TileTexture then
		yield = yield + city:GetSpecialistYield(specialistID, yieldID)
	end
	return yield
end

--[[
function City_GetBaseYieldFromAIBonus(city, yieldID)
	local player = Players[city:GetOwner()]
	local capital = player:GetCapitalCity()
	if capital ~= city or player:IsHuman() then
		return 0
	end
	local yield = 0
	if cityOwner:IsMilitaristicLeader() then
		yield = Game.GetHandicapInfo().AICapitalYieldMilitaristic
	else
		yield = Game.GetHandicapInfo().AICapitalYieldPeaceful
	end
	capital:SetNumRealBuilding(GameInfo.Buildings.BUILDING_AI_PRODUCTION.ID, yield)
	yield = yield + GameInfo.Yields.YIELD_GOLD.MinPlayer
	yield = yield + GameDefines.TRADE_ROUTE_BASE_GOLD + city:GetPopulation() * GameDefines.TRADE_ROUTE_CITY_POP_GOLD_MULTIPLIER
	capital:SetNumRealBuilding(GameInfo.Buildings.BUILDING_AI_GOLD.ID, yield)
end
--]]


---------------------------------------------------------------------
-- Base Yield Modifiers
---------------------------------------------------------------------

function City_GetBaseYieldRateModifier(city, yieldID, itemTable, itemID, queueNum)
	if city == nil then
		log:Fatal("City_GetBaseYieldRateModifier city=nil")
	elseif itemTable and not itemID then
		log:Fatal("City_GetBaseYieldRateModifier itemTable=%s itemID=%s", itemTable, itemID)
	end
	if yieldID == YieldTypes.YIELD_HAPPINESS_CITY or yieldID == YieldTypes.YIELD_HAPPINESS_NATIONAL then
		return 0
	end
	local player = Players[city:GetOwner()]
	local cityOwner = Players[city:GetOwner()]
	local yieldMod = 0
	yieldMod = yieldMod + player:GetGoldenAgeYieldModifier(yieldID)
	yieldMod = yieldMod + City_GetBaseYieldModFromTraits(city, yieldID)
	yieldMod = yieldMod + City_GetBaseYieldModFromPuppet(city, yieldID)
	yieldMod = yieldMod + City_GetBaseYieldModifierFromPolicies(city, yieldID, itemTable, itemID, queueNum)
	yieldMod = yieldMod + City_GetBaseYieldModifierFromGlobalBuildings(cityOwner, yieldID)
	yieldMod = yieldMod + City_GetBaseYieldModFromBuildings(city, yieldID)
	
	if yieldID == YieldTypes.YIELD_CULTURE then
		yieldMod = yieldMod + cityOwner:GetCultureCityModifier()
		if city:GetNumWorldWonders() > 0 then
			yieldMod = yieldMod + cityOwner:GetCultureWonderMultiplier()
		end
	else
		yieldMod = yieldMod + city:GetYieldRateModifier(yieldID)
		if yieldID == YieldTypes.YIELD_FOOD then
			yieldMod = yieldMod + City_GetCapitalSettlerModifier(city, yieldID, itemTable, itemID, queueNum)
		elseif yieldID == YieldTypes.YIELD_PRODUCTION then
			local happiness = Game.Round(cityOwner:GetYieldRate(YieldTypes.YIELD_HAPPINESS_NATIONAL))
			if happiness < 0 then--GameDefines.VERY_UNHAPPY_THRESHOLD then
				yieldMod = yieldMod + happiness * GameDefines.VERY_UNHAPPY_PRODUCTION_PENALTY_PER_UNHAPPY
			end
			if city:IsCapital() and cityOwner:HasTech("TECH_RAILROAD") then
				yieldMod = yieldMod + GameDefines.INDUSTRIAL_ROUTE_PRODUCTION_MOD
			end
			if itemTable == GameInfo.Units then
				--yieldMod = yieldMod + City_GetCapitalSettlerModifier(city, yieldID, itemTable, itemID, queueNum) 
				yieldMod = yieldMod + City_GetSupplyModifier(city, yieldID, itemTable, itemID, queueNum)
				yieldMod = yieldMod + city:GetUnitProductionModifier(itemID)
				return yieldMod
			elseif itemTable == GameInfo.Buildings then
				--yieldMod = yieldMod + City_GetBuildingClassConstructionYieldModifier(city, yieldID, itemTable, itemID, queueNum)
				if Building_IsWonder(itemID) then
					return yieldMod + City_GetWonderConstructionModifier(city, yieldID, itemTable, itemID, queueNum)
				end
				yieldMod = yieldMod + city:GetBuildingProductionModifier(itemID)
				--log:Warn("buildMod = %3s %20s", city:GetBuildingProductionModifier(itemID), itemTable[itemID].Type)
				return yieldMod
			elseif itemTable == GameInfo.Projects then
				yieldMod = yieldMod + city:GetProjectProductionModifier(itemID)
				--log:Warn("projMod  = %3s %20s", yieldMod, itemTable[itemID].Type)
				return yieldMod
			else
				local unitID		= city:GetProductionUnit()
				local buildingID	= city:GetProductionBuilding()
				local projectID		= city:GetProductionProject()
				if unitID and unitID ~= -1 then
					return City_GetBaseYieldRateModifier(city, yieldID, GameInfo.Units, unitID)
				elseif buildingID and buildingID ~= -1 then
					return City_GetBaseYieldRateModifier(city, yieldID, GameInfo.Buildings, buildingID)
				elseif projectID and projectID ~= -1 then
					return City_GetBaseYieldRateModifier(city, yieldID, GameInfo.Projects, projectID)
				end
			end
		end
	end
	return yieldMod
end

function City_GetBaseYieldModifierTooltip(city, yieldID, itemTable, itemID, queueNum)
	local tooltip = ""
	local player = Players[city:GetOwner()]
	local cityMod = City_GetBaseYieldRateModifier(city, yieldID)
	if cityMod ~= 0 then
		tooltip = tooltip .. "[NEWLINE][ICON_BULLET]" .. Locale.ConvertTextKey("TXT_KEY_CULTURE_CITY_MOD", cityMod)
	end
	if yieldID == YieldTypes.YIELD_CULTURE then
		-- Empire Culture modifier
		local empireMod = player:GetCultureCityModifier()
		if empireMod ~= 0 then
			tooltip = tooltip .. "[NEWLINE][ICON_BULLET]" .. Locale.ConvertTextKey("TXT_KEY_CULTURE_PLAYER_MOD", empireMod)
		end
		
		--[[ City Culture modifier
		local cityMod = City_GetBaseYieldRateModifier(city, yieldID)
		if cityMod ~= 0 then
			tooltip = tooltip .. "[NEWLINE][ICON_BULLET]" .. Locale.ConvertTextKey("TXT_KEY_CULTURE_CITY_MOD", cityMod)
		end--]]
		
		-- Wonders Culture modifier
		local wonderMod = 0
		if city:GetNumWorldWonders() > 0 then
			wonderMod = player:GetCultureWonderMultiplier()
		
			if (wonderMod ~= 0) then
				tooltip = tooltip .. "[NEWLINE][ICON_BULLET]" .. Locale.ConvertTextKey("TXT_KEY_CULTURE_WONDER_BONUS", wonderMod)
			end
		end

		-- Golden Age Culture modifier
		yieldMod = player:GetGoldenAgeYieldModifier(yieldID)
		if yieldMod ~= 0 then
			tooltip = tooltip .. Locale.ConvertTextKey("TXT_KEY_PRODMOD_YIELD_GOLDEN_AGE", yieldMod)
		end
	else
		--tooltip = tooltip .. (city:GetYieldModifierTooltip(yieldID) or "")
		--[[
		local yieldMod = City_GetBaseYieldModifierFromGlobalBuildings(player, yieldID)
		if yieldMod ~= 0 then
			tooltip = tooltip .. Locale.ConvertTextKey("TXT_KEY_YIELD_MOD_GLOBAL_BUILDINGS", yieldMod)
		end
		--]]
		if city:IsCapital() and player:HasTech("TECH_RAILROAD") and yieldID == YieldTypes.YIELD_PRODUCTION then
			tooltip = tooltip .. Locale.ConvertTextKey("TXT_KEY_PRODMOD_RAILROAD_CONNECTION", GameDefines.INDUSTRIAL_ROUTE_PRODUCTION_MOD)
		end
		local yieldMod = City_GetBaseYieldModifierFromPolicies(city, yieldID, itemTable, itemID, queueNum)
		if yieldMod ~= 0 then
			tooltip = tooltip .. Locale.ConvertTextKey("TXT_KEY_PRODMOD_YIELD_POLICY", yieldMod)
		end
	end
	return tooltip
end

function PlayerClass.GetGoldenAgeYieldModifier(player, yieldID)
	local yieldMod = 0
	if player:GetGoldenAgeTurns() == 0 then
		return yieldMod
	end
	
	yieldMod = GameInfo.Yields[yieldID].GoldenAgeYieldMod
	--[[
	local query = string.format("YieldType = '%s'", yieldName)
	for row in GameInfo.GoldenAgeYields(query) do
		yieldMod = yieldMod + row.YieldMod
	end
	--]]
	
	local query = string.format("TraitType='%s' AND YieldType='%s'", player:GetTraitInfo().Type, GameInfo.Yields[yieldID].Type)
	for row in GameInfo.Trait_GoldenAgeYieldModifier(query) do
		yieldMod = yieldMod + row.YieldMod
	end
	
	return yieldMod
end

function City_GetBaseYieldModifierFromGlobalBuildings(player, yieldID)
	local yieldMod = 0
	local yieldInfo = GameInfo.Yields[yieldID]
	local query = string.format("YieldType = '%s'", yieldInfo.Type)
	for entry in GameInfo.Building_GlobalYieldModifiers(query) do
		local buildingInfo = GameInfo.Buildings[entry.BuildingType]
		for city in player:Cities() do
			if City_GetNumBuilding(city, buildingInfo.ID) > 0 then
				yieldMod = yieldMod + entry.Yield
			end
		end
	end
	return yieldMod
end

function City_GetBaseYieldModFromTraits(city, yieldID)
	local yieldMod = 0
	--[[
	if Players[city:GetOwner()]:GetGoldenAgeTurns() > 0 then
		local query = string.format("TraitType='%s' AND YieldType='%s'", Players[city:GetOwner()]).Type:GetTrait(GameInfo.Yields[yieldID].Type)
		for row in GameInfo.Trait_GoldenAgeYieldModifier(query) do
			yieldMod = yieldMod + row.YieldMod
		end
	end
	--]]
	return yieldMod
end

function City_GetBaseYieldModFromPuppet(city, yieldID)
	local yieldMod = 0
	if not city:IsPuppet() then
		return 0
	end
	if yieldID == YieldTypes.YIELD_GOLD then
		yieldMod = GameDefines.PUPPET_GOLD_MODIFIER
	elseif yieldID == YieldTypes.YIELD_SCIENCE then
		yieldMod = GameDefines.PUPPET_SCIENCE_MODIFIER
	elseif yieldID == YieldTypes.YIELD_CULTURE then
		yieldMod = GameDefines.PUPPET_CULTURE_MODIFIER
	elseif yieldID == YieldTypes.YIELD_FAITH then
		yieldMod = GameDefines.PUPPET_FAITH_MODIFIER
	end
	return yieldMod
end


	

function City_GetBaseYieldModifierFromPolicies(city, yieldID, itemTable, itemID, queueNum)
	local yieldMod = 0
	local player = Players[city:GetOwner()]
	for row in GameInfo.Policy_YieldModifiers() do
		if yieldID == GameInfo.Yields[row.YieldType].ID and Players[city:GetOwner()]:HasPolicy(GameInfo.Policies[row.PolicyType].ID) then
			yieldMod = yieldMod + row.Yield
		end
	end
	if yieldID == YieldTypes.YIELD_PRODUCTION then
		if itemID == nil then
			itemID = city:GetProductionUnit()
			itemTable = GameInfo.Units
		end
		for row in GameInfo.Policy_UnitClassProductionModifiers() do
			if Players[city:GetOwner()]:HasPolicy(GameInfo.Policies[row.PolicyType].ID) then
				local unitID = player:GetUniqueUnitID(row.UnitClassType)
				if itemTable == GameInfo.Units and itemID == unitID then
					yieldMod = yieldMod + row.ProductionModifier
				end
			end
		end
	end
	return yieldMod
end

function City_GetSupplyModifier(city, yieldID, itemTable, itemID, queueNum)
	if itemID == nil then
		itemID = city:GetProductionUnit()
		itemTable = GameInfo.Units
	end
	if (itemID
		and itemID ~= -1
		and itemTable == GameInfo.Units
		and itemTable[itemID].Domain == "DOMAIN_LAND"
		and (itemTable[itemID].Combat > 0 or itemTable[itemID].RangedCombat > 0)
		) then
		return Players[city:GetOwner()]:GetSupplyModifier(yieldID)
	end
	return 0
end

function PlayerClass.GetSupplyModifier(player, yieldID, doUpdate)
	if yieldID and yieldID ~= YieldTypes.YIELD_PRODUCTION then
		return 0
	end
	local yieldMod = 0
	local netSupply = GetMaxUnitSupply(player, doUpdate) - GetCurrentUnitSupply(player, doUpdate)
	if netSupply < 0 then
		yieldMod = math.max(Cep.SUPPLY_PENALTY_MAX, netSupply * Cep.SUPPLY_PENALTY_PER_UNIT_PERCENT)
	end
	return yieldMod
end

function GetSupplyFromPopulation(player)
	if player:GetNumCities() == 0 then
		return 0
	end
	local supply = 0
	for city in player:Cities() do
		supply = supply + Cep.SUPPLY_PER_POP * city:GetPopulation()
	end
	return Game.Round(supply)
end

function GetMaxUnitSupply(player, doUpdate)
	local playerID = player:GetID()
	local activePlayer = Players[Game.GetActivePlayer()]
	if player:GetNumCities() == 0 then
		return 0
	end
	if doUpdate or MapModData.Cep_UnitSupplyMax[playerID] == nil then
		MapModData.Cep_UnitSupplyMax[playerID] = Cep.SUPPLY_BASE
		for city in player:Cities() do
			MapModData.Cep_UnitSupplyMax[playerID] = MapModData.Cep_UnitSupplyMax[playerID] + Cep.SUPPLY_PER_CITY + Cep.SUPPLY_PER_POP * city:GetPopulation()
		end
		if not player:IsHuman() then
			local handicapMod = 1 + Game.GetHandicapInfo(activePlayer).AIUnitSupplyPercent / 100
			MapModData.Cep_UnitSupplyMax[playerID] = handicapMod * MapModData.Cep_UnitSupplyMax[playerID]
		end
		MapModData.Cep_UnitSupplyMax[playerID] = Game.Round(MapModData.Cep_UnitSupplyMax[playerID])
		--log:Warn("%20s UnitSupplyMax     = %-3s", player:GetName(), MapModData.Cep_UnitSupplyMax[playerID])
	end
	return MapModData.Cep_UnitSupplyMax[playerID]
end

function GetCurrentUnitSupply(player, doUpdate)
	local playerID = player:GetID()
	if doUpdate or MapModData.Cep_UnitSupplyCurrent[playerID] == nil then
		MapModData.Cep_UnitSupplyCurrent[playerID] = 0
		for unit in player:Units() do
			if Unit_IsCombatDomain(unit, "DOMAIN_LAND") then
				MapModData.Cep_UnitSupplyCurrent[playerID] = MapModData.Cep_UnitSupplyCurrent[playerID] + 1
			end
		end
		--log:Warn("%20s UnitSupplyCurrent = %-3s", player:GetName(), MapModData.Cep_UnitSupplyCurrent[playerID])
	end
	return MapModData.Cep_UnitSupplyCurrent[playerID]
end

function City_GetCapitalSettlerModifier(city, yieldID, itemTable, itemID, queueNum)
	local yieldMod = 0
	if itemID == nil then
		itemID = city:GetProductionUnit()
		itemTable = GameInfo.Units
	end
	if city:IsCapital() and itemID and itemID ~= -1 and itemTable[itemID].Food then
		for policyInfo in GameInfo.Policies("CapitalSettlerProductionModifier != 0") do
			if Players[city:GetOwner()]:HasPolicy(policyInfo.ID) then
				yieldMod = yieldMod + policyInfo.CapitalSettlerProductionModifier
			end
		end
	end
	return yieldMod
end

function City_GetBuildingClassConstructionYieldModifier(city, yieldID, itemTable, itemID, queueNum)
	local yieldMod = 0
	if itemID == nil then
		itemID = city:GetProductionBuilding()
		if itemID == nil or itemID == -1 then
			return 0
		end
		itemTable = GameInfo.Buildings
	end
	for policyInfo in GameInfo.Policy_BuildingClassProductionModifiers() do
		if (policyInfo.BuildingClassType == itemTable[itemID].BuildingClass) then
			if Players[city:GetOwner()]:HasPolicy(GameInfo.Policies[policyInfo.PolicyType].ID) then
				yieldMod = yieldMod + policyInfo.ProductionModifier
			end
		end
	end
	return yieldMod
end

function City_GetWonderConstructionModifier(city, yieldID, itemTable, itemID, queueNum)
	local yieldMod = 0
	if yieldID == YieldTypes.YIELD_PRODUCTION then
		local player = Players[city:GetOwner()]
		if itemID == nil then
			itemID = city:GetProductionBuilding()
			if itemID == nil or itemID == -1 then
				return 0
			end
			itemTable = GameInfo.Buildings
		end		

		yieldMod = yieldMod + player:GetTraitInfo().WonderProductionModifier
		
		for buildingInfo in GameInfo.Buildings("WonderProductionModifier != 0") do
			if city:IsHasBuilding(buildingInfo.ID) then
				yieldMod = yieldMod + buildingInfo.WonderProductionModifier
			end
		end
		for resourceInfo in GameInfo.Resources("WonderProductionMod != 0") do
			if city:IsHasResourceLocal(resourceInfo.ID) then
				yieldMod = yieldMod + resourceInfo.WonderProductionMod
			end
		end
		for policyInfo in GameInfo.Policies("WonderProductionModifier != 0") do
			if player:HasPolicy(policyInfo.ID) then
				yieldMod = yieldMod + policyInfo.WonderProductionModifier
			end
		end
		for beliefInfo in GameInfo.Beliefs("WonderProductionModifier != 0") do
			if player:HasBelief(beliefInfo.ID) then
				local itemTech = itemTable[itemID].PrereqTech
				local itemEra = GameInfo.Technologies[itemTech].Era
				if itemEra == "ERA_ANCIENT" or itemEra == "ERA_CLASSICAL" then
					yieldMod = yieldMod + beliefInfo.WonderProductionModifier
				end
			end
		end
		--log:Debug("wondMod = "..yieldMod.." "..itemTable[itemID].Type)
	end
	return yieldMod
end



---------------------------------------------------------------------
-- Surplus Yield
---------------------------------------------------------------------

function City_GetYieldConsumed(city, yieldID, itemTable, itemID, queueNum)
	if city == nil then
		log:Fatal("City_GetYieldConsumed city=nil")
	elseif itemTable and not itemID then
		log:Fatal("City_GetYieldConsumed itemID=nil")
	end
	local yield		= 0
	local player	= Players[city:GetOwner()]
	local trait		= player:GetTraitInfo()
	if yieldID == YieldTypes.YIELD_FOOD then
		return city:FoodConsumption(true, 0)
	elseif yieldID == YieldTypes.YIELD_GOLD then
		return city:GetTotalBaseBuildingMaintenance()
	elseif yieldID == YieldTypes.YIELD_HAPPINESS_CITY then
		if city:IsOccupied() then
			yield = city:GetPopulation() * GameDefines.UNHAPPINESS_PER_OCCUPIED_POPULATION
		else
			yield = city:GetPopulation() * GameDefines.UNHAPPINESS_PER_POPULATION
		end
		local yieldMod = trait.PopulationUnhappinessModifier
		for buildingInfo in GameInfo.Buildings("UnhappinessModifier <> 0") do
			if player:HasBuilding(buildingInfo.Type) then
				yieldMod = yieldMod + buildingInfo.UnhappinessModifier
			end
		end
		yield = yield * (1 + yieldMod/100)
	elseif yieldID == YieldTypes.YIELD_HAPPINESS_NATIONAL then
		if city:IsOccupied() then
			yield = GameDefines.UNHAPPINESS_PER_CAPTURED_CITY
		else
			yield = GameDefines.UNHAPPINESS_PER_CITY
		end
		local yieldMod = trait.CityUnhappinessModifier
		for buildingInfo in GameInfo.Buildings("CityCountUnhappinessMod <> 0") do
			if player:HasBuilding(buildingInfo.Type) then
				yieldMod = yieldMod + buildingInfo.CityCountUnhappinessMod
			end
		end
		yield = yield * (1 + yieldMod/100)
	end
	return yield
end

function City_GetSurplusYieldRate(city, yieldID, itemTable, itemID, queueNum)
	if city == nil then
		log:Fatal("City_GetSurplusYieldRate city=nil")
	elseif itemTable and not itemID then
		log:Fatal("City_GetSurplusYieldRate itemTable=%s itemID=%s", itemTable, itemID)
	end
	if city:IsResistance() then
		return 0
	end
	
	local surplusRate = GetYieldCache(city, "surplusRate", yieldID, itemTable, itemID, queueNum)
	if surplusRate then
		return surplusRate
	end
	if showTimers == 3 then timeStart = os.clock() end
	
	--log:Debug("City_GetSurplusYieldRate %15s %15s", city:GetName(), GameInfo.Yields[yieldID].Type)
	local baseMod = City_GetBaseYieldRateModifier(city, yieldID, itemTable, itemID, queueNum)
	local baseRate = City_GetBaseYieldRate(city, yieldID, itemTable, itemID, queueNum) * (1 + baseMod/100)
	surplusRate = baseRate - City_GetYieldConsumed(city, yieldID, itemTable, itemID, queueNum)
	
	SetYieldCache(city, "surplusRate", yieldID, surplusRate, itemTable, itemID, queueNum)
	if showTimers == 3 then print(string.format("%3s ms for City_GetSurplusYieldRate", math.floor((os.clock() - timeStart)*1000))) end
	return surplusRate
	--]]
end

function City_GetSurplusYieldModFromBuildings(city, yieldID, itemTable, itemID, queueNum)
	local surplusMod = GetYieldCache(city, "surplusModFromBuildings", yieldID, itemTable, itemID, queueNum)
	if surplusMod then
		return surplusMod
	end

	local player = Players[city:GetOwner()]
	
	surplusMod = 0
	--log:Debug("City_GetSurplusYieldModFromBuildings %15s %15s", city:GetName(), GameInfo.Yields[yieldID].Type)
	if yieldID == YieldTypes.YIELD_HAPPINESS_CITY then
		return surplusMod
	elseif yieldID == YieldTypes.YIELD_HAPPINESS_NATIONAL then
		return surplusMod
	elseif City_GetSurplusYieldRate(city, yieldID) < 0 and Game.Round(player:GetYieldRate(YieldTypes.YIELD_HAPPINESS_NATIONAL)) <= GameDefines.VERY_UNHAPPY_THRESHOLD then
		return surplusMod
	end
	for row in GameInfo.Building_YieldSurplusModifiers() do
		if yieldID == YieldTypes[row.YieldType] and city:IsHasBuilding(GameInfo.Buildings[row.BuildingType].ID) then
			surplusMod = row.Yield + surplusMod
		end
	end
	SetYieldCache(city, "surplusModFromBuildings", yieldID, surplusMod, itemTable, itemID, queueNum)
	return surplusMod
end

function City_GetSurplusYieldModFromReligion(city, yieldID, itemTable, itemID, queueNum)
	local player = Players[city:GetOwner()]
	local surplusMod = 0
	if yieldID == YieldTypes.YIELD_FOOD then
		for beliefInfo in GameInfo.Beliefs("CityGrowthModifier != 0") do
			if player:HasBelief(beliefInfo.ID) and not (beliefInfo.RequiresPeace and player:IsAtWarWithAny()) then
				surplusMod = surplusMod + beliefInfo.CityGrowthModifier
			end
		end
	end
	return surplusMod
end

function City_GetSurplusYieldRateModifier(city, yieldID, itemTable, itemID, queueNum)
	if city == nil then
		log:Fatal("City_GetSurplusYieldRateModifier city=nil")
	elseif itemTable and not itemID then
		log:Fatal("City_GetSurplusYieldRateModifier itemID=nil")
	end
	local surplusMod = GetYieldCache(city, "surplusMod", yieldID, itemTable, itemID, queueNum)
	if surplusMod then
		return surplusMod
	end
	
	local surplusMod = 0
	local yieldInfo = GameInfo.Yields[yieldID]
	
	if yieldID == YieldTypes.YIELD_HAPPINESS_CITY then
		return surplusMod
	elseif yieldID == YieldTypes.YIELD_HAPPINESS_NATIONAL then
		return surplusMod
	elseif City_GetSurplusYieldRate(city, yieldID) < 0 then
		return surplusMod
	end
	--
	local player = Players[city:GetOwner()]
	local happiness = Game.Round(player:GetYieldRate(YieldTypes.YIELD_HAPPINESS_NATIONAL))
	local surplusMod = 0
	
	surplusMod = surplusMod + player:GetGoldenAgeSurplusYieldModifier(yieldID)
	surplusMod = surplusMod + City_GetSurplusYieldModFromBuildings(city, yieldID, itemTable, itemID, queueNum)	
	surplusMod = surplusMod + City_GetSurplusYieldModFromReligion(city, yieldID, itemTable, itemID, queueNum)
	
	if yieldID == YieldTypes.YIELD_FOOD then
		if City_GetSurplusYieldRate(city, yieldID) > 0 then
			if happiness <= GameDefines.VERY_UNHAPPY_THRESHOLD then
				surplusMod = surplusMod + GameDefines.VERY_UNHAPPY_GROWTH_PENALTY
			elseif happiness < 0 then
				surplusMod = surplusMod + GameDefines.UNHAPPY_GROWTH_PENALTY
			end
		end
		if city:GetWeLoveTheKingDayCounter() > 0 then
			surplusMod = surplusMod + GameDefines.WLTKD_GROWTH_MULTIPLIER
		end
		for policyInfo in GameInfo.Policies("CityGrowthMod != 0") do
			if player:HasPolicy(policyInfo.ID) then
				surplusMod = surplusMod + policyInfo.CityGrowthMod
			end
		end
		if city:IsCapital() then
			for policyInfo in GameInfo.Policies("CapitalGrowthMod != 0") do
				if player:HasPolicy(policyInfo.ID) then
					surplusMod = surplusMod + policyInfo.CapitalGrowthMod
				end
			end			
		end
	end
	--]]
	
	SetYieldCache(city, "surplusMod", yieldID, surplusMod, itemTable, itemID, queueNum)
	return surplusMod
end

function PlayerClass.GetGoldenAgeSurplusYieldModifier(player, yieldID)
	local yieldMod = 0
	if player:GetGoldenAgeTurns() == 0 then
		return yieldMod
	end
	
	yieldMod = GameInfo.Yields[yieldID].GoldenAgeSurplusYieldMod	
	return yieldMod
end



---------------------------------------------------------------------
-- Total Yield
---------------------------------------------------------------------

function City_GetYieldRate(city, yieldID, itemTable, itemID, queueNum)
	if city == nil then
		log:Fatal("City_GetYieldRate city=nil")
	elseif itemTable and not itemID then
		log:Fatal("City_GetYieldRate itemID=nil")
	end
	if not GameInfo.Yields[yieldID] or not GameInfo.Yields[yieldID].TileTexture then
		return 0
	end

	local player = Players[city:GetOwner()]
	local activePlayer = Players[Game.GetActivePlayer()]
	
	local yield = GetYieldCache(city, "totalRate", yieldID, itemTable, itemID, queueNum)
	if yield then
		return yield
	end
	if showTimers == 3 then timeStart = os.clock() end
	
	yield = City_GetSurplusYieldRate(city, yieldID, itemTable, itemID, queueNum)
	yield = yield * (1 + City_GetSurplusYieldRateModifier(city, yieldID, itemTable, itemID, queueNum) / 100)
	if yieldID == YieldTypes.YIELD_PRODUCTION then
		if itemTable == nil then
			if city:GetProductionUnit() ~= -1 then
				itemID = city:GetProductionUnit()
				itemTable = GameInfo.Units
			end
		end
		if itemID then
			if itemTable == GameInfo.Units then
				if itemTable[itemID].Food then
					yield = yield + math.max(0, City_GetYieldRate(city, YieldTypes.YIELD_FOOD, itemTable, itemID))
				end
				if itemID == GameInfo.Units.UNIT_SETTLER.ID then
					yield = yield * 105 / Cep.UNIT_SETTLER_BASE_COST
				end
			end
		end
		if not player:IsHuman() then
			local handicapInfo = Game.GetHandicapInfo(activePlayer)
			local handicapBonus = 1 + 0.01 * handicapInfo.AIProductionPercentPerEra * activePlayer:GetCurrentEra()
			--log:Warn("%-15s %3s", city:GetName(), Game.Round(handicapBonus * 100))
			yield = yield * handicapBonus
		end
	end
	yield = yield / City_GetCostMod(city, yieldID, itemTable, itemID)
	
	SetYieldCache(city, "totalRate", yieldID, yield, itemTable, itemID, queueNum)
	if showTimers == 3 then print(string.format("%3s ms for City_GetYieldRate", math.floor((os.clock() - timeStart)*1000))) end
	return yield
end

function City_GetYieldFromFood(city, yieldID, itemTable, itemID, queueNum)
	local yield = 0
	if yieldID == YieldTypes.YIELD_PRODUCTION then
		if itemTable == nil then
			if city:GetProductionUnit() ~= -1 then
				itemID = city:GetProductionUnit()
				itemTable = GameInfo.Units
			end
		end
		if itemID and itemTable == GameInfo.Units and itemTable[itemID].Food then
			yield = yield + math.max(0, City_GetYieldRate(city, YieldTypes.YIELD_FOOD, itemTable, itemID))
		end
	end
	return yield
end

function City_GetYieldRateTimes100(city, yieldID, itemTable, itemID, queueNum)
	if city == nil then
		log:Fatal("City_GetYieldRateTimes100 city=nil")
	elseif itemTable and not itemID then
		log:Fatal("City_GetYieldRateTimes100 itemID=nil")
	end
	return City_GetYieldRate(city, yieldID) * 100
end

function City_GetYieldStored(city, yieldID, itemTable, itemID, queueNum)
	if city == nil then
		log:Fatal("City_GetYieldStored city=nil")
	elseif itemTable and not itemID then
		log:Fatal("City_GetYieldStored itemID=nil")
	end
	if yieldID == YieldTypes.YIELD_FOOD then
		return city:GetFoodTimes100() / 100
	elseif yieldID == YieldTypes.YIELD_PRODUCTION then
		if itemTable == GameInfo.Units then
			return city:GetUnitProduction(itemID, queueNum)
		elseif itemTable == GameInfo.Buildings then
			return city:GetBuildingProduction(itemID, queueNum)
		elseif itemTable == GameInfo.Projects then
			log:Fatal("City_GetYieldStored: Civ API has no city:GetProjectProductionNeeded function!")
			--return city:GetProjectProduction(itemID, queueNum)
			return 0
		else
			return city:GetProduction()
		end		
	elseif yieldID == YieldTypes.YIELD_CULTURE then
		return city:GetJONSCultureStored()
	end
	return 0
end

function City_GetYieldNeeded(city, yieldID, itemTable, itemID, queueNum)
	if city == nil then
		log:Fatal("City_GetYieldNeeded city=nil")
	elseif itemTable and not itemID then
		log:Fatal("City_GetYieldNeeded itemID=nil")
	end
	if yieldID == YieldTypes.YIELD_FOOD then
		return city:GrowthThreshold()
	elseif yieldID == YieldTypes.YIELD_PRODUCTION then
		if itemTable == GameInfo.Units then
			return city:GetUnitProductionNeeded(itemID, queueNum)
		elseif itemTable == GameInfo.Buildings then
			return city:GetBuildingProductionNeeded(itemID, queueNum)
		elseif itemTable == GameInfo.Projects then
			return city:GetProjectProductionNeeded(itemID, queueNum)
		elseif not city:IsProductionProcess() and city:GetProductionNameKey() and city:GetProductionNameKey() ~= "" then 
			return city:GetProductionNeeded()
		end
	elseif yieldID == YieldTypes.YIELD_CULTURE then
		return city:GetJONSCultureThreshold()
	end
	return 0
end

function City_GetYieldTurns(city, yieldID, itemTable, itemID, queueNum)
	if city == nil then
		log:Fatal("City_GetYieldTurns city=nil")
	elseif itemTable and not itemID then
		log:Fatal("City_GetYieldTurns itemID=nil")
	end
	if itemTable == GameInfo.Projects then
		-- The API is missing the "city:GetProjectProduction(itemID, queueNum)" function!
		return math.max(1, math.ceil(
			city:GetProjectProductionTurnsLeft(itemID, queueNum)
			* City_GetYieldRate(city, yieldID, itemTable, itemID, queueNum)
			/ (city:GetYieldRateTimes100(yieldID) / 100)
		))
	end
	return math.max(1, math.ceil(
			( City_GetYieldNeeded(city, yieldID, itemTable, itemID, queueNum)
			- City_GetYieldStored(city, yieldID, itemTable, itemID, queueNum) )
			/ City_GetYieldRate(city, yieldID, itemTable, itemID, queueNum)
		))
end

function City_ChangeYieldStored(city, yieldID, amount, checkThreshold)
	if city == nil then
		log:Fatal("City_ChangeYieldStored city=nil")
	elseif itemTable and not itemID then
		log:Fatal("City_ChangeYieldStored itemID=nil")
	end
	local player = Players[city:GetOwner()]
	if yieldID == YieldTypes.YIELD_FOOD then
		city:ChangeFood(amount)
		local overflow = City_GetYieldStored(city, yieldID) - City_GetYieldNeeded(city, yieldID)
		if checkThreshold and overflow >= 0 then
			local totalYieldKept = 0
			for building in GameInfo.Buildings("FoodKept <> 0") do
				if city:IsHasBuilding(building.ID) then
					totalYieldKept = totalYieldKept + building.FoodKept / 100
				end
			end
			city:ChangePopulation(1,true)
			city:SetFood(0)
			if totalYieldKept > 0 then
				log:Warn(
					"%s add %s food = %s overflow + %s totalYieldKept * %s City_GetYieldNeeded", 
					city:GetName(), 
					overflow + totalYieldKept * City_GetYieldNeeded(city, yieldID), 
					overflow, 
					totalYieldKept, 
					City_GetYieldNeeded(city, yieldID)
				)
			end
			City_ChangeYieldStored(city, yieldID, overflow + totalYieldKept * City_GetYieldNeeded(city, yieldID), true)
		end
	elseif yieldID == YieldTypes.YIELD_PRODUCTION then
		city:ChangeProduction(amount)
	elseif yieldID == YieldTypes.YIELD_CULTURE then
		city:ChangeJONSCultureStored(amount)
		player:ChangeYieldStored(YieldTypes.YIELD_CULTURE, amount)
		local overflow = City_GetYieldStored(city, yieldID) - City_GetYieldNeeded(city, yieldID)
		if checkThreshold and overflow >= 0 then
			city:DoJONSCultureLevelIncrease()
			city:SetJONSCultureStored(0)
			City_ChangeYieldStored(city, yieldID, overflow, true)
		end
	elseif yieldID == YieldTypes.YIELD_POPULATION then
		city:ChangePopulation(amount, true)
	else
		player:ChangeYieldStored(yieldID, amount)
	end
end



---------------------------------------------------------------------
-- Total Player Yields
---------------------------------------------------------------------

if not MapModData.Cep_Yields then
	MapModData.Cep_Yields = {}
	MapModData.Cep_Yields[YieldTypes.YIELD_CS_MILITARY]		= {}
	MapModData.Cep_Yields[YieldTypes.YIELD_CS_GREAT_PEOPLE]	= {}
	local milBaseThreshold = Cep.MINOR_CIV_MILITARISTIC_REWARD_NEEDED * GameInfo.CepGameSpeeds[Game.GetGameSpeedType()].TrainPercent / 100
	local gpBaseThreshold = GameDefines.GREAT_PERSON_THRESHOLD_BASE	* GameInfo.CepGameSpeeds[Game.GetGameSpeedType()].GreatPeoplePercent / 100
	startClockTime = os.clock()
	for playerID,player in pairs(Players) do
		if player:IsAliveCiv() and not player:IsMinorCiv() then
			MapModData.Cep_Yields[YieldTypes.YIELD_CS_MILITARY][playerID]					= {}
			MapModData.Cep_Yields[YieldTypes.YIELD_CS_MILITARY][playerID].Needed			= milBaseThreshold
			MapModData.Cep_Yields[YieldTypes.YIELD_CS_GREAT_PEOPLE][playerID]				= {}
			if UI:IsLoadedGame() then
				MapModData.Cep_Yields[YieldTypes.YIELD_CS_MILITARY][playerID].Stored		= LoadValue("MapModData.Cep_Yields[%s][%s].Stored", YieldTypes.YIELD_CS_MILITARY, playerID) or 0
				MapModData.Cep_Yields[YieldTypes.YIELD_CS_GREAT_PEOPLE][playerID].Stored	= LoadValue("MapModData.Cep_Yields[%s][%s].Stored", YieldTypes.YIELD_CS_GREAT_PEOPLE, playerID) or 0
				MapModData.Cep_Yields[YieldTypes.YIELD_CS_GREAT_PEOPLE][playerID].Needed	= LoadValue("MapModData.Cep_Yields[%s][%s].Needed", YieldTypes.YIELD_CS_GREAT_PEOPLE, playerID) or gpBaseThreshold
			else
				MapModData.Cep_Yields[YieldTypes.YIELD_CS_MILITARY][playerID].Stored		= 0
				MapModData.Cep_Yields[YieldTypes.YIELD_CS_GREAT_PEOPLE][playerID].Stored	= 0
				MapModData.Cep_Yields[YieldTypes.YIELD_CS_GREAT_PEOPLE][playerID].Needed	= gpBaseThreshold
			end
		end
	end
	if UI:IsLoadedGame() then
		log:Info("%3s ms loading Yields", Game.Round((os.clock() - startClockTime)*1000))
	end
end

function PlayerClass.GetYieldStored(player, yieldID, itemID)
	if player == nil then
		log:Fatal("player:GetYieldStored player=nil")
	end
	if yieldID == YieldTypes.YIELD_GOLD then
		return player:GetGold()
	elseif yieldID == YieldTypes.YIELD_SCIENCE then
		return Teams[player:GetTeam()]:GetTeamTechs():GetResearchProgress(itemID or player:GetCurrentResearch())-- + player:GetOverflowResearch()
	elseif yieldID == YieldTypes.YIELD_CULTURE then
		return player:GetJONSCulture()
	elseif yieldID == YieldTypes.YIELD_HAPPINESS_CITY or yieldID == YieldTypes.YIELD_HAPPINESS_NATIONAL then
		return player:GetGoldenAgeProgressMeter()
	elseif yieldID == YieldTypes.YIELD_FAITH then
		return player:GetFaith()
	elseif yieldID == YieldTypes.YIELD_CS_MILITARY or yieldID == YieldTypes.YIELD_CS_GREAT_PEOPLE then
		return MapModData.Cep_Yields[yieldID][player:GetID()].Stored
	end
	
	return 0
end

function PlayerClass.SetYieldStored(player, yieldID, yield, itemID)
	if player == nil then
		log:Fatal("player:GetYieldStored player=nil")
	end
	if showTimers == 3 then timeStart = os.clock() end
	if yieldID == YieldTypes.YIELD_GOLD then
		player:SetGold(yield)
	elseif yieldID == YieldTypes.YIELD_SCIENCE then
		local sciString	= ""
		local teamID	= player:GetTeam()
		local team   	= Teams[teamID]
		local teamTechs	= team:GetTeamTechs()
		
		sciString = "Sci bonus for "..player:GetName()..": "
		local targetTech = itemID or player:GetCurrentResearch()
		if targetTech ~= -1 then
			targetTech = GameInfo.Technologies[targetTech]
			teamTechs:SetResearchProgress(targetTech.ID, yield, player)
			sciString = string.format("%-40s +%-3d  @ %s", sciString, Game.Round(yield), targetTech.Type)
		else
			local researchableTechs = {}
			for techInfo in GameInfo.Technologies() do
				if player:CanResearch(techInfo.ID) and not team:IsHasTech(techInfo.ID) then
					table.insert(researchableTechs, techInfo.ID)
				end
			end
			if #researchableTechs > 0 then
				targetTech = researchableTechs[1 + Map.Rand(#researchableTechs, "player:ChangeYieldStored: Random Tech")]
				targetTech = GameInfo.Technologies[targetTech]
				teamTechs:SetResearchProgress(targetTech.ID, yield, player)
				sciString = string.format("%-40s +%-3d  @ %s (random)", sciString, Game.Round(yield), targetTech.Type)
			end
		end
		--log:Warn(sciString)
	elseif yieldID == YieldTypes.YIELD_CULTURE then
		player:SetJONSCulture(yield)
	elseif yieldID == YieldTypes.YIELD_FAITH then
		player:SetFaith(yield)
	elseif yieldID == YieldTypes.YIELD_HAPPINESS_CITY or yieldID == YieldTypes.YIELD_HAPPINESS_NATIONAL then
		player:SetGoldenAgeProgressMeter(yield)
	elseif yieldID == YieldTypes.YIELD_CS_MILITARY or yieldID == YieldTypes.YIELD_CS_GREAT_PEOPLE then
		MapModData.Cep_Yields[yieldID][player:GetID()].Stored = yield
		SaveValue(yield, "MapModData.Cep_Yields[%s][%s].Stored", yieldID, player:GetID())
	end
	if showTimers == 3 then print(string.format("%3s ms for PlayerClass.SetYieldStored", math.floor((os.clock() - timeStart)*1000))) end
end

function PlayerClass.ChangeYieldStored(player, yieldID, yield, itemID)
	if yield == 0 then
		return
	end
	if showTimers == 3 then timeStart = os.clock() end
	if yieldID == YieldTypes.YIELD_GOLD then
		player:ChangeGold(yield)
	elseif yieldID == YieldTypes.YIELD_CULTURE then
		player:ChangeJONSCulture(yield)
	elseif yieldID == YieldTypes.YIELD_FAITH then
		player:SetFaith(player:GetFaith() + yield)
	elseif yieldID == YieldTypes.YIELD_HAPPINESS_CITY or yieldID == YieldTypes.YIELD_HAPPINESS_NATIONAL then
		player:SetGoldenAgeProgressMeter(math.max(0, player:GetGoldenAgeProgressMeter() + yield))
		local surplusGoldenPoints = player:GetGoldenAgeProgressMeter() - player:GetGoldenAgeProgressThreshold()
		if surplusGoldenPoints > 0 then
			player:SetGoldenAgeProgressMeter(surplusGoldenPoints)
			player:ChangeGoldenAgeTurns((1 + player:GetGoldenAgeModifier() / 100) * (GameDefines.GOLDEN_AGE_LENGTH - player:GetNumGoldenAges()))
			----log:Debug("Mod=%s Turns=%s NumAges=%s", player:GetGoldenAgeModifier(), GameDefines.GOLDEN_AGE_LENGTH - player:GetNumGoldenAges(), player:GetNumGoldenAges())
			player:ChangeNumGoldenAges(1)
		end
	elseif yieldID == YieldTypes.YIELD_EXPERIENCE then
		player:ChangeCombatExperience(yield)
	elseif yieldID == YieldTypes.YIELD_SCIENCE then
		local sciString	= ""
		local teamID	= player:GetTeam()
		local team   	= Teams[teamID]
		local teamTechs	= team:GetTeamTechs()
		
		sciString = "Sci bonus for "..player:GetName()..": "
		local targetTech = itemID or player:GetCurrentResearch()
		if targetTech ~= -1 then
			targetTech = GameInfo.Technologies[targetTech]
			sciString = string.format("%-40s %s +%-3d  @ %s (%s needed)", sciString, Game.Round(teamTechs:GetResearchProgress(targetTech.ID)), Game.Round(yield), targetTech.Type, teamTechs:GetResearchCost(targetTech.ID))
			teamTechs:ChangeResearchProgress(targetTech.ID, yield, player:GetID())
		else
			local researchableTechs = {}
			for techInfo in GameInfo.Technologies() do
				if player:CanResearch(techInfo.ID) and not team:IsHasTech(techInfo.ID) then
					table.insert(researchableTechs, techInfo.ID)
				end
			end
			if #researchableTechs > 0 then
				targetTech = researchableTechs[1 + Map.Rand(#researchableTechs, "player:ChangeYieldStored: Random Tech")]
				targetTech = GameInfo.Technologies[targetTech]
				sciString = string.format("%-40s +%-3d  @ %s (random)", sciString, Game.Round(yield), targetTech.Type)
				teamTechs:ChangeResearchProgress(targetTech.ID, yield, player:GetID())
			end
		end
		if player:IsHuman() then
			log:Warn(sciString)
		end
	end
	if player == Players[Game.GetActivePlayer()] then
		player:UpdateModdedHappiness()
		--LuaEvents.DirtyYieldCachePlayer(player)
	end
	if showTimers == 3 then print(string.format("%3s ms for PlayerClass.ChangeYieldStored", math.floor((os.clock() - timeStart)*1000))) end
end

function PlayerClass.GetYieldNeeded(player, yieldID, itemID)
	if player == nil then
		log:Fatal("player:GetYieldNeeded player=nil")
	end
	if yieldID == YieldTypes.YIELD_SCIENCE then
		return Game.Round(player:GetResearchCost(itemID or player:GetCurrentResearch()))
	elseif yieldID == YieldTypes.YIELD_CULTURE then
		return player:GetNextPolicyCost()
	elseif yieldID == YieldTypes.YIELD_FAITH then
		if player:HasCreatedPantheon() then
			if Game.GetNumReligionsStillToFound() > 0 or player:HasCreatedReligion() then
				return player:GetMinimumFaithNextGreatProphet()		
			end
		elseif player:CanCreatePantheon(false) then
			return Game.GetMinimumFaithNextPantheon()
		end
		if player:GetCurrentEra() >= GameInfo.Eras.ERA_INDUSTRIAL.ID then
			return player:GetMinimumFaithNextGreatProphet()
		end
		return math.huge
	elseif yieldID == YieldTypes.YIELD_HAPPINESS_CITY or yieldID == YieldTypes.YIELD_HAPPINESS_NATIONAL then
		return player:GetGoldenAgeProgressThreshold()
	elseif yieldID == YieldTypes.YIELD_CS_MILITARY or yieldID == YieldTypes.YIELD_CS_GREAT_PEOPLE then
		return MapModData.Cep_Yields[yieldID][player:GetID()].Needed
	end
	return 0
end

function PlayerClass.SetYieldNeeded(player, yieldID, value)
	if player == nil then
		log:Fatal("player:GetYieldNeeded player=nil")
	end
	if showTimers == 3 then timeStart = os.clock() end
	if yieldID == YieldTypes.YIELD_CS_GREAT_PEOPLE then
		MapModData.Cep_Yields[yieldID][player:GetID()].Needed = value
		SaveValue(value, "MapModData.Cep_Yields[%s][%s].Needed", yieldID, player:GetID())
	end
	if showTimers == 3 then print(string.format("%3s ms for PlayerClass.SetYieldNeeded", math.floor((os.clock() - timeStart)*1000))) end
	return 0
end

function PlayerClass.GetMinYieldRate(player, yieldID)
	if not player:IsHuman() and (yieldID == YieldTypes.YIELD_GOLD or yieldID == YieldTypes.YIELD_SCIENCE) then
		return 0
	end
	return GameInfo.Yields[yieldID].MinPlayer
end

function PlayerClass.GetYieldFromConnectedCities(player, yieldID)
	local yield = 0
	if yieldID == YieldTypes.YIELD_GOLD then
		yield = player:GetCityConnectionGoldTimes100() / 100
		if not player:IsHuman() then
			return yield
		end
		local capital = player:GetCapitalCity()
		if capital then --Gold not balanced? +6 Gold from capital to capital trade route at start
			--yield = yield + GameDefines.TRADE_ROUTE_BASE_GOLD/100 + capital:GetPopulation() * GameDefines.TRADE_ROUTE_CITY_POP_GOLD_MULTIPLIER/100
		end
	end
	return yield
end

if not PlayerClass.VanillaCalculateGoldRate then
	PlayerClass.VanillaCalculateGoldRate = PlayerClass.CalculateGoldRate
	--PlayerClass.CalculateGoldRate = function(player) return player:GetYieldRate(YieldTypes.YIELD_GOLD) end
end

function PlayerClass.GetBaseYieldRate(player, yieldID, skipGlobalMods)
	if yieldID ~= YieldTypes.YIELD_GOLD then
		return player:GetYieldRate(yieldID)
	end
	
	local yield = (
		player:GetMinYieldRate(yieldID)
		+ math.max(0, player:GetGoldPerTurnFromDiplomacy())
		+ player:GetGoldFromCitiesTimes100() / 100
		+ player:GetYieldFromConnectedCities(yieldID)
	)
	if not skipGlobalMods then
		yield = yield + player:GetYieldFromTradeDeals(yieldID)
		yield = yield + player:GetYieldFromResources(yieldID)
		yield = yield + player:GetYieldFromPolicies(yieldID)
	end	
	return Game.Round(yield)
end

function PlayerClass.GetYieldRate(player, yieldID, skipGlobalMods)
	if player == nil then
		log:Fatal("player:GetYieldRate player=nil")
		return nil
	end
	--print(tostring(player:GetYieldRate).." player:GetYieldRate")

	local capital = player:GetCapitalCity()
	if capital == nil then
		return 0
	end
	
	--local yield = 0
	--
	local yield = GetYieldCache(player, "playerRate", yieldID)
	if yield and player:GetID() == Game.GetActivePlayer() then
		return yield
	end
	--]]
	
	if showTimers == 3 then timeStart = os.clock() end	
	
	yield = player:GetMinYieldRate(yieldID)
	
	if yieldID == YieldTypes.YIELD_GOLD then
		yield = yield + player:VanillaCalculateGoldRate()
		yield = yield + player:GetFreeGarrisonMaintenance()
		local capital = player:GetCapitalCity()
		if capital then--Gold not balanced? +6 Gold from capital to capital trade route at start
			--yield = yield + GameDefines.TRADE_ROUTE_BASE_GOLD/100 + capital:GetPopulation() * GameDefines.TRADE_ROUTE_CITY_POP_GOLD_MULTIPLIER/100
		end	
		if not skipGlobalMods then
			yield = yield + player:GetYieldFromTradeDeals(yieldID)
			yield = yield + player:GetYieldFromResources(yieldID)
			yield = yield + player:GetYieldFromPolicies(yieldID)
		end
		yield = Game.Round(yield)
	elseif yieldID == YieldTypes.YIELD_SCIENCE then
		--yield = yield + player:GetScienceFromCitiesTimes100()/100
		for city in player:Cities() do
			yield = yield + City_GetYieldRate(city, yieldID)
		end
		yield = yield + player:GetScienceFromOtherPlayersTimes100()/100		
		local goldSurplus = player:GetYieldStored(YieldTypes.YIELD_GOLD) + player:GetYieldRate(YieldTypes.YIELD_GOLD)
		if goldSurplus < 0 then
			yield = yield + goldSurplus
		end
		if not skipGlobalMods then
			yield = yield + player:GetYieldFromTradeDeals(yieldID)
			yield = yield + player:GetYieldFromResources(yieldID)
			yield = yield + player:GetYieldFromPolicies(yieldID)
			yield = yield * (1 + player:GetYieldHappinessMod(yieldID) / 100)
		end
		yield = math.max(0, yield)
	elseif yieldID == YieldTypes.YIELD_CULTURE then
		yield = (yield
			+ player:GetJONSCulturePerTurnForFree()
			+ player:GetJONSCulturePerTurnFromExcessHappiness()
			+ player:GetJONSCulturePerTurnFromMinorCivs()
			+ player:GetCulturePerTurnFromReligion()
		)
		for city in player:Cities() do
			yield = yield + City_GetYieldRate(city, yieldID)
		end
	elseif yieldID == YieldTypes.YIELD_FAITH then
		--yield = yield + player:GetTotalFaithPerTurn()
		yield = (yield
			+ player:GetFaithPerTurnFromReligion()
			+ player:GetFaithPerTurnFromMinorCivs()
			+ player:GetYieldsFromCitystates()[yieldID]
		)
		for city in player:Cities() do
			yield = yield + City_GetYieldRate(city, YieldTypes.YIELD_FAITH)
		end
	elseif yieldID == YieldTypes.YIELD_HAPPINESS_NATIONAL then
		yield = yield + player:GetExcessHappiness();
		--[[yield = yield + Game.GetHandicapInfo(player).HappinessDefault
		for city in player:Cities() do
			yield = yield + City_GetYieldRate(city, YieldTypes.YIELD_HAPPINESS_CITY)
			yield = yield + City_GetYieldRate(city, YieldTypes.YIELD_HAPPINESS_NATIONAL)
		end
		yield = yield + player:GetHappinessFromResources()
		yield = yield + player:GetHappinessFromNaturalWonders()
		if not player:IsMinorCiv() then
			yield = yield + player:GetExtraHappinessPerLuxury()
			yield = yield + player:GetYieldFromSurplusResources(yieldID)
			--yield = yield + player:GetHappinessFromBuildings()
			yield = yield + player:GetHappinessFromTradeRoutes()
			yield = yield + player:GetHappinessFromPolicies()
			yield = yield + player:GetHappinessFromReligion()
			yield = yield + player:GetExtraHappinessPerCity() * player:GetNumCities()
			yield = yield + player:GetYieldsFromCitystates()[yieldID]
			yield = yield - City_GetNumBuilding(player:GetCapitalCity(), GameInfo.Buildings.BUILDING_HAPPINESS_NATIONAL.ID)
		end--]]
		
		--[[
		for city in player:Cities() do
			City_GetYieldRate(city, YieldTypes.YIELD_HAPPINESS_CITY)
			City_GetYieldRate(city, YieldTypes.YIELD_HAPPINESS_NATIONAL)
		end
		yield = yield + player:GetExcessHappiness()
		if not player:IsMinorCiv() then
			yield = yield + player:GetYieldFromSurplusResources(yieldID)
			yield = yield + player:GetYieldsFromCitystates()[yieldID]
			yield = yield - City_GetNumBuilding(player:GetCapitalCity(), GameInfo.Buildings.BUILDING_HAPPINESS_NATIONAL.ID)
		end
		--]]
	elseif yieldID == YieldTypes.YIELD_CS_MILITARY then
		yield = yield + player:GetYieldsFromCitystates(true)[yieldID]
	elseif yieldID == YieldTypes.YIELD_CS_GREAT_PEOPLE then
		local gpRate = 0
		for policyInfo in GameInfo.Policies("MinorGreatPeopleRate != 0") do
			if player:HasPolicy(policyInfo.ID) then
				gpRate = gpRate + policyInfo.MinorGreatPeopleRate
			end
		end
		if gpRate > 0 then
			for minorCivID,minorCiv in pairs(Players) do
				if minorCiv:IsAliveCiv() and minorCiv:IsMinorCiv() then
					local friendLevel = minorCiv:GetMinorCivFriendshipLevelWithMajor(playerID)
					if friendLevel == 1 then
						yield = yield + 1.0 * gpRate
					elseif friendLevel == 2 then
						yield = yield + 1.5 * gpRate
					end
				end
			end
		end
	end
	SetYieldCache(player, "playerRate", yieldID, yield)
	if showTimers == 3 then print(string.format("%3s ms for PlayerClass.GetYieldRate", math.floor((os.clock() - timeStart)*1000))) end
	return yield
end


function PlayerClass.GetYieldTurns(player, yieldID, itemID, overflow)
	local rate = player:GetYieldRate(yieldID, itemID)
	if rate == 0 then
		return 0
	end
	if showTimers == 3 then timeStart = os.clock() end
	
	local turns = math.max(0, math.ceil(
		( player:GetYieldNeeded(yieldID, itemID)
		- player:GetYieldStored(yieldID, itemID) )
		/ rate
	))
	if showTimers == 3 then print(string.format("%3s ms for PlayerClass.GetYieldTurns", math.floor((os.clock() - timeStart)*1000))) end
	return turns
end

function PlayerClass.GetYieldFromSurplusResources(player, yieldID)
	local luxurySurplus = 0
	if yieldID == YieldTypes.YIELD_HAPPINESS_NATIONAL then
		for policyInfo in GameInfo.Policies("ExtraHappinessPerLuxury != 0") do
			if player:HasPolicy(policyInfo.ID) and policyInfo.ExtraHappinessPerLuxury > 0 then
				for resourceInfo in GameInfo.Resources("Happiness != 0") do
					if resourceInfo.Happiness > 0 then
						luxurySurplus = luxurySurplus + math.max(0, player:GetNumResourceTotal(resourceInfo.ID, true) - 1)
					end
				end
			end
		end
	end
	return luxurySurplus
end

function PlayerClass.GetYieldFromResources(player, yieldID)
	local yieldMod = 0
	if not Game.HasValue({TraitType=player:GetTraitInfo().Type, YieldType=GameInfo.Yields[yieldID].Type}, GameInfo.Trait_LuxuryYieldModifier) then
		return 0
	end
	
	local luxuryTotal = 0
	for resourceInfo in GameInfo.Resources() do
		if Game.GetResourceUsageType(resourceInfo.ID) == ResourceUsageTypes.RESOURCEUSAGE_LUXURY and player:GetNumResourceAvailable(resourceInfo.ID, true) > 0 then
			luxuryTotal = luxuryTotal + 1
		end
	end
	local query = string.format("TraitType = '%s' AND YieldType = '%s'", player:GetTraitInfo().Type, GameInfo.Yields[yieldID].Type)
	for policyInfo in GameInfo.Trait_LuxuryYieldModifier(query) do
		yieldMod = yieldMod + policyInfo.YieldMod * luxuryTotal
	end
	return player:GetBaseYieldRate(yieldID, true) * yieldMod / 100
end

--[[
function PlayerClass.GetYieldFromPolicyHappiness(player, yieldID)
	if yieldID ~= YieldTypes.YIELD_SCIENCE then
		return 0
	end
	local yieldMod = 0
	for policyInfo in GameInfo.Policies("HappinessToScience <> 0") do
		if player:HasPolicy(policyInfo.ID) and Game.Round(player:GetYieldRate(YieldTypes.YIELD_HAPPINESS_CITY)) >= 0 then
			yieldMod = yieldMod + policyInfo.HappinessToScience
		end
	end
	if yieldMod == 0 then
		return 0
	end
	return player:GetYieldRate(yieldID, true) * yieldMod / 100
end
--]]

function PlayerClass.GetYieldFromPolicies(player, yieldID)
	local yieldMod = 0
	for policyInfo in GameInfo.Policy_PlayerYieldModifiers{YieldType = GameInfo.Yields[yieldID].Type} do
		if player:HasPolicy(GameInfo.Policies[policyInfo.PolicyType].ID) then
			yieldMod = yieldMod + policyInfo.YieldMod
		end
	end
	if yieldID == YieldTypes.YIELD_SCIENCE then
		for policyInfo in GameInfo.Policies("HappinessToScience <> 0") do
			if player:HasPolicy(policyInfo.ID) and Game.Round(player:GetYieldRate(YieldTypes.YIELD_HAPPINESS_NATIONAL)) >= 0 then
				yieldMod = yieldMod + policyInfo.HappinessToScience
			end
		end
	end
	if yieldMod == 0 then
		return 0
	end
	return player:GetYieldRate(yieldID, true) * yieldMod / 100
end

function PlayerClass.GetYieldFromTerrain(player, yieldID)
	local yield = 0
	if yieldID == YieldTypes.YIELD_HAPPINESS_CITY or yieldID == YieldTypes.YIELD_HAPPINESS_NATIONAL then
		for city in player:Cities() do
			yield = yield + City_GetBaseYieldFromTerrain(city, yieldID)
		end
	end
	--[[
	for plotID, plotYield in pairs(MapModData.Cep_PlotYields[yieldID]) do
		local plotOwner = Players[Map.GetPlotByIndex(plotID):GetOwner()]
		if plotOwner == player then
			yield = yield + plotYield
		end
	end
	--]]
	return yield
end

function PlayerClass.GetYieldFromBuildings(player, yieldID)
	local yield = 0
	for city in player:Cities() do
		yield = yield + City_GetBaseYieldFromBuildings(city, yieldID)
	end
	--[[
	for plotID, plotYield in pairs(MapModData.Cep_PlotYields[yieldID]) do
		local plotOwner = Players[Map.GetPlotByIndex(plotID):GetOwner()]
		if plotOwner == player then
			yield = yield + plotYield
		end
	end
	--]]
	return yield
end

if not PlayerClass.VanillaCalculateUnitCost then
	PlayerClass.VanillaCalculateUnitCost = PlayerClass.CalculateUnitCost
end

function PlayerClass.CalculateUnitCost(player)
	return player:VanillaCalculateUnitCost() - player:GetFreeGarrisonMaintenance()
end

function PlayerClass.GetFreeGarrisonMaintenance(player)
	local gold = 0
	for policyInfo in GameInfo.Policies() do
		if policyInfo.GarrisonFreeMaintenance and player:HasPolicy(policyInfo.ID) then
			for city in player:Cities() do
				local garrisonUnit = city:GetGarrisonedUnit()
				if garrisonUnit then
					gold = gold + Unit_GetMaintenance(garrisonUnit:GetUnitType())
				end
			end
			break
		end
	end
	return gold
end


---------------------------------------------------------------------
-- Plot Yields
---------------------------------------------------------------------

function GetImprovementExtraYield(improvementID, yieldID, player)
	local impInfo	= GameInfo.Improvements[improvementID]
	local player	= Players[playerID]
	local eraID		= player:IsHuman() and player:GetCurrentEra() or Game.GetAverageHumanEra()
	local yield		= 0

	if not impInfo.CreatedByGreatPerson or eraID == 0 then
		return 0
	end

	local query = string.format("ImprovementType = '%s' AND YieldType = '%s'", impInfo.Type, GameInfo.Yields[policyInfo.yieldID].Type)
	for policyInfo in GameInfo.Improvement_Yields(query) do
		yield = yield + eraID * policyInfo.Yield
	end
	return yield
end

function Plot_GetYield(plot, yieldID, isWithoutUpgrade)
	local yield = 0
	local plotID = Plot_GetID(plot)
	if yieldID == YieldTypes.YIELD_HAPPINESS_CITY then
		yield = (MapModData.Cep_PlotYields[yieldID][plotID] or 0)
		local featureID = plot:GetFeatureType()
		if featureID ~= -1 then
			local featureInfo = GameInfo.Features[featureID]
			local yieldInfo = GameInfo.Yields[yieldID]
			for row in GameInfo.Feature_YieldChanges{FeatureType = featureInfo.Type, YieldType = yieldInfo.Type} do
				yield = yield + row.Yield
			end
			--yield = yield + GameInfo.Features[featureID].InBorderHappiness
		end
	elseif yieldID == YieldTypes.YIELD_HAPPINESS_NATIONAL then
		-- todo
	else
		yield = plot:CalculateYield(yieldID, not isWithoutUpgrade)
	end
	--[[
	if (yieldID == YieldTypes.YIELD_FOOD
		or yieldID == YieldTypes.YIELD_PRODUCTION
		or yieldID == YieldTypes.YIELD_GOLD
		or yieldID == YieldTypes.YIELD_SCIENCE
		) then
		yield = plot:CalculateYield(yieldID, true)
	elseif yieldID == YieldTypes.YIELD_CULTURE then
		yield = (MapModData.Cep_PlotYields[yieldID][plotID] or 0)
	elseif yieldID == YieldTypes.YIELD_HAPPINESS_CITY then
		yield = (MapModData.Cep_PlotYields[yieldID][plotID] or 0)
	end
	--]]
	return yield
end

function Plot_ChangeYield(plot, yieldID, yield)
	local currentYield = Plot_GetYield(plot, yieldID)
	local newYield = 0
	local plotID = Plot_GetID(plot)
	local player = Players[plot:GetOwner()]
	if (yieldID == YieldTypes.YIELD_FOOD
		or yieldID == YieldTypes.YIELD_PRODUCTION
		or yieldID == YieldTypes.YIELD_GOLD
		or yieldID == YieldTypes.YIELD_SCIENCE
		or yieldID == YieldTypes.YIELD_CULTURE
		or yieldID == YieldTypes.YIELD_FAITH
		) then
		newYield = (MapModData.Cep_PlotYields[yieldID][plotID] or 0) + yield
		Game.SetPlotExtraYield( plot:GetX(), plot:GetY(), yieldID, newYield)
	elseif yieldID == YieldTypes.YIELD_HAPPINESS_CITY then
		newYield = currentYield + yield
	elseif yieldID == YieldTypes.YIELD_HAPPINESS_NATIONAL then
		-- todo
	elseif yieldID == YieldTypes.YIELD_POPULATION then
		if plot:GetWorkingCity() then
			City_ChangeYieldStored(plot:GetWorkingCity(), yieldID, yield)
		end
		return
	end
	LuaEvents.DirtyYieldCachePlayer(player)
	MapModData.Cep_PlotYields[yieldID][plotID] = newYield
	SaveValue(newYield, "MapModData.Cep_PlotYields[%s][%s]", yieldID, plotID)
	Events.HexYieldMightHaveChanged(plot:GetX(), plot:GetY())
	if plot:GetOwner() ~= -1 and (yieldID == YieldTypes.YIELD_HAPPINESS_CITY or yieldID == YieldTypes.YIELD_HAPPINESS_NATIONAL) then
		player:UpdateModdedHappiness()
	end
end

function Plot_SetYield(plot, yieldID, yield)
	local newYield = 0
	local player = Players[plot:GetOwner()]
	if (yieldID == YieldTypes.YIELD_FOOD
		or yieldID == YieldTypes.YIELD_PRODUCTION
		or yieldID == YieldTypes.YIELD_GOLD
		or yieldID == YieldTypes.YIELD_SCIENCE
		or yieldID == YieldTypes.YIELD_CULTURE
		or yieldID == YieldTypes.YIELD_FAITH
		) then
		newYield = yield
		Game.SetPlotExtraYield(plot:GetX(), plot:GetY(), yieldID, yield)
	elseif yieldID == YieldTypes.YIELD_HAPPINESS_CITY then
		newYield = yield
	elseif yieldID == YieldTypes.YIELD_HAPPINESS_NATIONAL then
		-- todo
	end
	LuaEvents.DirtyYieldCachePlayer(player)
	MapModData.Cep_PlotYields[yieldID][Plot_GetID(plot)] = newYield
	SaveValue(newYield, "MapModData.Cep_PlotYields[%s][%s]", yieldID, Plot_GetID(plot))
	Events.HexYieldMightHaveChanged(plot:GetX(), plot:GetY())
	if player and (yieldID == YieldTypes.YIELD_HAPPINESS_CITY or yieldID == YieldTypes.YIELD_HAPPINESS_NATIONAL) then
		player:UpdateModdedHappiness()
	end
end

--[[
function CheckPlotCultureYields()
	for plotID, yield in pairs(MapModData.Cep_PlotYields[YieldTypes.YIELD_CULTURE]) do
		local plot = Map.GetPlotByIndex(plotID)
		local culture = plot:CalculateYield( 4, true )
		if culture < yield then
			plot:ChangeCulture(yield - culture)
		end
	end
end
--]]

if not MapModData.Cep_PlotYields then
	MapModData.Cep_PlotYields = {}
	startClockTime = os.clock()
	for yieldInfo in GameInfo.Yields() do
		--yieldInfo = GameInfo.Yields[YieldTypes.YIELD_HAPPINESS_CITY]
		MapModData.Cep_PlotYields[yieldInfo.ID] = {}
		for plotID, plot in Plots() do
			if UI:IsLoadedGame() then
				MapModData.Cep_PlotYields[yieldInfo.ID][plotID] = LoadValue("MapModData.Cep_PlotYields[%s][%s]", yieldInfo.ID, plotID) --or 0
			else
				--MapModData.Cep_PlotYields[yieldInfo.ID][plotID] = 0
			end
		end
	end
	if UI:IsLoadedGame() then
		log:Info("%3s ms loading PlotYields", Game.Round((os.clock() - startClockTime)*1000))
	end
end



---------------------------------------------------------------------
-- Update modded yields
---------------------------------------------------------------------

function City_UpdateModdedYields(city, player)	
	--log:Info("%-25s %15s %15s", "City_UpdateModdedYields", player:GetName(), city:GetName())
	if city:IsResistance() then
		return
	end
	
	local capital = player:GetCapitalCity()
	
	if (city == capital
		and not player:IsHuman()
		--and not player:IsMinorCiv()
		) then
		local yield = 0
		if player:IsMilitaristicLeader() then
			yield = Game.GetHandicapInfo().AICapitalYieldMilitaristic
		else
			yield = Game.GetHandicapInfo().AICapitalYieldPeaceful
		end
		if yield ~= 0 then
			if GameInfo.Leaders[player:GetLeaderType()].AIBonus then
				yield = yield * 1.5
			end
			yield = Game.Round(math.min(city:GetPopulation(), yield))
			City_SetNumBuildingClass(city, "BUILDINGCLASS_AI_PRODUCTION", yield)
			if not city:IsHasBuilding(GameInfo.Buildings.BUILDING_AI_GOLD.ID) then
				City_SetNumBuildingClass(city, "BUILDINGCLASS_AI_GOLD", yield + GameInfo.Yields.YIELD_GOLD.MinPlayer)
				City_SetNumBuildingClass(city, "BUILDINGCLASS_AI_SCIENCE", yield + GameInfo.Yields.YIELD_SCIENCE.MinPlayer)
				City_SetNumBuildingClass(city, "BUILDINGCLASS_AI_CULTURE", yield)
			end
			--log:Debug("Set AI Buildings %3s %25s %25s", City_GetNumBuilding(city, GameInfo.Buildings.BUILDING_AI_PRODUCTION.ID), player:GetName(), city:GetName())
			LuaEvents.DirtyYieldCacheCity(city)
		end
	end

	local yieldID = YieldTypes.YIELD_FOOD
	local vanillaYield = city:FoodDifferenceTimes100() / 100
	local modYield = City_GetYieldRate(city, yieldID)
	if modYield ~= vanillaYield and not city:IsFoodProduction() then
		--log:Debug("%20s %15s vanillaYield:%3s modYield:%3s (to food)", player:GetName(), city:GetName(), Game.Round(vanillaYield), Game.Round(modYield))
		City_ChangeYieldStored(city, yieldID, modYield-vanillaYield)
	end
	
	yieldID = YieldTypes.YIELD_PRODUCTION
	vanillaYield = city:GetCurrentProductionDifferenceTimes100(false, false) / 100
	modYield = City_GetYieldRate(city, yieldID)
	if modYield ~= vanillaYield then
		--log:Debug("%20s %15s vanillaYield:%3s modYield:%3s (to production)", player:GetName(), city:GetName(), Game.Round(vanillaYield), Game.Round(modYield))
		City_ChangeYieldStored(city, yieldID, modYield-vanillaYield)
	end
	
	yieldID = YieldTypes.YIELD_GOLD
	vanillaYield = city:GetYieldRate(yieldID)
	modYield = City_GetBaseYieldRate(city, yieldID) * (1 + City_GetBaseYieldRateModifier(city, yieldID)/100)
	if modYield ~= vanillaYield then
		--log:Debug("%20s %15s vanillaYield:%3s modYield:%3s (to gold)", player:GetName(), city:GetName(), Game.Round(vanillaYield), Game.Round(modYield))
		--City_ChangeYieldStored(city, yieldID, modYield-vanillaYield)
	end
	
	yieldID = YieldTypes.YIELD_CULTURE
	vanillaYield = city:GetJONSCulturePerTurn()
	modYield = City_GetYieldRate(city, yieldID)
	if modYield ~= vanillaYield then
		--log:Debug("%20s %15s vanillaYield:%3s modYield:%3s (to culture)", player:GetName(), city:GetName(), Game.Round(vanillaYield), Game.Round(modYield))
		City_ChangeYieldStored(city, yieldID, modYield-vanillaYield)
	end
	
	yieldID = YieldTypes.YIELD_FAITH
	vanillaYield = city:GetFaithPerTurn()
	modYield = City_GetYieldRate(city, yieldID)
	if modYield ~= vanillaYield then
		--log:Debug("%20s %15s vanillaYield:%3s modYield:%3s (to culture)", player:GetName(), city:GetName(), Game.Round(vanillaYield), Game.Round(modYield))
		City_ChangeYieldStored(city, yieldID, modYield-vanillaYield)
	end
	
	--[[
	if City_GetNumBuilding(city, GameInfo.Buildings.BUILDING_NATIONAL_EPIC.ID) >= 1 then
		for policyInfo in GameInfo.Policy_BuildingClassYieldModifiers("YieldType = 'YIELD_GREAT_PEOPLE'") do
			if player:HasPolicy(GameInfo.Policies[policyInfo.PolicyType].ID) then
				-- modify specialist yields
			end
		end
	end
	--]]
end

function PlayerClass.UpdateModdedYieldsEnd(player)
	--[=[
	if player:IsMinorCiv() then
		return
	end
	--log:Info("%-25s %15s", "UpdateModdedYieldsEnd", player:GetName())

	--LuaEvents.DirtyYieldCachePlayer(player)

	GetCurrentUnitSupply(player, true)
	player:UpdateModdedHappiness()
	
	local yieldID = YieldTypes.YIELD_GOLD
	vanillaYield = player:VanillaCalculateGoldRate()
	modYield = player:GetYieldRate(yieldID)
	if modYield ~= vanillaYield then
		if player:IsHuman() then
			--log:Info("%s %s %s vanilla=%s mod=%s", Game.GetGameTurn(), player:GetName(), GameInfo.Yields[yieldID].Type, vanillaYield, modYield)
		end
		player:ChangeYieldStored(yieldID, modYield-vanillaYield)
	end
	
	local yieldID = YieldTypes.YIELD_SCIENCE
	vanillaYield = player:GetScience()
	modYield = player:GetYieldRate(yieldID)
	if modYield ~= vanillaYield then
		if player:IsHuman() then
			--log:Info("%s %s %s vanilla=%s mod=%s", Game.GetGameTurn(), player:GetName(), GameInfo.Yields[yieldID].Type, vanillaYield, modYield)
		end
		player:ChangeYieldStored(yieldID, modYield-vanillaYield)
	end
	
	local yieldID = YieldTypes.YIELD_CULTURE
	vanillaYield = player:GetTotalJONSCulturePerTurn()
	modYield = player:GetYieldRate(yieldID)
	if modYield ~= vanillaYield then
		--log:Info("%s %s %s vanilla=%s mod=%s", Game.GetGameTurn(), player:GetName(), GameInfo.Yields[yieldID].Type, vanillaYield, modYield)
		player:ChangeYieldStored(yieldID, modYield-vanillaYield)
	end
	
	local yieldID = YieldTypes.YIELD_FAITH
	vanillaYield = player:GetTotalFaithPerTurn()
	modYield = player:GetYieldRate(yieldID)
	if modYield ~= vanillaYield then
		--log:Info("%s %s %s vanilla=%s mod=%s", Game.GetGameTurn(), player:GetName(), GameInfo.Yields[yieldID].Type, vanillaYield, modYield)
		player:ChangeYieldStored(yieldID, modYield-vanillaYield)
	end
	
	--
	local yieldID = YieldTypes.YIELD_HAPPINESS_NATIONAL
	vanillaYield = player:GetExcessHappiness()
	modYield = player:GetYieldRate(yieldID)
	if modYield ~= vanillaYield then
		--log:Info("%s %s %s vanilla=%s mod=%s", Game.GetGameTurn(), player:GetName(), GameInfo.Yields[yieldID].Type, vanillaYield, modYield)
		player:ChangeYieldStored(yieldID, modYield-vanillaYield)
	end
	--]=]
end

function PlayerClass.UpdateModdedYieldsStart(player)
	--[=[
	if player:IsMinorCiv() then
		return
	end
	--log:Info("%-25s %15s", "UpdateModdedYieldsStart", player:GetName())
	local playerID = player:GetID()

	LuaEvents.DirtyYieldCachePlayer(player)

	GetCurrentUnitSupply(player, true)
	player:UpdateModdedHappiness()
	--]=]
end

function PlayerClass.UpdateModdedHappiness(player)
	--[=[	
	local capital = player:GetCapitalCity()
	if not capital then
		return
	end			
	
	local yieldID = YieldTypes.YIELD_HAPPINESS_NATIONAL
	local yield = 0	
	
	-- National Happiness
	--yield = yield + player:GetYieldFromTradeDeals(yieldID)
	--yield = yield + player:GetYieldFromPolicies(yieldID)
	--yield = yield + player:GetYieldFromTerrain(yieldID)
	if not player:IsMinorCiv() then
		yield = yield + player:GetYieldFromSurplusResources(yieldID)
		yield = yield + player:GetYieldsFromCitystates()[yieldID]
	end
	--log:Debug("%5s %20s national happiness from mod", yield, player:GetName())
	if yield < 0 then
		log:Error("Happiness from resources=%s citystates=%s", player:GetYieldFromSurplusResources(yieldID), player:GetYieldsFromCitystates()[yieldID])
	end
	City_SetNumBuildingClass(capital, "BUILDINGCLASS_HAPPINESS_NATIONAL", yield)
	
	--yield = Game.Round(player:GetYieldRate(yieldID) * Cep.PERCENT_SCIENCE_FOR_1_SURPLUS_HAPPINESS)

	--capital:SetNumRealBuilding(GameInfo.Buildings.BUILDING_SCIENCE_BONUS.ID, Game.Constrain(0, yield, 200))
	--capital:SetNumRealBuilding(GameInfo.Buildings.BUILDING_SCIENCE_PENALTY.ID, Game.Constrain(0, -yield, 90))
	
	-- City Happiness
	--[[
	yieldID = YieldTypes.YIELD_HAPPINESS_CITY
	for city in player:Cities() do
		local yield = City_GetBaseYieldFromTerrain(city, yieldID)
		city:SetNumRealBuilding(GameInfo.Buildings.BUILDING_HAPPINESS_CITY.ID, yield)
	end
	--]]
	--]=]
end


function PlayerClass.GetYieldFromHappiness(player, yieldID)
	local yield = player:GetMinYieldRate(yieldID)
	if yieldID == YieldTypes.YIELD_SCIENCE then
		yield = player:GetYieldRate(yieldID, true)
		yield = yield * player:GetYieldHappinessMod(yieldID) / 100
	end
	return yield
end

function PlayerClass.GetYieldHappinessMod(player, yieldID)
	local yieldMod = 0
	if yieldID == YieldTypes.YIELD_SCIENCE then
		yieldMod = player:GetYieldRate(YieldTypes.YIELD_HAPPINESS_NATIONAL) * Cep.PERCENT_SCIENCE_FOR_1_SURPLUS_HAPPINESS
	end
	return yieldMod
end

function PlayerClass.GetYieldFromTradeDeals(playerUs, yieldID, doUpdate)
	if yieldID ~= YieldTypes.YIELD_SCIENCE and yieldID ~= YieldTypes.YIELD_GOLD then
		return 0
	end
	
	local yieldSum			= 0
	local playerUsID		= playerUs:GetID()
	local teamUsID			= playerUs:GetTeam()
	local teamUs			= Teams[teamUsID]
	local playerUsScience	= Cep.RESEARCH_AGREEMENT_SCIENCE_RATE_PERCENT
	local playerUsGold		= Cep.OPEN_BORDERS_GOLD_RATE_PERCENT
	local goldMod			= Cep.OPEN_BORDERS_GOLD_RATE_PERCENT / 100
	
	goldMod = goldMod * (1 + playerUs:GetTraitInfo().OpenBordersGoldModifier / 100)
	for policyInfo in GameInfo.Policies("OpenBordersGoldModifier <> 0") do
		if playerUs:HasPolicy(policyInfo.ID) then
			goldMod = goldMod * (1 + policyInfo.OpenBordersGoldModifier / 100)
		end
	end
	
	if yieldID == YieldTypes.YIELD_SCIENCE then
		if playerUsScience == nil or playerUsScience == 0 then
			----log:Debug("playerUsScience: %s", playerUsScience)
			return 0
		end
		if playerUs:GetScience() <= 0 then
			----log:Debug("%s - no science for DoF research (%i)", playerUs:GetName(), playerUs:GetScience())
			return 0
		end
		playerUsScience = playerUs:GetYieldRate(yieldID, true)
	elseif yieldID == YieldTypes.YIELD_GOLD then
		if playerUsGold == nil or playerUsGold == 0 then
			----log:Debug("playerUsGold: %s", playerUsGold)
			return 0
		end
		playerUsGold = playerUs:GetBaseYieldRate(yieldID, true)
	else
		----log:Debug("Invalid yield type: %s", GameInfo.Yields[yieldID].Type)
		return 0
	end

	----log:Debug("%s:GetYieldFromTradeDeals(%s)", playerUs:GetName(), GameInfo.Yields[yieldID].Type)
	for playerThemID,playerThem in pairs(Players) do
		if playerThem:IsAliveCiv() and not playerThem:IsMinorCiv() and not (playerThem == playerUs) then
			local teamThemID = playerThem:GetTeam()
			local teamThem = Teams[teamThemID]
			if not teamUs:IsAtWar(teamThemID) then
				local yieldChange = 0
				if yieldID == YieldTypes.YIELD_SCIENCE then
					if teamUs:IsHasResearchAgreement(teamThemID) then
						yieldChange = yieldChange + (playerUsScience + playerThem:GetYieldRate(yieldID, true)) * Cep.RESEARCH_AGREEMENT_SCIENCE_RATE_PERCENT / 100
						----log:Debug("%s has RA with %s", playerUs:GetName(), playerThem:GetName())
					end
				elseif yieldID == YieldTypes.YIELD_GOLD then
					if teamUs:IsAllowsOpenBordersToTeam(teamThemID) and teamThem:IsAllowsOpenBordersToTeam(teamUsID) then
						local themGold = math.max(0, playerThem:GetBaseYieldRate(yieldID, true))
						yieldChange = yieldChange + goldMod * (playerUsGold + themGold)
					end
				end
				if playerUs:IsDoF(playerThemID) then
					yieldChange = yieldChange * (1 + Cep.FRIENDSHIP_TRADE_BONUS_PERCENT / 100)
				end
				----log:Debug("%s %s from %s = %s", playerUs:GetName(), GameInfo.Yields[yieldID].Type, playerThem:GetName(), yieldChange)
				yieldSum = yieldSum + math.ceil(yieldChange)
			end
		end
	end
	if yieldSum > 0 then
		local yieldMod = 1
		for buildingInfo in GameInfo.Buildings("TradeDealModifier != 0") do
			for city in playerUs:Cities() do 
				if city:IsHasBuilding(buildingInfo.ID) then
					yieldMod = yieldMod + buildingInfo.TradeDealModifier / 100
				end
			end
		end
		yieldSum = yieldSum * yieldMod
	end

	return math.max(0, Game.Round(yieldSum))
end

function City_ChangeCulture(city, player, culture)
	city:ChangeJONSCultureStored(culture)
	player:ChangeYieldStored(YieldTypes.YIELD_CULTURE, culture)
	cultureStored = city:GetJONSCultureStored()
	cultureNext = city:GetJONSCultureThreshold()
	cultureDiff = cultureNext - cultureStored
	if cultureDiff < 1 then
		city:DoJONSCultureLevelIncrease()
		city:SetJONSCultureStored(-cultureDiff)
	end
end


---------------------------------------------------------------------
-- Update citystate rewards
---------------------------------------------------------------------

function UpdatePlayerRewardsFromMinorCivs(player)
	log:Warn("UpdatePlayerRewardsFromMinorCivs")
end

Game.UpdatePlayerRewardsFromMinorCivs = UpdatePlayerRewardsFromMinorCivs

function PlayerClass.GetYieldsFromCitystates(player, doUpdate)
	if type(player) == "number" then
		log:Error("player:GetYieldsFromCitystates player=%s", player)
		return nil
	end
	local playerID = player:GetID()
	MapModData.Cep_MinorCivRewards[playerID] = MapModData.Cep_MinorCivRewards[playerID] or {}
	if doUpdate or MapModData.Cep_MinorCivRewards[playerID].Total == nil then
		--log:Debug("Recalculate Player Rewards from Minor Civs %s", player:GetName())
		MapModData.Cep_MinorCivRewards[playerID].Total = {}
		for yieldInfo in GameInfo.Yields() do
			MapModData.Cep_MinorCivRewards[playerID].Total[yieldInfo.ID] = 0
		end
		if not (player:GetNumCities() == 0 or player:IsMinorCiv() or player:IsBarbarian()) then
			for minorCivID,minorCiv in pairs(Players) do
				if minorCiv:IsAliveCiv() and minorCiv:IsMinorCiv() then
					local traitID = minorCiv:GetMinorCivTrait()
					local friendLevel = minorCiv:GetMinorCivFriendshipLevelWithMajor(player:GetID())
					for yieldID,yield in pairs(player:GetCitystateYields(traitID, friendLevel)) do
						MapModData.Cep_MinorCivRewards[playerID].Total[yieldID] = MapModData.Cep_MinorCivRewards[playerID].Total[yieldID] + yield
					end
					--log:Debug("friendLevel with %s = %i", minorCiv:GetName(), friendLevel)
				end
			end
		end
		--log:Debug("player:GetYieldsFromCitystates %s yield=%s", GameInfo.Yields[YieldTypes.YIELD_CS_MILITARY].Type, MapModData.Cep_MinorCivRewards[playerID].Total[YieldTypes.YIELD_CS_MILITARY])
	end
	return MapModData.Cep_MinorCivRewards[playerID].Total
end

function PlayerClass.GetFinalCitystateYield(player, yieldID)
	if type(player) == "number" then
		log:Error("player:GetFinalCitystateYield player=%s", player)
		return nil
	end
	local csYield = player:GetYieldsFromCitystates()[yieldID]
	if yieldID == YieldTypes.YIELD_CULTURE then
		if csYield == 0 then
			return csYield
		end
		csYield = 0
		for city in player:Cities() do
			local cityYield = City_GetBaseYieldFromMinorCivs(city, yieldID)
			cityYield = cityYield * (1 + City_GetBaseYieldRateModifier(city, yieldID) / 100)
			cityYield = cityYield * (1 + City_GetSurplusYieldRateModifier(city, yieldID) / 100)
			csYield = csYield + cityYield
		end
	end
	return csYield
end

function PlayerClass.GetCitystateYields(player, traitID, friendLevel)
	local yields = {}
	local isRealYields = true
	local query = ""
	if friendLevel <= 0 then
		friendLevel = 2
		isRealYields = false
	end

	for yieldInfo in GameInfo.Yields() do
		yields[yieldInfo.ID] = {Base=0, PerEra=0}		
	end
	
	query = string.format("FriendLevel = '%s'", friendLevel)
	for traitInfo in GameInfo.MinorCivTrait_Yields(query) do
		if GameInfo.MinorCivTraits[traitInfo.TraitType].ID == traitID then
			local yieldID = GameInfo.Yields[traitInfo.YieldType].ID
			yields[yieldID].Base = yields[yieldID].Base + traitInfo.Yield
			yields[yieldID].PerEra = yields[yieldID].PerEra + traitInfo.YieldPerEra
		end
	end
	
	for row in GameInfo.Policy_MinorCivBonuses(query) do
		if player:HasPolicy(GameInfo.Policies[row.PolicyType].ID) then
			local yieldID = GameInfo.Yields[row.YieldType].ID
			yields[yieldID].Base = yields[yieldID].Base + row.Yield
			yields[yieldID].PerEra = yields[yieldID].PerEra + row.YieldPerEra
		end
	end

	--log:Trace("GetCitystateYields(%s, %s, %s)", player:GetName(), GameInfo.MinorCivTraits[traitID].Type, friendLevel)
	for yieldID, yield in pairs(yields) do
		if yield.Base == 0 and yield.PerEra == 0 then
			yields[yieldID] = 0
		else
			yields[yieldID] = yield.Base + yield.PerEra * (1 + player:GetCurrentEra())
			local numCities = player:GetNumCities()
			--
			if yieldID ~= YieldTypes.YIELD_CS_MILITARY and numCities < 4 then
				yields[yieldID] = (1 - 0.2*(4-numCities)) * yields[yieldID]
			end
			--]]
			yields[yieldID] = math.ceil(yields[yieldID] * (1 + player:GetTraitInfo().CityStateBonusModifier / 100))
			--log:Trace("yields[%s] = %s", GameInfo.Yields[yieldID].Type, yields[yieldID])
		end
	end
	if isRealYields then
		return yields, {}
	else
		return {}, yields
	end
end

function PlayerClass.GetAvoidModifier(player, doUpdate)
	if type(player) ~= "table" then
		log:Fatal("player:GetAvoidModifier player=%s", player)
	end
	
	local playerID = player:GetID()
	if true then --doUpdate then
		--log:Debug("Recalculate Avoid Modifier ", player)
		local player = Players[playerID]
		local numAvoid = 0
		local numCities = 0
		for city in player:Cities() do
			numAvoid = numAvoid + (city:IsForcedAvoidGrowth() and 1 or 0)
			numCities = numCities + (not city:IsPuppet() and 1 or 0)
		end
		MapModData.Cep_AvoidModifier[playerID] = math.max(0, 1 + (numAvoid / numCities - 1) / (1 - Cep.AVOID_GROWTH_FULL_EFFECT_CUTOFF / 100))
	end
	return MapModData.Cep_AvoidModifier[playerID] or 0
end

function PlayerClass.GetTotalWeight(player, yieldID, doUpdate)
	if player == nil then
		log:Fatal("player:GetTotalWeight: Invalid player")
	end

	local playerID = player:GetID()
	local totalWeight = 0
	if MapModData.Cep_CityWeights[playerID] and MapModData.Cep_CityWeights[playerID][yieldID] then
		for k,v in pairs(MapModData.Cep_CityWeights[playerID][yieldID]) do
			if player:GetCityByID(k) ~= nil and player:GetCityByID(k):GetOwner() == playerID then
				totalWeight = totalWeight + v
			else
				v = nil
			end
		end
	end
	if totalWeight == 0 then
		return 1
	else
		return totalWeight
	end
end

function City_GetWeight(city, yieldID, doUpdate)
	if city == nil then
		log:Fatal("City_GetWeight city=nil")
	elseif yieldID == nil then
		log:Fatal("City_GetWeight yieldID=nil")
	end
	--log:Error(string.format("City_GetWeight %s %s %s", city:GetName(), GameInfo.Yields[yieldID].Description, tostring(doUpdate)))
	local ownerID = city:GetOwner()
	local owner = Players[ownerID]
	if doUpdate or not (MapModData.Cep_CityWeights[ownerID] and MapModData.Cep_CityWeights[ownerID][yieldID] and MapModData.Cep_CityWeights[ownerID][yieldID][city:GetID()]) then
		MapModData.Cep_CityWeights[ownerID] = MapModData.Cep_CityWeights[ownerID] or {}
		MapModData.Cep_CityWeights[ownerID][yieldID] = MapModData.Cep_CityWeights[ownerID][yieldID] or {}

		local weight = 1
		for v in GameInfo.CityWeights() do
			if v.IsCityStatus == true and city[v.Type](city) then
				local result = city[v.Type](city)
				weight = weight * v.Value * ((type(result) == type(1)) and result or 1)
			end
		end
		if city:GetFocusType() == CityYieldFocusTypes[yieldID] then
			weight = weight * GameInfo.CityWeights.CityFocus.Value
		end
		if not Players[ownerID]:IsCapitalConnectedToCity(city) then
			weight = weight * GameInfo.CityWeights.NotConnected.Value
		end
		if yieldID == YieldTypes.YIELD_FOOD and city:IsForcedAvoidGrowth() then
			weight = weight * owner:GetAvoidModifier(doUpdate)
		end	
		MapModData.Cep_CityWeights[ownerID][yieldID][city:GetID()] = math.max(0, weight)
	end
	--log:Error("Weight = "..MapModData.Cep_CityWeights[ownerID][yieldID][city:GetID()])
	return MapModData.Cep_CityWeights[ownerID][yieldID][city:GetID()]
end

---------------------------------------------------------------------
---------------------------------------------------------------------