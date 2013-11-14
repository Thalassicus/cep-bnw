-------------------------------------------------
-- City State Greeting Popup
-------------------------------------------------
include("IconSupport");
include("TutorialPopupScreen");
include("InfoTooltipInclude");

local m_PopupInfo = nil;
local lastBackgroundImage = "citystatebackgroundculture.dds"

-------------------------------------------------
-------------------------------------------------
function OnPopup( popupInfo )
	
	local bGreeting = popupInfo.Type == ButtonPopupTypes.BUTTONPOPUP_CITY_STATE_GREETING;
	local bMessage = popupInfo.Type == ButtonPopupTypes.BUTTONPOPUP_CITY_STATE_MESSAGE;
	
	if (not bGreeting and not bMessage) then
		return;
	end
	
	m_PopupInfo = popupInfo;	
	
    local iPlayer = popupInfo.Data1;
    local pPlayer = Players[iPlayer];	
	local bAllies = pPlayer:IsAllies(iActivePlayer);
	local bFriends = pPlayer:IsFriends(iActivePlayer);
	
	local strNameKey = pPlayer:GetCivilizationShortDescriptionKey();

	local strTitle = "";
	local strDescription = "";
	
	-- Set Title Icon
	local sMinorCivType = pPlayer:GetMinorCivType();
	local trait = GameInfo.MinorCivilizations[sMinorCivType].MinorCivTrait;
	Controls.TitleIcon:SetTexture(GameInfo.MinorCivTraits[trait].TraitTitleIcon);
	
	-- Set Background Image
	lastBackgroundImage = GameInfo.MinorCivTraits[trait].BackgroundImage;
	Controls.BackgroundImage:SetTexture(lastBackgroundImage);
	
	-- Update colors
	local primaryColor, secondaryColor = pPlayer:GetPlayerColors();
	primaryColor, secondaryColor = secondaryColor, primaryColor;
	local textColor = {x = primaryColor.x, y = primaryColor.y, z = primaryColor.z, w = 1};
	
	civType = pPlayer:GetCivilizationType();
	civInfo = GameInfo.Civilizations[civType];
	
	local iconColor = textColor;
	IconHookup( civInfo.PortraitIndex, 32, civInfo.AlphaIconAtlas, Controls.CivIcon );
	Controls.CivIcon:SetColor(iconColor);
	
	local strShortDescKey = pPlayer:GetCivilizationShortDescriptionKey();
	
	-- Title
	strTitle = Locale.ConvertTextKey("{" .. strShortDescKey.. ":upper}");

	local iActivePlayer = Game.GetActivePlayer();
	
	if (bMessage) then

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
		Controls.StatusIcon:SetTexture(GameInfo.MinorCivTraits[trait].TraitIcon);
		Controls.StatusIconBG:SetTexture(info.row.StatusIcon);
		Controls.StatusMeter:SetTexture(info.row.StatusMeter);
		Controls.StatusMeter:SetPercent(info.value);
		Controls.StatusInfo:SetText(strStatusText);
		Controls.StatusInfo:SetToolTipString(strStatusTT);
		Controls.StatusLabel:SetToolTipString(strStatusTT);
		Controls.StatusIconBG:SetToolTipString(strStatusTT);
		Controls.StatusMeter:SetToolTipString(strStatusTT);
		
		Controls.CityStateMeterThingy:SetHide(false);
	
	-- Greeting popup - don't show status here
	else
		Controls.CityStateMeterThingy:SetHide(true);
	
	end
		
	-- Info on their Trait
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
	
	Controls.TraitInfo:SetText(strTraitText);
	Controls.TraitInfo:SetToolTipString(strTraitTT);
	Controls.TraitLabel:SetToolTipString(strTraitTT);
	
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
	
	Controls.PersonalityInfo:SetText(strPersonalityText);
	Controls.PersonalityInfo:SetToolTipString(strPersonalityTT);
	Controls.PersonalityLabel:SetToolTipString(strPersonalityTT);
	
	-- Allied with anyone?
	local iAlly = pPlayer:GetAlly();
	if (iAlly ~= nil and iAlly ~= -1) then
		if (iAlly ~= Game.GetActivePlayer()) then
			if (Teams[Players[iAlly]:GetTeam()]:IsHasMet(Game.GetActiveTeam())) then
				Controls.AllyInfo:SetText("[COLOR_POSITIVE_TEXT]" .. Locale.ConvertTextKey(Players[iAlly]:GetCivilizationShortDescriptionKey()) .. "[ENDCOLOR]");
			else
				Controls.AllyInfo:SetText("[COLOR_POSITIVE_TEXT]" .. Locale.ConvertTextKey("TXT_KEY_UNMET_PLAYER") .. "[ENDCOLOR]");
			end
		else
			Controls.AllyInfo:SetText("[COLOR_POSITIVE_TEXT]" .. Locale.ConvertTextKey("TXT_KEY_YOU") .. "[ENDCOLOR]");
		end
	else
		Controls.AllyInfo:SetText(Locale.ConvertTextKey("TXT_KEY_CITY_STATE_NOBODY"));
	end
	
	local strAllyTT = Locale.ConvertTextKey("TXT_KEY_CITY_STATE_ALLY_TT");
	Controls.AllyInfo:SetToolTipString(strAllyTT);
	Controls.AllyLabel:SetToolTipString(strAllyTT);
	
	-- Nearby Resources
	
	local pCapital = pPlayer:GetCapitalCity();
	
	local strResourceText = "";
	
	local resourceList = {}
	
	if (pCapital ~= nil) then		
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
						if plotDistance <= iRange and (plotDistance <= iCloseRange or iOwner == iPlayer) then							
							local iResourceType = pTargetPlot:GetResourceType(Game.GetActiveTeam());							
							if iResourceType ~= -1 and Game.GetResourceUsageType(iResourceType) ~= ResourceUsageTypes.RESOURCEUSAGE_BONUS then
								resourceList[iResourceType] = (resourceList[iResourceType] or 0) + pTargetPlot:GetNumResource()
							end
						end
					end					
				end
			end
		end
		
		for resID, resNum in pairs(resourceList) do
			local pResource = GameInfo.Resources[resID];	
			local color = "[COLOR_GREY]"
			local exports = pPlayer:GetResourceExport(resID)
			
			if bAllies then
				if exports == resNum then
					color = "[COLOR_POSITIVE_TEXT]"
				else
					color = "[COLOR_WHITE]"
					resNum = exports .. "/" .. resNum
				end
			elseif pPlayer:GetNumResourceTotal(resID, false) > 0 then
				if pPlayer:GetMinorCivFriendshipWithMajor(iActivePlayer) >= GameDefines.FRIENDSHIP_THRESHOLD_ALLIES then
					color = "[COLOR_NEGATIVE_TEXT]"
				else
					color = "[COLOR_YELLOW]"
				end
			end			
			strResourceText = string.format("%s%s %s%s %s[ENDCOLOR]  ", strResourceText, pResource.IconString, color, resNum, Locale.ConvertTextKey(pResource.Description))
		end
		
		Controls.ResourcesInfo:SetText(strResourceText);
		
		local strResourceTextTT = Locale.ConvertTextKey("TXT_KEY_CITY_STATE_RESOURCES_TT");
		Controls.ResourcesInfo:SetToolTipString(strResourceTextTT);
		Controls.ResourcesLabel:SetToolTipString(strResourceTextTT);

		Controls.ResourcesLabel:SetHide(false);
		Controls.ResourcesInfo:SetHide(false);
		
	else
		Controls.ResourcesLabel:SetHide(true);
		Controls.ResourcesInfo:SetHide(true);
	end

	-- City State saying hi for the first time
	if (bGreeting) then
		
		local iGoldGift = popupInfo.Data2;
		local bFirstMajorCiv = popupInfo.Option1;
		
		-- Info on their Gold gift
		local strGiftString = "";
		
		if (iGoldGift > 0) then
			if (bFirstMajorCiv) then
				strGiftString = Locale.ConvertTextKey("TXT_KEY_CITY_STATE_GIFT_FIRST", iGoldGift);
			else
				strGiftString = Locale.ConvertTextKey("TXT_KEY_CITY_STATE_GIFT_OTHER", iGoldGift);
			end
		end
		
		local strSpeakAgainString = Locale.ConvertTextKey("TXT_KEY_MINOR_SPEAK_AGAIN", strNameKey);
		
		--strDescription = Locale.ConvertTextKey(strBaseString, strNameKey, strDetailsString, strGiftString, strSpeakAgainString);
		strDescription = Locale.ConvertTextKey("TXT_KEY_CITY_STATE_MEETING", strNameKey, strGiftString, strSpeakAgainString);
		
	else
		
		-- Title
		strTitle = Locale.ConvertTextKey("TXT_KEY_CITY_STATE_HAS_MESSAGE", strNameKey);
		strDescription = UI.GetTempString();
		
	end
	
	Controls.TitleLabel:SetText(strTitle);
	Controls.TitleLabel:SetColor(textColor, 0);
	Controls.DescriptionLabel:SetText(strDescription);
	
	UIManager:QueuePopup( ContextPtr, PopupPriority.CityStateGreeting );
end
Events.SerialEventGameMessagePopup.Add( OnPopup );

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

----------------------------------------------------------------        
-- Input processing
----------------------------------------------------------------        
function OnCloseButtonClicked ()
    UIManager:DequeuePopup( ContextPtr );
end
Controls.CloseButton:RegisterCallback( Mouse.eLClick, OnCloseButtonClicked );
Controls.ScreenButton:RegisterCallback( Mouse.eRClick, OnCloseButtonClicked );


-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
function InputHandler( uiMsg, wParam, lParam )
    if uiMsg == KeyEvents.KeyDown then
        if wParam == Keys.VK_ESCAPE or wParam == Keys.VK_RETURN then
            OnCloseButtonClicked();
            return true;
        end
    end
end
ContextPtr:SetInputHandler( InputHandler );


-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
function ShowHideHandler( bIsHide, bInitState )
    if( not bInitState ) then
		Controls.BackgroundImage:UnloadTexture();
        if( not bIsHide ) then
			Controls.BackgroundImage:SetTexture(lastBackgroundImage);
        	UI.incTurnTimerSemaphore();
        	--OpenAdvisorPopup(m_PopupInfo.Type);
        	Events.SerialEventGameMessagePopupShown(m_PopupInfo);
        else
            UI.decTurnTimerSemaphore();
            --CloseAdvisorPopup(m_PopupInfo.Type);
            Events.SerialEventGameMessagePopupProcessed.CallImmediate(m_PopupInfo.Type, 0);
        end
    end
end
ContextPtr:SetShowHideHandler( ShowHideHandler );

----------------------------------------------------------------
-- 'Active' (local human) player has changed
----------------------------------------------------------------
Events.GameplaySetActivePlayer.Add(OnCloseButtonClicked);
