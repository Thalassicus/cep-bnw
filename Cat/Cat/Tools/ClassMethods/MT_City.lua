-- MT_City
-- Author: Thalassicus
-- DateCreated: 2/29/2012 8:21:02 AM
--------------------------------------------------------------

include("MT_LuaLogger.lua")
local log = Events.LuaLogger:New()
log:SetLevel("WARN")


---------------------------------------------------------------------
-- City_Capture(city, player, captureType)
--
function City_GetYieldChangeForAction(city, player, captureType, yieldID)
	if captureType == "CAPTURE_PUPPET" then
		local oldHappy = player:GetUnhappiness()
		local newHappy = player:GetUnhappinessForecast(nil, city)
		log:Debug("%s %s = %s - %s", captureType, newHappy - oldHappy, newHappy, oldHappy)
		return -1 * (newHappy - oldHappy)
	end
	local perCity = GameDefines.UNHAPPINESS_PER_CITY
	local pop = city:GetPopulation()
	local popMod = 1 + Cep.SACKED_CITY_POPULATION_CHANGE / 100
	local perPop = GameDefines.UNHAPPINESS_PER_POPULATION
	
	log:Debug("%s %s = %s + math.ceil(%s * %s) * %s", captureType, perCity + math.ceil(pop * popMod) * perPop, perCity, pop, popMod, perPop)
	
	return -1 * (perCity + math.ceil(pop * popMod) * perPop)
end
function City_CalculateResistanceTurns(city, lostPlayer)
	local resistMod		= 1.0	
	for policyInfo in GameInfo.Policies("CityResistTimeMod <> 0") do
		if wonPlayer:HasPolicy(policyInfo.ID) then
			resistMod = resistMod + policyInfo.CityResistTimeMod / 100
		end
	end
	local lostCityPop	= city:GetPopulation()
	local heldTime		= (Game.GetGameTurn() - lostPlayer:GetTurnAcquired(city))
	local resistMaxTime	= math.max(1, math.min(heldTime, lostCityPop))
	local resistTime	= (lostCityPop - 0.1*lostCityPop^1.5) * resistMod
		  resistTime	= Game.Constrain(1, Game.Round(resistTime), resistMaxTime)
	
	return resistTime
end
function City_Capture(city, player, captureType)
	log:Info("%s %s %s", player:GetName(), city:GetName(), captureType)
	if captureType == "CAPTURE_RAZE" then
		city:ChangePopulation(math.ceil(city:GetPopulation() * Cep.SACKED_CITY_POPULATION_CHANGE / 100), true)
		City_SetResistanceTurns(city, city:GetPopulation())
		City_SetRazingTurns(city, city:GetPopulation())
		city:SetPuppet(false)	
		--city:SetOccupied(true)
	elseif captureType == "CAPTURE_SACK" then
		city:ChangePopulation(math.ceil(city:GetPopulation() * Cep.SACKED_CITY_POPULATION_CHANGE / 100), true)
		City_SetResistanceTurns(city, math.ceil( city:GetResistanceTurns() * (1 + Cep.SACKED_CITY_RESISTANCE_CHANGE / 100) ))
		City_SetRazingTurns(city, 0)
		--city:SetOccupied(false)
		city:SetPuppet(true)
	elseif captureType == "CAPTURE_PUPPET" then
		City_SetResistanceTurns(city, 0)
		City_SetRazingTurns(city, 0)
		--city:SetOccupied(false)
		city:SetPuppet(true)
	else
		--City_SetResistanceTurns(city, 0)
		--City_SetRazingTurns(city, 0)
		--city:SetOccupied(false)
		--city:SetPuppet(false)
	end
end


---------------------------------------------------------------------
-- City_CanPurchasePlot(city, plot, budget)
--
function City_GetBestPlotPurchaseCity(city, plot)
	local playerID	= city:GetOwner()
	local player	= Players[playerID]
	local cityPlot	= city:Plot()
	local distance	= Map.PlotDistance(cityPlot:GetX(), cityPlot:GetY(), plot:GetX(), plot:GetY())
	if plot:GetOwner() ~= -1 then
		return nil, math.huge
	elseif distance > GameDefines.MAXIMUM_BUY_PLOT_DISTANCE then
		return nil, math.huge
	end
	local hasAdjacentPlot = false
	for adjPlot in Plot_GetPlotsInCircle(plot, 1, 1) do
		if adjPlot:GetOwner() == playerID then
			hasAdjacentPlot = true
		end
	end
	if not hasAdjacentPlot then
		return nil, math.huge
	end
	local bestCost = Plot_GetCost(city, plot)
	local bestCity = city
	for otherCity in player:Cities() do
		local otherCost = Plot_GetCost(otherCity, plot)
		if bestCost > otherCost then
			bestCost = otherCost
			bestCity = otherCity
		end
	end
	return bestCity, bestCost
end


---------------------------------------------------------------------
-- City_GetBeliefFollowers(city, beliefType)
--
function City_GetBeliefFollowers(city, beliefType)
	if not beliefType or not GameInfo.Beliefs[beliefType] then
		log:Fatal("PlayerClass.HasBelief invalid belief=%s", beliefType)
	end
	local player = Players[city:GetOwner()]
	local beliefID = GameInfo.Beliefs[beliefType].ID
	
	if player:HasCreatedReligion() then
		--log:Error("Created Religion")
		local religionID = player:GetReligionCreatedByPlayer()
		for i, religionBeliefID in ipairs(Game.GetBeliefsInReligion(religionID)) do
			if religionBeliefID == beliefID then
				local followers = city:GetNumFollowers(religionID)
				--log:Error("%s has %s followers of %s", city:GetName(), followers, GameInfo.Beliefs[beliefID].Type)
				return followers
			end
		end
	elseif player:HasCreatedPantheon()  then
		--log:Error("Created Pantheon")
		if player:GetBeliefInPantheon() == beliefID then
			local followers = city:GetNumFollowers(GameInfo.Religions.RELIGION_PANTHEON.ID)
			--log:Error("%s has %s followers of %s", city:GetName(), followers, GameInfo.Beliefs[beliefID].Type)
			return followers
		end
	end
	return 0
end

---------------------------------------------------------------------
--[[ City_GetBuildingsOfFlavor(city, flavorType) usage example:

local buildingID, buildingFlavor = Game.GetMaximum(City_GetBuildingsOfFlavor(city, flavorType))
if buildingID ~= -1 then
	city:SetNumRealBuilding(buildingID, 1)
	hasFreeBuilding[row.FlavorType][cityID] = true
end
]]
function City_GetBuildingsOfFlavor(city, flavorType, goldMin, includeWonders)
	if not flavorType then
		log:Error("City_GetBuildingsOfFlavor: FlavorType is nil!")
		return
	end
	local player = Players[city:GetOwner()]
	local itemFlavors = {}
	local numItems = 0
	for flavorInfo in GameInfo.Building_Flavors(string.format("FlavorType = '%s'", flavorType)) do
		if not flavorInfo.BuildingType then
			log:Error("BuildingType=%s FlavorType=%s", flavorInfo.BuildingType, flavorType)
		else
			local itemInfo = GameInfo.Buildings[flavorInfo.BuildingType]
			--log:Warn("BuildingType=%s itemInfo.Type=%s itemInfo.ID=%s", flavorInfo.BuildingType, itemInfo.Type, itemInfo.ID)

			if not itemInfo then
				log:Error("City_GetBuildingsOfFlavor: %s does not exist in GameInfo.Buildings  (FlavorType=%s)", flavorInfo.BuildingType, flavorType)
			elseif (City_CanBuild(city, itemInfo.ID, 0, 1)
					and (includeWonders or not Building_IsWonder(itemInfo.ID))
					and not (goldMin and player:IsBudgetGone(goldMin + City_GetPurchaseCost(city, YieldTypes.YIELD_GOLD, GameInfo.Buildings, itemInfo.ID), itemInfo.GoldMaintenance))
					) then
				local isResourceAvailable = true
				for row in GameInfo.Building_ResourceQuantityRequirements(string.format("BuildingType = '%s'", itemInfo.Type)) do
					if player:GetNumResourceAvailable(GameInfo.Resources[row.ResourceType].ID, true) <= Cep.MIN_RESOURCE_QUANTITY_FREE_FLAVOR_BUILDINGS then
						isResourceAvailable = false
						break
					end
				end
				if isResourceAvailable then
					itemFlavors[itemInfo.ID] = flavorInfo.Flavor
					numItems = numItems + 1
				end
				itemFlavors[itemInfo.ID] = flavorInfo.Flavor
				numItems = numItems + 1
			end
		end
	end
	return itemFlavors, numItems
end

---------------------------------------------------------------------
-- City_GetUnitsOfFlavor(city, flavorType, goldMin) returns a table of {unitID=unitFlavor, ...} for FlavorType the city can build
--
function City_GetUnitsOfFlavor(city, flavorType, goldMin)
	if not flavorType then
		log:Error("City_GetUnitsOfFlavor: FlavorType is nil!")
		return
	end
	local player = Players[city:GetOwner()]
	local itemFlavors = {}
	local numItems = 0
	for flavorInfo in GameInfo.Unit_Flavors(string.format("FlavorType = '%s'", flavorType)) do
		local itemInfo = GameInfo.Units[flavorInfo.UnitType]
		if not itemInfo then
			log:Error("City_GetUnitsOfFlavor: %s does not exist in GameInfo.Units  (FlavorType=%s)", flavorInfo.UnitType, flavorType)
				
		elseif itemInfo.Class ~= "UNITCLASS_SCOUT" and city:CanTrain(itemInfo.ID, 0, 1) and not (goldMin and player:IsBudgetGone(goldMin + City_GetPurchaseCost(city, YieldTypes.YIELD_GOLD, GameInfo.Units, itemInfo.ID), itemInfo.ExtraMaintenanceCost)) then
			local isResourceAvailable = true
			for row in GameInfo.Unit_ResourceQuantityRequirements(string.format("UnitType = '%s'", itemInfo.Type)) do
				if player:GetNumResourceAvailable(GameInfo.Resources[row.ResourceType].ID, true) <= 0 then
					isResourceAvailable = false
					break
				end
			end
			if isResourceAvailable then
				itemFlavors[itemInfo.ID] = flavorInfo.Flavor
				numItems = numItems + 1
			end
		end
	end
	return itemFlavors, numItems
end

---------------------------------------------------------------------
--[[ City_GetBestBuildableUnit(city)


]]
function City_GetBestBuildableUnit(city, flavorType, excludeSea)
	local player				= Players[city:GetOwner()]
	local bestUnitType			= GameInfo.Units.UNIT_WARRIOR.ID
	local bestCombatStrength	= GameInfo.Units.UNIT_WARRIOR.Combat	
	local isCoastal				= false
	local plot					= city:Plot()
	if plot:IsCoastalLand() and Plot_GetAreaWeights(plot, 1, 8).SEA >= 0.5 then
		isCoastal = true
	end
 	for unit in GameInfo.Units("Combat > 0 AND Class NOT IN ('UNITCLASS_CARRIER')") do
		local unitCombat = unit.Combat
		if unit.CombatClass == "_UNITCOMBAT_SIEGE" or unit.CombatClass == "UNITCOMBAT_SIEGE" then
			unitCombat = unitCombat * 0.75
		elseif (unit.Domain == "DOMAIN_SEA" and isCoastal and not excludeSea) then
			unitCombat = unitCombat * 0.75
		elseif (unit.Domain == "DOMAIN_SEA" and not isCoastal) or (unit.Domain == "DOMAIN_AIR") then
			unitCombat = 0
		end
		if unit.Combat > bestCombatStrength and city:CanTrain( unit.ID ) then
			local isResourceRequired = false
			for unitType in GameInfo.Unit_ResourceQuantityRequirements() do
				if unitType.UnitType == unit.Type then
					isResourceRequired = true
					break
				end
			end
			if not isResourceRequired then
				bestUnitType = unit.ID
				bestCombatStrength = unit.Combat
			end
		end
	end
	--log:Debug("Best unit: "..GameInfo.Units[bestUnitType].Type)
	return bestUnitType
end

---------------------------------------------------------------------
--[[ City_GetBuildableUnitIDs(city) usage example:

local availableIDs	= City_GetBuildableUnitIDs(capitalCity)
local newUnitID		= availableIDs[1 + Map.Rand(#availableIDs, "InitUnitFromList")]
local capitalPlot	= capitalCity:Plot()
local exp			= player:GetCitystateYields(MinorCivTraitTypes.MINOR_CIV_TRAIT_MILITARISTIC, 2)[YieldTypes.YIELD_EXPERIENCE]
player:InitUnitType(newUnitID, capitalPlot, exp)
]]

function City_GetBuildableUnitIDs(city)
	local unitList = {}
	if city == nil then
		log:Fatal("City_GetBuildableUnitIDs: invalid city")
		return nil
	end
	local player = Players[city:GetOwner()]
	if player == nil then
		log:Fatal("City_GetBuildableUnitIDs: invalid player ID = %s", city, city:GetOwner())
		return nil
	end
 	for unitInfo in GameInfo.Units("Combat > 0") do
		if city:CanTrain( unitInfo.ID ) and unitInfo.Class ~= "UNITCLASS_SCOUT" and unitInfo.Class ~= "UNITCLASS_CARRIER" then
			local isResourceAvailable = true
			for row in GameInfo.Unit_ResourceQuantityRequirements("UnitType = '"..unitInfo.Type.."'") do
				if player:GetNumResourceAvailable(GameInfo.Resources[row.ResourceType].ID, true) <= 0 then
					isResourceAvailable = false
					break
				end
			end
			if isResourceAvailable then
				table.insert(unitList, unitInfo.ID)
			end
		end
	end
	if #unitList == 0 then
		log:Warn("City_GetBuildableUnitIDs %s no units found, adding Scout", city:GetName())
		table.insert(unitList, GameInfo.Units.UNIT_SCOUT.ID)
	end
	return unitList
end

---------------------------------------------------------------------
--[[ City_GetID(plot) usage example:
MapModData.buildingsAlive[City_GetID(city)][buildingID] = true
]]

function City_GetID(city)
	if not city then
		log:Fatal("City_GetID city=nil")
		return nil
	end
	local iW, iH = Map.GetGridSize()
	return city:Plot():GetY() * iW + city:Plot():GetX()
end

function Map_GetCity(cityID)
	return Map.GetPlotByIndex(cityID):GetPlotCity()
end

---------------------------------------------------------------------
-- City_GetNumBuilding(city, buildingID)
function City_GetNumBuilding(city, building)
	if not city then
		log:Fatal("City_GetNumBuilding city=%s", city)
		return 0
	end
	if not building then
		log:Fatal("City_GetNumBuilding building=%s", building)
		return 0
	end
	local buildingID = GameInfo.Buildings[building]
	if not buildingID then
		log:Fatal("City_GetNumBuilding: city=%s building=%s", city, building)
		return 0
	end
	buildingID = buildingID.ID
	return city:GetNumRealBuilding(buildingID) + city:GetNumFreeBuilding(buildingID)
end

---------------------------------------------------------------------
-- City_GetNumBuildingClass and City_SetNumBuildingClass
--
function City_GetNumBuildingClass(city, buildingClass)
	return City_GetNumBuilding(city, Players[city:GetOwner()]:GetUniqueBuildingID(buildingClass))
end

function City_SetNumBuildingClass(city, buildingClass, count)
	if count < 0 then
		log:Error("City_SetNumBuildingClass %s %s count=%s", city:GetName(), buildingClass, count)
		return
	end
	city:SetNumRealBuilding(Players[city:GetOwner()]:GetUniqueBuildingID(buildingClass), count)
end

---------------------------------------------------------------------
--[[ City_GetPurchaseCost usage example:

Players[city:GetOwner()]:GetYieldStored(YieldTypes.YIELD_GOLD) >= City_GetPurchaseCost(city, YieldTypes.YIELD_GOLD, GameInfo.Buildings, buildingID)
]]
function City_GetPurchaseCost(city, yieldID, itemTable, itemID)
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

	if not itemTable or not itemID or not itemTable[itemID] then
		log:Fatal("City_GetPurchaseCost %s itemTable=%s itemID=%s", city:GetName(), itemTable, itemID)
		return
	end

	if itemTable == GameInfo.Projects then
		return -1
	end

	local player = Players[city:GetOwner()]
	local cost = 0
	local hurryCost = -1
	local hurryCostMod = itemTable[itemID].HurryCostModifier

	if not hurryCostMod then
		log:Fatal("City_GetPurchaseCost HurryCostModifier is invalid! %s itemTable=%s itemID=%s", city:GetName(), itemTable, itemID)
	end

	if yieldID == YieldTypes.YIELD_FAITH then
		if itemTable == GameInfo.Units then
			return city:GetUnitFaithPurchaseCost( itemID, true )
		end
		return city:GetBuildingFaithPurchaseCost( itemID )
	end

	if hurryCostMod ~= -1 then
		if itemTable == GameInfo.Units then
			cost = player:GetUnitProductionNeeded(itemID)
		elseif itemTable == GameInfo.Buildings then
			cost = player:GetBuildingProductionNeeded(itemID)
			cost = cost + itemTable[itemID].PopCostMod * city:GetPopulation()
		elseif itemTable == GameInfo.Projects then
			cost = player:GetProjectProductionNeeded(itemID)
		end
		hurryCost = math.pow(cost * GameDefines.GOLD_PURCHASE_GOLD_PER_PRODUCTION, GameDefines.HURRY_GOLD_PRODUCTION_EXPONENT)
		local empireMod = 0
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
		hurryCost = hurryCost * (1 + hurryCostMod/100) * (1 + empireMod/100)
		hurryCost = Game.Round(hurryCost / GameDefines.GOLD_PURCHASE_VISIBLE_DIVISOR) * GameDefines.GOLD_PURCHASE_VISIBLE_DIVISOR		
	end

	return hurryCost
end

---------------------------------------------------------------------
--[[ City_GetUnitExperience(city, unitType) usage example:

]]
function City_GetUnitExperience(city, unitType)
	if city == nil then
		log:Fatal("City_GetUnitExperience: nil city")
		return nil
	end
	if unitType == nil then
		log:Fatal("City_GetUnitExperience: nil unitType @ %20s %20s", city:GetName(), city:GetOwner())
		return nil
	end
	--[[
	local xp = city:GetFreeExperience() 
	local domain = GameInfo.Units[unitType].Domain
	local domainID = GameInfo.Domains[domain].ID
	city:GetProductionExperience(UnitTypes eUnit) 
	xp = xp + city:GetDomainFreeExperience(domainID)
	--]]

	return city:GetProductionExperience(GameInfo.Units[unitType].ID)
end

---------------------------------------------------------------------
--[[ City_CanBuild(city, yieldID, itemTable, itemID, continue, testVisible, ignoreCost) usage example:

]]
function City_CanBuild(city, buildingID, continue, testVisible, ignoreCost)
	return city:CanConstruct(buildingID, continue, testVisible, ignoreCost)
end

function City_CanPurchase(city, yieldID, itemTable, itemID, ignoreCost)
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
	if itemTable == GameInfo.Projects then
		return false
	end

	if ignoreCost then
		if itemTable == GameInfo.Units then
			return city:IsCanPurchase(true, itemID, -1, -1, yieldID)
		end
		return city:IsCanPurchase(true, -1, itemID, -1, yieldID)
	end

	if not ignoreCost and City_GetPurchaseCost(city, yieldID, itemTable, itemID) > Players[city:GetOwner()]:GetYieldStored(yieldID) then
		return false
	end

	if itemTable == GameInfo.Units then
		return city:IsCanPurchase(false, itemID, -1, -1, yieldID)
	end
	return city:IsCanPurchase(false, -1, itemID, -1, yieldID)
end

---------------------------------------------------------------------
-- City_GetSpecialistCount(city, specialistID)
--
function City_GetSpecialistCount(city, specialistID)
	if specialistID and specialistID > 0 then
		return city:GetSpecialistCount(specialistID)
	end

	local count = 0
	for specialistInfo in GameInfo.Specialists() do
		count = count + city:GetSpecialistCount(specialistInfo.ID)
	end
	return count
end

---------------------------------------------------------------------
-- City_HasRailroad(city)
--
function City_HasRailroad(city)
	local player = Players[city:GetOwner()]
	if city:IsCapital() and player:HasTech("TECH_RAILROAD") then
		return true
	end
	if string.find(GetProductionTooltip(city), Locale.ConvertTextKey("TXT_KEY_ROUTE_RAILROAD")) then
		return true
	end
	return false
end


---------------------------------------------------------------------
-- City_SetRazingTurns(city, turns)
function City_SetRazingTurns(city, turns)
	city:ChangeRazingTurns(turns - city:GetRazingTurns())
end

---------------------------------------------------------------------
-- City_SetResistanceTurns(city, turns)
function City_SetResistanceTurns(city, turns)
	city:ChangeResistanceTurns(turns - city:GetResistanceTurns())
end