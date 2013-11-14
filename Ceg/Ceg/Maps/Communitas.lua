--[[------------------------------------------------------------------------------

Communitas.lua map script created by:
- Rich Marinaccio
- Bob Thomas
- Thalassicus

This map script generates climate based on a simplified model of geostrophic
and monsoon wind patterns. Rivers are generated along accurate drainage paths
governed by the elevation map used to create the landforms.

In addition to PerfectWorld features, this map includes:
- Natural wonders appear in useful locations.
- Island chains for offshore settlement.
- Ocean rifts so triremes can't navigate the whole world.
- Lakes, and rivers flowing out of lakes.
- Terrain proportions more closely matching vanilla, with less rough terrain (hills/forest/jungle).

--]]------------------------------------------------------------------------------

include("MapGenerator")
include("FeatureGenerator")
include("TerrainGenerator")
include("IslandMaker")

MapConstants = {}

local debugTime = false


function MapConstants:New()
	local mconst = {}
	setmetatable(mconst, self)
	self.__index = self

	--Percent of land tiles on the map.
	mconst.landPercent			= 0.35 --0.28

	--Top and bottom map latitudes.
	mconst.topLatitude			= 70
	mconst.bottomLatitude		= -70

	--Important latitude markers used for generating climate.
	mconst.tropicLatitudes		= 23 --23
	mconst.horseLatitudes		= 30 --28
	mconst.polarFrontLatitude	= 60 --60
	
	-- need open terrain for horses
	mconst.mountainsPercent		= 0.95 --0.85	--Percent of dry land that is below the mountain elevation deviance threshold.
	mconst.hillsPercent			= 0.80 --0.50	--Percent of dry land that is below the hill elevation deviance threshold.
	mconst.hillsBlendPercent	= 0.33 --0.00	--Chance for flat land to become hills per adjacent mountain. Requires at least 2 adjacent mountains.
	
	mconst.featurePercent		= 0.80 --1.00	--Percent of potential feature tiles that actually spawn a feature (marsh/jungle/forest)
	mconst.featureWetVariance	= 0.10 --0.00	--Percent chance increase if freshwater, decrease if dry (groups features near rivers)
	
	mconst.marshPercent			= 0.05 --		--Percent chance increase for marsh, from each adjacent watery tile
	mconst.junglePercent		= 0.75 --0.75	--Percent of land below the jungle rainfall threshold.
	mconst.plainsPercent		= 0.56 --0.56	--Percent of land that is below the plains rainfall threshold.
	mconst.zeroTreesPercent		= 0.30 --0.30	--Percent of land that is below the rainfall threshold where no trees can appear.
	mconst.desertPercent		= 0.30 --0.36	--Percent of land that is below the desert rainfall threshold.
	
	mconst.forestRandomPercent	= 0.10 --0.00	--Percent of barren plains and tundra which randomly spawn a forest
	mconst.forestWetVariance	= 0.00 --0.00	--Percent chance for feature increase if freshwater, decrease if dry (clusters features near rivers)
	mconst.jungleMinTemperature	= 0.70 --0.70	--Coldest absolute temperature allowed to be jungle, forest if colder.
	mconst.desertMinTemperature	= 0.40 --0.34	--Coldest absolute temperature allowed to be desert, plains if colder.
	mconst.tundraTemperature	= 0.35 --0.30	--Absolute temperature below which is tundra.
	mconst.treesMinTemperature	= 0.25 --0.27	--Coldest absolute temperature where trees appear.
	mconst.snowTemperature		= 0.25 --0.25	--Absolute temperature below which is snow.
	
	

	--North and south ice latitude limits.
	mconst.iceNorthLatitudeLimit = 60
	mconst.iceSouthLatitudeLimit = -60

	--North and south atoll latitude limits.
	mconst.atollNorthLatitudeLimit = 80
	mconst.atollSouthLatitudeLimit = -80
	mconst.atollMinDeepWaterNeighbors = 0

	--percent of river junctions that are large enough to become rivers.
	mconst.riverPercent = 0.10 --0.19

	--This value is multiplied by each river step. Values greater than one favor
	--watershed size. Values less than one favor actual rain amount.
	mconst.riverRainCheatFactor = 2 --1.6

	--These attenuation factors lower the altitude of the map edges. This is
	--currently used to prevent large continents in the uninhabitable polar
	--regions. East/west attenuation is set to zero, but modded maps may
	--have need for them.
	mconst.northAttenuationFactor = 0.75
	mconst.northAttenuationRange = 0.15 --percent of the map height.
	mconst.southAttenuationFactor = 0.75
	mconst.southAttenuationRange = 0.15

	--east west attenuation may be desired for flat maps.
	mconst.eastAttenuationFactor = 0.0
	mconst.eastAttenuationRange = 0.0 --percent of the map width.
	mconst.westAttenuationFactor = 0.0
	mconst.westAttenuationRange = 0.0

	--These set the water temperature compression that creates the land/sea
	--seasonal temperature differences that cause monsoon winds.
	mconst.minWaterTemp = 0.10
	mconst.maxWaterTemp = 0.60

	--Strength of geostrophic climate generation versus monsoon climate generation.
	mconst.geostrophicFactor = 3.0

	mconst.geostrophicLateralWindStrength = 0.6

	--Fill in any lakes smaller than this. It looks bad to have large
	--river systems flowing into a tiny lake.
	mconst.minOceanSize = 10 --50

	--Weight of the mountain elevation map versus the coastline elevation map.
	mconst.mountainWeight = 0.8

	--Crazy rain tweaking variables. I wouldn't touch these if I were you.
	mconst.minimumRainCost = 0.0001
	mconst.upLiftExponent = 4
	mconst.polarRainBoost = 0.00
	mconst.pressureNorm = 0.9 --[1.0 = no normalization] Helps to prevent exaggerated Jungle/Marsh banding on the equator. -Bobert13

	--default frequencies for map of width 128. Adjusting these frequences
	--will generate larger or smaller map features.
	mconst.twistMinFreq = 0.02
	mconst.twistMaxFreq = 0.12
	mconst.twistVar = 0.042
	mconst.mountainFreq = 0.078

	--mconst.useCivRands = true --not ready for this yet

	-----------------------------------------------------------------------
	--Below are map constants that should not be altered.

	--directions
	mconst.C = 0
	mconst.W = 1
	mconst.NW = 2
	mconst.NE = 3
	mconst.E = 4
	mconst.SE = 5
	mconst.SW = 6

	--flow directions
	mconst.NOFLOW = 0
	mconst.WESTFLOW = 1
	mconst.EASTFLOW = 2
	mconst.VERTFLOW = 3

	--wind zones
	mconst.NOZONE = -1
	mconst.NPOLAR = 0
	mconst.NTEMPERATE = 1
	mconst.NEQUATOR = 2
	mconst.SEQUATOR = 3
	mconst.STEMPERATE = 4
	mconst.SPOLAR = 5

	--Hex maps are shorter in the y direction than they are
	--wide per unit by this much. We need to know this to sample the perlin
	--maps properly so they don't look squished.
	mconst.YtoXRatio = 1.5/(math.sqrt(0.75) * 2)
	
	mconst.tropicalPlots = {}
	mconst.oceanRiftPlots = {}

	return mconst
end

function MapConstants:GetOppositeDir(dir)
	return ((dir + 2) % 6) + 1
end




---------------------------------------------------------------------
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
--end

--[[
if not MapModData.Cep.InitAreaWeightValues then
	MapModData.Cep.InitAreaWeightValues = true
	LuaEvents.MT_Initialize.Add(InitAreaWeightValues)
end
--]]

function Plot_GetAreaWeights(plot, minR, maxR)
	for k, v in pairs(PlotTypes) do
		plotTypeName[v] = k
	end
	for itemInfo in GameInfo.Terrains() do
		terrainTypeName[itemInfo.ID] = itemInfo.Type
	end
	for itemInfo in GameInfo.Features() do
		featureTypeName[itemInfo.ID] = itemInfo.Type
	end
	
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
	
	for _, adjPlot in pairs(Plot_GetPlotsInCircle(plot, minR, maxR)) do
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
---------------------------------------------------------------------

--Returns a value along a bell curve from a 0 - 1 range
function MapConstants:GetBellCurve(value)
	return math.sin(value * math.pi * 2 - math.pi * 0.5) * 0.5 + 0.5
end

-----------------------------------------------------------------------------
--Interpolation and Perlin functions
-----------------------------------------------------------------------------
function CubicInterpolate(v0,v1,v2,v3,mu)
	local mu2 = mu * mu
	local a0 = v3 - v2 - v0 + v1
	local a1 = v0 - v1 - a0
	local a2 = v2 - v0
	local a3 = v1

	return (a0 * mu * mu2 + a1 * mu2 + a2 * mu + a3)
end

function BicubicInterpolate(v,muX,muY)
	local a0 = CubicInterpolate(v[1],v[2],v[3],v[4],muX)
	local a1 = CubicInterpolate(v[5],v[6],v[7],v[8],muX)
	local a2 = CubicInterpolate(v[9],v[10],v[11],v[12],muX)
	local a3 = CubicInterpolate(v[13],v[14],v[15],v[16],muX)

	return CubicInterpolate(a0,a1,a2,a3,muY)
end

function CubicDerivative(v0,v1,v2,v3,mu)
	local mu2 = mu * mu
	local a0 = v3 - v2 - v0 + v1
	local a1 = v0 - v1 - a0
	local a2 = v2 - v0
	--local a3 = v1

	return (3 * a0 * mu2 + 2 * a1 * mu + a2)
end

function BicubicDerivative(v,muX,muY)
	local a0 = CubicInterpolate(v[1],v[2],v[3],v[4],muX)
	local a1 = CubicInterpolate(v[5],v[6],v[7],v[8],muX)
	local a2 = CubicInterpolate(v[9],v[10],v[11],v[12],muX)
	local a3 = CubicInterpolate(v[13],v[14],v[15],v[16],muX)

	return CubicDerivative(a0,a1,a2,a3,muY)
end

--This function gets a smoothly interpolated value from srcMap.
--x and y are non-integer coordinates of where the value is to
--be calculated, and wrap in both directions. srcMap is an object
--of type FloatMap.
function GetInterpolatedValue(X,Y,srcMap)
	local points = {}
	local fractionX = X - math.floor(X)
	local fractionY = Y - math.floor(Y)

	--wrappedX and wrappedY are set to -1,-1 of the sampled area
	--so that the sample area is in the middle quad of the 4x4 grid
	local wrappedX = ((math.floor(X) - 1) % srcMap.rectWidth) + srcMap.rectX
	local wrappedY = ((math.floor(Y) - 1) % srcMap.rectHeight) + srcMap.rectY

	local x
	local y

	for pY = 0, 4-1 do
		y = pY + wrappedY
		for pX = 0,4-1 do
			x = pX + wrappedX
			local srcIndex = srcMap:GetRectIndex(x, y)
			points[(pY * 4 + pX) + 1] = srcMap.data[srcIndex]
		end
	end

	local finalValue = BicubicInterpolate(points,fractionX,fractionY)

	return finalValue

end

function GetDerivativeValue(X,Y,srcMap)
	local points = {}
	local fractionX = X - math.floor(X)
	local fractionY = Y - math.floor(Y)

	--wrappedX and wrappedY are set to -1,-1 of the sampled area
	--so that the sample area is in the middle quad of the 4x4 grid
	local wrappedX = ((math.floor(X) - 1) % srcMap.rectWidth) + srcMap.rectX
	local wrappedY = ((math.floor(Y) - 1) % srcMap.rectHeight) + srcMap.rectY

	local x
	local y

	for pY = 0, 4-1 do
		y = pY + wrappedY
		for pX = 0,4-1 do
			x = pX + wrappedX
			local srcIndex = srcMap:GetRectIndex(x, y)
			points[(pY * 4 + pX) + 1] = srcMap.data[srcIndex]
		end
	end

	local finalValue = BicubicDerivative(points,fractionX,fractionY)

	return finalValue

end

--This function gets Perlin noise for the destination coordinates. Note
--that in order for the noise to wrap, the area sampled on the noise map
--must change to fit each octave.
function GetPerlinNoise(x,y,destMapWidth,destMapHeight,initialFrequency,initialAmplitude,amplitudeChange,octaves,noiseMap)
	local finalValue = 0.0
	local frequency = initialFrequency
	local amplitude = initialAmplitude
	local frequencyX --slight adjustment for seamless wrapping
	local frequencyY --''
	for i = 1,octaves do
		if noiseMap.wrapX then
			noiseMap.rectX = math.floor(noiseMap.width/2 - (destMapWidth * frequency)/2)
			noiseMap.rectWidth = math.max(math.floor(destMapWidth * frequency),1)
			frequencyX = noiseMap.rectWidth/destMapWidth
		else
			noiseMap.rectX = 0
			noiseMap.rectWidth = noiseMap.width
			frequencyX = frequency
		end
		if noiseMap.wrapY then
			noiseMap.rectY = math.floor(noiseMap.height/2 - (destMapHeight * frequency)/2)
			noiseMap.rectHeight = math.max(math.floor(destMapHeight * frequency),1)
			frequencyY = noiseMap.rectHeight/destMapHeight
		else
			noiseMap.rectY = 0
			noiseMap.rectHeight = noiseMap.height
			frequencyY = frequency
		end

		finalValue = finalValue + GetInterpolatedValue(x * frequencyX, y * frequencyY, noiseMap) * amplitude
		frequency = frequency * 2.0
		amplitude = amplitude * amplitudeChange
	end
	finalValue = finalValue/octaves
	return finalValue
end

function GetPerlinDerivative(x,y,destMapWidth,destMapHeight,initialFrequency,initialAmplitude,amplitudeChange,octaves,noiseMap)
	local finalValue = 0.0
	local frequency = initialFrequency
	local amplitude = initialAmplitude
	local frequencyX --slight adjustment for seamless wrapping
	local frequencyY --''
	for i = 1,octaves do
		if noiseMap.wrapX then
			noiseMap.rectX = math.floor(noiseMap.width/2 - (destMapWidth * frequency)/2)
			noiseMap.rectWidth = math.floor(destMapWidth * frequency)
			frequencyX = noiseMap.rectWidth/destMapWidth
		else
			noiseMap.rectX = 0
			noiseMap.rectWidth = noiseMap.width
			frequencyX = frequency
		end
		if noiseMap.wrapY then
			noiseMap.rectY = math.floor(noiseMap.height/2 - (destMapHeight * frequency)/2)
			noiseMap.rectHeight = math.floor(destMapHeight * frequency)
			frequencyY = noiseMap.rectHeight/destMapHeight
		else
			noiseMap.rectY = 0
			noiseMap.rectHeight = noiseMap.height
			frequencyY = frequency
		end

		finalValue = finalValue + GetDerivativeValue(x * frequencyX, y * frequencyY, noiseMap) * amplitude
		frequency = frequency * 2.0
		amplitude = amplitude * amplitudeChange
	end
	finalValue = finalValue/octaves
	return finalValue
end

function Push(a,item)
	table.insert(a,item)
end

function Pop(a)
	return table.remove(a)
end
------------------------------------------------------------------------
--inheritance mechanism from http://www.gamedev.net/community/forums/topic.asp?topic_id=561909
------------------------------------------------------------------------
function inheritsFrom( baseClass )

    local new_class = {}
    local class_mt = { __index = new_class }

    function new_class:create()
        local newinst = {}
        setmetatable( newinst, class_mt )
        return newinst
    end

    if nil ~= baseClass then
        setmetatable( new_class, { __index = baseClass } )
    end

    -- Implementation of additional OO properties starts here --

    -- Return the class object of the instance
    function new_class:class()
        return new_class
    end

	-- Return the super class object of the instance, optional base class of the given class (must be part of hiearchy)
    function new_class:baseClass(class)
		return new_class:_B(class)
    end

    -- Return the super class object of the instance, optional base class of the given class (must be part of hiearchy)
    function new_class:_B(class)
		if (class==nil) or (new_class==class) then
			return baseClass
		elseif(baseClass~=nil) then
			return baseClass:_B(class)
		end
		return nil
    end

	-- Return true if the caller is an instance of theClass
    function new_class:_ISA( theClass )
        local b_isa = false

        local cur_class = new_class

        while ( nil ~= cur_class ) and ( false == b_isa ) do
            if cur_class == theClass then
                b_isa = true
            else
                cur_class = cur_class:baseClass()
            end
        end

        return b_isa
    end

    return new_class
end

-----------------------------------------------------------------------------
-- Random functions will use lua rands for stand alone script running
-- and Map.rand for in game.
-----------------------------------------------------------------------------
function PWRand()
	if Map then
		return Map.Rand(10000, "Random - Lua") / 10000
	end
	return math.random()
end

function PWRandSeed(fixedseed)
	local seed
	if fixedseed == nil then
		seed = Map.Rand(2147483647,"") --This function caps at this number, if you set it any higher, or try to trick it with multiple RNGs that end up with a value above this, it will break randomization. This is 31 bits of precision so... - Bobert13
	else
		seed = fixedseed
	end
	math.randomseed(seed)
	print("random seed for this map is " .. seed)
end

--range is inclusive, low and high are possible results
function PWRandint(low, high)
	return math.random(low, high)
end
-----------------------------------------------------------------------------
-- FloatMap class
-- This is for storing 2D map data. The 'data' field is a zero based, one
-- dimensional array. To access map data by x and y coordinates, use the
-- GetIndex method to obtain the 1D index, which will handle any needs for
-- wrapping in the x and y directions.
-----------------------------------------------------------------------------
FloatMap = inheritsFrom(nil)

function FloatMap:New(width, height, wrapX, wrapY)
	local new_inst = {}
	setmetatable(new_inst, {__index = FloatMap})	--setup metatable

	new_inst.width = width
	new_inst.height = height
	new_inst.wrapX = wrapX
	new_inst.wrapY = wrapY
	new_inst.length = width*height

	--These fields are used to access only a subset of the map
	--with the GetRectIndex function. This is useful for
	--making Perlin noise wrap without generating separate
	--noise fields for each octave
	new_inst.rectX = 0
	new_inst.rectY = 0
	new_inst.rectWidth = width
	new_inst.rectHeight = height

	new_inst.data = {}
	for i = 0,width*height - 1 do
		new_inst.data[i] = 0.0
	end

	return new_inst
end

function FloatMap:GetNeighbor(x,y,dir)
	local xx
	local yy
	local odd = y % 2
	if dir == mc.C then
		return x,y
	elseif dir == mc.W then
		xx = x - 1
		yy = y
		return xx,yy
	elseif dir == mc.NW then
		xx = x - 1 + odd
		yy = y + 1
		return xx,yy
	elseif dir == mc.NE then
		xx = x + odd
		yy = y + 1
		return xx,yy
	elseif dir == mc.E then
		xx = x + 1
		yy = y
		return xx,yy
	elseif dir == mc.SE then
		xx = x + odd
		yy = y - 1
		return xx,yy
	elseif dir == mc.SW then
		xx = x - 1 + odd
		yy = y - 1
		return xx,yy
	else
		error("Bad direction in FloatMap:GetNeighbor")
	end
	return -1,-1
end

function FloatMap:GetIndex(x,y)
	if not self.wrapY and (y < 0 or y > self.height-1) then
		return -1
	elseif not self.wrapX and (x < 0 or x > self.width-1) then
		return -1
	end

	return (y % self.height) * self.width + (x % self.width)
end

function FloatMap:GetXYFromIndex(i)
	local x = i % self.width
	local y = (i - x)/self.width
	return x,y
end

--quadrants are labeled
--A B
--D C
function FloatMap:GetQuadrant(x,y)
	if x < self.width/2 then
		if y < self.height/2 then
			return "A"
		else
			return "D"
		end
	else
		if y < self.height/2 then
			return "B"
		else
			return "C"
		end
	end
end

--Gets an index for x and y based on the current
--rect settings. x and y are local to the defined rect.
--Wrapping is assumed in both directions
function FloatMap:GetRectIndex(x,y)
	local xx = x % self.rectWidth
	local yy = y % self.rectHeight

	xx = self.rectX + xx
	yy = self.rectY + yy

	return self:GetIndex(xx,yy)
end

function FloatMap:Normalize()
	--find highest and lowest values
	local maxAlt = -1000.0
	local minAlt = 1000.0
	for i = 0,self.length - 1 do
		local alt = self.data[i]
		if alt > maxAlt then
			maxAlt = alt
		end
		if alt < minAlt then
			minAlt = alt
		end

	end
	--subtract minAlt from all values so that
	--all values are zero and above
	for i = 0, self.length - 1, 1 do
		self.data[i] = self.data[i] - minAlt
	end

	--subract minAlt also from maxAlt
	maxAlt = maxAlt - minAlt

	--determine and apply scaler to whole map
	local scaler
	if maxAlt == 0.0 then
		scaler = 0.0
	else
		scaler = 1.0/maxAlt
	end

	for i = 0,self.length - 1 do
		self.data[i] = self.data[i] * scaler
	end

end

function FloatMap:GenerateNoise()
	for i = 0,self.length - 1 do
		self.data[i] = PWRand()
	end

end

function FloatMap:GenerateBinaryNoise()
	for i = 0,self.length - 1 do
		if PWRand() > 0.5 then
			self.data[i] = 1
		else
			self.data[i] = 0
		end
	end

end

function FloatMap:FindThresholdFromPercent(percent, greaterThan, excludeZeros)
	local mapList = {}
	local percentage = percent * 100

	if greaterThan then
		percentage = 100 - percentage
	end

	if percentage >= 100 then
		return 1.01 --whole map
	elseif percentage <= 0 then
		return -0.01 --none of the map
	end

	for i = 0,self.length - 1 do
		if not (self.data[i] == 0.0 and excludeZeros) then
			table.insert(mapList,self.data[i])
		end
	end

	table.sort(mapList, function (a,b) return a < b end)
	local threshIndex = math.floor((#mapList * percentage)/100)

	return mapList[threshIndex - 1]

end

function FloatMap:GetLatitudeForY(y)
	local range = mc.topLatitude - mc.bottomLatitude
	local lat = nil
	if y < self.height/2 then
		lat = (y+1) / self.height * range + (mc.bottomLatitude - mc.topLatitude / self.height)
	else
		lat = y / self.height * range + (mc.bottomLatitude + mc.topLatitude / self.height)
	end
	return lat
end

function FloatMap:GetYForLatitude(lat)
	local range = mc.topLatitude - mc.bottomLatitude
	return math.floor(((lat - mc.bottomLatitude) /range * self.height) + 0.5)
end

function FloatMap:GetZone(y)
	local lat = self:GetLatitudeForY(y)
	if y < 0 or y >= self.height then
		return mc.NOZONE
	end
	if lat > mc.polarFrontLatitude then
		return mc.NPOLAR
	elseif lat >= mc.horseLatitudes then
		return mc.NTEMPERATE
	elseif lat >= 0.0 then
		return mc.NEQUATOR
	elseif lat > -mc.horseLatitudes then
		return mc.SEQUATOR
	elseif lat >= -mc.polarFrontLatitude then
		return mc.STEMPERATE
	else
		return mc.SPOLAR
	end
end

function FloatMap:GetYFromZone(zone, bTop)
	if bTop then
		for y=self.height - 1,0,-1 do
			if zone == self:GetZone(y) then
				return y
			end
		end
	else
		for y=0,self.height - 1 do
			if zone == self:GetZone(y) then
				return y
			end
		end
	end
	return -1
end

function FloatMap:GetGeostrophicWindDirections(zone)

	if zone == mc.NPOLAR then
		return mc.SW,mc.W
	elseif zone == mc.NTEMPERATE then
		return mc.NE,mc.E
	elseif zone == mc.NEQUATOR then
		return mc.SW,mc.W
	elseif zone == mc.SEQUATOR then
		return mc.NW,mc.W
	elseif zone == mc.STEMPERATE then
		return mc.SE, mc.E
	else
		return mc.NW,mc.W
	end
	return -1,-1
end

function FloatMap:GetGeostrophicPressure(lat)
	local latRange = nil
	local latPercent = nil
	local pressure = nil
	if lat > mc.polarFrontLatitude then
		latRange = 90.0 - mc.polarFrontLatitude
		latPercent = (lat - mc.polarFrontLatitude)/latRange
		pressure = 1.0 - latPercent
	elseif lat >= mc.horseLatitudes then
		latRange = mc.polarFrontLatitude - mc.horseLatitudes
		latPercent = (lat - mc.horseLatitudes)/latRange
		pressure = latPercent
	elseif lat >= 0.0 then
		latRange = mc.horseLatitudes - 0.0
		latPercent = (lat - 0.0)/latRange
		pressure = 1.0 - latPercent
	elseif lat > -mc.horseLatitudes then
		latRange = 0.0 + mc.horseLatitudes
		latPercent = (lat + mc.horseLatitudes)/latRange
		pressure = latPercent
	elseif lat >= -mc.polarFrontLatitude then
		latRange = -mc.horseLatitudes + mc.polarFrontLatitude
		latPercent = (lat + mc.polarFrontLatitude)/latRange
		pressure = 1.0 - latPercent
	else
		latRange = -mc.polarFrontLatitude + 90.0
		latPercent = (lat + 90)/latRange
		pressure = latPercent
	end
-- Prevents excessively high and low pressures which helps distribute rain more evenly in the affected areas. -Bobert13
	pressure = pressure + 1
	if pressure > 1.5 then
		pressure = pressure * mc.pressureNorm
	else
		pressure = pressure / mc.pressureNorm
	end
	pressure = pressure - 1
-- FIN -Bobert13
	--print(pressure)
	return pressure
end

function FloatMap:ApplyFunction(func)
	for i = 0,self.length - 1 do
		self.data[i] = func(self.data[i])
	end
end

function FloatMap:GetRadiusAroundHex(x,y,radius)
	local list = {}
	table.insert(list,{x,y})
	if radius == 0 then
		return list
	end

	local hereX = x
	local hereY = y

	--make a circle for each radius
	for r = 1,radius do
		--start 1 to the west
		hereX,hereY = self:GetNeighbor(hereX,hereY,mc.W)
		if self:IsOnMap(hereX,hereY) then
			table.insert(list,{hereX,hereY})
		end
		--Go r times to the NE
		for z = 1,r do
			hereX, hereY = self:GetNeighbor(hereX,hereY,mc.NE)
			if self:IsOnMap(hereX,hereY) then
				table.insert(list,{hereX,hereY})
			end
		end
		--Go r times to the E
		for z = 1,r do
			hereX, hereY = self:GetNeighbor(hereX,hereY,mc.E)
			if self:IsOnMap(hereX,hereY) then
				table.insert(list,{hereX,hereY})
			end
		end
		--Go r times to the SE
		for z = 1,r do
			hereX, hereY = self:GetNeighbor(hereX,hereY,mc.SE)
			if self:IsOnMap(hereX,hereY) then
				table.insert(list,{hereX,hereY})
			end
		end
		--Go r times to the SW
		for z = 1,r do
			hereX, hereY = self:GetNeighbor(hereX,hereY,mc.SW)
			if self:IsOnMap(hereX,hereY) then
				table.insert(list,{hereX,hereY})
			end
		end
		--Go r times to the W
		for z = 1,r do
			hereX, hereY = self:GetNeighbor(hereX,hereY,mc.W)
			if self:IsOnMap(hereX,hereY) then
				table.insert(list,{hereX,hereY})
			end
		end
		--Go r - 1 times to the NW!!!!!
		for z = 1,r - 1 do
			hereX, hereY = self:GetNeighbor(hereX,hereY,mc.NW)
			if self:IsOnMap(hereX,hereY) then
				table.insert(list,{hereX,hereY})
			end
		end
		--one extra NW to set up for next circle
		hereX, hereY = self:GetNeighbor(hereX,hereY,mc.NW)
	end
	return list
end

function FloatMap:GetAverageInHex(x,y,radius)
	local list = self:GetRadiusAroundHex(x,y,radius)
	local avg = 0.0
	for n = 1,#list do
		local hex = list[n]
		local xx = hex[1]
		local yy = hex[2]
		local i = self:GetIndex(xx,yy)
		avg = avg + self.data[i]
	end
	avg = avg/#list

	return avg
end

function FloatMap:GetStdDevInHex(x,y,radius)
	local list = self:GetRadiusAroundHex(x,y,radius)
	local avg = 0.0
	for n = 1,#list do
		local hex = list[n]
		local xx = hex[1]
		local yy = hex[2]
		local i = self:GetIndex(xx,yy)
		avg = avg + self.data[i]
	end
	avg = avg/#list

	local deviation = 0.0
	for n = 1,#list do
		local hex = list[n]
		local xx = hex[1]
		local yy = hex[2]
		local i = self:GetIndex(xx,yy)
		local sqr = self.data[i] - avg
		deviation = deviation + (sqr * sqr)
	end
	deviation = math.sqrt(deviation/ #list)
	return deviation
end

function FloatMap:Smooth(radius)
	local dataCopy = {}
	for y = 0,self.height - 1 do
		for x = 0, self.width - 1 do
			local i = self:GetIndex(x,y)
			dataCopy[i] = self:GetAverageInHex(x,y,radius)
		end
	end
	self.data = dataCopy
end

function FloatMap:Deviate(radius)
	local dataCopy = {}
	for y = 0,self.height - 1 do
		for x = 0, self.width - 1 do
			local i = self:GetIndex(x,y)
			dataCopy[i] = self:GetStdDevInHex(x,y,radius)
		end
	end
	self.data = dataCopy
end

function FloatMap:IsOnMap(x,y)
	local i = self:GetIndex(x,y)
	if i == -1 then
		return false
	end
	return true
end

function FloatMap:Save(name)
	print("saving " .. name .. "...")
	local str = self.width .. "," .. self.height
	for i = 0,self.length - 1 do
		str = str .. "," .. self.data[i]
	end
	local file = io.open(name,"w+")
	file:write(str)
	file:close()
	print("bitmap saved as " .. name .. ".")
end
------------------------------------------------------------------------
--ElevationMap class
------------------------------------------------------------------------
ElevationMap = inheritsFrom(FloatMap)

function ElevationMap:New(width, height, wrapX, wrapY)
	local new_inst = FloatMap:New(width,height,wrapX,wrapY)
	setmetatable(new_inst, {__index = ElevationMap})	--setup metatable
	return new_inst
end
function ElevationMap:IsBelowSeaLevel(x,y)
	local i = self:GetIndex(x,y)
	if self.data[i] < self.seaLevelThreshold then
		return true
	else
		return false
	end
end
-------------------------------------------------------------------------
--AreaMap class
-------------------------------------------------------------------------
PWAreaMap = inheritsFrom(FloatMap)

function PWAreaMap:New(width,height,wrapX,wrapY)
	local new_inst = FloatMap:New(width,height,wrapX,wrapY)
	setmetatable(new_inst, {__index = PWAreaMap})	--setup metatable

	new_inst.areaList = {}
	new_inst.segStack = {}
	return new_inst
end

function PWAreaMap:DefineAreas(matchFunction)
	--zero map data
	for i = 0,self.width*self.height - 1 do
		self.data[i] = 0.0
	end

	self.areaList = {}
	local currentAreaID = 0
	for y = 0, self.height - 1 do
		for x = 0, self.width - 1 do
			local i = self:GetIndex(x,y)
			if self.data[i] == 0 then
				currentAreaID = currentAreaID + 1
				local area = PWArea:New(currentAreaID,x,y,matchFunction(x,y))
				--str = string.format("Filling area %d, matchFunction(x = %d,y = %d) = %s",area.id,x,y,tostring(matchFunction(x,y)))
				--print(str)
				self:FillArea(x,y,area,matchFunction)
				table.insert(self.areaList, area)

			end
		end
	end
end

function PWAreaMap:FillArea(x,y,area,matchFunction)
	self.segStack = {}
	local seg = LineSeg:New(y,x,x,1)
	Push(self.segStack,seg)
	seg = LineSeg:New(y + 1,x,x,-1)
	Push(self.segStack,seg)
	while #self.segStack > 0 do
		seg = Pop(self.segStack)
		self:ScanAndFillLine(seg,area,matchFunction)
	end
end

function PWAreaMap:ScanAndFillLine(seg,area,matchFunction)

	--str = string.format("Processing line y = %d, xLeft = %d, xRight = %d, dy = %d -------",seg.y,seg.xLeft,seg.xRight,seg.dy)
	--print(str)
	if self:ValidateY(seg.y + seg.dy) == -1 then
		return
	end

	local odd = (seg.y + seg.dy) % 2
	local notOdd = seg.y % 2
	--str = string.format("odd = %d, notOdd = %d",odd,notOdd)
	--print(str)

	local lineFound = 0
	local xStop = nil
	if self.wrapX then
		xStop = 0 - (self.width * 30)
	else
		xStop = -1
	end
	local leftExtreme = nil
	for leftExt = seg.xLeft - odd,xStop + 1,-1 do
		leftExtreme = leftExt --need this saved
		--str = string.format("leftExtreme = %d",leftExtreme)
		--print(str)
		local x = self:ValidateX(leftExtreme)
		local y = self:ValidateY(seg.y + seg.dy)
		local i = self:GetIndex(x,y)
		--str = string.format("x = %d, y = %d, area.trueMatch = %s, matchFunction(x,y) = %s",x,y,tostring(area.trueMatch),tostring(matchFunction(x,y)))
		--print(str)
		if self.data[i] == 0 and area.trueMatch == matchFunction(x,y) then
			self.data[i] = area.id
			area.size = area.size + 1
			--print("adding to area")
			lineFound = 1
		else
			--if no line was found, then leftExtreme is fine, but if
			--a line was found going left, then we need to increment
            --xLeftExtreme to represent the inclusive end of the line
			if lineFound == 1 then
				leftExtreme = leftExtreme + 1
				--print("line found, adding 1 to leftExtreme")
			end
			break
		end
	end
	--str = string.format("leftExtreme = %d",leftExtreme)
	--print(str)
	local rightExtreme = nil
	--now scan right to find extreme right, place each found segment on stack
	if self.wrapX then
		xStop = self.width * 20
	else
		xStop = self.width
	end
	for rightExt = seg.xLeft + lineFound - odd,xStop - 1 do
		rightExtreme = rightExt --need this saved
		--str = string.format("rightExtreme = %d",rightExtreme)
		--print(str)
		local x = self:ValidateX(rightExtreme)
		local y = self:ValidateY(seg.y + seg.dy)
		local i = self:GetIndex(x,y)
		--str = string.format("x = %d, y = %d, area.trueMatch = %s, matchFunction(x,y) = %s",x,y,tostring(area.trueMatch),tostring(matchFunction(x,y)))
		--print(str)
		if self.data[i] == 0 and area.trueMatch == matchFunction(x,y) then
			self.data[i] = area.id
			area.size = area.size + 1
			--print("adding to area")
			if lineFound == 0 then
				lineFound = 1 --starting new line
				leftExtreme = rightExtreme
			end
		elseif lineFound == 1 then --found the right end of a line segment
			--print("found right end of line")
			lineFound = 0
			--put same direction on stack
			local newSeg = LineSeg:New(y,leftExtreme,rightExtreme - 1,seg.dy)
			Push(self.segStack,newSeg)
			--str = string.format("  pushing y = %d, xLeft = %d, xRight = %d, dy = %d",y,leftExtreme,rightExtreme - 1,seg.dy)
			--print(str)
			--determine if we must put reverse direction on stack
			if leftExtreme < seg.xLeft - odd or rightExtreme >= seg.xRight + notOdd then
				--out of shadow so put reverse direction on stack
				newSeg = LineSeg:New(y,leftExtreme,rightExtreme - 1,-seg.dy)
				Push(self.segStack,newSeg)
				--str = string.format("  pushing y = %d, xLeft = %d, xRight = %d, dy = %d",y,leftExtreme,rightExtreme - 1,-seg.dy)
				--print(str)
			end
			if(rightExtreme >= seg.xRight + notOdd) then
				break
			end
		elseif lineFound == 0 and rightExtreme >= seg.xRight + notOdd then
			break --past the end of the parent line and no line found
		end
		--continue finding segments
	end
	if lineFound == 1 then --still needing a line to be put on stack
		print("still need line segments")
		lineFound = 0
		--put same direction on stack
		local newSeg = LineSeg:New(seg.y + seg.dy,leftExtreme,rightExtreme - 1,seg.dy)
		Push(self.segStack,newSeg)
		str = string.format("  pushing y = %d, xLeft = %d, xRight = %d, dy = %d",seg.y + seg.dy,leftExtreme,rightExtreme - 1,seg.dy)
		print(str)
		--determine if we must put reverse direction on stack
		if leftExtreme < seg.xLeft - odd or rightExtreme >= seg.xRight + notOdd then
			--out of shadow so put reverse direction on stack
			newSeg = LineSeg:New(seg.y + seg.dy,leftExtreme,rightExtreme - 1,-seg.dy)
			Push(self.segStack,newSeg)
			str = string.format("  pushing y = %d, xLeft = %d, xRight = %d, dy = %d",seg.y + seg.dy,leftExtreme,rightExtreme - 1,-seg.dy)
			print(str)
		end
	end
end

function PWAreaMap:GetAreaByID(id)
	for i = 1,#self.areaList do
		if self.areaList[i].id == id then
			return self.areaList[i]
		end
	end
	error("Can't find area id in AreaMap.areaList")
end

function PWAreaMap:ValidateY(y)
	local yy = nil
	if self.wrapY then
		yy = y % self.height
	elseif y < 0 or y >= self.height then
		return -1
	else
		yy = y
	end
	return yy
end

function PWAreaMap:ValidateX(x)
	local xx = nil
	if self.wrapX then
		xx = x % self.width
	elseif x < 0 or x >= self.width then
		return -1
	else
		xx = x
	end
	return xx
end

function PWAreaMap:PrintAreaList()
	for i=1,#self.areaList do
		local id = self.areaList[i].id
		local seedx = self.areaList[i].seedx
		local seedy = self.areaList[i].seedy
		local size = self.areaList[i].size
		local trueMatch = self.areaList[i].trueMatch
		local str = string.format("area id = %d, trueMatch = %s, size = %d, seedx = %d, seedy = %d",id,tostring(trueMatch),size,seedx,seedy)
		print(str)
	end
end
-------------------------------------------------------------------------
--Area class
-------------------------------------------------------------------------
PWArea = inheritsFrom(nil)

function PWArea:New(id,seedx,seedy,trueMatch)
	local new_inst = {}
	setmetatable(new_inst, {__index = PWArea})	--setup metatable

	new_inst.id = id
	new_inst.seedx = seedx
	new_inst.seedy = seedy
	new_inst.trueMatch = trueMatch
	new_inst.size = 0

	return new_inst
end
-------------------------------------------------------------------------
--LineSeg class
-------------------------------------------------------------------------
LineSeg = inheritsFrom(nil)

function LineSeg:New(y,xLeft,xRight,dy)
	local new_inst = {}
	setmetatable(new_inst, {__index = LineSeg})	--setup metatable

	new_inst.y = y
	new_inst.xLeft = xLeft
	new_inst.xRight = xRight
	new_inst.dy = dy

	return new_inst
end

-------------------------------------------------------------------------
--RiverMap class
-------------------------------------------------------------------------
RiverMap = inheritsFrom(nil)

function RiverMap:New(elevationMap)
	local new_inst = {}
	setmetatable(new_inst, {__index = RiverMap})

	new_inst.elevationMap = elevationMap
	new_inst.riverData = {}
	for y = 0,new_inst.elevationMap.height - 1 do
		for x = 0,new_inst.elevationMap.width - 1 do
			local i = new_inst.elevationMap:GetIndex(x,y)
			new_inst.riverData[i] = RiverHex:New(x,y)
		end
	end

	return new_inst
end

function RiverMap:GetJunction(x,y,isNorth)
	local i = self.elevationMap:GetIndex(x,y)
	if isNorth then
		return self.riverData[i].northJunction
	else
		return self.riverData[i].southJunction
	end
end

function RiverMap:GetJunctionNeighbor(direction,junction)
	local xx = nil
	local yy = nil
	local ii = nil
	local neighbor = nil
	local odd = junction.y % 2
	if direction == mc.NOFLOW then
		error("can't get junction neighbor in direction NOFLOW")
	elseif direction == mc.WESTFLOW then
		xx = junction.x + odd - 1
		if junction.isNorth then
			yy = junction.y + 1
		else
			yy = junction.y - 1
		end
		ii = self.elevationMap:GetIndex(xx,yy)
		if ii ~= -1 then
			neighbor = self:GetJunction(xx,yy,not junction.isNorth)
			return neighbor
		end
	elseif direction == mc.EASTFLOW then
		xx = junction.x + odd
		if junction.isNorth then
			yy = junction.y + 1
		else
			yy = junction.y - 1
		end
		ii = self.elevationMap:GetIndex(xx,yy)
		if ii ~= -1 then
			neighbor = self:GetJunction(xx,yy,not junction.isNorth)
			return neighbor
		end
	elseif direction == mc.VERTFLOW then
		xx = junction.x
		if junction.isNorth then
			yy = junction.y + 2
		else
			yy = junction.y - 2
		end
		ii = self.elevationMap:GetIndex(xx,yy)
		if ii ~= -1 then
			neighbor = self:GetJunction(xx,yy,not junction.isNorth)
			return neighbor
		end
	end

	return nil --neighbor off map
end

--Get the west or east hex neighboring this junction
function RiverMap:GetRiverHexNeighbor(junction,westNeighbor)
	local xx = nil
	local yy = nil
	local ii = nil
	local odd = junction.y % 2
	if junction.isNorth then
		yy = junction.y + 1
	else
		yy = junction.y - 1
	end
	if westNeighbor then
		xx = junction.x + odd - 1
	else
		xx = junction.x + odd
	end

	ii = self.elevationMap:GetIndex(xx,yy)
	if ii ~= -1 then
		return self.riverData[ii]
	end

	return nil
end

function RiverMap:SetJunctionAltitudes()
	for y = 0,self.elevationMap.height - 1 do
		for x = 0,self.elevationMap.width - 1 do
			local i = self.elevationMap:GetIndex(x,y)
			local vertAltitude = self.elevationMap.data[i]
			local westAltitude = nil
			local eastAltitude = nil
			local vertNeighbor = self.riverData[i]
			local westNeighbor = nil
			local eastNeighbor = nil
			local xx = nil
			local yy = nil
			local ii = nil

			--first do north
			westNeighbor = self:GetRiverHexNeighbor(vertNeighbor.northJunction,true)
			eastNeighbor = self:GetRiverHexNeighbor(vertNeighbor.northJunction,false)

			if westNeighbor ~= nil then
				ii = self.elevationMap:GetIndex(westNeighbor.x,westNeighbor.y)
			else
				ii = -1
			end

			if ii ~= -1 then
				westAltitude = self.elevationMap.data[ii]
			else
				westAltitude = vertAltitude
			end

			if eastNeighbor ~= nil then
				ii = self.elevationMap:GetIndex(eastNeighbor.x, eastNeighbor.y)
			else
				ii = -1
			end

			if ii ~= -1 then
				eastAltitude = self.elevationMap.data[ii]
			else
				eastAltitude = vertAltitude
			end

			vertNeighbor.northJunction.altitude = math.min(math.min(vertAltitude,westAltitude),eastAltitude)

			--then south
			westNeighbor = self:GetRiverHexNeighbor(vertNeighbor.southJunction,true)
			eastNeighbor = self:GetRiverHexNeighbor(vertNeighbor.southJunction,false)

			if westNeighbor ~= nil then
				ii = self.elevationMap:GetIndex(westNeighbor.x,westNeighbor.y)
			else
				ii = -1
			end

			if ii ~= -1 then
				westAltitude = self.elevationMap.data[ii]
			else
				westAltitude = vertAltitude
			end

			if eastNeighbor ~= nil then
				ii = self.elevationMap:GetIndex(eastNeighbor.x, eastNeighbor.y)
			else
				ii = -1
			end

			if ii ~= -1 then
				eastAltitude = self.elevationMap.data[ii]
			else
				eastAltitude = vertAltitude
			end

			vertNeighbor.southJunction.altitude = math.min(math.min(vertAltitude,westAltitude),eastAltitude)
		end
	end
end

function RiverMap:isLake(junction)

	--first exclude the map edges that don't have neighbors
	if junction.y == 0 and junction.isNorth == false then
		return false
	elseif junction.y == self.elevationMap.height - 1 and junction.isNorth == true then
		return false
	end

	--exclude altitudes below sea level
	if junction.altitude < self.elevationMap.seaLevelThreshold then
		return false
	end

	--if debugTime then print(string.format("junction = (%d,%d) N = %s, alt = %f",junction.x,junction.y,tostring(junction.isNorth),junction.altitude)) end

	local vertNeighbor = self:GetJunctionNeighbor(mc.VERTFLOW,junction)
	local vertAltitude = nil
	if vertNeighbor == nil then
		vertAltitude = junction.altitude
		--print("--vertNeighbor == nil")
	else
		vertAltitude = vertNeighbor.altitude
		--if debugTime then print(string.format("--vertNeighbor = (%d,%d) N = %s, alt = %f",vertNeighbor.x,vertNeighbor.y,tostring(vertNeighbor.isNorth),vertNeighbor.altitude)) end
	end

	local westNeighbor = self:GetJunctionNeighbor(mc.WESTFLOW,junction)
	local westAltitude = nil
	if westNeighbor == nil then
		westAltitude = junction.altitude
		--print("--westNeighbor == nil")
	else
		westAltitude = westNeighbor.altitude
		--if debugTime then print(string.format("--westNeighbor = (%d,%d) N = %s, alt = %f",westNeighbor.x,westNeighbor.y,tostring(westNeighbor.isNorth),westNeighbor.altitude)) end
	end

	local eastNeighbor = self:GetJunctionNeighbor(mc.EASTFLOW,junction)
	local eastAltitude = nil
	if eastNeighbor == nil then
		eastAltitude = junction.altitude
		--print("--eastNeighbor == nil")
	else
		eastAltitude = eastNeighbor.altitude
		--if debugTime then print(string.format("--eastNeighbor = (%d,%d) N = %s, alt = %f",eastNeighbor.x,eastNeighbor.y,tostring(eastNeighbor.isNorth),eastNeighbor.altitude)) end
	end

	local lowest = math.min(vertAltitude,math.min(westAltitude,math.min(eastAltitude,junction.altitude)))

	if lowest == junction.altitude then
		--print("--is lake")
		return true
	end
	--print("--is not lake")
	return false
end

--get the average altitude of the two lowest neighbors that are higher than
--the junction altitude.
function RiverMap:GetLowerNeighborAverage(junction)
	local vertNeighbor = self:GetJunctionNeighbor(mc.VERTFLOW,junction)
	local vertAltitude = nil
	if vertNeighbor == nil then
		vertAltitude = junction.altitude
	else
		vertAltitude = vertNeighbor.altitude
	end

	local westNeighbor = self:GetJunctionNeighbor(mc.WESTFLOW,junction)
	local westAltitude = nil
	if westNeighbor == nil then
		westAltitude = junction.altitude
	else
		westAltitude = westNeighbor.altitude
	end

	local eastNeighbor = self:GetJunctionNeighbor(mc.EASTFLOW,junction)
	local eastAltitude = nil
	if eastNeighbor == nil then
		eastAltitude = junction.altitude
	else
		eastAltitude = eastNeighbor.altitude
	end

	local nList = {vertAltitude,westAltitude,eastAltitude}
	table.sort(nList)
	local avg = nil
	if nList[1] > junction.altitude then
		avg = (nList[1] + nList[2])/2.0
	elseif nList[2] > junction.altitude then
		avg = (nList[2] + nList[3])/2.0
	elseif nList[3] > junction.altitude then
		avg = (nList[3] + junction.altitude)/2.0
	else
		avg = junction.altitude --all neighbors are the same height. Dealt with later
	end
	return avg
end

--this function alters the drainage pattern
function RiverMap:SiltifyLakes()
	local lakeList = {}
	local onQueueMapNorth = {}
	local onQueueMapSouth = {}
	for y = 0,self.elevationMap.height - 1 do
		for x = 0,self.elevationMap.width - 1 do
			local i = self.elevationMap:GetIndex(x,y)
			onQueueMapNorth[i] = false
			onQueueMapSouth[i] = false
			if self:isLake(self.riverData[i].northJunction) then
				Push(lakeList,self.riverData[i].northJunction)
				onQueueMapNorth[i] = true
			end
			if self:isLake(self.riverData[i].southJunction) then
				Push(lakeList,self.riverData[i].southJunction)
				onQueueMapSouth[i] = true
			end
		end
	end

	local longestLakeList = #lakeList
	local shortestLakeList = #lakeList
	local iterations = 0
	local debugOn = false
	--if debugTime then print(string.format("initial lake count = %d",longestLakeList)) end
	while #lakeList > 0 do
		--if debugTime then print(string.format("length of lakeList = %d",#lakeList)) end
		iterations = iterations + 1
		if #lakeList > longestLakeList then
			longestLakeList = #lakeList
		end

		if #lakeList < shortestLakeList then
			shortestLakeList = #lakeList
			--if debugTime then print(string.format("shortest lake list = %d, iterations = %d",shortestLakeList,iterations)) end
			iterations = 0
		end

		if iterations > 1000000 then
			debugOn = true
		end

		if iterations > 1001000 then
			error("endless loop in lake siltification. check logs")
		end

		local junction = Pop(lakeList)
		local i = self.elevationMap:GetIndex(junction.x,junction.y)
		if junction.isNorth then
			onQueueMapNorth[i] = false
		else
			onQueueMapSouth[i] = false
		end

		if debugOn then
			if debugTime then print(string.format("processing (%d,%d) N=%s alt=%f",junction.x,junction.y,tostring(junction.isNorth),junction.altitude)) end
		end

		local avgLowest = self:GetLowerNeighborAverage(junction)

		if debugOn then
			if debugTime then print(string.format("--avgLowest == %f",avgLowest)) end
		end

		if avgLowest < junction.altitude + 0.005 then --cant use == in fp comparison
			junction.altitude = avgLowest + 0.005
			if debugOn then
				print("--adding 0.005 to avgLowest")
			end
		else
			junction.altitude = avgLowest
		end

		if debugOn then
			if debugTime then print(string.format("--changing altitude to %f",junction.altitude)) end
		end

		for dir = mc.WESTFLOW,mc.VERTFLOW do
			local neighbor = self:GetJunctionNeighbor(dir,junction)
			if debugOn and neighbor == nil then
				if debugTime then print(string.format("--nil neighbor at direction = %d",dir)) end
			end
			if neighbor ~= nil and self:isLake(neighbor) then
				local i = self.elevationMap:GetIndex(neighbor.x,neighbor.y)
				if neighbor.isNorth == true and onQueueMapNorth[i] == false then
					Push(lakeList,neighbor)
					onQueueMapNorth[i] = true
					if debugOn then
						if debugTime then print(string.format("--pushing (%d,%d) N=%s alt=%f",neighbor.x,neighbor.y,tostring(neighbor.isNorth),neighbor.altitude)) end
					end
				elseif neighbor.isNorth == false and onQueueMapSouth[i] == false then
					Push(lakeList,neighbor)
					onQueueMapSouth[i] = true
					if debugOn then
						if debugTime then print(string.format("--pushing (%d,%d) N=%s alt=%f",neighbor.x,neighbor.y,tostring(neighbor.isNorth),neighbor.altitude)) end
					end
				end
			end
		end
	end
	--if debugTime then print(string.format("longestLakeList = %d",longestLakeList)) end

	--if debugTime then print(string.format("sea level = %f",self.elevationMap.seaLevelThreshold)) end

	local belowSeaLevelCount = 0
	local riverTest = FloatMap:New(self.elevationMap.width,self.elevationMap.height,self.elevationMap.xWrap,self.elevationMap.yWrap)
	local lakesFound = false
	for y = 0,self.elevationMap.height - 1 do
		for x = 0,self.elevationMap.width - 1 do
			local i = self.elevationMap:GetIndex(x,y)

			local northAltitude = self.riverData[i].northJunction.altitude
			local southAltitude = self.riverData[i].southJunction.altitude
			if northAltitude < self.elevationMap.seaLevelThreshold then
				belowSeaLevelCount = belowSeaLevelCount + 1
			end
			if southAltitude < self.elevationMap.seaLevelThreshold then
				belowSeaLevelCount = belowSeaLevelCount + 1
			end
			riverTest.data[i] = (northAltitude + southAltitude)/2.0

			if self:isLake(self.riverData[i].northJunction) then
				local junction = self.riverData[i].northJunction
				if debugTime then print(string.format("lake found at (%d, %d) isNorth = %s, altitude = %f!",junction.x,junction.y,tostring(junction.isNorth),junction.altitude)) end
				riverTest.data[i] = 1.0
				lakesFound = true
			end
			if self:isLake(self.riverData[i].southJunction) then
				local junction = self.riverData[i].southJunction
				if debugTime then print(string.format("lake found at (%d, %d) isNorth = %s, altitude = %f!",junction.x,junction.y,tostring(junction.isNorth),junction.altitude)) end
				riverTest.data[i] = 1.0
				lakesFound = true
			end
		end
	end

	if lakesFound then
		--error("Failed to siltify lakes. check logs")
	end
	--riverTest:Normalize()
--	riverTest:Save("riverTest.csv")
end

function RiverMap:SetFlowDestinations()
	junctionList = {}
	for y = 0,self.elevationMap.height - 1 do
		for x = 0,self.elevationMap.width - 1 do
			local i = self.elevationMap:GetIndex(x,y)
			table.insert(junctionList,self.riverData[i].northJunction)
			table.insert(junctionList,self.riverData[i].southJunction)
		end
	end

	table.sort(junctionList,function (a,b) return a.altitude > b.altitude end)

	for n=1,#junctionList do
		local junction = junctionList[n]
		local validList = self:GetValidFlows(junction)
		if #validList > 0 then
			local choice = PWRandint(1,#validList)
			junction.flow = validList[choice]
		else
			junction.flow = mc.NOFLOW
		end
	end
end

function RiverMap:GetValidFlows(junction)
	local validList = {}
	for dir = mc.WESTFLOW,mc.VERTFLOW do
		neighbor = self:GetJunctionNeighbor(dir,junction)
		if neighbor ~= nil and neighbor.altitude < junction.altitude then
			table.insert(validList,dir)
		end
	end
	return validList
end

function RiverMap:IsTouchingOcean(junction)

	if elevationMap:IsBelowSeaLevel(junction.x,junction.y) then
		return true
	end
	local westNeighbor = self:GetRiverHexNeighbor(junction,true)
	local eastNeighbor = self:GetRiverHexNeighbor(junction,false)

	if westNeighbor == nil or elevationMap:IsBelowSeaLevel(westNeighbor.x,westNeighbor.y) then
		return true
	end
	if eastNeighbor == nil or elevationMap:IsBelowSeaLevel(eastNeighbor.x,eastNeighbor.y) then
		return true
	end
	return false
end

function RiverMap:SetRiverSizes(rainfallMap)
	local junctionList = {} --only include junctions not touching ocean in this list
	for y = 0,self.elevationMap.height - 1 do
		for x = 0,self.elevationMap.width - 1 do
			local i = self.elevationMap:GetIndex(x,y)
			if not self:IsTouchingOcean(self.riverData[i].northJunction) then
				table.insert(junctionList,self.riverData[i].northJunction)
			end
			if not self:IsTouchingOcean(self.riverData[i].southJunction) then
				table.insert(junctionList,self.riverData[i].southJunction)
			end
		end
	end

	table.sort(junctionList,function (a,b) return a.altitude > b.altitude end)

	for n=1,#junctionList do
		local junction = junctionList[n]
		local nextJunction = junction
		local i = self.elevationMap:GetIndex(junction.x,junction.y)
		while true do
			nextJunction.size = (nextJunction.size + rainfallMap.data[i]) * mc.riverRainCheatFactor
			if nextJunction.flow == mc.NOFLOW or self:IsTouchingOcean(nextJunction) then
				nextJunction.size = 0.0
				break
			end
			nextJunction = self:GetJunctionNeighbor(nextJunction.flow,nextJunction)
		end
	end

	--now sort by river size to find river threshold
	table.sort(junctionList,function (a,b) return a.size > b.size end)
	local riverIndex = math.floor(mc.riverPercent * #junctionList)
	self.riverThreshold = junctionList[riverIndex].size
	if debugTime then print(string.format("river threshold = %f",self.riverThreshold)) end

--~ 	local riverMap = FloatMap:New(self.elevationMap.width,self.elevationMap.height,self.elevationMap.xWrap,self.elevationMap.yWrap)
--~ 	for y = 0,self.elevationMap.height - 1 do
--~ 		for x = 0,self.elevationMap.width - 1 do
--~ 			local i = self.elevationMap:GetIndex(x,y)
--~ 			riverMap.data[i] = math.max(self.riverData[i].northJunction.size,self.riverData[i].southJunction.size)
--~ 		end
--~ 	end
--~ 	riverMap:Normalize()
	--riverMap:Save("riverSizeMap.csv")
end

--This function returns the flow directions needed by civ
function RiverMap:GetFlowDirections(x,y)
	--if debugTime then print(string.format("Get flow dirs for %d,%d",x,y)) end
	local i = elevationMap:GetIndex(x,y)

	local WOfRiver = FlowDirectionTypes.NO_FLOWDIRECTION
	local xx,yy = elevationMap:GetNeighbor(x,y,mc.NE)
	local ii = elevationMap:GetIndex(xx,yy)
	if ii ~= -1 and self.riverData[ii].southJunction.flow == mc.VERTFLOW and self.riverData[ii].southJunction.size > self.riverThreshold then
		--if debugTime then print(string.format("--NE(%d,%d) south flow=%d, size=%f",xx,yy,self.riverData[ii].southJunction.flow,self.riverData[ii].southJunction.size)) end
		WOfRiver = FlowDirectionTypes.FLOWDIRECTION_SOUTH
	end
	xx,yy = elevationMap:GetNeighbor(x,y,mc.SE)
	ii = elevationMap:GetIndex(xx,yy)
	if ii ~= -1 and self.riverData[ii].northJunction.flow == mc.VERTFLOW and self.riverData[ii].northJunction.size > self.riverThreshold then
		--if debugTime then print(string.format("--SE(%d,%d) north flow=%d, size=%f",xx,yy,self.riverData[ii].northJunction.flow,self.riverData[ii].northJunction.size)) end
		WOfRiver = FlowDirectionTypes.FLOWDIRECTION_NORTH
	end

	local NWOfRiver = FlowDirectionTypes.NO_FLOWDIRECTION
	xx,yy = elevationMap:GetNeighbor(x,y,mc.SE)
	ii = elevationMap:GetIndex(xx,yy)
	if ii ~= -1 and self.riverData[ii].northJunction.flow == mc.WESTFLOW and self.riverData[ii].northJunction.size > self.riverThreshold then
		NWOfRiver = FlowDirectionTypes.FLOWDIRECTION_SOUTHWEST
	end
	if self.riverData[i].southJunction.flow == mc.EASTFLOW and self.riverData[i].southJunction.size > self.riverThreshold then
		NWOfRiver = FlowDirectionTypes.FLOWDIRECTION_NORTHEAST
	end

	local NEOfRiver = FlowDirectionTypes.NO_FLOWDIRECTION
	xx,yy = elevationMap:GetNeighbor(x,y,mc.SW)
	ii = elevationMap:GetIndex(xx,yy)
	if ii ~= -1 and self.riverData[ii].northJunction.flow == mc.EASTFLOW and self.riverData[ii].northJunction.size > self.riverThreshold then
		NEOfRiver = FlowDirectionTypes.FLOWDIRECTION_SOUTHEAST
	end
	if self.riverData[i].southJunction.flow == mc.WESTFLOW and self.riverData[i].southJunction.size > self.riverThreshold then
		NEOfRiver = FlowDirectionTypes.FLOWDIRECTION_NORTHWEST
	end

	return WOfRiver,NWOfRiver,NEOfRiver
end
-------------------------------------------------------------------------
--RiverHex class
-------------------------------------------------------------------------
RiverHex = inheritsFrom(nil)

function RiverHex:New(x, y)
	local new_inst = {}
	setmetatable(new_inst, {__index = RiverHex})

	new_inst.x = x
	new_inst.y = y
	new_inst.northJunction = RiverJunction:New(x,y,true)
	new_inst.southJunction = RiverJunction:New(x,y,false)

	return new_inst
end

-------------------------------------------------------------------------
--RiverJunction class
-------------------------------------------------------------------------
RiverJunction = inheritsFrom(nil)

function RiverJunction:New(x,y,isNorth)
	local new_inst = {}
	setmetatable(new_inst, {__index = RiverJunction})

	new_inst.x = x
	new_inst.y = y
	new_inst.isNorth = isNorth
	new_inst.altitude = 0.0
	new_inst.flow = mc.NOFLOW
	new_inst.size = 0.0

	return new_inst
end

------------------------------------------------------------------------------
--Global functions
------------------------------------------------------------------------------
function GenerateTwistedPerlinMap(width, height, xWrap, yWrap,minFreq,maxFreq,varFreq)
	local inputNoise = FloatMap:New(width,height,xWrap,yWrap)
	inputNoise:GenerateNoise()
	inputNoise:Normalize()

	local freqMap = FloatMap:New(width,height,xWrap,yWrap)
	for y = 0, freqMap.height - 1 do
		for x = 0,freqMap.width - 1 do
			local i = freqMap:GetIndex(x,y)
			local odd = y % 2
			local xx = x + odd * 0.5
			freqMap.data[i] = GetPerlinNoise(xx,y * mc.YtoXRatio,freqMap.width,freqMap.height * mc.YtoXRatio,varFreq,1.0,0.1,8,inputNoise)
		end
	end
	freqMap:Normalize()
--	freqMap:Save("freqMap.csv")

	local twistMap = FloatMap:New(width,height,xWrap,yWrap)
	for y = 0, twistMap.height - 1 do
		for x = 0,twistMap.width - 1 do
			local i = twistMap:GetIndex(x,y)
			local freq = freqMap.data[i] * (maxFreq - minFreq) + minFreq
			local mid = (maxFreq - minFreq)/2 + minFreq
			local coordScale = freq/mid
			local offset = (1.0 - coordScale)/mid
			--print("1-coordscale = " .. (1.0 - coordScale) .. ", offset = " .. offset)
			local ampChange = 0.85 - freqMap.data[i] * 0.5
			local odd = y % 2
			local xx = x + odd * 0.5
			twistMap.data[i] = GetPerlinNoise(xx + offset,(y + offset) * mc.YtoXRatio,twistMap.width,twistMap.height * mc.YtoXRatio,mid,1.0,ampChange,8,inputNoise)
		end
	end

	twistMap:Normalize()
	--twistMap:Save("twistMap.csv")
	return twistMap
end

function ShuffleList(list)
	local len = #list
	for i=0,len - 1 do
		local k = PWRandint(0,len-1)
		list[i], list[k] = list[k], list[i]
	end
end

function GenerateMountainMap(width,height,xWrap,yWrap,initFreq)
	local inputNoise = FloatMap:New(width,height,xWrap,yWrap)
	inputNoise:GenerateBinaryNoise()
	inputNoise:Normalize()
	local inputNoise2 = FloatMap:New(width,height,xWrap,yWrap)
	inputNoise2:GenerateNoise()
	inputNoise2:Normalize()

	local mountainMap = FloatMap:New(width,height,xWrap,yWrap)
	local stdDevMap = FloatMap:New(width,height,xWrap,yWrap)
	local noiseMap = FloatMap:New(width,height,xWrap,yWrap)
	for y = 0, mountainMap.height - 1 do
		for x = 0,mountainMap.width - 1 do
			local i = mountainMap:GetIndex(x,y)
			local odd = y % 2
			local xx = x + odd * 0.5
			mountainMap.data[i] = GetPerlinNoise(xx,y * mc.YtoXRatio,mountainMap.width,mountainMap.height * mc.YtoXRatio,initFreq,1.0,0.4,8,inputNoise)
			noiseMap.data[i] = GetPerlinNoise(xx,y * mc.YtoXRatio,mountainMap.width,mountainMap.height * mc.YtoXRatio,initFreq,1.0,0.4,8,inputNoise2)
			stdDevMap.data[i] = mountainMap.data[i]
		end
	end
	mountainMap:Normalize()
	stdDevMap:Deviate(7)
	stdDevMap:Normalize()
	--stdDevMap:Save("stdDevMap.csv")
	--mountainMap:Save("mountainCloud.csv")
	noiseMap:Normalize()
	--noiseMap:Save("noiseMap.csv")

	local moundMap = FloatMap:New(width,height,xWrap,yWrap)
	for y = 0, mountainMap.height - 1 do
		for x = 0,mountainMap.width - 1 do
			local i = mountainMap:GetIndex(x,y)
			local val = mountainMap.data[i]
			moundMap.data[i] = (math.sin(val*math.pi*2-math.pi*0.5)*0.5+0.5) * GetAttenuationFactor(mountainMap,x,y)
			if val < 0.5 then
				val = val^1 * 4
			else
				val = (1 - val)^1 * 4
			end
			--mountainMap.data[i] = val
			mountainMap.data[i] = moundMap.data[i]
		end
	end
	mountainMap:Normalize()
	--mountainMap:Save("premountMap.csv")
	--moundMap:Save("moundMap.csv")

	for y = 0, mountainMap.height - 1 do
		for x = 0,mountainMap.width - 1 do
			local i = mountainMap:GetIndex(x,y)
			local val = mountainMap.data[i]
			--mountainMap.data[i] = (math.sin(val * 2 * math.pi + math.pi * 0.5)^8 * val) + moundMap.data[i] * 2 + noiseMap.data[i] * 0.6
			mountainMap.data[i] = (math.sin(val * 3 * math.pi + math.pi * 0.5)^16 * val)^0.5
			if mountainMap.data[i] > 0.2 then
				mountainMap.data[i] = 1.0
			else
				mountainMap.data[i] = 0.0
			end
		end
	end
	--mountainMap:Save("premountMap.csv")

	local stdDevThreshold = stdDevMap:FindThresholdFromPercent(mc.landPercent,true,false)

	for y = 0, mountainMap.height - 1 do
		for x = 0,mountainMap.width - 1 do
			local i = mountainMap:GetIndex(x,y)
			local val = mountainMap.data[i]
			local dev = 2.0 * stdDevMap.data[i] - 2.0 * stdDevThreshold
			--mountainMap.data[i] = (math.sin(val * 2 * math.pi + math.pi * 0.5)^8 * val) + moundMap.data[i] * 2 + noiseMap.data[i] * 0.6
			mountainMap.data[i] = (val + moundMap.data[i]) * dev
		end
	end

	mountainMap:Normalize()
	--mountainMap:Save("mountainMap.csv")
	return mountainMap
end

function waterMatch(x,y)
	if elevationMap:IsBelowSeaLevel(x,y) then
		return true
	end
	return false
end

function GetAttenuationFactor(map,x,y)
	local southY = map.height * mc.southAttenuationRange
	local southRange = map.height * mc.southAttenuationRange
	local yAttenuation = 1.0
	if y < southY then
		yAttenuation = mc.southAttenuationFactor + (y/southRange) * (1.0 - mc.southAttenuationFactor)
	end

	local northY = map.height - (map.height * mc.northAttenuationRange)
	local northRange = map.height * mc.northAttenuationRange
	if y > northY then
		yAttenuation = mc.northAttenuationFactor + ((map.height - y)/northRange) * (1.0 - mc.northAttenuationFactor)
	end

	local eastY = map.width - (map.width * mc.eastAttenuationRange)
	local eastRange = map.width * mc.eastAttenuationRange
	local xAttenuation = 1.0
	if x > eastY then
		xAttenuation = mc.eastAttenuationFactor + ((map.width - x)/eastRange) * (1.0 - mc.eastAttenuationFactor)
	end

	local westY = map.width * mc.westAttenuationRange
	local westRange = map.width * mc.westAttenuationRange
	if x < westY then
		xAttenuation = mc.westAttenuationFactor + (x/westRange) * (1.0 - mc.westAttenuationFactor)
	end

	return yAttenuation * xAttenuation
end

function GenerateElevationMap(width,height,xWrap,yWrap)
	local timeStart = debugTime and os.clock() or 0
	local twistMinFreq = 128/width * mc.twistMinFreq --0.02/128
	local twistMaxFreq = 128/width * mc.twistMaxFreq --0.12/128
	local twistVar = 128/width * mc.twistVar --0.042/128
	local mountainFreq = 128/width * mc.mountainFreq --0.05/128
	if debugTime then if debugTime then print(string.format("%4s ms for GenerateElevationMap %s", math.floor((os.clock() - timeStart) * 1000), "Start")) end end
	
	if debugTime then timeStart = os.clock() end
	local twistMap = GenerateTwistedPerlinMap(width,height,xWrap,yWrap,twistMinFreq,twistMaxFreq,twistVar)
	if debugTime then print(string.format("%4s ms for GenerateElevationMap %s", math.floor((os.clock() - timeStart) * 1000), "GenerateTwistedPerlinMap")) end
	
	if debugTime then timeStart = os.clock() end
	local mountainMap = GenerateMountainMap(width,height,xWrap,yWrap,mountainFreq)
	if debugTime then print(string.format("%4s ms for GenerateElevationMap %s", math.floor((os.clock() - timeStart) * 1000), "GenerateMountainMap")) end
	
	if debugTime then timeStart = os.clock() end
	local elevationMap = ElevationMap:New(width,height,xWrap,yWrap)	
	for y = 0,height - 1 do
		for x = 0,width - 1 do
			local i = elevationMap:GetIndex(x,y)
			local tVal = twistMap.data[i]
			tVal = (math.sin(tVal*math.pi-math.pi*0.5)*0.5+0.5)^0.25 --this formula adds a curve flattening the extremes
			elevationMap.data[i] = (tVal + ((mountainMap.data[i] * 2) - 1) * mc.mountainWeight)
		end
	end
	
	if debugTime then timeStart = os.clock() end

	elevationMap:Normalize()

	--attentuation should not break normalization
	for y = 0,height - 1 do
		for x = 0,width - 1 do
			local i = elevationMap:GetIndex(x,y)
			local attenuationFactor = GetAttenuationFactor(elevationMap,x,y)
			elevationMap.data[i] = elevationMap.data[i] * attenuationFactor
		end
	end
	
	if debugTime then timeStart = os.clock() end

	elevationMap.seaLevelThreshold = elevationMap:FindThresholdFromPercent(mc.landPercent,true,false)

	if debugTime then print(string.format("%4s ms for GenerateElevationMap %s", math.floor((os.clock() - timeStart) * 1000), "End")) end
	return elevationMap
end

function FillInLakes()
	local areaMap = PWAreaMap:New(elevationMap.width,elevationMap.height,elevationMap.wrapX,elevationMap.wrapY)
	areaMap:DefineAreas(waterMatch)
	local lakePlots = {}
	for i=1, #areaMap.areaList do
		local area = areaMap.areaList[i]
		if area.trueMatch and area.size < mc.minOceanSize then
			for n = 0, areaMap.length do
				if areaMap.data[n] == area.id then
					elevationMap.data[n] = elevationMap.seaLevelThreshold
					--print("Saving lake of size ".. area.size)
					table.insert(lakePlots, Map.GetPlot(elevationMap:GetXYFromIndex(n)))
				end
			end
		end
	end
	return lakePlots
end

function RestoreLakes(lakePlots)
	for _, plot in pairs(lakePlots) do
		--print("Loading lake")
		plot:SetTerrainType(TerrainTypes.TERRAIN_COAST, false, true)
		--plot:SetFeatureType(FeatureTypes.FEATURE_ICE, -1)
	end
end

function GetTemperature(myPlot)
	if myPlot:GetTerrainType() == TerrainTypes.TERRAIN_SNOW then
		return 0
	elseif myPlot:GetTerrainType() == TerrainTypes.TERRAIN_TUNDRA then
		return 1
	end
	return 2
end

function BlendTerrain()
	local mapW, mapH = Map.GetGridSize()
	
	-- grass -> plains, near desert
	for plotY = 0, mapH-1 do
		for plotX = 0,mapW-1 do
			local plot = Map.GetPlot(plotX,plotY)
			local plotTerrainID = plot:GetTerrainType()
			if not plot:IsMountain() and plotTerrainID == TerrainTypes.TERRAIN_GRASS then
				--[[
				for _, adjPlot in pairs(Plot_GetPlotsInCircle(plot, 1)) do
					local adjTerrainID = adjPlot:GetTerrainType()
					if not adjPlot:IsMountain() and (adjTerrainID == TerrainTypes.TERRAIN_SNOW) then
						plot:SetTerrainType(TerrainTypes.TERRAIN_PLAINS, false, true)
						break
					end
				end
				--]]
				
				if Plot_GetAreaWeights(plot, 1, 1).TERRAIN_DESERT >= 0.25 then
					plot:SetTerrainType(TerrainTypes.TERRAIN_PLAINS, false, true)
					if plot:GetFeatureType() == FeatureTypes.FEATURE_MARSH then
						plot:SetFeatureType(FeatureTypes.FEATURE_FOREST, -1)
					end
				end
			end
		end
	end
	
	-- desert -> plains, near snow/grass
	for plotY = 0, mapH-1 do
		for plotX = 0,mapW-1 do
			local plot = Map.GetPlot(plotX,plotY)
			local plotTerrainID = plot:GetTerrainType()
			if not plot:IsMountain() and plotTerrainID == TerrainTypes.TERRAIN_DESERT then
				local favorDesert = 0
				for _, adjPlot in pairs(Plot_GetPlotsInCircle(plot, 1)) do
					local adjTerrainID = adjPlot:GetTerrainType()
					if not adjPlot:IsMountain() and adjTerrainID == TerrainTypes.TERRAIN_SNOW then
						plot:SetTerrainType(TerrainTypes.TERRAIN_PLAINS, false, true)
						break
					end
				end
				if Plot_GetAreaWeights(plot, 1, 1).TERRAIN_GRASS >= 0.25 then
					plot:SetTerrainType(TerrainTypes.TERRAIN_PLAINS, false, true)
				end
			end
		end
	end
	
	-- tundra -> plains, near grass/desert
	for plotY = 0, mapH-1 do
		for plotX = 0,mapW-1 do
			local plot = Map.GetPlot(plotX,plotY)
			local plotTerrainID = plot:GetTerrainType()
			if not plot:IsMountain() and plotTerrainID == TerrainTypes.TERRAIN_TUNDRA then
				for _, adjPlot in pairs(Plot_GetPlotsInCircle(plot, 1)) do
					local adjTerrainID = adjPlot:GetTerrainType()
					if not adjPlot:IsMountain() and (adjTerrainID == TerrainTypes.TERRAIN_GRASS or adjTerrainID == TerrainTypes.TERRAIN_DESERT) then
						plot:SetTerrainType(TerrainTypes.TERRAIN_PLAINS, false, true)
						break
					end
				end
			end
		end
	end
	
	-- snow -> tundra near river or plains, snow -> plains near grass/desert
	for plotY = 0, mapH-1 do
		for plotX = 0,mapW-1 do
			local plot = Map.GetPlot(plotX,plotY)
			local plotTerrainID = plot:GetTerrainType()
			if not plot:IsMountain() and plotTerrainID == TerrainTypes.TERRAIN_SNOW then
				if plot:IsFreshWater() then
					plot:SetTerrainType(TerrainTypes.TERRAIN_TUNDRA, false, true)
				end
				for _, adjPlot in pairs(Plot_GetPlotsInCircle(plot, 1)) do
					local adjTerrainID = adjPlot:GetTerrainType()
					if not adjPlot:IsMountain() then
						if (adjTerrainID == TerrainTypes.TERRAIN_GRASS or adjTerrainID == TerrainTypes.TERRAIN_DESERT) then
							plot:SetTerrainType(TerrainTypes.TERRAIN_PLAINS, false, true)
							break
						elseif (adjTerrainID == TerrainTypes.TERRAIN_PLAINS) then
							plot:SetTerrainType(TerrainTypes.TERRAIN_TUNDRA, false, true)
							break
						end
					end
				end
			end
		end
	end
	
	-- warm hills -> flat when surrounded by cold
	for plotY = 0, mapH-1 do
		for plotX = 0, mapW-1 do
			local plot = Map.GetPlot(plotX,plotY)
			local plotTerrainID = plot:GetTerrainType()
			if plot:GetPlotType() == PlotTypes.PLOT_HILLS then
				local adjCold = 0
				for _, adjPlot in pairs(Plot_GetPlotsInCircle(plot, 1)) do
					if not adjPlot:IsWater() and not adjPlot:IsMountain() and GetTemperature(adjPlot) < GetTemperature(plot) then
						adjCold = adjCold + 1
					end
				end
				if adjCold > 1 and (adjCold * mc.hillsBlendPercent * 100) >= Map.Rand(100, "Blend hills - Lua") then
					plot:SetPlotType(PlotTypes.PLOT_LAND, false, true)
				end
			end
		end
	end
	
	-- flat -> hills near mountain, and flat cold -> hills when surrounded by warm
	for plotY = 0, mapH-1 do
		for plotX = 0, mapW-1 do
			local plot = Map.GetPlot(plotX,plotY)
			local plotTerrainID = plot:GetTerrainType()
			if plot:GetPlotType() == PlotTypes.PLOT_LAND then
				local adjMountains = 0
				local adjWarm = 0
				for _, adjPlot in pairs(Plot_GetPlotsInCircle(plot, 1)) do
					if not adjPlot:IsWater() then
						local adjTerrainID = adjPlot:GetTerrainType()
						
						if adjPlot:IsMountain() then
							adjMountains = adjMountains + 1
						end
						
						if GetTemperature(adjPlot) > GetTemperature(plot) then
							adjWarm = adjWarm + 1
						end
					end
				end
				if (adjMountains > 1 and (adjMountains * mc.hillsBlendPercent * 100) >= Map.Rand(100, "Blend mountains - Lua")) then
					--print("Turning flatland near mountain into hills")
					plot:SetPlotType(PlotTypes.PLOT_HILLS, false, true)
					--plot:SetTerrainType(TerrainTypes.TERRAIN_SNOW, false, true)
				elseif adjWarm * mc.hillsBlendPercent * 100 >= Map.Rand(100, "Blend hills - Lua") then
					plot:SetPlotType(PlotTypes.PLOT_HILLS, false, true)
				end
			end
		end
	end
	--]]
end

function GenerateTempMaps(elevationMap)
	local timeStart = debugTime and os.clock() or 0
	local aboveSeaLevelMap = FloatMap:New(elevationMap.width,elevationMap.height,elevationMap.xWrap,elevationMap.yWrap)
	for y = 0,elevationMap.height - 1 do
		for x = 0,elevationMap.width - 1 do
			local i = aboveSeaLevelMap:GetIndex(x,y)
			if elevationMap:IsBelowSeaLevel(x,y) then
				aboveSeaLevelMap.data[i] = 0.0
			else
				aboveSeaLevelMap.data[i] = elevationMap.data[i] - elevationMap.seaLevelThreshold
			end
		end
	end
	aboveSeaLevelMap:Normalize()
	--aboveSeaLevelMap:Save("aboveSeaLevelMap.csv")

	local summerMap = FloatMap:New(elevationMap.width,elevationMap.height,elevationMap.xWrap,elevationMap.yWrap)
	local zenith = mc.tropicLatitudes
	local topTempLat = mc.topLatitude + zenith
	local bottomTempLat = mc.bottomLatitude
	local latRange = topTempLat - bottomTempLat
	for y = 0,elevationMap.height - 1 do
		for x = 0,elevationMap.width - 1 do
			local i = summerMap:GetIndex(x,y)
			local lat = summerMap:GetLatitudeForY(y)
			--print("y=" .. y ..",lat=" .. lat)
			local latPercent = (lat - bottomTempLat)/latRange
			--print("latPercent=" .. latPercent)
			local temp = (math.sin(latPercent * math.pi * 2 - math.pi * 0.5) * 0.5 + 0.5)
			if elevationMap:IsBelowSeaLevel(x,y) then
				temp = temp * mc.maxWaterTemp + mc.minWaterTemp
			end
			summerMap.data[i] = temp
		end
	end
	summerMap:Smooth(math.floor(elevationMap.width/8))
	summerMap:Normalize()
	if debugTime then print(string.format("%4s ms for GenerateTempMaps %s", math.floor((os.clock() - timeStart) * 1000), "Summer")) end
	
	if debugTime then timeStart = os.clock() end
	local winterMap = FloatMap:New(elevationMap.width,elevationMap.height,elevationMap.xWrap,elevationMap.yWrap)
	zenith = -mc.tropicLatitudes
	topTempLat = mc.topLatitude
	bottomTempLat = mc.bottomLatitude + zenith
	latRange = topTempLat - bottomTempLat
	for y = 0,elevationMap.height - 1 do
		for x = 0,elevationMap.width - 1 do
			local i = winterMap:GetIndex(x,y)
			local lat = winterMap:GetLatitudeForY(y)
			local latPercent = (lat - bottomTempLat)/latRange
			local temp = math.sin(latPercent * math.pi * 2 - math.pi * 0.5) * 0.5 + 0.5
			if elevationMap:IsBelowSeaLevel(x,y) then
				temp = temp * mc.maxWaterTemp + mc.minWaterTemp
			end
			winterMap.data[i] = temp
		end
	end
	winterMap:Smooth(math.floor(elevationMap.width/8))
	winterMap:Normalize()
	if debugTime then print(string.format("%4s ms for GenerateTempMaps %s", math.floor((os.clock() - timeStart) * 1000), "Winter")) end

	if debugTime then timeStart = os.clock() end
	local temperatureMap = FloatMap:New(elevationMap.width,elevationMap.height,elevationMap.xWrap,elevationMap.yWrap)
	for y = 0,elevationMap.height - 1 do
		for x = 0,elevationMap.width - 1 do
			local i = temperatureMap:GetIndex(x,y)
			temperatureMap.data[i] = (winterMap.data[i] + summerMap.data[i]) * (1.0 - aboveSeaLevelMap.data[i])
		end
	end
	temperatureMap:Normalize()

	if debugTime then print(string.format("%4s ms for GenerateTempMaps %s", math.floor((os.clock() - timeStart) * 1000), "End")) end
	return summerMap,winterMap,temperatureMap
end

function GenerateRainfallMap(elevationMap)
	local timeStart = debugTime and os.clock() or 0
	local summerMap,winterMap,temperatureMap = GenerateTempMaps(elevationMap)
	if debugTime then print(string.format("%4s ms for GenerateRainfallMap %s", math.floor((os.clock() - timeStart) * 1000), "GenerateTempMaps")) end
	
	if debugTime then timeStart = os.clock() end
	--summerMap:Save("summerMap.csv")
	--winterMap:Save("winterMap.csv")
	--temperatureMap:Save("temperatureMap.csv")
	local geoMap = FloatMap:New(elevationMap.width,elevationMap.height,elevationMap.xWrap,elevationMap.yWrap)
	for y = 0,elevationMap.height - 1 do
		for x = 0,elevationMap.width - 1 do
			local i = elevationMap:GetIndex(x,y)
			local lat = elevationMap:GetLatitudeForY(y)
			local pressure = elevationMap:GetGeostrophicPressure(lat)
			geoMap.data[i] = pressure
		end
	end
	geoMap:Normalize()
	--geoMap:Save("geoMap.csv")

	local sortedSummerMap = {}
	local sortedWinterMap = {}
	for y = 0,elevationMap.height - 1 do
		for x = 0,elevationMap.width - 1 do
			local i = elevationMap:GetIndex(x,y)
			sortedSummerMap[i + 1] = {x,y,summerMap.data[i]}
			sortedWinterMap[i + 1] = {x,y,winterMap.data[i]}
		end
	end
	table.sort(sortedSummerMap, function (a,b) return a[3] < b[3] end)
	table.sort(sortedWinterMap, function (a,b) return a[3] < b[3] end)
	
	local sortedGeoMap = {}
	local xStart = 0
	local xStop = 0
	local yStart = 0
	local yStop = 0
	local incX = 0
	local incY = 0
	local geoIndex = 1
	local str = ""
	for zone=0,5 do
		local topY = elevationMap:GetYFromZone(zone,true)
		local bottomY = elevationMap:GetYFromZone(zone,false)
		if not (topY == -1 and bottomY == -1) then
			if topY == -1 then
				topY = elevationMap.height - 1
			end
			if bottomY == -1 then
				bottomY = 0
			end
			--str = string.format("topY = %d, bottomY = %d",topY,bottomY)
			--print(str)
			local dir1,dir2 = elevationMap:GetGeostrophicWindDirections(zone)
			--str = string.format("zone = %d, dir1 = %d",zone,dir1)
			--print(str)
			if (dir1 == mc.SW) or (dir1 == mc.SE) then
				yStart = topY
				yStop = bottomY --- 1
				incY = -1
			else
				yStart = bottomY
				yStop = topY --+ 1
				incY = 1
			end
			if dir2 == mc.W then
				xStart = elevationMap.width - 1
				xStop = 0---1
				incX = -1
			else
				xStart = 0
				xStop = elevationMap.width
				incX = 1
			end
			--str = string.format("yStart = %d, yStop = %d, incY = %d",yStart,yStop,incY)
			--print(str)
			--str = string.format("xStart = %d, xStop = %d, incX = %d",xStart,xStop,incX)
			--print(str)

			for y = yStart,yStop ,incY do
				--str = string.format("y = %d",y)
				--print(str)
				--each line should start on water to avoid vast areas without rain
				local xxStart = xStart
				local xxStop = xStop
				for xx = xStart,xStop - incX, incX do
					local i = elevationMap:GetIndex(xx,y)
					if elevationMap:IsBelowSeaLevel(xx,y) then
						xxStart = xx
						xxStop = xx + elevationMap.width * incX
						break
					end
				end
				for x = xxStart,xxStop - incX,incX do
					local i = elevationMap:GetIndex(x,y)
					sortedGeoMap[geoIndex] = {x,y,geoMap.data[i]}
					geoIndex = geoIndex + 1
				end
			end
		end
	end
--	table.sort(sortedGeoMap, function (a,b) return a[3] < b[3] end)
	--print(#sortedGeoMap)
	--print(#geoMap.data)

	local rainfallSummerMap = FloatMap:New(elevationMap.width,elevationMap.height,elevationMap.xWrap,elevationMap.yWrap)
	local moistureMap = FloatMap:New(elevationMap.width,elevationMap.height,elevationMap.xWrap,elevationMap.yWrap)
	for i = 1,#sortedSummerMap do
		local x = sortedSummerMap[i][1]
		local y = sortedSummerMap[i][2]
		local pressure = sortedSummerMap[i][3]
		DistributeRain(x,y,elevationMap,temperatureMap,summerMap,rainfallSummerMap,moistureMap,false)
	end

	local rainfallWinterMap = FloatMap:New(elevationMap.width,elevationMap.height,elevationMap.xWrap,elevationMap.yWrap)
	local moistureMap = FloatMap:New(elevationMap.width,elevationMap.height,elevationMap.xWrap,elevationMap.yWrap)
	for i = 1,#sortedWinterMap do
		local x = sortedWinterMap[i][1]
		local y = sortedWinterMap[i][2]
		local pressure = sortedWinterMap[i][3]
		DistributeRain(x,y,elevationMap,temperatureMap,winterMap,rainfallWinterMap,moistureMap,false)
	end

	local rainfallGeostrophicMap = FloatMap:New(elevationMap.width,elevationMap.height,elevationMap.xWrap,elevationMap.yWrap)
	moistureMap = FloatMap:New(elevationMap.width,elevationMap.height,elevationMap.xWrap,elevationMap.yWrap)
	
	--print("----------------------------------------------------------------------------------------")
	--print("--GEOSTROPHIC---------------------------------------------------------------------------")
	--print("----------------------------------------------------------------------------------------")
	for i = 1,#sortedGeoMap do
		local x = sortedGeoMap[i][1]
		local y = sortedGeoMap[i][2]
--~ 		if y == 35 or y == 40 then
--~ 			str = string.format("x = %d, y = %d",x,y)
--~ 			print(str)
--~ 		end
		DistributeRain(x,y,elevationMap,temperatureMap,geoMap,rainfallGeostrophicMap,moistureMap,true)
	end
	--zero below sea level for proper percent threshold finding
	for y = 0,elevationMap.height - 1 do
		for x = 0,elevationMap.width - 1 do
			local i = elevationMap:GetIndex(x,y)
			if elevationMap:IsBelowSeaLevel(x,y) then
				rainfallSummerMap.data[i] = 0.0
				rainfallWinterMap.data[i] = 0.0
				rainfallGeostrophicMap.data[i] = 0.0
			end
		end
	end

	rainfallSummerMap:Normalize()
	--rainfallSummerMap:Save("rainFallSummerMap.csv")
	rainfallWinterMap:Normalize()
	--rainfallWinterMap:Save("rainFallWinterMap.csv")
	rainfallGeostrophicMap:Normalize()
	--rainfallGeostrophicMap:Save("rainfallGeostrophicMap.csv")

	local rainfallMap = FloatMap:New(elevationMap.width,elevationMap.height,elevationMap.xWrap,elevationMap.yWrap)
	for y = 0,elevationMap.height - 1 do
		for x = 0,elevationMap.width - 1 do
			local i = elevationMap:GetIndex(x,y)
			rainfallMap.data[i] = rainfallSummerMap.data[i] + rainfallWinterMap.data[i] + (rainfallGeostrophicMap.data[i] * mc.geostrophicFactor)
		end
	end
	rainfallMap:Normalize()

	if debugTime then print(string.format("%4s ms for GenerateRainfallMap %s", math.floor((os.clock() - timeStart) * 1000), "End")) end
	return rainfallMap, temperatureMap
end

function DistributeRain(x,y,elevationMap,temperatureMap,pressureMap,rainfallMap,moistureMap,boolGeostrophic)

	local i = elevationMap:GetIndex(x,y)
	local upLiftSource = math.max(math.pow(pressureMap.data[i],mc.upLiftExponent),1.0 - temperatureMap.data[i])
	--local str = string.format("geo=%s,x=%d, y=%d, srcPressure uplift = %f, upliftSource = %f",tostring(boolGeostrophic),x,y,math.pow(pressureMap.data[i],mc.upLiftExponent),upLiftSource)
	--print(str)
	if elevationMap:IsBelowSeaLevel(x,y) then
		moistureMap.data[i] = math.max(moistureMap.data[i], temperatureMap.data[i])
		--print("water tile = true")
	end
	--if debugTime then print(string.format("moistureMap.data[i] = %f",moistureMap.data[i])) end

	--make list of neighbors
	local nList = {}
	if boolGeostrophic then
		local zone = elevationMap:GetZone(y)
		local dir1,dir2 = elevationMap:GetGeostrophicWindDirections(zone)
		local x1,y1 = elevationMap:GetNeighbor(x,y,dir1)
		local ii = elevationMap:GetIndex(x1,y1)
		--neighbor must be on map and in same wind zone
		if ii >= 0 and (elevationMap:GetZone(y1) == elevationMap:GetZone(y)) then
			table.insert(nList,{x1,y1})
		end
		local x2,y2 = elevationMap:GetNeighbor(x,y,dir2)
		ii = elevationMap:GetIndex(x2,y2)
		if ii >= 0 then
			table.insert(nList,{x2,y2})
		end
	else
		for dir = 1,6 do
			local xx,yy = elevationMap:GetNeighbor(x,y,dir)
			local ii = elevationMap:GetIndex(xx,yy)
			if ii >= 0 and pressureMap.data[i] <= pressureMap.data[ii] then
				table.insert(nList,{xx,yy})
			end
		end
	end
	if #nList == 0 or boolGeostrophic and #nList == 1 then
		local cost = moistureMap.data[i]
		rainfallMap.data[i] = cost
		return
	end
	local moisturePerNeighbor = moistureMap.data[i]/#nList
	--drop rain and pass moisture to neighbors
	for n = 1,#nList do
		local xx = nList[n][1]
		local yy = nList[n][2]
		local ii = elevationMap:GetIndex(xx,yy)
		local upLiftDest = math.max(math.pow(pressureMap.data[ii],mc.upLiftExponent),1.0 - temperatureMap.data[ii])
		local cost = GetRainCost(upLiftSource,upLiftDest)
		local bonus = 0.0
		if (elevationMap:GetZone(y) == mc.NPOLAR or elevationMap:GetZone(y) == mc.SPOLAR) then
			bonus = mc.polarRainBoost
		end
		if boolGeostrophic and #nList == 2 then
			if n == 1 then
				moisturePerNeighbor = (1.0 - mc.geostrophicLateralWindStrength) * moistureMap.data[i]
			else
				moisturePerNeighbor = mc.geostrophicLateralWindStrength * moistureMap.data[i]
			end
		end
		--if debugTime then print(string.format("---xx=%d, yy=%d, destPressure uplift = %f, upLiftDest = %f, cost = %f, moisturePerNeighbor = %f, bonus = %f",xx,yy,math.pow(pressureMap.data[ii],mc.upLiftExponent),upLiftDest,cost,moisturePerNeighbor,bonus)) end
		rainfallMap.data[i] = rainfallMap.data[i] + cost * moisturePerNeighbor + bonus
		--pass to neighbor.
		--if debugTime then print(string.format("---moistureMap.data[ii] = %f",moistureMap.data[ii])) end
		moistureMap.data[ii] = moistureMap.data[ii] + moisturePerNeighbor - (cost * moisturePerNeighbor)
		--if debugTime then print(string.format("---dropping %f rain",cost * moisturePerNeighbor + bonus)) end
		--if debugTime then print(string.format("---passing on %f moisture",moisturePerNeighbor - (cost * moisturePerNeighbor))) end
	end

end

function GetRainCost(upLiftSource,upLiftDest)
	local cost = mc.minimumRainCost
	cost = math.max(mc.minimumRainCost, cost + upLiftDest - upLiftSource)
	if cost < 0.0 then
		cost = 0.0
	end
	return cost
end

function GetDifferenceAroundHex(x,y)
	local avg = elevationMap:GetAverageInHex(x,y,1)
 	local i = elevationMap:GetIndex(x,y)
	return elevationMap.data[i] - avg
--~ 	local nList = elevationMap:GetRadiusAroundHex(x,y,1)
--~ 	local i = elevationMap:GetIndex(x,y)
--~ 	local biggestDiff = 0.0
--~ 	for n=1,#nList do
--~ 		local xx = nList[n][1]
--~ 		local yy = nList[n][2]
--~ 		local ii = elevationMap:GetIndex(xx,yy)
--~ 		local diff = nil
--~ 		if elevationMap:IsBelowSeaLevel(x,y) then
--~ 			diff = elevationMap.data[i] - elevationMap.seaLevelThreshold
--~ 		else
--~ 			diff = elevationMap.data[i] - elevationMap.data[ii]
--~ 		end
--~ 		if diff > biggestDiff then
--~ 			biggestDiff = diff
--~ 		end
--~ 	end
--~ 	if biggestDiff < 0.0 then
--~ 		biggestDiff = 0.0
--~ 	end
--~ 	return biggestDiff
end





-------------------------------------------------------------------------------
--functions that Civ needs
-------------------------------------------------------------------------------
function GetMapScriptInfo()
	local world_age, temperature, rainfall, sea_level, resources = GetCoreMapOptions()
	return {
		Name = "Communitas",
		Description = "Creates several large continents, island chains, and rainfall based on elevation and wind.",
		IsAdvancedMap = 0,
		SupportsMultiplayer = true,
		IconIndex = 1,
		SortIndex = 1,
		CustomOptions = {
			{
                Name = "Start Placement",
                Values = {
                    "Start Anywhere",
                    "Largest Continent"
                },
                DefaultValue = 1,
                SortPriority = 1,
            },
			resources},
	}
end

function GetMapInitData(worldSize)
	local worldsizes = {
		[GameInfo.Worlds.WORLDSIZE_DUEL.ID] = {40, 24},
		[GameInfo.Worlds.WORLDSIZE_TINY.ID] = {56, 36},
		[GameInfo.Worlds.WORLDSIZE_SMALL.ID] = {66, 42},
		[GameInfo.Worlds.WORLDSIZE_STANDARD.ID] = {80, 52},
		[GameInfo.Worlds.WORLDSIZE_LARGE.ID] = {104, 64},
		[GameInfo.Worlds.WORLDSIZE_HUGE.ID] = {128, 80}
		}
--~ 	local worldsizes = {
--~ 		[GameInfo.Worlds.WORLDSIZE_DUEL.ID] = {50, 36},
--~ 		[GameInfo.Worlds.WORLDSIZE_TINY.ID] = {60, 42},
--~ 		[GameInfo.Worlds.WORLDSIZE_SMALL.ID] = {80, 56},
--~ 		[GameInfo.Worlds.WORLDSIZE_STANDARD.ID] = {100, 70},
--~ 		[GameInfo.Worlds.WORLDSIZE_LARGE.ID] = {120, 84},
--~ 		[GameInfo.Worlds.WORLDSIZE_HUGE.ID] = {140, 98}
--~ 		}
	local grid_size = worldsizes[worldSize]
	--
	local world = GameInfo.Worlds[worldSize]
	if(world ~= nil) then
	return {
		Width = grid_size[1],
		Height = grid_size[2],
		WrapX = true,
	}
     end
end

-------------------------------------------------------------------------------------------
--ShiftMap Class
-------------------------------------------------------------------------------------------
function ShiftMaps()
	--local stripRadius = self.stripRadius
	local shift_x = 0 
	local shift_y = 0

	shift_x = DetermineXShift()
	
	ShiftMapsBy(shift_x, shift_y)
end
-------------------------------------------------------------------------------------------	
function ShiftMapsBy(xshift, yshift)	
	local W, H = Map.GetGridSize()
	if(xshift > 0 or yshift > 0) then
		local Shift = {}
		local iDestI = 0
		for iDestY = 0, H-1 do
			for iDestX = 0, W-1 do
				local iSourceX = (iDestX + xshift) % W
				
				--local iSourceY = (iDestY + yshift) % H -- If using yshift, enable this and comment out the faster line below. - Bobert13
				local iSourceY = iDestY
				
				local iSourceI = W * iSourceY + iSourceX
				Shift[iDestI] = elevationMap.data[iSourceI]
				--if debugTime then print(string.format("Shift:%d,	%f	|	eMap:%d,	%f",iDestI,Shift[iDestI],iSourceI,elevationMap.data[iSourceI])) end
				iDestI = iDestI + 1
			end
		end
		elevationMap.data = Shift --It's faster to do one large table operation here than it is to do thousands of small operations to set up a copy of the input table at the beginning. -Bobert13
	end
	return elevationMap
end
-------------------------------------------------------------------------------------------
function DetermineXShift()
	--[[ This function will align the most water-heavy vertical portion of the map with the 
	vertical map edge. This is a form of centering the landmasses, but it emphasizes the
	edge not the middle. If there are columns completely empty of land, these will tend to
	be chosen as the new map edge, but it is possible for a narrow column between two large 
	continents to be passed over in favor of the thinnest section of a continent, because
	the operation looks at a group of columns not just a single column, then picks the 
	center of the most water heavy group of columns to be the new vertical map edge. ]]--

	-- First loop through the map columns and record land plots in each column.
	local gridWidth, gridHeight = Map.GetGridSize()
	local land_totals = {}
	for x = 0, gridWidth - 1 do
		local current_column = 0
		for y = 0, gridHeight - 1 do
			local i = y * gridWidth + x + 1
			if not elevationMap:IsBelowSeaLevel(x,y) then
				current_column = current_column + 1
			end
		end
		table.insert(land_totals, current_column)
	end
	
	-- Now evaluate column groups, each record applying to the center column of the group.
	local column_groups = {}
	-- Determine the group size in relation to map width.
	local group_radius = 3
	-- Measure the groups.
	for column_index = 1, gridWidth do
		local current_group_total = 0
		--for current_column = column_index - group_radius, column_index + group_radius do
		--Changed how group_radius works to get groups of four. -Bobert13
		for current_column = column_index, column_index + group_radius do
			local current_index = current_column % gridWidth
			if current_index == 0 then -- Modulo of the last column will be zero this repairs the issue.
				current_index = gridWidth
			end
			current_group_total = current_group_total + land_totals[current_index]
		end
		table.insert(column_groups, current_group_total)
	end
	
	-- Identify the group with the least amount of land in it.
	local best_value = gridHeight * (group_radius + 1) -- Set initial value to max possible.
	local best_group = 1 -- Set initial best group as current map edge.
	for column_index, group_land_plots in ipairs(column_groups) do
		if group_land_plots < best_value then
			best_value = group_land_plots
			best_group = column_index
		end
	end
	
	-- Determine X Shift	
	local x_shift = best_group + 2

	return x_shift
end
------------------------------------------------------------------------------
--DiffMap Class
------------------------------------------------------------------------------
--Seperated this from GeneratePlotTypes() to use it in other functions. -Bobert13

DiffMap = inheritsFrom(FloatMap)

function GenerateDiffMap(width,height,xWrap,yWrap)
	DiffMap = FloatMap:New(width,height,xWrap,yWrap)
	local i = 0
	for y = 0, height - 1,1 do
		for x = 0,width - 1,1 do
			if elevationMap:IsBelowSeaLevel(x,y) then
				DiffMap.data[i] = 0.0
			else
				DiffMap.data[i] = GetDifferenceAroundHex(x,y)
			end
			i=i+1
		end
	end

	DiffMap:Normalize()
	i = 0
	for y = 0, height - 1,1 do
		for x = 0,width - 1,1 do
			if elevationMap:IsBelowSeaLevel(x,y) then
				DiffMap.data[i] = 0.0
			else
				DiffMap.data[i] = DiffMap.data[i] + elevationMap.data[i] * 1.1
			end
			i=i+1
		end
	end

	DiffMap:Normalize()
	return DiffMap
end
-------------------------------------------------------------------------------------------
function GeneratePlotTypes()
	print("Creating initial map data - PerfectWorld3")
	local timeStart = debugTime and os.clock() or 0
	local gridWidth, gridHeight = Map.GetGridSize()
	--first do all the preliminary calculations in this function
	if debugTime then print(string.format("map size: width=%d, height=%d",gridWidth,gridHeight)) end
	mc = MapConstants:New()
	PWRandSeed()
	if debugTime then print(string.format("%4s ms for GeneratePlotTypes %s", math.floor((os.clock() - timeStart) * 1000), "Start")) end

	-- Elevations
	if debugTime then timeStart = os.clock() end
	
	elevationMap = GenerateElevationMap(gridWidth,gridHeight,true,false)
	
	--elevationMap:Save("elevationMap.csv")
	if debugTime then print(string.format("%4s ms for GeneratePlotTypes %s", math.floor((os.clock() - timeStart) * 1000), "GenerateElevationMap")) end

	-- Plots
	if debugTime then timeStart = os.clock() end
	print("Generating plot types - PerfectWorld3")
	ShiftMaps()
	DiffMap = GenerateDiffMap(gridWidth,gridHeight,true,false)	
	lakePlots = FillInLakes()
	GenerateOceanRifts()
	elevationMap = SetOceanRiftElevations(elevationMap)	
	if debugTime then print(string.format("%4s ms for GeneratePlotTypes %s", math.floor((os.clock() - timeStart) * 1000), "B")) end
	
	-- Rainfall
	if debugTime then timeStart = os.clock() end	
	rainfallMap, temperatureMap = GenerateRainfallMap(elevationMap)
	--rainfallMap:Save("rainfallMap.csv")
	if debugTime then print(string.format("%4s ms for GeneratePlotTypes %s", math.floor((os.clock() - timeStart) * 1000), "GenerateRainfallMap")) end
	
	-- Rivers
	if debugTime then timeStart = os.clock() end
	riverMap = RiverMap:New(elevationMap)
	riverMap:SetJunctionAltitudes()
	riverMap:SiltifyLakes()
	riverMap:SetFlowDestinations()
	riverMap:SetRiverSizes(rainfallMap)

	--find exact thresholds
	local hillsThreshold = DiffMap:FindThresholdFromPercent(mc.hillsPercent,false,true)
	local mountainsThreshold = DiffMap:FindThresholdFromPercent(mc.mountainsPercent,false,true)
	local i = 0
	for y = 0, gridHeight - 1,1 do
		for x = 0,gridWidth - 1,1 do
			local plot = Map.GetPlot(x,y)
			if elevationMap:IsBelowSeaLevel(x,y) then
				plot:SetPlotType(PlotTypes.PLOT_OCEAN, false, false)
			elseif DiffMap.data[i] < hillsThreshold then
				plot:SetPlotType(PlotTypes.PLOT_LAND,false,false)
			--This code makes the game only ever plot flat land if it's within two tiles of 
			--the seam. This prevents issues with tiles that don't look like what they are.
			elseif x == 0 or x == 1 or x == gridWidth - 1 or x == gridWidth -2 then
				plot:SetPlotType(PlotTypes.PLOT_LAND,false,false)
			-- Bobert13
			elseif DiffMap.data[i] < mountainsThreshold then
				plot:SetPlotType(PlotTypes.PLOT_HILLS,false,false)
			else
				plot:SetPlotType(PlotTypes.PLOT_MOUNTAIN,false,false)
			end
			i=i+1
		end
	end
	Map.RecalculateAreas()	
	GenerateIslands()
	GenerateCoasts()
	if debugTime then print(string.format("%4s ms for GeneratePlotTypes %s", math.floor((os.clock() - timeStart) * 1000), "End")) end
	if debugTime then timeStart = os.clock() end
end
------------------------------------------------------------------------------

--[=[
function GeneratePlotTypes()
	print("Creating initial map data - PerfectWorld3")
	local mapW, mapH = Map.GetGridSize()
	
	
	--first do all the preliminary calculations in this function
	if debugTime then print(string.format("map size: width=%d, height=%d",mapW,mapH)) end

	mc = MapConstants:New()
	PWRandSeed()	

	elevationMap = GenerateElevationMap(mapW,mapH,true,false)
	--FillInLakes()
	--elevationMap:Save("elevationMap.csv")	

	rainfallMap, temperatureMap = GenerateRainfallMap(elevationMap)
	--rainfallMap:Save("rainfallMap.csv")

	riverMap = RiverMap:New(elevationMap)
	riverMap:SetJunctionAltitudes()
	riverMap:SiltifyLakes()
	riverMap:SetFlowDestinations()
	riverMap:SetRiverSizes(rainfallMap)

	--now gen plot types
	print("Generating plot types - PerfectWorld3")
	local diffMap = FloatMap:New(mapW,mapH,true,false)
	for y = 0, mapH-1 do
		for x = 0,mapW-1 do
			local i = diffMap:GetIndex(x,y)
			if elevationMap:IsBelowSeaLevel(x,y) then
				diffMap.data[i] = 0.0
			else
				diffMap.data[i] = GetDifferenceAroundHex(x,y)
			end
		end
	end

	diffMap:Normalize()

	for y = 0, mapH-1 do
		for x = 0,mapW-1 do
			local i = diffMap:GetIndex(x,y)
			if elevationMap:IsBelowSeaLevel(x,y) then
				diffMap.data[i] = 0.0
			else
				diffMap.data[i] = diffMap.data[i] + elevationMap.data[i] * 1.1
			end
		end
	end

	diffMap:Normalize()

	--find exact thresholds
	local hillsThreshold = diffMap:FindThresholdFromPercent(mc.hillsPercent,false,true)
	local mountainsThreshold = diffMap:FindThresholdFromPercent(mc.mountainsPercent,false,true)

	for y = 0, mapH-1 do
		for x = 0,mapW-1 do
			local i = diffMap:GetIndex(x,y)
			local plot = Map.GetPlot(x, y)
			if elevationMap:IsBelowSeaLevel(x,y) then
				plot:SetPlotType(PlotTypes.PLOT_OCEAN, false, false)
			elseif diffMap.data[i] < hillsThreshold then
				plot:SetPlotType(PlotTypes.PLOT_LAND,false,false)
			elseif diffMap.data[i] < mountainsThreshold then
				plot:SetPlotType(PlotTypes.PLOT_HILLS,false,false)
			else
				plot:SetPlotType(PlotTypes.PLOT_MOUNTAIN,false,false)
			end
		end
	end
	
	Map.RecalculateAreas()
	GenerateIslands()
	GenerateCoasts()
end
--]=]

function GenerateOceanRifts()
	-- Creates simple ocean rifts by placing randomly-pathing ocean lines from north to south.
	local width, height = Map.GetGridSize()
	
	CreateOceanRift(0)
	CreateOceanRift(width / 2)
end

function SetOceanRiftElevations(elevationMap)
	for _, plot in pairs(mc.oceanRiftPlots) do
		elevationMap.data[elevationMap:GetIndex(plot:GetX(), plot:GetY())] = elevationMap.seaLevelThreshold - 1
	end
	return elevationMap
end

function SetOceanRiftPlots()
	for _, plot in pairs(mc.oceanRiftPlots) do
		plot:SetTerrainType(TerrainTypes.TERRAIN_OCEAN, false, true)
	end
end

function CreateOceanRift(midline)
	local width, height = Map.GetGridSize()
	print (string.format("Creating ocean rift at %s on map size (%s, %s)", midline, width, height))
	
	local lowerBound = midline - 0.2 * width
	local upperBound = midline + 0.2 * width
	
	local plotX = midline
	local plotY = 0
	
	while plotY < height - 1 do
		--if debugTime then print(string.format("Creating ocean at (%s, %s)", plotX, plotY))	 end
		
		table.insert(mc.oceanRiftPlots, Map.GetPlot((plotX-2) % width, plotY % height))
		table.insert(mc.oceanRiftPlots, Map.GetPlot((plotX-1) % width, plotY % height))
		table.insert(mc.oceanRiftPlots, Map.GetPlot((plotX+0) % width, plotY % height))
		table.insert(mc.oceanRiftPlots, Map.GetPlot((plotX+1) % width, plotY % height))
		table.insert(mc.oceanRiftPlots, Map.GetPlot((plotX+2) % width, plotY % height))
		
		plotY = plotY + 1
		
		if plotX >= upperBound then
			plotX = plotX - 1
		elseif plotX <= lowerBound then
			plotX = plotX + 1
		else
			plotX = plotX + (Map.Rand(3, "Ocean Rifts - Lua") - 1)
		end
	end
end

function FixRivers()
	-- No artwork was created for an alluvial fan, so rivers should not end on land tiles.
	-- http://wiki.2kgames.com/civ5/index.php/River_system_overview
	
	print("Fixing Rivers")
	local iW, iH = Map.GetGridSize()
	for x = 0, iW - 1 do
		for y = 0, iH - 1 do
			local plot = Map.GetPlot(x, y)
			if plot:IsRiverSide() then
				if Plot_IsRiverBroken(plot, DirectionTypes.DIRECTION_EAST) then
					print("Fix river")
					plot:SetFeatureType(FeatureTypes.FEATURE_ICE, -1)
					--Plot_SetRiver(plot, DirectionTypes.DIRECTION_EAST, FlowDirectionTypes.NO_FLOWDIRECTION)
				end
				if Plot_IsRiverBroken(plot, DirectionTypes.DIRECTION_SOUTHWEST) then
					print("Fix river")
					plot:SetFeatureType(FeatureTypes.FEATURE_ICE, -1)
					--Plot_SetRiver(plot, DirectionTypes.DIRECTION_SOUTHWEST, FlowDirectionTypes.NO_FLOWDIRECTION)
				end
				if Plot_IsRiverBroken(plot, DirectionTypes.DIRECTION_SOUTHEAST) then
					print("Fix river")
					plot:SetFeatureType(FeatureTypes.FEATURE_ICE, -1)
					--Plot_SetRiver(plot, DirectionTypes.DIRECTION_SOUTHEAST, FlowDirectionTypes.NO_FLOWDIRECTION)
				end
			end
		end
	end
end


function Plot_IsRiverBroken(plot, edgeDirection)
	local plotOverEdge = Map.PlotDirection(plot:GetX(), plot:GetY(), edgeDirection)
	
	-- There is no artwork for an alluvial fan, so rivers should not end on land tiles.
	
	-- Is river?
	if not Plot_IsRiver(plot, edgeDirection) or not plotOverEdge then
		return false
	end
	
	--[[ Double ocean?
	if plot:GetPlotType() ~= PlotTypes.PLOT_OCEAN and plotOverEdge:GetPlotType() ~= PlotTypes.PLOT_OCEAN then
		return false
	end
	--]]
	
	-- Is the next plot a land tile?
	local nextPlot = Plot_GetNextRiverPlot(plot, edgeDirection)
	if not nextPlot or nextPlot:GetPlotType() == PlotTypes.PLOT_OCEAN then
		return false
	end
	
	-- Does it continue the river?
	if Plot_IsRiverContinued(plot, edgeDirection) then
		return false
	end
	
	return true
end


function Plot_IsRiverContinued(plot, edgeDirection)
	local flowDirection = Plot_GetRiverFlowDirection(plot, edgeDirection)
	local nextPlot = Plot_GetNextRiverPlot(plot, edgeDirection)
	if not nextPlot then
		return false
	end
	
	if edgeDirection == DirectionTypes.DIRECTION_EAST then
		if flowDirection == FlowDirectionTypes.FLOWDIRECTION_NORTH then
			if Plot_IsRiver(nextPlot, DirectionTypes.DIRECTION_SOUTHEAST) or Plot_IsRiver(nextPlot, DirectionTypes.DIRECTION_SOUTHWEST) then
				return true
			end
		elseif flowDirection == FlowDirectionTypes.FLOWDIRECTION_SOUTH then
			if Plot_IsRiver(nextPlot, DirectionTypes.DIRECTION_NORTHEAST) or Plot_IsRiver(nextPlot, DirectionTypes.DIRECTION_NORTHWEST) then
				return true
			end
		end
	elseif edgeDirection == DirectionTypes.DIRECTION_NORTHEAST then
		if flowDirection == FlowDirectionTypes.FLOWDIRECTION_SOUTHEAST then
			if Plot_IsRiver(nextPlot, DirectionTypes.DIRECTION_NORTHWEST) or Plot_IsRiver(nextPlot, DirectionTypes.DIRECTION_WEST) then
				return true
			end
		elseif flowDirection == FlowDirectionTypes.FLOWDIRECTION_NORTHWEST then
			if Plot_IsRiver(nextPlot, DirectionTypes.DIRECTION_SOUTHEAST) or Plot_IsRiver(nextPlot, DirectionTypes.DIRECTION_EAST) then
				return true
			end
		end
	elseif edgeDirection == DirectionTypes.DIRECTION_NORTHWEST then
		if flowDirection == FlowDirectionTypes.FLOWDIRECTION_SOUTHWEST then
			if Plot_IsRiver(nextPlot, DirectionTypes.DIRECTION_NORTHEAST) or Plot_IsRiver(nextPlot, DirectionTypes.DIRECTION_EAST) then
				return true
			end
		elseif flowDirection == FlowDirectionTypes.FLOWDIRECTION_NORTHEAST then
			if Plot_IsRiver(nextPlot, DirectionTypes.DIRECTION_SOUTHWEST) or Plot_IsRiver(nextPlot, DirectionTypes.DIRECTION_WEST) then
				return true
			end
		end
	end
	return false
end

function Plot_GetNextRiverPlot(plot, edgeDirection)
	local flowDirection = Plot_GetRiverFlowDirection(plot, edgeDirection)
	local nextPlot = nil
	
	if edgeDirection == DirectionTypes.DIRECTION_EAST then
		if flowDirection == FlowDirectionTypes.FLOWDIRECTION_NORTH then
			nextPlot = Map.PlotDirection(plot:GetX(), plot:GetY(), DirectionTypes.DIRECTION_NORTHEAST) 
		elseif flowDirection == FlowDirectionTypes.FLOWDIRECTION_SOUTH then
			nextPlot = Map.PlotDirection(plot:GetX(), plot:GetY(), DirectionTypes.DIRECTION_SOUTHEAST) 
		end
	elseif edgeDirection == DirectionTypes.DIRECTION_NORTHEAST then
		if flowDirection == FlowDirectionTypes.FLOWDIRECTION_SOUTHEAST then
			nextPlot = Map.PlotDirection(plot:GetX(), plot:GetY(), DirectionTypes.DIRECTION_EAST) 
		elseif flowDirection == FlowDirectionTypes.FLOWDIRECTION_NORTHWEST then
			nextPlot = Map.PlotDirection(plot:GetX(), plot:GetY(), DirectionTypes.DIRECTION_NORTHWEST) 
		end
	elseif edgeDirection == DirectionTypes.DIRECTION_NORTHWEST then
		if flowDirection == FlowDirectionTypes.FLOWDIRECTION_SOUTHWEST then
			nextPlot = Map.PlotDirection(plot:GetX(), plot:GetY(), DirectionTypes.DIRECTION_WEST) 
		elseif flowDirection == FlowDirectionTypes.FLOWDIRECTION_NORTHEAST then
			nextPlot = Map.PlotDirection(plot:GetX(), plot:GetY(), DirectionTypes.DIRECTION_NORTHEAST) 
		end
	end
	
	return nextPlot
end

function Plot_GetRiverFlowDirection(plot, edgeDirection)
	if edgeDirection == DirectionTypes.DIRECTION_EAST then
		return plot:GetRiverEFlowDirection()
	elseif edgeDirection == DirectionTypes.DIRECTION_NORTHEAST then
		return plot:GetRiverNEFlowDirection()
	elseif edgeDirection == DirectionTypes.DIRECTION_NORTHWEST then
		return plot:GetRiverNWFlowDirection()
	end
	return FlowDirectionTypes.NO_FLOWDIRECTION
end

function Plot_IsRiver(plot, edgeDirection)
	if edgeDirection == DirectionTypes.DIRECTION_EAST then
		return plot:IsWOfRiver()
	elseif edgeDirection == DirectionTypes.DIRECTION_SOUTHEAST then
		return plot:IsNWOfRiver()
	elseif edgeDirection == DirectionTypes.DIRECTION_SOUTHWEST then
		return plot:IsNEOfRiver()
	else
		plot = Map.PlotDirection(plot:GetX(), plot:GetY(), edgeDirection)
		if not plot then
			return false
		end
		if edgeDirection == DirectionTypes.DIRECTION_WEST then
			return plot:IsWOfRiver()
		elseif edgeDirection == DirectionTypes.DIRECTION_NORTHEAST then
			return plot:IsNEOfRiver()
		elseif edgeDirection == DirectionTypes.DIRECTION_NORTHWEST then
			return plot:IsNWOfRiver()
		end
	end
	return false
end

function Plot_SetRiver(plot, edgeDirection, flowDirection)
	local isRiver = (flowDirection ~= FlowDirectionTypes.NO_FLOWDIRECTION)
	if edgeDirection == DirectionTypes.DIRECTION_EAST then
		plot:SetWOfRiver(isRiver, flowDirection)
	elseif edgeDirection == DirectionTypes.DIRECTION_SOUTHEAST then
		plot:SetNWOfRiver(isRiver, flowDirection)
	elseif edgeDirection == DirectionTypes.DIRECTION_SOUTHWEST then
		plot:SetNEOfRiver(isRiver, flowDirection)
	end
end

function GenerateIslands()
	-- A cell system will be used to combine predefined land chunks with randomly generated island groups.
	-- Define the cell traits. (These need to fit correctly with the map grid width and height.)
	local iW, iH = Map.GetGridSize()
	local iCellWidth = 10
	local iCellHeight = 8
	local iNumCellColumns = math.floor(iW / iCellWidth)
	local iNumCellRows = math.floor(iH / iCellHeight)
	local iNumTotalCells = iNumCellColumns * iNumCellRows
	local cell_data = table.fill(false, iNumTotalCells) -- Stores data on map cells in use. All cells begin as empty.
	local iNumCellsInUse = 0
	local iNumCellTarget = math.floor(iNumTotalCells * 0.66)
	local island_chain_PlotTypes = table.fill(PlotTypes.PLOT_OCEAN, iW * iH)

	-- Add randomly generated island groups
	local iNumGroups = iNumCellTarget -- Should virtually never use all the groups.
	for group = 1, iNumGroups do
		if iNumCellsInUse >= iNumCellTarget then -- Map has reeached desired island population.
			print("-") print("** Number of Island Groups produced:", group - 1) print("-")
			break
		end
		--[[ Formation Chart
		1. Single Cell, Axis Only
		2. Double Cell, Horizontal, Axis Only
		3. Single Cell With Dots
		4. Double Cell, Horizontal, With Shifted Dots
		5. Double Cell, Vertical, Axis Only
		6. Double Cell, Vertical, With Shifted Dots
		7. Triple Cell, Vertical, With Double Dots
		8. Square of Cells 2x2 With Double Dots
		9. Rectangle 3x2 With Double Dots
		10. Rectangle 2x3 With Double Dots ]]--
		--
		-- Choose a formation
		local rate_threshold = {}
		local total_appearance_rate, iNumFormations = 0, 0
		local appearance_rates = { -- These numbers are relative to one another. No specific target total is necessary.
			7, -- #1
			3, -- #2
			15, --#3
			8, -- #4
			3, -- #5
			6, -- #6
			4, -- #7
			6, -- #8
			4, -- #9
			3, -- #10
		}
		for i, rate in ipairs(appearance_rates) do
			total_appearance_rate = total_appearance_rate + rate
			iNumFormations = iNumFormations + 1
		end
		local accumulated_rate = 0
		for index = 1, iNumFormations do
			local threshold = (appearance_rates[index] + accumulated_rate) * 10000 / total_appearance_rate
			table.insert(rate_threshold, threshold)
			accumulated_rate = accumulated_rate + appearance_rates[index]
		end
		local formation_type
		local diceroll = Map.Rand(10000, "Choose formation type - Island Making - Lua")
		for index, threshold in ipairs(rate_threshold) do
			if diceroll <= threshold then -- Choose this formation type.
				formation_type = index
				break
			end
		end
		-- Choose cell(s) not in use
		local iNumAttemptsToFindOpenCells = 0
		local found_unoccupied_cell = false
		local anchor_cell, cell_x, cell_y, foo
		while found_unoccupied_cell == false do
			if iNumAttemptsToFindOpenCells > 100 then -- Too many attempts on this pass. Might not be any valid locations for this formation.
				print("-") print("*-* ERROR:  Formation type of", formation_type, "for island group#", group, "unable to find an open space. Switching to single-cell.")
				formation_type = 3 -- Reset formation type.
				iNumAttemptsToFindOpenCells = 0
			end
			local diceroll = 1 + Map.Rand(iNumTotalCells, "Choosing a cell for an island group - Polynesia LUA")
			if cell_data[diceroll] == false then -- Anchor cell is unoccupied.
				-- If formation type is multiple-cell, all secondary cells must also be unoccupied.
				if formation_type == 1 or formation_type == 3 then -- single cell, proceed.
					anchor_cell = diceroll
					found_unoccupied_cell = true
				elseif formation_type == 2 or formation_type == 4 then -- double cell, horizontal.
					-- Check to see if anchor cell is in the final column. If so, reject.
					cell_x = math.fmod(diceroll, iNumCellColumns)
					if cell_x ~= 0 then -- Anchor cell is valid, but still have to check adjacent cell.
						if cell_data[diceroll + 1] == false then -- Adjacent cell is unoccupied.
							anchor_cell = diceroll
							found_unoccupied_cell = true
						end
					end
				elseif formation_type == 5 or formation_type == 6 then -- double cell, vertical.
					-- Check to see if anchor cell is in the final row. If so, reject.
					cell_y, foo = math.modf(diceroll / iNumCellColumns)
					cell_y = cell_y + 1
					if cell_y < iNumCellRows then -- Anchor cell is valid, but still have to check cell above it.
						if cell_data[diceroll + iNumCellColumns] == false then -- Adjacent cell is unoccupied.
							anchor_cell = diceroll
							found_unoccupied_cell = true
						end
					end
				elseif formation_type == 7 then -- triple cell, vertical.
					-- Check to see if anchor cell is in the northern two rows. If so, reject.
					cell_y, foo = math.modf(diceroll / iNumCellColumns)
					cell_y = cell_y + 1
					if cell_y < iNumCellRows - 1 then -- Anchor cell is valid, but still have to check cells above it.
						if cell_data[diceroll + iNumCellColumns] == false then -- Cell directly above is unoccupied.
							if cell_data[diceroll + (iNumCellColumns * 2)] == false then -- Cell two rows above is unoccupied.
								anchor_cell = diceroll
								found_unoccupied_cell = true
							end
						end
					end
				elseif formation_type == 8 then -- square, 2x2.
					-- Check to see if anchor cell is in the final row or column. If so, reject.
					cell_x = math.fmod(diceroll, iNumCellColumns)
					if cell_x ~= 0 then
						cell_y, foo = math.modf(diceroll / iNumCellColumns)
						cell_y = cell_y + 1
						if cell_y < iNumCellRows then -- Anchor cell is valid. Still have to check the other three cells.
							if cell_data[diceroll + iNumCellColumns] == false then
								if cell_data[diceroll + 1] == false then
									if cell_data[diceroll + iNumCellColumns + 1] == false then -- All cells are open.
										anchor_cell = diceroll
										found_unoccupied_cell = true
									end
								end
							end
						end
					end
				elseif formation_type == 9 then -- horizontal, 3x2.
					-- Check to see if anchor cell is too near to an edge. If so, reject.
					cell_x = math.fmod(diceroll, iNumCellColumns)
					if cell_x ~= 0 and cell_x ~= iNumCellColumns - 1 then
						cell_y, foo = math.modf(diceroll / iNumCellColumns)
						cell_y = cell_y + 1
						if cell_y < iNumCellRows then -- Anchor cell is valid. Still have to check the other cells.
							if cell_data[diceroll + iNumCellColumns] == false then
								if cell_data[diceroll + 1] == false and cell_data[diceroll + 2] == false then
									if cell_data[diceroll + iNumCellColumns + 1] == false then
										if cell_data[diceroll + iNumCellColumns + 2] == false then -- All cells are open.
											anchor_cell = diceroll
											found_unoccupied_cell = true
										end
									end
								end
							end
						end
					end
				elseif formation_type == 10 then -- vertical, 2x3.
					-- Check to see if anchor cell is too near to an edge. If so, reject.
					cell_x = math.fmod(diceroll, iNumCellColumns)
					if cell_x ~= 0 then
						cell_y, foo = math.modf(diceroll / iNumCellColumns)
						cell_y = cell_y + 1
						if cell_y < iNumCellRows - 1 then -- Anchor cell is valid. Still have to check the other cells.
							if cell_data[diceroll + iNumCellColumns] == false then
								if cell_data[diceroll + 1] == false then
									if cell_data[diceroll + iNumCellColumns + 1] == false then
										if cell_data[diceroll + (iNumCellColumns * 2)] == false then
											if cell_data[diceroll + (iNumCellColumns * 2) + 1] == false then -- All cells are open.
												anchor_cell = diceroll
												found_unoccupied_cell = true
											end
										end
									end
								end
							end
						end
					end
				end
			end
			iNumAttemptsToFindOpenCells = iNumAttemptsToFindOpenCells + 1
		end
		-- Find Cell X and Y
		cell_x = math.fmod(anchor_cell, iNumCellColumns)
		if cell_x == 0 then
			cell_x = iNumCellColumns
		end
		cell_y, foo = math.modf(anchor_cell / iNumCellColumns)
		cell_y = cell_y + 1
		
		-- Debug
		--print("-") print("-") print("* Group# " .. group, "Formation Type: " .. formation_type, "Cell X, Y: " .. cell_x .. ", " .. cell_y)

		-- Create this island group.
		local iWidth, iHeight, fTilt -- Scope the variables needed for island group creation.
		local plot_data = {}
		local x_shift, y_shift
		if formation_type == 1 then -- single cell
			local x_shrinkage = Map.Rand(4, "Cell Width adjustment - Lua")
			if x_shrinkage > 2 then
				x_shrinkage = 0
			end
			local y_shrinkage = Map.Rand(5, "Cell Height adjustment - Lua")
			if y_shrinkage > 2 then
				y_shrinkage = 0
			end
			x_shift, y_shift = 0, 0
			if x_shrinkage > 0 then
				x_shift = Map.Rand(x_shrinkage, "Cell Width offset - Lua")
			end
			if y_shrinkage > 0 then
				y_shift = Map.Rand(y_shrinkage, "Cell Height offset - Lua")
			end
			iWidth = iCellWidth - x_shrinkage
			iHeight = iCellHeight - y_shrinkage
			fTilt = Map.Rand(181, "Angle for island chain axis - LUA")
			plot_data = CreateSingleAxisIslandChain(iWidth, iHeight, fTilt)

		elseif formation_type == 2 then -- two cells, horizontal
			local x_shrinkage = Map.Rand(8, "Cell Width adjustment - Lua")
			if x_shrinkage > 5 then
				x_shrinkage = 0
			end
			local y_shrinkage = Map.Rand(5, "Cell Height adjustment - Lua")
			if y_shrinkage > 2 then
				y_shrinkage = 0
			end
			x_shift, y_shift = 0, 0
			if x_shrinkage > 0 then
				x_shift = Map.Rand(x_shrinkage, "Cell Width offset - Lua")
			end
			if y_shrinkage > 0 then
				y_shift = Map.Rand(y_shrinkage, "Cell Height offset - Lua")
			end
			iWidth = iCellWidth * 2 - x_shrinkage
			iHeight = iCellHeight - y_shrinkage
			-- Limit angles to mostly horizontal ones.
			fTilt = 145 + Map.Rand(90, "Angle for island chain axis - LUA")
			if fTilt > 180 then
				fTilt = fTilt - 180
			end
			plot_data = CreateSingleAxisIslandChain(iWidth, iHeight, fTilt)
			
		elseif formation_type == 3 then -- single cell, with dots
			local x_shrinkage = Map.Rand(4, "Cell Width adjustment - Lua")
			if x_shrinkage > 2 then
				x_shrinkage = 0
			end
			local y_shrinkage = Map.Rand(5, "Cell Height adjustment - Lua")
			if y_shrinkage > 2 then
				y_shrinkage = 0
			end
			x_shift, y_shift = 0, 0
			if x_shrinkage > 0 then
				x_shift = Map.Rand(x_shrinkage, "Cell Width offset - Lua")
			end
			if y_shrinkage > 0 then
				y_shift = Map.Rand(y_shrinkage, "Cell Height offset - Lua")
			end
			iWidth = iCellWidth - x_shrinkage
			iHeight = iCellHeight - y_shrinkage
			fTilt = Map.Rand(181, "Angle for island chain axis - LUA")
			-- Determine "dot box"
			local iInnerWidth, iInnerHeight = iWidth - 2, iHeight - 2
			-- Determine number of dots
			local die_1 = Map.Rand(4, "Diceroll - Lua")
			local die_2 = Map.Rand(8, "Diceroll - Lua")
			local iNumDots = 4
			if die_1 + die_2 > 1 then
				iNumDots = iNumDots + Map.Rand(die_1 + die_2, "Number of dots to add to island chain - Lua")
			else
				iNumDots = iNumDots + die_1 + die_2
			end
			plot_data = CreateAxisChainWithDots(iWidth, iHeight, fTilt, iInnerWidth, iInnerHeight, iNumDots)

		elseif formation_type == 4 then -- two cells, horizontal, with dots
			local x_shrinkage = Map.Rand(8, "Cell Width adjustment - Lua")
			if x_shrinkage > 5 then
				x_shrinkage = 0
			end
			local y_shrinkage = Map.Rand(5, "Cell Height adjustment - Lua")
			if y_shrinkage > 2 then
				y_shrinkage = 0
			end
			x_shift, y_shift = 0, 0
			if x_shrinkage > 0 then
				x_shift = Map.Rand(x_shrinkage, "Cell Width offset - Lua")
			end
			if y_shrinkage > 0 then
				y_shift = Map.Rand(y_shrinkage, "Cell Height offset - Lua")
			end
			iWidth = iCellWidth * 2 - x_shrinkage
			iHeight = iCellHeight - y_shrinkage
			-- Limit angles to mostly horizontal ones.
			fTilt = 145 + Map.Rand(90, "Angle for island chain axis - LUA")
			if fTilt > 180 then
				fTilt = fTilt - 180
			end
			-- Determine "dot box"
			local iInnerWidth = math.floor(iWidth / 2)
			local iInnerHeight = iHeight - 2
			local iInnerWest = 2 + Map.Rand((iWidth - 1) - iInnerWidth, "Shift for sub island group - Lua")
			local iInnerSouth = 2
			-- Determine number of dots
			local die_1 = Map.Rand(4, "Diceroll - Lua")
			local die_2 = Map.Rand(10, "Diceroll - Lua")
			local iNumDots = 5
			if die_1 + die_2 > 1 then
				iNumDots = iNumDots + Map.Rand(die_1 + die_2, "Number of dots to add to island chain - Lua")
			else
				iNumDots = iNumDots + die_1 + die_2
			end
			plot_data = CreateAxisChainWithShiftedDots(iWidth, iHeight, fTilt, iInnerWidth, iInnerHeight, iInnerWest, iInnerSouth, iNumDots)
			
		elseif formation_type == 5 then -- Double Cell, Vertical, Axis Only
			local x_shrinkage = Map.Rand(5, "Cell Width adjustment - Lua")
			if x_shrinkage > 2 then
				x_shrinkage = 0
			end
			local y_shrinkage = Map.Rand(7, "Cell Height adjustment - Lua")
			if y_shrinkage > 4 then
				y_shrinkage = 0
			end
			x_shift, y_shift = 0, 0
			if x_shrinkage > 0 then
				x_shift = Map.Rand(x_shrinkage, "Cell Width offset - Lua")
			end
			if y_shrinkage > 0 then
				y_shift = Map.Rand(y_shrinkage, "Cell Height offset - Lua")
			end
			iWidth = iCellWidth - x_shrinkage
			iHeight = iCellHeight * 2 - y_shrinkage
			-- Limit angles to mostly vertical ones.
			fTilt = 55 + Map.Rand(71, "Angle for island chain axis - LUA")
			plot_data = CreateSingleAxisIslandChain(iWidth, iHeight, fTilt)
		
		elseif formation_type == 6 then -- Double Cell, Vertical With Dots
			local x_shrinkage = Map.Rand(5, "Cell Width adjustment - Lua")
			if x_shrinkage > 2 then
				x_shrinkage = 0
			end
			local y_shrinkage = Map.Rand(7, "Cell Height adjustment - Lua")
			if y_shrinkage > 4 then
				y_shrinkage = 0
			end
			x_shift, y_shift = 0, 0
			if x_shrinkage > 0 then
				x_shift = Map.Rand(x_shrinkage, "Cell Width offset - Lua")
			end
			if y_shrinkage > 0 then
				y_shift = Map.Rand(y_shrinkage, "Cell Height offset - Lua")
			end
			iWidth = iCellWidth - x_shrinkage
			iHeight = iCellHeight * 2 - y_shrinkage
			-- Limit angles to mostly vertical ones.
			fTilt = 55 + Map.Rand(71, "Angle for island chain axis - LUA")
			-- Determine "dot box"
			local iInnerWidth = iWidth - 2
			local iInnerHeight = math.floor(iHeight / 2)
			local iInnerWest = 2
			local iInnerSouth = 2 + Map.Rand((iHeight - 1) - iInnerHeight, "Shift for sub island group - Lua")
			-- Determine number of dots
			local die_1 = Map.Rand(4, "Diceroll - Lua")
			local die_2 = Map.Rand(10, "Diceroll - Lua")
			local iNumDots = 5
			if die_1 + die_2 > 1 then
				iNumDots = iNumDots + Map.Rand(die_1 + die_2, "Number of dots to add to island chain - Lua")
			else
				iNumDots = iNumDots + die_1 + die_2
			end
			plot_data = CreateAxisChainWithShiftedDots(iWidth, iHeight, fTilt, iInnerWidth, iInnerHeight, iInnerWest, iInnerSouth, iNumDots)
		
		elseif formation_type == 7 then -- Triple Cell, Vertical With Double Dots
			local x_shrinkage = Map.Rand(4, "Cell Width adjustment - Lua")
			if x_shrinkage > 1 then
				x_shrinkage = 0
			end
			local y_shrinkage = Map.Rand(9, "Cell Height adjustment - Lua")
			if y_shrinkage > 5 then
				y_shrinkage = 0
			end
			x_shift, y_shift = 0, 0
			if x_shrinkage > 0 then
				x_shift = Map.Rand(x_shrinkage, "Cell Width offset - Lua")
			end
			if y_shrinkage > 0 then
				y_shift = Map.Rand(y_shrinkage, "Cell Height offset - Lua")
			end
			iWidth = iCellWidth - x_shrinkage
			iHeight = iCellHeight * 3 - y_shrinkage
			-- Limit angles to steep ones.
			fTilt = 70 + Map.Rand(41, "Angle for island chain axis - LUA")
			-- Handle Dots Group 1.
			local iInnerWidth1 = iWidth - 3
			local iInnerHeight1 = iCellHeight - 1
			local iInnerWest1 = 2 + Map.Rand(2, "Shift for sub island group - Lua")
			local iInnerSouth1 = 2 + Map.Rand(iCellHeight - 3, "Shift for sub island group - Lua")
			-- Determine number of dots
			local die_1 = Map.Rand(4, "Diceroll - Lua")
			local die_2 = Map.Rand(8, "Diceroll - Lua")
			local iNumDots1 = 4
			if die_1 + die_2 > 1 then
				iNumDots1 = iNumDots1 + Map.Rand(die_1 + die_2, "Number of dots to add to island chain - Lua")
			else
				iNumDots1 = iNumDots1 + die_1 + die_2
			end
			-- Handle Dots Group 2.
			local iInnerWidth2 = iWidth - 3
			local iInnerHeight2 = iCellHeight - 1
			local iInnerWest2 = 2 + Map.Rand(2, "Shift for sub island group - Lua")
			local iInnerSouth2 = iCellHeight + 2 + Map.Rand(iCellHeight - 3, "Shift for sub island group - Lua")
			-- Determine number of dots
			local die_1 = Map.Rand(4, "Diceroll - Lua")
			local die_2 = Map.Rand(8, "Diceroll - Lua")
			local iNumDots2 = 4
			if die_1 + die_2 > 1 then
				iNumDots2 = iNumDots2 + Map.Rand(die_1 + die_2, "Number of dots to add to island chain - Lua")
			else
				iNumDots2 = iNumDots2 + die_1 + die_2
			end
			plot_data = CreateAxisChainWithDoubleDots(iWidth, iHeight, fTilt, iInnerWidth1, iInnerHeight1, iInnerWest1, iInnerSouth1,
                                                      iNumDots1, iInnerWidth2, iInnerHeight2, iInnerWest2, iInnerSouth2, iNumDots2)
		elseif formation_type == 8 then -- Square Block 2x2 With Double Dots
			local x_shrinkage = Map.Rand(6, "Cell Width adjustment - Lua")
			if x_shrinkage > 4 then
				x_shrinkage = 0
			end
			local y_shrinkage = Map.Rand(5, "Cell Height adjustment - Lua")
			if y_shrinkage > 3 then
				y_shrinkage = 0
			end
			x_shift, y_shift = 0, 0
			if x_shrinkage > 0 then
				x_shift = Map.Rand(x_shrinkage, "Cell Width offset - Lua")
			end
			if y_shrinkage > 0 then
				y_shift = Map.Rand(y_shrinkage, "Cell Height offset - Lua")
			end
			iWidth = iCellWidth * 2 - x_shrinkage
			iHeight = iCellHeight * 2 - y_shrinkage
			-- Full range of angles
			fTilt = Map.Rand(181, "Angle for island chain axis - LUA")
			-- Handle Dots Group 1.
			local iInnerWidth1 = iCellWidth - 2
			local iInnerHeight1 = iCellHeight - 2
			local iInnerWest1 = 3 + Map.Rand(iCellWidth - 2, "Shift for sub island group - Lua")
			local iInnerSouth1 = 3 + Map.Rand(iCellHeight - 2, "Shift for sub island group - Lua")
			-- Determine number of dots
			local die_1 = Map.Rand(6, "Diceroll - Lua")
			local die_2 = Map.Rand(10, "Diceroll - Lua")
			local iNumDots1 = 5
			if die_1 + die_2 > 1 then
				iNumDots1 = iNumDots1 + Map.Rand(die_1 + die_2, "Number of dots to add to island chain - Lua")
			else
				iNumDots1 = iNumDots1 + die_1 + die_2
			end
			-- Handle Dots Group 2.
			local iInnerWidth2 = iCellWidth - 2
			local iInnerHeight2 = iCellHeight - 2
			local iInnerWest2 = 3 + Map.Rand(iCellWidth - 2, "Shift for sub island group - Lua")
			local iInnerSouth2 = 3 + Map.Rand(iCellHeight - 2, "Shift for sub island group - Lua")
			-- Determine number of dots
			local die_1 = Map.Rand(4, "Diceroll - Lua")
			local die_2 = Map.Rand(8, "Diceroll - Lua")
			local iNumDots2 = 5
			if die_1 + die_2 > 1 then
				iNumDots2 = iNumDots2 + Map.Rand(die_1 + die_2, "Number of dots to add to island chain - Lua")
			else
				iNumDots2 = iNumDots2 + die_1 + die_2
			end
			plot_data = CreateAxisChainWithDoubleDots(iWidth, iHeight, fTilt, iInnerWidth1, iInnerHeight1, iInnerWest1, iInnerSouth1,
                                                      iNumDots1, iInnerWidth2, iInnerHeight2, iInnerWest2, iInnerSouth2, iNumDots2)

		elseif formation_type == 9 then -- Horizontal Block 3x2 With Double Dots
			local x_shrinkage = Map.Rand(8, "Cell Width adjustment - Lua")
			if x_shrinkage > 5 then
				x_shrinkage = 0
			end
			local y_shrinkage = Map.Rand(5, "Cell Height adjustment - Lua")
			if y_shrinkage > 3 then
				y_shrinkage = 0
			end
			x_shift, y_shift = 0, 0
			if x_shrinkage > 0 then
				x_shift = Map.Rand(x_shrinkage, "Cell Width offset - Lua")
			end
			if y_shrinkage > 0 then
				y_shift = Map.Rand(y_shrinkage, "Cell Height offset - Lua")
			end
			iWidth = iCellWidth * 3 - x_shrinkage
			iHeight = iCellHeight * 2 - y_shrinkage
			-- Limit angles to mostly horizontal ones.
			fTilt = 145 + Map.Rand(90, "Angle for island chain axis - LUA")
			if fTilt > 180 then
				fTilt = fTilt - 180
			end
			-- Handle Dots Group 1.
			local iInnerWidth1 = iCellWidth
			local iInnerHeight1 = iCellHeight - 2
			local iInnerWest1 = 4 + Map.Rand(iCellWidth + 2, "Shift for sub island group - Lua")
			local iInnerSouth1 = 3 + Map.Rand(iCellHeight - 2, "Shift for sub island group - Lua")
			-- Determine number of dots
			local die_1 = Map.Rand(4, "Diceroll - Lua")
			local die_2 = Map.Rand(8, "Diceroll - Lua")
			local iNumDots1 = 9
			if die_1 + die_2 > 1 then
				iNumDots1 = iNumDots1 + Map.Rand(die_1 + die_2, "Number of dots to add to island chain - Lua")
			else
				iNumDots1 = iNumDots1 + die_1 + die_2
			end
			-- Handle Dots Group 2.
			local iInnerWidth2 = iCellWidth
			local iInnerHeight2 = iCellHeight - 2
			local iInnerWest2 = 4 + Map.Rand(iCellWidth + 2, "Shift for sub island group - Lua")
			local iInnerSouth2 = 3 + Map.Rand(iCellHeight - 2, "Shift for sub island group - Lua")
			-- Determine number of dots
			local die_1 = Map.Rand(5, "Diceroll - Lua")
			local die_2 = Map.Rand(7, "Diceroll - Lua")
			local iNumDots2 = 8
			if die_1 + die_2 > 1 then
				iNumDots2 = iNumDots2 + Map.Rand(die_1 + die_2, "Number of dots to add to island chain - Lua")
			else
				iNumDots2 = iNumDots2 + die_1 + die_2
			end
			plot_data = CreateAxisChainWithDoubleDots(iWidth, iHeight, fTilt, iInnerWidth1, iInnerHeight1, iInnerWest1, iInnerSouth1,
                                                      iNumDots1, iInnerWidth2, iInnerHeight2, iInnerWest2, iInnerSouth2, iNumDots2)

		elseif formation_type == 10 then -- Vertical Block 2x3 With Double Dots
			local x_shrinkage = Map.Rand(6, "Cell Width adjustment - Lua")
			if x_shrinkage > 4 then
				x_shrinkage = 0
			end
			local y_shrinkage = Map.Rand(8, "Cell Height adjustment - Lua")
			if y_shrinkage > 5 then
				y_shrinkage = 0
			end
			x_shift, y_shift = 0, 0
			if x_shrinkage > 0 then
				x_shift = Map.Rand(x_shrinkage, "Cell Width offset - Lua")
			end
			if y_shrinkage > 0 then
				y_shift = Map.Rand(y_shrinkage, "Cell Height offset - Lua")
			end
			iWidth = iCellWidth * 2 - x_shrinkage
			iHeight = iCellHeight * 3 - y_shrinkage
			-- Mostly vertical
			fTilt = 55 + Map.Rand(71, "Angle for island chain axis - LUA")
			-- Handle Dots Group 1.
			local iInnerWidth1 = iCellWidth - 2
			local iInnerHeight1 = iCellHeight
			local iInnerWest1 = 3 + Map.Rand(iCellWidth - 2, "Shift for sub island group - Lua")
			local iInnerSouth1 = 4 + Map.Rand(iCellHeight + 2, "Shift for sub island group - Lua")
			-- Determine number of dots
			local die_1 = Map.Rand(4, "Diceroll - Lua")
			local die_2 = Map.Rand(10, "Diceroll - Lua")
			local iNumDots1 = 8
			if die_1 + die_2 > 1 then
				iNumDots1 = iNumDots1 + Map.Rand(die_1 + die_2, "Number of dots to add to island chain - Lua")
			else
				iNumDots1 = iNumDots1 + die_1 + die_2
			end
			-- Handle Dots Group 2.
			local iInnerWidth2 = iCellWidth - 2
			local iInnerHeight2 = iCellHeight
			local iInnerWest2 = 3 + Map.Rand(iCellWidth - 2, "Shift for sub island group - Lua")
			local iInnerSouth2 = 4 + Map.Rand(iCellHeight + 2, "Shift for sub island group - Lua")
			-- Determine number of dots
			local die_1 = Map.Rand(4, "Diceroll - Lua")
			local die_2 = Map.Rand(8, "Diceroll - Lua")
			local iNumDots2 = 7
			if die_1 + die_2 > 1 then
				iNumDots2 = iNumDots2 + Map.Rand(die_1 + die_2, "Number of dots to add to island chain - Lua")
			else
				iNumDots2 = iNumDots2 + die_1 + die_2
			end
			plot_data = CreateAxisChainWithDoubleDots(iWidth, iHeight, fTilt, iInnerWidth1, iInnerHeight1, iInnerWest1, iInnerSouth1,
                                                      iNumDots1, iInnerWidth2, iInnerHeight2, iInnerWest2, iInnerSouth2, iNumDots2)
		end

		-- Obtain land plots from the plot data
		local x_adjust = (cell_x - 1) * iCellWidth + x_shift
		local y_adjust = (cell_y - 1) * iCellHeight + y_shift
		for y = 1, iHeight do
			for x = 1, iWidth do
				local data_index = (y - 1) * iWidth + x
				if plot_data[data_index] == true then -- This plot is land.
					local real_x, real_y = x + x_adjust - 1, y + y_adjust - 1
					local plot_index = real_y * iW + real_x + 1
					island_chain_PlotTypes[plot_index] = PlotTypes.PLOT_LAND
				end
			end
		end
		
		-- Record cells in use
		if formation_type == 1 then -- single cell
			cell_data[anchor_cell] = true
			iNumCellsInUse = iNumCellsInUse + 1
		elseif formation_type == 2 then
			cell_data[anchor_cell], cell_data[anchor_cell + 1] = true, true
			iNumCellsInUse = iNumCellsInUse + 2
		elseif formation_type == 3 then
			cell_data[anchor_cell] = true
			iNumCellsInUse = iNumCellsInUse + 1
		elseif formation_type == 4 then
			cell_data[anchor_cell], cell_data[anchor_cell + 1] = true, true
			iNumCellsInUse = iNumCellsInUse + 2
		elseif formation_type == 5 then
			cell_data[anchor_cell], cell_data[anchor_cell + iNumCellColumns] = true, true
			iNumCellsInUse = iNumCellsInUse + 2
		elseif formation_type == 6 then
			cell_data[anchor_cell], cell_data[anchor_cell + iNumCellColumns] = true, true
			iNumCellsInUse = iNumCellsInUse + 2
		elseif formation_type == 7 then
			cell_data[anchor_cell], cell_data[anchor_cell + iNumCellColumns] = true, true
			cell_data[anchor_cell + (iNumCellColumns * 2)] = true
			iNumCellsInUse = iNumCellsInUse + 3
		elseif formation_type == 8 then
			cell_data[anchor_cell], cell_data[anchor_cell + 1] = true, true
			cell_data[anchor_cell + iNumCellColumns], cell_data[anchor_cell + iNumCellColumns + 1] = true, true
			iNumCellsInUse = iNumCellsInUse + 4
		elseif formation_type == 9 then
			cell_data[anchor_cell], cell_data[anchor_cell + 1] = true, true
			cell_data[anchor_cell + iNumCellColumns], cell_data[anchor_cell + iNumCellColumns + 1] = true, true
			cell_data[anchor_cell + 2], cell_data[anchor_cell + iNumCellColumns + 2] = true, true
			iNumCellsInUse = iNumCellsInUse + 6
		elseif formation_type == 10 then
			cell_data[anchor_cell], cell_data[anchor_cell + 1] = true, true
			cell_data[anchor_cell + iNumCellColumns], cell_data[anchor_cell + iNumCellColumns + 1] = true, true
			cell_data[anchor_cell + (iNumCellColumns * 2)], cell_data[anchor_cell + (iNumCellColumns * 2) + 1] = true, true
			iNumCellsInUse = iNumCellsInUse + 6
		end
	end
	
	-- Debug check of cell occupation.
	--print("- - -")
	for loop = iNumCellRows, 1, -1 do
		local c = (loop - 1) * iNumCellColumns
		local stringdata = {}
		for innerloop = 1, iNumCellColumns do
			if cell_data[c + innerloop] == false then
				stringdata[innerloop] = "false"
			else
				stringdata[innerloop] = "true "
			end
		end
		--print("Row: ", table.concat(stringdata))
	end
	--
	
	-- Add Hills and Peaks to randomly generated islands.
	local regionHillsFrac = Fractal.Create(iW, iH, 5, {}, 7, 7)
	local regionPeaksFrac = Fractal.Create(iW, iH, 6, {}, 7, 7)
	local iHillsBottom1 = regionHillsFrac:GetHeight(20)
	local iHillsTop1 = regionHillsFrac:GetHeight(35)
	local iHillsBottom2 = regionHillsFrac:GetHeight(65)
	local iHillsTop2 = regionHillsFrac:GetHeight(80)
	local iPeakThreshold = regionPeaksFrac:GetHeight(80)
	for x = 0, iW - 1 do
		for y = 0, iH - 1 do
			local i = y * iW + x + 1
			if island_chain_PlotTypes[i] ~= PlotTypes.PLOT_OCEAN then
				local hillVal = regionHillsFrac:GetHeight(x,y)
				if ((hillVal >= iHillsBottom1 and hillVal <= iHillsTop1) or (hillVal >= iHillsBottom2 and hillVal <= iHillsTop2)) then
					local peakVal = regionPeaksFrac:GetHeight(x,y)
					if (peakVal >= iPeakThreshold) then
						island_chain_PlotTypes[i] = PlotTypes.PLOT_MOUNTAIN
					else
						island_chain_PlotTypes[i] = PlotTypes.PLOT_HILLS
					end
				end
			end
		end
	end
	
	-- Apply island data to the map.
	for y = 2, iH - 3 do -- avoid polar caps
		for x = 0, iW - 1 do
			local i = y * iW + x + 1
			local plot = Map.GetPlot(x, y)
			if island_chain_PlotTypes[i] ~= PlotTypes.PLOT_OCEAN and plot:GetPlotType() == PlotTypes.PLOT_OCEAN and not plot:IsLake() and not plot:IsRiverSide() then
				local isValid = true
				local numAdjacentLand = 0
				-- Don't fill river deltas with land
				for _, adjPlot in pairs(Plot_GetPlotsInCircle(plot, 1)) do
					if adjPlot:IsRiverSide() then -- does not appear to work?
						isValid = false
						break
					end
					--
					if adjPlot:GetPlotType() ~= PlotTypes.PLOT_OCEAN and adjPlot:Area():GetNumTiles() >= 10 then
						numAdjacentLand = numAdjacentLand + 1
						if numAdjacentLand > 1 then
							isValid = false
							break
						end
					end
					--]]
				end
				if isValid then
					plot:SetPlotType(island_chain_PlotTypes[i], false, false)
				else
					--plot:SetPlotType(PlotTypes.PLOT_MOUNTAIN, false, false)
				end
			end
		end
	end
end

function ErasePolarLand(y)
	local mapW, mapH = Map.GetGridSize()
	
	
	for x = 0,mapW-1 do
		local plot = Map.GetPlot(x, y)
		if plot:GetPlotType() == PlotTypes.PLOT_MOUNTAIN then
			plot:SetPlotType(PlotTypes.PLOT_LAND, false, true)
		end		
	end
end

function GenerateTerrain()
	print("Generating terrain - PerfectWorld3")
	local timeStart = debugTime and os.clock() or 0
	local terrainDesert	= GameInfoTypes["TERRAIN_DESERT"]
	local terrainPlains	= GameInfoTypes["TERRAIN_PLAINS"]
	local terrainSnow	= GameInfoTypes["TERRAIN_SNOW"]
	local terrainTundra	= GameInfoTypes["TERRAIN_TUNDRA"]
	local terrainGrass	= GameInfoTypes["TERRAIN_GRASS"]

	local mapW, mapH = Map.GetGridSize()
	
	SetOceanRiftPlots()
	
	--first find minimum rain above sea level for a soft desert transition
	local minRain = 100.0
	for y = 0, mapH-1 do
		for x = 0,mapW-1 do
			local i = elevationMap:GetIndex(x,y)
			if not elevationMap:IsBelowSeaLevel(x,y) then
				if rainfallMap.data[i] < minRain then
					minRain = rainfallMap.data[i]
				end
			end
		end
	end

	--find exact thresholds
	local desertThreshold = rainfallMap:FindThresholdFromPercent(mc.desertPercent,false,true)
	local plainsThreshold = rainfallMap:FindThresholdFromPercent(mc.plainsPercent,false,true)
	for y = 0, mapH-1 do
		for x = 0,mapW-1 do
			local i = elevationMap:GetIndex(x,y)
			local plot = Map.GetPlot(x, y)
			if not elevationMap:IsBelowSeaLevel(x,y) then
				if rainfallMap.data[i] < desertThreshold then
					if temperatureMap.data[i] < mc.snowTemperature then--and elevationMap:GetZone(y) ~= mc.NEQUATOR and elevationMap:GetZone(y) ~= mc.SEQUATOR then
						plot:SetTerrainType(terrainSnow,false,false)
					elseif temperatureMap.data[i] < mc.tundraTemperature then
						plot:SetTerrainType(terrainTundra,false,false)
					elseif temperatureMap.data[i] < mc.desertMinTemperature then
						plot:SetTerrainType(terrainPlains,false,false)
					else
						--if rainfallMap.data[i] < (PWRand() * (desertThreshold - minRain) + desertThreshold - minRain)/2.0 + minRain then
						plot:SetTerrainType(terrainDesert,false,false)
						--else
							--plot:SetTerrainType(terrainPlains,false,false)
						--end
					end
				elseif rainfallMap.data[i] < plainsThreshold then
					if temperatureMap.data[i] < mc.snowTemperature then--and elevationMap:GetZone(y) ~= mc.NEQUATOR and elevationMap:GetZone(y) ~= mc.SEQUATOR then
						plot:SetTerrainType(terrainSnow,false,false)
					elseif temperatureMap.data[i] < mc.tundraTemperature then
						plot:SetTerrainType(terrainTundra,false,false)
					else
						if rainfallMap.data[i] < (PWRand() * (plainsThreshold - desertThreshold) + plainsThreshold - desertThreshold)/2.0 + desertThreshold then
							plot:SetTerrainType(terrainPlains,false,false)
						else
							plot:SetTerrainType(terrainGrass,false,false)
						end
					end
				else
					if temperatureMap.data[i] < mc.snowTemperature then--and elevationMap:GetZone(y) ~= mc.NEQUATOR and elevationMap:GetZone(y) ~= mc.SEQUATOR then
						plot:SetTerrainType(terrainSnow,false,false)
					elseif temperatureMap.data[i] < mc.tundraTemperature then
						plot:SetTerrainType(terrainTundra,false,false)
					else
						plot:SetTerrainType(terrainGrass,false,false)
					end
				end
			end
		end
	end
	
	if debugTime then print(string.format("%4s ms for GenerateTerrain %s", math.floor((os.clock() - timeStart) * 1000), "Main")) end
	if debugTime then timeStart = os.clock() end
	BlendTerrain()
	if debugTime then print(string.format("%4s ms for GenerateTerrain %s", math.floor((os.clock() - timeStart) * 1000), "BlendTerrain")) end
end
------------------------------------------------------------------------------



------------------------------------------------------------------------------
function AddFeatures()
	print("Adding Features PerfectWorld3")
	local mapW, mapH = Map.GetGridSize()
	Map.RecalculateAreas()	
	
	local timeStart = debugTime and os.clock() or 0
	local zeroTreesThreshold	= rainfallMap:FindThresholdFromPercent(mc.zeroTreesPercent,false,true)
	local jungleThreshold		= rainfallMap:FindThresholdFromPercent(mc.junglePercent,false,true)
	for y = 0, mapH-1 do
		for x = 0,mapW-1 do
			Plot_AddMainFeatures(x, y, zeroTreesThreshold, jungleThreshold)
		end
	end
	
	for y = 0, mapH-1 do
		for x = 0,mapW-1 do
			local plot = Map.GetPlot(x, y)
			if not plot:IsWater() then
				PlacePossibleOasis(x,y)
				PlaceRandomForest(x,y)
			else
				--PlacePossibleAtoll(x,y)
				PlacePossibleIce(x,y)
			end
		end
	end
	AddAtolls()	
	
	RestoreLakes(lakePlots)
	FloodDeserts()
	FixRivers()
	if debugTime then print(string.format("%4s ms for AddFeatures %s", math.floor((os.clock() - timeStart) * 1000), "End")) end
end

function Plot_AddMainFeatures(x, y, zeroTreesThreshold, jungleThreshold)
	local i						= elevationMap:GetIndex(x,y)
	local plot					= Map.GetPlot(x, y)
	local mapW, mapH			= Map.GetGridSize()
	local terrainPlains			= TerrainTypes.TERRAIN_PLAINS
	local terrainDesert			= TerrainTypes.TERRAIN_DESERT
	local terrainSnow			= TerrainTypes.TERRAIN_SNOW
	local featureFlood			= FeatureTypes.FEATURE_FLOOD_PLAINS
	local featureIce			= FeatureTypes.FEATURE_ICE
	local featureJungle			= FeatureTypes.FEATURE_JUNGLE
	local featureForest			= FeatureTypes.FEATURE_FOREST
	local featureOasis			= FeatureTypes.FEATURE_OASIS
	local featureMarsh			= FeatureTypes.FEATURE_MARSH
	--local zeroTreesThreshold	= rainfallMap:FindThresholdFromPercent(mc.zeroTreesPercent,false,true)
	--local jungleThreshold		= rainfallMap:FindThresholdFromPercent(mc.junglePercent,false,true)
	
	if plot:IsWater() or plot:IsMountain() then
		return
	end
	
	-- Set desert rivers to floodplains
	if plot:CanHaveFeature(featureFlood) then
		plot:SetFeatureType(featureFlood,-1)
		return
	end
	
	-- Micro-climates for tiny volcanic islands 
	if not plot:IsMountain() and (plotTerrainID == terrainPlains or plotTerrainID == terrainGrass) then
		local areaSize = plot:Area():GetNumTiles()
		if areaSize <= 5 and (6 - areaSize) >= Map.Rand(5, "Add Island Features - Lua") then
			local zone = elevationMap:GetZone(y)
			if zone == mc.NEQUATOR or zone == mc.SEQUATOR then
				plot:SetTerrainType(terrainPlains,false,false)
				plot:SetFeatureType(featureJungle,-1)
				return
			elseif zone == mc.NTEMPERATE or zone == mc.STEMPERATE then
				plot:SetFeatureType(featureForest,-1)
				return
			end
		end
	end
	
	-- Too dry for jungle
	local plotTerrainID = plot:GetTerrainType()
	if rainfallMap.data[i] < jungleThreshold then
		local treeRange = jungleThreshold - zeroTreesThreshold
		if (rainfallMap.data[i] > PWRand() * treeRange + zeroTreesThreshold) and (temperatureMap.data[i] > mc.treesMinTemperature) then
			if IsGoodFeatureTile(plot) then
				plot:SetFeatureType(featureForest,-1)
			end
		end
		return
	end
	
	-- Too cold for jungle
	if temperatureMap.data[i] < mc.jungleMinTemperature then
		if temperatureMap.data[i] > mc.treesMinTemperature and IsGoodFeatureTile(plot) then
			plot:SetFeatureType(featureForest,-1)
		end
		return
	end	
	
	-- Too near desert for jungle
	for _, adjPlot in pairs(Plot_GetPlotsInCircle(plot, 1)) do
		if adjPlot:GetTerrainType() == terrainDesert then
			return
		end
	end
	
	-- This tile is tropical forest or jungle	
	table.insert(mc.tropicalPlots, plot)
	
	-- Check marsh
	if temperatureMap.data[i] > mc.treesMinTemperature and IsGoodFeatureTile(plot, featureMarsh) then
		plot:SetPlotType(PlotTypes.PLOT_LAND,false,false)
		plot:SetFeatureType(featureMarsh,-1)
		return
	end
	
	if plot:IsHills() then
		--jungle on hill looks terrible in Civ5. Can't use it.
		plot:SetTerrainType(terrainGrass,false,false)
		if IsGoodFeatureTile(plot) then
			plot:SetFeatureType(featureForest,-1)
		end
		return
	end
	
	if IsGoodFeatureTile(plot) then
		plot:SetTerrainType(terrainPlains,false,false)
		plot:SetFeatureType(featureJungle,-1)
	else
		plot:SetTerrainType(terrainGrass,false,false)
	end
end

function IsGoodFeatureTile(plot, featureID)
	local odds = 0
	
	if featureID == FeatureTypes.FEATURE_MARSH then
		if plot:GetPlotType() ~= PlotTypes.PLOT_LAND then
			return false
		end
		for _, adjPlot in pairs(Plot_GetPlotsInCircle(plot, 0, 1)) do
			local adjTerrainID = adjPlot:GetTerrainType()
			if adjPlot:GetPlotType() == PlotTypes.PLOT_OCEAN then
				if plot:IsRiverSide() then
					odds = odds + 2 * mc.marshPercent
				end
				if adjPlot:IsLake() then
					odds = odds + 8 * mc.marshPercent
				else
					odds = odds + mc.marshPercent
				end
			elseif adjTerrainID == TerrainTypes.TERRAIN_DESERT or adjTerrainID == TerrainTypes.TERRAIN_SNOW or adjTerrainID == TerrainTypes.TERRAIN_TUNDRA then
				return 0
			elseif adjPlot:GetFeatureType() == FeatureTypes.FEATURE_MARSH then
				odds = odds - 4 * mc.marshPercent -- avoid clumping
			elseif plot:IsRiverSide() and adjPlot:IsFreshWater() then
				odds = odds + mc.marshPercent
			end
		end
		return math.min(odds, mc.featurePercent) >= PWRand()
	end
	
	odds = mc.featurePercent 
	if plot:IsFreshWater() then
		odds = odds + mc.featureWetVariance
	else
		odds = odds - mc.featureWetVariance
	end
	
	return odds >= PWRand()
end

function IsBarrenDesert(plot)
	return plot:GetTerrainType() == TerrainTypes.TERRAIN_DESERT and not plot:IsMountain() and plot:GetFeatureType() == FeatureTypes.NO_FEATURE
end

function PlacePossibleOasis(plotX,plotY)
	local plot = Map.GetPlot(plotX,plotY)
	if not plot:CanHaveFeature(FeatureTypes.FEATURE_OASIS) or plot:IsHills() then
		return
	end
	
	local odds = 0
	for _, adjPlot in pairs(Plot_GetPlotsInCircle(plot, 3)) do
		local distance = Map.PlotDistance(adjPlot:GetX(), adjPlot:GetY(), plot:GetX(), plot:GetY()) or 1
		local featureID = adjPlot:GetFeatureType()
		
		if featureID == FeatureTypes.FEATURE_OASIS then
			if distance <= 2 then
				-- at least 2 tile spacing between oases
				return
			end
			odds = odds - 200 / distance
		end
		
		if featureID == FeatureTypes.NO_FEATURE and not adjPlot:IsFreshWater() then
			if adjPlot:GetTerrainType() == TerrainTypes.TERRAIN_DESERT then
				odds = odds + 10 / distance
			elseif adjPlot:IsMountain() or adjPlot:IsHills() then
				odds = odds + 10 / distance
			elseif adjPlot:GetTerrainType() == TerrainTypes.TERRAIN_PLAINS then
				odds = odds + 5 / distance
			end
		else
			odds = odds - 5 / distance
		end
	end
	
	if odds >= Map.Rand(100, "PlacePossibleOasis - Lua") then
		plot:SetFeatureType(FeatureTypes.FEATURE_OASIS, -1)
	end
end

function PlaceRandomForest(plotX,plotY)
	local plot = Map.GetPlot(plotX,plotY)
	local terrainID = plot:GetTerrainType() 
	
	if not plot:CanHaveFeature(FeatureTypes.FEATURE_FOREST) then
		return false
	end
	
	local resID = plot:GetResourceType()
	if resID ~= -1 and terrainID == TerrainTypes.TERRAIN_TUNDRA then
		plot:SetFeatureType(FeatureTypes.FEATURE_FOREST, -1)
		return true
	end
	
	local odds = mc.forestRandomPercent
	if plot:IsFreshWater() then
		odds = odds + mc.forestWetVariance
	else
		odds = odds - mc.forestWetVariance
	end
	if 100 * odds >= Map.Rand(100, "Add Extra Forest - Lua") then
		plot:SetFeatureType(FeatureTypes.FEATURE_FOREST, -1)
		return true
	end
end

function FloodDeserts()
	local mapW, mapH = Map.GetGridSize()
	for plotY = 0, mapH-1 do
		for plotX = 0,mapW-1 do
			local plot = Map.GetPlot(plotX,plotY)
			if (plot:GetTerrainType() == TerrainTypes.TERRAIN_DESERT
					and plot:GetFeatureType() == FeatureTypes.NO_FEATURE
					and plot:IsFreshWater()
					and not plot:IsHills()
					and not plot:IsMountain()
					)then
				if not Cep then
					Game.SetPlotExtraYield( plot:GetX(), plot:GetY(), YieldTypes.YIELD_FOOD, 1)
				end
			end
		end
	end
end

function PlacePossibleIce(x,y)
	local featureIce = FeatureTypes.FEATURE_ICE
	local plot = Map.GetPlot(x,y)
	local i = temperatureMap:GetIndex(x,y)
	if plot:IsWater() then
		local temp = temperatureMap.data[i]
		local latitude = temperatureMap:GetLatitudeForY(y)
		--local randval = PWRand() * (mc.iceMaxTemperature - mc.minWaterTemp) + mc.minWaterTemp * 2
		local randvalNorth = PWRand() * (mc.iceNorthLatitudeLimit - mc.topLatitude) + mc.topLatitude - 2
		local randvalSouth = PWRand() * (mc.bottomLatitude - mc.iceSouthLatitudeLimit) + mc.iceSouthLatitudeLimit
		--if debugTime then print(string.format("lat = %f, randvalNorth = %f, randvalSouth = %f",latitude,randvalNorth,randvalSouth)) end
		if latitude > randvalNorth  or latitude < randvalSouth then
			plot:SetFeatureType(featureIce,-1)
			for _, adjPlot in pairs(Plot_GetPlotsInCircle(plot, 1)) do
				-- grass -> tundra, near ice
				if adjPlot:GetTerrainType() == TerrainTypes.TERRAIN_GRASS then
					plot:SetTerrainType(TerrainTypes.TERRAIN_TUNDRA, false, true)
					break
				end
			end
		end
	end
end

function AddAtolls()
	-- This function added Feb 2011 by Bob Thomas.
	-- Adds the new feature Atolls in to the game, for oceanic maps.
	local iW, iH = Map.GetGridSize()
	local biggest_ocean = Map.FindBiggestArea(true)
	local iNumBiggestOceanPlots = 0
	
	if biggest_ocean ~= nil then
		iNumBiggestOceanPlots = biggest_ocean:GetNumTiles()
	end
	if iNumBiggestOceanPlots <= (iW * iH) / 4 then -- No major oceans on this world.
		return
	end
	
	-- World has oceans, proceed with adding Atolls.
	local iNumAtollsPlaced = 0
	local direction_types = {
		DirectionTypes.DIRECTION_NORTHEAST,
		DirectionTypes.DIRECTION_EAST,
		DirectionTypes.DIRECTION_SOUTHEAST,
		DirectionTypes.DIRECTION_SOUTHWEST,
		DirectionTypes.DIRECTION_WEST,
		DirectionTypes.DIRECTION_NORTHWEST
	}
	local numCoast = 0
	local coastID = GameInfo.Terrains.TERRAIN_COAST.ID
	for i, plot in Plots() do
		if plot:GetTerrainType() == coastID then
			numCoast = numCoast + 1
		end
	end
	--[[
	local worldsizes = {
		[GameInfo.Worlds.WORLDSIZE_DUEL.ID] = 2,
		[GameInfo.Worlds.WORLDSIZE_TINY.ID] = 4,
		[GameInfo.Worlds.WORLDSIZE_SMALL.ID] = 5,
		[GameInfo.Worlds.WORLDSIZE_STANDARD.ID] = 7,
		[GameInfo.Worlds.WORLDSIZE_LARGE.ID] = 9,
		[GameInfo.Worlds.WORLDSIZE_HUGE.ID] = 12,
	}
	--]]
	local atoll_target = numCoast * 0.10
	local variance = 25
		  variance = atoll_target * (Map.Rand(2 * variance, "Number of Atolls to place - LUA") - variance) / 100
	local atoll_number = math.floor(atoll_target + variance)
	local feature_atoll
	for thisFeature in GameInfo.Features() do
		if thisFeature.Type == "FEATURE_ATOLL" then
			feature_atoll = thisFeature.ID
		end
	end

	-- Generate candidate plot lists.
	local temp_one_tile_island_list, temp_alpha_list, temp_beta_list = {}, {}, {}
	local temp_gamma_list, temp_delta_list, temp_epsilon_list = {}, {}, {}
	for y = 0, iH - 1 do
		for x = 0, iW - 1 do
			local i = y * iW + x + 1 -- Lua tables/lists/arrays start at 1, not 0 like C++ or Python
			local plot = Map.GetPlot(x, y)
			local plotType = plot:GetPlotType()
			if plotType == PlotTypes.PLOT_OCEAN then
				local featureType = plot:GetFeatureType()
				if featureType ~= FeatureTypes.FEATURE_ICE then
					if not plot:IsLake() then
						local terrainType = plot:GetTerrainType()
						if terrainType == TerrainTypes.TERRAIN_COAST then
							-- Check all adjacent plots and identify adjacent landmasses.
							local iNumLandAdjacent, biggest_adj_area = 0, 0
							local bPlotValid = true
							for loop, direction in ipairs(direction_types) do
								local adjPlot = Map.PlotDirection(x, y, direction)
								if adjPlot ~= nil then
									local adjPlotType = adjPlot:GetPlotType()
									--[[
									if adjPlot:GetFeatureType() == FeatureTypes.FEATURE_ICE then
										bPlotValid = false
									elseif adjPlot:GetTerrainType() == TerrainTypes.TERRAIN_SNOW then
										bPlotValid = false
									end
									--]]
									if adjPlotType ~= PlotTypes.PLOT_OCEAN then -- Found land.
										iNumLandAdjacent = iNumLandAdjacent + 1
										if adjPlotType == PlotTypes.PLOT_LAND or adjPlotType == PlotTypes.PLOT_HILLS then
											local iArea = adjPlot:GetArea()
											local adjArea = Map.GetArea(iArea)
											local iNumAreaPlots = adjArea:GetNumTiles()
											if iNumAreaPlots > biggest_adj_area then
												biggest_adj_area = iNumAreaPlots
											end
										end
									end
								end
							end
							-- Only plots with a single land plot adjacent can be eligible.
							if bPlotValid and iNumLandAdjacent <= 1 then
								--if biggest_adj_area >= 152 then
									-- discard this site
								if biggest_adj_area >= 82 then
									table.insert(temp_epsilon_list, i)
								elseif biggest_adj_area >= 34 then
									table.insert(temp_delta_list, i)
								elseif biggest_adj_area >= 16 or biggest_adj_area == 0 then
									table.insert(temp_gamma_list, i)
								elseif biggest_adj_area >= 6 then
									table.insert(temp_beta_list, i)
								elseif biggest_adj_area >= 1 then
									table.insert(temp_alpha_list, i)
								else -- Unexpected result
									--print("** Area Plot Count =", biggest_adj_area)
								end
							end
						end
					end
				end
			end
		end
	end
	local alpha_list = GetShuffledCopyOfTable(temp_alpha_list)
	local beta_list = GetShuffledCopyOfTable(temp_beta_list)
	local gamma_list = GetShuffledCopyOfTable(temp_gamma_list)
	local delta_list = GetShuffledCopyOfTable(temp_delta_list)
	local epsilon_list = GetShuffledCopyOfTable(temp_epsilon_list)

	-- Determine maximum number able to be placed, per candidate category.
	local max_alpha = math.ceil(table.maxn(alpha_list) )--* .25)
	local max_beta = math.ceil(table.maxn(beta_list) )--* .2)
	local max_gamma = math.ceil(table.maxn(gamma_list) )--* .25)
	local max_delta = math.ceil(table.maxn(delta_list) )--* .3)
	local max_epsilon = math.ceil(table.maxn(epsilon_list) )--* .4)
	
	-- Place Atolls.
	local plotIndex
	local i_alpha, i_beta, i_gamma, i_delta, i_epsilon = 1, 1, 1, 1, 1		
	local passNum = 0	
	
	while (iNumAtollsPlaced < atoll_number) and (passNum < atoll_number * 5) do
		local able_to_proceed = true
		local diceroll = 1 + Map.Rand(100, "Atoll Placement Type - LUA")
		if diceroll <= 40 and max_alpha > 0 then
			plotIndex = alpha_list[i_alpha]
			i_alpha = i_alpha + 1
			max_alpha = max_alpha - 1
			--print("- Alpha site chosen")
		elseif diceroll <= 65 then
			if max_beta > 0 then
				plotIndex = beta_list[i_beta]
				i_beta = i_beta + 1
				max_beta = max_beta - 1
				--print("- Beta site chosen")
			elseif max_alpha > 0 then
				plotIndex = alpha_list[i_alpha]
				i_alpha = i_alpha + 1
				max_alpha = max_alpha - 1
				--print("- Alpha site chosen")
			else -- Unable to place this Atoll
				--print("-") print("* Atoll #", loop, "was unable to be placed.")
				able_to_proceed = false
			end
		elseif diceroll <= 80 then
			if max_gamma > 0 then
				plotIndex = gamma_list[i_gamma]
				i_gamma = i_gamma + 1
				max_gamma = max_gamma - 1
				--print("- Gamma site chosen")
			elseif max_beta > 0 then
				plotIndex = beta_list[i_beta]
				i_beta = i_beta + 1
				max_beta = max_beta - 1
				--print("- Beta site chosen")
			elseif max_alpha > 0 then
				plotIndex = alpha_list[i_alpha]
				i_alpha = i_alpha + 1
				max_alpha = max_alpha - 1
				--print("- Alpha site chosen")
			else -- Unable to place this Atoll
				--print("-") print("* Atoll #", loop, "was unable to be placed.")
				able_to_proceed = false
			end
		elseif diceroll <= 90 then
			if max_delta > 0 then
				plotIndex = delta_list[i_delta]
				i_delta = i_delta + 1
				max_delta = max_delta - 1
				--print("- Delta site chosen")
			elseif max_gamma > 0 then
				plotIndex = gamma_list[i_gamma]
				i_gamma = i_gamma + 1
				max_gamma = max_gamma - 1
				--print("- Gamma site chosen")
			elseif max_beta > 0 then
				plotIndex = beta_list[i_beta]
				i_beta = i_beta + 1
				max_beta = max_beta - 1
				--print("- Beta site chosen")
			elseif max_alpha > 0 then
				plotIndex = alpha_list[i_alpha]
				i_alpha = i_alpha + 1
				max_alpha = max_alpha - 1
				--print("- Alpha site chosen")
			else -- Unable to place this Atoll
				--print("-") print("* Atoll #", loop, "was unable to be placed.")
				able_to_proceed = false
			end
		else
			if max_epsilon > 0 then
				plotIndex = epsilon_list[i_epsilon]
				i_epsilon = i_epsilon + 1
				max_epsilon = max_epsilon - 1
				--print("- Epsilon site chosen")
			elseif max_delta > 0 then
				plotIndex = delta_list[i_delta]
				i_delta = i_delta + 1
				max_delta = max_delta - 1
				--print("- Delta site chosen")
			elseif max_gamma > 0 then
				plotIndex = gamma_list[i_gamma]
				i_gamma = i_gamma + 1
				max_gamma = max_gamma - 1
				--print("- Gamma site chosen")
			elseif max_beta > 0 then
				plotIndex = beta_list[i_beta]
				--print("- Beta site chosen")
				i_beta = i_beta + 1
				max_beta = max_beta - 1
			elseif max_alpha > 0 then
				plotIndex = alpha_list[i_alpha]
				i_alpha = i_alpha + 1
				max_alpha = max_alpha - 1
				--print("- Alpha site chosen")
			else -- Unable to place this Atoll
				--print("-") print("* Atoll #", loop, "was unable to be placed.")
				able_to_proceed = false
			end
		end
		if able_to_proceed and plotIndex then
			local x = (plotIndex - 1) % iW
			local y = (plotIndex - x - 1) / iW
			local plot = Map.GetPlot(x, y)
			for _, direction in ipairs(direction_types) do
				local adjPlot = Map.PlotDirection(x, y, direction)
				if adjPlot and adjPlot:GetFeatureType() == feature_atoll then
					able_to_proceed = false
					--print("Adjacent atoll")
					break
				end
			end
			if able_to_proceed then
				plot:SetFeatureType(feature_atoll, -1)
				iNumAtollsPlaced = iNumAtollsPlaced + 1
			end
		end
		passNum = passNum + 1
	end 
	
	-- Debug report
	print("-")
	print("-                 Atoll Target Number: ", atoll_number)
	print("-             Number of Atolls placed: ", iNumAtollsPlaced)
	print("-                            Attempts: ", passNum)
	print("-")	
	print("- Atolls placed in Alpha locations   : ", i_alpha - 1)
	print("- Atolls placed in Beta locations    : ", i_beta - 1)
	print("- Atolls placed in Gamma locations   : ", i_gamma - 1)
	print("- Atolls placed in Delta locations   : ", i_delta - 1)
	print("- Atolls placed in Epsilon locations : ", i_epsilon - 1)
	--]]
end

function PlacePossibleAtoll(x,y)
	local shallowWater = GameDefines.SHALLOW_WATER_TERRAIN
	local deepWater = GameDefines.DEEP_WATER_TERRAIN
	local featureAtoll = nil
	for thisFeature in GameInfo.Features() do
		if thisFeature.Type == "FEATURE_ATOLL" then
			featureAtoll = thisFeature.ID
		end
	end
	local plot = Map.GetPlot(x,y)
	local i = temperatureMap:GetIndex(x,y)
	if plot:GetTerrainType() == shallowWater then
		local temp = temperatureMap.data[i]
		local latitude = temperatureMap:GetLatitudeForY(y)
		if latitude < mc.atollNorthLatitudeLimit and latitude > mc.atollSouthLatitudeLimit then
			local tiles = elevationMap:GetRadiusAroundHex(x,y,1)
			local deepCount = 0
			for n=1,#tiles do
				local xx = tiles[n][1]
				local yy = tiles[n][2]
				local nPlot = Map.GetPlot(xx,yy)
				if nPlot:GetTerrainType() == deepWater then
					deepCount = deepCount + 1
				end
			end
			if deepCount >= mc.atollMinDeepWaterNeighbors then
				plot:SetFeatureType(featureAtoll,-1)
			end
		end
	end
end

function StartPlotSystem()
	-- Get Resources setting input by user.
	local res = Map.GetCustomOption(2)
	if res == 6 then
		res = 1 + Map.Rand(3, "Random Resources Option - Lua")
	end

	local starts = Map.GetCustomOption(1)
	local divMethod = nil
	if starts == 1 then
		divMethod = 2
	else
		divMethod = 1
	end

	print("Creating start plot database.")
	local start_plot_database = AssignStartingPlots.Create()

	print("Dividing the map in to Regions.")
	-- Regional Division Method 2: Continental or 1:Terra
	local args = {
		method = divMethod,
		resources = res,
		}
	start_plot_database:GenerateRegions(args)

	print("Choosing start locations for civilizations.")
	start_plot_database:ChooseLocations()

	print("Normalizing start locations and assigning them to Players.")
	start_plot_database:BalanceAndAssign()

	--error(":P")
	print("Placing Natural Wonders.")
	start_plot_database:PlaceNaturalWonders()

	print("Placing Resources and City States.")
	start_plot_database:PlaceResourcesAndCityStates()
end

function AddRivers()
	local mapW, mapH = Map.GetGridSize()
	
	
	for y = 0, mapH-1 do
		for x = 0,mapW-1 do
			local plot = Map.GetPlot(x, y)

			local WOfRiver, NWOfRiver, NEOfRiver = riverMap:GetFlowDirections(x,y)

			if WOfRiver == FlowDirectionTypes.NO_FLOWDIRECTION then
				plot:SetWOfRiver(false,WOfRiver)
			else
				local xx,yy = elevationMap:GetNeighbor(x,y,mc.E)
				local nPlot = Map.GetPlot(xx,yy)
				if plot:IsMountain() and nPlot:IsMountain() then
					plot:SetPlotType(PlotTypes.PLOT_LAND,false,false)
				end
				plot:SetWOfRiver(true,WOfRiver)
				--if debugTime then print(string.format("(%d,%d)WOfRiver = true dir=%d",x,y,WOfRiver)) end
			end

			if NWOfRiver == FlowDirectionTypes.NO_FLOWDIRECTION then
				plot:SetNWOfRiver(false,NWOfRiver)
			else
				local xx,yy = elevationMap:GetNeighbor(x,y,mc.SE)
				local nPlot = Map.GetPlot(xx,yy)
				if plot:IsMountain() and nPlot:IsMountain() then
					plot:SetPlotType(PlotTypes.PLOT_LAND,false,false)
				end
				plot:SetNWOfRiver(true,NWOfRiver)
				--if debugTime then print(string.format("(%d,%d)NWOfRiver = true dir=%d",x,y,NWOfRiver)) end
			end

			if NEOfRiver == FlowDirectionTypes.NO_FLOWDIRECTION then
				plot:SetNEOfRiver(false,NEOfRiver)
			else
				local xx,yy = elevationMap:GetNeighbor(x,y,mc.SW)
				local nPlot = Map.GetPlot(xx,yy)
				if plot:IsMountain() and nPlot:IsMountain() then
					plot:SetPlotType(PlotTypes.PLOT_LAND,false,false)
				end
				plot:SetNEOfRiver(true,NEOfRiver)
				--if debugTime then print(string.format("(%d,%d)NEOfRiver = true dir=%d",x,y,NEOfRiver)) end
			end
		end
	end
end

function oceanMatch(x,y)
	local plot = Map.GetPlot(x,y)
	if plot:GetPlotType() == PlotTypes.PLOT_OCEAN then
		return true
	end
	return false
end

function jungleMatch(x,y)
	local terrainGrass	= GameInfoTypes["TERRAIN_GRASS"]
	local plot = Map.GetPlot(x,y)
	if plot:GetFeatureType() == FeatureTypes.FEATURE_JUNGLE or Contains(mc.tropicalPlots, plot) then
		return true
	--include any mountains on the border as part of the desert.
	elseif (plot:GetFeatureType() == FeatureTypes.FEATURE_MARSH or plot:GetFeatureType() == FeatureTypes.FEATURE_FOREST) and plot:GetTerrainType() == terrainGrass then
		local nList = elevationMap:GetRadiusAroundHex(x,y,1)
		for n=1,#nList do
			local xx = nList[n][1]
			local yy = nList[n][2]
			local ii = elevationMap:GetIndex(xx,yy)
			if 11 ~= -1 then
				local nPlot = Map.GetPlot(xx,yy)
				if nPlot:GetFeatureType() == FeatureTypes.FEATURE_JUNGLE then
					return true
				end
			end
		end
	end
	return false
end

function desertMatch(x,y)
	local terrainDesert	= GameInfoTypes["TERRAIN_DESERT"]
	local plot = Map.GetPlot(x,y)
	if plot:GetTerrainType() == terrainDesert then
		return true
	--include any mountains on the border as part of the desert.
	elseif plot:GetPlotType() == PlotTypes.PLOT_MOUNTAIN then
		local nList = elevationMap:GetRadiusAroundHex(x,y,1)
		for n=1,#nList do
			local xx = nList[n][1]
			local yy = nList[n][2]
			local ii = elevationMap:GetIndex(xx,yy)
			if 11 ~= -1 then
				local nPlot = Map.GetPlot(xx,yy)
				if nPlot:GetPlotType() ~= PlotTypes.PLOT_MOUNTAIN and nPlot:GetTerrainType() == terrainDesert then
					return true
				end
			end
		end
	end
	return false
end



------------------------------------------------------------------------------

function DetermineContinents()
	print("Determining continents for art purposes (PerfectWorld)")
	-- Each plot has a continent art type.
	-- Command for setting the art type for a plot is: <plot object>:SetContinentArtType(<art_set_number>)
	
	-- CONTINENTAL ART SETS - in order from hot to cold
	-- 0) Ocean
	-- 3) Africa
	-- 2) Asia
	-- 1) America
	-- 4) Europe
	
	contArt = {}
	contArt.OCEAN	= 0
	contArt.AFRICA	= 3
	contArt.ASIA	= 2
	contArt.AMERICA	= 1
	contArt.EUROPE	= 4
	
	local mapW, mapH = Map.GetGridSize()

 	for i, plot in Plots() do
 		if plot:IsWater() then
 			plot:SetContinentArtType(contArt.OCEAN)
 		else
 			plot:SetContinentArtType(contArt.AFRICA)
 		end
 	end
	
	local continentMap = PWAreaMap:New(elevationMap.width,elevationMap.height,elevationMap.wrapX,elevationMap.wrapY)
	continentMap:DefineAreas(oceanMatch)
	table.sort(continentMap.areaList,function (a,b) return a.size > b.size end)

	--check for jungle
	for y=0, elevationMap.height - 1 do
		for x=0,elevationMap.width - 1 do
			local i = elevationMap:GetIndex(x,y)
			local area = continentMap:GetAreaByID(continentMap.data[i])
			area.hasJungle = false
		end
	end
	for y=0, elevationMap.height - 1 do
		for x=0, elevationMap.width - 1 do
			local plot = Map.GetPlot(x,y)
			if plot:GetFeatureType() == FeatureTypes.FEATURE_JUNGLE then
				local i = elevationMap:GetIndex(x,y)
				local area = continentMap:GetAreaByID(continentMap.data[i])
				area.hasJungle = true
			end
		end
	end
	for n=1, #continentMap.areaList do
		--if debugTime then print(string.format("area[%d] size = %d",n,desertMap.areaList[n].size)) end
--		if not continentMap.areaList[n].trueMatch and not continentMap.areaList[n].hasJungle then
		if not continentMap.areaList[n].trueMatch then
			continentMap.areaList[n].artStyle = 1 + Map.Rand(2, "Continent Art Styles - Lua") -- left out America's orange trees
		end
	end 
	for y=0, elevationMap.height - 1 do
		for x=0, elevationMap.width - 1 do
			local plot = Map.GetPlot(x,y)
			local i = elevationMap:GetIndex(x,y)
			local artStyle = continentMap:GetAreaByID(continentMap.data[i]).artStyle
			if plot:IsWater() then
				plot:SetContinentArtType(contArt.OCEAN)
			elseif jungleMatch(x,y) then
				plot:SetContinentArtType(contArt.EUROPE)
			else
				plot:SetContinentArtType(contArt.AFRICA)
			end
		end
	end
	
	--Africa has the best looking deserts, so for the biggest
	--desert use Africa. America has a nice dirty looking desert also, so
	--that should be the second biggest desert.
	local desertMap = PWAreaMap:New(elevationMap.width,elevationMap.height,elevationMap.wrapX,elevationMap.wrapY)
	desertMap:DefineAreas(desertMatch)
	table.sort(desertMap.areaList,function (a,b) return a.size > b.size end)
	local largestDesertID = nil
	local secondLargestDesertID = nil
	for n=1,#desertMap.areaList do
		--if debugTime then print(string.format("area[%d] size = %d",n,desertMap.areaList[n].size)) end
		if desertMap.areaList[n].trueMatch then
			if largestDesertID == nil then
				largestDesertID = desertMap.areaList[n].id
			else
				secondLargestDesertID = desertMap.areaList[n].id
				break
			end
		end
	end
	for y=0,elevationMap.height - 1 do
		for x=0,elevationMap.width - 1 do
			local plot = Map.GetPlot(x,y)
			local i = elevationMap:GetIndex(x,y)
			if desertMap.data[i] == largestDesertID then
				plot:SetContinentArtType(contArt.AFRICA)
			elseif desertMap.data[i] == secondLargestDesertID then
				plot:SetContinentArtType(contArt.ASIA)
			end
		end
	end
	
	-- Set tundra/mountains -> snowy when adjacent to snow tiles
	for y = 0, mapH-1 do
		for x = 0, mapW-1 do
			local plot = Map.GetPlot(x,y)
			local plotTerrainID = plot:GetTerrainType()
			if plot:IsMountain() then
				local coldness = 0
				local zone = elevationMap:GetZone(y)
				
				if (zone == mc.NPOLAR or zone == mc.SPOLAR) then
					coldness = coldness + 2
				elseif (zone == mc.NTEMPERATE or zone == mc.STEMPERATE) then
					coldness = coldness + 1
				else
					coldness = coldness - 1
				end
				
				for _, adjPlot in pairs(Plot_GetPlotsInCircle(plot, 1, 1)) do
					local adjTerrainID = adjPlot:GetTerrainType()
					local adjFeatureID = adjPlot:GetFeatureType()
					if adjPlot:IsMountain() then
						coldness = coldness + 0.5
					elseif adjTerrainID == TerrainTypes.TERRAIN_SNOW then
						coldness = coldness + 2
					elseif adjTerrainID == TerrainTypes.TERRAIN_TUNDRA then
						coldness = coldness + 1
					elseif adjTerrainID == TerrainTypes.TERRAIN_DESERT then
						coldness = coldness - 1
					elseif adjFeatureID == FeatureTypes.FEATURE_JUNGLE or adjFeatureID == FeatureTypes.FEATURE_MARSH then
						coldness = coldness - 8
					end
				end
				
				for _, adjPlot in pairs(Plot_GetPlotsInCircle(plot, 2, 2)) do
					if adjPlot:IsMountain() then
						coldness = coldness + 0.25
					end
				end
				
				-- Avoid snow near tropical jungle
				if coldness >= 1 then
					for _, adjPlot in pairs(Plot_GetPlotsInCircle(plot, 2, 3)) do
						local adjFeatureID = adjPlot:GetFeatureType()
						if adjFeatureID == FeatureTypes.FEATURE_JUNGLE or adjFeatureID == FeatureTypes.FEATURE_MARSH then
							coldness = coldness - 8 / Map.PlotDistance(x, y, adjPlot:GetX(), adjPlot:GetY())
						end
					end
				end
				
				if coldness >= 7 then
					plot:SetContinentArtType(contArt.EUROPE)
				elseif coldness >= 1 then
					plot:SetContinentArtType(contArt.AMERICA)
				elseif coldness >= 0 then
					plot:SetContinentArtType(contArt.ASIA)
				else
					plot:SetContinentArtType(contArt.AFRICA)
				end
				

			elseif plotTerrainID == TerrainTypes.TERRAIN_TUNDRA then
				local coldness = 0
				for _, adjPlot in pairs(Plot_GetPlotsInCircle(plot, 1, 1)) do
					local adjTerrainID = adjPlot:GetTerrainType()
					local adjFeatureID = adjPlot:GetFeatureType()
					if adjTerrainID == TerrainTypes.TERRAIN_SNOW then
						coldness = coldness + 5
					elseif adjTerrainID == TerrainTypes.TERRAIN_TUNDRA then
						coldness = coldness + 1
					elseif adjTerrainID == TerrainTypes.TERRAIN_DESERT or adjFeatureID == FeatureTypes.FEATURE_JUNGLE or adjFeatureID == FeatureTypes.FEATURE_MARSH then
						coldness = coldness - 2
					end
				end
				for _, adjPlot in pairs(Plot_GetPlotsInCircle(plot, 2, 2)) do
					if adjTerrainID == TerrainTypes.TERRAIN_DESERT or adjFeatureID == FeatureTypes.FEATURE_JUNGLE or adjFeatureID == FeatureTypes.FEATURE_MARSH then
						coldness = coldness - 1
					end
				end
				if coldness >= 5 then
					if plot:GetFeatureType() == FeatureTypes.FEATURE_FOREST then
						plot:SetContinentArtType(contArt.ASIA)
					else
						plot:SetContinentArtType(contArt.EUROPE)
					end
				else
					plot:SetContinentArtType(contArt.AFRICA)
				end
			elseif plotTerrainID == TerrainTypes.TERRAIN_SNOW then
				plot:SetContinentArtType(contArt.EUROPE)
			end
		end
	end
end

------------------------------------------------------------------------------

--~ mc = MapConstants:New()
--~ PWRandSeed()

--~ elevationMap = GenerateElevationMap(100,70,true,false)
--~ FillInLakes()
--~ elevationMap:Save("elevationMap.csv")

--~ rainfallMap, temperatureMap = GenerateRainfallMap(elevationMap)
--~ temperatureMap:Save("temperatureMap.csv")
--~ rainfallMap:Save("rainfallMap.csv")

--~ riverMap = RiverMap:New(elevationMap)
--~ riverMap:SetJunctionAltitudes()
--~ riverMap:SiltifyLakes()
--~ riverMap:SetFlowDestinations()
--~ riverMap:SetRiverSizes(rainfallMap)







-- Override AssignStartingPlots functions

function AssignStartingPlots:ExaminePlotForNaturalWondersEligibility(x, y)
	-- This function checks only for eligibility requirements applicable to all 
	-- Natural Wonders. If a candidate plot passes all such checks, we will move
	-- on to checking it against specific needs for each particular wonderID.
	--
	-- Update, May 2011: Control over wonderID placement is being migrated to XML. Some checks here moved to there.
	local iW, iH = Map.GetGridSize();
	local plotIndex = iW * y + x + 1;
	
	-- Check for collision with player starts
	if self.naturalWondersData[plotIndex] > 0 then
		return false
	end
	
	-- Check the location is a decent city site, otherwise the wonderID is pointless
	local plot = Map.GetPlot(x, y);
	if Plot_GetFertilityInRange(plot, 3) < 12 then
		return false
	end
	return true
end

function AssignStartingPlots:CanPlaceCityStateAt(x, y, area_ID, force_it, ignore_collisions)
	local iW, iH = Map.GetGridSize();
	local plot = Map.GetPlot(x, y)
	local area = plot:GetArea()
	if area ~= area_ID and area_ID ~= -1 then
		return false
	end
	
	local plotType = plot:GetPlotType()
	if plotType == PlotTypes.PLOT_OCEAN or plotType == PlotTypes.PLOT_MOUNTAIN then
		return false
	end
	
	-- Avoid horrible locations
	if Plot_GetFertilityInRange(plot, 1) < 6 then
		return false
	end
	
	-- Discourage citystates from claiming natural wonders
	for _, adjPlot in pairs(Plot_GetPlotsInCircle(plot, 1, 3)) do
		local featureInfo = GameInfo.Features[adjPlot:GetFeatureType()]
		if featureInfo and featureInfo.NaturalWonder then
			return false
		end
	end
	
	local plotIndex = y * iW + x + 1;
	if self.cityStateData[plotIndex] > 0 and force_it == false then
		return false
	end
	local plotIndex = y * iW + x + 1;
	if self.playerCollisionData[plotIndex] == true and ignore_collisions == false then
		--print("-"); print("City State candidate plot rejected: collided with already-placed civ or City State at", x, y);
		return false
	end
	return true
end

--
-- Helper functions
--

---------------------------------------------------------------------
-- Plot_GetFertility(plot) usage example:
--[[
basicYields = {
	YieldTypes.YIELD_FOOD,
	YieldTypes.YIELD_PRODUCTION,
	YieldTypes.YIELD_GOLD,
	YieldTypes.YIELD_SCIENCE,
	YieldTypes.YIELD_CULTURE,
	YieldTypes.YIELD_FAITH
}
--]]
basicYields = nil
function Plot_GetFertilityInRange(plot, range)
	basicYields = {
		YieldTypes.YIELD_FOOD,
		YieldTypes.YIELD_PRODUCTION,
		YieldTypes.YIELD_GOLD,
		YieldTypes.YIELD_SCIENCE,
		YieldTypes.YIELD_CULTURE,
		YieldTypes.YIELD_FAITH
	}
	local value = 0
	for _, adjPlot in pairs(Plot_GetPlotsInCircle(plot, range)) do
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
----------------------------------------------------------------
function Plot_GetPlotsInCircle(plot, minR, maxR)
	if not plot then
		log:Fatal("plot:GetPlotsInCircle plot=nil")
		return
	end
	if not maxR then
		maxR = minR
		minR = 1
	end
	
	local plotList	= {}
	local iW, iH	= Map.GetGridSize()
	local isWrapX	= Map:IsWrapX()
	local isWrapY	= Map:IsWrapY()
	local centerX	= plot:GetX()
	local centerY	= plot:GetY()

	x1 = isWrapX and ((centerX-maxR) % iW) or Constrain(0, centerX-maxR, iW-1)
	x2 = isWrapX and ((centerX+maxR) % iW) or Constrain(0, centerX+maxR, iW-1)
	y1 = isHrapY and ((centerY-maxR) % iH) or Constrain(0, centerY-maxR, iH-1)
	y2 = isHrapY and ((centerY+maxR) % iH) or Constrain(0, centerY+maxR, iH-1)

	local x		= x1
	local y		= y1
	local xStep	= 0
	local yStep	= 0
	local rectW	= x2-x1 
	local rectH	= y2-y1
	
	if rectW < 0 then
		rectW = rectW + iW
	end
	
	if rectH < 0 then
		rectH = rectH + iH
	end
	
	local adjPlot = Map.GetPlot(x, y)

	while (yStep < 1 + rectH) and adjPlot ~= nil do
		while (xStep < 1 + rectW) and adjPlot ~= nil do
			if IsBetween(minR, Map.PlotDistance(x, y, centerX, centerY), maxR) then
				table.insert(plotList, adjPlot)
			end
			
			x		= x + 1
			x		= isWrapX and (x % iW) or x
			xStep	= xStep + 1
			adjPlot	= Map.GetPlot(x, y)
		end
		x		= x1
		y		= y + 1
		y		= isWrapY and (y % iH) or y
		xStep	= 0
		yStep	= yStep + 1
		adjPlot	= Map.GetPlot(x, y)
	end
	
	return plotList
end
----------------------------------------------------------------
function IsBetween(lower, mid, upper)
	return ((lower <= mid) and (mid <= upper))
end

function Contains(list, value)
	for k, v in pairs(list) do
		if v == value then
			return true
		end
	end
	return false
end

function Constrain(lower, mid, upper)
	return math.max(lower, math.min(mid, upper))
end
----------------------------------------------------------------