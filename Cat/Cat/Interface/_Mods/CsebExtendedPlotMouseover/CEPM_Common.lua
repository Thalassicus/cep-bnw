--
-- Common logic used by both plot info panels
-- Author: csebal
--

include("EPM_CommonPlotHelpers.lua");
include("AlpacaUtils");

-------------------------------------------------
-- Returns general unit / military information
-- about a plot
-------------------------------------------------
function GetUnitsString(plot)
	local textTip = "";
	local bShowBasicHelp = not OptionsManager.IsNoBasicHelp()

	local iActiveTeam = Game.GetActiveTeam();
	local pTeam = Teams[iActiveTeam];
	local bIsDebug = Game.IsDebugMode();
	local bFirstEntry = true;
	
	-- Loop through all units
	local numUnits = plot:GetNumUnits();
	for i = 0, numUnits do
		
		local unit = plot:GetUnit(i);
		if (unit ~= nil and not unit:IsInvisible(iActiveTeam, bIsDebug)) then

			if (bFirstEntry) then
				bFirstEntry = false;
			else
				textTip = textTip .. "[NEWLINE]";
			end

			local strength = unit:GetBaseCombatStrength();
			local unitInfo = GameInfo.Units[unit:GetUnitType()]
		
			local pPlayer = Players[unit:GetOwner()];
			
			-- Unit Name
			--local strUnitName = unit:GetNameKey();
			--local convertedKey = Locale.ConvertTextKey(strUnitName);
			local convertedKey = unit:GetName();
			--convertedKey = Locale.ToUpper(convertedKey);
			
			-- Player using nickname
			if (pPlayer:GetNickName() ~= nil and pPlayer:GetNickName() ~= "") then
				textTip = textTip .. Locale.ConvertTextKey("TXT_KEY_MULTIPLAYER_UNIT_TT", pPlayer:GetNickName(), Locale.ConvertTextKey(pPlayer:GetCivilizationAdjectiveKey()), convertedKey);
			-- Use civ short description
			else
				textTip = textTip .. Locale.ConvertTextKey("TXT_KEY_PLOTROLL_UNIT_DESCRIPTION_CIV", pPlayer:GetCivilizationAdjectiveKey(), convertedKey);
			end
			
			local unitTeam = unit:GetTeam();
			if iActiveTeam == unitTeam then
				textTip = "[COLOR_WHITE]" .. textTip .. "[ENDCOLOR]";
			elseif pTeam:IsAtWar(unitTeam) then
				textTip = "[COLOR_NEGATIVE_TEXT]" .. textTip .. "[ENDCOLOR]";
			else
				textTip = "[COLOR_POSITIVE_TEXT]" .. textTip .. "[ENDCOLOR]";
			end
			
			-- Debug stuff
			if (OptionsManager:IsDebugMode()) then
				textTip = textTip .. " ("..tostring(unit:GetOwner()).." - " .. tostring(unit:GetID()) .. ")";
			end
			
			-- Embarked
			if (unit:IsEmbarked()) and bShowBasicHelp then
				textTip = textTip .. ", " .. Locale.ConvertTextKey( "TXT_KEY_PLOTROLL_EMBARKED" );
			end
			

			local strStatus = ""

			if iActiveTeam == unitTeam and Unit_GetMaintenance(unitInfo.ID) > 0 and not unitInfo.NoMaintenance then
				strStatus = strStatus .. Unit_GetMaintenance(unitInfo.ID) .. "[ICON_GOLD] ";
			end

			-- Combat strength
			if (strength > 0) and bShowBasicHelp then
				strStatus = strStatus .. unit:GetBaseCombatStrength() .. "[ICON_STRENGTH] ";
			end
			
			-- Movement
			if iActiveTeam == unitTeam and bShowBasicHelp then
				strStatus = strStatus .. Locale.ConvertTextKey("TXT_KEY_HOVERINFO_MOVES", unit:MovesLeft() / GameDefines.MOVE_DENOMINATOR) .. " ";
			end
			
			-- Experience
			if iActiveTeam == unitTeam and unit:IsCombatUnit() or unit:GetDomainType() == DomainTypes.DOMAIN_AIR then
				strStatus = strStatus .. Locale.ConvertTextKey("TXT_KEY_HOVERINFO_EXPERIENCE", Unit_GetXPStored(unit), Unit_GetXPNeeded(unit)) .. " ";
			end
			
			-- Hit Points
			if unit:GetDamage() > 0 then
				strStatus = strStatus .. Locale.ConvertTextKey("TXT_KEY_HOVERINFO_HEALTH", GameDefines.MAX_HIT_POINTS - unit:GetDamage()) .. " ";
			end

			if strStatus ~= "" then
				textTip = textTip .. "[NEWLINE]" .. strStatus
			end
			
			-- Building something?
			--if (unit:GetBuildType() ~= -1) then
				--textTip = textTip .. ", " .. Locale.ConvertTextKey(GameInfo.Builds[unit:GetBuildType()].Description);
			--end
		end			
	end	
	
	return textTip;

end

-------------------------------------------------
-- Returns general city / owner information
-- about a plot
-------------------------------------------------
function GetOwnerString(plot)
	local textTip = "";
	
	local iActiveTeam = Game.GetActiveTeam();
	local pTeam = Teams[iActiveTeam];
	local bIsDebug = Game.IsDebugMode();
	
	-- City here?
	if plot:IsCity() then		
		local city = plot:GetPlotCity();
		local strAdjectiveKey = Players[city:GetOwner()]:GetCivilizationAdjectiveKey();		
		local cityMaxHealth = city:GetMaxHitPoints()
		local cityHealth = cityMaxHealth - city:GetDamage()
		local textHealth = Locale.ConvertTextKey("TXT_KEY_HOVERINFO_HEALTH_CITY", cityHealth, cityMaxHealth)
		
		if cityHealth < cityMaxHealth then
			textHealth = "[COLOR_NEGATIVE_TEXT]" .. textHealth .. "[ENDCOLOR]"
		end
		
		textTip = string.format("%s%s %s ",
			textTip,
			Locale.ConvertTextKey("TXT_KEY_CITY_OF", strAdjectiveKey, city:GetName()),
			textHealth
		)
		
	-- No city, see if this plot is just owned
	else
		
		-- Plot owner
		local iOwner = plot:GetRevealedOwner(iActiveTeam, bIsDebug);
		
		if (iOwner >= 0) then
			local pPlayer = Players[iOwner];
			
			-- Player using nickname
			if (pPlayer:GetNickName() ~= nil and pPlayer:GetNickName() ~= "") then
				textTip = Locale.ConvertTextKey("TXT_KEY_PLOTROLL_OWNED_PLAYER", pPlayer:GetNickName());
			-- Use civ short description
			else
				textTip = Locale.ConvertTextKey("TXT_KEY_PLOTROLL_OWNED_CIV", pPlayer:GetCivilizationShortDescriptionKey());
			end
				local iActiveTeam = Game.GetActiveTeam();
				local plotTeam = pPlayer:GetTeam();
				if iActiveTeam == plotTeam then
					textTip = "[COLOR_WHITE]" .. textTip .. "[ENDCOLOR]";
				elseif pTeam:IsAtWar(plotTeam) then
					textTip = "[COLOR_NEGATIVE_TEXT]" .. textTip .. "[ENDCOLOR]";
				else
					textTip = "[COLOR_POSITIVE_TEXT]" .. textTip .. "[ENDCOLOR]";
				end
		end
	end
	
	return textTip;
end

-------------------------------------------------
-- Returns general terrain information
-- about a plot
-------------------------------------------------
function GetNatureString(plot)	
	local textTip = ""; -- result string	
	local bFirst = true; -- differentiate betweent he first and subsequent entries in the nature line		
	local bMountain = false; -- mountains and special features (natural wonders) do not display base plot type.

	local iFeature = plot:GetFeatureType(); -- Get the feature on the plot

	-- Features
	if (iFeature > -1) then -- if there is a feature on the plot
		if (bFirst) then
			bFirst = false;
		else
			textTip = textTip .. ", ";
		end
			
		-- Block terrian type below natural wonders
		if (GameInfo.Features[iFeature].NaturalWonder) then
			bMountain = true;
		end
									
		textTip = textTip .. csebPlotHelpers_GetPlotFeatureName(plot);
	else 
		-- Mountain
		if (plot:IsMountain()) then
			if (bFirst) then
				bFirst = false;
			else
				textTip = textTip .. ", ";
			end
				
			bMountain = true;
				
			textTip = textTip .. Locale.ConvertTextKey( "TXT_KEY_PLOTROLL_MOUNTAIN" );
		end
	end
	-- Terrain
	if (not bMountain) then -- we do not display base terrain for mountain type features
		if (bFirst) then
			bFirst = false;
		else
			textTip = textTip .. ", ";
		end
			
		local convertedKey;
			
		-- Lake?
		if (plot:IsLake()) then
			convertedKey = Locale.ConvertTextKey( "TXT_KEY_PLOTROLL_LAKE" );
		else
			convertedKey = Locale.ConvertTextKey(GameInfo.Terrains[plot:GetTerrainType()].Description);		
		end
			
		textTip = textTip .. convertedKey;
	end
	-- Hills
	if (plot:IsHills()) then
		if (bFirst) then
			bFirst = false;
		else
			textTip = textTip .. ", ";
		end
		
		textTip = textTip .. Locale.ConvertTextKey( "TXT_KEY_PLOTROLL_HILL" );
	end
	-- River
	if (plot:IsRiver()) then
		if (bFirst) then
			bFirst = false;
		else
			textTip = textTip .. ", ";
		end
		
		textTip = textTip .. Locale.ConvertTextKey( "TXT_KEY_PLOTROLL_RIVER" );
	end
	-- Fresh Water
	if (plot:IsFreshWater()) then
		textTip = textTip .. ", [COLOR_POSITIVE_TEXT]" .. Locale.ConvertTextKey( "TXT_KEY_PLOTROLL_FRESH_WATER" ) .. "[ENDCOLOR]";
	end
	
	return textTip;	
end

-------------------------------------------------
-- Returns general improvement information
-- about a plot
-------------------------------------------------
function GetImprovementString(plot)

	local textTip = ""; -- result string		
	local iActiveTeam = Game.GetActiveTeam(); -- the ID of the currently active team
	local pTeam = Teams[iActiveTeam]; -- the currently active team

	-- add the improvement already built on this plot
	local iImprovementType = plot:GetRevealedImprovementType(iActiveTeam, false); -- get improvement on the plot
	if (iImprovementType >= 0) then -- if there is an improvement, display it
		if (textTip ~= "") then
			textTip = textTip .. ", ";
		end

		local improvementInfo = GameInfo.Improvements[iImprovementType]
		local improvementName = Locale.ConvertTextKey(improvementInfo.Description);

		if improvementInfo.BarbarianCamp then
			improvementName = "[COLOR_WARNING_TEXT]" ..improvementName.. "[ENDCOLOR]"
		end

		textTip = textTip .. improvementName;

		if plot:IsImprovementPillaged() then -- add text, when it is pillaged.
			textTip = textTip .. " [COLOR_WARNING_TEXT]" .. Locale.ConvertTextKey("TXT_KEY_PLOTROLL_PILLAGED") .. "[ENDCOLOR]";
		end
	end

	-- add the route already built on this plot
	local iRouteType = plot:GetRevealedRouteType(iActiveTeam, false); -- get route type on plot
	if (iRouteType > -1) then -- if there is a route, display it
		if (textTip ~= "") then
			textTip = textTip .. ", ";
		end
		local convertedKey = Locale.ConvertTextKey(GameInfo.Routes[iRouteType].Description);		
		textTip = textTip .. convertedKey;
		
		if (plot:IsRoutePillaged()) then
			textTip = textTip .." [COLOR_WARNING_TEXT]" .. Locale.ConvertTextKey("TXT_KEY_PLOTROLL_PILLAGED") .. "[ENDCOLOR]";
		end
	end

	-- add the improvement being built on this plot
	--[[
	for pBuildInfo in GameInfo.Builds() do -- iterate through all the possible worker actions
		local iTurnsLeft = PlotGetBuildTurnsLeft(plot, pBuildInfo.ID);
		-- only process if it is an improvement type and actually has turns left
		if (pBuildInfo.ImprovementType and iTurnsLeft < 4000 and iTurnsLeft > 0) then
			-- only process it, if it isnt already built
			if (GameInfoTypes[ pBuildInfo.ImprovementType ] ~= iImprovementType) then
				if (textTip ~= "") then
					textTip = textTip .. ", ";
				end

				local convertedKey = Locale.ConvertTextKey(GameInfo.Improvements[pBuildInfo.ImprovementType].Description);		
				textTip = textTip .. Locale.ConvertTextKey("TXT_KEY_CSB_PLOTROLL_IMPROVEMENT_UNDER_CONSTRUCTION", convertedKey, iTurnsLeft);
			end
		end
	end

	-- add the route being built on this plot
	for pBuildInfo in GameInfo.Builds() do -- iterate through all the possible worker actions
		local iTurnsLeft = plot:GetBuildTurnsLeft(pBuildInfo.ID, 0, 0);
		-- only process if it is an imprvement type and actually has turns left
		if (pBuildInfo.RouteType and iTurnsLeft < 4000 and iTurnsLeft > 0) then
			-- only process it, if it isnt already built
			if (GameInfoTypes[pBuildInfo.RouteType] ~= iRouteType) then

				if (textTip ~= "") then
					textTip = textTip .. ", ";
				end

				local convertedKey = Locale.ConvertTextKey(GameInfo.Routes[pBuildInfo.RouteType].Description);		
				textTip = textTip .. Locale.ConvertTextKey("TXT_KEY_CSB_PLOTROLL_IMPROVEMENT_UNDER_CONSTRUCTION", convertedKey, iTurnsLeft);
			end
		end
	end
	--]]
	
	for i=0, plot:GetNumUnits()-1 do
		local iBuildID = plot:GetUnit( i ):GetBuildType();
		if iBuildID ~= -1 then
			--local iTurnsLeft = plot:GetBuildTurnsLeft(pBuildInfo.ID, 0, 0); -- vanilla version is bugged
			local iTurnsLeft = PlotGetBuildTurnsLeft(plot, iBuildID);
				
			if (iTurnsLeft < 4000 and iTurnsLeft >= 0) then
				if (textTip ~= "") then
					textTip = textTip .. ", ";
				end

				local buildInfo = GameInfo.Builds[iBuildID]
				local buildDescription = ""
				if buildInfo.ImprovementType then
					buildDescription = Locale.ConvertTextKey(GameInfo.Improvements[buildInfo.ImprovementType].Description)
				elseif buildInfo.RouteType then
					buildDescription = Locale.ConvertTextKey(GameInfo.Routes[buildInfo.RouteType].Description)
				else
					buildDescription = buildInfo.Description
				end
					
				textTip = textTip .. Locale.ConvertTextKey("TXT_KEY_CSB_PLOTROLL_IMPROVEMENT_UNDER_CONSTRUCTION", buildDescription, iTurnsLeft);
			end
		end
	end
	
	return textTip;
end

-------------------------------------------------
-- Returns quests / tasks given by minor civs
-- if they are related to this plot
-------------------------------------------------
function GetCivStateQuestString(plot, bShortVersion)
	local textTip = "";  -- result string	
	local iActivePlayer = Game.GetActivePlayer(); -- the ID of the currently active player
	local iActiveTeam = Game.GetActiveTeam(); -- the ID of the currently active team
	local pTeam = Teams[iActiveTeam]; -- the currently active team
	
	for iPlayerLoop = GameDefines.MAX_MAJOR_CIVS, GameDefines.MAX_CIV_PLAYERS-1, 1 do -- cycle through other players
		pOtherPlayer = Players[iPlayerLoop]; -- the ID of the other player
		iOtherTeam = pOtherPlayer:GetTeam(); -- the ID of the other player's team
			
		if pOtherPlayer:IsMinorCiv() and iActiveTeam ~= iOtherTeam and pOtherPlayer:IsAlive() and pTeam:IsHasMet(iOtherTeam)  then
			
			-- Does the player have a quest to kill a barb camp here?
			if pOtherPlayer:IsMinorCivActiveQuestForPlayer(iActivePlayer, MinorCivQuestTypes.MINOR_CIV_QUEST_KILL_CAMP) then
				local iQuestData1 = pOtherPlayer:GetQuestData1(iActivePlayer, MinorCivQuestTypes.MINOR_CIV_QUEST_KILL_CAMP);
				local iQuestData2 = pOtherPlayer:GetQuestData2(iActivePlayer, MinorCivQuestTypes.MINOR_CIV_QUEST_KILL_CAMP);
				if iQuestData1 == plot:GetX() and iQuestData2 == plot:GetY() then
					if textTip ~= "" then
						textTip = textTip .. "[NEWLINE]";
					end
					if bShortVersion then
						textTip = textTip .. "[COLOR_POSITIVE_TEXT]" .. Locale.ConvertTextKey("TXT_KEY_CITY_STATE_BARB_QUEST_SHORT") .. "[ENDCOLOR]";
					else				
						textTip = textTip .. "[COLOR_POSITIVE_TEXT]" .. Locale.ConvertTextKey("TXT_KEY_CITY_STATE_BARB_QUEST_LONG",  pOtherPlayer:GetCivilizationShortDescriptionKey()) .. "[ENDCOLOR]";
					end
				end
			end
		end
	end		
	
	return textTip;
end

-------------------------------------------------
-- Returns resource information for any resource
-- located on this plot
-------------------------------------------------
function GetResourceString(plot, bShortVersion)
	local textTip = "";
	local iActiveTeam = Game.GetActiveTeam();
	local pTeam = Teams[iActiveTeam];
	local bShowBasicHelp = not OptionsManager.IsNoBasicHelp()
	
	if (plot:GetResourceType(iActiveTeam) >= 0) then
		local resourceType = plot:GetResourceType(iActiveTeam);
		local pResource = GameInfo.Resources[resourceType];
		
		textTip = textTip .. pResource.IconString .. " "
		if (plot:GetNumResource() > 1) then
			textTip = textTip .. "[COLOR_POSITIVE_TEXT]" .. plot:GetNumResource() .. "[ENDCOLOR] ";
		end
		textTip = textTip .. Locale.ConvertTextKey(pResource.Description);

		if bShowBasicHelp then
			local strImpList = csebPlotHelpers_GetImprovementListForResource(plot, pResource);
			if (strImpList ~= "") then
				textTip = textTip .. " " .. Locale.ConvertTextKey( "TXT_KEY_CSB_PLOTROLL_IMPROVEMENTS_REQUIRED_FOR_RESOURCE", strImpList );
			end
		end

		local iTechCityTrade = GameInfoTypes[pResource.TechCityTrade];
		if (iTechCityTrade ~= nil) then
			if (iTechCityTrade ~= -1 and not pTeam:GetTeamTechs():HasTech(iTechCityTrade)) then
				local techName = Locale.ConvertTextKey(GameInfo.Technologies[iTechCityTrade].Description);

				if bShowBasicHelp then
					textTip = textTip .. "[NEWLINE]"
				else
					textTip = textTip .. " "
				end
				
				if (bShortVersion) then
					textTip = textTip .. Locale.ConvertTextKey( "TXT_KEY_PLOTROLL_REQUIRES_TECH", techName );
				else
					textTip = textTip .. Locale.ConvertTextKey( "TXT_KEY_PLOTROLL_REQUIRES_TECH_TO_USE", techName );
				end
			end
		end
	end
	
	return textTip;	
end

-------------------------------------------------
-- Returns various yield informations 
-- about the plot
-------------------------------------------------
function GetYieldLines(plot, bExpanded)
	local textTip			= ""
	local bShowBasicHelp	= not OptionsManager.IsNoBasicHelp()

	-- get current plot yield
	local strCurrentYield = csebPlotHelpers_GetCurrentPlotYieldString(plot);

	-- get current plot yield
	if bShowBasicHelp then
		textTip = textTip .. Locale.ConvertTextKey("TXT_KEY_CSB_PLOTROLL_LABEL_YIELDS_ACTUAL", strCurrentYield);
	else
		textTip = textTip .. csebPlotHelpers_GetCurrentPlotYieldString(plot);
	end

	-- if the plot has a clearable feature, get the yield after clearing the feature
	local strPlotFeature = csebPlotHelpers_GetPlotFeatureName(plot);
	local strYieldWithoutFeature = csebPlotHelpers_GetYieldWithoutFeatureString(plot);

	local strExtraInfo = "";

	if (strYieldWithoutFeature ~= "") then
		strExtraInfo = strExtraInfo .. "[NEWLINE]" .. Locale.ConvertTextKey("TXT_KEY_CSB_PLOTROLL_LABEL_YIELDS_WITHOUTFEATURE", strPlotFeature, strYieldWithoutFeature);
	end

	-- list each item we can build on this plot, along with the yields they provide, if it differs from the base yield
	for pBuildInfo in GameInfo.Builds() do
		local strBuildName = "";
		
		if (pBuildInfo.ImprovementType ~= nil) then
			strBuildName = Locale.ConvertTextKey( GameInfo.Improvements[ pBuildInfo.ImprovementType ].Description );
		end
			
--		if (pBuildInfo.RouteType ~= nil) then
--			strBuildName = Locale.ConvertTextKey( GameInfo.Routes [ pBuildInfo.RouteType ].Description );
--		end
		
		if (strBuildName ~= "" and csebPlotHelpers_HasTechForBuild(pBuildInfo) and csebPlotHelpers_CanBeBuilt(plot, pBuildInfo)) then
			local strYieldWithBuild = csebPlotHelpers_GetPlotYieldWithBuild( plot, pBuildInfo.ID, true );
			if (strYieldWithBuild ~= "") then
				strExtraInfo = strExtraInfo .. "[NEWLINE]" .. Locale.ConvertTextKey("TXT_KEY_CSB_PLOTROLL_LABEL_YIELDS_WITHIMPROVEMENT", strBuildName, strYieldWithBuild);
			end
		end
	end

	if (bExpanded or strExtraInfo == "") then -- display expanded version, that also shows the yields
		textTip = textTip .. strExtraInfo;
	else
		if bShowBasicHelp then
			textTip = textTip .. "[NEWLINE]" .. Locale.ConvertTextKey("TXT_KEY_CSB_PLOTROLL_HELP_PRESS_FOR_MORE");
		end
	end

	return textTip;
end


-------------------------------------------------
-- Returns defensive bonuses / penalties 
-- for the plot
-------------------------------------------------
function GetPlotDefenseString(plot)
	local textTip = ""; -- result string
	local iActiveTeam = Game.GetActiveTeam(); -- the ID of the currently active team
	local pTeam = Teams[iActiveTeam]; -- the currently active team

	if plot:GetPlotCity() then
		return textTip;
	end

	local iDefensePlotTotal = plot:DefenseModifier(pTeam, false);

	if (iDefensePlotTotal ~= 0) then
		textTip = Locale.ConvertTextKey("TXT_KEY_CSB_PLOTROLL_LABEL_DEFENSE_BLOCK_SIMPLE", iDefensePlotTotal)
	end

	return textTip;
end



