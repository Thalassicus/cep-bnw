-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- City State Diplo Popup
--
-- Authors: Anton Strenger
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

include( "IconSupport" );
include( "InfoTooltipInclude" );
include( "CityStateStatusHelper" );

local log = Events.LuaLogger:New()
log:SetLevel("WARN")

local g_iMinorCivID = -1;
local g_iMinorCivTeamID = -1;
local m_PopupInfo = nil;
local m_bNewQuestAvailable = false;
local lastBackgroundImage = "citystatebackgroundculture.dds"
local WordWrapOffset = 19;
local WordWrapAnimOffset = 3;

local kiNoAction = 0;
local kiMadePeace = 1;
local kiBulliedGold = 2;
local kiBulliedUnit = 3;
local kiGiftedGold = 4;
local kiPledgedToProtect = 5;
local kiDeclaredWar = 6;
local kiRevokedProtection = 7;
local m_iLastAction = kiNoAction;
local m_iPendingAction = kiNoAction; -- For bullying dialog popups

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- HANDLERS AND HELPERS
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
function SetButtonSize(textControl, buttonControl, animControl, buttonHL)

	--print(textControl:GetText());
	local sizeY = textControl:GetSizeY() + WordWrapOffset;
	buttonControl:SetSizeY(sizeY);
	animControl:SetSizeY(sizeY+WordWrapAnimOffset);
	buttonHL:SetSizeY(sizeY+WordWrapAnimOffset);
end

function UpdateButtonStack()
	Controls.GiveStack:CalculateSize();
    Controls.GiveStack:ReprocessAnchoring();
    
    Controls.TakeStack:CalculateSize();
    Controls.TakeStack:ReprocessAnchoring();
    
    Controls.ButtonStack:CalculateSize();
    Controls.ButtonStack:ReprocessAnchoring();
    
	Controls.ButtonScrollPanel:CalculateInternalSize();
end

function InputHandler( uiMsg, wParam, lParam )
    if uiMsg == KeyEvents.KeyDown then
        if wParam == Keys.VK_ESCAPE or wParam == Keys.VK_RETURN then
			if (Controls.WarConfirm:IsHidden() and Controls.BullyConfirm:IsHidden()) then
	            OnCloseButtonClicked();
			else
				m_iPendingAction = kiNoAction;
				Controls.WarConfirm:SetHide(true);
				Controls.BullyConfirm:SetHide(true);
            	Controls.BGBlock:SetHide(false);
			end
			return true;
        end
    end
end
ContextPtr:SetInputHandler( InputHandler );

function ShowHideHandler( bIsHide, bInitState )

    if( not bInitState ) then
 	   Controls.BackgroundImage:UnloadTexture();
       if( not bIsHide ) then
			Controls.BackgroundImage:SetTexture(lastBackgroundImage);
        	UI.incTurnTimerSemaphore();
        	Events.SerialEventGameMessagePopupShown(m_PopupInfo);
        else
            UI.decTurnTimerSemaphore();
            Events.SerialEventGameMessagePopupProcessed.CallImmediate(m_PopupInfo.Type, 0);
        end
    end
end
ContextPtr:SetShowHideHandler( ShowHideHandler );

-------------------------------------------------
-- 'Active' (local human) player has changed
-------------------------------------------------
Events.GameplaySetActivePlayer.Add(OnCloseButtonClicked);

-------------------------------------------------
-- On Event Received
-------------------------------------------------
function OnEventReceived( popupInfo )
	
	local bGreeting = popupInfo.Type == ButtonPopupTypes.BUTTONPOPUP_CITY_STATE_GREETING;
	local bMessage = popupInfo.Type == ButtonPopupTypes.BUTTONPOPUP_CITY_STATE_MESSAGE;
	local bDiplo = popupInfo.Type == ButtonPopupTypes.BUTTONPOPUP_CITY_STATE_DIPLO;
	
	if(not bMessage and not bDiplo) then
		return;
	end
	
	m_PopupInfo = popupInfo;	
	
    local iPlayer = popupInfo.Data1;
    local pPlayer = Players[iPlayer];
	local iTeam = pPlayer:GetTeam();
	local pTeam = Teams[iTeam];
	
	local iQuestFlags = popupInfo.Data2;
    
    g_iMinorCivID = iPlayer;
    g_iMinorCivTeamID = iTeam;
	
	m_iLastAction = kiNoAction;
	m_iPendingAction = kiNoAction;
	
	if (iQuestFlags == 1) then
		m_bNewQuestAvailable = true;
	else
		m_bNewQuestAvailable = false;
	end
	
	OnDisplay();
	
	UIManager:QueuePopup( ContextPtr, PopupPriority.CityStateDiplo );
end
Events.SerialEventGameMessagePopup.Add( OnEventReceived );

-------------------------------------------------
-- On Game Info Dirty
-------------------------------------------------
function OnGameDataDirty()

	if (ContextPtr:IsHidden()) then
		return;
	end
	
	OnDisplay();
	
end
Events.SerialEventGameDataDirty.Add(OnGameDataDirty);

-------------------------------------------------
-- On Display
-------------------------------------------------
function OnDisplay()
    
	-- print("Displaying City State Diplo Popup");
    
    local activePlayerID = Game.GetActivePlayer();
    local activePlayer = Players[activePlayerID];
    local activeTeamID = Game.GetActiveTeam();
    local activeTeam = Teams[activeTeamID];
    
    local minorCivID = g_iMinorCivID;
    local minorCiv = Players[minorCivID];
	local csTeamID = g_iMinorCivTeamID;
	local csTeam = Teams[csTeamID];
	local sMinorCivType = minorCiv:GetMinorCivType();
	
	local strShortDescKey = minorCiv:GetCivilizationShortDescriptionKey();
	
	local bAllies = minorCiv:IsAllies(activePlayerID);
	local bFriends = minorCiv:IsFriends(activePlayerID);
	
	-- At war?
	local bWar = activeTeam:IsAtWar(csTeamID);

	-- Update colors
	local primaryColor, secondaryColor = minorCiv:GetPlayerColors();
	primaryColor, secondaryColor = secondaryColor, primaryColor;
	local textColor = {x = primaryColor.x, y = primaryColor.y, z = primaryColor.z, w = 1};

	-- Title
	strTitle = Locale.ConvertTextKey("{"..minorCiv:GetCivilizationShortDescriptionKey()..":upper}");
	Controls.TitleLabel:SetText(strTitle);
	Controls.TitleLabel:SetColor(textColor, 0);
	
	civType = minorCiv:GetCivilizationType();
	civInfo = GameInfo.Civilizations[civType];

	local trait = GameInfo.MinorCivilizations[sMinorCivType].MinorCivTrait;
	Controls.TitleIcon:SetTexture(GameInfo.MinorCivTraits[trait].TraitTitleIcon);
	
	-- Set Background Image
	lastBackgroundImage = GameInfo.MinorCivTraits[trait].BackgroundImage;
	Controls.BackgroundImage:SetTexture(lastBackgroundImage);
	
	local iconColor = textColor;
	IconHookup( civInfo.PortraitIndex, 32, civInfo.AlphaIconAtlas, Controls.CivIcon );
	Controls.CivIcon:SetColor(iconColor);
	
	local strStatusText = GetCityStateStatusText(activePlayerID, minorCivID);
	local strStatusTT = GetCityStateStatusToolTip(activePlayerID, minorCivID, true);
	Controls.StatusIcon:SetTexture(GameInfo.MinorCivTraits[trait].TraitIcon);
	UpdateCityStateStatusUI(activePlayerID, minorCivID, Controls.PositiveStatusMeter, Controls.NegativeStatusMeter, Controls.StatusMeterMarker, Controls.StatusIconBG);
	Controls.StatusInfo:SetText(strStatusText);
	Controls.StatusInfo:SetToolTipString(strStatusTT);
	Controls.StatusLabel:SetToolTipString(strStatusTT);
	Controls.StatusIconBG:SetToolTipString(strStatusTT);
	Controls.PositiveStatusMeter:SetToolTipString(strStatusTT);
	Controls.NegativeStatusMeter:SetToolTipString(strStatusTT);
	
	-- Trait
	local strTraitText = GetCityStateTraitText(minorCivID);
	local strTraitTT = GetCityStateTraitToolTip(minorCivID);
	
	strTraitText = "[COLOR_POSITIVE_TEXT]" .. strTraitText .. "[ENDCOLOR]";
	
	Controls.TraitInfo:SetText(strTraitText);
	Controls.TraitInfo:SetToolTipString(strTraitTT);
	Controls.TraitLabel:SetToolTipString(strTraitTT);
	
	-- Personality
	local strPersonalityText = "";
	local strPersonalityTT = "";
	local iPersonality = minorCiv:GetPersonality();
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
	
	Controls.PersonalityInfo:SetText(strPersonalityText);
	Controls.PersonalityInfo:SetToolTipString(strPersonalityTT);
	Controls.PersonalityLabel:SetToolTipString(strPersonalityTT);
	
	-- Ally Status
	local allyID = minorCiv:GetAlly();
	local strAllyTT = "";
	local bHideIcon = true;
	local bHideText = true;
	if (allyID ~= nil and allyID ~= -1) then
		local allyInf = minorCiv:GetMinorCivFriendshipWithMajor(allyID);
		local activePlayerInf = minorCiv:GetMinorCivFriendshipWithMajor(activePlayerID);
	
		if (allyID ~= activePlayerID) then
			if (Teams[Players[allyID]:GetTeam()]:IsHasMet(Game.GetActiveTeam())) then
				local iInfUntilAllied = allyInf - activePlayerInf + 1; -- needs to pass up the current ally, not just match
				strAllyTT = Locale.ConvertTextKey("TXT_KEY_CITY_STATE_ALLY_TT", Players[allyID]:GetCivilizationShortDescriptionKey(), iInfUntilAllied);
				bHideIcon = false;
				CivIconHookup(allyID, 32, Controls.AllyIcon, Controls.AllyIconBG, Controls.AllyIconShadow, false, true);
			else
				local iInfUntilAllied = allyInf - activePlayerInf + 1; -- needs to pass up the current ally, not just match
				strAllyTT = Locale.ConvertTextKey("TXT_KEY_CITY_STATE_ALLY_UNKNOWN_TT", iInfUntilAllied);
				bHideIcon = false;
				CivIconHookup(-1, 32, Controls.AllyIcon, Controls.AllyIconBG, Controls.AllyIconShadow, false, true);
			end
		else
			strAllyTT = Locale.ConvertTextKey("TXT_KEY_CITY_STATE_ALLY_ACTIVE_PLAYER_TT");
			bHideText = false;
			Controls.AllyText:SetText("[COLOR_POSITIVE_TEXT]" .. Locale.ConvertTextKey("TXT_KEY_YOU") .. "[ENDCOLOR]");
		end
	else
		local activePlayerInf = minorCiv:GetMinorCivFriendshipWithMajor(activePlayerID);
		local iInfUntilAllied = GameDefines["FRIENDSHIP_THRESHOLD_ALLIES"] - activePlayerInf;
		strAllyTT = Locale.ConvertTextKey("TXT_KEY_CITY_STATE_ALLY_NOBODY_TT", iInfUntilAllied);
		bHideText = false;
		Controls.AllyText:SetText(Locale.ConvertTextKey("TXT_KEY_CITY_STATE_NOBODY"));
	end
	Controls.AllyIcon:SetToolTipString(strAllyTT);
	Controls.AllyIconBG:SetToolTipString(strAllyTT);
	Controls.AllyIconShadow:SetToolTipString(strAllyTT);
	Controls.AllyText:SetToolTipString(strAllyTT);
	Controls.AllyLabel:SetToolTipString(strAllyTT);
	
	Controls.AllyIconContainer:SetHide(bHideIcon);
	Controls.AllyText:SetHide(bHideText);
	
	-- Protected by anyone?
	local strProtectors = "";
	for iCivLoop = 0, GameDefines.MAX_CIV_PLAYERS-1, 1 do
		local pOtherCiv = Players[iCivLoop]
		if pOtherCiv:IsAliveCiv() and not pOtherCiv:IsMinorCiv() and pOtherCiv:IsProtectingMinor(minorCivID) then
			if strProtectors ~= "" then
				strProtectors = strProtectors .. ", ";
			end
			if pOtherCiv == Players[activePlayerID] then
				strProtectors = string.format("%s[COLOR_POSITIVE_TEXT]%s[ENDCOLOR]", strProtectors, Locale.ConvertTextKey("TXT_KEY_YOU"))
			elseif Teams[Game.GetActiveTeam()]:IsHasMet(pOtherCiv:GetTeam()) then
				strProtectors = string.format("%s[COLOR_YELLOW]%s[ENDCOLOR]", strProtectors, Locale.ConvertTextKey(pOtherCiv:GetCivilizationShortDescriptionKey()))
			else
				strProtectors = string.format("%s[COLOR_YELLOW]%s[ENDCOLOR]", strProtectors, Locale.ConvertTextKey("TXT_KEY_MISC_UNKNOWN"))
			end
		end
	end
	if strProtectors == "" then
		strProtectors = Locale.ConvertTextKey("TXT_KEY_CITY_STATE_NOBODY");
	end

	Controls.ProtectorsInfo:SetText(strProtectors);
	Controls.ProtectorsInfo:SetToolTipString(Locale.ConvertTextKey("TXT_KEY_MINORCIV_PROTECTED_DESC"));
	Controls.ProtectorsLabel:SetSizeY(Controls.ProtectorsInfo:GetSizeY());
	
	-- Nearby Resources
	local pCapital = minorCiv:GetCapitalCity();	
	local strResourceText = "";	
	
	if pCapital then
		for resID, resNear in pairs(minorCiv:GetNearbyResources()) do
			local resInfo = GameInfo.Resources[resID];	
			local resImproved = minorCiv:GetResourceExport(resID)
			strResourceText = string.format(
				"%s%s %s%s %s[ENDCOLOR]  ", 
				strResourceText, 
				resInfo.IconString, 
				minorCiv:GetExportColor(resID, resImproved, resNear), 
				(resImproved == resNear) and resImproved or (resImproved .. "/" .. resNear), 
				Locale.ConvertTextKey(resInfo.Description)
			)
		end
		
		if strResourceText == "" then
			strResourceText = " "
		end		
		Controls.ResourcesInfo:SetText(strResourceText);		
		local strResourceTextTT = Locale.ConvertTextKey("TXT_KEY_CITY_STATE_RESOURCES_TT");
		Controls.ResourcesInfo:SetToolTipString(strResourceTextTT);
		Controls.ResourcesLabel:SetToolTipString(strResourceTextTT);
		
		local strYieldText = minorCiv:GetMinorYieldString(false)
		local strYieldTextTT = Locale.ConvertTextKey("TXT_KEY_CITY_STATE_YIELDS_TT");
		if strYieldText == nil or strYieldText == "" then
			strYieldText = "[ICON_HAPPINESS_2]"
		end
		--log:Debug("GetMinorYieldString = '%s'", minorCiv:GetMinorYieldString(false))
		Controls.YieldsInfo:SetText(strYieldText);
		if minorCiv:GetMinorCivFriendshipLevelWithMajor(activePlayerID) > 0 then
			Controls.YieldsInfo:SetToolTipString(minorCiv:GetMinorYieldString(true) or "");
		else
			Controls.YieldsInfo:SetToolTipString(strYieldTextTT);
		end
		
	end

	-- Body text
	local strText;
	
	-- Active Quests
	UpdateActiveQuests();
	
	-- Peace
	if (not bWar) then
		
		-- Were we sent here because we clicked a notification for a new quest?
		if (m_iLastAction == kiNoAction and m_bNewQuestAvailable) then
			strText = Locale.ConvertTextKey("TXT_KEY_CITY_STATE_DIPLO_HELLO_QUEST_MESSAGE");
		
		-- Did we just make peace?
		elseif (m_iLastAction == kiMadePeace) then
			strText = Locale.ConvertTextKey("TXT_KEY_CITY_STATE_DIPLO_PEACE_JUST_MADE");
			
		-- Did we just bully gold?
		elseif (m_iLastAction == kiBulliedGold) then
			strText = Locale.ConvertTextKey("TXT_KEY_CITY_STATE_DIPLO_JUST_BULLIED");
		
		-- Did we just bully a worker?
		elseif (m_iLastAction == kiBulliedUnit) then
			strText = Locale.ConvertTextKey("TXT_KEY_CITY_STATE_DIPLO_JUST_BULLIED_WORKER");
		
		-- Did we just give gold?
		elseif (m_iLastAction == kiGiftedGold) then
			strText = Locale.ConvertTextKey("TXT_KEY_CITY_STATE_DIPLO_JUST_SUPPORTED");
		
		-- Did we just PtP?
		elseif (m_iLastAction == kiPledgedToProtect) then
			strText = Locale.ConvertTextKey("TXT_KEY_CITY_STATE_PLEDGE_RESPONSE");
		
		-- Did we just revoke a PtP?
		elseif (m_iLastAction == kiRevokedProtection) then
			strText = Locale.ConvertTextKey("TXT_KEY_CITY_STATE_DIPLO_JUST_REVOKED_PROTECTION");
		
		-- Normal peaceful hello, with info about active quests
		else
			local iPersonality = minorCiv:GetPersonality();
			
			if (minorCiv:IsProtectedByMajor(activePlayerID)) then
				strText = Locale.ConvertTextKey("TXT_KEY_CITY_STATE_DIPLO_HELLO_PEACE_PROTECTED");
			elseif (iPersonality == MinorCivPersonalityTypes.MINOR_CIV_PERSONALITY_FRIENDLY) then
				strText = Locale.ConvertTextKey("TXT_KEY_CITY_STATE_DIPLO_HELLO_PEACE_FRIENDLY");
			elseif (iPersonality == MinorCivPersonalityTypes.MINOR_CIV_PERSONALITY_NEUTRAL) then
				strText = Locale.ConvertTextKey("TXT_KEY_CITY_STATE_DIPLO_HELLO_PEACE_NEUTRAL");
			elseif (iPersonality == MinorCivPersonalityTypes.MINOR_CIV_PERSONALITY_HOSTILE) then
				strText = Locale.ConvertTextKey("TXT_KEY_CITY_STATE_DIPLO_HELLO_PEACE_HOSTILE");
			elseif (iPersonality == MinorCivPersonalityTypes.MINOR_CIV_PERSONALITY_IRRATIONAL) then
				strText = Locale.ConvertTextKey("TXT_KEY_CITY_STATE_DIPLO_HELLO_PEACE_IRRATIONAL");
			end
		
			local strQuestString = "";
			local strWarString = "";
			
			local iNumPlayersAtWar = 0;
			
			-- Loop through all the Majors the active player knows
			for playerIDLoop = 0, GameDefines.MAX_MAJOR_CIVS-1, 1 do
				
				pOtherPlayer = Players[playerIDLoop];
				iOtherTeam = pOtherPlayer:GetTeam();
				
				-- Don't test war with active player!
				if (playerIDLoop ~= activePlayerID) then
					if (pOtherPlayer:IsAlive()) then
						if (csTeam:IsAtWar(iOtherTeam)) then
							if (minorCiv:IsMinorWarQuestWithMajorActive(playerIDLoop)) then
								if (iNumPlayersAtWar ~= 0) then
									strWarString = strWarString .. ", "
								end
								strWarString = strWarString .. Locale.ConvertTextKey(pOtherPlayer:GetNameKey());
								
								iNumPlayersAtWar = iNumPlayersAtWar + 1;
							end
						end
					end
				end
			end
		end
		
		-- Tell the City State to stop gifting us Units (if they are)
		Controls.NoUnitSpawningButton:SetHide(true);
		--[[
		if (minorCiv:GetMinorCivTrait() == MinorCivTraitTypes.MINOR_CIV_TRAIT_MILITARISTIC) then
			if (bFriends) then
				Controls.NoUnitSpawningButton:SetHide(false);
				
				-- Player has said to turn it off
				local strSpawnText;
				if (minorCiv:IsMinorCivUnitSpawningDisabled(activePlayerID)) then
					strSpawnText = Locale.ConvertTextKey("TXT_KEY_CITY_STATE_TURN_SPAWNING_ON");
				else
					strSpawnText = Locale.ConvertTextKey("TXT_KEY_CITY_STATE_TURN_SPAWNING_OFF");
				end
				
				Controls.NoUnitSpawningLabel:SetText(strSpawnText);
			end
		end
		--]]
		
		Controls.GiveButton:SetHide(false);
		Controls.TakeButton:SetHide(false);
		Controls.PeaceButton:SetHide(true);
		Controls.WarButton:SetHide(false);
		
	-- War
	else
		
		-- Warmongering player
		if (minorCiv:IsPeaceBlocked(activeTeamID)) then
			strText = Locale.ConvertTextKey("TXT_KEY_CITY_STATE_DIPLO_HELLO_WARMONGER");
			Controls.PeaceButton:SetHide(true);
			
		-- Normal War
		else
			strText = Locale.ConvertTextKey("TXT_KEY_CITY_STATE_DIPLO_HELLO_WAR");
			Controls.PeaceButton:SetHide(false);
		end
		
		Controls.GiveButton:SetHide(true);
		Controls.TakeButton:SetHide(true);
		Controls.WarButton:SetHide(true);
		Controls.NoUnitSpawningButton:SetHide(true);
		
	end
	
	-- Pledge to Protect
	local bShowPledgeButton = false;
	local bEnablePledgeButton = false;
	local bShowRevokeButton = false;
	local bEnableRevokeButton = false;
	local strProtectButton = Locale.Lookup("TXT_KEY_POP_CSTATE_PLEDGE_TO_PROTECT");
	local strProtectTT = Locale.Lookup("TXT_KEY_POP_CSTATE_PLEDGE_TT", 10, 10); --antonjs: todo: xml
	local strRevokeProtectButton = Locale.Lookup("TXT_KEY_POP_CSTATE_REVOKE_PROTECTION");
	local strRevokeProtectTT = Locale.Lookup("TXT_KEY_POP_CSTATE_REVOKE_PROTECTION_TT");
	
	if (not bWar) then
		-- PtP in effect
		if (minorCiv:IsProtectedByMajor(activePlayerID)) then
			bShowRevokeButton = true;
			-- Can we revoke it?
			if (minorCiv:CanMajorWithdrawProtection(activePlayerID)) then
				bEnableRevokeButton = true;
			else
				bEnableRevokeButton = false;
				strRevokeProtectButton = "[COLOR_WARNING_TEXT]" .. strRevokeProtectButton .. "[ENDCOLOR]";
				local iTurnsCommitted = (minorCiv:GetTurnLastPledgedProtectionByMajor(activePlayerID) + 10) - Game.GetGameTurn(); --antonjs: todo: xml
				strRevokeProtectTT = strRevokeProtectTT .. Locale.Lookup("TXT_KEY_POP_CSTATE_REVOKE_PROTECTION_DISABLED_COMMITTED_TT", iTurnsCommitted);
			end
		-- No PtP
		else
			bShowPledgeButton = true;
			-- Can we pledge?
			if (minorCiv:CanMajorStartProtection(activePlayerID)) then
				bEnablePledgeButton = true;
			else
				bEnablePledgeButton = false;
				strProtectButton = "[COLOR_WARNING_TEXT]" .. strProtectButton .. "[ENDCOLOR]";
				local iLastTurnPledgeBroken = minorCiv:GetTurnLastPledgeBrokenByMajor(activePlayerID);
				if (iLastTurnPledgeBroken >= 0) then -- (-1) means never happened
					local iTurnsUntilRecovered = (iLastTurnPledgeBroken + 20) - Game.GetGameTurn(); --antonjs: todo: xml
					strProtectTT = strProtectTT .. Locale.Lookup("TXT_KEY_POP_CSTATE_PLEDGE_DISABLED_MISTRUST_TT", iTurnsUntilRecovered);
				else
					local iMinimumInfForPledge = GameDefines["FRIENDSHIP_THRESHOLD_CAN_PLEDGE_TO_PROTECT"];
					strProtectTT = strProtectTT .. Locale.Lookup("TXT_KEY_POP_CSTATE_PLEDGE_DISABLED_INFLUENCE_TT", iMinimumInfForPledge);
				end
			end
		end
	end
	Controls.PledgeAnim:SetHide(not bEnablePledgeButton);
	Controls.PledgeButton:SetHide(not bShowPledgeButton);
	if (bShowPledgeButton) then
		Controls.PledgeLabel:SetText(strProtectButton);
		Controls.PledgeButton:SetToolTipString(strProtectTT);
	end
	Controls.RevokePledgeAnim:SetHide(not bEnableRevokeButton);
	Controls.RevokePledgeButton:SetHide(not bShowRevokeButton);
	if (bShowRevokeButton) then
		Controls.RevokePledgeLabel:SetText(strRevokeProtectButton);
		Controls.RevokePledgeButton:SetToolTipString(strRevokeProtectTT);
	end
	
	if (Game.IsOption(GameOptionTypes.GAMEOPTION_ALWAYS_WAR)) then
		Controls.PeaceButton:SetHide(true);
	end
	if (Game.IsOption(GameOptionTypes.GAMEOPTION_ALWAYS_PEACE)) then
		Controls.WarButton:SetHide(true);
	end
	if (Game.IsOption(GameOptionTypes.GAMEOPTION_NO_CHANGING_WAR_PEACE)) then
		Controls.PeaceButton:SetHide(true);
		Controls.WarButton:SetHide(true);
	end
	
	-- Buyout (Austria UA)
	local iBuyoutCost = minorCiv:GetBuyoutCost(activePlayerID);
	local strButtonLabel = Locale.ConvertTextKey( "TXT_KEY_POP_CSTATE_BUYOUT");
	local strToolTip = Locale.ConvertTextKey( "TXT_KEY_POP_CSTATE_BUYOUT_TT", iBuyoutCost );
	if (minorCiv:CanMajorBuyout(activePlayerID) and not bWar) then
		Controls.BuyoutButton:SetHide(false);
		Controls.BuyoutAnim:SetHide(false);
	elseif (activePlayer:IsAbleToAnnexCityStates() and not bWar) then
		if (minorCiv:GetAlly() == activePlayerID) then
			local iAllianceTurns = minorCiv:GetAlliedTurns();
			strButtonLabel = "[COLOR_WARNING_TEXT]" .. strButtonLabel .. "[ENDCOLOR]";
			strToolTip = Locale.ConvertTextKey("TXT_KEY_POP_CSTATE_BUYOUT_DISABLED_ALLY_TT", GameDefines.MINOR_CIV_BUYOUT_TURNS, iAllianceTurns, iBuyoutCost);
		else
			strButtonLabel = "[COLOR_WARNING_TEXT]" .. strButtonLabel .. "[ENDCOLOR]";
			strToolTip = Locale.ConvertTextKey("TXT_KEY_POP_CSTATE_BUYOUT_DISABLED_TT", GameDefines.MINOR_CIV_BUYOUT_TURNS, iBuyoutCost);
		end
		--antonjs: todo: disable button entirely, in case bWar doesn't update in time for the callback to disallow buyout in wartime
		Controls.BuyoutButton:SetHide(false);
		Controls.BuyoutAnim:SetHide(true);
	else
		Controls.BuyoutButton:SetHide(true);
	end
	Controls.BuyoutLabel:SetText( strButtonLabel )
	Controls.BuyoutButton:SetToolTipString( strToolTip );
	
	Controls.DescriptionLabel:SetText(strText);
	
	SetButtonSize(Controls.PeaceLabel, Controls.PeaceButton, Controls.PeaceAnim, Controls.PeaceButtonHL);
	SetButtonSize(Controls.GiveLabel, Controls.GiveButton, Controls.GiveAnim, Controls.GiveButtonHL);
	SetButtonSize(Controls.TakeLabel, Controls.TakeButton, Controls.TakeAnim, Controls.TakeButtonHL);
	SetButtonSize(Controls.WarLabel, Controls.WarButton, Controls.WarAnim, Controls.WarButtonHL);
	SetButtonSize(Controls.PledgeLabel, Controls.PledgeButton, Controls.PledgeAnim, Controls.PledgeButtonHL);
	SetButtonSize(Controls.RevokePledgeLabel, Controls.RevokePledgeButton, Controls.RevokePledgeAnim, Controls.RevokePledgeButtonHL);
	SetButtonSize(Controls.NoUnitSpawningLabel, Controls.NoUnitSpawningButton, Controls.NoUnitSpawningAnim, Controls.NoUnitSpawningButtonHL);
	SetButtonSize(Controls.BuyoutLabel, Controls.BuyoutButton, Controls.BuyoutAnim, Controls.BuyoutButtonHL);
	
	Controls.GiveStack:SetHide(true);
	Controls.TakeStack:SetHide(true);
	Controls.ButtonStack:SetHide(false);
	
	UpdateButtonStack();
end

function UpdateActiveQuests()
	local activePlayerID = Game.GetActivePlayer();
	local sIconText = GetActiveQuestText(activePlayerID, g_iMinorCivID);
	local sToolTipText = GetActiveQuestToolTip(activePlayerID, g_iMinorCivID);
	
	Controls.QuestInfo:SetText(sIconText);
	Controls.QuestInfo:SetToolTipString(sToolTipText);
	Controls.QuestLabel:SetToolTipString(sToolTipText);
end

-------------------------------------------------
-- On Quest Info Clicked
-------------------------------------------------
function OnQuestInfoClicked()
	local activePlayerID = Game.GetActivePlayer();
	local pMinor = Players[g_iMinorCivID];
	if (pMinor) then
		if (pMinor:IsMinorCivActiveQuestForPlayer(activePlayerID, MinorCivQuestTypes.MINOR_CIV_QUEST_KILL_CAMP)) then
			local iQuestData1 = pMinor:GetQuestData1(activePlayerID, MinorCivQuestTypes.MINOR_CIV_QUEST_KILL_CAMP);
			local iQuestData2 = pMinor:GetQuestData2(activePlayerID, MinorCivQuestTypes.MINOR_CIV_QUEST_KILL_CAMP);
			local pPlot = Map.GetPlot(iQuestData1, iQuestData2);
			if (pPlot) then
				UI.LookAt(pPlot, 0);
				local hex = ToHexFromGrid(Vector2(pPlot:GetX(), pPlot:GetY()));
				Events.GameplayFX(hex.x, hex.y, -1);
			end
		end
	end
end
Controls.QuestInfo:RegisterCallback( Mouse.eLClick, OnQuestInfoClicked );

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- MAIN MENU
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

----------------------------------------------------------------
-- Pledge
----------------------------------------------------------------
function OnPledgeButtonClicked ()
	
	local activePlayerID = Game.GetActivePlayer();
	local pPlayer = Players[g_iMinorCivID];
	
	if (pPlayer:CanMajorStartProtection(activePlayerID)) then
		Game.DoMinorPledgeProtection(Game.GetActivePlayer(), g_iMinorCivID, true);
		m_iLastAction = kiPledgedToProtect;
	end
end
Controls.PledgeButton:RegisterCallback( Mouse.eLClick, OnPledgeButtonClicked );

----------------------------------------------------------------
-- Revoke Pledge
----------------------------------------------------------------
function OnRevokePledgeButtonClicked ()
	
	local activePlayerID = Game.GetActivePlayer();
	local pPlayer = Players[g_iMinorCivID];
	
	if (pPlayer:CanMajorWithdrawProtection(activePlayerID)) then
		Game.DoMinorPledgeProtection(activePlayerID, g_iMinorCivID, false);
		m_iLastAction = kiRevokedProtection;
	end
end
Controls.RevokePledgeButton:RegisterCallback( Mouse.eLClick, OnRevokePledgeButtonClicked );

----------------------------------------------------------------
-- Buyout
----------------------------------------------------------------
function OnBuyoutButtonClicked()
	local activePlayerID = Game.GetActivePlayer();
	local pMinor = Players[g_iMinorCivID];
	
	if (pMinor:CanMajorBuyout(activePlayerID)) then
		UIManager:DequeuePopup( ContextPtr );
		Game.DoMinorBuyout(activePlayerID, g_iMinorCivID);
	end
end
Controls.BuyoutButton:RegisterCallback( Mouse.eLClick, OnBuyoutButtonClicked );


----------------------------------------------------------------
-- War
----------------------------------------------------------------
function OnWarButtonClicked ()

	local bIsProtected = false;
    local warConfirmString = Locale.ConvertTextKey("TXT_KEY_CONFIRM_WAR_PROTECTED_CITY_STATE", Players[g_iMinorCivID]:GetCivilizationShortDescriptionKey());
	
	for playerIDLoop = 0, GameDefines.MAX_MAJOR_CIVS-1, 1 do
			
		pOtherPlayer = Players[playerIDLoop];
			
		-- Don't test protection status with active player!
		if (playerIDLoop ~= Game.GetActivePlayer()) then
			if (pOtherPlayer:IsAlive()) then
				if (pOtherPlayer:IsProtectingMinor(g_iMinorCivID)) then
					if (bIsProtected)then
						warConfirmString = warConfirmString .. ", " .. Locale.ConvertTextKey(Players[playerIDLoop]:GetCivilizationShortDescriptionKey());
					else
						warConfirmString = warConfirmString .. " " .. Locale.ConvertTextKey(Players[playerIDLoop]:GetCivilizationShortDescriptionKey());	
						bIsProtected = true;	
					end		    
				end
			end
		end
	end

	if (not bIsProtected) then
		warConfirmString = Locale.ConvertTextKey("TXT_KEY_CONFIRM_WAR");
	end
	
	Controls.WarConfirmLabel:SetText( warConfirmString );
	Controls.WarConfirm:SetHide(false);
	Controls.BGBlock:SetHide(true);
end
Controls.WarButton:RegisterCallback( Mouse.eLClick, OnWarButtonClicked );

----------------------------------------------------------------
-- Peace
----------------------------------------------------------------
function OnPeaceButtonClicked ()
    
	Network.SendChangeWar(g_iMinorCivTeamID, false);
	m_iLastAction = kiMadePeace;
end
Controls.PeaceButton:RegisterCallback( Mouse.eLClick, OnPeaceButtonClicked );

----------------------------------------------------------------
-- Stop/Start Unit Spawning
----------------------------------------------------------------
function OnStopStartSpawning()
    local pPlayer = Players[g_iMinorCivID];
    local activePlayerID = Game.GetActivePlayer();
	
	local bSpawningDisabled = pPlayer:IsMinorCivUnitSpawningDisabled(activePlayerID);
	
	-- Update the text based on what state we're changing to
	local strSpawnText;
	if (bSpawningDisabled) then
		strSpawnText = Locale.ConvertTextKey("TXT_KEY_CITY_STATE_TURN_SPAWNING_OFF");
	else
		strSpawnText = Locale.ConvertTextKey("TXT_KEY_CITY_STATE_TURN_SPAWNING_ON");
	end
	
	Controls.NoUnitSpawningLabel:SetText(strSpawnText);
    
	Network.SendMinorNoUnitSpawning(g_iMinorCivID, not bSpawningDisabled);
end
Controls.NoUnitSpawningButton:RegisterCallback( Mouse.eLClick, OnStopStartSpawning );

----------------------------------------------------------------
-- Open Give Submenu
----------------------------------------------------------------
function OnGiveButtonClicked ()
	Controls.GiveStack:SetHide(false);
	Controls.TakeStack:SetHide(true);
	Controls.ButtonStack:SetHide(true);
	PopulateGiftChoices();
end
Controls.GiveButton:RegisterCallback( Mouse.eLClick, OnGiveButtonClicked );

----------------------------------------------------------------
-- Open Take Submenu
----------------------------------------------------------------
function OnTakeButtonClicked ()
	Controls.GiveStack:SetHide(true);
	Controls.TakeStack:SetHide(false);
	Controls.ButtonStack:SetHide(true);
	PopulateTakeChoices();
end
Controls.TakeButton:RegisterCallback( Mouse.eLClick, OnTakeButtonClicked );

----------------------------------------------------------------
-- Close
----------------------------------------------------------------
function OnCloseButtonClicked ()
	UIManager:DequeuePopup( ContextPtr );
end
Controls.CloseButton:RegisterCallback( Mouse.eLClick, OnCloseButtonClicked );

----------------------------------------------------------------
-- Find On Map
----------------------------------------------------------------
function OnFindOnMapButtonClicked ()
	local pPlayer = Players[g_iMinorCivID];
	if (pPlayer) then
		local pCity = pPlayer:GetCapitalCity();
		if (pCity) then
			local pPlot = pCity:Plot();
			if (pPlot) then
				UI.LookAt(pPlot, 0);
			end
		end
	end
end
Controls.FindOnMapButton:RegisterCallback( Mouse.eLClick, OnFindOnMapButtonClicked );

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- GIFT MENU
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
local iGoldGiftLarge = GameDefines["MINOR_GOLD_GIFT_LARGE"];
local iGoldGiftMedium = GameDefines["MINOR_GOLD_GIFT_MEDIUM"];
local iGoldGiftSmall = GameDefines["MINOR_GOLD_GIFT_SMALL"];

function PopulateGiftChoices()	
	local pPlayer = Players[g_iMinorCivID];
	
	local activePlayerID = Game.GetActivePlayer();
	local activePlayer = Players[activePlayerID];
	
	if Civup.USING_CSD == 1 then
		Controls.SmallGiftButton:SetHide(true)
		Controls.MediumGiftButton:SetHide(true)
		Controls.LargeGiftButton:SetHide(true)
	else
		-- Small Gold
		local iNumGoldPlayerHas = activePlayer:GetGold();
		
		iGold = iGoldGiftSmall;
		iLowestGold = iGold;
		iFriendshipAmount = pPlayer:GetFriendshipFromGoldGift(activePlayerID, iGold);
		local buttonText = Locale.ConvertTextKey("TXT_KEY_POPUP_MINOR_GOLD_GIFT_AMOUNT", iGold, iFriendshipAmount);
		if (iNumGoldPlayerHas < iGold) then
			buttonText = "[COLOR_WARNING_TEXT]" .. buttonText .. "[ENDCOLOR]";
			Controls.SmallGiftAnim:SetHide(true);
		else
			Controls.SmallGiftAnim:SetHide(false);
		end
		Controls.SmallGift:SetText(buttonText);
		SetButtonSize(Controls.SmallGift, Controls.SmallGiftButton, Controls.SmallGiftAnim, Controls.SmallGiftButtonHL);
		
		-- Medium Gold
		iGold = iGoldGiftMedium;
		iFriendshipAmount = pPlayer:GetFriendshipFromGoldGift(activePlayerID, iGold);
		local buttonText = Locale.ConvertTextKey("TXT_KEY_POPUP_MINOR_GOLD_GIFT_AMOUNT", iGold, iFriendshipAmount);
		if (iNumGoldPlayerHas < iGold) then
			buttonText = "[COLOR_WARNING_TEXT]" .. buttonText .. "[ENDCOLOR]";
			Controls.MediumGiftAnim:SetHide(true);
		else
			Controls.MediumGiftAnim:SetHide(false);
		end
		Controls.MediumGift:SetText(buttonText);
		SetButtonSize(Controls.MediumGift, Controls.MediumGiftButton, Controls.MediumGiftAnim, Controls.MediumGiftButtonHL);
		
		-- Large Gold
		iGold = iGoldGiftLarge;
		iFriendshipAmount = pPlayer:GetFriendshipFromGoldGift(activePlayerID, iGold);
		local buttonText = Locale.ConvertTextKey("TXT_KEY_POPUP_MINOR_GOLD_GIFT_AMOUNT", iGold, iFriendshipAmount);
		if (iNumGoldPlayerHas < iGold) then
			buttonText = "[COLOR_WARNING_TEXT]" .. buttonText .. "[ENDCOLOR]";
			Controls.LargeGiftAnim:SetHide(true);
		else
			Controls.LargeGiftAnim:SetHide(false);
		end
		Controls.LargeGift:SetText(buttonText);
		SetButtonSize(Controls.LargeGift, Controls.LargeGiftButton, Controls.LargeGiftAnim, Controls.LargeGiftButtonHL);
	end
	
	-- Unit
	SetButtonSize(Controls.UnitGift, Controls.UnitGiftButton, Controls.UnitGiftAnim, Controls.UnitGiftButtonHL);
	
	-- Tile Improvement
	-- Only allowed for allies
	iGold = pPlayer:GetGiftTileImprovementCost(activePlayerID);
	local buttonText = Locale.ConvertTextKey("TXT_KEY_POPUP_MINOR_GIFT_TILE_IMPROVEMENT", iGold);
	if (not pPlayer:CanMajorGiftTileImprovement(activePlayerID)) then
		buttonText = "[COLOR_WARNING_TEXT]" .. buttonText .. "[ENDCOLOR]";
		Controls.TileImprovementGiftAnim:SetHide(true);
	else
		Controls.TileImprovementGiftAnim:SetHide(false);
	end
	Controls.TileImprovementGift:SetText(buttonText);
	SetButtonSize(Controls.TileImprovementGift, Controls.TileImprovementGiftButton, Controls.TileImprovementGiftAnim, Controls.TileImprovementGiftButtonHL);
	
	-- Tooltip info
	local iFriendsAmount = GameDefines["FRIENDSHIP_THRESHOLD_FRIENDS"];
	local iAlliesAmount = GameDefines["FRIENDSHIP_THRESHOLD_ALLIES"];
    local iFriendship = pPlayer:GetMinorCivFriendshipWithMajor(activePlayerID);
	local strInfoTT = Locale.ConvertTextKey("TXT_KEY_POP_CSTATE_GOLD_STATUS_TT", iFriendsAmount, iAlliesAmount, iFriendship);
	strInfoTT = strInfoTT .. "[NEWLINE][NEWLINE]";
	strInfoTT = strInfoTT .. Locale.ConvertTextKey("TXT_KEY_POP_CSTATE_GOLD_TT");
	Controls.SmallGiftButton:SetToolTipString(strInfoTT);
	Controls.MediumGiftButton:SetToolTipString(strInfoTT);
	Controls.LargeGiftButton:SetToolTipString(strInfoTT);
	
	UpdateButtonStack();
end

----------------------------------------------------------------
-- Gold Gifts
----------------------------------------------------------------
function OnSmallGold ()
	local activePlayerID = Game.GetActivePlayer();
	local activePlayer = Players[activePlayerID];
	local iNumGoldPlayerHas = activePlayer:GetGold();
	
	if (iNumGoldPlayerHas >= iGoldGiftSmall) then
		Game.DoMinorGoldGift(g_iMinorCivID, iGoldGiftSmall);
		LuaEvents.DirtyYieldCachePlayer(Players[Game.GetActivePlayer()])
		m_iLastAction = kiGiftedGold;
		OnCloseGive();
	end
end
Controls.SmallGiftButton:RegisterCallback( Mouse.eLClick, OnSmallGold );

function OnMediumGold ()
	local activePlayerID = Game.GetActivePlayer();
	local activePlayer = Players[activePlayerID];
	local iNumGoldPlayerHas = activePlayer:GetGold();
	
	if (iNumGoldPlayerHas >= iGoldGiftMedium) then
		Game.DoMinorGoldGift(g_iMinorCivID, iGoldGiftMedium);
		LuaEvents.DirtyYieldCachePlayer(Players[Game.GetActivePlayer()])
		m_iLastAction = kiGiftedGold;
		OnCloseGive();
	end
end
Controls.MediumGiftButton:RegisterCallback( Mouse.eLClick, OnMediumGold );

function OnBigGold ()
	local activePlayerID = Game.GetActivePlayer();
	local activePlayer = Players[activePlayerID];
	local iNumGoldPlayerHas = activePlayer:GetGold();
	
	if (iNumGoldPlayerHas >= iGoldGiftLarge) then
		Game.DoMinorGoldGift(g_iMinorCivID, iGoldGiftLarge);
		LuaEvents.DirtyYieldCachePlayer(Players[Game.GetActivePlayer()])
		m_iLastAction = kiGiftedGold;
		OnCloseGive();
	end
end
Controls.LargeGiftButton:RegisterCallback( Mouse.eLClick, OnBigGold );

----------------------------------------------------------------
-- Gift Unit
----------------------------------------------------------------
function OnGiftUnit()
    UIManager:DequeuePopup( ContextPtr );

	local interfaceModeSelection = InterfaceModeTypes.INTERFACEMODE_GIFT_UNIT;
	
	UI.SetInterfaceMode(interfaceModeSelection);
	UI.SetInterfaceModeValue(g_iMinorCivID);
end
Controls.UnitGiftButton:RegisterCallback( Mouse.eLClick, OnGiftUnit );

----------------------------------------------------------------
-- Gift Improvement
----------------------------------------------------------------
function OnGiftTileImprovement()
	local pMinor = Players[g_iMinorCivID];
	local activePlayerID = Game.GetActivePlayer();
    
    if (pMinor:CanMajorGiftTileImprovement(activePlayerID)) then
		UIManager:DequeuePopup( ContextPtr );

		local interfaceModeSelection = InterfaceModeTypes.INTERFACEMODE_GIFT_TILE_IMPROVEMENT;
		
		UI.SetInterfaceMode(interfaceModeSelection);
		UI.SetInterfaceModeValue(g_iMinorCivID);
	end
end
Controls.TileImprovementGiftButton:RegisterCallback( Mouse.eLClick, OnGiftTileImprovement );

----------------------------------------------------------------
-- Close Give Submenu
----------------------------------------------------------------
function OnCloseGive()
	Controls.GiveStack:SetHide(true);
	Controls.TakeStack:SetHide(true);
	Controls.ButtonStack:SetHide(false);
	UpdateButtonStack();
end
Controls.ExitGiveButton:RegisterCallback( Mouse.eLClick, OnCloseGive );

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- TAKE MENU
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
local iBullyGoldInfluenceLost = (GameDefines["MINOR_FRIENDSHIP_DROP_BULLY_GOLD_SUCCESS"] / 100) * -1; -- Since XML value is times 100 for fidelity, and negative
local iBullyUnitInfluenceLost = (GameDefines["MINOR_FRIENDSHIP_DROP_BULLY_WORKER_SUCCESS"] / 100) * -1; -- Since XML value is times 100 for fidelity, and negative
local iBullyUnitMinimumPop = 4; --antonjs: todo: XML

function PopulateTakeChoices()	
	local pPlayer = Players[g_iMinorCivID];
	local activePlayerID = Game.GetActivePlayer();
	local buttonText = "";
	local ttText = "";
	
	local iBullyGold = pPlayer:GetMinorCivBullyGoldAmount(activePlayerID);
	buttonText = Locale.Lookup("TXT_KEY_POPUP_MINOR_BULLY_GOLD_AMOUNT", iBullyGold, iBullyGoldInfluenceLost);
	ttText = Locale.Lookup("TXT_KEY_POP_CSTATE_BULLY_GOLD_TT");
	if (not pPlayer:CanMajorBullyGold(activePlayerID)) then
		buttonText = "[COLOR_WARNING_TEXT]" .. buttonText .. "[ENDCOLOR]";
		Controls.GoldTributeAnim:SetHide(true);
	else
		Controls.GoldTributeAnim:SetHide(false);
	end
	Controls.GoldTributeLabel:SetText(buttonText);
	Controls.GoldTributeButton:SetToolTipString(ttText);
	SetButtonSize(Controls.GoldTributeLabel, Controls.GoldTributeButton, Controls.GoldTributeAnim, Controls.GoldTributeButtonHL);
	
	local sBullyUnit = GameInfo.Units["UNIT_WORKER"].Description; --antonjs: todo: XML or fn
	buttonText = Locale.Lookup("TXT_KEY_POPUP_MINOR_BULLY_UNIT_AMOUNT", sBullyUnit, iBullyUnitInfluenceLost);
	ttText = Locale.Lookup("TXT_KEY_POP_CSTATE_BULLY_UNIT_TT", sBullyUnit, iBullyUnitMinimumPop);
	if (not pPlayer:CanMajorBullyUnit(activePlayerID)) then
		buttonText = "[COLOR_WARNING_TEXT]" .. buttonText .. "[ENDCOLOR]";
		Controls.UnitTributeAnim:SetHide(true);
	else
		Controls.UnitTributeAnim:SetHide(false);
	end
	Controls.UnitTributeLabel:SetText(buttonText);
	Controls.UnitTributeButton:SetToolTipString(ttText);
	SetButtonSize(Controls.UnitTributeLabel, Controls.UnitTributeButton, Controls.UnitTributeAnim, Controls.UnitTributeButtonHL);
	
	UpdateButtonStack();
end

----------------------------------------------------------------
-- Bully confirmation
----------------------------------------------------------------
function OnBullyButtonClicked ()

	local listofProtectingCivs = {};
	for playerIDLoop = 0, GameDefines.MAX_MAJOR_CIVS-1, 1 do
			
		pOtherPlayer = Players[playerIDLoop];
			
		-- Don't test protection status with active player!
		if (playerIDLoop ~= Game.GetActivePlayer()) then
			if (pOtherPlayer:IsAlive()) then
				if (pOtherPlayer:IsProtectingMinor(g_iMinorCivID)) then
					table.insert(listofProtectingCivs, Players[playerIDLoop]:GetCivilizationShortDescriptionKey()); 
				end
			end
		end
	end
	
	local pMinor = Players[g_iMinorCivID];
	local cityStateName = Locale.Lookup(pMinor:GetCivilizationShortDescriptionKey());
	
	local bullyConfirmString = Locale.ConvertTextKey("TXT_KEY_CONFIRM_BULLY", cityStateName);
	local numProtectingCivs = #listofProtectingCivs;
	if(numProtectingCivs > 0) then
		if(numProtectingCivs == 1) then
			bullyConfirmString = Locale.ConvertTextKey("TXT_KEY_CONFIRM_BULLY_PROTECTED_CITY_STATE", cityStateName, listofProtectingCivs[1]);
		else
			local translatedCivs = {};
			for i,v in ipairs(listofProtectingCivs) do
				translatedCivs[i] = Locale.Lookup(v);
			end
		
			bullyConfirmString = Locale.ConvertTextKey("TXT_KEY_CONFIRM_BULLY_PROTECTED_CITY_STATE_MULTIPLE", cityStateName, table.concat(translatedCivs, ", "));
		end
	end
	
	Controls.BullyConfirmLabel:SetText( bullyConfirmString );
	Controls.BullyConfirm:SetHide(false);
	Controls.BGBlock:SetHide(true);
end

----------------------------------------------------------------
-- Take Gold
----------------------------------------------------------------
function OnGoldTributeButtonClicked()
	local pPlayer = Players[g_iMinorCivID];
	local activePlayerID = Game.GetActivePlayer();
	
	if (pPlayer:CanMajorBullyGold(activePlayerID)) then
		m_iPendingAction = kiBulliedGold;
		OnBullyButtonClicked();
		OnCloseTake();
	end
end
Controls.GoldTributeButton:RegisterCallback( Mouse.eLClick, OnGoldTributeButtonClicked );

----------------------------------------------------------------
-- Take Unit
----------------------------------------------------------------
function OnUnitTributeButtonClicked()
	local pPlayer = Players[g_iMinorCivID];
	local activePlayerID = Game.GetActivePlayer();
	
	if (pPlayer:CanMajorBullyUnit(activePlayerID)) then
		m_iPendingAction = kiBulliedUnit;
		OnBullyButtonClicked();
		OnCloseTake();
	end
end
Controls.UnitTributeButton:RegisterCallback( Mouse.eLClick, OnUnitTributeButtonClicked );

----------------------------------------------------------------
-- Close Take Submenu
----------------------------------------------------------------
function OnCloseTake()
	Controls.GiveStack:SetHide(true);
	Controls.TakeStack:SetHide(true);
	Controls.ButtonStack:SetHide(false);
	UpdateButtonStack();
end
Controls.ExitTakeButton:RegisterCallback( Mouse.eLClick, OnCloseTake );

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- BULLY CONFIRMATION POPUP
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
function OnYesBully( )
	local activePlayerID = Game.GetActivePlayer();
	if (m_iPendingAction == kiBulliedGold) then
		Game.DoMinorBullyGold(activePlayerID, g_iMinorCivID);
		m_iPendingAction = kiNoAction;
		m_iLastAction = kiBulliedGold;
	elseif (m_iPendingAction == kiBulliedUnit) then
		Game.DoMinorBullyUnit(activePlayerID, g_iMinorCivID);
		m_iPendingAction = kiNoAction;
		m_iLastAction = kiBulliedUnit;
	else
		print("Scripting error - Selected Yes for bully confrirmation dialog, but invalid PendingAction type");
	end
	LuaEvents.DirtyYieldCachePlayer(Players[Game.GetActivePlayer()])

	Controls.BullyConfirm:SetHide(true);
	Controls.BGBlock:SetHide(false);
    UIManager:DequeuePopup( ContextPtr );
end
Controls.YesBully:RegisterCallback( Mouse.eLClick, OnYesBully );

function OnNoBully( )
	Controls.BullyConfirm:SetHide(true);
	Controls.BGBlock:SetHide(false);
end
Controls.NoBully:RegisterCallback( Mouse.eLClick, OnNoBully );


-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- WAR CONFIRMATION POPUP
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
function OnYesWar( )
	Controls.WarConfirm:SetHide(true);
	Controls.BGBlock:SetHide(false);
	
    UIManager:DequeuePopup( ContextPtr );
    
	Network.SendChangeWar(g_iMinorCivTeamID, true);
	LuaEvents.DirtyYieldCachePlayer(Players[Game.GetActivePlayer()])
end
Controls.YesWar:RegisterCallback( Mouse.eLClick, OnYesWar );

function OnNoWar( )
	Controls.WarConfirm:SetHide(true);
	Controls.BGBlock:SetHide(false);
end
Controls.NoWar:RegisterCallback( Mouse.eLClick, OnNoWar );
