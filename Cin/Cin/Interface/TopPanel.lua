-------------------------------
-- TopPanel.lua
-------------------------------

--AttilaMod+
include("TopPanel_Clock");
include("YieldLibrary.lua")

local log = Events.LuaLogger:New()
log:SetLevel("WARN")

local showTimers = Civup.DEBUG_TIMER_LEVEL

--Great People display helper functions - from BlakeTheGreat

local bestGcity;

--return a dictionary of all the GPs from each city being built in the format: [{city, specialist} = progress]
function GetGPList(activePlayer)
	local progresses = {};
	for city in activePlayer:Cities() do
		for pSpecialistInfo in GameInfo.Specialists() do	
			local gpEntry				= {};
			gpEntry.progress			= city:GetSpecialistGreatPersonProgress(pSpecialistInfo.ID);
			gpEntry.perTurn				= getRateOfChange(city,pSpecialistInfo,activePlayer);
			if (gpEntry.progress > 0) or (gpEntry.perTurn > 0) then
				gpEntry.city			= city;
				gpEntry.specialistInfo	= pSpecialistInfo;
				gpEntry.specialistName	= Locale.ConvertTextKey(pSpecialistInfo.Description);
				gpEntry.name			= Locale.ConvertTextKey(GameInfo.UnitClasses[pSpecialistInfo.GreatPeopleUnitClass].Description);
				gpEntry.Color			= GameInfo.UnitClasses[pSpecialistInfo.GreatPeopleUnitClass].Color;
				gpEntry.icon			= GameInfo.UnitClasses[pSpecialistInfo.GreatPeopleUnitClass].IconString;
				gpEntry.threshold		= city:GetSpecialistUpgradeThreshold();
				gpEntry.turnsRemaining	= math.ceil((gpEntry.threshold - gpEntry.progress) / gpEntry.perTurn);
				table.insert(progresses, gpEntry);
			end
		end
	end
	return progresses;
end

--given a city and GP, returns the progress per turn
function getRateOfChange(city, specialistInfo, activePlayer)
	local iCount = city:GetSpecialistCount( specialistInfo.ID );
	local iGPPChange = specialistInfo.GreatPeopleRateChange * iCount * 100;
	for building in GameInfo.Buildings() do
		local buildingID = building.ID;
		if building.SpecialistType == specialistInfo.Type then
			if (city:IsHasBuilding(buildingID)) then
				iGPPChange = iGPPChange + building.GreatPeopleRateChange * 100;
			end
		end
	end
	if iGPPChange > 0 then
		local iMod = 0;
		iMod = iMod + city:GetGreatPeopleRateModifier();
		iMod = iMod + activePlayer:GetGreatPeopleRateModifier();
		if (specialistInfo.GreatPeopleUnitClass == "UNITCLASS_SCIENTIST") then
			iMod = iMod + activePlayer:GetTraitGreatScientistRateModifier();
		end
		iGPPChange = (iGPPChange * (100 + iMod)) / 100;
		return math.floor(iGPPChange/100);
	else
		return 0;
	end
end

--AttilaMod-

function UpdateData()

	local activePlayerID = Game.GetActivePlayer();
	if activePlayerID < 0 then
		return
	end

	local activePlayer = Players[activePlayerID];
	local activeTeam = Teams[activePlayer:GetTeam()];

	-- Update turn counter
	local turn = Locale.ConvertTextKey("TXT_KEY_TP_TURN_COUNTER", Game.GetGameTurn());
	Controls.CurrentTurn:SetText(turn);
		

	-- Update date
	local date;
	local traditionalDate;
	local year = Game.GetGameTurnYear();
	if(year < 0) then
		traditionalDate = Locale.ConvertTextKey("TXT_KEY_TIME_BC", math.abs(year));
	else
		traditionalDate = Locale.ConvertTextKey("TXT_KEY_TIME_AD", math.abs(year));
	end


	if (activePlayer:IsUsingMayaCalendar()) then
		date = activePlayer:GetMayaCalendarString();
		local toolTipString = Locale.ConvertTextKey("TXT_KEY_MAYA_DATE_TOOLTIP", activePlayer:GetMayaCalendarLongString(), traditionalDate);
		Controls.CurrentDate:SetToolTipString(toolTipString);
	else
		date = traditionalDate;
	end
	
	Controls.CurrentDate:SetText(date);
	
	if activePlayer:GetNumCities() <= 0 then
		Controls.TopPanelInfoStack:SetHide(true)
		return
	end
	
	if not activePlayer:IsTurnActive() then
		return
	end

	Controls.TopPanelInfoStack:SetHide(false);
	
	local city = UI.GetHeadSelectedCity();
	if city and UI.IsCityScreenUp() then		
		Controls.MenuButton:SetText(Locale.ToUpper(Locale.ConvertTextKey("TXT_KEY_RETURN")));
		Controls.MenuButton:SetToolTipString(Locale.ConvertTextKey("TXT_KEY_CITY_SCREEN_EXIT_TOOLTIP"));
	else
		Controls.MenuButton:SetText(Locale.ToUpper(Locale.ConvertTextKey("TXT_KEY_MENU")));
		Controls.MenuButton:SetToolTipString(Locale.ConvertTextKey("TXT_KEY_MENU_TOOLTIP"));
	end

	-----------------------------
	-- Update science stats
	-----------------------------
	local strScienceText;
	
	if (Game.IsOption(GameOptionTypes.GAMEOPTION_NO_SCIENCE)) then
		strScienceText = Locale.ConvertTextKey("TXT_KEY_TOP_PANEL_SCIENCE_OFF");
	else

		local sciencePerTurn = activePlayer:GetYieldRate(YieldTypes.YIELD_SCIENCE);

		-- No Science
		if (sciencePerTurn <= 0) then
			strScienceText = string.format("[COLOR:255:60:60:255]" .. Locale.ConvertTextKey("TXT_KEY_NO_SCIENCE") .. "[ENDCOLOR]");
		-- We have science
		else
			local activeTeamTechs = activeTeam:GetTeamTechs();
			
			eCurrentTech = activePlayer:GetCurrentResearch();
			eRecentTech = activeTeamTechs:GetLastTechAcquired();

			if (eCurrentTech ~= -1) then
				local iResearchTurnsLeft = activePlayer:GetYieldTurns(YieldTypes.YIELD_SCIENCE,  eCurrentTech);
				local pTechInfo = GameInfo.Technologies[eCurrentTech];
				local szText = Locale.ConvertTextKey( pTechInfo.Description );
				strScienceText = string.format("%s (%i)", szText, math.ceil(iResearchTurnsLeft));
			elseif (eRecentTech ~= -1) then
				local pTechInfo = GameInfo.Technologies[eRecentTech];
				local szText = Locale.ConvertTextKey( pTechInfo.Description );
				strScienceText = string.format("%s (%i)", szText, 0);
				
			end

			local iGoldPerTurn = activePlayer:GetYieldRate(YieldTypes.YIELD_GOLD);
			
			-- Gold being deducted from our Science
			if (activePlayer:GetGold() + iGoldPerTurn < 0) then
				strScienceText = "[COLOR_NEGATIVE_TEXT]" .. strScienceText .. "[ENDCOLOR]";
			-- Normal Science state
			else
				strScienceText = "[COLOR_RESEARCH_STORED]" .. strScienceText .. "[ENDCOLOR]";
			end
		end
	
		strScienceText = "[ICON_RESEARCH]" .. strScienceText;
	end
	
	Controls.SciencePerTurn:SetText(strScienceText);
	
	-----------------------------
	-- Update gold stats
	-----------------------------
	local iTotalGold = activePlayer:GetGold();
	local iGoldPerTurn = activePlayer:GetYieldRate(YieldTypes.YIELD_GOLD);

	-- Accounting for positive or negative GPT - there's obviously a better way to do this.  If you see this comment and know how, it's up to you ;)
	-- Text is White when you can buy a Plot
	--if (iTotalGold >= activePlayer:GetBuyPlotCost(-1,-1)) then
		--if (iGoldPerTurn >= 0) then
			--strGoldStr = string.format("[COLOR:255:255:255:255]%i (+%i)[/COLOR]", iTotalGold, iGoldPerTurn)
		--else
			--strGoldStr = string.format("[COLOR:255:255:255:255]%i (%i)[/COLOR]", iTotalGold, iGoldPerTurn)
		--end
	---- Text is Yellow or Red when you can't buy a Plot
	--else
	local strGoldStr = Locale.ConvertTextKey("TXT_KEY_TOP_PANEL_GOLD", iTotalGold, iGoldPerTurn);
	--end
	
	Controls.GoldPerTurn:SetText(strGoldStr);
	
	-----------------------------
	-- Update Happiness
	-----------------------------
	local strHappiness;
	
	if (Game.IsOption(GameOptionTypes.GAMEOPTION_NO_HAPPINESS)) then
		strHappiness = Locale.ConvertTextKey("TXT_KEY_TOP_PANEL_HAPPINESS_OFF");
	else
		local iHappiness = activePlayer:GetExcessHappiness()--Game.Round(activePlayer:GetYieldRate(YieldTypes.YIELD_HAPPINESS_NATIONAL));
		local tHappinessTextColor;

		-- Empire is Happiness
		if iHappiness >= 0 then
			strHappiness = string.format("[ICON_HAPPINESS_1][COLOR:60:255:60:255]%i[ENDCOLOR]", iHappiness);
		
		-- Empire Really Unhappy
		elseif iHappiness <= GameDefines.VERY_UNHAPPY_THRESHOLD then
			strHappiness = string.format("[ICON_HAPPINESS_4][COLOR:255:60:60:255]%i[ENDCOLOR]", -iHappiness);
		
		-- Empire Unhappy
		else
			strHappiness = string.format("[ICON_HAPPINESS_3][COLOR:255:60:60:255]%i[ENDCOLOR]", -iHappiness);
		end
	end
	
	Controls.HappinessString:SetText(strHappiness);
	
	-----------------------------
	-- Update Golden Age Info
	-----------------------------
	local strGoldenAgeStr = "";

	if (Game.IsOption(GameOptionTypes.GAMEOPTION_NO_HAPPINESS)) then
		strGoldenAgeStr = Locale.ConvertTextKey("TXT_KEY_TOP_PANEL_GOLDEN_AGES_OFF");
	else
		strGoldenAgeStr = string.format("%s%i/%i", strGoldenAgeStr, activePlayer:GetGoldenAgeProgressMeter(), activePlayer:GetGoldenAgeProgressThreshold());
		if (activePlayer:GetGoldenAgeTurns() > 0) then
			strGoldenAgeStr = string.format("%s (%i %s!)", strGoldenAgeStr, activePlayer:GetGoldenAgeTurns(), Locale.ConvertTextKey("TXT_KEY_TURNS"));
		end

		strGoldenAgeStr = "[ICON_GOLDEN_AGE][COLOR:255:255:255:255]" .. strGoldenAgeStr .. "[ENDCOLOR]";
	end
	
	Controls.GoldenAgeString:SetText(strGoldenAgeStr);
	
	-----------------------------
	-- Update Culture
	-----------------------------

	local strCultureStr;
	
	if (Game.IsOption(GameOptionTypes.GAMEOPTION_NO_POLICIES)) then
		strCultureStr = Locale.ConvertTextKey("TXT_KEY_TOP_PANEL_POLICIES_OFF");
	else
		strCultureStr = string.format("[ICON_CULTURE][COLOR:255:0:255:255]%s %s[ENDCOLOR]", activePlayer:GetYieldTurns(YieldTypes.YIELD_CULTURE), Locale.ConvertTextKey("TXT_KEY_TURNS"))
	end
	
	Controls.CultureString:SetText(strCultureStr);
	
	-----------------------------
	-- Update Faith
	-----------------------------
	local strFaithStr;
	if (Game.IsOption(GameOptionTypes.GAMEOPTION_NO_RELIGION)) then
		strFaithStr = Locale.ConvertTextKey("TXT_KEY_TOP_PANEL_RELIGION_OFF");
	else
		local yieldNeeded = activePlayer:GetYieldTurns(YieldTypes.YIELD_FAITH)
		if yieldNeeded == 0 or yieldNeeded == math.huge then
			strFaithStr = string.format("[ICON_PEACE][%s]%s[ENDCOLOR]", GameInfo.Yields.YIELD_FAITH.Color, activePlayer:GetYieldStored(YieldTypes.YIELD_FAITH))
		else
			strFaithStr = string.format("[ICON_PEACE][%s]%s/%s[ENDCOLOR]", GameInfo.Yields.YIELD_FAITH.Color, activePlayer:GetYieldStored(YieldTypes.YIELD_FAITH), activePlayer:GetYieldNeeded(YieldTypes.YIELD_FAITH))
		end
	end
	Controls.FaithString:SetText(strFaithStr);

	-----------------------------------------------
	----------- Update Great People ---------------
	-----------------------------------------------


	--Controls.GreatPeopleString:SetHide(false);

	local strTooltip = ""

	local GPList = GetGPList(activePlayer)

	if GPList ~= nil then
		table.sort(GPList, function (a,b)
			if a.turnsRemaining ~= b.turnsRemaining then
				return a.turnsRemaining < b.turnsRemaining
			else
				if a.progress ~= b.progress then
					return a.progress < b.progress
				else
					return a.name < b.name
				end
			end
		end)
		local bestGP = GPList[1]
		if bestGP and bestGP.perTurn > 0 then
			bestGcity = bestGP.city
			strTooltip = strTooltip .. "[ICON_GREAT_PEOPLE][COLOR:" .. bestGP.Color .. "]" .. bestGP.specialistName
			strTooltip = strTooltip ..  " (" .. bestGP.turnsRemaining .. ")[ENDCOLOR]"
		else
			bestGcity = nil
			gpName = Locale.ConvertTextKey("TXT_KEY_SPECIALIST_GENERAL")
			gpColor = Locale.ConvertTextKey(GameInfo.UnitClasses.UNITCLASS_GREAT_GENERAL.Color)
			strTooltip =  "[ICON_GREAT_PEOPLE]"..gpName .. " (" .. activePlayer:GetCombatExperience() .."/" .. activePlayer:GreatGeneralThreshold() .. ")"
		end
	end
	Controls.GreatPeopleString:SetText(strTooltip);
	--AttilaMod-

	-----------------------------
	-- Update Resources
	-----------------------------
	local iLuxurySurplus = 0;
	local strResourceText = "";

	for resInfo in GameInfo.Resources() do
		local resID = resInfo.ID;
		local res = activePlayer:GetResourceQuantities(resID)
		local bShowResource	= false;
	
		if res.IsStrategic then				
			bShowResource = res.Used > 0;
		
			if activePlayer:HasTech(GameInfoTypes[resInfo.TechReveal]) and activePlayer:HasTech(GameInfoTypes[resInfo.TechCityTrade]) then
				bShowResource = true;
			end
		
			if bShowResource then
				local strTempText = string.format(" %s %i  ", Locale.ConvertTextKey(resInfo.IconString), res.Available);
				if res.Tradable > 0 then
					strTempText = "[COLOR_POSITIVE_TEXT]" .. strTempText .. "[ENDCOLOR]";
				elseif res.Available < 0 then
					strTempText = "[COLOR_WARNING_TEXT]" .. strTempText .. "[ENDCOLOR]";
				end
				strResourceText = strResourceText .. strTempText;
			end
		elseif res.IsLuxury and res.Tradable > 0 then
			iLuxurySurplus = iLuxurySurplus + res.Tradable;
		end
	end
	
	if iLuxurySurplus > 0 then
		iLuxurySurplus = "[COLOR_POSITIVE_TEXT]".. iLuxurySurplus .."[ENDCOLOR]";
	end
	strResourceText =  strResourceText .. "[ICON_RES_GEMS] " .. iLuxurySurplus .. "  "

	local deals = activePlayer:GetPossibleDeals()
	if deals[2].num > 0 then
		strResourceText = string.format("%s%s %s  ", strResourceText, deals[2].icon,  deals[2].num)
	end
	
	Controls.ResourceString:SetText(strResourceText);

	-- Update Unit Supply
	local supplyMod = activePlayer:GetSupplyModifier(YieldTypes.YIELD_PRODUCTION, true)
	if (supplyMod ~= 0) then
		local maxSupply = GetMaxUnitSupply(activePlayer)
		local netSupply = GetMaxUnitSupply(activePlayer) - GetCurrentUnitSupply(activePlayer)
		local strUnitSupplyToolTip = Locale.ConvertTextKey("TXT_KEY_UNIT_SUPPLY_REACHED_TOOLTIP", maxSupply, -netSupply, -supplyMod);

		Controls.UnitSupplyString:SetToolTipString(strUnitSupplyToolTip);
		Controls.UnitSupplyString:SetHide(false);
	else
		Controls.UnitSupplyString:SetHide(true);
	end
end

function OnTopPanelDirty()
	if showTimers >= 1 then timeStart = os.clock() end
	UpdateData();
	if showTimers >= 1 then
		print(string.format("%3s ms for OnTopPanelDirty END", math.floor((os.clock() - timeStart) * 1000)))
	end
end

-------------------------------------------------
-------------------------------------------------
function OnCivilopedia()	
	-- In City View, return to main game
	--if (UI.GetHeadSelectedCity() ~= nil) then
		--Events.SerialEventExitCityScreen();
	--end
	--
	-- opens the Civilopedia without changing its current state
	Events.SearchForPediaEntry("");
end
Controls.CivilopediaButton:RegisterCallback( Mouse.eLClick, OnCivilopedia );

-------------------------------------------------
-------------------------------------------------
Controls.DebugButton:RegisterCallback( Mouse.eLClick, LuaEvents.PrintDebug );

-------------------------------------------------
-------------------------------------------------
function OnMenu()
	
	-- In City View, return to main game
	if (UI.GetHeadSelectedCity() ~= nil) then
		Events.SerialEventExitCityScreen();
		--UI.SetInterfaceMode(InterfaceModeTypes.INTERFACEMODE_SELECTION);
	-- In Main View, open Menu Popup
	else
	    UIManager:QueuePopup( LookUpControl( "/InGame/GameMenu" ), PopupPriority.InGameMenu );
	end
end
Controls.MenuButton:RegisterCallback( Mouse.eLClick, OnMenu );


-------------------------------------------------
-------------------------------------------------
function OnCultureClicked()
	
	Events.SerialEventGameMessagePopup( { Type = ButtonPopupTypes.BUTTONPOPUP_CHOOSEPOLICY } );

end
Controls.CultureString:RegisterCallback( Mouse.eLClick, OnCultureClicked );


-------------------------------------------------
-------------------------------------------------
function OnTechClicked()
	
	Events.SerialEventGameMessagePopup( { Type = ButtonPopupTypes.BUTTONPOPUP_TECH_TREE, Data2 = -1} );

end
Controls.SciencePerTurn:RegisterCallback( Mouse.eLClick, OnTechClicked );


-------------------------------------------------
-------------------------------------------------
function OnGoldClicked()
	
	Events.SerialEventGameMessagePopup( { Type = ButtonPopupTypes.BUTTONPOPUP_ECONOMIC_OVERVIEW } );

end
Controls.HappinessString:RegisterCallback( Mouse.eLClick, OnGoldClicked );
Controls.GoldenAgeString:RegisterCallback( Mouse.eLClick, OnGoldClicked );
Controls.GoldPerTurn:RegisterCallback( Mouse.eLClick, OnGoldClicked );


-------------------------------------------------
-------------------------------------------------
function OnGreatPeopleClicked()
	if bestGcity == nil then
		Events.SerialEventGameMessagePopup( { Type = ButtonPopupTypes.BUTTONPOPUP_MILITARY_OVERVIEW } );
		return;
	end
	
	local plot = bestGcity:Plot();
	if plot then
		local playerID = plot:GetOwner();
		local activePlayer = Players[playerID];
		
		-- Puppets are special
		if (bestGcity:IsPuppet()) then
			local popupInfo = {
					Type = ButtonPopupTypes.BUTTONPOPUP_ANNEX_CITY,
					Data1 = bestGcity:GetID(),
					Data2 = -1,
					Data3 = -1,
					Option1 = false,
					Option2 = false;
				}
			Events.SerialEventGameMessagePopup(popupInfo);
		else
			UI.DoSelectCityAtPlot( plot );
		end
	end
end
Controls.GreatPeopleString:RegisterCallback( Mouse.eLClick, OnGreatPeopleClicked );


-------------------------------------------------
-------------------------------------------------
function OnFaithClicked()
	
	Events.SerialEventGameMessagePopup( { Type = ButtonPopupTypes.BUTTONPOPUP_RELIGION_OVERVIEW } );

end
Controls.FaithString:RegisterCallback( Mouse.eLClick, OnFaithClicked );

-------------------------------------------------
-------------------------------------------------
function OnResourcesClicked()
	
	Events.SerialEventGameMessagePopup( { Type = ButtonPopupTypes.BUTTONPOPUP_DIPLOMATIC_OVERVIEW } );

end
Controls.ResourceString:RegisterCallback( Mouse.eLClick, OnResourcesClicked );


-------------------------------------------------
-------------------------------------------------
function OnTurnsClicked()
	if MapModData.InfoAddict then
		UIManager:PushModal(MapModData.InfoAddict.InfoAddictScreenContext);
	end
end
Controls.CurrentDate:RegisterCallback( Mouse.eLClick, OnTurnsClicked );
Controls.CurrentTurn:RegisterCallback( Mouse.eLClick, OnTurnsClicked );




-------------------------------------------------
-- TOOLTIPS
-------------------------------------------------


-- Tooltip init
function DoInitTooltips()
	Controls.SciencePerTurn:SetToolTipCallback( ScienceTipHandler );
	Controls.GoldPerTurn:SetToolTipCallback( GoldTipHandler );
	Controls.HappinessString:SetToolTipCallback( HappinessTipHandler );
	Controls.GoldenAgeString:SetToolTipCallback( GoldenAgeTipHandler );
	Controls.CultureString:SetToolTipCallback( CultureTipHandler );
	Controls.FaithString:SetToolTipCallback( FaithTipHandler );
	Controls.GreatPeopleString:SetToolTipCallback(GreatPeopleTipHandler);
	Controls.ResourceString:SetToolTipCallback( ResourcesTipHandler );
end

-- Science Tooltip
local tipControlTable = {};
TTManager:GetTypeControlTable( "TooltipTypeTopPanel", tipControlTable );
function ScienceTipHandler( control )
	if (Game.IsOption(GameOptionTypes.GAMEOPTION_NO_SCIENCE)) then
		strText = Locale.ConvertTextKey("TXT_KEY_TOP_PANEL_SCIENCE_OFF_TOOLTIP");
		tipControlTable.TooltipLabel:SetText( strText );
		tipControlTable.TopPanelMouseover:SetHide(false);
	    
	    -- Autosize tooltip
	    tipControlTable.TopPanelMouseover:DoAutoSize();
		return;
	end

	local strText		= "";
	local playerID		= Game.GetActivePlayer();
	local player		= Players[playerID];
	local activeTeam	= Teams[player:GetTeam()];
	local city			= UI.GetHeadSelectedCity();
	
	local yieldInfo		= GameInfo.Yields.YIELD_SCIENCE
	local yieldDesc		= Locale.ConvertTextKey(yieldInfo.Description)
	local yieldIcon		= Locale.ConvertTextKey(yieldInfo.IconString)
	local yieldID		= yieldInfo.ID
	local yieldStored	= player:GetYieldStored(yieldID);
	local yieldNeeded	= player:GetYieldNeeded(yieldID);
	local yieldRate		= player:GetYieldRate(yieldID);
	local yieldTurns	= (yieldRate == 0) and "?" or math.ceil(player:GetYieldTurns(yieldID));
	
	strText = strText .. Locale.ConvertTextKey("TXT_KEY_YIELD_BREAKDOWN",
		yieldInfo.Color,
		Game.Round(yieldStored, 1),
		Game.Round(yieldNeeded, 1),
		Game.Round(yieldRate, 1),		
		yieldIcon,
		yieldDesc
	)
	strText = strText .. "[NEWLINE]";
	
	-- Science LOSS from Budget Deficits
	local goldSurplus = player:GetYieldStored(YieldTypes.YIELD_GOLD) + player:GetYieldRate(YieldTypes.YIELD_GOLD);
	if goldSurplus < 0  then
		strText = strText .. "[NEWLINE]" .. Locale.ConvertTextKey("TXT_KEY_TP_SCIENCE_FROM_BUDGET_DEFICIT", goldSurplus);
		strText = strText .. "[NEWLINE]";
	end
	
	local yieldFromEmpire = player:GetMinYieldRate(yieldID);
	if (yieldFromEmpire ~= 0) then
		strText = strText .. "[NEWLINE]" .. Locale.ConvertTextKey("TXT_KEY_TP_YIELD_FOR_FREE", yieldFromEmpire, yieldIcon);
	end
	
	local yieldFromCities = player:GetScienceFromCitiesTimes100();
	if (yieldFromCities ~= 0) then
		strText = strText .. "[NEWLINE]" .. Locale.ConvertTextKey("TXT_KEY_TP_YIELD_FROM_CITIES", yieldFromCities / 100, yieldIcon);
	end
	
	local yieldFromOtherPlayers = player:GetScienceFromOtherPlayersTimes100();
	if (yieldFromOtherPlayers ~= 0) then
		strText = strText .. "[NEWLINE]" .. Locale.ConvertTextKey("TXT_KEY_TP_YIELD_FROM_MINORS", yieldFromOtherPlayers / 100, yieldIcon);
	end
	
	local yieldFromDeals = Game.Round(player:GetYieldFromTradeDeals(yieldID));
	if (yieldFromDeals ~= 0) then
		strText = strText .. "[NEWLINE]" .. Locale.ConvertTextKey("TXT_KEY_TP_YIELD_FROM_RESEARCH_AGREEMENTS", yieldFromDeals, yieldIcon);
	end

	local yieldFromResources = player:GetYieldFromResources(yieldID);
	if (yieldFromResources ~= 0) then
		strText = strText .. "[NEWLINE]" .. Locale.ConvertTextKey("TXT_KEY_TP_YIELD_FROM_LUXURIES", yieldFromResources / 100, yieldIcon);
	end
	
	--
	local yieldFromPolicies = Game.Round(player:GetYieldFromPolicies(yieldID));
	if (yieldFromPolicies > 0) then
		strText = strText .. "[NEWLINE]" .. Locale.ConvertTextKey("TXT_KEY_TP_YIELD_FROM_POLICIES", yieldFromPolicies, yieldIcon);
	end	
	--]]
	
	strText = strText .. "[NEWLINE]"
	
	local yieldFromHappiness = player:GetYieldHappinessMod(yieldID);
	if (yieldFromHappiness ~= 0) then
		if yieldFromHappiness >= 0 then
			strText = strText .. "[NEWLINE]" .. Locale.ConvertTextKey("TXT_KEY_TP_YIELD_FROM_HAPPINESS", yieldFromHappiness, yieldIcon);
		else
			strText = strText .. "[NEWLINE]" .. Locale.ConvertTextKey("TXT_KEY_TP_YIELD_FROM_UNHAPPINESS", -yieldFromHappiness, yieldIcon);
		end
	end
	
	if not OptionsManager.IsNoBasicHelp() then
		strText = strText .. "[NEWLINE]" .. Locale.ConvertTextKey("TXT_KEY_TP_SCIENCE");		
	end
	
	tipControlTable.TooltipLabel:SetText(Game.RemoveExtraNewlines(strText));
	tipControlTable.TopPanelMouseover:SetHide(false);
    
    -- Autosize tooltip
    tipControlTable.TopPanelMouseover:DoAutoSize();	
end

-- Gold Tooltip
function GoldTipHandler( control )

	local strText = "";
	local activePlayerID = Game.GetActivePlayer();
	local activePlayer = Players[activePlayerID];
	local activeTeam = Teams[activePlayer:GetTeam()];
	local city = UI.GetHeadSelectedCity();
	
	local iTotalGold = activePlayer:GetGold();

	local iGoldPerTurnFromOtherPlayers = activePlayer:GetGoldPerTurnFromDiplomacy();
	local iGoldPerTurnToOtherPlayers = 0;
	if (iGoldPerTurnFromOtherPlayers < 0) then
		iGoldPerTurnToOtherPlayers = -iGoldPerTurnFromOtherPlayers;
		iGoldPerTurnFromOtherPlayers = 0;
	end
	
	local iGoldPerTurnFromReligion = activePlayer:GetGoldPerTurnFromReligion();

	local fGoldPerTurnFromCities = activePlayer:GetGoldFromCitiesTimes100() / 100;
	local fCityConnectionGold = activePlayer:GetYieldFromConnectedCities(YieldTypes.YIELD_GOLD);
	local fOpenBordersGold = activePlayer:GetYieldFromTradeDeals(YieldTypes.YIELD_GOLD);
	local fLuxuryGold = activePlayer:GetYieldFromResources(YieldTypes.YIELD_GOLD);
	local fPolicyGold = activePlayer:GetYieldFromPolicies(YieldTypes.YIELD_GOLD);
	local fTotalIncome = activePlayer:GetBaseYieldRate(YieldTypes.YIELD_GOLD);
	
	if (not OptionsManager.IsNoBasicHelp()) then
		strText = strText .. Locale.ConvertTextKey("TXT_KEY_TP_AVAILABLE_GOLD", iTotalGold);
		strText = strText .. "[NEWLINE][NEWLINE]";
	end
	
	strText = strText .. "[COLOR:150:255:150:255]";
	strText = strText .. "+" .. Locale.ConvertTextKey("TXT_KEY_TP_TOTAL_INCOME", math.floor(fTotalIncome));
	if activePlayer:GetMinYieldRate(YieldTypes.YIELD_GOLD) ~= 0 then
		strText = strText .. "[NEWLINE]  [ICON_BULLET]" .. Locale.ConvertTextKey("TXT_KEY_TP_GOLD_FOR_FREE", activePlayer:GetMinYieldRate(YieldTypes.YIELD_GOLD));
	end
	strText = strText .. "[NEWLINE]  [ICON_BULLET]" .. Locale.ConvertTextKey("TXT_KEY_TP_CITY_OUTPUT", fGoldPerTurnFromCities);
	strText = strText .. "[NEWLINE]  [ICON_BULLET]" .. Locale.ConvertTextKey("TXT_KEY_TP_GOLD_FROM_TR", Game.Round(fCityConnectionGold));
	if Civup.OPEN_BORDERS_GOLD_RATE_PERCENT and Civup.OPEN_BORDERS_GOLD_RATE_PERCENT ~= 0 then
		strText = strText .. "[NEWLINE]  [ICON_BULLET]" .. Locale.ConvertTextKey("TXT_KEY_TP_GOLD_FROM_OPEN_BORDERS", Game.Round(fOpenBordersGold));		
	end
	if (iGoldPerTurnFromOtherPlayers > 0) then
		strText = strText .. "[NEWLINE]  [ICON_BULLET]" .. Locale.ConvertTextKey("TXT_KEY_TP_GOLD_FROM_OTHERS", iGoldPerTurnFromOtherPlayers);
	end
	if (fLuxuryGold > 0) then
		strText = strText .. "[NEWLINE]  [ICON_BULLET]" .. Locale.ConvertTextKey("TXT_KEY_TP_YIELD_FROM_LUXURIES", Game.Round(fLuxuryGold, 1));
	end	
	if (fPolicyGold > 0) then
		strText = strText .. "[NEWLINE]  [ICON_BULLET]" .. Locale.ConvertTextKey("TXT_KEY_TP_GOLD_FROM_POLICIES", Game.Round(fPolicyGold, 1));
	end	
	if (iGoldPerTurnFromReligion > 0) then
		strText = strText .. "[NEWLINE]  [ICON_BULLET]" .. Locale.ConvertTextKey("TXT_KEY_TP_GOLD_FROM_RELIGION", iGoldPerTurnFromReligion);
	end
	strText = strText .. "[ENDCOLOR]";
	
	local iUnitCost = activePlayer:CalculateUnitCost();
	local iUnitSupply = activePlayer:CalculateUnitSupply();
	local iBuildingMaintenance = activePlayer:GetBuildingGoldMaintenance();
	local iImprovementMaintenance = activePlayer:GetImprovementGoldMaintenance();
	local iTotalExpenses = iUnitCost + iUnitSupply + iBuildingMaintenance + iImprovementMaintenance + iGoldPerTurnToOtherPlayers;
	
	strText = strText .. "[NEWLINE]";
	strText = strText .. "[COLOR:255:150:150:255]";
	strText = strText .. "[NEWLINE]-" .. Locale.ConvertTextKey("TXT_KEY_TP_TOTAL_EXPENSES", iTotalExpenses);
	if (iUnitCost ~= 0) then
		strText = strText .. "[NEWLINE]  [ICON_BULLET]" .. Locale.ConvertTextKey("TXT_KEY_TP_UNIT_MAINT", iUnitCost);
	end
	if (iUnitSupply ~= 0) then
		strText = strText .. "[NEWLINE]  [ICON_BULLET]" .. Locale.ConvertTextKey("TXT_KEY_TP_GOLD_UNIT_SUPPLY", iUnitSupply);
	end
	if (iBuildingMaintenance ~= 0) then
		strText = strText .. "[NEWLINE]  [ICON_BULLET]" .. Locale.ConvertTextKey("TXT_KEY_TP_GOLD_BUILDING_MAINT", iBuildingMaintenance);
	end
	if (iImprovementMaintenance ~= 0) then
		strText = strText .. "[NEWLINE]  [ICON_BULLET]" .. Locale.ConvertTextKey("TXT_KEY_TP_GOLD_TILE_MAINT", iImprovementMaintenance);
	end
	if (iGoldPerTurnToOtherPlayers > 0) then
		strText = strText .. "[NEWLINE]  [ICON_BULLET]" .. Locale.ConvertTextKey("TXT_KEY_TP_GOLD_TO_OTHERS", iGoldPerTurnToOtherPlayers);
	end
	strText = strText .. "[ENDCOLOR]";
	
	if (fTotalIncome + iTotalGold < 0) then
		strText = strText .. "[NEWLINE][COLOR:255:60:60:255]" .. Locale.ConvertTextKey("TXT_KEY_TP_LOSING_SCIENCE_FROM_DEFICIT") .. "[ENDCOLOR]";
	end
	
	-- Basic explanation of Happiness
	if (not OptionsManager.IsNoBasicHelp()) then
		strText = strText .. "[NEWLINE][NEWLINE]";
		strText = strText ..  Locale.ConvertTextKey("TXT_KEY_TP_GOLD_EXPLANATION");
	end
	
	--Controls.GoldPerTurn:SetToolTipString(strText);
	
	tipControlTable.TooltipLabel:SetText(Game.RemoveExtraNewlines(strText));
	tipControlTable.TopPanelMouseover:SetHide(false);
    
    -- Autosize tooltip
    tipControlTable.TopPanelMouseover:DoAutoSize();
	
end

-- Happiness Tooltip
function HappinessTipHandler( control )
	if (Game.IsOption(GameOptionTypes.GAMEOPTION_NO_HAPPINESS)) then
		strText = Locale.ConvertTextKey("TXT_KEY_TOP_PANEL_HAPPINESS_OFF_TOOLTIP");
		tipControlTable.TooltipLabel:SetText( strText );
		tipControlTable.TopPanelMouseover:SetHide(false);
	    
	    -- Autosize tooltip
	    tipControlTable.TopPanelMouseover:DoAutoSize();
		return;
	end

	local strText;
	local activePlayerID = Game.GetActivePlayer();
	local activePlayer = Players[activePlayerID];
	local activeTeam = Teams[activePlayer:GetTeam()];
	local city = UI.GetHeadSelectedCity();	
	
	local yieldID = ""
	
	yieldID = YieldTypes.YIELD_HAPPINESS_CITY;
	local iTerrainHappiness = activePlayer:GetYieldFromTerrain(yieldID);
	local iCityHappiness = activePlayer:GetYieldFromBuildings(yieldID);
	local iGarrisonedUnitsHappiness = 0 --activePlayer:GetHappinessFromGarrisonedUnits();	
	
	yieldID = YieldTypes.YIELD_HAPPINESS_NATIONAL;
	local iHappiness = activePlayer:GetExcessHappiness()--Game.Round(activePlayer:GetYieldRate(yieldID));	
	local iTotalHappiness = activePlayer:GetHappiness();
	local iPoliciesHappiness = activePlayer:GetHappinessFromPolicies();
	local iCitystatesHappiness = activePlayer:GetYieldsFromCitystates()[yieldID];
	local iResourcesHappiness = activePlayer:GetHappinessFromResources() + activePlayer:GetYieldFromSurplusResources(yieldID);
	local iExtraLuxuryHappiness = activePlayer:GetExtraHappinessPerLuxury();
	local iNationalBuildingHappiness = activePlayer:GetHappinessFromBuildings();
	local iTradeRouteHappiness = activePlayer:GetHappinessFromTradeRoutes();
	local iReligionHappiness = activePlayer:GetHappinessFromReligion();
	local iNaturalWonderHappiness = activePlayer:GetHappinessFromNaturalWonders();
	local iExtraHappinessPerCity = activePlayer:GetExtraHappinessPerCity() * activePlayer:GetNumCities();
	local iHandicapHappiness = GameInfo.HandicapInfos[activePlayer:GetHandicapType()].HappinessDefault;	
	local iMinorCivHappiness = 0;
	local iMiscGlobalHappiness = City_GetNumBuilding(activePlayer:GetCapitalCity(), GameInfo.Buildings.BUILDING_HAPPINESS_NATIONAL.ID);
	
	local pMinor;
	
	-- Loop through all the Minors the active activePlayer knows
	for iPlayerLoop = GameDefines.MAX_MAJOR_CIVS, GameDefines.MAX_CIV_PLAYERS-1, 1 do
		iMinorCivHappiness = iMinorCivHappiness + activePlayer:GetHappinessFromMinor(iPlayerLoop);
	end

	if iHappiness >= 0 then
		strText = Locale.ConvertTextKey("TXT_KEY_TP_TOTAL_HAPPINESS", iHappiness);
	elseif iHappiness <= GameDefines.VERY_UNHAPPY_THRESHOLD then
		strText = Locale.ConvertTextKey("TXT_KEY_TP_TOTAL_UNHAPPINESS", "[ICON_HAPPINESS_4]", -iHappiness);
	else
		strText = Locale.ConvertTextKey("TXT_KEY_TP_TOTAL_UNHAPPINESS", "[ICON_HAPPINESS_3]", -iHappiness);
	end	
	
	if iHappiness <= GameDefines.VERY_UNHAPPY_THRESHOLD then
		

		if activePlayer:IsEmpireSuperUnhappy() then
			strText = strText .. "[NEWLINE][NEWLINE]";
			strText = strText .. "[COLOR:255:60:60:255]" .. Locale.ConvertTextKey("TXT_KEY_TP_EMPIRE_SUPER_UNHAPPY") .. "[ENDCOLOR]";
		end
		
		strText = strText .. "[NEWLINE][NEWLINE]";
		strText = strText .. "[COLOR:255:60:60:255]" .. Locale.ConvertTextKey("TXT_KEY_TP_EMPIRE_VERY_UNHAPPY") .. "[ENDCOLOR]";
	elseif iHappiness < 0 then
		
		strText = strText .. "[NEWLINE][NEWLINE]";
		strText = strText .. "[COLOR:255:60:60:255]" .. Locale.ConvertTextKey("TXT_KEY_TP_EMPIRE_UNHAPPY") .. "[ENDCOLOR]";
	end
	
	strText = strText .. "[NEWLINE][NEWLINE]";
	strText = strText .. "[COLOR:150:255:150:255]";
	strText = strText .. Locale.ConvertTextKey("TXT_KEY_TP_HAPPINESS_SOURCES", iTotalHappiness);
	
	strText = strText .. "[NEWLINE]";
	strText = strText .. "  [ICON_BULLET]" .. Locale.ConvertTextKey("TXT_KEY_TP_HAPPINESS_FROM_RESOURCES", iResourcesHappiness);
	
	-- Individual Resource Info

	local iBaseHappinessFromResources = 0;
	local iNumHappinessResources = 0;
	for resource in GameInfo.Resources() do
		local resourceID = resource.ID;
		if (activePlayer:GetNumResourceTotal(resourceID, true) > 0) then
			if (resource.Happiness ~= 0) then
				strText = strText .. "[NEWLINE]";
				strText = strText .. "          +" .. Locale.ConvertTextKey("TXT_KEY_TP_HAPPINESS_EACH_RESOURCE", resource.Happiness, resource.IconString, resource.Description);
				iNumHappinessResources = iNumHappinessResources + 1;
				iBaseHappinessFromResources = iBaseHappinessFromResources + resource.Happiness;
			end
		end
	end
	
	-- Happiness from Luxury Variety
	local iHappinessFromExtraResources = activePlayer:GetHappinessFromResourceVariety();
	if (iHappinessFromExtraResources > 0) then
		strText = strText .. "[NEWLINE]";
		strText = strText .. "          +" .. Locale.ConvertTextKey("TXT_KEY_TP_HAPPINESS_RESOURCE_VARIETY", iHappinessFromExtraResources);
	end
	
	-- Extra Happiness from each Luxury
	if (iExtraLuxuryHappiness >= 1) then
		strText = strText .. "[NEWLINE]";
		strText = strText .. "          +" .. Locale.ConvertTextKey("TXT_KEY_TP_HAPPINESS_EXTRA_PER_RESOURCE", iExtraLuxuryHappiness, iExtraLuxuryHappiness * iNumHappinessResources + activePlayer:GetYieldFromSurplusResources(yieldID));
	end
	
	-- Misc Happiness from Resources
	local iMiscHappiness = iResourcesHappiness - iBaseHappinessFromResources - iHappinessFromExtraResources - (iExtraLuxuryHappiness * iNumHappinessResources) - activePlayer:GetYieldFromSurplusResources(yieldID) - activePlayer:GetYieldFromTerrain(yieldID);
	if (iMiscHappiness > 0) then
		strText = strText .. "[NEWLINE]";
		strText = strText .. "          +" .. Locale.ConvertTextKey("TXT_KEY_TP_HAPPINESS_OTHER_SOURCES", iMiscHappiness);
	end
	
	strText = strText .. "[NEWLINE]";
	strText = strText .. "  [ICON_BULLET]" .. Locale.ConvertTextKey("TXT_KEY_TP_HAPPINESS_TERRAIN", iTerrainHappiness);
	strText = strText .. "[NEWLINE]";
	strText = strText .. "  [ICON_BULLET]" .. Locale.ConvertTextKey("TXT_KEY_TP_HAPPINESS_CITIES", iCityHappiness);
	strText = strText .. "[NEWLINE]";
	strText = strText .. "  [ICON_BULLET]" .. Locale.ConvertTextKey("TXT_KEY_TP_HAPPINESS_BUILDINGS", iNationalBuildingHappiness);
	strText = strText .. "[NEWLINE]";
	strText = strText .. "  [ICON_BULLET]" .. Locale.ConvertTextKey("TXT_KEY_TP_HAPPINESS_POLICIES", iPoliciesHappiness);
	if (iCitystatesHappiness ~= 0) then
		strText = strText .. "[NEWLINE]";
		strText = strText .. "  [ICON_BULLET]" .. Locale.ConvertTextKey("TXT_KEY_TP_HAPPINESS_CITYSTATES", iCitystatesHappiness);
	end
	if (iGarrisonedUnitsHappiness ~= 0) then
		strText = strText .. "[NEWLINE]";
		strText = strText .. "  [ICON_BULLET]" .. Locale.ConvertTextKey("TXT_KEY_TP_HAPPINESS_GARRISONED_UNITS", iGarrisonedUnitsHappiness);
	end
	if (iTradeRouteHappiness ~= 0) then
		strText = strText .. "[NEWLINE]";
		strText = strText .. "  [ICON_BULLET]" .. Locale.ConvertTextKey("TXT_KEY_TP_HAPPINESS_CONNECTED_CITIES", iTradeRouteHappiness);
	end
	if (iReligionHappiness ~= 0) then
		strText = strText .. "[NEWLINE]";
		strText = strText .. "  [ICON_BULLET]" .. Locale.ConvertTextKey("TXT_KEY_TP_HAPPINESS_STATE_RELIGION", iReligionHappiness);
	end
	if (iNaturalWonderHappiness ~= 0) then
		strText = strText .. "[NEWLINE]";
		strText = strText .. "  [ICON_BULLET]" .. Locale.ConvertTextKey("TXT_KEY_TP_HAPPINESS_NATURAL_WONDERS", iNaturalWonderHappiness);
	end
	if (iExtraHappinessPerCity ~= 0) then
		strText = strText .. "[NEWLINE]";
		strText = strText .. "  [ICON_BULLET]" .. Locale.ConvertTextKey("TXT_KEY_TP_HAPPINESS_CITY_COUNT", iExtraHappinessPerCity);
	end
	if (iMinorCivHappiness ~= 0) then
		strText = strText .. "[NEWLINE]";
		strText = strText .. "  [ICON_BULLET]" .. Locale.ConvertTextKey("TXT_KEY_TP_HAPPINESS_CITY_STATE_FRIENDSHIP", iMinorCivHappiness);
	end
	strText = strText .. "[NEWLINE]";
	strText = strText .. "  [ICON_BULLET]" .. Locale.ConvertTextKey("TXT_KEY_TP_HAPPINESS_DIFFICULTY_LEVEL", iHandicapHappiness);
	if (iMiscGlobalHappiness ~= 0) then
		--strText = strText .. "[NEWLINE]";
		--strText = strText .. "  [ICON_BULLET]" .. Locale.ConvertTextKey("TXT_KEY_TP_HAPPINESS_MISC_GLOBAL", iMiscGlobalHappiness);
	end
	strText = strText .. "[ENDCOLOR]";
	
	-- Unhappiness
	local iTotalUnhappiness = activePlayer:GetUnhappiness();
	local iUnhappinessFromUnits = Locale.ToNumber( activePlayer:GetUnhappinessFromUnits() / 100, "#.#" );
	local iUnhappinessFromCityCount = Locale.ToNumber( activePlayer:GetUnhappinessFromCityCount() / 100, "#.#" );
	local iUnhappinessFromCapturedCityCount = Locale.ToNumber( activePlayer:GetUnhappinessFromCapturedCityCount() / 100, "#.#" );
	local iUnhappinessFromPupetCities = activePlayer:GetUnhappinessFromPuppetCityPopulation();
	local unhappinessFromSpecialists = activePlayer:GetUnhappinessFromCitySpecialists();
	local unhappinessFromPop = activePlayer:GetUnhappinessFromCityPopulation() - unhappinessFromSpecialists - iUnhappinessFromPupetCities;
	
	local iUnhappinessFromPop = Locale.ToNumber( unhappinessFromPop / 100, "#.##" );
	local iUnhappinessFromOccupiedCities = Locale.ToNumber( activePlayer:GetUnhappinessFromOccupiedCities() / 100, "#.##" );

	strText = strText .. "[NEWLINE][NEWLINE]";
	strText = strText .. "[COLOR:255:150:150:255]";
	strText = strText .. Locale.ConvertTextKey("TXT_KEY_TP_UNHAPPINESS_TOTAL", iTotalUnhappiness);
	strText = strText .. "[NEWLINE]";
	strText = strText .. "  [ICON_BULLET]" .. Locale.ConvertTextKey("TXT_KEY_TP_UNHAPPINESS_CITY_COUNT", iUnhappinessFromCityCount);
	if (iUnhappinessFromCapturedCityCount ~= "0") then
		strText = strText .. "[NEWLINE]";
		strText = strText .. "  [ICON_BULLET]" .. Locale.ConvertTextKey("TXT_KEY_TP_UNHAPPINESS_CAPTURED_CITY_COUNT", iUnhappinessFromCapturedCityCount);
	end
	strText = strText .. "[NEWLINE]";
	strText = strText .. "  [ICON_BULLET]" .. Locale.ConvertTextKey("TXT_KEY_TP_UNHAPPINESS_POPULATION", iUnhappinessFromPop);
	
	if(iUnhappinessFromPupetCities > 0) then
		strText = strText .. "[NEWLINE]";
		strText = strText .. "  [ICON_BULLET]" .. Locale.ConvertTextKey("TXT_KEY_TP_UNHAPPINESS_PUPPET_CITIES", iUnhappinessFromPupetCities / 100);
	end
	if (iUnhappinessFromOccupiedCities ~= "0") then
		strText = strText .. "[NEWLINE]";
		strText = strText .. "  [ICON_BULLET]" .. Locale.ConvertTextKey("TXT_KEY_TP_UNHAPPINESS_OCCUPIED_POPULATION", iUnhappinessFromOccupiedCities);
	end
	if(unhappinessFromSpecialists > 0) then
		strText = strText .. "[NEWLINE]  [ICON_BULLET]" .. Locale.ConvertTextKey("TXT_KEY_TP_UNHAPPINESS_SPECIALISTS", unhappinessFromSpecialists / 100);
	end
	if (iUnhappinessFromUnits ~= "0") then
		strText = strText .. "[NEWLINE]";
		strText = strText .. "  [ICON_BULLET]" .. Locale.ConvertTextKey("TXT_KEY_TP_UNHAPPINESS_UNITS", iUnhappinessFromUnits);
	end
	if (iPoliciesHappiness < 0) then
		strText = strText .. "[NEWLINE]";
		strText = strText .. "  [ICON_BULLET]" .. Locale.ConvertTextKey("TXT_KEY_TP_HAPPINESS_POLICIES", iPoliciesHappiness);
	end	
	strText = strText .. "[ENDCOLOR]";
	
	-- Basic explanation of Happiness
	if (not OptionsManager.IsNoBasicHelp()) then
		strText = strText .. "[NEWLINE][NEWLINE]";
		strText = strText ..  Locale.ConvertTextKey("TXT_KEY_TP_HAPPINESS_EXPLANATION");
	end
	
	tipControlTable.TooltipLabel:SetText(Game.RemoveExtraNewlines(strText));
	tipControlTable.TopPanelMouseover:SetHide(false);
    
    -- Autosize tooltip
    tipControlTable.TopPanelMouseover:DoAutoSize();
	
end

-- Golden Age Tooltip
function GoldenAgeTipHandler( control )

	local strText = "";
	local activePlayerID = Game.GetActivePlayer();
	local activePlayer = Players[activePlayerID];
	local activeTeam = Teams[activePlayer:GetTeam()];
	local city = UI.GetHeadSelectedCity();
	
	if (activePlayer:GetGoldenAgeTurns() > 0) then
		strText = strText .. Locale.ConvertTextKey("TXT_KEY_TP_GOLDEN_AGE_NOW", activePlayer:GetGoldenAgeTurns());
	else
		local iHappiness = Game.Round(activePlayer:GetYieldRate(YieldTypes.YIELD_HAPPINESS_NATIONAL));

--AttlaMod+
--Display turns left until next Golden Age (from salaminizer)
		local iTurns;

		if (iHappiness > 0) then
			iTurns = math.floor((activePlayer:GetGoldenAgeProgressThreshold() - activePlayer:GetGoldenAgeProgressMeter()) / iHappiness + 1);

			strText = string.format("%i turns left until the next Golden Age",iTurns);
			--strText = Locale.ConvertTextKey("TXT_KEY_NEXT_GOLDEN_AGE_TURN_LABEL", iTurns);
			strText = strText .. "[NEWLINE][NEWLINE]";
		end

--		strText = Locale.ConvertTextKey("TXT_KEY_TP_GOLDEN_AGE_PROGRESS", activePlayer:GetGoldenAgeProgressMeter(), activePlayer:GetGoldenAgeProgressThreshold());
		strText = strText..Locale.ConvertTextKey("TXT_KEY_TP_GOLDEN_AGE_PROGRESS", activePlayer:GetGoldenAgeProgressMeter(), activePlayer:GetGoldenAgeProgressThreshold());
--AttilaMod-

		strText = strText .. "[NEWLINE]";
		
		if (iHappiness >= 0) then
			strText = strText .. Locale.ConvertTextKey("TXT_KEY_TP_GOLDEN_AGE_ADDITION", iHappiness);
		else
			strText = strText .. "[COLOR_WARNING_TEXT]" .. Locale.ConvertTextKey("TXT_KEY_TP_GOLDEN_AGE_LOSS", -iHappiness) .. "[ENDCOLOR]";
		end
	end
	
	strText = strText .. "[NEWLINE][NEWLINE]";
	strText = strText ..  Locale.ConvertTextKey("TXT_KEY_TP_GOLDEN_AGE_EFFECT");
	
	tipControlTable.TooltipLabel:SetText(Game.RemoveExtraNewlines(strText));
	tipControlTable.TopPanelMouseover:SetHide(false);
    
    -- Autosize tooltip
    tipControlTable.TopPanelMouseover:DoAutoSize();
	
end

-- Culture Tooltip
function CultureTipHandler( control )
	if (Game.IsOption(GameOptionTypes.GAMEOPTION_NO_POLICIES)) then
		strText = Locale.ConvertTextKey("TXT_KEY_TOP_PANEL_POLICIES_OFF_TOOLTIP");
		tipControlTable.TooltipLabel:SetText( strText );
		tipControlTable.TopPanelMouseover:SetHide(false);	    
	    tipControlTable.TopPanelMouseover:DoAutoSize();
		return;
	end


	local strText = "";
	local activePlayerID = Game.GetActivePlayer();
	local activePlayer = Players[activePlayerID];
	
	local yieldInfo		= GameInfo.Yields.YIELD_CULTURE
	local yieldDesc		= Locale.ConvertTextKey(yieldInfo.Description)
	local yieldIcon		= Locale.ConvertTextKey(yieldInfo.IconString)
	local yieldID		= yieldInfo.ID
	local yieldStored	= activePlayer:GetYieldStored(yieldID);
	local yieldNeeded	= activePlayer:GetYieldNeeded(yieldID);
	local yieldRate		= activePlayer:GetYieldRate(yieldID);
	local yieldTurns	= (yieldRate == 0) and "?" or math.ceil(activePlayer:GetYieldTurns(yieldID));
	
	strText = strText .. Locale.ConvertTextKey("TXT_KEY_YIELD_BREAKDOWN",
		yieldInfo.Color,
		Game.Round(yieldStored, 1),
		Game.Round(yieldNeeded, 1),
		Game.Round(yieldRate, 1),		
		Locale.ConvertTextKey(yieldInfo.IconString),
		Locale.ConvertTextKey(yieldInfo.Description)
	)

	local bFirstEntry = true;
	
	-- Culture for Free
	local iCultureForFree = activePlayer:GetMinYieldRate(YieldTypes.YIELD_CULTURE);
	if iCultureForFree ~= 0 then
		if (bFirstEntry) then
			strText = strText .. "[NEWLINE]";
			bFirstEntry = false;
		end
		strText = strText .. "[NEWLINE]" .. Locale.ConvertTextKey("TXT_KEY_TP_YIELD_FOR_FREE", iCultureForFree, yieldIcon);
	end
	
	-- Culture from Cities
	local iCultureFromCities = 0
	for city in activePlayer:Cities() do
		iCultureFromCities = iCultureFromCities + City_GetYieldRate(city, YieldTypes.YIELD_CULTURE)
	end
	iCultureFromCities = iCultureFromCities - activePlayer:GetFinalCitystateYield(YieldTypes.YIELD_CULTURE)
	if iCultureFromCities ~= 0 then
		if (bFirstEntry) then
			strText = strText .. "[NEWLINE]";
			bFirstEntry = false;
		end
		strText = strText .. "[NEWLINE]" .. Locale.ConvertTextKey("TXT_KEY_TP_YIELD_FROM_CITIES", Game.Round(iCultureFromCities, 1), yieldIcon);
	end
	
	-- Culture from Excess Happiness
	local iCultureFromHappiness = activePlayer:GetJONSCulturePerTurnFromExcessHappiness();
	if (iCultureFromHappiness ~= 0) then
		
		-- Add separator for non-initial entries
		if (bFirstEntry) then
			strText = strText .. "[NEWLINE]";
			bFirstEntry = false;
		end

		strText = strText .. "[NEWLINE]";
		strText = strText .. Locale.ConvertTextKey("TXT_KEY_TP_YIELD_FROM_HAPPINESS", iCultureFromHappiness, yieldIcon);
	end
	
	-- Culture from Minor Civs
	if Civup.ENABLE_DISTRIBUTED_MINOR_CIV_YIELDS == 1 then
		local csYield = activePlayer:GetFinalCitystateYield(yieldID);
		if csYield ~= 0 then
			if bFirstEntry then
				strText = strText .. "[NEWLINE]";
				bFirstEntry = false;
			end
			strText = strText .. "[NEWLINE]" .. Locale.ConvertTextKey("TXT_KEY_TP_YIELD_FROM_MINORS", Game.Round(csYield, 1), yieldIcon);
		end
	elseif activePlayer:GetJONSCulturePerTurnFromMinorCivs() ~= 0 then
		if bFirstEntry then
			strText = strText .. "[NEWLINE]";
			bFirstEntry = false;
		end
		strText = strText .. "[NEWLINE]" .. Locale.ConvertTextKey("TXT_KEY_TP_YIELD_FROM_MINORS", activePlayer:GetJONSCulturePerTurnFromMinorCivs(), yieldIcon);
	end
	
	-- Culture from Religion
	local iCultureFromReligion = activePlayer:GetCulturePerTurnFromReligion();
	if (iCultureFromReligion ~= 0) then
	
		-- Add separator for non-initial entries
		if (bFirstEntry) then
			strText = strText .. "[NEWLINE]";
			bFirstEntry = false;
		end

		strText = strText .. "[NEWLINE]";
		strText = strText .. Locale.ConvertTextKey("TXT_KEY_TP_CULTURE_FROM_RELIGION", iCultureFromReligion);
	end
		
	if (not OptionsManager.IsNoBasicHelp()) then
		strText = strText .. "[NEWLINE][NEWLINE]" .. Locale.ConvertTextKey("TXT_KEY_TP_CULTURE_ACCUMULATED", activePlayer:GetYieldStored(YieldTypes.YIELD_CULTURE));		
		if (activePlayer:GetYieldNeeded(YieldTypes.YIELD_CULTURE) > 0) then
			strText = strText .. "[NEWLINE]" .. Locale.ConvertTextKey("TXT_KEY_TP_CULTURE_NEXT_POLICY", activePlayer:GetYieldNeeded(YieldTypes.YIELD_CULTURE));
		end
		strText = strText .. "[NEWLINE]" .. Locale.ConvertTextKey("TXT_KEY_NEXT_POLICY_TURN_LABEL", yieldTurns);
		strText = strText .. "[NEWLINE]" .. Locale.ConvertTextKey("TXT_KEY_TP_CULTURE_CITY_COST", Game.GetNumCitiesPolicyCostMod());
	end
	
	tipControlTable.TooltipLabel:SetText(Game.RemoveExtraNewlines(strText));
	tipControlTable.TopPanelMouseover:SetHide(false);
    
    -- Autosize tooltip
    tipControlTable.TopPanelMouseover:DoAutoSize();
	
end

-- FaithTooltip
function FaithTipHandler( control )
	if (Game.IsOption(GameOptionTypes.GAMEOPTION_NO_RELIGION)) then
		strText = Locale.ConvertTextKey("TXT_KEY_TOP_PANEL_RELIGION_OFF_TOOLTIP");
		tipControlTable.TooltipLabel:SetText( strText );
		tipControlTable.TopPanelMouseover:SetHide(false);	    
	    tipControlTable.TopPanelMouseover:DoAutoSize();
		return;
	end
	
	
	local strText = "";
	local activePlayerID = Game.GetActivePlayer();
	local activePlayer = Players[activePlayerID];
	
	local yieldInfo		= GameInfo.Yields.YIELD_FAITH
	local yieldDesc		= Locale.ConvertTextKey(yieldInfo.Description)
	local yieldIcon		= Locale.ConvertTextKey(yieldInfo.IconString)
	local yieldID		= yieldInfo.ID
	local yieldStored	= activePlayer:GetYieldStored(yieldID);
	local yieldNeeded	= activePlayer:GetYieldNeeded(yieldID);
	local yieldRate		= activePlayer:GetYieldRate(yieldID);
	local yieldTurns	= (yieldRate == 0) and "?" or math.ceil(activePlayer:GetYieldTurns(yieldID));
	
	strText = strText .. Locale.ConvertTextKey("TXT_KEY_YIELD_BREAKDOWN",
		yieldInfo.Color,
		Game.Round(yieldStored, 1),
		Game.Round(yieldNeeded, 1),
		(yieldNeeded == math.huge) and "-" or Game.Round(yieldRate, 1),		
		Locale.ConvertTextKey(yieldInfo.IconString),
		Locale.ConvertTextKey(yieldInfo.Description)
	)
	
	strText = strText .. "[NEWLINE]";

	-- Yield from Cities
	local iYieldFromCities = 0
	for city in activePlayer:Cities() do
		iYieldFromCities = iYieldFromCities + City_GetYieldRate(city, yieldID)
	end
	if iYieldFromCities ~= 0 then
		strText = strText .. "[NEWLINE]" .. Locale.ConvertTextKey("TXT_KEY_TP_YIELD_FROM_CITIES", Game.Round(iYieldFromCities, 1), yieldIcon);
	end

	-- Yield from Minor Civs
	if Civup.ENABLE_DISTRIBUTED_MINOR_CIV_YIELDS == 1 then
		local csYield = activePlayer:GetFinalCitystateYield(yieldID);
		if csYield ~= 0 then
			strText = strText .. "[NEWLINE]" .. Locale.ConvertTextKey("TXT_KEY_TP_YIELD_FROM_MINORS", Game.Round(csYield, 1), yieldIcon);
		end
	elseif activePlayer:GetFaithPerTurnFromMinorCivs() ~= 0 then
		strText = strText .. "[NEWLINE]" .. Locale.ConvertTextKey("TXT_KEY_TP_YIELD_FROM_MINORS", activePlayer:GetFaithPerTurnFromMinorCivs(), yieldIcon);
	end

	-- Yield from Religion
	local iYieldFromReligion = activePlayer:GetFaithPerTurnFromReligion();
	if (iYieldFromReligion ~= 0) then
		strText = strText .. "[NEWLINE]" .. Locale.ConvertTextKey("TXT_KEY_TP_FAITH_FROM_RELIGION", iYieldFromReligion);
	end
	
	if iYieldFromCities ~= 0 or iYieldFromMinorCivs ~= 0 or iYieldFromReligion ~= 0 then
		strText = strText .. "[NEWLINE]";
	end

	strText = strText .. "[NEWLINE]";

	--if not OptionsManager.IsNoBasicHelp() then
		if (activePlayer:HasCreatedPantheon()) then
			if (Game.GetNumReligionsStillToFound() > 0 or activePlayer:HasCreatedReligion()) then
				strText = strText .. Locale.ConvertTextKey("TXT_KEY_TP_FAITH_NEXT_PROPHET", activePlayer:GetMinimumFaithNextGreatProphet());
				strText = strText .. "[NEWLINE]";
			end
		else
			if (activePlayer:CanCreatePantheon(false)) then
				strText = strText .. Locale.ConvertTextKey("TXT_KEY_TP_FAITH_NEXT_PANTHEON", Game.GetMinimumFaithNextPantheon());
				strText = strText .. "[NEWLINE]";
			else
				strText = strText .. Locale.ConvertTextKey("TXT_KEY_TP_FAITH_PANTHEONS_LOCKED");
				strText = strText .. "[NEWLINE]";
			end
		end
		strText = strText .. "[NEWLINE]";	
	--end

	if (Game.GetNumReligionsStillToFound() < 0) then
		strText = strText .. Locale.ConvertTextKey("TXT_KEY_TP_FAITH_RELIGIONS_LEFT", 0);
	else
		strText = strText .. Locale.ConvertTextKey("TXT_KEY_TP_FAITH_RELIGIONS_LEFT", Game.GetNumReligionsStillToFound());
	end
	
	if (activePlayer:GetCurrentEra() >= GameInfo.Eras["ERA_INDUSTRIAL"].ID) then
		local bAnyFound = false;
		strText = strText .. "[NEWLINE]";		
		strText = strText .. "[NEWLINE]";		
		strText = strText .. Locale.ConvertTextKey("TXT_KEY_TP_FAITH_NEXT_GREAT_PERSON", activePlayer:GetMinimumFaithNextGreatProphet());	
		for info in GameInfo.Units{Special = "SPECIALUNIT_PEOPLE"} do
			if (info.ID == GameInfo.Units["UNIT_MERCHANT"].ID and activePlayer:IsPolicyBranchUnlocked(GameInfo.PolicyBranchTypes["POLICY_BRANCH_COMMERCE"].ID) and not activePlayer:IsPolicyBranchBlocked(GameInfo.PolicyBranchTypes["POLICY_BRANCH_COMMERCE"].ID)) then	
				strText = strText .. "[NEWLINE]";
				strText = strText .. "[ICON_BULLET]" .. Locale.ConvertTextKey(info.Description);
				bAnyFound = true;
			end
			if (info.ID == GameInfo.Units["UNIT_SCIENTIST"].ID and activePlayer:IsPolicyBranchUnlocked(GameInfo.PolicyBranchTypes["POLICY_BRANCH_RATIONALISM"].ID) and not activePlayer:IsPolicyBranchBlocked(GameInfo.PolicyBranchTypes["POLICY_BRANCH_RATIONALISM"].ID)) then	
				strText = strText .. "[NEWLINE]";
				strText = strText .. "[ICON_BULLET]" .. Locale.ConvertTextKey(info.Description);
				bAnyFound = true;
			end
			if (info.ID == GameInfo.Units["UNIT_ARTIST"].ID and activePlayer:IsPolicyBranchUnlocked(GameInfo.PolicyBranchTypes["POLICY_BRANCH_FREEDOM"].ID) and not activePlayer:IsPolicyBranchBlocked(GameInfo.PolicyBranchTypes["POLICY_BRANCH_FREEDOM"].ID)) then	
				strText = strText .. "[NEWLINE]";
				strText = strText .. "[ICON_BULLET]" .. Locale.ConvertTextKey(info.Description);
				bAnyFound = true;
			end
			if (info.ID == GameInfo.Units["UNIT_GREAT_GENERAL"].ID and activePlayer:IsPolicyBranchUnlocked(GameInfo.PolicyBranchTypes["POLICY_BRANCH_AUTOCRACY"].ID) and not activePlayer:IsPolicyBranchBlocked(GameInfo.PolicyBranchTypes["POLICY_BRANCH_AUTOCRACY"].ID)) then	
				strText = strText .. "[NEWLINE]";
				strText = strText .. "[ICON_BULLET]" .. Locale.ConvertTextKey(info.Description);
				bAnyFound = true;
			end
			if (info.ID == GameInfo.Units["UNIT_GREAT_ADMIRAL"].ID and activePlayer:IsPolicyBranchUnlocked(GameInfo.PolicyBranchTypes["POLICY_BRANCH_AUTOCRACY"].ID) and not activePlayer:IsPolicyBranchBlocked(GameInfo.PolicyBranchTypes["POLICY_BRANCH_AUTOCRACY"].ID)) then	
				strText = strText .. "[NEWLINE]";
				strText = strText .. "[ICON_BULLET]" .. Locale.ConvertTextKey(info.Description);
				bAnyFound = true;
			end
			if (info.ID == GameInfo.Units["UNIT_ENGINEER"].ID and activePlayer:IsPolicyBranchUnlocked(GameInfo.PolicyBranchTypes["POLICY_BRANCH_ORDER"].ID) and not activePlayer:IsPolicyBranchBlocked(GameInfo.PolicyBranchTypes["POLICY_BRANCH_ORDER"].ID)) then	
				strText = strText .. "[NEWLINE]";
				strText = strText .. "[ICON_BULLET]" .. Locale.ConvertTextKey(info.Description);
				bAnyFound = true;
			end
		end
		if (not bAnyFound) then
			strText = strText .. "[NEWLINE]";
			strText = strText .. "[ICON_BULLET]" .. Locale.ConvertTextKey("TXT_KEY_RO_YR_NO_GREAT_PEOPLE");
		end
	end
	

	tipControlTable.TooltipLabel:SetText( strText );
	tipControlTable.TopPanelMouseover:SetHide(false);
    tipControlTable.TopPanelMouseover:DoAutoSize();	
end

-- Resources Tooltip
function ResourcesTipHandler( control )

	local strText = "";
	local activePlayerID = Game.GetActivePlayer();
	local activePlayer = Players[activePlayerID];
	local activeTeam = Teams[activePlayer:GetTeam()];
	local city = UI.GetHeadSelectedCity();
	local bShowResource;
	local strExtraText;
	local strName;
	local tResourceList = {};
	
	for resInfo in GameInfo.Resources() do
		local resID = resInfo.ID;
		local res = activePlayer:GetResourceQuantities(resID)
		strText = "";
		bShowResource = res.IsLuxury;
		
		if res.IsStrategic and activePlayer:HasTech(GameInfoTypes[resInfo.TechReveal]) and activePlayer:HasTech(GameInfoTypes[resInfo.TechCityTrade]) then
			bShowResource = true;
		end
			
		if bShowResource then
			strName			= Locale.ConvertTextKey(resInfo.Description);
			strText			= string.format("%"..((res.Available/10 >= 1) and 2 or 3).."i", res.Available)
			strExtraText	= ""
			
			if res.Tradable > 0 then
				strText = string.format("[COLOR_POSITIVE_TEXT]%s[ENDCOLOR]", strText);
			elseif (res.IsStrategic and res.Available < 0) or (not res.IsStrategic and res.Exported > 0 and res.Available == 0) then
				strText = string.format("[COLOR_WARNING_TEXT]%s[ENDCOLOR]", strText);
			end
			
			strText = strText .. "  " .. resInfo.IconString .. " " .. strName
			
			if res.Imported > 0 then
				strExtraText = (strExtraText=="") and ": " or (strExtraText..", ")
				strExtraText = strExtraText .. Locale.ConvertTextKey("TXT_KEY_RES_IMPORTED", res.Imported)
			end
			if res.Citystates > 0 then
				strExtraText = (strExtraText=="") and ": " or (strExtraText..", ")
				strExtraText = strExtraText .. Locale.ConvertTextKey("TXT_KEY_RES_CITYSTATES", res.Citystates)
			end
			if res.Exported > 0 then
				strExtraText = (strExtraText=="") and ": " or (strExtraText..", ")
				strExtraText = strExtraText .. "[COLOR_WARNING_TEXT]" .. Locale.ConvertTextKey("TXT_KEY_RES_EXPORTED", res.Exported) .. "[ENDCOLOR]"
			end
			if res.Used > 0 and res.IsStrategic then
				strExtraText = (strExtraText=="") and ": " or (strExtraText..", ")
				strExtraText = strExtraText .. "[COLOR_WARNING_TEXT]" .. Locale.ConvertTextKey("TXT_KEY_RES_USED", res.Used) .. "[ENDCOLOR]"
			end
			if res.Tradable > 0 then
				strExtraText = (strExtraText=="") and ": " or (strExtraText..", ")
				strExtraText = strExtraText .. "[COLOR_POSITIVE_TEXT]" .. Locale.ConvertTextKey("TXT_KEY_RES_SURPLUS", res.Tradable) .. "[ENDCOLOR]"
			end
			
			if res.Available == 0 and strExtraText == "" then
				--strText = "[COLOR:192:192:192:255]" .. strText .. "[ENDCOLOR]";
			else
				strText = strText .. strExtraText
				table.insert(tResourceList, {IsStrategic=res.IsStrategic, name=strName, str=strText});
			end			
		end
	end
	
	table.sort(tResourceList, function (a,b)
		if a.IsStrategic ~= b.IsStrategic then
			return a.IsStrategic;
		else
			return a.name < b.name;
		end
	end)

	strText = ""
	bIsCurrentStrategic = false;
	for _,v in ipairs(tResourceList) do
		if bIsCurrentStrategic == true and v.IsStrategic == false then
			strText = strText .. "[NEWLINE]";		
		end
		bIsCurrentStrategic = v.IsStrategic;
		strText = strText .. "[NEWLINE]" .. v.str;
	end
	
	--print(strText);
	
	local tradeText = Locale.ConvertTextKey("TXT_KEY_CLICK_TO_TRADE") .. "[NEWLINE]"
	
	for _, dealInfo in ipairs(activePlayer:GetPossibleDeals()) do
		if dealInfo.num > 0 then
			tradeText = tradeText .. Locale.ConvertTextKey("TXT_KEY_POSSIBLE_DEALS", dealInfo.icon, dealInfo.num, dealInfo.name) .. "[NEWLINE]"
		end
	end
	
	strText = tradeText .. strText
	
	if (strText ~= "") then
		tipControlTable.TopPanelMouseover:SetHide(false);
		tipControlTable.TooltipLabel:SetText(Game.RemoveExtraNewlines(strText));
	else
		tipControlTable.TopPanelMouseover:SetHide(true);
	end
    
    -- Autosize tooltip
    tipControlTable.TopPanelMouseover:DoAutoSize();
	
end


---------------------------------------------------
---------ADDED Update Great People Tooltip---------
---------------------------------------------------

function GreatPeopleTipHandler( control )
	local activePlayer = Players[Game.GetActivePlayer()]
	local strTooltip = ""
	local GPList = GetGPList(activePlayer)
	
	if GPList ~= nil then
		-- Find GP priorities
		local gpPriority = {}
		for _,v in pairs(GPList) do
			if (gpPriority[v.name] == nil) or (gpPriority[v.name] < v.turnsRemaining) then
				gpPriority[v.name] = v.turnsRemaining
			end
		end
		
		-- Sort the GP list
		table.sort(GPList, function (a,b)
			if a.name ~= b.name then
				if gpPriority[a.name] ~= gpPriority[b.name] then
					return gpPriority[a.name] < gpPriority[b.name]
				else
					return a.name < b.name
				end
			else
				if a.turnsRemaining ~= b.turnsRemaining then
					return a.turnsRemaining < b.turnsRemaining
				else
					return a.progress < b.progress
				end
			end
		end)

		if GPList[1] then
			strTooltip = strTooltip .. string.format("%s: %i[ICON_GREAT_PEOPLE]", Locale.ConvertTextKey("TXT_KEY_ADVISOR_COUNSEL_ECONOMIC_NEXT"), GPList[1].threshold)
		end
		
		-- Add each GP in the list to the tooltip
		local currentGP = {name="", cities=0}
		for _,v in ipairs(GPList) do
			if v.name ~= currentGP.name then
				-- New GP entry
				currentGP.name = v.name
				currentGP.Cities = 0
				local strTurns = ""
				if v.turnsRemaining ~= math.huge then
					strTurns = v.turnsRemaining .. " "
					strTurns = strTurns .. Locale.ConvertTextKey(v.turnsRemaining==1 and "TXT_KEY_DO_TURN" or "TXT_KEY_DO_TURNS")
				end
				strTooltip = strTooltip .. "[NEWLINE][NEWLINE]" ..v.icon.. " " ..v.name.. ": " ..strTurns.. " "
			end
			
			-- Add cities to current GP entry
			if currentGP.Cities < (GameDefines.TOOLTIP_MAX_CITIES_PER_GP or 3) then
				local cityName = Locale.ToUpper(Locale.ConvertTextKey(v.city:GetNameKey()))
				cityName = string.sub(cityName, 1, 1) .. string.lower(string.sub(cityName, 2))
				
				strTooltip = strTooltip.."[NEWLINE][ICON_BULLET] "..cityName.." "..v.progress
				if v.perTurn > 0 then
					strTooltip = strTooltip .. " [COLOR_POSITIVE_TEXT]+" ..v.perTurn.. "[ENDCOLOR]"
				else
					strTooltip = strTooltip .. " +" ..v.perTurn
				end
			end
			currentGP.Cities = currentGP.Cities + 1
		end
	end

	-- Add great general
	strTooltip = strTooltip .. "[NEWLINE][NEWLINE][ICON_WAR] "
	strTooltip = strTooltip .. Locale.ConvertTextKey(GameInfo.UnitClasses.UNITCLASS_GREAT_GENERAL.Description)
	strTooltip = strTooltip .. ": " .. activePlayer:GetCombatExperience() .. "/" .. activePlayer:GreatGeneralThreshold()

	-- Remove excess newlines
	strTooltip = string.gsub(strTooltip, "^%[NEWLINE%]+", "")
	strTooltip = string.gsub(strTooltip, "^%[NEWLINE%]+", "")

	tipControlTable.TooltipLabel:SetText(Game.RemoveExtraNewlines(strTooltip))
	tipControlTable.TopPanelMouseover:SetHide(false)
    tipControlTable.TopPanelMouseover:DoAutoSize()
end

--AttilaMod-

-------------------------------------------------
-- On Top Panel mouseover exited
-------------------------------------------------
--function HelpClose()
	---- Hide the help text box
	--Controls.HelpTextBox:SetHide( true );
--end


-- Register Events
Events.SerialEventGameDataDirty.Add(OnTopPanelDirty);
Events.SerialEventTurnTimerDirty.Add(OnTopPanelDirty);
Events.SerialEventCityInfoDirty.Add(OnTopPanelDirty);

-- Update data at initialization
UpdateData();
DoInitTooltips();