-------------------------------------------------
-- Diplomatic
-------------------------------------------------
include("IconSupport");
include("SupportFunctions");
include("InstanceManager");
include("CityStateStatusHelper.lua");
include("ThalsUtilities.lua");

local m_PlayerTable = Matchmaking.GetPlayerList();
local m_PlayerNames = {};
for i = 1, #m_PlayerTable do
    m_PlayerNames[ m_PlayerTable[i].playerID ] = m_PlayerTable[i].playerName;
end

local g_MajorCivButtonIM = InstanceManager:new( "MajorCivButtonInstance", "DiploButton", Controls.ButtonStack );
local g_MinorCivButtonIM = InstanceManager:new( "MinorCivButtonInstance", "LeaderButton", Controls.MinorButtonStack );
local g_MajorCivTradeRowIMList = {};

local g_iDealDuration = Game.GetDealDuration();

local g_Deal = UI.GetScratchDeal();
local g_iUs = -1; --Game.GetActivePlayer();
local g_pUs = -1;

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
function ShowHideHandler( bIsHide, bInitState )
	g_iUs = Game.GetActivePlayer();
	g_pUs = Players[ g_iUs ];
	
	InitMajorCivList();
	InitMinorCivList();
end
ContextPtr:SetShowHideHandler( ShowHideHandler );

function InitMinorCivList()
	-- Clear buttons
	g_MinorCivButtonIM:ResetInstances();
	
	local iPlayer = Game.GetActivePlayer();
	local pPlayer = Players[ iPlayer ];
	local pTeam = Teams[pPlayer:GetTeam()];
	
    -------------------------------------------------
    -- Look for the CityStates we've met	
    -------------------------------------------------
	local iMinorMetCount = 0;
	local firstCityStateFound = nil;
	for iPlayerLoop = GameDefines.MAX_MAJOR_CIVS, GameDefines.MAX_CIV_PLAYERS-1, 1 do
		
		pOtherPlayer = Players[iPlayerLoop];
		iOtherTeam = pOtherPlayer:GetTeam();
		
		-- Valid player? - Can't be us, and has to be alive
		if (pPlayer:GetTeam() ~= iOtherTeam and pOtherPlayer:IsAlive()) then
			-- Met this player?
			if (pTeam:IsHasMet(iOtherTeam)) then
				if (pOtherPlayer:IsMinorCiv()) then
						iMinorMetCount = iMinorMetCount + 1;
						local controlTable = g_MinorCivButtonIM:GetInstance();
		
						local minorCivType = pOtherPlayer:GetMinorCivType();
						local civInfo = GameInfo.MinorCivilizations[minorCivType];
						
						local strDiploState = "";
				
						if (pTeam:IsAtWar(iOtherTeam)) then
							strDiploState = Locale.ConvertTextKey( "TXT_KEY_DIPLO_MAJOR_CIV_DIPLO_STATE_WAR" )
						end
						
						controlTable.LeaderName:SetText( Locale.ConvertTextKey( civInfo.Description ));
						controlTable.StatusText:SetText( strDiploState);
						
						-- Update colors
						local primaryColor, secondaryColor = pOtherPlayer:GetPlayerColors();
						primaryColor, secondaryColor = secondaryColor, primaryColor;
						local textColor = {x = primaryColor.x, y = primaryColor.y, z = primaryColor.z, w = 1};

						civType = pOtherPlayer:GetCivilizationType();
						civInfo = GameInfo.Civilizations[civType];
		
						local iconColor = textColor;		
						IconHookup( civInfo.PortraitIndex, 32, civInfo.AlphaIconAtlas, controlTable.LeaderPortrait );
						controlTable.LeaderPortrait:SetColor(iconColor);
						
						controlTable.LeaderButton:SetVoid1( iPlayerLoop);
						controlTable.LeaderButton:SetVoid2( pCity );
						controlTable.LeaderButton:RegisterCallback( Mouse.eLClick, MinorSelected );

						PopulateCityStateInfo(iPlayerLoop, controlTable);
						
						controlTable.CityStack:CalculateSize();
						controlTable.CityStack:ReprocessAnchoring();
	
						local buttonY = controlTable.CityStack:GetSizeY();
						controlTable.LeaderButton:SetSizeY(buttonY);
						controlTable.LeaderButtonHL:SetSizeY(buttonY);
				end
			end
		end
	end		

	if(iMinorMetCount > 0) then
		Controls.NoMinorCivs:SetHide(true);
	else
		Controls.NoMinorCivs:SetHide(false);
	end
	
	Controls.MinorButtonStack:CalculateSize();
	Controls.MinorButtonStack:ReprocessAnchoring();
	Controls.MinorCivScrollPanel:CalculateInternalSize();
end

function InitMajorCivList()
	-- Clear buttons
	g_MajorCivButtonIM:ResetInstances();
	
	for i, v in pairs(g_MajorCivTradeRowIMList) do
		v:ResetInstances();
	end
	g_MajorCivTradeRowIMList = {};
	
	local iPlayer = Game.GetActivePlayer();
	local pPlayer = Players[ iPlayer ];
	local pTeam = Teams[pPlayer:GetTeam()];
	local count = 0;
	
    --------------------------------------------------------------------
	-- Loop through all the Majors the active player knows
    --------------------------------------------------------------------
	for iPlayerLoop = 0, GameDefines.MAX_MAJOR_CIVS-1, 1 do
		
		pOtherPlayer = Players[iPlayerLoop];
		iOtherTeam = pOtherPlayer:GetTeam();
		
		-- Valid player? - Can't be us, and has to be alive
		if (iPlayerLoop ~= iPlayer and pOtherPlayer:IsAlive()) then

			-- Met this player?
			if (pTeam:IsHasMet(iOtherTeam)) then
				local controlTable = g_MajorCivButtonIM:GetInstance();
				count = count+1;
					-- Update colors
				local primaryColor, secondaryColor = pOtherPlayer:GetPlayerColors();
				--if pOtherPlayer:IsMinorCiv() then
					--primaryColor, secondaryColor = secondaryColor, primaryColor;
				--end					
				local backgroundColor = {x = secondaryColor.x, y = secondaryColor.y, z = secondaryColor.z, w = 1};
				local textColor = {x = primaryColor.x, y = primaryColor.y, z = primaryColor.z, w = 1};
				
				local civType = pOtherPlayer:GetCivilizationType();
				local civInfo = GameInfo.Civilizations[civType];
				local strCiv = Locale.ConvertTextKey(civInfo.ShortDescription);
				
				local leaderType = pOtherPlayer:GetLeaderType();
				local leaderInfo = GameInfo.Leaders[leaderType];

				controlTable.CivName:SetText(strCiv);

				CivIconHookup( iPlayerLoop, 32, controlTable.CivSymbol, controlTable.CivIconBG, controlTable.CivIconShadow, false, true );

				controlTable.CivIconBG:SetHide(false);
				
				IconHookup( leaderInfo.PortraitIndex, 64, leaderInfo.IconAtlas, controlTable.LeaderPortrait );

				local strDiploState;
				
				if (pTeam:IsAtWar(iOtherTeam)) then
					strDiploState = Locale.ConvertTextKey( "TXT_KEY_DIPLO_MAJOR_CIV_DIPLO_STATE_WAR" )	
				elseif (pOtherPlayer:IsDenouncingPlayer(iPlayer)) then
					strDiploState = Locale.ConvertTextKey( "TXT_KEY_DIPLO_MAJOR_CIV_DIPLO_STATE_DENOUNCING" );	
				else
					local eApproachGuess = pPlayer:GetApproachTowardsUsGuess(iPlayerLoop);
					
					if( eApproachGuess == MajorCivApproachTypes.MAJOR_CIV_APPROACH_WAR ) then
						statusString = Locale.ConvertTextKey( "TXT_KEY_WAR_CAPS" );
					elseif( eApproachGuess == MajorCivApproachTypes.MAJOR_CIV_APPROACH_HOSTILE ) then
						statusString = Locale.ConvertTextKey( "TXT_KEY_DIPLO_MAJOR_CIV_DIPLO_STATE_HOSTILE", leaderInfo.Description  );
					elseif( eApproachGuess == MajorCivApproachTypes.MAJOR_CIV_APPROACH_GUARDED ) then
						statusString = Locale.ConvertTextKey( "TXT_KEY_DIPLO_MAJOR_CIV_DIPLO_STATE_GUARDED", leaderInfo.Description  );
					elseif( eApproachGuess == MajorCivApproachTypes.MAJOR_CIV_APPROACH_AFRAID ) then
						statusString = Locale.ConvertTextKey( "TXT_KEY_DIPLO_MAJOR_CIV_DIPLO_STATE_AFRAID", leaderInfo.Description  );
					elseif( eApproachGuess == MajorCivApproachTypes.MAJOR_CIV_APPROACH_FRIENDLY ) then
						statusString = Locale.ConvertTextKey( "TXT_KEY_DIPLO_MAJOR_CIV_DIPLO_STATE_FRIENDLY", leaderInfo.Description  );
					elseif( eApproachGuess == MajorCivApproachTypes.MAJOR_CIV_APPROACH_NEUTRAL ) then
						statusString = Locale.ConvertTextKey( "TXT_KEY_DIPLO_MAJOR_CIV_DIPLO_STATE_NEUTRAL", leaderInfo.Description );
					end
					
					PopulateTrade(iPlayerLoop, controlTable);
				end
				
				controlTable.DiploState:SetText(strDiploState);
				
				local strScore = pOtherPlayer:GetScore();
				controlTable.Score:SetText(strScore);
				controlTable.Score:SetHide(false);
				
				local textBoxSize = controlTable.LeaderNameStack:GetSizeX() - controlTable.DiploState:GetSizeX() -
									controlTable.Score:GetSizeX() - controlTable.CivIconBG:GetSizeX()- 74;

				
				--if(pOtherPlayer:GetNickName() ~= "" and Game:IsNetworkMultiPlayer()) then
				if(pOtherPlayer:GetNickName() ~= "" and pOtherPlayer:IsHuman()) then
					TruncateString(controlTable.LeaderName, textBoxSize, pOtherPlayer:GetNickName()); 
				else
					controlTable.LeaderName:LocalizeAndSetText( pOtherPlayer:GetNameKey() );
				end
				
				controlTable.DiploButton:SetVoid1( iPlayerLoop ); -- indicates type
				controlTable.DiploButton:RegisterCallback( Mouse.eLClick, LeaderSelected );
				
				controlTable.TradeStack:CalculateSize();
				controlTable.TradeStack:ReprocessAnchoring();
				
				local buttonY = controlTable.TradeStack:GetSizeY();
				controlTable.LeaderNameStack:SetSizeY(buttonY);
				
				controlTable.LeaderButton:CalculateSize();
				controlTable.LeaderButton:ReprocessAnchoring();
				
				buttonY = controlTable.LeaderButton:GetSizeY();
				controlTable.DiploButton:SetSizeY(buttonY);
				controlTable.DiploButtonHL:SetSizeY(buttonY);
			end
		end
	end

	if(count > 0) then
		Controls.NoMajorCivs:SetHide(true);
	else
		Controls.NoMajorCivs:SetHide(false);
	end
	
	Controls.ButtonStack:CalculateSize();
	Controls.ButtonStack:ReprocessAnchoring();
	Controls.MajorCivScrollPanel:CalculateInternalSize();
end

-------------------------------------------------
-- On Leader Selected
-------------------------------------------------
function LeaderSelected( ePlayer )

    if( Players[ePlayer]:IsHuman() ) then
        Events.OpenPlayerDealScreenEvent( ePlayer );
    else
        
        UI.SetRepeatActionPlayer(ePlayer);
        UI.ChangeStartDiploRepeatCount(1);
    	Players[ePlayer]:DoBeginDiploWithHuman();    

	end
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
function MinorSelected (PlayerID) 
	local popupInfo = {
		Type = ButtonPopupTypes.BUTTONPOPUP_CITY_STATE_DIPLO,
		Data1 = PlayerID;
		}
    
	Events.SerialEventGameMessagePopup( popupInfo );
end

function PopulateTrade(iPlayer, pStack)
	local g_MajorCivTradeRowIM = InstanceManager:new( "MajorCivTradeRowInstance", "Row", pStack.TradeStack );
	g_MajorCivTradeRowIMList[iPlayer] = g_MajorCivTradeRowIM;
	
	local iItemToBeChanged = -1;	-- This is -1 because we're not changing anything right now
	local tradeRow = nil;
    ---------------------------------------------------------------------------------- 
    -- pocket Gold
    ---------------------------------------------------------------------------------- 
	-- Removed the negative check, as you can already see this in the diplo trade screen
	-- bGoldTradeAllowed = g_Deal:IsPossibleToTradeItem(iPlayer, g_iUs, TradeableItems.TRADE_ITEM_GOLD, 1);	-- 1 here is 1 Gold, which is the minimum possible
	
	-- if (bGoldTradeAllowed) then
		local iGold = g_Deal:GetGoldAvailable(iPlayer, iItemToBeChanged);
		local strGoldString = Locale.ConvertTextKey("TXT_KEY_DIPLO_GOLD") .." (" .. iGold .. "[ICON_GOLD])";
		tradeRow = AddTrade(strGoldString, tradeRow, g_MajorCivTradeRowIM);
	-- end
	---------------------------------------------------------------------------------- 
    -- pocket Gold Per Turn  
    ---------------------------------------------------------------------------------- 
	-- Removed the negative check, as you can already see this in the diplo trade screen
	-- local bGPTAllowed = g_Deal:IsPossibleToTradeItem(iPlayer, g_iUs, TradeableItems.TRADE_ITEM_GOLD_PER_TURN, 1, g_iDealDuration);	-- 1 here is 1 GPT, which is the minimum possible
	
    -- if (bGPTAllowed) then
		local iGoldPerTurn = Players[iPlayer]:GetYieldRate(YieldTypes.YIELD_GOLD);
		local strGoldString = Locale.ConvertTextKey("TXT_KEY_DIPLO_GOLD_PER_TURN") .. " (" .. iGoldPerTurn .. "[ICON_GOLD])";
		tradeRow = AddTrade(strGoldString, tradeRow, g_MajorCivTradeRowIM);
	-- end
	---------------------------------------------------------------------------------- 
    -- pocket Open Borders
    ---------------------------------------------------------------------------------- 
    bOpenBordersAllowed = g_Deal:IsPossibleToTradeItem(iPlayer, g_iUs, TradeableItems.TRADE_ITEM_OPEN_BORDERS, g_iDealDuration);
    -- Are they not allowed to give OB? (don't have tech, or are already providing it to us)
    if (bOpenBordersAllowed) then
		tradeRow = AddTrade(Locale.ConvertTextKey("TXT_KEY_DIPLO_OPEN_BORDERS"), tradeRow, g_MajorCivTradeRowIM);
	end
	---------------------------------------------------------------------------------- 
    -- pocket Defensive Pact
    ---------------------------------------------------------------------------------- 
    bDefensivePactAllowed = g_Deal:IsPossibleToTradeItem(iPlayer, g_iUs, TradeableItems.TRADE_ITEM_DEFENSIVE_PACT, g_iDealDuration);
    -- Are they not allowed to give DP? (don't have tech, or are already providing it to us)
    if (bDefensivePactAllowed) then
		tradeRow = AddTrade(Locale.ConvertTextKey("TXT_KEY_DIPLO_DEF_PACT"), tradeRow, g_MajorCivTradeRowIM);
    end
    ---------------------------------------------------------------------------------- 
    -- pocket Research Agreement
    ---------------------------------------------------------------------------------- 
    bResearchAgreementAllowed = g_Deal:IsPossibleToTradeItem(iPlayer, g_iUs, TradeableItems.TRADE_ITEM_RESEARCH_AGREEMENT, g_iDealDuration);   
    -- Are they not allowed to give RA? (don't have tech, or are already providing it to us)
    if (bResearchAgreementAllowed) then
    tradeRow = AddTrade(Locale.ConvertTextKey("TXT_KEY_DIPLO_RESCH_AGREEMENT"), tradeRow, g_MajorCivTradeRowIM);
    end
    ---------------------------------------------------------------------------------- 
    -- pocket Trade Agreement
    ---------------------------------------------------------------------------------- 
     bTradeAgreementAllowed = g_Deal:IsPossibleToTradeItem(iPlayer, g_iUs, TradeableItems.TRADE_ITEM_TRADE_AGREEMENT, g_iDealDuration);  
    -- Are they not allowed to give RA? (don't have tech, or are already providing it to us)
    if (bTradeAgreementAllowed) then
    tradeRow = AddTrade(Locale.ConvertTextKey("TXT_KEY_DIPLO_TRADE_AGREEMENT"), tradeRow, g_MajorCivTradeRowIM);
    end
    ---------------------------------------------------------------------------------- 
    -- pocket resources for them
    ---------------------------------------------------------------------------------- 
	local strategicCount = 0;
	local luxuryCount = 0;
	local strStrategic = Locale.ConvertTextKey("TXT_KEY_DIPLO_STRATEGIC_RESOURCES");
	local strLuxury = Locale.ConvertTextKey("TXT_KEY_DIPLO_LUXURY_RESOURCES");
	for i=0, #GameInfo.Resources-1 do
		local bCanTradeResource = g_Deal:IsPossibleToTradeItem(iPlayer, g_iUs, TradeableItems.TRADE_ITEM_RESOURCES, i, 1);	-- 1 here is 1 quanity of the Resource, which is the minimum possible

		if(bCanTradeResource) then
			v = GameInfo.Resources[i];
			local iResourceCount = Players[iPlayer]:GetNumResourceAvailable( i, false );

			if(v.ResourceClassType == "RESOURCECLASS_LUXURY") then
				strLuxury = strLuxury .. " " .. iResourceCount  ..v.IconString ;
				luxuryCount = luxuryCount + 1;
			else
				strStrategic = strStrategic .. " " .. iResourceCount  ..v.IconString;
				strategicCount = strategicCount + 1;
			end
		end
	end
	
	if(strategicCount > 0) then
		tradeRow = AddTrade(strStrategic, tradeRow, g_MajorCivTradeRowIM);
	end
	
	if(luxuryCount > 0) then
		tradeRow = AddTrade(strLuxury, tradeRow, g_MajorCivTradeRowIM);
	end
end

function AddTrade(tradeString, tradeRow, tradeMgr)
	if(tradeRow == nil) then
		tradeRow = tradeMgr:GetInstance();
		tradeRow.Item0:SetText(tradeString);
	else
		tradeRow.Item1:SetText(tradeString);
		tradeRow = nil;
	end	
	return tradeRow;
end

function PopulateCityStateInfo(iPlayer, pStack)
	local pPlayer = Players[iPlayer];
	
	local iActivePlayer = Game.GetActivePlayer();
	local strShortDescKey = pPlayer:GetCivilizationShortDescriptionKey();
	
	-- At war?
	local bWar = Teams[Game.GetActiveTeam()]:IsAtWar(pPlayer:GetTeam());

	-- Status
	local strStatusText = "";
	
	if (pPlayer:IsAllies(iActivePlayer)) then		-- Allies
		strStatusText = Locale.ConvertTextKey("TXT_KEY_ALLIES");
		strStatusText = "[COLOR_POSITIVE_TEXT]" .. strStatusText .. "[ENDCOLOR]";
		
	elseif (pPlayer:IsFriends(iActivePlayer)) then		-- Friends
		strStatusText = Locale.ConvertTextKey("TXT_KEY_FRIENDS");
		strStatusText = "[COLOR_POSITIVE_TEXT]" .. strStatusText .. "[ENDCOLOR]";
		
	elseif (pPlayer:IsMinorPermanentWar(iActiveTeam)) then		-- Permanent War
		strStatusText = Locale.ConvertTextKey("TXT_KEY_PERMANENT_WAR");
		strStatusText = "[COLOR_NEGATIVE_TEXT]" .. strStatusText .. "[ENDCOLOR]";
		
	elseif (pPlayer:IsPeaceBlocked(iActiveTeam)) then		-- Peace blocked by being at war with ally
		strStatusText = Locale.ConvertTextKey("TXT_KEY_PEACE_BLOCKED");
		strStatusText = "[COLOR_NEGATIVE_TEXT]" .. strStatusText .. "[ENDCOLOR]";
		
	elseif (bWar) then		-- War
		strStatusText = Locale.ConvertTextKey("TXT_KEY_WAR");
		strStatusText = "[COLOR_NEGATIVE_TEXT]" .. strStatusText .. "[ENDCOLOR]";
		
	elseif (pPlayer:GetMinorCivFriendshipWithMajor(iActivePlayer) < 0) then		-- Angry
		strStatusText = Locale.ConvertTextKey("TXT_KEY_ANGRY");
		strStatusText = "[COLOR_NEGATIVE_TEXT]" .. strStatusText .. "[ENDCOLOR]";
		
	else		-- Neutral
		strStatusText = Locale.ConvertTextKey("TXT_KEY_CITY_STATE_PERSONALITY_NEUTRAL");
		strStatusText = "[COLOR_POSITIVE_TEXT]" .. strStatusText .. "[ENDCOLOR]";
	end
	
	local strStatusTT = GetCityStateStatus(pPlayer, iActivePlayer, bWar);
	
	-- Open Borders
	if (pPlayer:IsPlayerHasOpenBorders(iActivePlayer)) then
		
		strStatusTT = strStatusTT .. "[NEWLINE][NEWLINE]";
		
		if (pPlayer:IsPlayerHasOpenBordersAutomatically(iActivePlayer)) then
			strStatusTT = strStatusTT .. Locale.ConvertTextKey("TXT_KEY_CSTATE_OPEN_BORDERS_TRAIT");
		else
			strStatusTT = strStatusTT .. Locale.ConvertTextKey("TXT_KEY_CSTATE_OPEN_BORDERS_FRIENDS");
		end
	end
	
	-- Friendship bonuses
	
	local iCultureBonus = pPlayer:GetCurrentCultureBonus(iActivePlayer);
	if (iCultureBonus ~= 0) then
		strStatusTT = strStatusTT .. "[NEWLINE][NEWLINE]";
		strStatusTT = strStatusTT .. Locale.ConvertTextKey("TXT_KEY_CSTATE_CULTURE_BONUS", iCultureBonus);
	end
	
	local iCapitalFoodBonus = pPlayer:GetCurrentCapitalFoodBonus(iActivePlayer) / 100;
	local iOtherCityFoodBonus = pPlayer:GetCurrentOtherCityFoodBonus(iActivePlayer) / 100;
	if (iCapitalFoodBonus ~= 0 or iOtherCityFoodBonus ~= 0) then
		strStatusTT = strStatusTT .. "[NEWLINE][NEWLINE]";
		strStatusTT = strStatusTT .. Locale.ConvertTextKey("TXT_KEY_CSTATE_FOOD_BONUS", iCapitalFoodBonus, iOtherCityFoodBonus);
	end
	
	local iCurrentSpawnEstimate = pPlayer:GetCurrentSpawnEstimate(iActivePlayer);
	if (iCurrentSpawnEstimate ~= 0) then
		strStatusTT = strStatusTT .. "[NEWLINE][NEWLINE]";
		strStatusTT = strStatusTT .. Locale.ConvertTextKey("TXT_KEY_CSTATE_MILITARY_BONUS", iCurrentSpawnEstimate);
	end
	
	local iScienceBonus = pPlayer:GetCurrentScienceFriendshipBonusTimes100(iActivePlayer);
	if (iScienceBonus ~= 0) then
		strStatusTT = strStatusTT .. "[NEWLINE][NEWLINE]";
		strStatusTT = strStatusTT .. Locale.ConvertTextKey("TXT_KEY_CSTATE_SCIENCE_BONUS", iScienceBonus / 100);
	end
	
	-- Resources
	local strExportedResourceText = "";
	
	local iAmount;
	
	for pResource in GameInfo.Resources() do
		iResourceLoop = pResource.ID;
		
		iAmount = pPlayer:GetResourceExport(iResourceLoop);
		
		if (iAmount > 0) then
			
			local pResource = GameInfo.Resources[iResourceLoop];
			
			if (Game.GetResourceUsageType(iResourceLoop) ~= ResourceUsageTypes.RESOURCEUSAGE_BONUS) then
				strExportedResourceText = strExportedResourceText .. pResource.IconString .. " [COLOR_POSITIVE_TEXT]" .. Locale.ConvertTextKey(pResource.Description) .. " (" .. iAmount .. ") [ENDCOLOR]";
			end
		end
	end
	
	if (strExportedResourceText ~= "") then
		if (bAllies) then
			strStatusTT = strStatusTT .. "[NEWLINE][NEWLINE]";
			strStatusTT = strStatusTT .. Locale.ConvertTextKey("TXT_KEY_CSTATE_RESOURCES_RECEIVED", strExportedResourceText);
		end
	end
	
	local info = GetStatusRow(pPlayer:GetMinorCivFriendshipWithMajor(iActivePlayer));
	local sMinorCivType = pPlayer:GetMinorCivType();
	local trait = GameInfo.MinorCivilizations[sMinorCivType].MinorCivTrait;
	pStack.StatusIcon:SetTexture(GameInfo.MinorCivTraits[trait].TraitIcon);
	pStack.StatusIconBG:SetTexture(info.row.StatusIcon);
	pStack.StatusMeter:SetTexture(info.row.StatusMeter);
	pStack.StatusMeter:SetPercent(info.value);
	pStack.StatusIconBG:SetToolTipString(strStatusTT);
	pStack.StatusMeter:SetToolTipString(strStatusTT);
	
	-- Trait
	local strTraitText = "";
	local strTraitTT = "";
	local iTrait = pPlayer:GetMinorCivTrait();
	if (iTrait == MinorCivTraitTypes.MINOR_CIV_TRAIT_CULTURED) then
		strTraitText = Locale.ConvertTextKey("TXT_KEY_CITY_STATE_CULTURED_ADJECTIVE");
		strTraitTT = Locale.ConvertTextKey("TXT_KEY_CITY_STATE_CULTURED_TT");
	elseif (iTrait == MinorCivTraitTypes.MINOR_CIV_TRAIT_MILITARISTIC) then
		strTraitText = Locale.ConvertTextKey("TXT_KEY_CITY_STATE_MILITARISTIC_ADJECTIVE");
		strTraitTT = Locale.ConvertTextKey("TXT_KEY_CITY_STATE_MILITARISTIC_TT");
	elseif (iTrait == MinorCivTraitTypes.MINOR_CIV_TRAIT_MARITIME) then
		strTraitText = Locale.ConvertTextKey("TXT_KEY_CITY_STATE_MARITIME_ADJECTIVE");
		strTraitTT = Locale.ConvertTextKey("TXT_KEY_CITY_STATE_MARITIME_TT");
	end
	
	strTraitText = "[COLOR_POSITIVE_TEXT]" .. strTraitText .. "[ENDCOLOR]";
	
	pStack.TraitInfo:SetText(strTraitText);
	pStack.TraitInfo:SetToolTipString(strTraitTT);
	pStack.TraitLabel:SetToolTipString(strTraitTT);
	
		-- Personality
	local strPersonalityText = "";
	local strPersonalityTT = "";
	local iPersonality = pPlayer:GetPersonality();
	if (iPersonality == MinorCivPersonalityTypes.MINOR_CIV_PERSONALITY_FRIENDLY) then
		strPersonalityText = Locale.ConvertTextKey("TXT_KEY_CITY_STATE_PERSONALITY_FRIENDLY");
		strPersonalityTT = Locale.ConvertTextKey("TXT_KEY_CITY_STATE_PERSONALITY_FRIENDLY_TT");
	elseif (iPersonality == MinorCivPersonalityTypes.MINOR_CIV_PERSONALITY_NEUTRAL) then
		strPersonalityText = Locale.ConvertTextKey("TXT_KEY_CITY_STATE_PERSONALITY_NEUTRAL");
		strPersonalityTT = Locale.ConvertTextKey("TXT_KEY_CITY_STATE_PERSONALITY_NEUTRAL_TT");
	elseif (iPersonality == MinorCivPersonalityTypes.MINOR_CIV_PERSONALITY_HOSTILE) then
		strPersonalityText = Locale.ConvertTextKey("TXT_KEY_CITY_STATE_PERSONALITY_HOSTILE");
		strPersonalityTT = Locale.ConvertTextKey("TXT_KEY_CITY_STATE_PERSONALITY_HOSTILE_TT");
	elseif (iPersonality == MinorCivPersonalityTypes.MINOR_CIV_PERSONALITY_IRRATIONAL) then
		strPersonalityText = Locale.ConvertTextKey("TXT_KEY_CITY_STATE_PERSONALITY_IRRATIONAL");
		strPersonalityTT = Locale.ConvertTextKey("TXT_KEY_CITY_STATE_PERSONALITY_IRRATIONAL_TT");
	end
	
	strPersonalityText = "[COLOR_POSITIVE_TEXT]" .. strPersonalityText .. "[ENDCOLOR]";
	
	pStack.PersonalityInfo:SetText(strPersonalityText);
	pStack.PersonalityInfo:SetToolTipString(strPersonalityTT);
	pStack.PersonalityLabel:SetToolTipString(strPersonalityTT);
	
	-- Allied with anyone?
	local iAlly = pPlayer:GetAlly();
	if (iAlly ~= nil and iAlly ~= -1) then
		if (iAlly ~= iActivePlayer) then
			pStack.AllyInfo:SetText("[COLOR_POSITIVE_TEXT]" .. Locale.ConvertTextKey(Players[iAlly]:GetCivilizationShortDescriptionKey()) .. "[ENDCOLOR]");
		else
			pStack.AllyInfo:SetText("[COLOR_POSITIVE_TEXT]" .. Locale.ConvertTextKey("TXT_KEY_YOU") .. "[ENDCOLOR]");
		end
	else
		pStack.AllyInfo:SetText(Locale.ConvertTextKey("TXT_KEY_CITY_STATE_NOBODY"));
	end
	
	local strAllyTT = Locale.ConvertTextKey("TXT_KEY_CITY_STATE_ALLY_TT");
	pStack.AllyInfo:SetToolTipString(strAllyTT);
	pStack.AllyLabel:SetToolTipString(strAllyTT);

-- Cope: [ PROTECTION ] Find out who's protecting this pCity state
-- Strange Days
	local strProtectors = "";

	for iCivLoop = 0, GameDefines.MAX_CIV_PLAYERS-1, 1 do
		local pOtherCiv = Players[iCivLoop]
		if pOtherCiv:IsAliveCiv() and not pOtherCiv:IsMinorCiv() and pOtherCiv:IsProtectingMinor(iPlayer) then
			local iActiveTeam = Teams[Game.GetActiveTeam()];
			
			if (strProtectors ~= "") then
				strProtectors = strProtectors .. "[NEWLINE]";
			end

			if ( pOtherCiv == Players[iActivePlayer] ) then
				strProtectors = strProtectors .."[COLOR_POSITIVE_TEXT]" .. Locale.ConvertTextKey("TXT_KEY_YOU") .. "[ENDCOLOR]";
			elseif ( iActiveTeam:IsHasMet( pOtherCiv:GetTeam() ) ) then
				strProtectors = strProtectors .."[COLOR_YELLOW]" .. 
								Locale.ConvertTextKey(pOtherCiv:GetCivilizationShortDescriptionKey()) .. "[ENDCOLOR]";
			else
				strProtectors = strProtectors .. "[COLOR_YELLOW]" .. Locale.ConvertTextKey("TXT_KEY_MISC_UNKNOWN") .. "[ENDCOLOR]";
			end

		end
	end
	if (strProtectors == "") then
		strProtectors = Locale.ConvertTextKey("TXT_KEY_CITY_STATE_NOBODY");
	end

	pStack.ProtectorsInfo:SetText(strProtectors);
	local protSizeY = pStack.ProtectorsInfo:GetSizeY();
	pStack.ProtectorsLabel:SetSizeY(protSizeY);
	local strProtectorsTT = Locale.ConvertTextKey("TXT_KEY_MINORCIV_PROTECTED_DESC");
	pStack.ProtectorsInfo:SetToolTipString(strProtectorsTT);
-------------
		-- Nearby Resources
	local pCapital = pPlayer:GetCapitalCity();
	
	local strResourceText = "";
	
	if (pCapital ~= nil) then
		
		local iNumResourcesFound = 0;
		
		local thisX = pCapital:GetX();
		local thisY = pCapital:GetY();
		
		local iRange = 5;
		local iCloseRange = 2;
		
		for iDX = -iRange, iRange, 1 do
			for iDY = -iRange, iRange, 1 do
				local pTargetPlot = Map.GetPlotXY(thisX, thisY, iDX, iDY);
				
				if pTargetPlot ~= nil then
					
					local iOwner = pTargetPlot:GetOwner();
					
					if (iOwner == iPlayer or iOwner == -1) then
						local plotX = pTargetPlot:GetX();
						local plotY = pTargetPlot:GetY();
						local plotDistance = Map.PlotDistance(thisX, thisY, plotX, plotY);
						
						if (plotDistance <= iRange and (plotDistance <= iCloseRange or iOwner == iPlayer)) then
							
							local iResourceType = pTargetPlot:GetResourceType(Game.GetActiveTeam());
							
							if (iResourceType ~= -1) then
								
								if (Game.GetResourceUsageType(iResourceType) ~= ResourceUsageTypes.RESOURCEUSAGE_BONUS) then
									
									-- Add spacing if we already have found an entry
									if (iNumResourcesFound > 0) then
										strResourceText = strResourceText .. ", ";
									end
									
									local pResource = GameInfo.Resources[iResourceType];
									strResourceText = strResourceText .. pResource.IconString .. " [COLOR_POSITIVE_TEXT]" .. Locale.ConvertTextKey(pResource.Description) .. " (" .. pTargetPlot:GetNumResource() .. ") [ENDCOLOR]";
									
									iNumResourcesFound = iNumResourcesFound + 1;
									
								end
							end
						end
					end
					
				end
			end
		end
		
		pStack.ResourcesInfo:SetText(strResourceText);
		local resourceY = pStack.ResourcesInfo:GetSizeY();
		pStack.ResourcesLabel:SetSizeY(resourceY);
		local strResourceTextTT = Locale.ConvertTextKey("TXT_KEY_CITY_STATE_RESOURCES_TT");
		pStack.ResourcesInfo:SetToolTipString(strResourceTextTT);
		pStack.ResourcesLabel:SetToolTipString(strResourceTextTT);
	end
end

----------------------------------------------------------------
----------------------------------------------------------------
function GetStatusRow(status)
	local table = {}
	if(status < GameDefines["FRIENDSHIP_THRESHOLD_NEUTRAL"]) then
		table.row = GameInfo.MinorCivTraits_Status["MINOR_FRIENDSHIP_AT_WAR"];
		table.value = status / GameDefines["MINOR_FRIENDSHIP_AT_WAR"];
	elseif(status < GameDefines["FRIENDSHIP_THRESHOLD_FRIENDS"]) then
		table.row = GameInfo.MinorCivTraits_Status["FRIENDSHIP_THRESHOLD_NEUTRAL"];
		table.value = (status - GameDefines["FRIENDSHIP_THRESHOLD_NEUTRAL"]) / 
					  (GameDefines["FRIENDSHIP_THRESHOLD_FRIENDS"] - GameDefines["FRIENDSHIP_THRESHOLD_NEUTRAL"]);
	elseif(status < GameDefines["FRIENDSHIP_THRESHOLD_ALLIES"]) then
		table.row = GameInfo.MinorCivTraits_Status["FRIENDSHIP_THRESHOLD_FRIENDS"];
		table.value = (status - GameDefines["FRIENDSHIP_THRESHOLD_FRIENDS"]) / 
					  (GameDefines["FRIENDSHIP_THRESHOLD_ALLIES"] - GameDefines["FRIENDSHIP_THRESHOLD_FRIENDS"]);
	else
		table.row = GameInfo.MinorCivTraits_Status["FRIENDSHIP_THRESHOLD_ALLIES"];
		table.value = (status - GameDefines["FRIENDSHIP_THRESHOLD_ALLIES"]) / 
					  (GameDefines["FRIENDSHIP_THRESHOLD_MAX"] - GameDefines["FRIENDSHIP_THRESHOLD_ALLIES"]);
	end
	return table;
end