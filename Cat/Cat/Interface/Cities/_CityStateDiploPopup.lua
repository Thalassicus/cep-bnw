-------------------------------------------------
-- City State Diplo Popup
-------------------------------------------------
include("IconSupport");
include("InfoTooltipInclude");

local g_iMinorCivID = -1;
local g_iMinorCivTeamID = -1;
local m_PopupInfo = nil;
local lastBackgroundImage = "citystatebackgroundculture.dds"

-------------------------------------------------
-- On Display
-------------------------------------------------
function OnEventReceived( popupInfo )
	
	if( popupInfo.Type ~= ButtonPopupTypes.BUTTONPOPUP_CITY_STATE_DIPLO ) then
		return;
	end
	
	m_PopupInfo = popupInfo;	
	
    local iPlayer = popupInfo.Data1;
    local pPlayer = Players[iPlayer];
	local iTeam = pPlayer:GetTeam();
	local pTeam = Teams[iTeam];
    
    g_iMinorCivID = iPlayer;
    g_iMinorCivTeamID = iTeam;
	
	local bForcePeace = false;
	OnDisplay(bForcePeace);
	
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
	
	local bForcePeace = false;
	OnDisplay(bForcePeace);
	
end
Events.SerialEventGameDataDirty.Add(OnGameDataDirty);

-------------------------------------------------
-- On Display
-------------------------------------------------
function OnDisplay(bForcePeace)
    
   -- print("Displaying City State Diplo Popup");
    
    local iActivePlayer = Game.GetActivePlayer();
    local pActivePlayer = Players[iActivePlayer];
    local iActiveTeam = Game.GetActiveTeam();
    local pActiveTeam = Teams[iActiveTeam];
    
    local iPlayer = g_iMinorCivID;
    local pPlayer = Players[iPlayer];
	local iTeam = g_iMinorCivTeamID;
	local pTeam = Teams[iTeam];
	local sMinorCivType = pPlayer:GetMinorCivType();
	local capitalCity = pPlayer:GetCapitalCity()
	
	local strShortDescKey = pPlayer:GetCivilizationShortDescriptionKey();
	
	local bAllies = pPlayer:IsAllies(iActivePlayer);
	local bFriends = pPlayer:IsFriends(iActivePlayer);
	
	-- At war?
	local bWar = pActiveTeam:IsAtWar(iTeam);
	if (bForcePeace) then
		bWar = false;
	end

	-- Update colors
	local primaryColor, secondaryColor = pPlayer:GetPlayerColors();
	primaryColor, secondaryColor = secondaryColor, primaryColor;
	local textColor = {x = primaryColor.x, y = primaryColor.y, z = primaryColor.z, w = 1};

	-- Title
	strTitle = Locale.ConvertTextKey("{"..pPlayer:GetCivilizationShortDescriptionKey()..":upper}");
	Controls.TitleLabel:SetText(strTitle);
	Controls.TitleLabel:SetColor(textColor, 0);
	
	civType = pPlayer:GetCivilizationType();
	civInfo = GameInfo.Civilizations[civType];

	local trait = GameInfo.MinorCivilizations[sMinorCivType].MinorCivTrait;
	Controls.TitleIcon:SetTexture(GameInfo.MinorCivTraits[trait].TraitTitleIcon);
	
	-- Set Background Image
	lastBackgroundImage = GameInfo.MinorCivTraits[trait].BackgroundImage;
	Controls.BackgroundImage:SetTexture(lastBackgroundImage);
	
	local iconColor = textColor;
	IconHookup( civInfo.PortraitIndex, 32, civInfo.AlphaIconAtlas, Controls.CivIcon );
	Controls.CivIcon:SetColor(iconColor);

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
		if (iAlly ~= iActivePlayer) then	
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

	-- Protected by anyone?
	local strProtectors = "";
	for iCivLoop = 0, GameDefines.MAX_CIV_PLAYERS-1, 1 do
		local pOtherCiv = Players[iCivLoop]
		if pOtherCiv:IsAliveCiv() and not pOtherCiv:IsMinorCiv() and pOtherCiv:IsProtectingMinor(iPlayer) then
			if strProtectors ~= "" then
				strProtectors = strProtectors .. ", ";
			end
			if pOtherCiv == Players[iActivePlayer] then
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
		
		if strResourceText == "" then
			strResourceText = " "
		end		
		Controls.ResourcesInfo:SetText(strResourceText);		
		local strResourceTextTT = Locale.ConvertTextKey("TXT_KEY_CITY_STATE_RESOURCES_TT");
		Controls.ResourcesInfo:SetToolTipString(strResourceTextTT);
		Controls.ResourcesLabel:SetToolTipString(strResourceTextTT);
		
		local strYieldTextTT = Locale.ConvertTextKey("TXT_KEY_CITY_STATE_YIELDS_TT");
		Controls.YieldsInfo:SetText(pPlayer:GetMinorYieldString(false) or " ");	
		Controls.YieldsInfo:SetToolTipString(pPlayer:GetMinorYieldString(true) or "");
	end
	

	-- Body text
	local strText;
	
	-- Peace
	if (not bWar) then
		
		-- Did we just make peace?
		if (bForcePeace) then
			strText = Locale.ConvertTextKey("TXT_KEY_CITY_STATE_DIPLO_PEACE_JUST_MADE");
			
		-- Normal peaceful hello
		else
			local iPersonality = pPlayer:GetPersonality();
			
			if (iPersonality == MinorCivPersonalityTypes.MINOR_CIV_PERSONALITY_FRIENDLY) then
				strText = Locale.ConvertTextKey("TXT_KEY_CITY_STATE_DIPLO_HELLO_PEACE_FRIENDLY");
			elseif (iPersonality == MinorCivPersonalityTypes.MINOR_CIV_PERSONALITY_NEUTRAL) then
				strText = Locale.ConvertTextKey("TXT_KEY_CITY_STATE_DIPLO_HELLO_PEACE_NEUTRAL");
			elseif (iPersonality == MinorCivPersonalityTypes.MINOR_CIV_PERSONALITY_HOSTILE) then
				strText = Locale.ConvertTextKey("TXT_KEY_CITY_STATE_DIPLO_HELLO_PEACE_HOSTILE");
			elseif (iPersonality == MinorCivPersonalityTypes.MINOR_CIV_PERSONALITY_IRRATIONAL) then
				strText = Locale.ConvertTextKey("TXT_KEY_CITY_STATE_DIPLO_HELLO_PEACE_IRRATIONAL");
			end
		end
		
		local strQuestString = "";
		local strWarString = ""
		
		local iNumPlayersAtWar = 0;
		
		-- Loop through all the Majors the active player knows
		for iPlayerLoop = 0, GameDefines.MAX_MAJOR_CIVS-1, 1 do
			
			pOtherPlayer = Players[iPlayerLoop];
			iOtherTeam = pOtherPlayer:GetTeam();
			
			-- Don't test war with active player!
			if (iPlayerLoop ~= iActivePlayer) then
				if (pOtherPlayer:IsAlive()) then
					if (pTeam:IsAtWar(iOtherTeam)) then
						if (pPlayer:IsMinorWarQuestWithMajorActive(iPlayerLoop)) then
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
		
		-- War quest with anyone?
		if (iNumPlayersAtWar > 0) then
			strQuestString = strQuestString .. " " .. Locale.ConvertTextKey("TXT_KEY_CITY_STATE_QUEST_WAR_WITH_PLAYERS", strWarString);
		end
		
		-- Barbarians
		if (pPlayer:GetTurnsSinceThreatenedByBarbarians() >= 0) then
			strQuestString = strQuestString .. " " .. Locale.ConvertTextKey("TXT_KEY_CITY_STATE_QUEST_BARBARIANS");
		end
		
		-- Normal Quests
		local iQuest = pPlayer:GetActiveQuestForPlayer(iActivePlayer);
		local iQuestData1 = pPlayer:GetQuestData1(iActivePlayer);
		local iQuestData2 = pPlayer:GetQuestData2(iActivePlayer);
		
		-- If we're stringing multiple unrelated things together, make the dialogue sound less mechanical
		if (iQuest >= 0) then
			if (strQuestString ~= "") then
				strQuestString = strQuestString .. " " .. Locale.ConvertTextKey("TXT_KEY_CITY_STATE_QUEST_ONE_MORE_THING");
			end
		end
		
		if (iQuest == MinorCivQuestTypes.MINOR_CIV_QUEST_ROUTE) then
			strQuestString = strQuestString .. " " .. Locale.ConvertTextKey("TXT_KEY_CITY_STATE_QUEST_ROUTE");
		elseif (iQuest == MinorCivQuestTypes.MINOR_CIV_QUEST_KILL_CAMP) then
			strQuestString = strQuestString .. " " .. Locale.ConvertTextKey("TXT_KEY_CITY_STATE_QUEST_KILL_CAMP");
		elseif (iQuest == MinorCivQuestTypes.MINOR_CIV_QUEST_CONNECT_RESOURCE) then
			local strResourceName = GameInfo.Resources[iQuestData1].Description;
			strQuestString = strQuestString .. " " .. Locale.ConvertTextKey("TXT_KEY_CITY_STATE_QUEST_CONNECT_RESOURCE", strResourceName);
		elseif (iQuest == MinorCivQuestTypes.MINOR_CIV_QUEST_CONSTRUCT_WONDER) then
			local strWonderName = GameInfo.Buildings[iQuestData1].Description;
			strQuestString = strQuestString .. " " .. Locale.ConvertTextKey("TXT_KEY_CITY_STATE_QUEST_CONSTRUCT_WONDER", strWonderName);
		elseif (iQuest == MinorCivQuestTypes.MINOR_CIV_QUEST_GREAT_PERSON) then
			local strUnitName = GameInfo.Units[iQuestData1].Description;
			strQuestString = strQuestString .. " " .. Locale.ConvertTextKey("TXT_KEY_CITY_STATE_QUEST_GREAT_PERSON", strUnitName);
		elseif (iQuest == MinorCivQuestTypes.MINOR_CIV_QUEST_KILL_CITY_STATE) then
			local strTargetPlayerKey = Players[iQuestData1]:GetNameKey();
			strQuestString = strQuestString .. " " .. Locale.ConvertTextKey("TXT_KEY_CITY_STATE_QUEST_KILL_CITY_STATE", strTargetPlayerKey);
		elseif (iQuest == MinorCivQuestTypes.MINOR_CIV_QUEST_FIND_PLAYER) then
			local strPlayerKey = Players[iQuestData1]:GetCivilizationShortDescriptionKey();
			strQuestString = strQuestString .. " " .. Locale.ConvertTextKey("TXT_KEY_CITY_STATE_QUEST_FIND_PLAYER", strPlayerKey);
		elseif (iQuest == MinorCivQuestTypes.MINOR_CIV_QUEST_FIND_NATURAL_WONDER) then
			strQuestString = strQuestString .. " " .. Locale.ConvertTextKey("TXT_KEY_CITY_STATE_QUEST_FIND_NATURAL_WONDER");
		end
		
		-- Add Quest text (it might be empty)
		strText = strText .. strQuestString;
		
		-- Tell the City State to stop gifting us Units (if they are)
		Controls.NoUnitSpawningButton:SetHide(true);
		--[[
		if (iTrait == MinorCivTraitTypes.MINOR_CIV_TRAIT_MILITARISTIC) then
			if (bFriends) then
				Controls.NoUnitSpawningButton:SetHide(false);
				
				-- Player has said to turn it off
				local strSpawnText;
				if (pPlayer:IsMinorCivUnitSpawningDisabled(iActivePlayer)) then
					strSpawnText = Locale.ConvertTextKey("TXT_KEY_CITY_STATE_TURN_SPAWNING_ON");
				else
					strSpawnText = Locale.ConvertTextKey("TXT_KEY_CITY_STATE_TURN_SPAWNING_OFF");
				end
				
				Controls.NoUnitSpawningLabel:SetText(strSpawnText);
			end
		end
		--]]
		
		-- Improve nearby resources
		if (bAllies) then
			local plotList = pPlayer:GetImprovableResources()
			if plotList then
				local label = Locale.ConvertTextKey("TXT_KEY_POP_CSTATE_IMPROVE_RESOURCES")		
				local cost = Civup.CITYSTATE_RESOURCE_IMPROVEMENT_COST * Game.GetSpeedYieldMod(YieldTypes.YIELD_GOLD)
				if pActivePlayer:GetYieldStored(YieldTypes.YIELD_GOLD) >= cost then
					Controls.ImproveResourcesButton:RegisterCallback( Mouse.eLClick, function()
						Events.AudioPlay2DSound("AS2D_INTERFACE_CITY_SCREEN_PURCHASE")
						pActivePlayer:ChangeYieldStored(YieldTypes.YIELD_GOLD, -1 * cost)
						pPlayer:ImproveResources(plotList)
					end );
				else
					label = "[COLOR_WARNING_TEXT]" .. label .. "[ENDCOLOR]"
				end
				Controls.ImproveResourcesLabel:SetText(label)
				Controls.ImproveResourcesButton:LocalizeAndSetToolTip("TXT_KEY_POP_CSTATE_IMPROVE_RESOURCES_TT", cost)
				Controls.ImproveResourcesButton:SetHide(false)
			else
				Controls.ImproveResourcesButton:SetHide(true)
			end
		else 
			Controls.ImproveResourcesButton:SetHide(true)
		end
		
		Controls.GoldGiftButton:SetHide(Civup.USING_CSD == 1);
		Controls.PeaceButton:SetHide(true);
		Controls.UnitGiftButton:SetHide(false);
		Controls.WarButton:SetHide(false);
		
	-- War
	else
		
		-- Warmongering player
		if (pPlayer:IsPeaceBlocked(iActiveTeam)) then
			strText = Locale.ConvertTextKey("TXT_KEY_CITY_STATE_DIPLO_HELLO_WARMONGER");
			Controls.PeaceButton:SetHide(true);
			
		-- Normal War
		else
			strText = Locale.ConvertTextKey("TXT_KEY_CITY_STATE_DIPLO_HELLO_WAR");
			Controls.PeaceButton:SetHide(false);
		end
		
		Controls.GoldGiftButton:SetHide(true);
		Controls.UnitGiftButton:SetHide(true);
		Controls.WarButton:SetHide(true);
		Controls.NoUnitSpawningButton:SetHide(true);
		Controls.ImproveResourcesButton:SetHide(true);		
	end
	
	-- Must be at least friends to pledge to protect
	-- Already protecting, hide the button
	if (bWar or not bFriends or pActivePlayer:IsProtectingMinor(iPlayer)) then
		Controls.PledgeButton:SetHide(true);
	else
		Controls.PledgeButton:SetHide(false);
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
	
	Controls.DescriptionLabel:SetText(strText);
	
	SetButtonSize(Controls.PeaceLabel, Controls.PeaceButton, Controls.PeaceAnim, Controls.PeaceButtonHL);
	SetButtonSize(Controls.GoldGift, Controls.GoldGiftButton, Controls.GoldGiftAnim, Controls.GoldGiftButtonHL);
	SetButtonSize(Controls.UnitGift, Controls.UnitGiftButton, Controls.UnitGiftAnim, Controls.UnitGiftButtonHL);
	SetButtonSize(Controls.WarLabel, Controls.WarButton, Controls.WarAnim, Controls.WarButtonHL);
	SetButtonSize(Controls.PledgeLabel, Controls.PledgeButton, Controls.PledgeAnim, Controls.PledgeButtonHL);
	SetButtonSize(Controls.NoUnitSpawningLabel, Controls.NoUnitSpawningButton, Controls.NoUnitSpawningAnim, Controls.NoUnitSpawningButtonHL);
	SetButtonSize(Controls.ImproveResourcesLabel, Controls.ImproveResourcesButton, Controls.ImproveResourcesAnim, Controls.ImproveResourcesButtonHL);
	
	
	Controls.GoldGiftStack:SetHide(true);
	Controls.ButtonStack:SetHide(false);
	
	UpdateButtonStack();
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
----------------------------------------------------------------        
-- Input processing
----------------------------------------------------------------        

-------------------------------------------------------------------------------
-- GOLD GIFT
-------------------------------------------------------------------------------
function OnGoldGiftButtonClicked ()
	Controls.GoldGiftStack:SetHide(false);
	Controls.ButtonStack:SetHide(true);
	PopulateGoldGiftChoices();
end
Controls.GoldGiftButton:RegisterCallback( Mouse.eLClick, OnGoldGiftButtonClicked );

-------------------------------------------------------------------------------
-- Close Gift Gold
-------------------------------------------------------------------------------
function OnCloseGoldGift()
	Controls.GoldGiftStack:SetHide(true);
	Controls.ButtonStack:SetHide(false);
	UpdateButtonStack();
	--UpdatePlayerRewardsFromMinorCivs(Players[Game.GetActivePlayer()]);
end
Controls.BackButton:RegisterCallback( Mouse.eLClick, OnCloseGoldGift );

-------------------------------------------------------------------------------
-- GIFT UNIT
-------------------------------------------------------------------------------
function OnGiftUnit()
    UIManager:DequeuePopup( ContextPtr );

	local interfaceModeSelection = InterfaceModeTypes.INTERFACEMODE_GIFT_UNIT;
	UI.SetInterfaceMode(interfaceModeSelection);
	UI.SetInterfaceModeValue(g_iMinorCivID);
end
Controls.UnitGiftButton:RegisterCallback( Mouse.eLClick, OnGiftUnit );


-------------------------------------------------------------------------------
-- STOP/START SPAWNING
-------------------------------------------------------------------------------
function OnStopStartSpawning()
    local pPlayer = Players[g_iMinorCivID];
    local iActivePlayer = Game.GetActivePlayer();
	
	local bSpawningDisabled = pPlayer:IsMinorCivUnitSpawningDisabled(iActivePlayer);
	
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



-------------------------------------------------------------------------------
-- PLEDGE
-------------------------------------------------------------------------------
function OnPledgeButtonClicked ()
	
	local strText;
	
    local pPlayer = Players[g_iMinorCivID];
	local iPersonality = pPlayer:GetPersonality();
	
	if (iPersonality == MinorCivPersonalityTypes.MINOR_CIV_PERSONALITY_HOSTILE) then
		strText = Locale.ConvertTextKey("TXT_KEY_CITY_STATE_PLEDGE_RESPONSE_HOSTILE");
	else
		strText = Locale.ConvertTextKey("TXT_KEY_CITY_STATE_PLEDGE_RESPONSE");
	end
	
	Controls.DescriptionLabel:SetText(strText);
    
	Network.SendPledgeMinorProtection(g_iMinorCivID, true);
	
	Controls.PledgeButton:SetHide(true);
	
end
Controls.PledgeButton:RegisterCallback( Mouse.eLClick, OnPledgeButtonClicked );

-------------------------------------------------------------------------------
-- WAR
-------------------------------------------------------------------------------
function OnWarButtonClicked ()

	local bIsProtected = false;
    local warConfirmString = Locale.ConvertTextKey("TXT_KEY_CONFIRM_WAR_PROTECTED_CITY_STATE", Players[g_iMinorCivID]:GetCivilizationShortDescriptionKey());
	
	for iPlayerLoop = 0, GameDefines.MAX_MAJOR_CIVS-1, 1 do
			
		pOtherPlayer = Players[iPlayerLoop];
			
		-- Don't test protection status with active player!
		if (iPlayerLoop ~= Game.GetActivePlayer()) then
			if (pOtherPlayer:IsAlive()) then
				if (pOtherPlayer:IsProtectingMinor(g_iMinorCivID)) then
					if (bIsProtected)then
						warConfirmString = warConfirmString .. ", " .. Locale.ConvertTextKey(Players[iPlayerLoop]:GetCivilizationShortDescriptionKey());
					else
						warConfirmString = warConfirmString .. " " .. Locale.ConvertTextKey(Players[iPlayerLoop]:GetCivilizationShortDescriptionKey());	
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


-------------------------------------------------------------------------------
-- PEACE
-------------------------------------------------------------------------------
function OnPeaceButtonClicked ()
    
	Network.SendChangeWar(g_iMinorCivTeamID, false);
	
	local bForcePeace = true;
	OnDisplay(bForcePeace)
end
Controls.PeaceButton:RegisterCallback( Mouse.eLClick, OnPeaceButtonClicked );


-------------------------------------------------------------------------------
-- CLOSE BUTTON
-------------------------------------------------------------------------------
function OnCloseButtonClicked ()
	--UpdatePlayerRewardsFromMinorCivs(Players[Game.GetActivePlayer()]);
	UIManager:DequeuePopup( ContextPtr );
end
Controls.CloseButton:RegisterCallback( Mouse.eLClick, OnCloseButtonClicked );


-------------------------------------------------------------------------------
-- VIEW BUTTON
-------------------------------------------------------------------------------
function OnViewButtonClicked ()
	local capitalCity = Players[g_iMinorCivID]:GetCapitalCity()
	if capitalCity then
		UI.LookAt(capitalCity:Plot(), 0)
	end
end
Controls.ViewButton:RegisterCallback( Mouse.eLClick, OnViewButtonClicked );

-------------------------------------------------------------------------------
-- WAR CONFIRMATION POPUP
-------------------------------------------------------------------------------
function OnYes( )
	Controls.WarConfirm:SetHide(true);
	Controls.BGBlock:SetHide(false);
	
    UIManager:DequeuePopup( ContextPtr );
    
	Network.SendChangeWar(g_iMinorCivTeamID, true);
    
	Network.SendPledgeMinorProtection(g_iMinorCivID, false);
end
Controls.Yes:RegisterCallback( Mouse.eLClick, OnYes );

function OnNo( )
	Controls.WarConfirm:SetHide(true);
	Controls.BGBlock:SetHide(false);
end
Controls.No:RegisterCallback( Mouse.eLClick, OnNo );
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
local iGoldGiftLarge = GameDefines["MINOR_GOLD_GIFT_LARGE"];
local iGoldGiftMedium = GameDefines["MINOR_GOLD_GIFT_MEDIUM"];
local iGoldGiftSmall = GameDefines["MINOR_GOLD_GIFT_SMALL"];
local WordWrapOffset = 19;
local WordWrapAnimOffset = 3;
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
function PopulateGoldGiftChoices()	
	local pPlayer = Players[g_iMinorCivID];
	
	local iActivePlayer = Game.GetActivePlayer();
	local pActivePlayer = Players[iActivePlayer];
	
	-- Small Gold
	local iNumGoldPlayerHas = pActivePlayer:GetGold();
	
	iGold = iGoldGiftSmall;
	iLowestGold = iGold;
	iFriendshipAmount = pPlayer:GetFriendshipFromGoldGift(iActivePlayer, iGold);
	local buttonText = Locale.ConvertTextKey("TXT_KEY_POPUP_MINOR_GOLD_GIFT_AMOUNT", iGold, iFriendshipAmount);
	if (iNumGoldPlayerHas < iGold) then
		 buttonText = "[COLOR_WARNING_TEXT]" .. buttonText .. "[ENDCOLOR]";
	end
	Controls.SmallGift:SetText(buttonText);
	SetButtonSize(Controls.SmallGift, Controls.SmallGiftButton, Controls.SmallGiftAnim, Controls.SmallGiftButtonHL);
	
	-- Medium Gold
	iGold = iGoldGiftMedium;
	iFriendshipAmount = pPlayer:GetFriendshipFromGoldGift(iActivePlayer, iGold);
	local buttonText = Locale.ConvertTextKey("TXT_KEY_POPUP_MINOR_GOLD_GIFT_AMOUNT", iGold, iFriendshipAmount);
	if (iNumGoldPlayerHas < iGold) then
		 buttonText = "[COLOR_WARNING_TEXT]" .. buttonText .. "[ENDCOLOR]";
	end
	Controls.MediumGift:SetText(buttonText);
	SetButtonSize(Controls.MediumGift, Controls.MediumGiftButton, Controls.MediumGiftAnim, Controls.MediumGiftButtonHL);
	
	-- Medium Gold
	iGold = iGoldGiftLarge;
	iFriendshipAmount = pPlayer:GetFriendshipFromGoldGift(iActivePlayer, iGold);
	local buttonText = Locale.ConvertTextKey("TXT_KEY_POPUP_MINOR_GOLD_GIFT_AMOUNT", iGold, iFriendshipAmount);
	if (iNumGoldPlayerHas < iGold) then
		 buttonText = "[COLOR_WARNING_TEXT]" .. buttonText .. "[ENDCOLOR]";
	end
	Controls.LargeGift:SetText(buttonText);
	SetButtonSize(Controls.LargeGift, Controls.LargeGiftButton, Controls.LargeGiftAnim, Controls.LargeGiftButtonHL);
	
	-- Tooltip info
	local iFriendsAmount = GameDefines["FRIENDSHIP_THRESHOLD_FRIENDS"];
	local iAlliesAmount = GameDefines["FRIENDSHIP_THRESHOLD_ALLIES"];
    local iFriendship = pPlayer:GetMinorCivFriendshipWithMajor(iActivePlayer);
	local strInfoTT = Locale.ConvertTextKey("TXT_KEY_POP_CSTATE_GOLD_STATUS_TT", iFriendsAmount, iAlliesAmount, iFriendship);
	strInfoTT = strInfoTT .. "[NEWLINE][NEWLINE]";
	strInfoTT = strInfoTT .. Locale.ConvertTextKey("TXT_KEY_POP_CSTATE_GOLD_TT");
	Controls.SmallGiftButton:SetToolTipString(strInfoTT);
	Controls.MediumGiftButton:SetToolTipString(strInfoTT);
	Controls.LargeGiftButton:SetToolTipString(strInfoTT);
	
	UpdateButtonStack();
end
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
function SetButtonSize(textControl, buttonControl, animControl, buttonHL)
	--print(textControl:GetText());
	local sizeY = textControl:GetSizeY() + WordWrapOffset;
	buttonControl:SetSizeY(sizeY);
	animControl:SetSizeY(sizeY+WordWrapAnimOffset);
	buttonHL:SetSizeY(sizeY+WordWrapAnimOffset);
end
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
function OnSmallGold ()
	Game.DoMinorGoldGift(g_iMinorCivID, iGoldGiftSmall);
	Events.AudioPlay2DSound("AS2D_INTERFACE_CITY_SCREEN_PURCHASE")
	OnCloseGoldGift();
end
Controls.SmallGiftButton:RegisterCallback( Mouse.eLClick, OnSmallGold );
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
function OnMediumGold ()
	Game.DoMinorGoldGift(g_iMinorCivID, iGoldGiftMedium);
	Events.AudioPlay2DSound("AS2D_INTERFACE_CITY_SCREEN_PURCHASE")
	OnCloseGoldGift();
end
Controls.MediumGiftButton:RegisterCallback( Mouse.eLClick, OnMediumGold );
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
function OnBigGold ()
	Game.DoMinorGoldGift(g_iMinorCivID, iGoldGiftLarge);
	Events.AudioPlay2DSound("AS2D_INTERFACE_CITY_SCREEN_PURCHASE")
	OnCloseGoldGift();
end
Controls.LargeGiftButton:RegisterCallback( Mouse.eLClick, OnBigGold );
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
function UpdateButtonStack()
	Controls.GoldGiftStack:CalculateSize();
    Controls.GoldGiftStack:ReprocessAnchoring();
    
    Controls.ButtonStack:CalculateSize();
    Controls.ButtonStack:ReprocessAnchoring();
    
	Controls.ButtonScrollPanel:CalculateInternalSize();
end
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
function InputHandler( uiMsg, wParam, lParam )
    if uiMsg == KeyEvents.KeyDown then
        if wParam == Keys.VK_ESCAPE or wParam == Keys.VK_RETURN then
			if(Controls.WarConfirm:IsHidden())then
	            OnCloseButtonClicked();
	            
			else
				Controls.WarConfirm:SetHide(true);
            	Controls.BGBlock:SetHide(false);
			end
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
        	Events.SerialEventGameMessagePopupShown(m_PopupInfo);
        else
            UI.decTurnTimerSemaphore();
            Events.SerialEventGameMessagePopupProcessed.CallImmediate(ButtonPopupTypes.BUTTONPOPUP_CITY_STATE_DIPLO, 0);
        end
    end
end
ContextPtr:SetShowHideHandler( ShowHideHandler );

----------------------------------------------------------------
-- 'Active' (local human) player has changed
----------------------------------------------------------------
Events.GameplaySetActivePlayer.Add(OnCloseButtonClicked);
