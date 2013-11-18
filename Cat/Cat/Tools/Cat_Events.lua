-- BC - General.lua
-- Author: Thalassicus
-- DateCreated: 10/29/2010 12:44:28 AM
--------------------------------------------------------------

include("MT_Events.lua")
include("YieldLibrary.lua")
--include("CustomNotification.lua")

local log = Events.LuaLogger:New()
log:SetLevel("WARN")

--local store = Events.SavegameData:New()
--store:SetModName("Cep")

--LuaEvents.NotificationAddin({name = "CSUnitReward", type = "CNOTIFICATION_CSUnitReward"})
--LuaEvents.NotificationAddin({name = "CapturedCityLoot", type = "CNOTIFICATION_CAPTURED_CITY_LOOT"})
--LuaEvents.NotificationAddin({name = "CityGrowth", type = "CNOTIFICATION_CITY_GROWTH"})


function CustomNotification(name, tip, text)
	log:Warn("CustomNotification name='%s' tip='%s' text='%s'", name, tip, text)
	Events.GameplayAlertMessage(text)
end

if not UI:IsLoadedGame() then
	OptionsManager.SetTooltip1Seconds_Cached(0)
	for optionInfo in GameInfo.GameOptions() do
		if optionInfo.Reverse then
			Game.SetOption(optionInfo.ID, not Game.IsOption(optionInfo.ID))
			log:Info("%30s: %s", optionInfo.Type, Game.IsOption(optionInfo.ID))
		end
	end
end

---------------------------------------------------------------------
---------------------------------------------------------------------

function GiveCSNewYields(player)
	local playerID = player:GetID()
	local capitalCity = player:GetCapitalCity()
	local yieldType = nil
	local yieldRate = 0
	if (Cep.MINOR_CIV_MILITARISTIC_REWARD_NEEDED == 0
		or player:GetNumCities() == 0
		or player:IsMinorCiv()
		or player:IsBarbarian()
		or capitalCity == nil
		) then
		return
	end
	
	
	yieldType = YieldTypes.YIELD_CS_MILITARY
	yieldRate = player:GetYieldRate(yieldType)	
	if yieldRate ~= 0 then
		local yieldStored = player:GetYieldStored(yieldType)
		local yieldNeeded = player:GetYieldNeeded(yieldType)
		if yieldStored == nil or yieldRate == nil then
			log:Error("GiveCSNewYields yieldStored=%s yieldRate=%s", yieldStored, yieldRate)
			return
		end
		yieldStored = yieldStored + yieldRate
		--log:Debug("%25s %15s current=%i threshold=%i rate=%i", "GiveCSNewYields", player:GetName(), yieldStored, yieldNeeded, yieldRate)
		if yieldStored >= yieldNeeded then
			yieldStored = yieldStored - yieldNeeded
			--log:Debug("%25s %15s current=%i", " ", " ", yieldStored)
			local availableIDs	= City_GetBuildableUnitIDs(capitalCity)
			local newUnitID		= availableIDs[1 + Map.Rand(#availableIDs, "InitUnitFromList")]
			local capitalPlot	= capitalCity:Plot()
			local xp			= 0
			if player:IsHuman() or player:IsAtWarWithHuman() or player:IsMilitaristicLeader() then
				xp = player:GetCitystateYields(MinorCivTraitTypes.MINOR_CIV_TRAIT_MILITARISTIC, 2)[YieldTypes.YIELD_EXPERIENCE]
			end

			if GameInfo.Units[newUnitID].Domain ~= "DOMAIN_LAND" then
				xp = xp * Cep.MINOR_CIV_MILITARISTIC_XP_NONLAND_PENALTY
			end

			--log:Debug("  Reward=%s  XP=%s", GameInfo.Units[newUnitID].Type, xp)
			local newUnit = player:InitUnitType(newUnitID, capitalPlot, xp)

			local promotion = player:GetTraitInfo().MilitaristicCSFreePromotion

			if promotion then
				newUnit:SetHasPromotion(GameInfo.UnitPromotions[promotion].ID, true)
			end
			

			local newUnitInfo = GameInfo.Units[newUnitID]
			if Game.GetActivePlayer() == player:GetID() then
				local newUnitIcon = {{"Unit1", newUnitID, 0, 0, 0}}
				local newUnitName = Locale.ConvertTextKey(newUnitInfo.Description)
				CustomNotification(
					"CSUnitReward",
					"New "..newUnitName,
					"A new "..newUnitName.." arrived in your [ICON_CAPITAL] Capital from your militaristic [ICON_CITY_STATE] City-State allies.",
					capitalPlot,
					0,
					0,
					newUnitIcon
				)
			end
		end
		player:SetYieldStored(yieldType, yieldStored)
	end
	
	yieldType = YieldTypes.YIELD_CS_GREAT_PEOPLE
	yieldRate = player:GetYieldRate(yieldType)
	if yieldRate ~= 0 then
		local yieldStored = player:GetYieldStored(yieldType) + yieldRate
		local yieldNeeded = player:GetYieldNeeded(yieldType)
		--log:Debug("%25s %15s current=%i threshold=%i rate=%i", "GiveCSNewYields", player:GetName(), yieldStored, yieldNeeded, yieldRate)
		if yieldStored >= yieldNeeded then
			yieldStored = yieldStored - yieldNeeded
			player:SetYieldNeeded(yieldType, yieldNeeded + GameDefines.GREAT_PERSON_THRESHOLD_INCREASE)
			--log:Debug("%25s %15s current=%i", " ", " ", yieldStored)
			local availableIDs	= {}
			for unitInfo in GameInfo.Units("Special = 'SPECIALUNIT_PEOPLE' AND (CombatClass LIKE '%UNITCOMBAT_CIVILIAN') AND (Type <> 'UNIT_PROPHET')") do
				--log:Debug("%20s CombatClass=%15s ID=%3s UniqueID=%3s", unitInfo.Type, unitInfo.CombatClass, unitInfo.ID, player:GetUniqueUnitID(unitInfo.Class))
				if unitInfo.ID == player:GetUniqueUnitID(unitInfo.Class) then
					table.insert(availableIDs, unitInfo.ID)
				end
			end

			local newUnitID		= availableIDs[1 + Map.Rand(#availableIDs, "InitUnitFromList")]
			local capitalPlot	= capitalCity:Plot()
			local newUnit		= player:InitUnitType(newUnitID, capitalPlot)
			local newUnitInfo	= GameInfo.Units[newUnitID]
			if Game.GetActivePlayer() == player:GetID() then
				local newUnitIcon = {{"Unit1", newUnitID, 0, 0, 0}}
				local newUnitName = Locale.ConvertTextKey(newUnitInfo.Description)
				CustomNotification(
					"CSUnitReward",
					"New "..newUnitName,
					"A new "..newUnitName.." arrived in your [ICON_CAPITAL] Capital from your [ICON_CITY_STATE] City-State allies.",
					capitalPlot,
					0,
					0,
					newUnitIcon
				)
			end
		end
		player:SetYieldStored(yieldType, yieldStored)
	end
end
LuaEvents.ActivePlayerTurnStart_Player.Add(GiveCSNewYields)

---------------------------------------------------------------------
---------------------------------------------------------------------

--[[
function UpdatePuppetOccupyStatus(city, player, isForced)
	if not player then 
		player = Players[city:GetOwner()]
	end
	
	if isForced then
		log:Info("UpdatePuppetOccupyStatus %15s's %15s isForced=%s", player:GetName(), city:GetName(), isForced)
	end
	
	local courthouseID		= player:GetUniqueBuildingID("BUILDINGCLASS_COURTHOUSE")
	local canCourthouseID	= GameInfo.Buildings.BUILDING_CAN_BUILD_COURTHOUSE.ID
	local governorID		= GameInfo.Buildings.BUILDING_VICEROY.ID
	local happinessModID	= GameInfo.Buildings.BUILDING_PUPPET_MODIFIER.ID
	local isOccupied		= (isForced == "OCCUPY") or (city:IsOccupied() and not isForced)
	local isPuppet			= (isForced == "PUPPET") or (city:IsPuppet() and not isForced)

	if isPuppet or isOccupied then
		if city:IsHasBuilding(courthouseID) then
			isPuppet		= false
			isOccupied		= false
			city:SetPuppet(false)
			city:SetOccupied(false)	
			log:Info("Courthouse is in %s %s", player:GetName(), city:GetName())	
		else
			city:SetNumRealBuilding(governorID, 1)
		end
	elseif city:IsHasBuilding(governorID) then
		city:SetNumRealBuilding(governorID, 0)
	end
	
	if player:IsHuman() then
		if isOccupied and not city:IsHasBuilding(canCourthouseID) then
			city:SetNumRealBuilding(canCourthouseID, 1)
		elseif not isOccupied and city:IsHasBuilding(canCourthouseID) then
			city:SetNumRealBuilding(canCourthouseID, 0)
		end
	else
		if isPuppet then
			city:SetNumRealBuilding(canCourthouseID, 1)
		elseif city:IsHasBuilding(canCourthouseID) then
			city:SetNumRealBuilding(canCourthouseID, 0)
		end
	end
	
	if isPuppet then
		city:SetNumRealBuilding(happinessModID, 1)--Game.Round(city:GetPopulation() * Cep.PUPPET_UNHAPPINESS_MOD / 100))
	elseif city:IsHasBuilding(happinessModID) then
		city:SetNumRealBuilding(happinessModID, 0)
	end

end

LuaEvents.ActivePlayerTurnStart_City.Add( UpdatePuppetOccupyStatus )
LuaEvents.CityOccupied.Add( UpdatePuppetOccupyStatus )
LuaEvents.CityPuppeted.Add( UpdatePuppetOccupyStatus )
--]]

--[[
function FixGameCoreCaptureBug(hexPos, lostPlayerID, cityID, wonPlayerID)
	print("FixGameCoreCaptureBug")
	-- workaround for game core bug 
	local plot = Map.GetPlot(ToGridFromHex(hexPos.x, hexPos.y))
	local city = plot:GetPlotCity()
	if city then
		log:Warn("%s wonPlayerID=%s original=%s", city:GetName(), wonPlayerID, city:GetOriginalOwner())
		if wonPlayerID ~= city:GetOriginalOwner() then
			city:SetPuppet(true)
			city:SetOccupied(false)
			city:ChooseProduction()
			log:Warn("Set %s to puppet", city:GetName())
		end
	else
		log:Error("FixGameCoreCaptureBug: plot #%s is not a city?", Plot_GetID(plot))
	end	
end
Events.SerialEventCityCaptured.Add(FixGameCoreCaptureBug)
--]]

---------------------------------------------------------------------
---------------------------------------------------------------------

--[[
function DestroyCourthouseInCapturedCity(city, player, isForced)
	City_SetNumBuildingClass(city, "BUILDINGCLASS_COURTHOUSE", 0)
end

LuaEvents.CityOccupied.Add( DestroyCourthouseInCapturedCity )
LuaEvents.CityPuppeted.Add( DestroyCourthouseInCapturedCity )
--]]

---------------------------------------------------------------------
---------------------------------------------------------------------

function LiberatedMinor(city, minorCiv, isForced)
	if not minorCiv then 
		minorCiv = Players[city:GetOwner()]
	end
	if not minorCiv:IsMinorCiv() then
		return
	end
		
	local minorTeam = Teams[minorCiv:GetTeam()]
	for majorCivID,majorCiv in pairs(Players) do
		if majorCiv:IsAliveCiv() and not majorCiv:IsMinorCiv() and (majorCivID ~= Game.GetActivePlayer()) and (minorCiv:GetMinorCivFriendshipWithMajor(majorCivID) > Cep.MINOR_CIV_LIBERATED_FRIENDSHIP_MAX) then
			minorCiv:SetFriendship(majorCivID, Cep.MINOR_CIV_LIBERATED_FRIENDSHIP_MAX)
		end
	end
end

LuaEvents.CityLiberated(city, player, isForced)

---------------------------------------------------------------------
---------------------------------------------------------------------

function BuildingCreated(player, city, buildingID)
	local playerID		= player:GetID()
	local plot			= city:Plot()

	local buildingInfo	= GameInfo.Buildings[buildingID]
	local query			= ""
	local trait			= player:GetTraitInfo()
	
	--[[
	local improvementType = buildingInfo.MountainImprovement
	if improvementType then
		local mountainPlot = Plot_FindPlotType(plot)
		mountainPlot:SetOwner(playerID, city:GetID())
		mountainPlot:SetImprovementType(GameInfo.Improvements[improvementType].ID)
	end
	--]]

	local endOccupy = buildingInfo.NoOccupiedUnhappinessFixed
	if endOccupy then
		city:SetPuppet(false)
		city:SetOccupied(false)
		log:Info("Courthouse built in %s %s", player:GetName(), city:GetName())
	end
	
	query = string.format("ID = '%s' AND InstantHappiness != 0", buildingID)
	for info in GameInfo.Buildings(query) do
		player:ChangeYieldStored(YieldTypes.YIELD_HAPPINESS_NATIONAL, info.InstantHappiness)
	end
	
	query = string.format("BuildingType = '%s'", buildingInfo.Type)
	for info in GameInfo.Building_YieldInstant(query) do
		City_ChangeYieldStored(city, GameInfo.Yields[info.YieldType].ID, info.Yield)
	end

	local borderExpand = buildingInfo.InstantBorderRadius
	if borderExpand ~= 0 then
		for adjPlot in Plot_GetPlotsInCircle(plot, 1, borderExpand) do
			if adjPlot:GetOwner() == -1 then
				adjPlot:SetOwner(playerID, city:GetID())
			end
		end
	end

	local borderExpandAll = buildingInfo.GlobalInstantBorderRadius
	if borderExpandAll ~= 0 then
		for targetCity in player:Cities() do
			for adjPlot in Plot_GetPlotsInCircle(targetCity:Plot(), 1, borderExpandAll) do
				if adjPlot:GetOwner() == -1 then
					adjPlot:SetOwner(playerID, targetCity:GetID())
				end
			end
		end
	end

	local influence = buildingInfo.MinorFriendshipFlatChange
	if influence ~= 0 then
		local playerTeam = Teams[player:GetTeam()]
		--log:Debug("%s CS Friendship: +%s", player:GetName(), buildingInfo.MinorFriendshipFlatChange)
		for minorCivID,minorCiv in pairs(Players) do
			local minorTeamID = minorCiv:GetTeam()
			if minorCiv:IsAliveCiv() and minorCiv:IsMinorCiv() and playerTeam:IsHasMet(minorTeamID) and not playerTeam:IsAtWar(minorTeamID) then
				minorCiv:ChangeMinorCivFriendshipWithMajor(playerID, influence)
			end
		end
	end

	local promotion = buildingInfo.FreePromotionAllCombatUnits
	if promotion then
		local promotionID = GameInfo.UnitPromotions[promotion].ID
		for unit in player:Units() do
			if unit and (not unit:IsDead()) and unit:IsCombatUnit() then
				unit:SetHasPromotion(promotionID, true)
			end
		end
	end
	
	query = string.format("BuildingType = '%s'", buildingInfo.Type)
	for info in GameInfo.Building_NearestPlotYieldChanges(query) do
		local targetPlot = Plot_FindPlotType(plot, info.PlotType)
		targetPlot:SetOwner(playerID, city:GetID())
		Plot_ChangeYield(targetPlot, GameInfo.Yields[info.YieldType].ID, info.Yield)
	end
	
	query = string.format("BuildingType = '%s'", buildingInfo.Type)
	for info in GameInfo.Building_PlotYieldChanges(query) do
		    for adjPlot in Plot_GetPlotsInCircle(plot, 0, 3) do
			local adjPlotID = Plot_GetID(adjPlot)
			if adjPlot:GetPlotType() == PlotTypes.PLOT_HILLS and (adjPlot:GetOwner() == playerID or adjPlot:GetOwner() == -1) then
				if adjPlot:GetOwner() == -1 then
					adjPlot:SetOwner(playerID, city:GetID())
				end
				Plot_ChangeYield(adjPlot, GameInfo.Yields[info.YieldType].ID, info.Yield)
			end
		end
	end
	
	--[[
	query = string.format("BuildingType = '%s' AND YieldType = 'YIELD_CULTURE'", buildingInfo.Type)
	if Game.HasValue( {BuildingType=buildingInfo.Type, YieldType='YIELD_CULTURE'}, GameInfo.Building_SeaPlotYieldChanges ) then
		local nearbyPlots = Plot_GetPlotsInCircle(plot, 1, 3)
		for _,adjPlot in pairs(nearbyPlots) do
			local adjPlotID = Plot_GetID(adjPlot)
			if adjPlot:GetOwner() == playerID and not MapModData.Cep_HasTerrainCulture[adjPlotID][buildingInfo.Type] then
				for row in GameInfo.Building_ResourceYieldChanges(query) do
					Plot_ChangeYield(adjPlot, YieldTypes.YIELD_CULTURE, row.Yield)
					MapModData.Cep_HasTerrainCulture[adjPlotID][row.BuildingType] = true
					SaveValue(true, "MapModData.Cep_HasTerrainCulture[%s][%s]", adjPlotID, row.BuildingType)
				end
			end
		end
	end

	query = string.format("BuildingType = '%s' AND YieldType = 'YIELD_CULTURE'", buildingInfo.Type)
	if Game.HasValue( {BuildingType=buildingInfo.Type, YieldType='YIELD_CULTURE'}, GameInfo.Building_ResourceYieldChanges ) then
		--log:Debug("ResourceYieldChanges %15s", buildingInfo.Type)
		local nearbyPlots = Plot_GetPlotsInCircle(plot, 1, 3)
		for _,adjPlot in pairs(nearbyPlots) do
			local adjPlotID = Plot_GetID(adjPlot)
			local adjResource = adjPlot:GetResourceType(-1)
			if adjResource ~= -1 and adjPlot:GetOwner() == playerID and not MapModData.Cep_HasResourceCulture[adjPlotID][buildingInfo.Type] then
				adjResource = GameInfo.Resources[adjResource].Type
				for row in GameInfo.Building_ResourceYieldChanges(query) do
					if adjResource == row.ResourceType then
						Plot_ChangeYield(adjPlot, YieldTypes.YIELD_CULTURE, row.Yield)
						MapModData.Cep_HasResourceCulture[adjPlotID][row.BuildingType] = true
						SaveValue(true, "MapModData.Cep_HasResourceCulture[%s][%s]", adjPlotID, row.BuildingType)
					end
				end
			end
		end
	end
	--]]
	
	if city:IsCapital() then
		for row in GameInfo.Trait_YieldFromConstructionInCapital() do
			if trait.Type == row.TraitType and buildingInfo.Type == row.BuildingType then

				if row.Yield ~= 0 then
					player:ChangeYieldStored(GameInfo.Yields[row.YieldType].ID, row.Yield)
					--log:Debug("+%s %s from science building constructed in %s", row.Yield, GameInfo.Yields[row.YieldType].Type, city:GetName())
				end
				if row.YieldMod ~= 0 then
					local prereqTech = buildingInfo.PrereqTech or "TECH_AGRICULTURE"
					local yieldAdded = row.YieldMod/100 * GameInfo.Technologies[prereqTech].Cost * GameInfo.GameSpeeds[Game.GetGameSpeedType()].ResearchPercent/100
					player:ChangeYieldStored(GameInfo.Yields[row.YieldType].ID, yieldAdded)
					--log:Debug("+%s %s from science building constructed in %s", yieldAdded, GameInfo.Yields[row.YieldType].Type, city:GetName())
				end
			end
		end
	end
	
	for row in GameInfo.Trait_YieldFromConstruction() do
		if trait.Type == row.TraitType and buildingInfo.Type == row.BuildingType then
			local yieldInfo = GameInfo.Yields[row.YieldType]
			City_ChangeYieldStored(city, yieldInfo.ID, row.Yield)
			if playerID == Game.GetActivePlayer() then
				Events.GameplayAlertMessage(string.format(
					"%s gained %s %s %s from constructing a %s.",
					city:GetName(),
					row.Yield, 
					yieldInfo.IconString,
					Locale.ConvertTextKey(yieldInfo.Description),
					Locale.ConvertTextKey(buildingInfo.Description)
				))
			end
		end
	end
end

LuaEvents.BuildingConstructed.Add( BuildingCreated )

---------------------------------------------------------------------
---------------------------------------------------------------------

--
MapModData.Cep_HasTerrainCulture = {}
MapModData.Cep_HasResourceCulture = {}
startClockTime = os.clock()
for plotID = 0, Map.GetNumPlots() - 1, 1 do
	MapModData.Cep_HasTerrainCulture [plotID] = {}
	MapModData.Cep_HasResourceCulture[plotID] = {}
	local plot = Map.GetPlotByIndex(plotID)
	if plot:GetOwner() ~= -1 then
		--[[
		for row in GameInfo.Building_SeaPlotYieldChanges ("YieldType = 'YIELD_CULTURE'") do
			MapModData.Cep_HasTerrainCulture[plotID][row.BuildingType] = LoadValue("MapModData.Cep_HasTerrainCulture[%s][%s]", plotID, row.BuildingType)
		end
		for row in GameInfo.Building_ResourceYieldChanges("YieldType = 'YIELD_CULTURE'") do
			MapModData.Cep_HasResourceCulture[plotID][row.BuildingType] = LoadValue("MapModData.Cep_HasResourceCulture[%s][%s]", plotID, row.BuildingType)
		end
		--]]
	end
end
if UI:IsLoadedGame() then
	log:Info("%3s ms loading HasTerrainCulture", Game.Round((os.clock() - startClockTime)*1000))
end
--]]


function OnPlotAcquired(plot, playerID)
	--log:Warn("Plot Acquired")
	local plotID = Plot_GetID(plot)
	local city = plot:GetWorkingCity()
	if city then
		--[[
		for row in GameInfo.Building_SeaPlotYieldChanges("YieldType = 'YIELD_CULTURE'") do
			local buildingID = GameInfo.Buildings[row.BuildingType].ID
			if not MapModData.Cep_HasTerrainCulture[plotID][row.BuildingType] then
				if city:IsHasBuilding(buildingID) then
					--log:Debug("HasTerrainCulture")
					Plot_ChangeYield(plot, YieldTypes.YIELD_CULTURE, row.Yield)
					MapModData.Cep_HasTerrainCulture[plotID][row.BuildingType] = true
					SaveValue(true, "MapModData.Cep_HasTerrainCulture[%s][%s]", plotID, row.BuildingType)
				end
			end
		end
		for row in GameInfo.Building_ResourceYieldChanges("YieldType = 'YIELD_CULTURE'") do
			local buildingID = GameInfo.Buildings[row.BuildingType].ID
			if not MapModData.Cep_HasResourceCulture[plotID][row.BuildingType] then
				if city:IsHasBuilding(buildingID) and (plot:GetResourceType(-1) == GameInfo.Resources[row.ResourceType].ID) then
					--log:Debug("HasResourceCulture")
					Plot_ChangeYield(plot, YieldTypes.YIELD_CULTURE, row.Yield)
					MapModData.Cep_HasResourceCulture[plotID][row.BuildingType] = true
					SaveValue(true, "MapModData.Cep_HasResourceCulture[%s][%s]", plotID, row.BuildingType)
				end
			end
		end
		--]]
	end
end

LuaEvents.PlotAcquired.Add(OnPlotAcquired)

---------------------------------------------------------------------
---------------------------------------------------------------------

function BuildingLost(player, city, buildingID)
	local playerID		= player:GetID()
	local plot			= city:Plot()
	local buildingInfo	= GameInfo.Buildings[buildingID]
	local query			= ""

	local endOccupy = buildingInfo.NoOccupiedUnhappinessFixed
	if endOccupy then
		--city:SetOccupied(true)
	end
	
	
	--[[
	query = string.format("BuildingType = '%s' AND YieldType = 'YIELD_CULTURE'", buildingInfo.Type)
	if Game.HasValue( {BuildingType=buildingInfo.Type, YieldType='YIELD_CULTURE'}, GameInfo.Building_ResourceYieldChanges ) then
		local nearbyPlots = Plot_GetPlotsInCircle(plot, 1, 3)
		for _,adjPlot in pairs(nearbyPlots) do
			local adjPlotID = Plot_GetID(adjPlot)
			local adjResource = adjPlot:GetResourceType(-1)
			if adjResource ~= -1 and adjPlot:GetOwner() == playerID and MapModData.Cep_HasResourceCulture[adjPlotID][buildingInfo.Type] then
				adjResource = GameInfo.Resources[adjResource].Type
				for row in GameInfo.Building_ResourceYieldChanges(query) do
					if adjResource == row.ResourceType then
						Plot_ChangeYield(adjPlot, YieldTypes.YIELD_CULTURE, -row.Yield)
						MapModData.Cep_HasResourceCulture[adjPlotID][row.BuildingType] = false
						SaveValue(true, "MapModData.Cep_HasTerrainHasResourceCultureCulture[%s][%s]", adjPlotID, row.BuildingType)
					end
				end
			end
		end
	end

	query = string.format("BuildingType = '%s' AND YieldType = 'YIELD_CULTURE'", buildingInfo.Type)
	if Game.HasValue( {BuildingType=buildingInfo.Type, YieldType='YIELD_CULTURE'}, GameInfo.Building_SeaPlotYieldChanges ) then
		local nearbyPlots = Plot_GetPlotsInCircle(plot, 1, 3)
		for _,adjPlot in pairs(nearbyPlots) do
			local adjPlotID = Plot_GetID(adjPlot)
			if adjPlot:GetOwner() == playerID and MapModData.Cep_HasTerrainCulture[adjPlotID][buildingInfo.Type] then
				for row in GameInfo.Building_ResourceYieldChanges(query) do
					Plot_ChangeYield(adjPlot, YieldTypes.YIELD_CULTURE, -row.Yield)
					MapModData.Cep_HasTerrainCulture[adjPlotID][row.BuildingType] = false
					SaveValue(true, "MapModData.Cep_HasTerrainCulture[%s][%s]", adjPlotID, row.BuildingType)
				end
			end
		end
	end
	--]]
end

LuaEvents.BuildingDestroyed.Add( BuildingLost )

---------------------------------------------------------------------
---------------------------------------------------------------------

function NewCity(hexPos, playerID, cityID, cultureType, eraType, continent, populationSize, size, fowState)
	local plot		= Map.GetPlot(ToGridFromHex(hexPos.x, hexPos.y))
	local player	= Players[playerID]
	local city		= player:GetCityByID(cityID)
	local query		= ""

	query = "GlobalInstantBorderRadius != 0"
	for buildingInfo in GameInfo.Buildings(query) do
		local borderExpandAll = buildingInfo.GlobalInstantBorderRadius
		if borderExpandAll then
			for testCity in player:Cities() do
				if testCity:IsHasBuilding(buildingInfo.ID) then
					--log:Debug("Detected: %s %s", testCity:GetName(), buildingInfo.Type)
					for adjPlot in Plot_GetPlotsInCircle(plot, 1, borderExpandAll) do
						if adjPlot:GetOwner() == -1 then
							adjPlot:SetOwner(playerID, city:GetID())
						end
					end
					break
				end
			end
		end
	end

	CheckPerTurnPolicyEffects(player)
end

Events.SerialEventCityCreated.Add( NewCity )

---------------------------------------------------------------------
---------------------------------------------------------------------

function UnitCreatedChecks( playerID,
							unitID,
							hexVec,
							unitType,
							cultureType,
							civID,
							primaryColor,
							secondaryColor,
							unitFlagIndex,
							fogState,
							selected,
							military,
							notInvisible )
	local player		= Players[playerID]
	local activePlayer	= Players[Game.GetActivePlayer()]
	local unit			= player:GetUnitByID(unitID)
	local query			= ""

	if player:IsBarbarian() or player:IsMinorCiv() then
		return
	end

	if not unit then
		log:Fatal("UnitCreatedChecks Unit %s for %s is nil!", unitID, player:GetName())
		return
	end

	log:Debug("%25s %20s check for trait bonuses", player:GetName(), unit:GetName())
	local unitInfo	= GameInfo.Units[unit:GetUnitType()]
	local playerTrait = player:GetTraitInfo()

	for traitInfo in GameInfo.Trait_FreePromotionUnitTypes() do
		--log:Trace(traitInfo.TraitType.. " " ..traitInfo.UnitType.. " " ..traitInfo.PromotionType)
		if (traitInfo.TraitType == playerTrait.Type) and (traitInfo.UnitType == unitInfo.Type) then
			unit:SetHasPromotion(GameInfo.UnitPromotions[traitInfo.PromotionType].ID, true)
			--LuaEvents.RefreshUnitFlagPromotions(unit)
		end
	end

	for promoInfo in GameInfo.Technology_DomainPromotion{DomainType = unitInfo.Domain} do
		if player:HasTech(promoInfo.TechType) then
			unit:SetHasPromotion(GameInfo.UnitPromotions[promoInfo.PromotionType].ID, true)
		end
	end

	if not military then
		return
	end

	for traitInfo in GameInfo.Trait_FreeExperience_Domains{DomainType = unitInfo.Domain, TraitType = playerTrait.Type} do
		unit:ChangeExperience(traitInfo.Experience)
	end

	for policyInfo in GameInfo.Policies("GlobalExperience <> 0") do
		if player:HasPolicy(policyInfo.ID) then
			unit:ChangeExperience(policyInfo.GlobalExperience)
		end
	end

	for buildingInfo in GameInfo.Buildings("GlobalExperienceFixed <> 0") do
		if player:HasBuilding(buildingInfo.ID) then
			unit:ChangeExperience(buildingInfo.GlobalExperienceFixed)			
		end
	end

	query = "(FreePromotionAllCombatUnits IS NOT NULL) OR (GlobalExperience != 0)"
	for buildingInfo in GameInfo.Buildings(query) do
		local promo = buildingInfo.FreePromotionAllCombatUnits
		local experience = buildingInfo.GlobalExperience
		for city in player:Cities() do
			if city:IsHasBuilding(buildingInfo.ID) then
				if promo then
					unit:SetHasPromotion(GameInfo.UnitPromotions[promo].ID, true)
					promo = nil
				end
				if experience ~= 0 then
					unit:ChangeExperience(experience)
					experience = 0
				end
			end
			if promo == nil and experience == 0 then
				break
			end
		end
	end
end

LuaEvents.NewUnit.Add(UnitCreatedChecks)

---------------------------------------------------------------------
---------------------------------------------------------------------

function CityCaptureYield(city, yieldType, yieldConstant, yieldPopulation, yieldEra, yieldEraExponent, targetCity)
	log:Info("CityCaptureYield %s", city:GetName())

	local player = Players[city:GetOwner()]
	local baseYield = yieldConstant
		  baseYield = baseYield + city:GetPopulation() * yieldPopulation
		  baseYield = baseYield + yieldEra * (1 + player:GetCurrentEra()) ^ yieldEraExponent
		  baseYield = baseYield * GameInfo.GameSpeeds[Game.GetGameSpeedType()].CulturePercent / 100
		  
	--log:Debug("CityCaptureYield baseYield = %s", baseYield)

	local totalYield = 0
	if targetCity then
		local cityCulture = baseYield * (1 + City_GetBaseYieldRateModifier(targetCity, yieldType)/100)
		totalYield = totalYield + cityCulture
		City_ChangeYieldStored(targetCity, yieldType, cityCulture)
	else
		for targetCity in player:Cities() do
			local cityCulture = baseYield * (1 + City_GetBaseYieldRateModifier(targetCity, yieldType)/100) * City_GetWeight(targetCity, yieldType)/player:GetTotalWeight(yieldType)
			totalYield = totalYield + cityCulture
			City_ChangeYieldStored(targetCity, yieldType, cityCulture)
		end
	end

	--log:Debug("CityCaptureYield totalYield = %s", baseYield)
	
	local yieldInfo = GameInfo.Yields[yieldType]
	local yieldName = Locale.ConvertTextKey(yieldInfo.Description)
	local tooltip = string.format( "%s %s %s looted from capturing %s.",
		Game.Round(totalYield),
		yieldInfo.IconString,
		yieldName,
		city:GetName()
		)
	if player:GetID() == Game.GetActivePlayer() then
		CustomNotification(
			"CapturedCityLoot",
			"Looted " .. yieldName,
			tooltip,
			city:Plot(),
			0,
			0,
			0
		)
	end
end

function DoCityCaptureBonuses(capturedCity, player)	
	log:Info("DoCityCaptureBonuses")
	for policyInfo in GameInfo.Policies("CityCaptureCulture != 0") do
		if player:HasPolicy(policyInfo.ID) then
			CityCaptureYield(capturedCity,
				YieldTypes.YIELD_CULTURE,
				policyInfo.CityCaptureCulture,
				policyInfo.CityCaptureCulturePerPop,
				policyInfo.CityCaptureCulturePerEra,
				policyInfo.CityCaptureCulturePerEraExponent
				)
		end
	end
	for buildingInfo in GameInfo.Buildings("CityCaptureCulture != 0") do
		for targetCity in player:Cities() do
			if targetCity:IsHasBuilding(buildingInfo.ID) then
				CityCaptureYield(capturedCity,
					YieldTypes.YIELD_CULTURE,
					buildingInfo.CityCaptureCulture,
					buildingInfo.CityCaptureCulturePerPop,
					buildingInfo.CityCaptureCulturePerEra,
					buildingInfo.CityCaptureCulturePerEraExponent,
					targetCity
					)
			end
		end
	end
end

LuaEvents.CityCaptureBonuses = LuaEvents.CityCaptureBonuses or function(city) end
LuaEvents.CityCaptureBonuses.Add( DoCityCaptureBonuses )

---------------------------------------------------------------------
---------------------------------------------------------------------

function CheckPerTurnTechEffects(player)
	log:Debug("CheckPerTurnTechEffects %s", player:GetName())	
	for promoInfo in GameInfo.Technology_DomainPromotion() do
		if player:HasTech(promoInfo.TechType) then
			for unit in player:Units() do
				local promoID = GameInfo.UnitPromotions[promoInfo.PromotionType].ID
				if not unit:IsHasPromotion(promoID) and (promoInfo.DomainType == GameInfo.Units[unit:GetUnitType()].Domain) then
					unit:SetHasPromotion(promoID, true)
				end
			end
		end
	end
end
LuaEvents.ActivePlayerTurnStart_Player.Add( CheckPerTurnTechEffects )

---------------------------------------------------------------------
---------------------------------------------------------------------

function DoPolicyEffects(player, policyID)
	if not policyID then
		log:Error("DoPolicyEffects policyID=%s", policyID)
		return nil
	end
	local policyInfo = GameInfo.Policies[policyID]
	log:Info("DoPolicyEffects %s %s", player:GetName(), policyInfo.Type)
	DoPolicyExperience(player, policyInfo)
	DoPolicyBorderObstacle(player, policyInfo)
	DoPolicyInfluence(player, policyInfo)
	DoPolicyFreeUnits(player, policyID)
	DoPolicyFreeBuildingClasses(player, policyID)
	DoPolicyFreeBuildingFlavors(player, policyID)
	DoPolicyInstantYield(player, policyID)
	DoPolicyBuildingUnlocks(player, policyID)
end
LuaEvents.NewPolicy.Add( DoPolicyEffects )

function DoPolicyBuildingUnlocks(player, policyID)
	local policyType = GameInfo.Policies[policyID].Type
	for building in GameInfo.Buildings{PolicyType = policyType} do
		player:SetPolicyBranchUnlocked(GameInfo.PolicyBranchTypes[policyType].ID, true, false)
	end
end

function CheckPerTurnPolicyEffects(player)
	DoPolicyFreeBuildingClasses(player)
	DoPolicyFreeBuildingFlavors(player)
end
LuaEvents.ActivePlayerTurnStart_Player.Add( CheckPerTurnPolicyEffects )
	
function DoPolicyFreeUnits(player, policyID)
	--log:Info("DoPolicyFreeUnits")
	local playerID = player:GetID()
	local city = player:GetCapitalCity()
	
	for row in GameInfo.Policy_FreeUnitFlavor() do
		local policyInfo = GameInfo.Policies[row.PolicyType]
		local flavorType = row.FlavorType
		if policyID == policyInfo.ID then
			local unitsFlavor = City_GetUnitsOfFlavor(city, flavorType)
			for unitID, unitFlavor in pairs(unitsFlavor) do
				unitsFlavor[unitID] = player:GetUnitProductionNeeded(unitID) * unitFlavor
			end
			local itemID, unitFlavor = Game.GetMaximum(unitsFlavor)
			if player:IsHuman() then
				log:Debug("%45s has      %s", player:GetName(), policyInfo.Type)
				log:Debug("%45s best     %s unit: %s", city:GetName(), flavorType, (itemID ~= -1) and GameInfo.Units[itemID].Type or "None Available")
			end		
			if itemID ~= -1 then
				for i=1, row.Count do
					player:InitUnitType(itemID, city:Plot(), City_GetUnitExperience(city, itemID))
					if player:IsHuman() then
						log:Debug("%45s recieved unit", " ", " ")
					end
				end
			end
		end
	end
end
	
function DoPolicyFreeBuildingClasses(player, policyID)
	log:Info("DoPolicyFreeBuildingClasses")
	local playerID = player:GetID()
	local cityList = nil
	for row in GameInfo.Policy_FreeBuildingClass() do
		local testPolicyInfo = GameInfo.Policies[row.PolicyType]
		local numCities = row.NumCities
		if (policyID == testPolicyInfo.ID) or player:HasPolicy(testPolicyInfo.ID) then
			if player:IsHuman() then
				log:Debug("%45s has      %s", player:GetName(), testPolicyInfo.Type)
			end
			local buildingID = player:GetUniqueBuildingID(row.BuildingClass)
			if not MapModData.Cep_PlayerFreeBuildings.Buildings[playerID][buildingID] then
				MapModData.Cep_PlayerFreeBuildings.Buildings[playerID][buildingID] = 0
			end
			if numCities == -1 then
				for city in player:Cities() do
					if not city:IsHasBuilding(buildingID) then
						city:SetNumRealBuilding(buildingID, 1)
					end
				end
			elseif (MapModData.Cep_PlayerFreeBuildings.Buildings[playerID][buildingID] < numCities) then
				if not cityList then
					cityList = {}
					for city in player:Cities() do
						if player:IsHuman() then
							log:Debug("Policy_FreeBuildingFlavor #cityList=%s id=%s turn=%s", #cityList, City_GetID(city), city:GetGameTurnAcquired())
						end
						table.insert(cityList, {id=City_GetID(city), turn=city:GetGameTurnAcquired()})
					end
					table.sort(cityList, function (a,b)
						return a.turn < b.turn
					end)
				end
				local maxCityID = #cityList
				if numCities < maxCityID then
					maxCityID = numCities
				end
				for i = 1, maxCityID do
					local cityID = cityList[i].id
					local city = Map_GetCity(cityID)
					PlaceBuildingID(city, buildingID)
				end
			end		
		end
	end
end

	
function DoPolicyFreeBuildingFlavors(player, policyID)
	--log:Info("DoPolicyFreeBuildingFlavors")
	local playerID = player:GetID()
	local cityList = nil
	for row in GameInfo.Policy_FreeBuildingFlavor() do
		local testPolicyInfo = GameInfo.Policies[row.PolicyType]
		local flavorType = row.FlavorType
		local numCities = row.NumCities
		if (policyID == testPolicyInfo.ID) or player:HasPolicy(testPolicyInfo.ID) then
			if player:IsHuman() then
				log:Debug("%45s has      %s", player:GetName(), testPolicyInfo.Type)
			end
			if numCities == -1 then
				for city in player:Cities() do
					local cityID = City_GetID(city)
					if not MapModData.Cep_FreeFlavorBuilding[flavorType][cityID] then
						PlaceBuildingOfFlavor(city, flavorType)
					end
				end
			elseif (MapModData.Cep_PlayerFreeBuildings.Flavors[flavorType][playerID] < numCities) then
				if not cityList then
					cityList = {}
					for city in player:Cities() do
						if player:IsHuman() then
							log:Debug("Policy_FreeBuildingFlavor #cityList=%s id=%s turn=%s", #cityList, City_GetID(city), city:GetGameTurnAcquired())
						end
						table.insert(cityList, {id=City_GetID(city), turn=city:GetGameTurnAcquired()})
					end
					table.sort(cityList, function (a,b)
						return a.turn < b.turn
					end)
				end
				local maxCityID = #cityList
				if numCities < maxCityID then
					maxCityID = numCities
				end
				for i = 1, maxCityID do
					local cityID = cityList[i].id
					if player:IsHuman() then
						log:Debug("cityID=%s freeBuilding=%s", cityID, MapModData.Cep_FreeFlavorBuilding[flavorType][cityID])
					end
					local city = Map_GetCity(cityID)
					if not MapModData.Cep_FreeFlavorBuilding[flavorType][cityID] then
						PlaceBuildingOfFlavor(city, flavorType)
					end
				end
			end		
		end
	end
end

function DoPolicyExperience(player, policyInfo)
	local experience = policyInfo.FreeExperience
	if not experience then
		return
	end
	for unit in player:Units() do
		if unit:IsCombatUnit() then
			unit:ChangeExperience(experience)
		end
	end
end

function DoPolicyBorderObstacle(player, policyInfo)
	local activateBorderTech = GameInfo.Buildings.BUILDING_GREAT_WALL.ObsoleteTech
	if not policyInfo.BorderObstacle or (not player:HasTech(activateBorderTech) and player:HasBuilding("BUILDING_GREAT_WALL")) then
		return
	end
	local buildingID = GameInfo.Buildings.BUILDING_FREEDOM_FINISHER.ID
	local capitalCity = player:GetCapitalCity()
	if capitalCity and City_GetNumBuilding(capitalCity, buildingID) ~= 1 then
		capitalCity:SetNumRealBuilding(buildingID, 1)
	end
end

function DoPolicyInfluence(player, policyInfo)
	local playerID = player:GetID()
	local influence = policyInfo.MinorInfluence
	local minInfluence = policyInfo.MinorFriendshipMinimum
	if influence == 0 then
		return
	end
	
	local playerTeam = Teams[player:GetTeam()]
	log:Warn("%s CS Friendship: +%s", player:GetName(), influence)
	for minorCivID,minorCiv in pairs(Players) do
		local minorTeamID = minorCiv:GetTeam()
		if minorCiv:IsAliveCiv() and minorCiv:IsMinorCiv() and playerTeam:IsHasMet(minorTeamID) and not playerTeam:IsAtWar(minorTeamID) then
			if (policyInfo.MinorFriendshipMinimum ~= 0) and (minorCiv:GetMinorCivFriendshipLevelWithMajor(playerID) < policyInfo.MinorFriendshipMinimum) then
				minorCiv:SetFriendship(playerID, policyInfo.MinorFriendshipMinimum)
			end
			minorCiv:ChangeMinorCivFriendshipWithMajor(playerID, influence)
		end
	end
end

function DoPolicyInstantYield(player, policyID)
	local policyType = GameInfo.Policies[policyID].Type
	log:Debug("DoPolicyInstantYield %s %s", player:GetName(), policyType)
	
	for info in GameInfo.Policy_InstantYield{PolicyType = policyType} do
		log:Debug("DoPolicyInstantYield %s %s * %s", info.YieldType, info.Yield, Game.GetSpeedYieldMod(YieldTypes[info.YieldType]))
		player:ChangeYieldStored(YieldTypes[info.YieldType], info.Yield * Game.GetSpeedYieldMod(YieldTypes[info.YieldType]))
		if info.YieldType == "YIELD_GOLD" and Game.GetActivePlayer() == player:GetID() then
			Events.AudioPlay2DSound("AS2D_INTERFACE_CITY_SCREEN_PURCHASE")
		end
	end
	for info in GameInfo.Policy_InstantYieldEra{PolicyType = policyType} do
		log:Debug("%s * %s * %s", info.Yield, 1+player:GetCurrentEra(), Game.GetSpeedYieldMod(YieldTypes[info.YieldType]))
		player:ChangeYieldStored(YieldTypes[info.YieldType], info.Yield * (1+player:GetCurrentEra()) * Game.GetSpeedYieldMod(YieldTypes[info.YieldType]))
		if info.YieldType == "YIELD_GOLD" and Game.GetActivePlayer() == player:GetID() then
			Events.AudioPlay2DSound("AS2D_INTERFACE_CITY_SCREEN_PURCHASE")
		end
	end

	for info in GameInfo.Policy_InstantYieldTurns{PolicyType = policyType} do
		if Game.Contains(nationalYieldTypes, info.YieldType) then
			local baseYieldRate = math.max(0, player:GetBaseYieldRate(YieldTypes[info.YieldType]))
			player:ChangeYieldStored(YieldTypes[info.YieldType], info.Turns * baseYieldRate)
			if info.YieldType == "YIELD_GOLD" and Game.GetActivePlayer() == player:GetID() then
				Events.AudioPlay2DSound("AS2D_INTERFACE_CITY_SCREEN_PURCHASE")
			end
		elseif Game.Contains(cityYieldTypes, info.YieldType) then
			local yieldID = YieldTypes[info.YieldType]
			for city in player:Cities() do
				local baseMod = City_GetBaseYieldRateModifier(city, yieldID)
				local baseYieldRate = City_GetBaseYieldRate(city, yieldID) * (1 + baseMod/100)
				city:ChangeYieldStored(yieldID, info.Turns * baseYieldRate)
			end
		end
	end
end

local nationalYieldTypes = {
	"YIELD_GOLD",
	"YIELD_SCIENCE",
	"YIELD_FAITH",
	"YIELD_HAPPINESS_NATIONAL"
}

local cityYieldTypes = {
	"YIELD_FOOD",
	"YIELD_PRODUCTION",
	"YIELD_CULTURE",
	"YIELD_HAPPINESS_CITY"
}

if not MapModData.Cep_FreeFlavorBuilding then
	MapModData.Cep_FreeBuilding = {}
	MapModData.Cep_FreeFlavorBuilding = {}
	MapModData.Cep_PlayerFreeBuildings = {}
	MapModData.Cep_PlayerFreeBuildings.Buildings = {}
	MapModData.Cep_PlayerFreeBuildings.Flavors = {}
	startClockTime = os.clock()
	for playerID,player in pairs(Players) do
		MapModData.Cep_PlayerFreeBuildings.Buildings[playerID] = {}
		if UI:IsLoadedGame() then
			for city in player:Cities() do
				local cityID = City_GetID(city)			
				MapModData.Cep_FreeBuilding[cityID] = {}
				local buildingID = LoadValue("MapModData.Cep_FreeBuilding[%s]", cityID)
				--log:Trace("Loading %15s MapModData.Cep_FreeBuilding %s = %s", city:GetName(), flavorType, buildingID)
				if buildingID then
					MapModData.Cep_FreeBuilding[cityID][buildingID] = true
					if not MapModData.Cep_PlayerFreeBuildings.Buildings[playerID][buildingID] then
						MapModData.Cep_PlayerFreeBuildings.Buildings[playerID][buildingID] = 1
					else
						MapModData.Cep_PlayerFreeBuildings.Buildings[playerID][buildingID] = MapModData.Cep_PlayerFreeBuildings.Buildings[playerID][buildingID] + 1
					end
				end
			end
		end
	end
	for row in GameInfo.Flavors() do
		local flavorType = row.Type
		MapModData.Cep_FreeFlavorBuilding[flavorType] = {}
		MapModData.Cep_PlayerFreeBuildings.Flavors[flavorType] = {}
		for playerID,player in pairs(Players) do
			MapModData.Cep_PlayerFreeBuildings.Flavors[flavorType][playerID] = 0
			if UI:IsLoadedGame() then
				for city in player:Cities() do
					local cityID = City_GetID(city)
					local buildingID = LoadValue("MapModData.Cep_FreeFlavorBuilding[%s][%s]", flavorType, cityID)
					--log:Trace("Loading %15s MapModData.Cep_FreeFlavorBuilding %s = %s", city:GetName(), flavorType, buildingID)
					if buildingID then
						MapModData.Cep_FreeFlavorBuilding[flavorType][cityID] = buildingID
						MapModData.Cep_PlayerFreeBuildings.Flavors[flavorType][playerID] = MapModData.Cep_PlayerFreeBuildings.Flavors[flavorType][playerID] + 1
					end
				end
			end
		end
	end
	if UI:IsLoadedGame() then
		log:Info("%3s ms loading FreeFlavorBuilding", Game.Round((os.clock() - startClockTime)*1000))
	end
end

function PlaceBuildingID(city, buildingID)
	local playerID = city:GetOwner()
	local player = Players[playerID]
	local cityID = City_GetID(city)
	if not MapModData.Cep_FreeBuilding[cityID] then
		MapModData.Cep_FreeBuilding[cityID] = {}
	end
	if MapModData.Cep_FreeBuilding[cityID][buildingID] then
		return
	end
	city:SetNumRealBuilding(buildingID, 1)
	SaveValue(buildingID, "MapModData.Cep_FreeBuilding[%s]", cityID)
	MapModData.Cep_FreeBuilding[cityID][buildingID] = true
	MapModData.Cep_PlayerFreeBuildings.Buildings[playerID][buildingID] = MapModData.Cep_PlayerFreeBuildings.Buildings[playerID][buildingID] + 1
	if player:IsHuman() then
		log:Warn("%45s recieved building", " ", " ")
	end
end

function PlaceBuildingOfFlavor(city, flavorType)
	local playerID = city:GetOwner()
	local player = Players[playerID]
	local buildingID, buildingFlavor = Game.GetMaximum(City_GetBuildingsOfFlavor(city, flavorType))

	if player:IsHuman() then
		log:Debug("%45s best     %s building: %s", city:GetName(), flavorType, (buildingID ~= -1) and GameInfo.Buildings[buildingID].Type or "None Available")
	end
	if buildingID ~= -1 then
		city:SetNumRealBuilding(buildingID, 1)
		local cityID = City_GetID(city)
		SaveValue(buildingID, "MapModData.Cep_FreeFlavorBuilding[%s][%s]", flavorType, cityID)
		MapModData.Cep_FreeFlavorBuilding[flavorType][cityID] = buildingID
		MapModData.Cep_PlayerFreeBuildings.Flavors[flavorType][playerID] = MapModData.Cep_PlayerFreeBuildings.Flavors[flavorType][playerID] + 1
		if player:IsHuman() then
			log:Debug("%45s recieved building", " ", " ")
		end
	end
end

---------------------------------------------------------------------
---------------------------------------------------------------------

function UpdatePromotions(unit, isUpgrading)
	if not unit or not unit:IsCombatUnit() then
		return
	end

	local needsAstronomy = GameInfo.UnitPromotions.PROMOTION_OCEAN_IMPASSABLE_UNTIL_ASTRONOMY.ID
	if unit:IsHasPromotion(needsAstronomy) and Players[unit:GetOwner()]:GetTraitInfo().EmbarkedAllWater then
		unit:SetHasPromotion(needsAstronomy, false)
	end

	if unit:GetDomainType() == DomainTypes.DOMAIN_SEA then
		return
	end

	local unitInfo = GameInfo.Units[unit:GetUnitType()]
	if isUpgrading then
		unitInfo = GameInfo.Units[unit:GetUpgradeUnitType()]
		log:Debug("UpdatePromotions upgrade %s to %s", GameInfo.Units[unit:GetUnitType()].Type, tostring(unitInfo.Type))
	end
	
	log:Info("Debug %s", unitInfo.Type)
		
	local upgradingUnitPromotionSet = GameInfo.UnitCombatInfos[unitInfo.CombatClass].PromotionCategory

	if isUpgrading then
		log:Debug("New promotion column: %s", upgradingUnitPromotionSet)
	end

	if GameInfo.UnitPromotions.PROMOTION_REPAIR and (unitInfo.CombatClass == "_UNITCOMBAT_ARMOR" or unitInfo.CombatClass == "UNITCOMBAT_ARMOR") then
		CheckReplacePromotion(
			unit,
			GameInfo.UnitPromotions.PROMOTION_MARCH.ID,
			GameInfo.UnitPromotions.PROMOTION_REPAIR.ID
			)
	end

	for swapRow in GameInfo.UnitPromotions_Equivilancy() do
		local newPromo = swapRow[upgradingUnitPromotionSet]
		local newPromoID = -1
		if newPromo then
			if GameInfo.UnitPromotions[newPromo] then
				newPromoID = GameInfo.UnitPromotions[newPromo].ID
			else
				log:Warn("UpdatePromotions: %s does not exist in UnitPromotions!", newPromo)					
			end
		end
		for column, oldPromoType in pairs(swapRow) do
			if (oldPromoType == "PROMOTION_SIEGE" and (unitInfo.CombatClass == "_UNITCOMBAT_SIEGE" or unitInfo.CombatClass == "UNITCOMBAT_SIEGE")
				or (oldPromoType == "PROMOTION_SIEGE" and unitInfo.Range > 0)
				) then
				-- do not replace
			elseif column ~= upgradingUnitPromotionSet then
				if GameInfo.UnitPromotions[oldPromoType] then
					CheckReplacePromotion(unit, GameInfo.UnitPromotions[oldPromoType].ID, newPromoID)
				else
					log:Warn("UpdatePromotions: %s does not exist in UnitPromotions!", oldPromoType)
				end
			end
		end
	end
end

LuaEvents.ActivePlayerTurnStart_Unit.Add(UpdatePromotions)
LuaEvents.UnitUpgraded.Add(function(unit) UpdatePromotions(unit, true) end)

function CheckReplacePromotion(unit, oldPromoID, newPromoID)
	if unit:IsHasPromotion(oldPromoID) and (oldPromoID ~= newPromoID) then
		--log:Trace("%s replace %s with %s", unit:GetName(), GameInfo.UnitPromotions[oldPromoID].Type, newPromoID and GameInfo.UnitPromotions[newPromoID].Type or "none")
		if newPromoID == -1 then
			
		else
			unit:SetHasPromotion(oldPromoID, false)
			unit:SetHasPromotion(newPromoID, true)
			--LuaEvents.RefreshUnitFlagPromotions(unit)
		end
	end
end

---------------------------------------------------------------------
---------------------------------------------------------------------

function CheckExtraBuildingStats(city, owner)
	local query = ""

	query = "GreatGeneralRateChange != 0"
	for buildingInfo in GameInfo.Buildings(query) do
		if (city:IsHasBuilding(buildingInfo.ID)) then
			owner:ChangeCombatExperience(buildingInfo.GreatGeneralRateChange)
		end
	end

	query = "GoldenAgePoints != 0"
	for buildingInfo in GameInfo.Buildings(query) do
		if (city:IsHasBuilding(buildingInfo.ID)) then
			owner:ChangeGoldenAgeProgressMeter(buildingInfo.GoldenAgePoints)
		end
	end

	query = "ExperiencePerTurn != 0"
	for buildingInfo in GameInfo.Buildings(query) do
		if (city:IsHasBuilding(buildingInfo.ID)) then
			local plot = city:Plot()
			for i=0, plot:GetNumUnits()-1 do
				local unit = plot:GetUnit(i)
				if unit and unit:IsCombatUnit() then
					unit:ChangeExperience(buildingInfo.ExperiencePerTurn)
				end
			end			
		end
	end
end

LuaEvents.ActivePlayerTurnStart_City.Add(CheckExtraBuildingStats)

---------------------------------------------------------------------
---------------------------------------------------------------------

function CheckGarrisonExperience(player)
	if player:IsMinorCiv() then
		return
	end
	local playerID = player:GetID()
	local exp = 0
	for policyInfo in GameInfo.Policies("GarrisonedExperience != 0") do
		if player:HasPolicy(policyInfo.ID)  then
			exp = exp + policyInfo.GarrisonedExperience
		end
	end
	if exp > 0 then
		for unit in player:Units() do
			if unit and not unit:IsDead() and unit:IsGarrisoned() then
				unitXP = (MapModData.Cep_UnitXP[playerID][unit:GetID()] or 0) + exp
				if unitXP >= 1 then
					unit:ChangeExperience(math.floor(unitXP))
					unitXP = unitXP - math.floor(unitXP)
				end
				MapModData.Cep_UnitXP[playerID][unit:GetID()] = unitXP
				SaveValue(unitXP, "MapModData.Cep_UnitXP[%s][%s]", playerID, unit:GetID())
				--SaveUnit(unit, unitXP, "unitXP")
				--log:Debug("%25s %15s %15s exp=%.1f", "CheckGarrisonExperience", player:GetName(), unit:GetName(), unitXP)
			end
		end
	end
end

LuaEvents.ActivePlayerTurnStart_Player.Add(CheckGarrisonExperience)

---------------------------------------------------------------------
---------------------------------------------------------------------

--[[
function DoLevelupHeal(
		attPlayerID,
		attUnitID,
		attUnitDamage,
		attFinalUnitDamage,
		attMaxHitPoints,
		defPlayerID,
		defUnitID,
		defUnitDamage,
		defFinalUnitDamage,
		defMaxHitPoints
		)

	local heal = Cep.UNIT_LEVEL_UP_HEAL_PERCENT
	local attPlayer	= Players[attPlayerID]
	local attUnit	= attPlayer:GetUnitByID(attUnitID)

	if (not attUnit) or (not heal) or (heal == 0)  then
		return
	end

	--log:Debug("DoLevelupHeal %15s %15s", attPlayer:GetName(), attUnit:GetName())

end



Events.EndCombatSim.Add( DoLevelupHeal )
--]]

---------------------------------------------------------------------
---------------------------------------------------------------------

if not MapModData.Cep_UnitLevel then
	MapModData.Cep_UnitLevel = {}
	for playerID,player in pairs(Players) do
		if player:IsAliveCiv() then
			MapModData.Cep_UnitLevel[playerID] = {}
			for unit in player:Units() do
				MapModData.Cep_UnitLevel[playerID][unit:GetID()] = unit:GetLevel()
			end
		end
	end
end

function DoPromotionHeal(unit, promotionType)
	local heal = Cep.UNIT_LEVEL_UP_HEAL_PERCENT
	if heal and heal ~= 0 then
		local playerID = unit:GetOwner()
		heal = unit:GetMaxHitPoints() * heal / 100
		unit:ChangeDamage(-heal)
		--log:Warn("Level %s", unit:GetLevel())
		MapModData.Cep_UnitLevel[playerID][unit:GetID()] = (MapModData.Cep_UnitLevel[playerID][unit:GetID()] or unit:GetLevel()) + 1
	end
end
LuaEvents.PromotionEarned.Add(DoPromotionHeal)

function CheckForAILevelup(unit)
	local playerID = unit:GetOwner()
	MapModData.Cep_UnitLevel[playerID][unit:GetID()] = MapModData.Cep_UnitLevel[playerID][unit:GetID()] or unit:GetLevel()
	for i = MapModData.Cep_UnitLevel[playerID][unit:GetID()], unit:GetLevel() - 1 do
		--log:Warn("%15s %15s old=%s new=%s", Players[playerID]:GetName(), unit:GetName(), MapModData.Cep_UnitLevel[playerID][unit:GetID()], unit:GetLevel())
		DoPromotionHeal(unit)
	end
end
LuaEvents.ActivePlayerTurnEnd_Unit.Add(CheckForAILevelup)
LuaEvents.ActivePlayerTurnStart_Unit.Add(CheckForAILevelup)

---------------------------------------------------------------------
---------------------------------------------------------------------

function FixTechNotificationBug(hexPos, playerID, cityID, cultureType, eraType, continent, populationSize, size, fowState)
	local player = Players[playerID]
	if player:IsHuman() and player:GetNumCities() <= 1 then
		log:Debug("Show choose tech notification")
		player:ChooseTech(0, Locale.ConvertTextKey("TXT_KEY_MISC_WHAT_TO_RESEARCH_NEXT"), GameInfo.Technologies.TECH_AGRICULTURE.ID)
	end
end
LuaEvents.NewCity.Add(FixTechNotificationBug)

---------------------------------------------------------------------
---------------------------------------------------------------------

function DoHillProduction(hexPos, playerID, cityID, cultureType, eraType, continent, populationSize, size, fowState)
	local plot = Map.GetPlot(ToGridFromHex(hexPos.x, hexPos.y))
	if GameInfo.Yields.YIELD_PRODUCTION.MinCity >= 2 and plot:GetPlotType() == PlotTypes.PLOT_HILLS then
		Plot_ChangeYield(plot, YieldTypes.YIELD_PRODUCTION, 1)
	end
end
LuaEvents.NewCity.Add(DoHillProduction)

function ResetCityYields(hexPos, playerID, cityID, newPlayerID)
	local plot = Map.GetPlot(ToGridFromHex(hexPos.x, hexPos.y))
	if plot:GetPlotType() == PlotTypes.PLOT_HILLS then
		Plot_SetYield(plot, YieldTypes.YIELD_PRODUCTION, 2)
	else
		Plot_SetYield(plot, YieldTypes.YIELD_CULTURE, 0)
		local query = string.format("TerrainType = '%s'", GameInfo.Terrains[plot:GetTerrainType()].Type)
		for info in GameInfo.Terrain_Yields(query) do
			Plot_SetYield(plot, GameInfo.Yields[info.YieldType].ID, info.Yield)
		end
	end
end
Events.SerialEventCityDestroyed.Add(ResetCityYields)

---------------------------------------------------------------------
---------------------------------------------------------------------

LuaEvents.ActivePlayerTurnStart_Turn.Add(
	function ()
		if (Game.GetGameTurn() % 50 == 0) and (Game.GetGameTurn() ~= 0) then
			LuaEvents.PrintDebug()
		end
	end
)

Events.SequenceGameInitComplete.Add( LuaEvents.PrintDebug );

---------------------------------------------------------------------
---------------------------------------------------------------------

--[[
function ChooseTech(hexPos, playerID, cityID, cultureType, eraType, continent, populationSize, size, fowState)
	if playerID == Game.GetActivePlayer() and Players[playerID]:GetNumCities() <= 1 then
		Events.OpenInfoCorner(InfoCornerID.Tech)
	end
end
LuaEvents.NewCity.Add(ChooseTech)
--]]