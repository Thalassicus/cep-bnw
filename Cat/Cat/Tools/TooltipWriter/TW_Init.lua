-- TW_InitBuildings
-- Author: Thalassicus
-- DateCreated: 12/19/2012 9:35:05 PM
--------------------------------------------------------------

--
include( "ModTools.lua" )

if Game == nil then
	print("Game is nil!")
	--return
end

print("Initializing TW_Init.lua")

--
-- Globals
--

do

log = Events.LuaLogger:New()
log:SetLevel("DEBUG")

timeStart = os.clock()

isFirstTimePromotions = true
errorMsg = {Type=statType, Section=statSection, Priority=linePriority, TextBody=statType}

Game.Stats				= Game.Stats or {}
Game.Stats.Units		= Game.Stats.Units or {}
Game.Stats.Buildings	= Game.Stats.Buildings or {}
Game.Stats.Promotions	= Game.Stats.Promotions or {}

MAX_RESOURCES = {}
for resourceInfo in GameInfo.Resources() do
	resUsageType = Game.GetResourceUsageType(resourceInfo.ID)
	MAX_RESOURCES[resUsageType] = (MAX_RESOURCES[resUsageType] or 0) + 1
end

MAX_SPECIALISTS = 0
for specialistInfo in GameInfo.Specialists() do
	MAX_SPECIALISTS = MAX_SPECIALISTS + 1
end

resUsageTypeStr = {}
resUsageTypeStr[ResourceUsageTypes.RESOURCEUSAGE_STRATEGIC] = Locale.ConvertTextKey("TXT_KEY_CIV5_RESOURCE_STRATEGIC")
resUsageTypeStr[ResourceUsageTypes.RESOURCEUSAGE_LUXURY] = Locale.ConvertTextKey("TXT_KEY_CIV5_RESOURCE_LUXURY")
resUsageTypeStr[ResourceUsageTypes.RESOURCEUSAGE_BONUS] = Locale.ConvertTextKey("TXT_KEY_CIV5_RESOURCE_BONUS")

statTextKey			= nil
statFootKey			= nil
statFoot			= nil
statPriority		= nil
lineType			= nil
lineTextKey			= nil
lineSection			= nil
linePriority		= nil
linePrefix			= nil
lineSign			= nil
lineValue			= nil
lineExtra			= nil
objectInfo			= nil
objectClassInfo		= nil
activePlayer		= nil
activeTeam			= nil
adjustedCost		= nil
subStats			= nil
	
end


--
-- Main Method
--

Game.GetDefaultBuildingStatText = Game.GetDefaultBuildingStatText or function(objectID, statType, statSection, sPriority, statValue, city)
	if not objectID or not statType then
		log:Fatal("Game.GetDefaultBuildingStatText objectID=%s statType=%s statValue=%s statPriority=%s", objectID, statType, statValue, sPriority)
	end
	if not statValue or statValue == 0 or statValue == "" then
		return {}
	end
	
	lineType		= statType
	objectInfo		= GameInfo.Buildings[objectID]
	objectClassInfo	= GameInfo.BuildingClasses[objectInfo.BuildingClass]
	activePlayer	= Players[Game.GetActivePlayer()]
	activeTeam		= Teams[Game.GetActiveTeam()]
	adjustedCost	= activePlayer:GetBuildingProductionNeeded(objectID)	
	statTextKey		= "TXT_KEY_BUILDING_EFFECT" .. string.upper( string.gsub(lineType, '(%u)',  function(x) return "_"..x end) )
	statFootKey		= Locale.ConvertTextKey(statTextKey.."_FOOT")
	statFoot		= (statFootKey ~= (statTextKey.."_FOOT")) and statFootKey
	statPriority	= sPriority
	lineTextKey		= statTextKey
	lineSection		= statSection
	linePriority	= statPriority
	linePrefix		= ""
	lineSign		= ""
	lineValue		= statValue
	lineExtra		= ""	
	subStats		= {}
	
	if type(lineValue) == "number" then
		lineValue = ToDecimal(lineValue)
		lineSign = GetSign(lineValue)
	end
	
	if lineType == "Name" then
		table.insert(subStats, {Type=lineType, Section=statSection, Priority=statPriority,
			TextBody = Locale.ToUpper(Locale.ConvertTextKey(objectInfo.Description or objectInfo.Type))
		})
		
	elseif lineType == "Cost" then
		local prodCost = objectInfo.Cost
		if prodCost > 0 then
			lineValue = activePlayer:GetBuildingProductionNeeded(objectID)
			InsertBuildingSubStat()
		elseif prodCost == -1 and objectInfo.FaithCost ~= -1 then
			if city then
				lineValue = city:GetBuildingFaithPurchaseCost(objectInfo.ID, true)
			else
				lineValue = objectInfo.FaithCost * Game.GetSpeedInfo().ConstructPercent
			end
		end

	elseif lineType == "HurryCostModifier" then
		if objectInfo.Cost <= 0 or objectInfo[lineType] == -1 then return {} end
		lineValue = activePlayer:GetPurchaseCostMod(activePlayer:GetBuildingProductionNeeded(objectID), objectInfo[lineType])
		InsertBuildingSubStat()

	elseif lineType == "GoldMaintenance" then
		if city and city:GetNumFreeBuilding(objectID) > 0 then return {} end
		lineValue = objectInfo[lineType]
		InsertBuildingSubStat()

	elseif lineType == "UnmoddedHappiness" then
		lineValue = activePlayer:GetBuildingYield(objectID, YieldTypes.YIELD_HAPPINESS_NATIONAL, city)
		InsertBuildingSubStat()

	elseif lineType == "Happiness" then
		lineValue = activePlayer:GetBuildingYield(objectID, YieldTypes.YIELD_HAPPINESS_CITY, city)
		InsertBuildingSubStat()

	elseif lineType == "AlreadyBuilt" then
		lineValue = Building_IsAlreadyBuilt(objectID, activePlayer)
		InsertBuildingSubStat()

	elseif lineType == "Replaces" then
		local defaultObjectType = objectClassInfo.DefaultBuilding
		if objectInfo.Type ~= defaultObjectType then		
			lineValue = Locale.ConvertTextKey(GameInfo.Buildings[defaultObjectType].Description or GameInfo.Buildings[defaultObjectType].Type)
			InsertBuildingSubStat()
		end

	elseif lineType == "YieldChange" then
		for yieldInfo in GameInfo.Yields("Type <> 'YIELD_HAPPINESS_CITY' AND Type <> 'YIELD_HAPPINESS_NATIONAL'") do
			lineValue = activePlayer:GetBuildingYield(objectID, yieldInfo.ID, city)
			if lineValue ~= 0 then
				linePrefix = string.format("%s {%s}", yieldInfo.IconString or ("ICON:"..yieldInfo.Type), yieldInfo.Description or yieldInfo.Type)
				linePriority = statPriority + (100 * yieldInfo.ListPriority)
				InsertBuildingSubStat()
			end
		end

	elseif lineType == "YieldMod" then
		for yieldInfo in GameInfo.Yields() do
			lineValue = activePlayer:GetBuildingYieldMod(objectID, yieldInfo.ID, city) + Game.GetBuildingYieldModifier(objectID, yieldInfo.ID)
			if lineValue ~= 0 then
				linePrefix = string.format("%s {%s}", yieldInfo.IconString or ("ICON:"..yieldInfo.Type), yieldInfo.Description or yieldInfo.Type)
				linePriority = statPriority + (100 * yieldInfo.ListPriority)
				InsertBuildingSubStat()
			end
		end

	elseif lineType == "YieldInstant" then
		return GetYieldInfo{table="Building_YieldInstant"}

	elseif lineType == "YieldPerPop" then
		return GetYieldInfo{table="Building_YieldChangesPerPop", div100=true}

	elseif lineType == "YieldFromReligion" then
		return GetYieldInfo{table="Building_YieldChangesPerReligion", div100=true}

	elseif lineType == "YieldModSurplus" then
		return GetYieldInfo{table="Building_YieldSurplusModifiers"}

	elseif lineType == "YieldModInAllCities" then
		return GetYieldInfo{table="Building_GlobalYieldModifiers"}

	elseif lineType == "YieldFromLakes" then
		return GetYieldInfo{table="Building_LakePlotYieldChanges"}

	elseif lineType == "YieldFromPlots" then
		return GetYieldInfo{table="Building_PlotYieldChanges", tableReference="Plots", cellReference="PlotType"}

	elseif lineType == "YieldFromSea" then
		return GetYieldInfo{table="Building_SeaPlotYieldChanges", tableReference="Plots", typeReference="PLOT_OCEAN"}
		
	elseif lineType == "YieldFromTerrain" then
		return GetYieldInfo{table="Building_TerrainYieldChanges", tableReference="Terrains", cellReference="TerrainType"}
		
	elseif lineType == "YieldFromRivers" then
		return GetYieldInfo{table="Building_RiverPlotYieldChanges"}

	elseif lineType == "YieldFromFeatures" then
		local yieldList = {}
		for row in GameInfo.Building_FeatureYieldChanges{BuildingType = objectInfo.Type} do
			if row.FeatureType ~= objectInfo.NotFeature then
				if not yieldList[row.YieldType] then yieldList[row.YieldType] = {} end
				yieldList[row.YieldType][row.Yield] = (yieldList[row.YieldType][row.Yield] or "") .. Locale.ConvertTextKey(GameInfo.Features[row.FeatureType].Description or GameInfo.Features[row.FeatureType].Type) .. ", "
			end
		end
		return ConvertYieldList(lineType, statSection, statPriority, lineTextKey, yieldList)

	elseif lineType == "YieldFromTech" then
		return GetYieldInfo{table="Building_TechEnhancedYieldChanges", tableReference="Technologies", cellReference="EnhancedYieldTech"}

	elseif lineType == "YieldFromBuildings" then
		return GetYieldInfo{table="Building_BuildingClassYieldChanges", yield="YieldChange", tableReference="BuildingClasses", cellReference="BuildingClassType"}

	elseif lineType == "YieldModFromBuildings" then
		return GetYieldInfo{table="Building_BuildingClassYieldModifiers", tableReference="BuildingClasses", cellReference="BuildingClassType"}
		
	elseif lineType == "YieldModHurry" then
		return GetYieldInfo{table="Building_HurryModifiers", yield="HurryCostModifier", yieldType=GameInfo.HurryInfos.HURRY_GOLD.YieldType}

	elseif lineType == "YieldModCombat" then
		return GetYieldInfo{table="Building_UnitCombatProductionModifiers", yield="Modifier", tableReference="UnitCombatInfos", cellReference="UnitCombatType", yieldType="YIELD_PRODUCTION"}

	elseif lineType == "YieldModDomain" then
		return GetYieldInfo{table="Building_DomainProductionModifiers", yield="Modifier", tableReference="Domains", cellReference="DomainType", yieldType="YIELD_PRODUCTION"}
		
	elseif lineType == "YieldModMilitary" or lineType == "YieldModBuilding" or lineType == "YieldModWonder" or lineType == "YieldModSpace" then
		lineType = string.gsub(lineType, "YieldMod(.*)", function(x) return x.."ProductionModifier" end)
		InsertBuildingSubStat(GameInfo.Yields.YIELD_PRODUCTION)

	elseif lineType == "YieldStorage" then
		lineType = "FoodKept"
		InsertBuildingSubStat(GameInfo.Yields.YIELD_FOOD)

	elseif lineType == "InstantBorderPlots" then
		InsertBuildingSubStat(GameInfo.Yields.YIELD_CULTURE)

	elseif lineType == "InstantBorderRadius" then
		InsertBuildingSubStat(GameInfo.Yields.YIELD_CULTURE)

	elseif lineType == "YieldFromUsingGreatPeople" then
		lineType = "GreatPersonExpendGold"
		InsertBuildingSubStat(GameInfo.Yields.YIELD_GOLD)

	elseif lineType == "TradeRouteModifier" then
		InsertBuildingSubStat(GameInfo.Yields.YIELD_GOLD)

	elseif lineType == "MedianTechPercentChange" then
		InsertBuildingSubStat(GameInfo.Yields.YIELD_SCIENCE)

	elseif lineType == "ReligiousPressureModifier" then
		InsertBuildingSubStat(GameInfo.Yields.YIELD_FAITH)

	elseif lineType == "YieldFromResources" then
		local yieldRes = {}
		local numResources = {}
		for row in GameInfo.Building_ResourceYieldChanges{BuildingType = objectInfo.Type} do
			local resourceInfo	= GameInfo.Resources[row.ResourceType]
			local resUsageType	= tonumber(Game.GetResourceUsageType(resourceInfo.ID))
			if not yieldRes[row.YieldType] then yieldRes[row.YieldType] = {} end
			if not yieldRes[row.YieldType][row.Yield] then yieldRes[row.YieldType][row.Yield] = {} end
			if not yieldRes[row.YieldType][row.Yield][resUsageType] then yieldRes[row.YieldType][row.Yield][resUsageType] = {} end
			yieldRes[row.YieldType][row.Yield][resUsageType].string = (yieldRes[row.YieldType][row.Yield][resUsageType].string or "") .. (resourceInfo.IconString or ("ICON:"..resourceInfo.Type))
			yieldRes[row.YieldType][row.Yield][resUsageType].quantity = (yieldRes[row.YieldType][row.Yield][resUsageType].quantity or 0) + 1
		end
		
		-- merge usage strings
		local yieldList = {}
		for yieldType, yields in pairs(yieldRes) do
			if not yieldList[yieldType] then yieldList[yieldType] = {} end			
			for yield, resources in pairs(yields) do
				if not yieldList[yieldType][yield] then yieldList[yieldType][yield] = "" end	
				local numMaxed = 0
				for resUsageType, res in pairs(resources) do
					if res.quantity >= MAX_RESOURCES[resUsageType] then
						yieldList[yieldType][yield] = yieldList[yieldType][yield] .. resUsageTypeStr[resUsageType]..", "
						numMaxed = numMaxed + 1
					else
						yieldList[yieldType][yield] = yieldList[yieldType][yield] .. res.string
					end
				end
				if numMaxed == 3 then
					yieldList[yieldType][yield] = Locale.ConvertTextKey("TXT_KEY_SV_ICONS_ALL") .. " " .. Locale.ConvertTextKey("TXT_KEY_SV_ICONS_RESOURCES")
				end				
			end
		end
		
		return ConvertYieldList(lineType, statSection, statPriority, lineTextKey, yieldList)

	elseif lineType == "YieldFromSpecialists" then
		local yieldList = {}
		local  yieldNum = {}
		for row in GameInfo.Building_SpecialistYieldChanges{BuildingType = objectInfo.Type} do
			if not yieldList[row.YieldType] then yieldList[row.YieldType] = {} end
			if not  yieldNum[row.YieldType] then  yieldNum[row.YieldType] = {} end
			yieldList[row.YieldType][row.Yield] = (yieldList[row.YieldType][row.Yield] or "") .. Locale.ConvertTextKey(GameInfo.Specialists[row.SpecialistType].Description or GameInfo.Specialists[row.SpecialistType].Type) .. ", "
			 yieldNum[row.YieldType][row.Yield] = ( yieldNum[row.YieldType][row.Yield] or 0) + 1
			if   yieldNum[row.YieldType][row.Yield] == MAX_SPECIALISTS then
				yieldList[row.YieldType][row.Yield] = Locale.ConvertTextKey("TXT_KEY_PEOPLE_SECTION_1")
			end
		end
		return ConvertYieldList(lineType, statSection, statPriority, lineTextKey, yieldList)

	elseif lineType == "SpecialistType" then
		local specInfo = GameInfo.Specialists[objectInfo.SpecialistType]
		local statPriority = statPriority * specInfo.ListPriority
		if objectInfo.SpecialistCount ~= 0 then
			lineTextKey = "TXT_KEY_BUILDING_EFFECT_SPECIALIST_POINTS"
			linePrefix = string.format("%s {%s}", specInfo.IconString or ("ICON:"..specInfo.Type), specInfo.Description or specInfo.Type)
			lineValue = objectInfo.SpecialistCount
			InsertBuildingSubStat()
		end
		if objectInfo.GreatPeopleRateChange ~= 0 then
			lineTextKey = "TXT_KEY_BUILDING_EFFECT_GREAT_PERSON_POINTS"
			linePrefix = specInfo.IconString or ("ICON:"..specInfo.Type)
			lineValue = objectInfo.GreatPeopleRateChange
			lineExtra = string.format("{%s}", specInfo.Description or specInfo.Type)
			InsertBuildingSubStat()
		end

	elseif lineType == "GreatWorkSlotType" then
		local gwInfo = GameInfo.GreatWorkSlots[objectInfo.GreatWorkSlotType]
		local statPriority = statPriority * gwInfo.ListPriority
		if objectInfo.GreatWorkCount ~= 0 then
			lineTextKey = gwInfo.SlotsToolTipText or gwInfo.Type
			linePrefix = objectInfo.GreatWorkCount
			InsertBuildingSubStat()
		end
		
	elseif lineType == "ExperienceDomain" then
		for row in GameInfo.Building_DomainFreeExperiences{BuildingType = objectInfo.Type} do
			lineValue = row.Experience
			lineExtra = Locale.ConvertTextKey(GameInfo.Domains[row.DomainType].Description or GameInfo.Domains[row.DomainType].Type)
			InsertBuildingSubStat()
		end

	elseif lineType == "ExperienceCombat" then
		for row in GameInfo.Building_UnitCombatFreeExperiences{BuildingType = objectInfo.Type} do
			lineValue = row.Experience
			lineExtra = Locale.ConvertTextKey(GameInfo.UnitCombatInfos[row.UnitCombatType].Description or GameInfo.UnitCombatInfos[row.UnitCombatType].Type)
			InsertBuildingSubStat()
		end

	elseif lineType == "FreeGreatWork" then
		lineValue = string.format("{%s}", GameInfo.GreatWorks[objectInfo.FreeGreatWork].Description or GameInfo.GreatWorks[objectInfo.FreeGreatWork].Type)
		InsertBuildingSubStat()

	elseif lineType == "FreeBuildingThisCity" then
		local uniqueID = activePlayer:GetUniqueBuildingID(objectInfo[lineType])
		lineValue = string.format("{%s}", GameInfo.Buildings[uniqueID].Description or GameInfo.Buildings[uniqueID].Type)
		InsertBuildingSubStat()

	elseif lineType == "FreeBuilding" then
		local uniqueID = activePlayer:GetUniqueBuildingID(objectInfo[lineType])
		lineValue = string.format("{%s}", GameInfo.Buildings[uniqueID].Description or GameInfo.Buildings[uniqueID].Type)
		InsertBuildingSubStat()

	elseif lineType == "FreeUnits" then
		for row in GameInfo.Building_FreeUnits{BuildingType = objectInfo.Type} do
			local unitInfo = GameInfo.Units[row.UnitType]
			lineValue = row.NumUnits
			lineExtra = Locale.ConvertTextKey(unitInfo.Description or unitInfo.Type)
			if unitInfo.MoveRate == "GREAT_PERSON" then
				lineTextKey = "TXT_KEY_BUILDING_EFFECT_FREE_GREAT_PERSON"
			end
			InsertBuildingSubStat()
		end

	elseif lineType == "FreeResources" then
		for row in GameInfo.Building_ResourceQuantity{BuildingType = objectInfo.Type} do
			local resInfo = GameInfo.Resources[row.ResourceType]
			linePrefix = resInfo.IconString or ("ICON:"..resInfo.Type)
			lineValue = row.Quantity
			lineExtra = Locale.ConvertTextKey(resInfo.Description or resInfo.Type)
			InsertBuildingSubStat()
		end

	elseif lineType == "RequiresNearAll" then
		lineValue = ""
		for row in GameInfo.Building_LocalResourceAnds{BuildingType = objectInfo.Type} do
			lineValue = lineValue .. (GameInfo.Resources[row.ResourceType].IconString or ("ICON:"..GameInfo.Resources[row.ResourceType].Type))
		end
		InsertBuildingSubStat()

	elseif lineType == "RequiresNearAny" then
		lineValue = ""
		for row in GameInfo.Building_LocalResourceOrs{BuildingType = objectInfo.Type} do
			lineValue = lineValue .. (GameInfo.Resources[row.ResourceType].IconString or ("ICON:"..GameInfo.Resources[row.ResourceType].Type))
		end
		InsertBuildingSubStat()

	elseif lineType == "RequiresResourceConsumption" then
		lineValue = ""
		for row in GameInfo.Building_ResourceQuantityRequirements{BuildingType = objectInfo.Type} do
			lineValue = string.format("%s%s%s ", lineValue, row.Cost, GameInfo.Resources[row.ResourceType].IconString or ("ICON:"..GameInfo.Resources[row.ResourceType].Type))
		end
		InsertBuildingSubStat()
		
	elseif lineType == "NotFeature" then
		lineValue = string.format("{%s}", GameInfo.Features[lineValue].Description or GameInfo.Features[lineValue].Type)
		InsertBuildingSubStat()
		
	elseif lineType == "NearbyTerrainRequired" or lineType == "ProhibitedCityTerrain" then
		lineValue = string.format("{%s}", GameInfo.Terrains[lineValue].Description or GameInfo.Terrains[lineValue].Type)
		InsertBuildingSubStat()

	elseif lineType == "RequiresTech" then
		for row in GameInfo.Building_TechAndPrereqs{BuildingType = objectInfo.Type} do
			lineValue = string.format("{%s}", GameInfo.Technologies[row.TechType].Description or GameInfo.Technologies[row.TechType].Type)
			InsertBuildingSubStat()
		end

	elseif lineType == "RequiresBuilding" then
		for row in GameInfo.Building_ClassesNeededInCity{BuildingType = objectInfo.Type} do
			local uniqueID = activePlayer:GetUniqueBuildingID(row.BuildingClassType)
			lineValue = string.format("{%s}", GameInfo.Buildings[uniqueID].Description or GameInfo.Buildings[uniqueID].Type)
			InsertBuildingSubStat()
		end

	elseif lineType == "RequiresBuildingInCities" then
		for row in GameInfo.Building_PrereqBuildingClasses{BuildingType = objectInfo.Type} do
			local uniqueID = activePlayer:GetUniqueBuildingID(row.BuildingClassType)
			lineValue = string.format("{%s}", GameInfo.Buildings[uniqueID].Description or GameInfo.Buildings[uniqueID].Type)
			if row.NumBuildingNeeded == -1 then
				lineExtra = Locale.ConvertTextKey("TXT_KEY_SV_ICONS_ALL")
			else
				lineExtra = row.NumBuildingNeeded
			end
			InsertBuildingSubStat()
		end

	elseif lineType == "RequiresBuildingInPercentCities" then
		for row in GameInfo.Building_PrereqBuildingClasses{BuildingType = objectInfo.Type} do
			local uniqueID = activePlayer:GetUniqueBuildingID(row.BuildingClassType)
			lineValue = string.format("{%s}", GameInfo.Buildings[uniqueID].Description or GameInfo.Buildings[uniqueID].Type)
			if row.PercentBuildingNeeded == -1 then
				lineExtra = Locale.ConvertTextKey("TXT_KEY_SV_ICONS_ALL")
			else
				lineExtra = row.PercentBuildingNeeded
			end
			InsertBuildingSubStat()
		end
		
	else
		-- ** DEFAULT STRING HANDLING ** --
		InsertBuildingSubStat()
	end
	
	return subStats
end
	
Game.GetDefaultPromotionStatText = Game.GetDefaultPromotionStatText or function(objectID, statType, statSection, sPriority, statValue, statAttack, statDefense, statOpposite, unit)
	if not objectID or not statType then
		log:Fatal("Game.GetDefaultPromotionStatText objectID=%s statType=%s statValue=%s statPriority=%s", objectID, statType, statValue, sPriority)
	end
	if not statValue or statValue == 0 or statValue == "" then
		return {}
	end
	
	lineType			= statType
	objectInfo			= GameInfo.UnitPromotions[objectID]
	objectClassInfo		= GameInfo.PromotionClasses[objectInfo.Class]
	activePlayer		= Players[Game.GetActivePlayer()]
	activeTeam			= Teams[Game.GetActiveTeam()]
	statTextKey			= "TXT_KEY_PROMOTION_EFFECT" .. string.upper( string.gsub(lineType, '(%u)',  function(x) return "_"..x end) )
	statPriority		= sPriority
	lineTextKey			= statTextKey
	lineSection			= statSection or 14
	linePriority		= statPriority
	linePrefix			= TipSectionIcon[lineSection] or "[ICON_BULLET]"
	lineSign			= ""
	lineValue			= statValue
	lineExtra			= ""	
	subStats			= {}
	
	if type(lineValue) == "number" then
		lineValue = ToDecimal(lineValue)
		lineSign = GetSign(lineValue)
	end
	
	
	if lineType == "Name" then
		
	else
		-- ** DEFAULT STRING HANDLING ** --
		InsertPromoSubStat()
	end
	
	return subStats
end

--
-- Private Helper Methods
--


function ToDecimal(value)
	return (value % 1) and value or Locale.ToNumber(value, "#.#")
end

function GetSign(value)
	return value > 0 and "+" or ""
end

function InsertPromoSubStat()
	if type(lineValue) == "function" then
		-- not handled by a specific if-else clause, so use default behavior
		lineValue = objectInfo[lineType]
		--log:Warn("InsertPromoSubStat %s value is an unhandled function!", lineType)
	end
	if not lineValue or lineValue == 0 or lineValue == -1 or lineValue == "" then
		return
	end
	local text = ModLocale.ConvertTextKey(lineTextKey, linePrefix, lineSign, lineValue, lineExtra)
	if text == lineTextKey then
		-- no text key, so use fallback
		text = string.gsub(lineType, '(%u)',  function(x) return " "..x end)
		if type(lineValue) == "boolean" then
			text = string.format("%s %s", linePrefix, text)
		else
			text = string.format("%s %s: %s", linePrefix, text, lineValue)
		end
		text = string.gsub(text, '  ', ' ')
	end
	table.insert(subStats, {Type=lineType, Section=lineSection, Priority=linePriority, TextBody=text})
end

function InsertBuildingSubStat(yieldInfo)
	if yieldInfo then
		linePrefix		= string.format("%s {%s}", yieldInfo.IconString or ("ICON:"..yieldInfo.Type), yieldInfo.Description or yieldInfo.Type)
		linePriority	= statPriority + (100 * yieldInfo.ListPriority)
		lineValue		= objectInfo[lineType]
	end
	if type(lineValue) == "function" then
		-- not handled by a specific if-else clause, so use fallback
		lineValue = objectInfo[lineType]
		--log:Warn("InsertBuildingSubStat %30s value is an unhandled function!", lineType)
		--return
	end
	if not lineValue or lineValue == 0 or lineValue == -1 or lineValue == "" then
		return
	end
	local text = ModLocale.ConvertTextKey(lineTextKey, linePrefix, lineSign, lineValue, lineExtra)
	if text == lineTextKey then
		-- no text key, so use fallback
		text = string.gsub(lineType, '(%u)',  function(x) return " "..x end)
		if type(lineValue) == "boolean" then
			text = string.format("%s %s", linePrefix, text)
		else
			text = string.format("%s %s: %s", linePrefix, text, lineValue)
		end
		text = string.gsub(text, '  ', ' ')
	end
	table.insert(subStats, {Type=lineType, Section=lineSection, Priority=linePriority, TextBody=text, TextFoot=statFoot})
end

function ConvertYieldList(statType, statSection, statPriority, lineTextKey, yieldList)
	local subStats = {}
	for yieldType, yieldData in pairs(yieldList) do
		local yieldInfo = GameInfo.Yields[yieldType]
		if not yieldInfo then
			log:Error("ConvertYieldList statType=%s : %s is not a valid yieldType", statType, yieldType)
			return errorMsg
		end
		local linePrefix = string.format("%s {%s}", yieldInfo.IconString or ("ICON:"..yieldInfo.Type), yieldInfo.Description or yieldInfo.Type)
		local linePriority = statPriority + (100 * yieldInfo.ListPriority)
		if type(yieldData) == "table" then
			for yieldValue, objectString in pairs(yieldData) do
				table.insert(subStats, {
					Type=statType, Section=statSection, Priority=linePriority,
					TextBody = Locale.ConvertTextKey(lineTextKey, linePrefix, GetSign(yieldValue), ToDecimal(yieldValue), string.gsub(objectString, ", $", ""))
				})
			end
		else
			table.insert(subStats, {
				Type=statType, Section=statSection, Priority=linePriority,
				TextBody = Locale.ConvertTextKey(lineTextKey, linePrefix, GetSign(yieldData), ToDecimal(yieldData))
			})
		end
	end
	return subStats
end

function GetYieldInfo(info)
	--[[
	
	This function uses several optional parameters.
	
	Type	Parameter		Default Value	  Description
	-------------------------------------------------------------
	string	table							: Name of the table to scan
	string	yieldType		"YieldType" 	: The type of yield we give
	string	yield			"Yield" 		: The yield amount
	string	tableReference	nil				: The yield is given for something in another table, like a yield bonus for a specific terrain or resource type
	string	cellReference	nil				: Type to search for in the other table
	string	typeReference	nil				: Some tables do not store the type to search for in its table data, so we must manually give that information.
	boolean div100			false			: Divide "yield" by 100 to get the real value
	
	--]]
	
	--[[ Usage example:
	
	Data:
	<Building_UnitCombatProductionModifiers>
		<Row>
			<BuildingType>BUILDING_DUCAL_STABLE</BuildingType>
			<UnitCombatType>UNITCOMBAT_MOUNTED</UnitCombatType>
			<Modifier>15</Modifier>
		</Row>
	</Building_UnitCombatProductionModifiers>
	
	Code to read the data:
	elseif lineType == "YieldModCombat" then
		return GetYieldInfo{
			table="Building_UnitCombatProductionModifiers", -- Name of the table to scan
			yield="Modifier",								-- The yield amount, normally called "Yield", but called "Modifier" in this table
			tableReference="UnitCombatInfos",				-- The yield gets modified for a specific unit combat type.
			cellReference="UnitCombatType",					-- Search for the UnitCombatType ("UNITCOMBAT_MOUNTED") in the UnitCombatInfos table
			yieldType="YIELD_PRODUCTION"					-- Most tables specify a YieldType, but this table can only modify Production.
															   The table does not give this information, so we must specify the yield type ourselves.
		}
		
	--]]


	-- Error checking
	if not GameInfo[info.table] then
		log:Error("GetDefaultBuildingStatText lineType=%s : GameInfo.%s does not exist", lineType, info.table)
		return errorMsg
	elseif info.tableReference and not GameInfo[info.tableReference] then
		log:Error("GetDefaultBuildingStatText lineType=%s : GameInfo.%s does not exist", lineType, info.tableReference)
		return errorMsg
	end
	
	-- Main loop
	local yieldList = {}		
	for row in GameInfo[info.table]{BuildingType = objectInfo.Type} do
		-- More error checking
		if info.yield and not row[info.yield or "Yield"] then
			log:Fatal("GetDefaultBuildingStatText lineType=%s : column %s does not exist in GameInfo.%s", lineType, info.yield, info.table)
			return errorMsg
		end
		if not (info.yieldType or row[info.cellYieldType or "YieldType"]) then
			log:Fatal("GetDefaultBuildingStatText lineType=%s : column %s does not exist in GameInfo.%s", lineType, "YieldType", info.table)
			return errorMsg
		end
		if info.cellReference then
			if not row[info.cellReference] then
				log:Fatal("GetDefaultBuildingStatText lineType=%s : column %s does not exist in GameInfo.%s", lineType, info.cellReference, info.table)
				return errorMsg
			end
			info.typeReference = row[info.cellReference]
		end				
		if info.cellReference and not GameInfo[info.tableReference][info.typeReference] then
			log:Fatal("GetDefaultBuildingStatText lineType=%s : GameInfo.%s.%s does not exist", lineType, info.table, info.typeReference)
			return errorMsg
			--[[
		elseif info.cellReference and not GameInfo[info.tableReference][info.typeReference].Description then
			log:Fatal("GetDefaultBuildingStatText lineType=%s : GameInfo.%s.%s.Description is null", lineType, info.table, info.typeReference)
			return errorMsg
			--]]
		end
		
		-- Main data
		local yieldType = info.yieldType or row[info.cellYieldType or "YieldType"]
		local yield = row[info.yield or "Yield"]
		if not yieldList[yieldType] then yieldList[yieldType] = {} end		
		
		if info.tableReference then
			yieldList[yieldType][yield] = (yieldList[yieldType][yield] or "") .. Locale.ConvertTextKey(GameInfo[info.tableReference][info.typeReference].Description or GameInfo[info.tableReference][info.typeReference].Type) .. ", "
		else
			yieldList[yieldType] = info.div100 and yield/100 or yield
		end
	end
	return ConvertYieldList(lineType, lineSection, linePriority, lineTextKey, yieldList)
end


--
-- Read Data
--

--print(string.format("%3s ms loading InfoTooltipInclude.lua building stat functions", Game.Round(os.clock() - buildingStatStartTime, 8)))
local buildingStatStartTime = os.clock()

cepObjectInfo = nil
cepClassInfo = nil
--if not Game.InitializedStats then
	Game.InitializedStats = true
	Game.Stats.Buildings = {}
	for objectInfo in GameInfo.Buildings() do
		local objectID = objectInfo.ID
		cepObjectInfo = objectInfo
		cepClassInfo = GameInfo.BuildingClasses[objectInfo.BuildingClass]
		Game.Stats.Buildings[objectID] = {}
		for row in GameInfo.BuildingStats() do
			if row.Value then
				local stat = {
					Type 		= row.Type,
					Section 	= row.Section,
					Priority 	= row.Priority,
					Dynamic 	= (row.Dynamic == 1),
					Value 		= assert(loadstring("return " .. row.Value))()
				}
				if stat.Value and stat.Value ~= 0 and stat.Value ~= -1 and stat.Value ~= "" then
					if stat.Dynamic then
						table.insert(Game.Stats.Buildings[objectID], stat)
					else
						for _, subStat in pairs(Game.GetDefaultBuildingStatText(objectID, stat.Type, stat.Section, stat.Priority, stat.Value)) do
							if subStat.Section and subStat.Priority and subStat.TextBody then
								table.insert(Game.Stats.Buildings[objectID], {
									Type 		= stat.Type,
									Section 	= subStat.Section,
									Priority 	= subStat.Priority,
									TextBody 	= subStat.TextBody,
									TextFoot 	= subStat.TextFoot})
							else
								log:Error("Init Stats %25s %20s %20s section=%3s priority=%3s textBody=%s",
									objectInfo.Type,
									stat.Type,
									subStat.Type,
									subStat.Section,
									subStat.Priority,
									subStat.TextBody
								)
							end
						end
					end
				end
			else
				log:Error("cepObjectInfo %s value is nil!", row.Type)
			end
		end
	end
	Game.Stats.Promotions = {}
	for objectInfo in GameInfo.UnitPromotions() do
		local objectID = objectInfo.ID
		cepObjectInfo = objectInfo
		cepClassInfo = GameInfo.PromotionClasses[objectInfo.Class]
		Game.Stats.Promotions[objectID] = {}
		for row in GameInfo.PromotionStats() do
			if not row.Value then
				log:Error("cepObjectInfo %s value is nil!", row.Type)
			else
				local stat = {
					Type		= row.Type,
					Section		= row.Section, 
					Priority	= row.Priority, 
					Dynamic		= (row.Dynamic == 1), 
					Attack		= row.Attack, 
					Defense		= row.Defense, 
					Opposite	= row.Opposite, 
					Value		= assert(loadstring("return " .. row.Value))()
				}
				if stat.Value and stat.Value ~= 0 and stat.Value ~= -1 and stat.Value ~= "" then
					if stat.Dynamic then
						table.insert(Game.Stats.Promotions[objectID], stat)
					else
						for _, subStat in pairs(Game.GetDefaultPromotionStatText(objectID, stat.Type, stat.Section, stat.Priority, stat.Value)) do
							if subStat.Section and subStat.Priority and subStat.TextBody then
								table.insert(Game.Stats.Promotions[objectID], {
								Type		= stat.Type,
								Section		= subStat.Section,
								Priority	= subStat.Priority,
								Attack		= subStat.Attack,
								Defense		= subStat.Defense,
								Opposite	= subStat.Opposite,
								TextBody	= subStat.TextBody,
								TextFoot	= subStat.TextFoot})
							else
								log:Error("Init Stats %25s %20s %20s section=%3s priority=%3s attack=%3s defense=%3s opposite=%3s textBody=%s",
									objectInfo.Type,
									stat.Type,
									subStat.Type,
									subStat.Section, 
									subStat.Priority,
									subStat.Attack,
									subStat.Defense,
									subStat.Opposite,
									subStat.TextBody
								)
							end
						end
					end
				end
			end
		end
		if Game.Stats.Promotions[objectID] == {} then
			table.insert(Game.Stats.Promotions[objectID], {
			Type		= "Other",
			Section		= 14,
			Priority	= 999,
			Attack		= false,
			Defense		= false,
			Opposite	= false,
			TextBody	= objectInfo.Type,
			TextFoot	= false})
		end
	end
--end

local endTime = math.floor((os.clock() - buildingStatStartTime) * 1000)
if endTime > 100 then
	print(string.format("%s ms loading Game.Stats", endTime))
end

--]==]



-------------------------------------------------
-- Completed initialization of Game.Stats
-------------------------------------------------

--log:Info("Completed initialization of Game.Stats")


