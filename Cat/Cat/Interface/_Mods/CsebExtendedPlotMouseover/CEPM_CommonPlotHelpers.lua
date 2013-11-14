--
-- Helper functions for plot / yield related logic
-- Author: csebal
--

include("YieldLibrary.lua")

local log = Events.LuaLogger:New()
log:SetLevel("WARN")

-------------------------------------------------
-- List the improvements that can be built on
-- the specified resource
-------------------------------------------------
function csebPlotHelpers_GetImprovementListForResource(pPlot, pResource)
	local strResult = ""; -- result string	
	local player = Players[Game.GetActivePlayer()]

	-- check to see if there already is an improvement on the plot
	local strBuiltImprovementKey = "";
	local impID = pPlot:GetRevealedImprovementType(activeTeamID, false); -- get the improvement type on the plot
	local bHasMatchingImprovement = false;
	if (impID >= 0) then
		strBuiltImprovementKey = GameInfo.Improvements[impID].Type;
	end

	local strImpKey = "";
	local strImpName = "";
	for row in GameInfo.Improvement_ResourceTypes("ResourceType='" .. pResource.Type .. "'") do
		
		strImpKey = row.ImprovementType;		 
		-- do not display the improvement list if the improvement already on the plot matches any 
		-- of the required improvements for the resource
		if (strImpKey == strBuiltImprovementKey) then
			return "";
		end

		-- only add the improvement, if it can be built on this plot
		local iCurrentImprovementInfo = GameInfo.Improvements[ strImpKey ];
		if (pPlot:CanHaveImprovement(iCurrentImprovementInfo.ID, -1)
			and not iCurrentImprovementInfo.CreatedByGreatPerson
			and (iCurrentImprovementInfo.CivilizationType == nil
				or iCurrentImprovementInfo.CivilizationType == GameInfo.Civilizations[player:GetCivilizationType()].Type)
			) then
			strImpName = Locale.ConvertTextKey( iCurrentImprovementInfo.Description );

			if (strResult ~= "") then
				strResult = strResult .. ", ";
			end

			strResult = strResult .. strImpName;
		end
	end

	return strResult;
end

-------------------------------------------------
-- Returns the current yield of a plot
-------------------------------------------------
function csebPlotHelpers_GetCurrentPlotYieldString(pPlot)	
	
	local iNumFood			= pPlot:CalculateYield(0, true); -- food	
	local iNumProduction	= pPlot:CalculateYield(1, true); -- production	
	local iNumGold			= pPlot:CalculateYield(2, true); -- gold	
	local iNumScience		= pPlot:CalculateYield(3, true); -- science	
	local iNumCulture		= pPlot:CalculateYield(4, true); -- science	
	local iNumFaith			= pPlot:CalculateYield(5, true); -- science	

	local iResourceNum = 0;
	local pResource;
	local iHappy = Plot_GetYield(pPlot, YieldTypes.YIELD_HAPPINESS_CITY) + Plot_GetYield(pPlot, YieldTypes.YIELD_HAPPINESS_NATIONAL);

	local activeTeamID = Game.GetActiveTeam(); -- the ID of the currently active team
	local pTeam = Teams[activeTeamID]; -- the currently active team
	
	local iResource = pPlot:GetResourceType(activeTeamID);
	
	if iResource >= 0 then -- if there is a resource on this pPlot
		
		pResource = GameInfo.Resources[iResource]; -- get the resource object
		
		if csebPlotHelpers_IsResourceImproved(pPlot, pResource) then -- if the resource is being worked
				
			iResourceNum = pPlot:GetNumResource();
			if pResource.Happiness then -- if it is a luxury resource, adjust the happiness display
				iHappy = iHappy + pResource.Happiness;
				iResourceNum = 1;
			elseif iResourceNum <= 1 then --  we do not display food resources
				iResourceNum = 0;
			end

		end

	end

	return csebPlotHelpers_GetFormattedYieldString(iResourceNum, pResource, iHappy, iNumFood, iNumProduction, iNumGold, iNumScience, iNumCulture, iNumFaith);
end


-------------------------------------------------
-- Returns the yield of a plot without its
-- actual feature (forest/jungle/marsh)
-------------------------------------------------
function csebPlotHelpers_GetYieldWithoutFeatureString(pPlot)
	local strResult = "";
    
	-- find feature on the plot
	local iFeature = pPlot:GetFeatureType();
	if (iFeature < 0) then
		return "" -- there is no feature to remove
	end
	local iBuild = -1;
	if (iFeature == GameInfoTypes["FEATURE_FOREST"]) then
		iBuild = GameInfoTypes["BUILD_REMOVE_FOREST"];
	elseif (iFeature == GameInfoTypes["FEATURE_JUNGLE"]) then
		iBuild = GameInfoTypes["BUILD_REMOVE_JUNGLE"];
	elseif (iFeature == GameInfoTypes["FEATURE_MARSH"]) then
		iBuild = GameInfoTypes["BUILD_REMOVE_MARSH"];
	elseif (iFeature == GameInfoTypes["FEATURE_FALLOUT"]) then
		iBuild = GameInfoTypes["BUILD_SCRUB_FALLOUT"];
	end

	if (iBuild ~= -1) then
		local buildInfo = GameInfo.Builds[iBuild];
		return csebPlotHelpers_GetPlotYieldWithBuild(pPlot, iBuild, true);
	end

	return "";
end

-------------------------------------------------
-- Returns true if the player has the technology
-- to build the specified item
-------------------------------------------------
function csebPlotHelpers_HasTechForBuild(buildInfo)
	local activeTeamID = Game.GetActiveTeam(); -- the ID of the currently active team
	local activeTeam = Teams[activeTeamID]; -- the currently active team
	if (buildInfo.PrereqTech ~= nil) then
		local prereqTech = GameInfo.Technologies[buildInfo.PrereqTech];
		if not prereqTech then
			log:Error("HasTechForBuild: %s prereq %s does not exist in Technologies!", buildInfo.Type, buildInfo.PrereqTech)
			return true
		end
		local prereqTechID = prereqTech.ID;
		if (prereqTechID ~= -1) then
			return activeTeam:GetTeamTechs():HasTech(prereqTechID);
		else
			return true;
		end		
	end
end

-------------------------------------------------
-- Returns true if the specified build is valid
-- for the plot specified
-------------------------------------------------
function csebPlotHelpers_CanBeBuilt(pPlot, buildInfo)
	local activeTeamID	= Game.GetActiveTeam();
	local iTerrain		= pPlot:GetTerrainType();
	local iFeature		= pPlot:GetFeatureType();
	local pFeature		= GameInfo.Features[iFeature];
	local iResource		= pPlot:GetResourceType(activeTeamID)
	local impID			= pPlot:GetRevealedImprovementType(activeTeamID, false);

	if not buildInfo.ImprovementType then -- if this is an improvement build
		return false;
	end
	
	local pImprovement = GameInfo.Improvements[buildInfo.ImprovementType];

	if pPlot:GetPlotType() == PlotTypes.PLOT_MOUNTAIN or (pFeature and pFeature.NoImprovement) then
		return false;
	end
		
	-- It is already built, we can't build it again
	if (impID == GameInfoTypes [ buildInfo.ImprovementType ]) then
		return false;
	end

	-- If it is a water improvement and we are not on water, we can't build it. same goes for land improvements not on land.
	if (pImprovement.Water ~= pPlot:IsWater()) then
		return false;
	end

	-- It has an resource
	if (iResource ~= -1) then
		-- check to see if the improvement has a valid resource type
		for row in GameInfo.Improvement_ResourceTypes("ResourceType = '" .. GameInfo.Resources[iResource].Type .. "' and ImprovementType = '" .. pImprovement.Type .. "'") do
			return true;
		end

		if (pImprovement.BuildableOnResources) then
			return true;
		end

		return false;
	end

	-- check to see if it has a valid terrain type
	for row in GameInfo.Improvement_ValidTerrains("TerrainType = '" .. GameInfo.Terrains[iTerrain].Type .. "' and ImprovementType = '" .. pImprovement.Type .. "'") do
		return true;
	end

	-- check to see if it has a valid feature type
	if (iFeature ~= -1) then
		for row in GameInfo.Improvement_ValidFeatures("FeatureType = '" .. GameInfo.Features[iFeature].Type .. "' and ImprovementType = '" .. pImprovement.Type .. "'") do
			return true;
		end
	end

	-- check to see if the plot matches any of the improvement's special validation rules
	if (pImprovement.HillsMakesValid and pPlot:IsHills()) then
		return true;
	end
	if (pImprovement.FreshWaterMakesValid and pPlot:IsFreshWater() and (pImprovement.BuildableOnResources or iResource == -1)) then
		return true;
	end

	return false;
end

-------------------------------------------------
-- Returns the yield of a plot with the specified
-- item built on it
-------------------------------------------------
function csebPlotHelpers_GetPlotYieldWithBuild(pPlot, iBuild, bScienceHack)
	local iNumFood			= pPlot:GetYieldWithBuild(iBuild, YieldTypes.YIELD_FOOD, false); -- food	
	local iNumProduction	= pPlot:GetYieldWithBuild(iBuild, YieldTypes.YIELD_PRODUCTION, false); -- production	
	local iNumGold			= pPlot:GetYieldWithBuild(iBuild, YieldTypes.YIELD_GOLD, false); -- gold	
	local iNumScience		= pPlot:GetYieldWithBuild(iBuild, YieldTypes.YIELD_SCIENCE, false); -- science	
	local iNumCulture		= pPlot:GetYieldWithBuild(iBuild, YieldTypes.YIELD_CULTURE, false); -- culture	
	local iNumFaith			= pPlot:GetYieldWithBuild(iBuild, YieldTypes.YIELD_FAITH, false); -- faith	
	local iResourceNum		= 0;
	local pResource			;
	local iHappy			= 0;

	if (bScienceHack) then -- for some reason, the game adds 1 science to some improvements (trading post) when called outside the cultural borders
		if (iNumScience == 1) then
			iNumScience = 0;
		end
	end

	local activeTeamID = Game.GetActiveTeam(); -- the ID of the currently active team
	local pTeam = Teams[activeTeamID]; -- the currently active team
	
	local iResource = pPlot:GetResourceType(activeTeamID);
	local buildInfo = GameInfo.Builds[iBuild];
	local pImprovementToBuild = nil;
	if (buildInfo.ImprovementType ~= nil) then
		pImprovementToBuild = GameInfo.Improvements[buildInfo.ImprovementType];
	end

	local pImprovementOnPlot = nil;
	local iImprovementOnPlotType = pPlot:GetRevealedImprovementType(activeTeamID, false);

	if (iImprovementOnPlotType ~= nil and iImprovementOnPlotType >= 0) then
		pImprovementOnPlot = GameInfo.Improvements[iImprovementOnPlotType];
	end
	
	if (iResource >= 0) then -- if there is a resource on this pPlot
		
		pResource = GameInfo.Resources[iResource]; -- get the resource object

		-- if it is outside the cultural borders, we have to add the resource based yield increases manually
		local iOwner = pPlot:GetRevealedOwner(activeTeamID, false);
		local needsAdjustment = true;
		if (iOwner >= 0) then
			local pPlayer = Players[iOwner];
			local plotTeam = pPlayer:GetTeam();
			if activeTeamID == plotTeam then
				needsAdjustment = false;
			end
		end

		if (needsAdjustment) then
			for row in GameInfo.Resource_YieldChanges("ResourceType='" .. pResource.Type .. "'") do
				iYieldTypeID = GameInfoTypes[row.YieldType];
				if (iYieldTypeID == YieldTypes.YIELD_FOOD) then	
					iNumFood = iNumFood + row.Yield;
				elseif (iYieldTypeID == YieldTypes.YIELD_PRODUCTION) then
					iNumProduction = iNumProduction + row.Yield;					
				elseif (iYieldTypeID == YieldTypes.YIELD_GOLD) then
					iNumGold = iNumGold + row.Yield;					
				elseif (iYieldTypeID == YieldTypes.YIELD_SCIENCE) then
					iNumScience = iNumScience + row.Yield;					
				end	
			end
		end

		local bShowResourceData = false;
		if (csebPlotHelpers_IsBuildImprovingResource(pPlot, GameInfoTypes [ buildInfo.ImprovementType ])) then
			bShowResourceData = true;
		elseif (buildInfo.RouteType ~= nil and csebPlotHelpers_IsBuildImprovingResource(pPlot, iImprovementOnPlotType)) then
			bShowResourceData = true;
		end
		
		if (bShowResourceData) then -- if the resource will be worked
				
			if (pResource.Happiness) then -- if it is a luxury resource, adjust the happiness display
				iHappy = pResource.Happiness;
			end

			iResourceNum = pPlot:GetNumResource();
			if (iHappy > 0) then -- for happiness resources, we display 1
				iResourceNum = 1;
			elseif (iResourceNum <= 1) then --  we do not display food resources
				iResourceNum = 0;
			end

			if (needsAdjustment) then
				local iYieldTypeID;
				for row in GameInfo.Improvement_ResourceType_Yields("ResourceType='" .. pResource.Type .. "' and ImprovementType='" .. pImprovementToBuild.Type .. "'") do
					iYieldTypeID = GameInfoTypes[row.YieldType];
					if (iYieldTypeID == YieldTypes.YIELD_FOOD) then	
						iNumFood = iNumFood + row.Yield;
					elseif (iYieldTypeID == YieldTypes.YIELD_PRODUCTION) then
						iNumProduction = iNumProduction + row.Yield;					
					elseif (iYieldTypeID == YieldTypes.YIELD_GOLD) then
						iNumGold = iNumGold + row.Yield;					
					elseif (iYieldTypeID == YieldTypes.YIELD_SCIENCE) then
						iNumScience = iNumScience + row.Yield;		
					elseif (iYieldTypeID == YieldTypes.YIELD_CULTURE) then
						iNumCulture = iNumCulture + row.Yield;	
					elseif (iYieldTypeID == YieldTypes.YIELD_FAITH) then
						iNumFaith = iNumFaith + row.Yield;
					end	
				end
			end		

		end

	end

	--[[ adjust culture manually
	if (pImprovementToBuild ~= nil and pImprovementToBuild.Culture) then
		iNumCulture = iNumCulture + pImprovementToBuild.Culture;
	end
	--]]

	return csebPlotHelpers_GetFormattedYieldString(iResourceNum, pResource, iHappy, iNumFood, iNumProduction, iNumGold, iNumScience, iNumCulture, iNumFaith);
end

-------------------------------------------------
-- Returns true if the resource on the plot
-- is improved by the proper improvement
-------------------------------------------------
function csebPlotHelpers_IsResourceImproved(pPlot)
	local activeTeamID = Game.GetActiveTeam(); 
	local impID = pPlot:GetRevealedImprovementType(activeTeamID, false);
	if (impID ~= nil and impID >= 0) then
		return pPlot:IsResourceConnectedByImprovement(impID);
	else
		return false;	
	end
end

-------------------------------------------------
-- Returns true if the specified build constructs
-- the proper improvement for the resource on 
-- on this plot
-------------------------------------------------
function csebPlotHelpers_IsBuildImprovingResource(pPlot, iImprovement)
	if (iImprovement == nil or iImprovement == NULL) then
		return false;
	elseif (iImprovement < 0) then
		return false;
	else
		return pPlot:IsResourceConnectedByImprovement(iImprovement);
	end
end

-------------------------------------------------
-- Returns the name of the feature on this plot
-------------------------------------------------
function csebPlotHelpers_GetPlotFeatureName(pPlot)
	local iFeature = pPlot:GetFeatureType();
	if (iFeature > -1) then
		return Locale.ConvertTextKey( GameInfo.Features[iFeature].Description );
	else
		return "";
	end
end

-------------------------------------------------
-- Returns a formatted yield line
-------------------------------------------------
function csebPlotHelpers_GetFormattedYieldString(iResourceNum, pResource, iHappy, iFood, iProduction, iGold, iScience, iCulture, iFaith)
	local strResult = "";
	local bShowBasicHelp = not OptionsManager.IsNoBasicHelp()

	if (iFood > 0) then
		strResult = strResult .. "[ICON_FOOD] " .. iFood .. " ";
	end
	if (iProduction > 0) then
		strResult = strResult .. "[ICON_PRODUCTION] " .. iProduction .. " ";
	end
	if (iGold > 0) then
		strResult = strResult .. "[ICON_GOLD] " .. iGold .. " ";
	end
	if (iScience > 0) then
		strResult = strResult .. "[ICON_RESEARCH] " .. iScience .. " ";
	end
	if (iCulture > 0) then
		strResult = strResult .. "[ICON_CULTURE] " .. iCulture .. " ";
	end
	if (iFaith > 0) then
		strResult = strResult .. "[ICON_PEACE] " .. iFaith .. " ";
	end
	if (iHappy > 0) then
		strResult = strResult .. "[ICON_HAPPINESS_1] " .. iHappy .. " ";
	end
	if (iResourceNum > 0 and pResource and bShowBasicHelp) then
		strResult = strResult .. pResource.IconString .. " " .. iResourceNum .. " ";
	end

	return strResult;
end