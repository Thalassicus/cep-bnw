-- TU - LuaEvents
-- Author: Thalassicus
-- DateCreated: 2/29/2012 7:29:27 AM
--------------------------------------------------------------

include("ModTools.lua")

--print("Init MT_Events.lua")

local log = Events.LuaLogger:New()
log:SetLevel("INFO")

--
-- Initialize data
--

if not LuaEvents.MT_Initialize then
	LuaEvents.MT_Initialize					= function()							end
	LuaEvents.PrintDebug					= function()							end
	LuaEvents.ActivePlayerTurnStart_Turn	= function()							end
	LuaEvents.ActivePlayerTurnStart_Player	= function(player)						end
	LuaEvents.ActivePlayerTurnStart_Unit	= function(unit)						end
	LuaEvents.ActivePlayerTurnStart_City	= function(city, owner)					end
	LuaEvents.ActivePlayerTurnStart_Plot	= function(plot)						end
	LuaEvents.ActivePlayerTurnEnd_Turn		= function()							end
	LuaEvents.ActivePlayerTurnEnd_Player	= function(player)						end
	LuaEvents.ActivePlayerTurnEnd_Unit		= function(unit)						end
	LuaEvents.ActivePlayerTurnEnd_City		= function(city, owner)					end
	LuaEvents.ActivePlayerTurnEnd_Plot		= function(plot)						end
	LuaEvents.NewCity						= function(hexPos, playerID, cityID, cultureType, eraType, continent, populationSize, size, fowState) end
	LuaEvents.NewUnit						= function(playerID, unitID, hexVec, unitType, cultureType, civID, primaryColor, secondaryColor, unitFlagIndex, fogState, selected, military, notInvisible) end
	LuaEvents.NewImprovement				= function(hexX, hexY, cultureArtID, continentArtID, playerID, engineImprovementTypeDoNotUse, improvementID, engineResourceTypeDoNotUse, resourceID, eraID, improvementState) end
	LuaEvents.NewTech						= function(player, techID, changeID)	end
	LuaEvents.PlotChanged					= function(hexX, hexY)					end
	LuaEvents.PlotAcquired					= function(plot, newOwnerID)			end
	LuaEvents.NewPolicy						= function(policyID, isPolicy)			end
	LuaEvents.CityOccupied					= function(city, player, isForced)		end
	LuaEvents.CityPuppeted					= function(city, player, isForced)		end
	LuaEvents.CityLiberated					= function(city, player, isForced)		end
	LuaEvents.PromotionEarned				= function(unit, promotionType)			end
	LuaEvents.UnitUpgraded					= function(unit)						end
	LuaEvents.BuildingConstructed			= function(player, city, buildingID)	end
	LuaEvents.BuildingDestroyed				= function(player, city, buildingID)	end
	LuaEvents.CheckPlotBuildingsStatus		= function(plot)						end
end


local startAITurnTime = nil

MapModData.Cep_VanillaTurnTimes	= 0
MapModData.Cep_StartTurn		= Game.GetGameTurn()
MapModData.Cep_TotalPlayers		= 0
MapModData.Cep_TotalCities		= 0
MapModData.Cep_TotalUnits		= 0
MapModData.Cep_ReplacingUnit	= false


MapModData.Cep_StartTurnTimes = {
	Turn		= 0,
	Players		= 0,
	Units		= 0,
	Cities		= 0,
	Policies	= 0,
	Plots		= 0,
	Total		= 0
}

MapModData.Cep_EndTurnTimes = {
	Turn		= 0,
	Players		= 0,
	Units		= 0,
	Cities		= 0,
	Policies	= 0,
	Plots		= 0,
	Total		= 0
}

MapModData.Cep_PlotOwner = {}

for plotID = 0, Map.GetNumPlots() - 1, 1 do
	local plot = Map.GetPlotByIndex(plotID)
	--if plot:GetOwner() ~= -1 then
		--log:Warn("Loading PlotOwner %s", plotID)
		MapModData.Cep_PlotOwner[plotID] = plot:GetOwner() --LoadPlot(plot, "PlotOwner")
	--end
end

MapModData.Cep_HasPolicy = {}

startClockTime = os.clock()
for playerID, player in pairs(Players) do
	MapModData.Cep_HasPolicy[playerID] = {}
	if not player:IsMinorCiv() then
		for policyInfo in GameInfo.Policies() do
			MapModData.Cep_HasPolicy[playerID][policyInfo.ID] = player:HasPolicy(policyInfo.ID)
		end
	end
end
if UI:IsLoadedGame() then
	log:Info("%3s ms loading HasPolicy", Game.Round((os.clock() - startClockTime)*1000))
end

MapModData.Cep_UnitXP = {}
startClockTime = os.clock()
for playerID,player in pairs(Players) do
	if player:IsAliveCiv() and not player:IsMinorCiv() then
		MapModData.Cep_UnitXP[playerID] = {}
		if UI.IsLoadedGame() then
			for policyInfo in GameInfo.Policies("GarrisonedExperience <> 0") do
				if player:HasPolicy(policyInfo.ID) then
					for unit in player:Units() do
						--log:Debug("Loading UnitXP %s", unit:GetName())
						MapModData.Cep_UnitXP[playerID][unit:GetID()] = LoadValue("MapModData.Cep_UnitXP[%s][%s]", playerID, unit:GetID())
					end
				end
			end
		end		
	end
end
if UI:IsLoadedGame() then
	log:Info("%3s ms loading UnitXP", Game.Round((os.clock() - startClockTime)*1000))
end

MapModData.buildingsAlive = {}
for plotID = 0, Map.GetNumPlots() - 1, 1 do
	MapModData.buildingsAlive[plotID] = {}
end
for playerID,player in pairs(Players) do
	for city in player:Cities() do
		for buildingInfo in GameInfo.Buildings() do
			log:Debug("Loading buildingsAlive %15s %20s = %s", city:GetName(), GetName(buildingInfo), city:IsHasBuilding(buildingInfo.ID))
			MapModData.buildingsAlive[City_GetID(city)][buildingInfo.ID] = city:IsHasBuilding(buildingInfo.ID)
		end
	end
end

--
-- Event Definitions
--

----------------------------------------------------------------
--[[ LuaEvents.ActivePlayerTurnStart usage example:

function UpdatePromotions(pUnit, pOwner)
	-- does stuff for each unit, once at the start of the turn
end
LuaEvents.ActivePlayerTurnStart_Unit.Add(UpdatePromotions)

-- also available:
-- LuaEvents.ActivePlayerTurnStart_Turn		()
-- LuaEvents.ActivePlayerTurnStart_Player	(player)
-- LuaEvents.ActivePlayerTurnStart_Unit		(unit)
-- LuaEvents.ActivePlayerTurnStart_City		(city, owner) 
-- LuaEvents.ActivePlayerTurnStart_Plot		(plot)
]]


function OnTurnStart()
	if startAITurnTime then
		log:Info("VanillaStuff %10s %10.3f seconds", "Total", os.clock() - startAITurnTime)
		MapModData.Cep_VanillaTurnTimes = MapModData.Cep_VanillaTurnTimes + (os.clock() - startAITurnTime)
	else
		log:Info("OnTurnStart")
	end
	
	log:Info("OnTurnStart")
	local startClockTime = os.clock()
	local stepClockTime = os.clock()
	LuaEvents.ActivePlayerTurnStart_Turn()
	MapModData.Cep_StartTurnTimes.Turn = MapModData.Cep_StartTurnTimes.Turn + (os.clock() - stepClockTime)
	log:Info("OnTurnStart %10s %10.3f seconds", "Turn", os.clock() - stepClockTime)
	stepClockTime = os.clock()
	for playerID, player in pairs(Players) do
		if player:IsAliveCiv() then
			LuaEvents.ActivePlayerTurnStart_Player(player)
			MapModData.Cep_TotalPlayers = MapModData.Cep_TotalPlayers + 1
		end
	end
	log:Info("OnTurnStart %10s %10.3f seconds", "Players", os.clock() - stepClockTime)
	MapModData.Cep_StartTurnTimes.Players = MapModData.Cep_StartTurnTimes.Players + (os.clock() - stepClockTime)
	stepClockTime = os.clock()
	for playerID, player in pairs(Players) do
		if player:IsAliveCiv() then
			for city in player:Cities() do
				if city then
					LuaEvents.ActivePlayerTurnStart_City(city, player)
					MapModData.Cep_TotalCities = MapModData.Cep_TotalCities + 1
				end
			end
		end
	end
	log:Info("OnTurnStart %10s %10.3f seconds", "Cities", os.clock() - stepClockTime)
	MapModData.Cep_StartTurnTimes.Cities = MapModData.Cep_StartTurnTimes.Cities + (os.clock() - stepClockTime)
	stepClockTime = os.clock()
	for playerID, player in pairs(Players) do
		if player:IsAliveCiv() then
			for pUnit in player:Units() do
				if pUnit then
					LuaEvents.ActivePlayerTurnStart_Unit(pUnit)
					MapModData.Cep_TotalUnits = MapModData.Cep_TotalUnits + 1
				end
			end
		end
	end
	log:Info("OnTurnStart %10s %10.3f seconds", "Units", os.clock() - stepClockTime)
	MapModData.Cep_StartTurnTimes.Units = MapModData.Cep_StartTurnTimes.Units + (os.clock() - stepClockTime)
	stepClockTime = os.clock()
	for playerID, player in pairs(Players) do
		if player:IsAliveCiv() then
			if not player:IsMinorCiv() then
				for policyInfo in GameInfo.Policies() do
					local policyID = policyInfo.ID
					if MapModData.Cep_HasPolicy[playerID][policyID] ~= player:HasPolicy(policyID) then
						MapModData.Cep_HasPolicy[playerID][policyID] = player:HasPolicy(policyID)
						LuaEvents.NewPolicy(player, policyID)
					end
				end
			end
		end
	end
	log:Info("OnTurnStart %10s %10.3f seconds", "Policies", os.clock() - stepClockTime)
	MapModData.Cep_StartTurnTimes.Policies = MapModData.Cep_StartTurnTimes.Policies + (os.clock() - stepClockTime)
	stepClockTime = os.clock()
	for plotID = 0, Map.GetNumPlots() - 1, 1 do
		local plot = Map.GetPlotByIndex(plotID)
		LuaEvents.ActivePlayerTurnStart_Plot(plot)
	end
	log:Info("OnTurnStart %10s %10.3f seconds", "Plots", os.clock() - stepClockTime)
	MapModData.Cep_StartTurnTimes.Plots = MapModData.Cep_StartTurnTimes.Plots + (os.clock() - stepClockTime)
	log:Info("OnTurnStart  %10s %10.3f seconds", "Total", os.clock() - startClockTime)
	MapModData.Cep_StartTurnTimes.Total = MapModData.Cep_StartTurnTimes.Total + (os.clock() - startClockTime)
end

----------------------------------------------------------------
--[[ Events.ActivePlayerTurnEnd usage example:

function CheckNewBuildingStats(city, player)
	-- does stuff for each city, once at the end of the turn
end
LuaEvents.ActivePlayerTurnEnd_City.Add(CheckNewBuildingStats)

-- also available:
-- LuaEvents.ActivePlayerTurnEnd_Turn	()
-- LuaEvents.ActivePlayerTurnEnd_Player	(player)
-- LuaEvents.ActivePlayerTurnEnd_Unit	(unit)
-- LuaEvents.ActivePlayerTurnEnd_City	(city, owner) 
-- LuaEvents.ActivePlayerTurnEnd_Plot	(plot)
]]

--
function OnTurnEnd()
	--log:Info("OnTurnEnd")
	local startClockTime = os.clock()
	local stepClockTime = os.clock()
	LuaEvents.ActivePlayerTurnEnd_Turn()
	MapModData.Cep_EndTurnTimes.Turn = MapModData.Cep_EndTurnTimes.Turn + (os.clock() - stepClockTime)
	log:Debug("OnTurnEnd   %10s %10.3f seconds", "Turn", os.clock() - stepClockTime)
	stepClockTime = os.clock()
	for playerID, player in pairs(Players) do
		if player:IsAliveCiv() then
			LuaEvents.ActivePlayerTurnEnd_Player(player)
		end
	end
	log:Debug("OnTurnEnd   %10s %10.3f seconds", "Players", os.clock() - stepClockTime)
	MapModData.Cep_EndTurnTimes.Players = MapModData.Cep_EndTurnTimes.Players + (os.clock() - stepClockTime)
	stepClockTime = os.clock()
	for playerID, player in pairs(Players) do
		if player:IsAliveCiv() then
			for pUnit in player:Units() do
				if pUnit then
					LuaEvents.ActivePlayerTurnEnd_Unit(pUnit)
				end
			end
		end
	end
	log:Debug("OnTurnEnd   %10s %10.3f seconds", "Units", os.clock() - stepClockTime)
	MapModData.Cep_EndTurnTimes.Units = MapModData.Cep_EndTurnTimes.Units + (os.clock() - stepClockTime)
	stepClockTime = os.clock()
	for playerID, player in pairs(Players) do
		if player:IsAliveCiv() then
			for city in player:Cities() do
				if city then
					LuaEvents.ActivePlayerTurnEnd_City(city, player)
				end
			end
		end
	end
	log:Debug("OnTurnEnd   %10s %10.3f seconds", "Cities", os.clock() - stepClockTime)
	MapModData.Cep_EndTurnTimes.Cities = MapModData.Cep_EndTurnTimes.Cities + (os.clock() - stepClockTime)
	stepClockTime = os.clock()
	for playerID, player in pairs(Players) do
		if player:IsAliveCiv() then
			if not player:IsMinorCiv() then
				for policyInfo in GameInfo.Policies() do
					local policyID = policyInfo.ID
					if MapModData.Cep_HasPolicy[playerID][policyID] ~= player:HasPolicy(policyID) then
						MapModData.Cep_HasPolicy[playerID][policyID] = player:HasPolicy(policyID)
						LuaEvents.NewPolicy(player, policyID)
					end
				end
			end
		end
	end
	log:Debug("OnTurnEnd   %10s %10.3f seconds", "Policies", os.clock() - stepClockTime)
	MapModData.Cep_EndTurnTimes.Policies = MapModData.Cep_EndTurnTimes.Policies + (os.clock() - stepClockTime)
	stepClockTime = os.clock()
	for plotID = 0, Map.GetNumPlots() - 1, 1 do
		local plot = Map.GetPlotByIndex(plotID)
		LuaEvents.ActivePlayerTurnEnd_Plot(plot)
	end
	log:Debug("OnTurnEnd   %10s %10.3f seconds", "Plots", os.clock() - stepClockTime)
	MapModData.Cep_EndTurnTimes.Plots = MapModData.Cep_EndTurnTimes.Plots + (os.clock() - stepClockTime)
	log:Info("OnTurnEnd    %10s %10.3f seconds", "Total", os.clock() - startClockTime)
	MapModData.Cep_EndTurnTimes.Total = MapModData.Cep_EndTurnTimes.Total + (os.clock() - startClockTime)
	startAITurnTime = os.clock()
end
--]]

----------------------------------------------------------------
--[[ These run a single time when a city is founded

LuaEvents.NewCity.Add(CityCreatedChecks)
]]

function OnNewCity(hexPos, playerID, cityID, cultureType, eraType, continent, populationSize, size, fowState)
	if MapModData.Cep_Initialized or not UI.IsLoadedGame() then
		LuaEvents.NewCity(hexPos, playerID, cityID, cultureType, eraType, continent, populationSize, size, fowState)
	end
end

----------------------------------------------------------------
--[[ These run a single time when a plot changes
]]

function OnPlotChanged(hexX, hexY)
	if MapModData.Cep_Initialized or not UI.IsLoadedGame() then
		LuaEvents.PlotChanged(hexX, hexY)
	end
end

----------------------------------------------------------------
--[[ These run a single time when an improvement is built
]]

function OnNewImprovement(hexX, hexY, cultureArtID, continentArtID, playerID, engineImprovementTypeDoNotUse, improvementID, engineResourceTypeDoNotUse, resourceID, eraID, improvementState)
	if MapModData.Cep_Initialized or not UI.IsLoadedGame() then
		LuaEvents.NewImprovement(hexX, hexY, cultureArtID, continentArtID, playerID, engineImprovementTypeDoNotUse, improvementID, engineResourceTypeDoNotUse, resourceID, eraID, improvementState)
	end
end

----------------------------------------------------------------
--[[ LuaEvents.NewUnit runs a single time when the unit is created

function UnitCreatedChecks( playerID, unitID, hexVec, unitType, cultureType, civID, primaryColor, secondaryColor, unitFlagIndex, fogState, selected, military, notInvisible )
	-- do stuff
end

LuaEvents.NewUnit.Add(UnitCreatedChecks)
]]


function OnNewUnit(playerID, unitID, hexVec, unitType, cultureType, civID, primaryColor, secondaryColor, unitFlagIndex, fogState, selected, military, notInvisible)
	local unit = Players[playerID]:GetUnitByID(unitID)
	if ( unit == nil
		or unit:IsDead()
		or unit:IsHasPromotion(GameInfo.UnitPromotions.PROMOTION_NEW_UNIT.ID)
		or unit:GetGameTurnCreated() < Game.GetGameTurn() ) then
        return
    end

	unit:SetHasPromotion(GameInfo.UnitPromotions.PROMOTION_NEW_UNIT.ID, true)
	if not MapModData.Cep_ReplacingUnit then
		--log:Warn("New %s %s", unit:GetName(), Players[playerID]:GetName())
		LuaEvents.NewUnit(playerID, unitID, hexVec, unitType, cultureType, civID, primaryColor, secondaryColor, unitFlagIndex, fogState, selected, military, notInvisible)
	end
end

function RemoveNewUnitFlag(unit)
	unit:SetHasPromotion(GameInfo.UnitPromotions.PROMOTION_NEW_UNIT.ID, false)
end

--[[
if not MapModData.Cep_UnitCreated then
	MapModData.Cep_UnitCreated = {}
	for playerID, player in pairs(Players) do
		MapModData.Cep_UnitCreated[playerID] = {}
		for unit in player:Units() do
			MapModData.Cep_UnitCreated[playerID][unit:GetID()] = true
		end
	end
end

function OnNewUnit(playerID, unitID, hexVec, unitType, cultureType, civID, primaryColor, secondaryColor, unitFlagIndex, fogState, selected, military, notInvisible)
	if MapModData.Cep_Initialized or not UI.IsLoadedGame() then
		local unit = Players[playerID]:GetUnitByID(unitID)

		if not MapModData.Cep_UnitCreated[playerID][unitID] then
			MapModData.Cep_UnitCreated[playerID][unitID] = true
			LuaEvents.NewUnit(playerID, unitID, hexVec, unitType, cultureType, civID, primaryColor, secondaryColor, unitFlagIndex, fogState, selected, military, notInvisible)
		end
	end
end
--]]

---------------------------------------------------------------------
-- OnNewTech(teamID, techID, changeID)
--
function OnNewTech(teamID, techID, changeID)
	for playerID, player in pairs(Players) do
		if player and player:IsAlive() and player:GetTeam() == teamID then
			LuaEvents.NewTech(player, techID, changeID)
		end
	end	
end


---------------------------------------------------------------------
--[[ LuaEvents.PlotAcquired(plot, newOwnerID) usage example:

]]

function OnHexCultureChanged(hexX, hexY, newOwnerID, unknown)
	local plot = Map.GetPlot(ToGridFromHex(hexX, hexY))
	local plotID = Plot_GetID(plot)
	log:Warn("MapModData.Cep_PlotOwner = %s", MapModData.Cep_PlotOwner)
	--log:Warn("OnHexCultureChanged old=%s new=%s", MapModData.Cep_PlotOwner[plotID], newOwnerID)
	if newOwnerID ~= MapModData.Cep_PlotOwner[plotID] then
		MapModData.Cep_PlotOwner[plotID] = newOwnerID
		--SavePlot(plot, "PlotOwner", newOwnerID)
		--log:Warn("PlotAcquired")
		LuaEvents.PlotAcquired(plot, newOwnerID)
	end
end

---------------------------------------------------------------------
--[[ LuaEvents.NewPolicy(player, policyID) usage example:

function CheckFreeBuildings(player, policyID)
	-- check for buildings affected by the new policy
end

LuaEvents.ActivePlayerTurnEnd_Player.Add( CheckFreeBuildings )
LuaEvents.NewPolicy.Add( CheckFreeBuildings )	
]]

Events.PolicyAdopted = function(policyID, isPolicy)
	log:Info("TriggerPolicyAdopted %s %s", policyID, isPolicy)
	if not isPolicy then
		policyID = GameInfo.Policies[GameInfo.PolicyBranchTypes[policyID].FreePolicy].ID
	end
	local playerID = Game.GetActivePlayer()
	MapModData.Cep_HasPolicy[playerID][policyID] = true
	LuaEvents.NewPolicy(Players[playerID], policyID)
end


---------------------------------------------------------------------
--[[ LuaEvents.UnitExperienceChange(unit, experience) usage example:

]]
--LuaEvents.UnitExperienceChange = LuaEvents.UnitExperienceChange or function(unit, oldXP, newXP) end



---------------------------------------------------------------------
--[[ GetBranchFinisherID(policyBranchType) usage example:

]]
function GetBranchFinisherID(policyBranchType)
	return GameInfo.Policies[GameInfo.PolicyBranchTypes[policyBranchType].FreeFinishingPolicy].ID
end

---------------------------------------------------------------------
--[[ GetItemName(itemTable, itemTypeOrID) usage example:

]]
function GetName(itemInfo, itemTable)
	if itemTable then
		itemInfo = itemTable[itemInfo]
	end
	return Locale.ConvertTextKey(itemInfo.Description)
end

---------------------------------------------------------------------
--[[ HasFinishedBranch(player, policyBranchType, newPolicyID) usage example:

]]
function HasFinishedBranch(player, policyBranchType, newPolicyID)
	local branchFinisherID = GetBranchFinisherID(policyBranchType)
	if player:HasPolicy(branchFinisherID) then
		return true
	end

	for policyInfo in GameInfo.Policies(string.format("PolicyBranchType = '%s' AND ID != '%s'", policyBranchType, branchFinisherID)) do
		if (newPolicyID ~= policyInfo.ID) and not player:HasPolicy(policyInfo.ID) then
			return false
		end
	end
	--log:Debug("%s finished %s", player:GetName(), policyBranchType)
	return true
end

---------------------------------------------------------------------
--[[ LuaEvents.CityOccupied(city, player) usage example:

]]
Events.CityOccupied = function(city, player, isForced)
	LuaEvents.CityOccupied(city, player, isForced)
end

Events.CityPuppeted = function(city, player, isForced)
	LuaEvents.CityPuppeted(city, player, isForced)
end

Events.CityLiberated = function(city, player, isForced)
	LuaEvents.CityLiberated(city, player, isForced)
end

---------------------------------------------------------------------
--[[ LuaEvents.PromotionEarned(city, player) usage example:

]]
Events.PromotionEarned = function(unit, promotionType)
	--log:Warn("PromotionEarned")
	LuaEvents.PromotionEarned(unit, promotionType)
end

Events.UnitUpgraded = function(unit)
	LuaEvents.UnitUpgraded(unit)
end

----------------------------------------------------------------
--[[ CheckPlotBuildingsStatus(plot) usage example:

]]






function OnBuildingConstructed(player, city, buildingID)
	log:Debug("%-25s %15s %15s %30s %s", "BuildingConstructed", player:GetName(), city:GetName(), GameInfo.Buildings[buildingID].Type, MapModData.buildingsAlive[City_GetID(city)])
	local cityID = City_GetID(city)
	MapModData.buildingsAlive[cityID] = MapModData.buildingsAlive[cityID] or {}
	MapModData.buildingsAlive[cityID][buildingID] = true
end

function OnBuildingDestroyed(player, city, buildingID)
	local buildingInfo = GameInfo.Buildings[buildingID]
	if buildingInfo.OneShot then
		return
	end
	log:Debug("%-25s %15s %15s %30s %s", "BuildingDestroyed", player:GetName(), city:GetName(), buildingInfo.Type, MapModData.buildingsAlive[City_GetID(city)])
	local cityID = City_GetID(city)
	MapModData.buildingsAlive[cityID] = MapModData.buildingsAlive[cityID] or {}
	MapModData.buildingsAlive[cityID][buildingID] = false
	if MapModData.Cep_FreeFlavorBuilding then
		for flavorInfo in GameInfo.Flavors() do
			if buildingID == MapModData.Cep_FreeFlavorBuilding[flavorInfo.Type][cityID] then
				MapModData.Cep_FreeFlavorBuilding[flavorInfo.Type][cityID] = false
				SaveValue(false, "MapModData.Cep_FreeFlavorBuilding[%s][%s]", flavorInfo.Type, cityID)
			end
		end
	end
end


LuaEvents.CheckPlotBuildingsStatus = function(plot)
	if plot == nil then
		log:Fatal("CheckPlotBuildingsStatus plot=nil")
		return
	end
	local plotID = Plot_GetID(plot)
	local city = plot:GetPlotCity()
	if city then
		local player = Players[city:GetOwner()]
		if MapModData.buildingsAlive[plotID] == nil then
			MapModData.buildingsAlive[plotID] = {}
		end
		for buildingInfo in GameInfo.Buildings() do
			local buildingID = buildingInfo.ID
			if city:IsHasBuilding(buildingID) and not MapModData.buildingsAlive[plotID][buildingID] then
				LuaEvents.BuildingConstructed(player, city, buildingID)
			elseif not city:IsHasBuilding(buildingID) and MapModData.buildingsAlive[plotID][buildingID] then
				LuaEvents.BuildingDestroyed(player, city, buildingID)
			end
		end
	end
end

function LuaEvents.CheckActiveBuildingStatus()
	for plotID, data in pairs(MapModData.buildingsAlive) do
		if not Map_GetCity(plotID) then
			MapModData.buildingsAlive[plotID] = nil
		end
	end
	if not MapModData.Cep_FreeFlavorBuilding then
		return
	end
	for flavorInfo in GameInfo.Flavors() do
		for plotID, data in pairs(MapModData.Cep_FreeFlavorBuilding[flavorInfo.Type]) do
			if not Map_GetCity(plotID) then
				MapModData.Cep_FreeFlavorBuilding[flavorInfo.Type][plotID] = false
				SaveValue(false, "MapModData.Cep_FreeFlavorBuilding[%s][%s]", flavorInfo.Type, plotID)
			end			
		end
	end
end

function OnCityDestroyed(hexPos, playerID, cityID, newPlayerID)
	LuaEvents.CheckPlotBuildingsStatus(Map.GetPlot(ToGridFromHex(hexPos.x, hexPos.y)))
end





---------------------------------------------------------------------
-- LuaEvents.PrintDebug()
--
function LuaEvents.PrintDebug()
	local text			= ""
	local turnTime		= Game.GetGameTurn() - MapModData.Cep_StartTurn
	local avgPlayers	= 0
	local avgCities		= 0
	local avgUnits		= 0
	if turnTime > 0 then
		avgPlayers = MapModData.Cep_TotalPlayers / turnTime
		avgCities = MapModData.Cep_TotalCities / turnTime
		avgUnits = MapModData.Cep_TotalUnits / turnTime
	else
		for playerID, player in pairs(Players) do
			if player:IsAliveCiv() then
				avgPlayers = avgPlayers + 1
				for city in player:Cities() do
					avgCities = avgCities + 1
				end
				for unit in player:Units() do
					avgUnits = avgUnits + 1
				end
			end
		end
	end
	
	text = string.format("%s\n\n============= Game Info =============\n\n", text)
	text = string.format("%s%14s %-s\n", text, "Map:", PreGame.GetMapScript())
	text = string.format("%s%14s %-s\n", text, "Leader:", GameInfo.Leaders[Players[Game.GetActivePlayer()]:GetLeaderType()].Type)
	text = string.format("%s%14s %-s\n", text, "Difficulty:", GameInfo.CepHandicapInfos[Game:GetHandicapType()].Type)
	text = string.format("%s%14s %-s\n", text, "Size:", Game.GetWorldInfo().Type)	
	text = string.format("%s%14s %-s%%%%\n", text, "Speed:", Game.GetSpeedInfo().VictoryDelayPercent)
	text = string.format("%s%14s %-s\n", text, "Animations:", tostring(OptionsManager.GetSinglePlayerQuickCombatEnabled_Cached()))
	text = string.format("%s%14s %-i\n", text, "Players:", avgPlayers)
	text = string.format("%s%14s %-i\n", text, "Cities:", avgCities)
	text = string.format("%s%14s %-i\n", text, "Units:", avgUnits)
	text = string.format("%s%14s %-i\n", text, "Plots:", Map.GetNumPlots())
	text = string.format("%s%14s %-i\n", text, "Start turn:", MapModData.Cep_StartTurn)
	text = string.format("%s%14s %-i\n", text, "End turn:", Game.GetGameTurn())

	text = string.format("%s\n\n==== Average Processing per Turn ====\n", text)
	if turnTime > 0 then		
		text = string.format("%s\n%14s %10s\n", text, "VanillaStuff", "seconds")
		text = string.format("%s%14s %10.3f seconds\n", text, "Total", MapModData.Cep_VanillaTurnTimes / turnTime)
		
		text = string.format("%s\n%14s %10s\n", text, "ModTurnStart", "seconds")
		text = string.format("%s%14s %10.3f\n", text, "Turn", MapModData.Cep_StartTurnTimes.Turn / turnTime)
		text = string.format("%s%14s %10.3f\n", text, "Players", MapModData.Cep_StartTurnTimes.Players / turnTime)
		text = string.format("%s%14s %10.3f\n", text, "Policies", MapModData.Cep_StartTurnTimes.Policies / turnTime)
		text = string.format("%s%14s %10.3f\n", text, "Cities", MapModData.Cep_StartTurnTimes.Cities / turnTime)
		text = string.format("%s%14s %10.3f\n", text, "Units", MapModData.Cep_StartTurnTimes.Units / turnTime)
		text = string.format("%s%14s %10.3f\n", text, "Plots", MapModData.Cep_StartTurnTimes.Plots / turnTime)
		text = string.format("%s%14s %10.3f\n", text, "Total", MapModData.Cep_StartTurnTimes.Total / turnTime)

		text = string.format("%s\n%14s %10s\n", text, "ModTurnEnd", "seconds")
		text = string.format("%s%14s %10.3f\n", text, "Turn", MapModData.Cep_EndTurnTimes.Turn / turnTime)
		text = string.format("%s%14s %10.3f\n", text, "Players", MapModData.Cep_EndTurnTimes.Players / turnTime)
		text = string.format("%s%14s %10.3f\n", text, "Policies", MapModData.Cep_EndTurnTimes.Policies / turnTime)
		text = string.format("%s%14s %10.3f\n", text, "Cities", MapModData.Cep_EndTurnTimes.Cities / turnTime)
		text = string.format("%s%14s %10.3f\n", text, "Units", MapModData.Cep_EndTurnTimes.Units / turnTime)
		text = string.format("%s%14s %10.3f\n", text, "Plots", MapModData.Cep_EndTurnTimes.Plots / turnTime)
		text = string.format("%s%14s %10.3f\n", text, "Total", MapModData.Cep_EndTurnTimes.Total / turnTime)
	end

	text = string.format("%s\n\n========= Player Yield Rates =========\n\n", text)
	local header = string.format(
		"%5s %5s %5s %5s %5s %-20s %-1s\n",
		"Gold",
		"Cul",
		"Sci",
		"Faith",
		"Happy",
		"Player",
		"Handicap"
	)
	text = text .. header
	for playerID = 0, GameDefines.MAX_CIV_PLAYERS-1, 1 do
		local player = Players[playerID];
		if player:IsEverAlive() and player:GetNumCities() > 0 then
			text = string.format(
				"%s%5s %5s %5s %5s %5s %-20s %-1s\n",
				text,
				Game.Round(player:GetYieldRate(YieldTypes.YIELD_GOLD)),
				Game.Round(player:GetYieldRate(YieldTypes.YIELD_CULTURE)),
				Game.Round(player:GetYieldRate(YieldTypes.YIELD_SCIENCE)),
				Game.Round(player:GetYieldRate(YieldTypes.YIELD_FAITH)),
				Game.Round(player:GetYieldRate(YieldTypes.YIELD_HAPPINESS_NATIONAL)),
				player:GetName(),
				GameInfo.CepHandicapInfos[player:GetHandicapType()].Type
			)
		end
	end

	text = string.format("%s\n\n========== City Yield Rates ==========\n\n", text)
	local header = string.format(
		"%5s %5s %5s %5s %5s %5s %5s %5s %-20s %-1s\n",
		"Food",
		"Gold",
		"Prod",
		"Cul",
		"Sci",
		"Faith",
		"AI",
		"Pop",
		"Player",
		"City"
	)
	text = text .. header
	local cityText = ""
	for playerID = 0, GameDefines.MAX_CIV_PLAYERS-1, 1 do
		local player = Players[playerID];
		if player:IsEverAlive() and player:GetNumCities() > 0 then
			local totalYield = {}
			local totalAIBonus = 0
			local totalCount = 0
			
			for city in player:Cities() do
				totalCount = totalCount + 1
				for yieldInfo in GameInfo.Yields() do
					totalYield[yieldInfo.ID] = (totalYield[yieldInfo.ID] or 0) + City_GetYieldRate(city, yieldInfo.ID)
				end
				totalYield[YieldTypes.YIELD_POPULATION] = (totalYield[YieldTypes.YIELD_POPULATION] or 0) + city:GetPopulation()
				totalAIBonus = totalAIBonus + City_GetNumBuilding(city, GameInfo.Buildings.BUILDING_AI_PRODUCTION.ID)
				cityText = string.format(
					"%s%5s %5s %5s %5s %5s %5s %5s %5s %-20s %-1s\n",
					cityText,
					Game.Round(City_GetYieldRate(city, YieldTypes.YIELD_FOOD)),
					Game.Round(City_GetYieldRate(city, YieldTypes.YIELD_GOLD)),
					Game.Round(City_GetYieldRate(city, YieldTypes.YIELD_PRODUCTION)),
					Game.Round(City_GetYieldRate(city, YieldTypes.YIELD_CULTURE)),
					Game.Round(City_GetYieldRate(city, YieldTypes.YIELD_SCIENCE)),
					Game.Round(City_GetYieldRate(city, YieldTypes.YIELD_FAITH)),
					City_GetNumBuilding(city, GameInfo.Buildings.BUILDING_AI_PRODUCTION.ID),
					city:GetPopulation(),
					player:GetName(),
					city:GetName()
				)
			end
			
			if totalCount ~= 0 then
				text = string.format(
					"%s%5s %5s %5s %5s %5s %5s %5s %5s %-20s %-1s\n",
					text,
					Game.Round(totalYield[YieldTypes.YIELD_FOOD] / totalCount),
					Game.Round(totalYield[YieldTypes.YIELD_GOLD] / totalCount),
					Game.Round(totalYield[YieldTypes.YIELD_PRODUCTION] / totalCount),
					Game.Round(totalYield[YieldTypes.YIELD_CULTURE] / totalCount),
					Game.Round(totalYield[YieldTypes.YIELD_SCIENCE] / totalCount),
					Game.Round(totalYield[YieldTypes.YIELD_FAITH] / totalCount),
					Game.Round(totalAIBonus / totalCount),
					Game.Round(totalYield[YieldTypes.YIELD_POPULATION] / totalCount),
					player:GetName(),
					"Average"
				)
			end
		end
	end

	text = string.format("%s\n%s%s", text, header, cityText)
	log:Info(text)
end