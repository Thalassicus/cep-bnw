-- MT_Plot
-- Author: Thalassicus
-- DateCreated: 2/29/2012 8:19:45 AM
--------------------------------------------------------------

include("MT_LuaLogger.lua")
local log = Events.LuaLogger:New()
log:SetLevel("WARN")

--print(string.format("Map.GetPlotByIndex(1) = %s", Map.GetPlotByIndex(1)))

--PlotClass	= getmetatable(Map.GetPlotByIndex(0)).__index


-- Plot_BuildImprovement(plot)
--
function Plot_BuildImprovement(plot, improveID)
    plot:SetImprovementType(improveID)
	local featureID = plot:GetFeatureType()
	if featureID == -1 then
		return
	end

	local improveType = GameInfo.Improvements[improveID].Type
	local featureType = GameInfo.Features[featureID].Type
	local buildType = Game.GetValue("Type", {ImprovementType=improveType}, GameInfo.Builds)
	if Game.GetValue("Remove", {BuildType=buildType, FeatureType=featureType}, GameInfo.BuildFeatures) then
		plot:SetFeatureType(FeatureTypes.NO_FEATURE, -1)
	end
end


-- Plot_Buy(player, plot, city, cost) purchases plot for player.
-- This avoids a vanilla bug: the same tile can have different costs when viewed from different cities.
--

function Plot_Buy(plot, player, city, cost)
	local playerID = player:GetID()
	player:ChangeYieldStored(YieldTypes.YIELD_GOLD, -cost)
	plot:SetOwner(playerID, city:GetID())
	MapModData.Cep_PlotCostExtra[playerID] = MapModData.Cep_PlotCostExtra[playerID] + GameDefines.PLOT_ADDITIONAL_COST_PER_PLOT
	SaveValue(MapModData.Cep_PlotCostExtra[playerID], "MapModData.Cep_PlotCostExtra[%s]", playerID)
end

function Plot_CanBuy(city, plot, notCheckGold)
	--local hex = ToHexFromGrid(Vector2(plot:GetX(), plot:GetY()))
	return city:CanBuyPlotAt(plot:GetX(), plot:GetY(), notCheckGold)
end

function Plot_GetCost(city, plot)
	if Plot_CanBuy(city, plot, true) then
		return city:GetBuyPlotCost(plot:GetX(), plot:GetY()) + MapModData.Cep_PlotCostExtra[city:GetOwner()]
	end
	return math.huge
end

if not MapModData.Cep_PlotCostExtra then
	MapModData.Cep_PlotCostExtra = {}
	startClockTime = os.clock()
	for playerID, player in pairs(Players) do
		if UI.IsLoadedGame() then
			MapModData.Cep_PlotCostExtra[playerID] = LoadValue("MapModData.Cep_PlotCostExtra[%s]", playerID) or 0
		else
			MapModData.Cep_PlotCostExtra[playerID] = 0
		end
	end
	if UI:IsLoadedGame() then
		log:Info("%3s ms loading PlotCostExtra", Game.Round((os.clock() - startClockTime)*1000))
	end
end
	

--
--
function Plot_FindPlotType(startPlot, plotType)
	local hex = ToHexFromGrid( Vector2(startPlot:GetX(), startPlot:GetY()) )
	
	local directions = {
		Vector2(  0,  1),
		Vector2( -1,  0),
		Vector2(  1, -1),
		Vector2(  0, -1),
		Vector2(  1,  0),
		Vector2( -1,  1)
	}

	for _, vecJ in ipairs(directions) do
		local hexJ = VecAdd(hex, vecJ)		
		for _, vecK in ipairs(directions) do
			local hexK = VecAdd(hexJ, vecK)
			local targetPlot = Map.GetPlot(ToGridFromHex(hexK.x, hexK.y))
			
			if targetPlot and targetPlot:GetPlotType() == PlotTypes[plotType] then
				return targetPlot
			end
		end
	end
	return startPlot
end


--[[ Plot_GetCombatUnit(plot) usage example:
local capturingUnit = Plot_GetCombatUnit(plot)
]]

function Plot_GetCombatUnit(plot)
    local lostCityPlot = Map.GetPlot( ToGridFromHex( plot.x, plot.y ) )
	local count = lostCityPlot:GetNumUnits()
	for i = 0, count - 1 do
		local pUnit = lostCityPlot:GetUnit( i )
		if Unit_IsCombatDomain(pUnit, "DOMAIN_LAND") then
			return pUnit
		end
	end
	return nil
end


--[[ Plot_GetAreaWeights(centerPlot, minRadius, maxRadius) usage example:

areaWeights = Plot_GetAreaWeights(plot, 2, 2)
if (areaWeights.PLOT_LAND + areaWeights.PLOT_HILLS) <= 0.25 then
	return
end
]]

local plotTypeName		= {}-- -1="NO_PLOT"}
local terrainTypeName	= {}-- -1="NO_TERRAIN"}
local featureTypeName	= {}-- -1="NO_FEATURE"}

--function InitAreaWeightValues()
	for k, v in pairs(PlotTypes) do
		plotTypeName[v] = k
	end
	for itemInfo in GameInfo.Terrains() do
		terrainTypeName[itemInfo.ID] = itemInfo.Type
	end
	for itemInfo in GameInfo.Features() do
		featureTypeName[itemInfo.ID] = itemInfo.Type
	end
--end

--[[
if not MapModData.Cep_InitAreaWeightValues then
	MapModData.Cep_InitAreaWeightValues = true
	LuaEvents.MT_Initialize.Add(InitAreaWeightValues)
end
--]]

function Plot_GetAreaWeights(plot, minR, maxR)
	local weights = {TOTAL=0, SEA=0, NO_PLOT=0, NO_TERRAIN=0, NO_FEATURE=0}
	
	for k, v in pairs(PlotTypes) do
		weights[k] = 0
	end
	for itemInfo in GameInfo.Terrains() do
		weights[itemInfo.Type] = 0
	end
	for itemInfo in GameInfo.Features() do
		weights[itemInfo.Type] = 0
	end
	
	for adjPlot in Plot_GetPlotsInCircle(plot, minR, maxR) do
		local distance		 = Map.PlotDistance(adjPlot:GetX(), adjPlot:GetY(), plot:GetX(), plot:GetY())
		local adjWeight		 = (distance == 0) and 6 or (1/distance)
		local plotType		 = plotTypeName[adjPlot:GetPlotType()]
		local terrainType	 = terrainTypeName[adjPlot:GetTerrainType()]
		local featureType	 = featureTypeName[adjPlot:GetFeatureType()] or "NO_FEATURE"
		
		weights.TOTAL		 = weights.TOTAL		+ adjWeight 
		weights[plotType]	 = weights[plotType]	+ adjWeight
		weights[terrainType] = weights[terrainType]	+ adjWeight
		weights[featureType] = weights[featureType]	+ adjWeight
				
		if plotType == "PLOT_OCEAN" then
			if not adjPlot:IsLake() and featureType ~= "FEATURE_ICE" then
				weights.SEA = weights.SEA + adjWeight
			end
		end
	end
	
	if weights.TOTAL == 0 then
		log:Fatal("plot:GetAreaWeights Total=0! x=%s y=%s", x, y)
	end
	for k, v in pairs(weights) do
		if k ~= "TOTAL" then
			weights[k] = weights[k] / weights.TOTAL
		end
	end
	
	return weights
end


--[[ Plot_GetID(plot) usage example:
MapModData.buildingsAlive[Plot_GetID(city:Plot())][buildingID] = true
]]
function Plot_GetID(plot)
	if not plot then
		log:Fatal("plot:GetID plot=nil")
		return nil
	end
	local iW, iH = Map.GetGridSize()
	return plot:GetY() * iW + plot:GetX()
end


--[[ Plot_GetNearestOceanPlot(centerPlot, radius, minArea) usage example:

]]
function Plot_GetNearestOceanPlot(centerPlot, maxRange)
	local oceanPlot = nil
	local minDistance = 999
	local maxArea = 0
	for nearPlot, distance in Plot_GetPlotsInCircle(centerPlot, maxRange) do
		if nearPlot:IsWater() and not nearPlot:IsLake() then
			local nearArea = nearPlot:Area():GetNumTiles()
			if nearArea > maxArea or (nearArea == maxArea and distance < minDistance) then
				oceanPlot = nearPlot
				minDistance = distance
				maxArea = nearArea
			end
		end
	end
	return oceanPlot
end


function Plot_GetPlotsInCircle(plot, minR, maxR)
	--[[ Plot_GetPlotsInCircle(plot, minR, [maxR]) usage examples:
	for nearPlot in Plot_GetPlotsInCircle(plot, 0, 4) do
		-- check all plots in radius 0-4
		nearPlot:GetX()
	end
	for nearPlot, distance in Plot_GetPlotsInCircle(plot, 3) do
		-- check all plots in radius 1-3
		if distance == 3 then
			print(nearPlot:GetX())
		end
	end
	]]
	if not plot then
		print("plot:GetPlotsInCircle plot=nil")
		return
	end
	if not maxR then
		maxR = minR
		minR = 1
	end
	
	local mapW, mapH	= Map.GetGridSize()
	local isWrapX		= Map:IsWrapX()
	local isWrapY		= Map:IsWrapY()
	local centerX		= plot:GetX()
	local centerY		= plot:GetY()
	
	leftX	= isWrapX and ((centerX-maxR) % mapW) or Game.Constrain(0, centerX-maxR, mapW-1)
	rightX	= isWrapX and ((centerX+maxR) % mapW) or Game.Constrain(0, centerX+maxR, mapW-1)
	bottomY	= isWrapY and ((centerY-maxR) % mapH) or Game.Constrain(0, centerY-maxR, mapH-1)
	topY	= isWrapY and ((centerY+maxR) % mapH) or Game.Constrain(0, centerY+maxR, mapH-1)
	
	local nearX	= leftX
	local nearY	= bottomY
	local stepX	= 0
	local stepY	= 0
	local rectW	= rightX-leftX 
	local rectH	= topY-bottomY
	
	if rectW < 0 then
		rectW = rectW + mapW
	end
	
	if rectH < 0 then
		rectH = rectH + mapH
	end
	
	local nextPlot = Map.GetPlot(nearX, nearY)
	
	return function ()
		while (stepY < 1 + rectH) and nextPlot do
			while (stepX < 1 + rectW) and nextPlot do
				local plot		= nextPlot
				local distance	= Map.PlotDistance(nearX, nearY, centerX, centerY)
				
				nearX		= (nearX + 1) % mapW
				stepX		= stepX + 1
				nextPlot	= Map.GetPlot(nearX, nearY)
				
				if Game.IsBetween(minR, distance, maxR) then
					return plot, distance
				end
			end
			nearX		= leftX
			nearY		= (nearY + 1) % mapH
			stepX		= 0
			stepY		= stepY + 1
			nextPlot	= Map.GetPlot(nearX, nearY)
		end
	end
end


-- Plot_GetFertility(plot) usage example:
basicYields = {
	YieldTypes.YIELD_FOOD,
	YieldTypes.YIELD_PRODUCTION,
	YieldTypes.YIELD_GOLD,
	YieldTypes.YIELD_SCIENCE,
	YieldTypes.YIELD_CULTURE,
	YieldTypes.YIELD_FAITH
}
function Plot_GetFertilityInRange(plot, range)
	local value = 0
	for adjPlot in Plot_GetPlotsInCircle(plot, range) do
		value = value + Plot_GetFertility(adjPlot) / (math.max(1, Map.PlotDistance(adjPlot:GetX(), adjPlot:GetY(), plot:GetX(), plot:GetY())))
	end
	return value
end
function Plot_GetFertility(plot)
	local value = 0
	--
	if plot:IsImpassable() or plot:GetTerrainType() == TerrainTypes.TERRAIN_OCEAN then
		return value
	end
	
	for _, yieldID in pairs(basicYields) do
		value = value + plot:CalculateYield(yieldID, true)
	end
	
	if plot:IsFreshWater() then
		value = value + 1
	end

	local featureID = plot:GetFeatureType()
	if featureID == FeatureTypes.FEATURE_FOREST then
		value = value + 1
	end
	
	local resID = plot:GetResourceType()
	if resID == -1 then
		if featureID == -1 and plot:GetTerrainType() == TerrainTypes.TERRAIN_COAST then
			-- can't do much with these tiles in BNW
			value = value - 0.5
		end
	else
		local resInfo = GameInfo.Resources[resID]
		value = value + 4 * resInfo.Happiness
		if resInfo.ResourceClassType == "RESOURCECLASS_RUSH" then
			value = value + math.ceil(5 * math.sqrt(plot:GetNumResource()))
		elseif resInfo.ResourceClassType == "RESOURCECLASS_BONUS" then
			value = value + 2
		end
	end
	--]]
	return value
end


--[[ Plot_IsFlatDesert(plot) usage example:

]]
function Plot_IsFlatDesert(plot)
	return (plot:GetPlotType() == PlotTypes.PLOT_LAND and plot:GetTerrainType() == TerrainTypes.TERRAIN_DESERT and plot:GetFeatureType() == -1)
end


----------------------------------------------------
function Plot_IsNearHuman(plot, radius)
	if plot:IsVisibleToWatchingHuman() then
		return true
	end
	local x = plot:GetX()
	local y = plot:GetY()
	for playerID, player in pairs(Players) do
		if player:IsAliveCiv() and player:IsHuman() then
			for city in player:Cities() do
				if Map.PlotDistance(x, y, city:Plot():GetX(), city:Plot():GetY()) <= radius then
					return true
				end
			end
			for unit in player:Units() do
				if Map.PlotDistance(x, y, unit:GetPlot():GetX(), unit:GetPlot():GetY()) <= radius then
					return true
				end
			end
		end
	end
	return false
end