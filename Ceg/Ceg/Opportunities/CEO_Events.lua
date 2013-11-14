-- Example events
-- Author: veyDer
--------------------------------------------------------------

include("Trigger.lua")
include("ModTools.lua")
include("FLuaVector")

local log = Events.LuaLogger:New()
log:SetLevel("DEBUG")

----------------------------------------------------------------

Game.TrigCondition = Game.TrigCondition or {}
Game.TrigAction = Game.TrigAction or {}

function IsEmptyPlot(plot)
	return plot:GetImprovementType() == -1 and plot:GetResourceType() == -1 and plot:GetFeatureType() == -1 and plot:GetPlotType() == PlotTypes.PLOT_LAND and plot:GetPlotCity() == nil
end

function Game.TrigCondition.UnitUnownedTerritory(playerID, trigID, targetID, outID)
	return (Players[playerID]:GetUnitByID(targetID):GetPlot():GetOwner() == -1)
end

function Game.TrigCondition.IsNotLevel3(playerID, trigID, targetID, outID)
	return (Players[playerID]:GetUnitByID(targetID):GetLevel() < 3)
end

function Game.TrigCondition.IsExperience10(playerID, trigID, targetID, outID)
	return (Players[playerID]:GetUnitByID(targetID):GetExperience() >= 10)
end

function Game.TrigCondition.IsNotAtWar(playerID, trigID, targetID, outID)
	if not Players[playerID] then
		log:Error("Game.TrigCondition.IsNotAtWar player is nil! %s %s %s %s", playerID, trigID, targetID, outID)
	end
	return not Players[playerID]:IsAtWar(Players[targetID])
end

function Game.TrigCondition.IsNotAngryCS(playerID, trigID, targetID, outID)
	return Players[targetID]:GetMinorCivFriendshipWithMajor(playerID) >= 0
end

function Game.TrigCondition.IsNotAlliedCS(playerID, trigID, targetID, outID)
	local player = Players[playerID]
	local minorCiv = Players[targetID]
	if player:IsAtWar(minorCiv) then
		return false
	end
	return minorCiv:GetAlly() ~= playerID
end

function Game.TrigCondition.CanTrain2Horses(playerID, trigID, targetID, outID)
	if Players[playerID]:GetNumResourceAvailable(GameInfo.Resources.RESOURCE_HORSE.ID, true) < 2 then
		return false
	end
	local buildableUnits = City_GetUnitsOfFlavor(Map_GetCity(targetID), "FLAVOR_MOBILE")
	for unitID, unitFlavor in pairs(buildableUnits) do
		--log:Debug("%s flavor = %s", GameInfo.Units[unitID].Type, unitFlavor)
		if Game.HasValue({UnitType=GameInfo.Units[unitID].Type, ResourceType="RESOURCE_HORSE"}, GameInfo.Unit_ResourceQuantityRequirements) then
			return true
		end
	end
	return false
end

----------------------------------------------------------------

function Game.TrigCondition.IsEmptyRiver(playerID, trigID, targetID, outID)
	local plot = Map.GetPlotByIndex(targetID)
	return plot:IsRiver() and IsEmptyPlot(plot)
end

function Game.TrigCondition.IsEmptyDesert(playerID, trigID, targetID, outID)
	local plot = Map.GetPlotByIndex(targetID)
	return plot:GetTerrainType() == TerrainTypes.TERRAIN_DESERT and IsEmptyPlot(plot)
end

function Game.TrigCondition.IsEmptySnow(playerID, trigID, targetID, outID)
	local plot = Map.GetPlotByIndex(targetID)
	return plot:GetTerrainType() == TerrainTypes.TERRAIN_SNOW and IsEmptyPlot(plot)
end

function Game.TrigCondition.IsEmptyMountain(playerID, trigID, targetID, outID)
	local plot = Map.GetPlotByIndex(targetID)
	return plot:IsMountain() and Plot_GetYield(plot, YieldTypes.YIELD_FOOD) == 0
end

----------------------------------------------------------------

function Game.TrigAction.FortExpansion2(playerID, trigID, targetID, outID)
	Map.GetPlotByIndex(targetID):SetImprovementType(GameInfoTypes.IMPROVEMENT_CITADEL)
end

function Game.TrigAction.GranaryPopulationBoom1(playerID, trigID, targetID, outID)
	Players[playerID]:InitUnitClass("UNITCLASS_SETTLER", Map_GetCity(targetID))
end

function Game.TrigAction.GranaryPopulationBoom2(playerID, trigID, targetID, outID)
	Players[playerID]:InitUnitClass("UNITCLASS_WORKER", Map_GetCity(targetID))
	Players[playerID]:InitUnitClass("UNITCLASS_WORKER", Map_GetCity(targetID))
end

function Game.TrigAction.BarracksRecruitment2(playerID, trigID, targetID, outID)
	local city = Map_GetCity(targetID)
	local buildableUnits = City_GetUnitsOfFlavor(city, "FLAVOR_OFFENSE")
	local unitsTrained = 0
	for i = 1, 2 do
		local newUnitID = Game.GetMaximum(buildableUnits)
		if newUnitID ~= -1 then
			Players[playerID]:InitUnitType(newUnitID, city:Plot(), City_GetUnitExperience(city, newUnitID))
			unitsTrained = unitsTrained + 1
		end
	end
	if unitsTrained == 2 then
		return
	end
	
	local availableIDs = City_GetBuildableUnitIDs(city)
	for i = 1, 2-unitsTrained do
		local newUnitID	= availableIDs[1 + Map.Rand(#availableIDs, "DoBarracksRecruitment2")]
		Players[playerID]:InitUnitType(newUnitID, city:Plot(), City_GetUnitExperience(city, newUnitID))
	end
end

function Game.TrigAction.StableBreed2(playerID, trigID, targetID, outID)
	local city = Map_GetCity(targetID)
	local buildableUnits = City_GetUnitsOfFlavor(city, "FLAVOR_MOBILE")
	for unitID, unitFlavor in pairs(buildableUnits) do
		if not Game.HasValue({UnitType=GameInfo.Units[unitID].Type, ResourceType="RESOURCE_HORSE"}, GameInfo.Unit_ResourceQuantityRequirements) then
			buildableUnits[unitID] = nil
		end
	end
	for i = 1, 2 do
		local newUnitID = Game.GetMaximum(buildableUnits)
		if newUnitID ~= -1 then
			Players[playerID]:InitUnitType(newUnitID, city:Plot(), City_GetUnitExperience(city, newUnitID))
		end
	end	
end

----------------------------------------------------------------

function Game.TrigAction.ScoutSavior1(playerID, trigID, targetID, outID)
	local unit = Players[playerID]:GetUnitByID(targetID)
	local newUnit = Players[playerID]:InitUnitClass("UNITCLASS_SCOUT", unit:GetPlot(), unit:GetExperience())
	for promoInfo in GameInfo.UnitPromotions{Class = "PROMOTION_CLASS_PERSISTANT"} do
		if unit:IsHasPromotion(promoInfo.ID) then
			newUnit:SetHasPromotion(promoInfo.ID, true)
		end
	end
	unit:SetDamage(0)
	unit:SetMoves(unit:MaxMoves())
	newUnit:SetEmbarked(unit:IsEmbarked())
	newUnit:SetLevel(unit:GetLevel())
	newUnit:SetPromotionReady(newUnit:GetExperience() >= newUnit:ExperienceNeeded())
	newUnit:SetDamage(unit:GetDamage())
	newUnit:SetMoves(math.max(1, unit:MovesLeft()))
end

function Game.TrigAction.ScoutSavior2(playerID, trigID, targetID, outID)
	local unit = Players[playerID]:GetUnitByID(targetID)
	local newUnit = Unit_Replace(unit, "UNITCLASS_ARCHER")
	newUnit:SetHasPromotion(GameInfo.UnitPromotions.PROMOTION_IGNORE_TERRAIN_COST_NOUPGRADE.ID, true)
end

function Game.TrigAction.ScoutSavior3(playerID, trigID, targetID, outID)
	local unit = Players[playerID]:GetUnitByID(targetID)
	unit:SetDamage(0)
	unit:ChangeExperience(5)
	unit:SetPromotionReady(unit:GetExperience() >= unit:ExperienceNeeded())
end

----------------------------------------------------------------

function Game.TrigAction.ScoutStories1(playerID, trigID, targetID, outID)
	Players[playerID]:GetUnitByID(targetID):SetDamage(0)
	Players[playerID]:ChangeYieldStored(YieldTypes.YIELD_CULTURE, 100)
end

function Game.TrigAction.ScoutStories2(playerID, trigID, targetID, outID)
	local unit = Players[playerID]:GetUnitByID(targetID)
	local newUnit = Unit_Replace(unit, "UNITCLASS_SENTINEL")
	newUnit:SetDamage(0)
	--newUnit:ChangeExperience(15)
end

function Game.TrigAction.ScoutStories3(playerID, trigID, targetID, outID)
	Players[playerID]:GetUnitByID(targetID):SetDamage(0)
	Players[playerID]:ChangeYieldStored(YieldTypes.YIELD_CULTURE, 30)
end

----------------------------------------------------------------

function Game.TrigAction.PopularWarrior1(playerID, trigID, targetID, outID)
	local player = Players[playerID]
	local unit = player:GetUnitByID(targetID)
	local newUnit = player:InitUnitClass("UNITCLASS_WORKER", unit:GetPlot())
	newUnit:SetEmbarked(unit:IsEmbarked())
	--newUnit:FinishMoves()
	newUnit:SetHasPromotion(GameInfo.UnitPromotions.PROMOTION_IGNORE_TERRAIN_COST.ID, true)
	unit:Kill()
end

function Game.TrigAction.PopularWarrior2(playerID, trigID, targetID, outID)
	local unit = Players[playerID]:GetUnitByID(targetID)
	Unit_Replace(unit, "UNITCLASS_SPEARMAN")
end

function Game.TrigAction.PopularWarrior3(playerID, trigID, targetID, outID)
	local unit = Players[playerID]:GetUnitByID(targetID)
	unit:SetDamage(0)
	unit:ChangeExperience(5)
	unit:SetPromotionReady(unit:GetExperience() >= unit:ExperienceNeeded())
end

function Game.TrigAction.PopularArcher1(playerID, trigID, targetID, outID)
	local player = Players[playerID]
	local unit = player:GetUnitByID(targetID)
	local newUnit = player:InitUnitClass("UNITCLASS_WORKER", unit:GetPlot())
	newUnit:SetEmbarked(unit:IsEmbarked())
	--newUnit:FinishMoves()
	newUnit:SetHasPromotion(GameInfo.UnitPromotions.PROMOTION_IGNORE_TERRAIN_COST.ID, true)
	unit:Kill()
end

function Game.TrigAction.PopularArcher2(playerID, trigID, targetID, outID)
	local unit = Players[playerID]:GetUnitByID(targetID)
	Unit_Replace(unit, "UNITCLASS_CHARIOT_ARCHER")
end

function Game.TrigAction.PopularArcher3(playerID, trigID, targetID, outID)
	local unit = Players[playerID]:GetUnitByID(targetID)
	unit:SetDamage(0)
	unit:ChangeExperience(5)
	unit:SetPromotionReady(unit:GetExperience() >= unit:ExperienceNeeded())
end

----------------------------------------------------------------

function Game.TrigAction.CityStatePolitics1(playerID, trigID, targetID, outID)
	Players[targetID]:ChangeMinorCivFriendshipWithMajor(Players[playerID], 70)
end

function Game.TrigAction.CityStatePolitics2(playerID, trigID, targetID, outID)
	Players[targetID]:ChangeMinorCivFriendshipWithMajor(playerID, -70)
	Players[playerID]:ChangeYieldStored(YieldTypes.YIELD_GOLD, 200)
end

function Game.TrigAction.CityStatePolitics3(playerID, trigID, targetID, outID)
	Players[targetID]:ChangeMinorCivFriendshipWithMajor(Players[playerID], 10)	
end

function Game.TrigAction.DiplomaticIncident1(playerID, trigID, targetID, outID)
	Players[targetID]:ChangeMinorCivFriendshipWithMajor(Players[playerID], 70)
	Players[playerID]:ChangeYieldStored(YieldTypes.YIELD_CULTURE, -200)
end

function Game.TrigAction.DiplomaticIncident2(playerID, trigID, targetID, outID)
	Players[targetID]:ChangeMinorCivFriendshipWithMajor(playerID, -70)
	Players[playerID]:ChangeYieldStored(YieldTypes.YIELD_CULTURE, 200)
end

function Game.TrigAction.ScholasticFame1(playerID, trigID, targetID, outID)
	Players[targetID]:ChangeMinorCivFriendshipWithMajor(Players[playerID], 70)
	Players[playerID]:ChangeYieldStored(YieldTypes.YIELD_SCIENCE, -200)
end

function Game.TrigAction.ScholasticFame2(playerID, trigID, targetID, outID)
	Players[targetID]:ChangeMinorCivFriendshipWithMajor(playerID, -70)
	Players[playerID]:ChangeYieldStored(YieldTypes.YIELD_SCIENCE, 200)
end

----------------------------------------------------------------

function Game.TrigAction.LandGrab1(playerID, trigID, targetID, outID)
	local player = Players[playerID]
	local city = Map_GetCity(targetID)
	local nearPlots = Plot_GetPlotsInCircle(city:Plot(), 2, 5)
	table.sort(nearPlots,
		function(a, b)
			if a:GetOwner() == -1 and b:GetOwner() == -1 then
				return Plot_GetCost(city, a) < Plot_GetCost(city, b)
			end
			return a:GetOwner() == -1
		end
	)
	for i = 1, 3 do
		local plot = nearPlots[i]
		if plot and plot:GetOwner() == -1 then
			local tarHex = ToHexFromGrid(Vector2(plot:GetX(), plot:GetY()))
			Events.SerialEventHexHighlight(tarHex, true, Vector4(1.0, 0.0, 1.0, 1))
			plot:SetOwner(playerID, city:GetID())
		else
			player:ChangeYieldStored(YieldTypes.YIELD_GOLD, 25)
		end
	end
end

function Game.TrigAction.LandGrab2(playerID, trigID, targetID, outID)
	local player = Players[playerID]
	local city = player:GetCapitalCity()
	player:InitUnitClass("UNITCLASS_WORKER", Map_GetCity(targetID):Plot())	
end

function Game.TrigAction.LandGrab3(playerID, trigID, targetID, outID)
	local player = Players[playerID]
	local city = Map_GetCity(targetID)
	local nearPlots = Plot_GetPlotsInCircle(city:Plot(), 2, 5)
	table.sort(nearPlots,
		function(a, b)
			if a:GetOwner() == -1 and b:GetOwner() == -1 then
				return Plot_GetCost(city, a) < Plot_GetCost(city, b)
			end
			return a:GetOwner() == -1
		end
	)
	for i = 1, 1 do
		local plot = nearPlots[i]
		if plot then
			local tarHex = ToHexFromGrid(Vector2(plot:GetX(), plot:GetY()))
			Events.SerialEventHexHighlight(tarHex, true, Vector4(1.0, 0.0, 1.0, 1))
			plot:SetOwner(playerID, city:GetID())
		else
			player:ChangeYieldStored(YieldTypes.YIELD_GOLD, 25)
		end
	end
end

----------------------------------------------------------------

function Game.TrigAction.BarbarianMercenaries1(playerID, trigID, targetID, outID)
	local player = Players[playerID]
	local city = player:GetCapitalCity()
	player:InitUnitClass("UNITCLASS_WORKER", city:Plot())
	--player:InitUnitClass("UNITCLASS_WORKER", city:Plot())
end

function Game.TrigAction.BarbarianMercenaries2(playerID, trigID, targetID, outID)
	local player		= Players[playerID]
	local city			= player:GetCapitalCity()
	local barbWarriorID	= GameInfo.Units.UNIT_BARBARIAN_WARRIOR.ID
	local unitList		= {}

	for overrideInfo in GameInfo.Civilization_UnitClassOverrides{CivilizationType = "CIVILIZATION_BARBARIAN"} do
		if overrideInfo.UnitType then
			for unitInfo in GameInfo.Units{Type = overrideInfo.UnitType} do
				if (unitInfo.Domain == "DOMAIN_LAND" or city:IsCoastal()) and (not unitInfo.PrereqTech or player:HasTech(unitInfo.PrereqTech)) then
					local unitStrength = math.max(unitInfo.Combat, unitInfo.RangedCombat)
					if unitInfo.Domain == "DOMAIN_SEA" then
						unitStrength = unitStrength * 0.75
					end
					unitList[unitInfo.ID] = unitStrength
				end
			end
		end
	end
	for i=1, 2 do
		local unitID = Game.GetRandomWeighted(unitList)
		if unitID and unitID ~= -1 then
			player:InitUnitType(unitID, city:Plot())
		else
			log:Error("Game.TrigAction.BarbarianMercenaries2 invalid unitID %s", unitID)
		end
	end
end

function Game.TrigAction.BarbarianMercenaries3(playerID, trigID, targetID, outID)
	Players[playerID]:ChangeYieldStored(YieldTypes.YIELD_GOLD, 25)
end