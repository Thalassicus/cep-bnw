------------------------------------------------------
-- CityStateStatusHelper.lua
-- Author: Anton Strenger
--
-- Consolidation of code associated with displaying
-- the friendship status of a player with a city-state
------------------------------------------------------

include( "IconSupport" );

------------------------------------------------------
-- Global Constants
------------------------------------------------------
local kPosInfRange = math.abs( GameDefines["FRIENDSHIP_THRESHOLD_ALLIES"] - GameDefines["FRIENDSHIP_THRESHOLD_NEUTRAL"] );
local kNegInfRange = math.abs( GameDefines["MINOR_FRIENDSHIP_AT_WAR"] - GameDefines["FRIENDSHIP_THRESHOLD_NEUTRAL"] );
local kPosBarRange = 81;
local kNegBarRange = 81;
local kBarIconAtlas = "CITY_STATE_INFLUENCE_METER_ICON_ATLAS";
local kBarIconNeutralIndex = 4;

-- The order of precedence in which the quest icons and tooltip points are displayed
ktQuestsDisplayOrder = {
	-- Global quests are first
	MinorCivQuestTypes.MINOR_CIV_QUEST_CONTEST_CULTURE,
	MinorCivQuestTypes.MINOR_CIV_QUEST_CONTEST_FAITH,
	MinorCivQuestTypes.MINOR_CIV_QUEST_CONTEST_TECHS,
	MinorCivQuestTypes.MINOR_CIV_QUEST_INVEST,
	MinorCivQuestTypes.MINOR_CIV_QUEST_KILL_CAMP,
	-- Then personal support quests
	MinorCivQuestTypes.MINOR_CIV_QUEST_GIVE_GOLD,
	MinorCivQuestTypes.MINOR_CIV_QUEST_PLEDGE_TO_PROTECT,
	MinorCivQuestTypes.MINOR_CIV_QUEST_DENOUNCE_MAJOR,
	-- Then other pesonal quests
	MinorCivQuestTypes.MINOR_CIV_QUEST_SPREAD_RELIGION,
	MinorCivQuestTypes.MINOR_CIV_QUEST_BULLY_CITY_STATE,
	MinorCivQuestTypes.MINOR_CIV_QUEST_FIND_NATURAL_WONDER,
	MinorCivQuestTypes.MINOR_CIV_QUEST_FIND_PLAYER,
	MinorCivQuestTypes.MINOR_CIV_QUEST_KILL_CITY_STATE,
	MinorCivQuestTypes.MINOR_CIV_QUEST_GREAT_PERSON,
	MinorCivQuestTypes.MINOR_CIV_QUEST_CONSTRUCT_WONDER,
	MinorCivQuestTypes.MINOR_CIV_QUEST_CONNECT_RESOURCE,
	MinorCivQuestTypes.MINOR_CIV_QUEST_ROUTE,
}

------------------------------------------------------

function GetCityStateStatusRow(majorCivID, minorCivID)
	local majorCiv = Players[majorCivID];
	local minorCiv = Players[minorCivID];
	
	if (majorCiv == nil or minorCiv == nil) then
		print("Lua error - invalid player index");
	end
	
	local majorTeamID = majorCiv:GetTeam();
	local minorTeamID = minorCiv:GetTeam();
	local majorTeam = Teams[majorTeamID];
	local minorTeam = Teams[minorTeamID];
	
	local influence = minorCiv:GetMinorCivFriendshipWithMajor(majorCivID);
	local isWar = majorTeam:IsAtWar(minorTeamID);
	local canBully = minorCiv:CanMajorBullyGold(majorCivID);
	local isAllies = minorCiv:IsAllies(majorCivID);
	
	-- War
	if (isWar) then
		return GameInfo.MinorCivTraits_Status["MINOR_FRIENDSHIP_STATUS_WAR"];
	end
	
	-- Negative INF
	if (influence < GameDefines["FRIENDSHIP_THRESHOLD_NEUTRAL"]) then
		-- Able to bully?
		if (canBully) then
			return GameInfo.MinorCivTraits_Status["MINOR_FRIENDSHIP_STATUS_AFRAID"];
		else
			return GameInfo.MinorCivTraits_Status["MINOR_FRIENDSHIP_STATUS_ANGRY"];
		end
	-- Neutral
	elseif (influence < GameDefines["FRIENDSHIP_THRESHOLD_FRIENDS"]) then
		return GameInfo.MinorCivTraits_Status["MINOR_FRIENDSHIP_STATUS_NEUTRAL"];
	-- Friends
	elseif (influence < GameDefines["FRIENDSHIP_THRESHOLD_ALLIES"]) then
		return GameInfo.MinorCivTraits_Status["MINOR_FRIENDSHIP_STATUS_FRIENDS"];
	-- Friends, but high enough INF to be a potential ally
	elseif (not isAllies) then
		return GameInfo.MinorCivTraits_Status["MINOR_FRIENDSHIP_STATUS_FRIENDS"];
	-- Allies
	else
		return GameInfo.MinorCivTraits_Status["MINOR_FRIENDSHIP_STATUS_ALLIES"];
	end
end

function GetCityStateStatusType(majorCivID, minorCivID)
	local row = GetCityStateStatusRow(majorCivID, minorCivID);
	return row.Type;
end

function UpdateCityStateStatusBar(majorCivID, minorCivID, posBarCtrl, negBarCtrl, barMarkerCtrl)
	local majorCiv = Players[majorCivID];
	local minorCiv = Players[minorCivID];
	
	if (majorCiv == nil or minorCiv == nil) then
		print("Lua error - invalid player index");
	end
	
	local info = GetCityStateStatusRow(majorCivID, minorCivID);
	local influence = minorCiv:GetMinorCivFriendshipWithMajor(majorCivID);
	
	if (info.PositiveStatusMeter ~= nil) then
		local percentFull = math.abs(influence) / kPosInfRange;
		local xOffset = math.min(percentFull * kPosBarRange, kPosBarRange);
		barMarkerCtrl:SetOffsetX(xOffset);
		posBarCtrl:SetTexture(info.PositiveStatusMeter);
		posBarCtrl:SetPercent(percentFull);
		posBarCtrl:SetHide(false);
	else
		posBarCtrl:SetHide(true);
	end
	
	if (info.NegativeStatusMeter ~= nil) then
		local percentFull = math.abs(influence) / kNegInfRange;
		local xOffset = -1 * math.min(percentFull * kNegBarRange, kNegBarRange);
		barMarkerCtrl:SetOffsetX(xOffset);
		negBarCtrl:SetTexture(info.NegativeStatusMeter);
		negBarCtrl:SetPercent(percentFull);
		negBarCtrl:SetHide(false);
	else
		negBarCtrl:SetHide(true);
	end
	
	-- Bubble icon for meter
	local size = barMarkerCtrl:GetSize().x;
	-- Special case when INF = 0
	if (influence == 0) then
		IconHookup(kBarIconNeutralIndex, size, kBarIconAtlas, barMarkerCtrl);
	elseif (info.StatusMeterIconAtlasIndex ~= nil) then
		IconHookup(info.StatusMeterIconAtlasIndex, size, kBarIconAtlas, barMarkerCtrl);
	end
end

function UpdateCityStateStatusIconBG(majorCivID, minorCivID, iconBGCtrl)
	local info = GetCityStateStatusRow(majorCivID, minorCivID);
	
	if (info.StatusIcon ~= nil) then
		iconBGCtrl:SetTexture(info.StatusIcon);
	end
end

function UpdateCityStateStatusUI(majorCivID, minorCivID, posBarCtrl, negBarCtrl, barMarkerCtrl, iconBGCtrl)
	UpdateCityStateStatusBar(majorCivID, minorCivID, posBarCtrl, negBarCtrl, barMarkerCtrl);
	UpdateCityStateStatusIconBG(majorCivID, minorCivID, iconBGCtrl);
end

function GetCityStateStatusText(majorCivID, minorCivID)
	local majorCiv = Players[majorCivID];
	local minorCiv = Players[minorCivID];
	
	if (majorCiv == nil or minorCiv == nil) then
		print("Lua error - invalid player index");
	end
	
	local majorTeamID = majorCiv:GetTeam();
	local minorTeamID = minorCiv:GetTeam();
	local majorTeam = Teams[majorTeamID];
	local minorTeam = Teams[minorTeamID];
	
	local isWar = majorTeam:IsAtWar(minorTeamID);
	local canBully = minorCiv:CanMajorBullyGold(majorCivID);
	
	-- Status
	local strStatusText = "";
	
	if (minorCiv:IsAllies(majorCivID)) then		-- Allies
		strStatusText = Locale.ConvertTextKey("TXT_KEY_ALLIES");
		strStatusText = "[COLOR_CYAN]" .. strStatusText .. "[ENDCOLOR]";
		
	elseif (minorCiv:IsFriends(majorCivID)) then		-- Friends
		strStatusText = Locale.ConvertTextKey("TXT_KEY_FRIENDS");
		strStatusText = "[COLOR_POSITIVE_TEXT]" .. strStatusText .. "[ENDCOLOR]";
		
	elseif (minorCiv:IsMinorPermanentWar(majorTeamID)) then		-- Permanent War
		strStatusText = Locale.ConvertTextKey("TXT_KEY_PERMANENT_WAR");
		strStatusText = "[COLOR_NEGATIVE_TEXT]" .. strStatusText .. "[ENDCOLOR]";
		
	elseif (minorCiv:IsPeaceBlocked(majorTeamID)) then		-- Peace blocked by being at war with ally
		strStatusText = Locale.ConvertTextKey("TXT_KEY_PEACE_BLOCKED");
		strStatusText = "[COLOR_NEGATIVE_TEXT]" .. strStatusText .. "[ENDCOLOR]";
		
	elseif (isWar) then		-- War
		strStatusText = Locale.ConvertTextKey("TXT_KEY_WAR");
		strStatusText = "[COLOR_NEGATIVE_TEXT]" .. strStatusText .. "[ENDCOLOR]";
		
	elseif (minorCiv:GetMinorCivFriendshipWithMajor(majorCivID) < GameDefines["FRIENDSHIP_THRESHOLD_NEUTRAL"]) then
		-- Afraid
		if (canBully) then
			strStatusText = Locale.ConvertTextKey("TXT_KEY_AFRAID");
		-- Angry
		else
			strStatusText = Locale.ConvertTextKey("TXT_KEY_ANGRY");
		end
		strStatusText = "[COLOR_NEGATIVE_TEXT]" .. strStatusText .. "[ENDCOLOR]";
		
	else		-- Neutral
		strStatusText = Locale.ConvertTextKey("TXT_KEY_CITY_STATE_PERSONALITY_NEUTRAL");
		strStatusText = "[COLOR_POSITIVE_TEXT]" .. strStatusText .. "[ENDCOLOR]";
	end
	
	return strStatusText;
end

-- CITY STATE STATUS
function GetCityStateStatus(pPlayer, iForPlayer, bWar)
	
	local strStatusTT = pPlayer:GetCitystateThresholdString();
	local strShortDescKey = pPlayer:GetCivilizationShortDescriptionKey();
	local bShowBasicHelp = not OptionsManager.IsNoBasicHelp()
	local activePlayer = Players[Game.GetActivePlayer()]
	
	local iInfluenceChangeThisTurn = Game.Round(pPlayer:GetFriendshipChangePerTurnTimes100(iForPlayer) / 100, 1);
	
	local strLabel = ""
	local strValue = ""
	local strBasicHelp = ""
	local strInfluenceRate = " "	
	
	if pPlayer:IsAllies(iForPlayer) then
		strLabel = "[COLOR_CYAN]"..Locale.ConvertTextKey("TXT_KEY_ALLIES").."[ENDCOLOR]"
		strValue = string.format("[COLOR_CYAN]%s[ENDCOLOR]", pPlayer:GetMinorCivFriendshipWithMajor(iForPlayer))
		strInfluenceRate = string.format("(%s%.1f)", iInfluenceChangeThisTurn >= 0 and "+" or "", iInfluenceChangeThisTurn)
		strBasicHelp = Locale.ConvertTextKey("TXT_KEY_ALLIES_CSTATE_TT", strShortDescKey, iInfluenceChangeThisTurn);
	elseif pPlayer:IsFriends(iForPlayer) then
		strLabel = "[COLOR_GREEN]"..Locale.ConvertTextKey("TXT_KEY_FRIENDS").."[ENDCOLOR]"
		strValue = string.format("[COLOR_GREEN]%s[ENDCOLOR]", pPlayer:GetMinorCivFriendshipWithMajor(iForPlayer))
		strInfluenceRate = string.format("(%s%.1f)", iInfluenceChangeThisTurn >= 0 and "+" or "", iInfluenceChangeThisTurn)
		strBasicHelp = Locale.ConvertTextKey("TXT_KEY_FRIENDS_CSTATE_TT", strShortDescKey, iInfluenceChangeThisTurn);
	elseif pPlayer:IsMinorPermanentWar(iActiveTeam) then
		strLabel = "[COLOR_RED]"..Locale.ConvertTextKey("TXT_KEY_ANGRY").."[ENDCOLOR]"
		strValue = string.format("[COLOR_RED]%s[ENDCOLOR]", pPlayer:GetMinorCivFriendshipWithMajor(iForPlayer))
		strBasicHelp = Locale.ConvertTextKey("TXT_KEY_PERMANENT_WAR_CSTATE_TT", strShortDescKey);
	elseif pPlayer:IsPeaceBlocked(iActiveTeam) then
		strLabel = "[COLOR_RED]"..Locale.ConvertTextKey("TXT_KEY_ANGRY").."[ENDCOLOR]"
		strValue = string.format("[COLOR_RED]%s[ENDCOLOR]", pPlayer:GetMinorCivFriendshipWithMajor(iForPlayer))
		strBasicHelp = Locale.ConvertTextKey("TXT_KEY_PEACE_BLOCKED_CSTATE_TT", strShortDescKey);
	elseif bWar then
		strLabel = "[COLOR_RED]"..Locale.ConvertTextKey("TXT_KEY_ANGRY").."[ENDCOLOR]"
		strValue = string.format("[COLOR_RED]%s[ENDCOLOR]", pPlayer:GetMinorCivFriendshipWithMajor(iForPlayer))
		strBasicHelp = Locale.ConvertTextKey("TXT_KEY_WAR_CSTATE_TT", strShortDescKey);
	elseif pPlayer:GetMinorCivFriendshipWithMajor(iForPlayer) < 0 then
		strLabel = "[COLOR_RED]"..Locale.ConvertTextKey("TXT_KEY_ANGRY").."[ENDCOLOR]"
		strValue = string.format("[COLOR_RED]%s[ENDCOLOR]", pPlayer:GetMinorCivFriendshipWithMajor(iForPlayer))
		strInfluenceRate = string.format("(%s%.1f)", iInfluenceChangeThisTurn >= 0 and "+" or "", iInfluenceChangeThisTurn)
		strBasicHelp = Locale.ConvertTextKey("TXT_KEY_ANGRY_CSTATE_TT", strShortDescKey, iInfluenceChangeThisTurn);
	else
		-- Neutral
		strLabel = Locale.ConvertTextKey("TXT_KEY_CITY_STATE_PERSONALITY_NEUTRAL")
		strValue = string.format("%s", pPlayer:GetMinorCivFriendshipWithMajor(iForPlayer))
		if pPlayer:GetMinorCivFriendshipWithMajor(iForPlayer) ~= 0 then
			strInfluenceRate = string.format("(%s%s)", iInfluenceChangeThisTurn >= 0 and "+" or "", iInfluenceChangeThisTurn)
		end
		strBasicHelp = Locale.ConvertTextKey("TXT_KEY_NEUTRAL_CSTATE_TT", strShortDescKey);
	end
	
	strStatusTT = strStatusTT .. Locale.ConvertTextKey("TXT_KEY_DIPLO_STATUS_TT", strLabel, strValue, strInfluenceRate)
	if bShowBasicHelp then
		strStatusTT = strStatusTT .. "[NEWLINE][NEWLINE]" .. strBasicHelp
	end

	local rivalInfluence, rivalID = activePlayer:GetRivalInfluence(pPlayer)
	local rival = Players[rivalID]
	if rival then	
		if activePlayer:HasMet(rival) then
			rival = rival:GetName()
		else
			rival = Locale.ConvertTextKey("TXT_KEY_UNMET_PLAYER")
		end
		--log:Debug("Best is %15s influence with %15s = %3s", rival, pPlayer:GetName(), rivalInfluence)	
		if (pPlayer:IsAllies(rivalID)) then
			rival			= string.format("[COLOR_CYAN]%s[ENDCOLOR]", rival)
			rivalInfluence	= string.format("[COLOR_CYAN]%s[ENDCOLOR]", rivalInfluence)
		elseif (pPlayer:IsFriends(rivalID)) then
			rival			= string.format("[COLOR_GREEN]%s[ENDCOLOR]", rival)
			rivalInfluence	= string.format("[COLOR_GREEN]%s[ENDCOLOR]", rivalInfluence)
		end
		strStatusTT = strStatusTT .. "[NEWLINE]" .. Locale.ConvertTextKey("TXT_KEY_DIPLO_INFLUENCE_RIVAL_TT", rival, rivalInfluence);
	end
	
	return strStatusTT;
	
end

function GetCityStateStatusToolTip(majorCivID, minorCivID, bFullInfo)
	local majorCiv = Players[majorCivID];
	local minorCiv = Players[minorCivID];
	local majorTeamID = majorCiv:GetTeam();
	local minorTeamID = minorCiv:GetTeam();
	local majorTeam = Teams[majorTeamID];
	local minorTeam = Teams[minorTeamID];
	
	if (majorCiv == nil or minorCiv == nil) then
		print("Lua error - invalid player index");
	end	
	
	local strStatusTT = minorCiv:GetCitystateThresholdString();
	local strShortDescKey = minorCiv:GetCivilizationShortDescriptionKey();
	local showBasicHelp = not OptionsManager.IsNoBasicHelp()
	local majorCiv = Players[Game.GetActivePlayer()]
	
	local isWar = majorTeam:IsAtWar(minorTeamID);
	local canBully = minorCiv:CanMajorBullyGold(majorCivID);
	
	local influence = minorCiv:GetMinorCivFriendshipWithMajor(majorCivID);
	local influenceRate = Game.Round(minorCiv:GetFriendshipChangePerTurnTimes100(majorCivID) / 100, 1);
	local influenceAnchor = minorCiv:GetMinorCivFriendshipAnchorWithMajor(majorCivID);
	
	local strLabel = ""
	local strValue = ""
	local strBasicHelp = ""
	local strInfluenceRate = " "	
	
	-- Influence
	if minorCiv:IsAllies(majorCivID) then
		strLabel = string.format("[COLOR_CYAN]%s[ENDCOLOR]", Locale.ConvertTextKey("TXT_KEY_ALLIES"))
		strValue = string.format("[COLOR_CYAN]%s[ENDCOLOR]", influence)
		strInfluenceRate = string.format("(%s%.1f)", influenceRate >= 0 and "+" or "", influenceRate)
		strBasicHelp = Locale.ConvertTextKey("TXT_KEY_ALLIES_CSTATE_TT", strShortDescKey, influenceRate);
		
	elseif minorCiv:IsFriends(majorCivID) then
		strLabel = string.format("[COLOR_POSITIVE_TEXT]%s[ENDCOLOR]", Locale.ConvertTextKey("TXT_KEY_FRIENDS"))
		strValue = string.format("[COLOR_POSITIVE_TEXT]%s[ENDCOLOR]", influence)
		strInfluenceRate = string.format("(%s%.1f)", influenceRate >= 0 and "+" or "", influenceRate)
		strBasicHelp = Locale.ConvertTextKey("TXT_KEY_FRIENDS_CSTATE_TT", strShortDescKey, influenceRate);
		
	elseif minorCiv:IsMinorPermanentWar(majorTeamID) then
		strLabel = string.format("[COLOR_NEGATIVE_TEXT]%s[ENDCOLOR]", Locale.ConvertTextKey("TXT_KEY_ANGRY"))
		strValue = string.format("[COLOR_NEGATIVE_TEXT]%s[ENDCOLOR]", influence)
		strBasicHelp = Locale.ConvertTextKey("TXT_KEY_PERMANENT_WAR_CSTATE_TT", strShortDescKey);
		
	elseif minorCiv:IsPeaceBlocked(majorTeamID) then
		strLabel = string.format("[COLOR_NEGATIVE_TEXT]%s[ENDCOLOR]", Locale.ConvertTextKey("TXT_KEY_ANGRY"))
		strValue = string.format("[COLOR_NEGATIVE_TEXT]%s[ENDCOLOR]", influence)
		strBasicHelp = Locale.ConvertTextKey("TXT_KEY_PEACE_BLOCKED_CSTATE_TT", strShortDescKey);
		
	elseif isWar then
		strLabel = string.format("[COLOR_NEGATIVE_TEXT]%s[ENDCOLOR]", Locale.ConvertTextKey("TXT_KEY_ANGRY"))
		strValue = string.format("[COLOR_NEGATIVE_TEXT]%s[ENDCOLOR]", influence)
		strBasicHelp = Locale.ConvertTextKey("TXT_KEY_WAR_CSTATE_TT", strShortDescKey);
		
	elseif influence < 0 then
		if canBully then
			strLabel = string.format("[COLOR_NEGATIVE_TEXT]%s[ENDCOLOR]", Locale.ConvertTextKey("TXT_KEY_AFRAID"))
		else
			strLabel = string.format("[COLOR_NEGATIVE_TEXT]%s[ENDCOLOR]", Locale.ConvertTextKey("TXT_KEY_ANGRY"))
		end
		strValue = string.format("[COLOR_NEGATIVE_TEXT]%s[ENDCOLOR]", influence)
		strInfluenceRate = string.format("(%s%.1f)", influenceRate >= 0 and "+" or "", influenceRate)
		strBasicHelp = Locale.ConvertTextKey("TXT_KEY_ANGRY_CSTATE_TT", strShortDescKey, influenceRate);
		
	else
		-- Neutral
		strLabel = Locale.ConvertTextKey("TXT_KEY_CITY_STATE_PERSONALITY_NEUTRAL")
		strValue = string.format("%s", influence)
		if influence ~= 0 then
			strInfluenceRate = string.format("(%s%s)", influenceRate >= 0 and "+" or "", influenceRate)
		end
		strBasicHelp = Locale.ConvertTextKey("TXT_KEY_NEUTRAL_CSTATE_TT", strShortDescKey);
	end
	
	strStatusTT = strStatusTT .. Locale.ConvertTextKey("TXT_KEY_DIPLO_INFLUENCE_TT", strLabel, strValue, strInfluenceRate)
	if showBasicHelp then
		strStatusTT = strStatusTT .. "[NEWLINE]" .. strBasicHelp .. "[NEWLINE]"
	end

	-- Rival Influence
	local rivalInfluence, rivalID = majorCiv:GetRivalInfluence(minorCiv)
	local rival = Players[rivalID]
	if rival then	
		if majorCiv:HasMet(rival) then
			rival = rival:GetName()
		else
			rival = Locale.ConvertTextKey("TXT_KEY_UNMET_PLAYER")
		end
		--log:Debug("Best is %15s influence with %15s = %3s", rival, minorCiv:GetName(), rivalInfluence)	
		if (minorCiv:IsAllies(rivalID)) then
			rival			= string.format("[COLOR_CYAN]%s[ENDCOLOR]", rival)
			rivalInfluence	= string.format("[COLOR_CYAN]%s[ENDCOLOR]", rivalInfluence)
		elseif (minorCiv:IsFriends(rivalID)) then
			rival			= string.format("[COLOR_GREEN]%s[ENDCOLOR]", rival)
			rivalInfluence	= string.format("[COLOR_GREEN]%s[ENDCOLOR]", rivalInfluence)
		end
		strStatusTT = strStatusTT .. "[NEWLINE]" .. Locale.ConvertTextKey("TXT_KEY_DIPLO_INFLUENCE_RIVAL_TT", rival, rivalInfluence);
	end
	
	-- Bullying
	local shortBully = ""
	local longBully = " "
	if canBully then
		shortBully = string.format("[COLOR_POSITIVE_TEXT]%s[ENDCOLOR]", Locale.ConvertTextKey("TXT_KEY_POSSIBLE"))
		if showBasicHelp then
			longBully = "[NEWLINE]"..Locale.ConvertTextKey("TXT_KEY_CSTATE_CAN_BULLY") 
		end
	else
		shortBully = string.format("%s", Locale.ConvertTextKey("TXT_KEY_NOT_POSSIBLE"))
		if showBasicHelp then
			longBully = "[NEWLINE]"..Locale.ConvertTextKey("TXT_KEY_CSTATE_CANNOT_BULLY")
		end
	end
	strStatusTT = string.format(
		"%s[NEWLINE]%s%s",
		strStatusTT,
		Locale.ConvertTextKey("TXT_KEY_DIPLO_STATUS_TRIBUTE_TT", shortBully),
		longBully
	)
	
	if (bFullInfo) then
		-- Open Borders
		if (minorCiv:IsPlayerHasOpenBorders(majorCivID)) then
		
			strStatusTT = strStatusTT .. "[NEWLINE][NEWLINE]";
		
			if (minorCiv:IsPlayerHasOpenBordersAutomatically(majorCivID)) then
				strStatusTT = strStatusTT .. Locale.ConvertTextKey("TXT_KEY_CSTATE_OPEN_BORDERS_TRAIT");
			else
				strStatusTT = strStatusTT .. Locale.ConvertTextKey("TXT_KEY_CSTATE_OPEN_BORDERS_FRIENDS");
			end
		end
		
		-- Friendship bonuses
		local iCultureBonus = minorCiv:GetMinorCivCurrentCultureBonus(majorCivID);
		if (iCultureBonus ~= 0) then
			strStatusTT = strStatusTT .. "[NEWLINE][NEWLINE]";
			strStatusTT = strStatusTT .. Locale.ConvertTextKey("TXT_KEY_CSTATE_CULTURE_BONUS", iCultureBonus);
		end
		
		local iCapitalFoodBonus = minorCiv:GetCurrentCapitalFoodBonus(majorCivID) / 100;
		local iOtherCityFoodBonus = minorCiv:GetCurrentOtherCityFoodBonus(majorCivID) / 100;
		if (iCapitalFoodBonus ~= 0 or iOtherCityFoodBonus ~= 0) then
			strStatusTT = strStatusTT .. "[NEWLINE][NEWLINE]";
			strStatusTT = strStatusTT .. Locale.ConvertTextKey("TXT_KEY_CSTATE_FOOD_BONUS", iCapitalFoodBonus, iOtherCityFoodBonus);
		end
		
		local iCurrentSpawnEstimate = minorCiv:GetCurrentSpawnEstimate(majorCivID);
		if (iCurrentSpawnEstimate ~= 0) then
			strStatusTT = strStatusTT .. "[NEWLINE][NEWLINE]";
			strStatusTT = strStatusTT .. Locale.ConvertTextKey("TXT_KEY_CSTATE_MILITARY_BONUS", iCurrentSpawnEstimate);
		end
		
		local iScienceBonus = minorCiv:GetCurrentScienceFriendshipBonusTimes100(majorCivID);
		if (iScienceBonus ~= 0) then
			strStatusTT = strStatusTT .. "[NEWLINE][NEWLINE]";
			strStatusTT = strStatusTT .. Locale.ConvertTextKey("TXT_KEY_CSTATE_SCIENCE_BONUS", iScienceBonus / 100);
		end
		
		local iHappinessBonus = minorCiv:GetMinorCivCurrentHappinessBonus(majorCivID);
		if (iHappinessBonus ~= 0) then
			strStatusTT = strStatusTT .. "[NEWLINE][NEWLINE]";
			strStatusTT = strStatusTT .. Locale.ConvertTextKey("TXT_KEY_CSTATE_HAPPINESS_BONUS", iHappinessBonus);
		end
		
		local iFaithBonus = minorCiv:GetMinorCivCurrentFaithBonus(majorCivID);
		if (iFaithBonus ~= 0) then
			strStatusTT = strStatusTT .. "[NEWLINE][NEWLINE]";
			strStatusTT = strStatusTT .. Locale.ConvertTextKey("TXT_KEY_CSTATE_FAITH_BONUS", iFaithBonus);
		end
		
		-- Resources
		local strExportedResourceText = "";
		
		local iAmount;
		
		for pResource in GameInfo.Resources() do
			iResourceLoop = pResource.ID;
			
			iAmount = minorCiv:GetResourceExport(iResourceLoop);
			
			if (iAmount > 0) then
				
				local pResource = GameInfo.Resources[iResourceLoop];
				
				if (Game.GetResourceUsageType(iResourceLoop) ~= ResourceUsageTypes.RESOURCEUSAGE_BONUS) then
					strExportedResourceText = strExportedResourceText .. pResource.IconString .. " [COLOR_POSITIVE_TEXT]" .. Locale.ConvertTextKey(pResource.Description) .. " (" .. iAmount .. ") [ENDCOLOR]";
				end
			end
		end
		
		if (strExportedResourceText ~= "") then
			if (minorCiv:IsAllies(majorCivID)) then
				strStatusTT = strStatusTT .. "[NEWLINE][NEWLINE]";
				strStatusTT = strStatusTT .. Locale.ConvertTextKey("TXT_KEY_CSTATE_RESOURCES_RECEIVED", strExportedResourceText);
			end
		end
	end
	
	return strStatusTT;
	
	
	
	
	--[[
	local majorTeamID = majorCiv:GetTeam();
	local minorTeamID = minorCiv:GetTeam();
	local majorTeam = Teams[majorTeamID];
	local minorTeam = Teams[minorTeamID];
	
	local isWar = majorTeam:IsAtWar(minorTeamID);
	local canBully = minorCiv:CanMajorBullyGold(majorCivID);
	
	local strShortDescKey = minorCiv:GetCivilizationShortDescriptionKey();
	local influence = minorCiv:GetMinorCivFriendshipWithMajor(majorCivID);
	local influenceRate = minorCiv:GetFriendshipChangePerTurnTimes100(majorCivID) / 100;
	local influenceAnchor = minorCiv:GetMinorCivFriendshipAnchorWithMajor(majorCivID);
	
	local strStatusTT = "";
	
	-- Status and Influence
	if (minorCiv:IsAllies(majorCivID)) then		-- Allies
		strStatusTT = Locale.ConvertTextKey("TXT_KEY_DIPLO_STATUS_TT", Locale.ConvertTextKey(strShortDescKey), Locale.ConvertTextKey("TXT_KEY_ALLIES"),
										  influence, 
										  GameDefines["FRIENDSHIP_THRESHOLD_MAX"] - GameDefines["FRIENDSHIP_THRESHOLD_ALLIES"]); 
		
		local strTempTT = Locale.ConvertTextKey("TXT_KEY_ALLIES_CSTATE_TT", strShortDescKey);
		
		strStatusTT = strStatusTT .. "[NEWLINE][NEWLINE]" .. strTempTT;
		
	elseif (minorCiv:IsFriends(majorCivID)) then		-- Friends
		strStatusTT = Locale.ConvertTextKey("TXT_KEY_DIPLO_STATUS_TT", Locale.ConvertTextKey(strShortDescKey), Locale.ConvertTextKey("TXT_KEY_FRIENDS"),
										    influence,
										    GameDefines["FRIENDSHIP_THRESHOLD_ALLIES"] - GameDefines["FRIENDSHIP_THRESHOLD_FRIENDS"]);
		
		local strTempTT = Locale.ConvertTextKey("TXT_KEY_FRIENDS_CSTATE_TT", strShortDescKey);
		
		strStatusTT = strStatusTT .. "[NEWLINE][NEWLINE]" .. strTempTT;
		
	elseif (minorCiv:IsMinorPermanentWar(majorTeamID)) then		-- Permanent War
		strStatusTT = Locale.ConvertTextKey("TXT_KEY_DIPLO_STATUS_TT", Locale.ConvertTextKey(strShortDescKey), Locale.ConvertTextKey("TXT_KEY_ANGRY"),
										    influence, GameDefines["MINOR_FRIENDSHIP_AT_WAR"]);
										    
		strStatusTT = strStatusTT .. "[NEWLINE][NEWLINE]" .. Locale.ConvertTextKey("TXT_KEY_PERMANENT_WAR_CSTATE_TT", strShortDescKey);
		
	elseif (minorCiv:IsPeaceBlocked(majorTeamID)) then		-- Peace blocked by being at war with ally
		strStatusTT = Locale.ConvertTextKey("TXT_KEY_DIPLO_STATUS_TT", Locale.ConvertTextKey(strShortDescKey), Locale.ConvertTextKey("TXT_KEY_ANGRY"),
										    influence, GameDefines["MINOR_FRIENDSHIP_AT_WAR"]);
										    
		strStatusTT = strStatusTT .. "[NEWLINE][NEWLINE]" .. Locale.ConvertTextKey("TXT_KEY_PEACE_BLOCKED_CSTATE_TT", strShortDescKey);
		
	elseif (isWar) then		-- War
		strStatusTT = Locale.ConvertTextKey("TXT_KEY_DIPLO_STATUS_TT", Locale.ConvertTextKey(strShortDescKey), Locale.ConvertTextKey("TXT_KEY_ANGRY"),
										    influence, GameDefines["MINOR_FRIENDSHIP_AT_WAR"]);
										    
		strStatusTT = strStatusTT .. "[NEWLINE][NEWLINE]" ..Locale.ConvertTextKey("TXT_KEY_WAR_CSTATE_TT", strShortDescKey);
		
	elseif (influence < GameDefines.FRIENDSHIP_THRESHOLD_NEUTRAL) then
		-- Afraid
		if (canBully) then
			strStatusTT = Locale.ConvertTextKey("TXT_KEY_DIPLO_STATUS_TT", Locale.ConvertTextKey(strShortDescKey), Locale.ConvertTextKey("TXT_KEY_AFRAID"),
										    influence, GameDefines["MINOR_FRIENDSHIP_AT_WAR"]);
		-- Angry
		else
			strStatusTT = Locale.ConvertTextKey("TXT_KEY_DIPLO_STATUS_TT", Locale.ConvertTextKey(strShortDescKey), Locale.ConvertTextKey("TXT_KEY_ANGRY"),
										    influence, GameDefines["MINOR_FRIENDSHIP_AT_WAR"]);
		end
										    
		strStatusTT = strStatusTT .. "[NEWLINE][NEWLINE]" .. Locale.ConvertTextKey("TXT_KEY_ANGRY_CSTATE_TT", strShortDescKey);
		
	else		-- Neutral
		strStatusTT = Locale.ConvertTextKey("TXT_KEY_DIPLO_STATUS_TT", Locale.ConvertTextKey(strShortDescKey), Locale.ConvertTextKey("TXT_KEY_CITY_STATE_PERSONALITY_NEUTRAL"),
										    influence - GameDefines["FRIENDSHIP_THRESHOLD_NEUTRAL"], 
											GameDefines["FRIENDSHIP_THRESHOLD_FRIENDS"] - GameDefines["FRIENDSHIP_THRESHOLD_NEUTRAL"]);
										    
		strStatusTT = strStatusTT .. "[NEWLINE][NEWLINE]" .. Locale.ConvertTextKey("TXT_KEY_NEUTRAL_CSTATE_TT", strShortDescKey);
	end
	
	-- Influence change
	if (influence ~= influenceAnchor) then
		strStatusTT = strStatusTT .. "[NEWLINE][NEWLINE]";
		strStatusTT = strStatusTT .. Locale.ConvertTextKey("TXT_KEY_CSTATE_INFLUENCE_RATE", influenceRate, influenceAnchor);
	end
	
	-- Bullying
	if (canBully) then
		strStatusTT = strStatusTT .. "[NEWLINE][NEWLINE]";
		strStatusTT = strStatusTT .. Locale.ConvertTextKey("TXT_KEY_CSTATE_CAN_BULLY");
	else
		strStatusTT = strStatusTT .. "[NEWLINE][NEWLINE]";
		strStatusTT = strStatusTT .. Locale.ConvertTextKey("TXT_KEY_CSTATE_CANNOT_BULLY");
	end
	
	if (bFullInfo) then
		-- Open Borders
		if (minorCiv:IsPlayerHasOpenBorders(majorCivID)) then
		
			strStatusTT = strStatusTT .. "[NEWLINE][NEWLINE]";
		
			if (minorCiv:IsPlayerHasOpenBordersAutomatically(majorCivID)) then
				strStatusTT = strStatusTT .. Locale.ConvertTextKey("TXT_KEY_CSTATE_OPEN_BORDERS_TRAIT");
			else
				strStatusTT = strStatusTT .. Locale.ConvertTextKey("TXT_KEY_CSTATE_OPEN_BORDERS_FRIENDS");
			end
		end
		
		-- Friendship bonuses
		local iCultureBonus = minorCiv:GetMinorCivCurrentCultureBonus(majorCivID);
		if (iCultureBonus ~= 0) then
			strStatusTT = strStatusTT .. "[NEWLINE][NEWLINE]";
			strStatusTT = strStatusTT .. Locale.ConvertTextKey("TXT_KEY_CSTATE_CULTURE_BONUS", iCultureBonus);
		end
		
		local iCapitalFoodBonus = minorCiv:GetCurrentCapitalFoodBonus(majorCivID) / 100;
		local iOtherCityFoodBonus = minorCiv:GetCurrentOtherCityFoodBonus(majorCivID) / 100;
		if (iCapitalFoodBonus ~= 0 or iOtherCityFoodBonus ~= 0) then
			strStatusTT = strStatusTT .. "[NEWLINE][NEWLINE]";
			strStatusTT = strStatusTT .. Locale.ConvertTextKey("TXT_KEY_CSTATE_FOOD_BONUS", iCapitalFoodBonus, iOtherCityFoodBonus);
		end
		
		local iCurrentSpawnEstimate = minorCiv:GetCurrentSpawnEstimate(majorCivID);
		if (iCurrentSpawnEstimate ~= 0) then
			strStatusTT = strStatusTT .. "[NEWLINE][NEWLINE]";
			strStatusTT = strStatusTT .. Locale.ConvertTextKey("TXT_KEY_CSTATE_MILITARY_BONUS", iCurrentSpawnEstimate);
		end
		
		local iScienceBonus = minorCiv:GetCurrentScienceFriendshipBonusTimes100(majorCivID);
		if (iScienceBonus ~= 0) then
			strStatusTT = strStatusTT .. "[NEWLINE][NEWLINE]";
			strStatusTT = strStatusTT .. Locale.ConvertTextKey("TXT_KEY_CSTATE_SCIENCE_BONUS", iScienceBonus / 100);
		end
		
		local iHappinessBonus = minorCiv:GetMinorCivCurrentHappinessBonus(majorCivID);
		if (iHappinessBonus ~= 0) then
			strStatusTT = strStatusTT .. "[NEWLINE][NEWLINE]";
			strStatusTT = strStatusTT .. Locale.ConvertTextKey("TXT_KEY_CSTATE_HAPPINESS_BONUS", iHappinessBonus);
		end
		
		local iFaithBonus = minorCiv:GetMinorCivCurrentFaithBonus(majorCivID);
		if (iFaithBonus ~= 0) then
			strStatusTT = strStatusTT .. "[NEWLINE][NEWLINE]";
			strStatusTT = strStatusTT .. Locale.ConvertTextKey("TXT_KEY_CSTATE_FAITH_BONUS", iFaithBonus);
		end
		
		-- Resources
		local strExportedResourceText = "";
		
		local iAmount;
		
		for pResource in GameInfo.Resources() do
			iResourceLoop = pResource.ID;
			
			iAmount = minorCiv:GetResourceExport(iResourceLoop);
			
			if (iAmount > 0) then
				
				local pResource = GameInfo.Resources[iResourceLoop];
				
				if (Game.GetResourceUsageType(iResourceLoop) ~= ResourceUsageTypes.RESOURCEUSAGE_BONUS) then
					strExportedResourceText = strExportedResourceText .. pResource.IconString .. " [COLOR_POSITIVE_TEXT]" .. Locale.ConvertTextKey(pResource.Description) .. " (" .. iAmount .. ") [ENDCOLOR]";
				end
			end
		end
		
		if (strExportedResourceText ~= "") then
			if (minorCiv:IsAllies(majorCivID)) then
				strStatusTT = strStatusTT .. "[NEWLINE][NEWLINE]";
				strStatusTT = strStatusTT .. Locale.ConvertTextKey("TXT_KEY_CSTATE_RESOURCES_RECEIVED", strExportedResourceText);
			end
		end
	end
	
	return strStatusTT;
	--]]
end

function GetActiveQuestText(majorCivID, minorCivID)
	local majorCivID = majorCivID;
	local minorCiv = Players[minorCivID];
	
	local sIconText = "";
	local iNumQuests = 0;
	
	if (minorCiv == nil) then
		return Locale.Lookup("TXT_KEY_CITY_STATE_QUEST_NONE");
	end
	
	for i, eType in ipairs(ktQuestsDisplayOrder) do
		if (minorCiv:IsMinorCivActiveQuestForPlayer(majorCivID, eType)) then
			
			iNumQuests = iNumQuests + 1;
			
			-- This data is not pertinent for all quest types, but grab it here for readability
			local iQuestData1 = minorCiv:GetQuestData1(majorCivID, eType);
			local iQuestData2 = minorCiv:GetQuestData2(majorCivID, eType);
	
			if (eType == MinorCivQuestTypes.MINOR_CIV_QUEST_ROUTE) then
				sIconText = sIconText .. "[ICON_CONNECTED]";
			elseif (eType == MinorCivQuestTypes.MINOR_CIV_QUEST_KILL_CAMP) then	
				sIconText = sIconText .. "[ICON_WAR]";
			elseif (eType == MinorCivQuestTypes.MINOR_CIV_QUEST_CONNECT_RESOURCE) then
				sIconText = sIconText .. GameInfo.Resources[iQuestData1].IconString;
			elseif (eType == MinorCivQuestTypes.MINOR_CIV_QUEST_CONSTRUCT_WONDER) then
				sIconText = sIconText .. "[ICON_GOLDEN_AGE]";
			elseif (eType == MinorCivQuestTypes.MINOR_CIV_QUEST_GREAT_PERSON) then
				sIconText = sIconText .. "[ICON_GREAT_PEOPLE]";
			elseif (eType == MinorCivQuestTypes.MINOR_CIV_QUEST_KILL_CITY_STATE) then
				sIconText = sIconText .. "[ICON_RAZING]";
			elseif (eType == MinorCivQuestTypes.MINOR_CIV_QUEST_FIND_PLAYER) then
				if (Players[iQuestData1]:IsMinorCiv()) then
					sIconText = sIconText .. "[ICON_CITY_STATE]";
				else
					sIconText = sIconText .. "[ICON_CAPITAL]";
				end
			elseif (eType == MinorCivQuestTypes.MINOR_CIV_QUEST_FIND_NATURAL_WONDER) then
				sIconText = sIconText .. "[ICON_HAPPINESS_1]";
			elseif (eType == MinorCivQuestTypes.MINOR_CIV_QUEST_GIVE_GOLD) then
				sIconText = sIconText .. "[ICON_GOLD]";
			elseif (eType == MinorCivQuestTypes.MINOR_CIV_QUEST_PLEDGE_TO_PROTECT) then
				sIconText = sIconText .. "[ICON_STRENGTH]";
			elseif (eType == MinorCivQuestTypes.MINOR_CIV_QUEST_CONTEST_CULTURE) then
				sIconText = sIconText .. "[ICON_CULTURE]";
			elseif (eType == MinorCivQuestTypes.MINOR_CIV_QUEST_CONTEST_FAITH) then
				sIconText = sIconText .. "[ICON_PEACE]";
			elseif (eType == MinorCivQuestTypes.MINOR_CIV_QUEST_CONTEST_TECHS) then
				sIconText = sIconText .. "[ICON_RESEARCH]";
			elseif (eType == MinorCivQuestTypes.MINOR_CIV_QUEST_INVEST) then
				sIconText = sIconText .. "[ICON_INVEST]";
			elseif (eType == MinorCivQuestTypes.MINOR_CIV_QUEST_BULLY_CITY_STATE) then
				sIconText = sIconText .. "[ICON_PIRATE]";
			elseif (eType == MinorCivQuestTypes.MINOR_CIV_QUEST_DENOUNCE_MAJOR) then
				sIconText = sIconText .. "[ICON_DENOUNCE]";
			elseif (eType == MinorCivQuestTypes.MINOR_CIV_QUEST_SPREAD_RELIGION) then
				sIconText = sIconText .. GameInfo.Religions[iQuestData1].IconString;
			end
		end
	end
	
	-- Kill invading barbarians is a conditional "pseudo-quest", so handle it here separately
	if (minorCiv:IsThreateningBarbariansEventActiveForPlayer(majorCivID)) then
		iNumQuests = iNumQuests + 1;
		sIconText = sIconText .. "[ICON_RAZING]";
	end
	
	if (iNumQuests <= 0) then
		sIconText = Locale.Lookup("TXT_KEY_CITY_STATE_QUEST_NONE");
	end
	
	return sIconText;
end

function GetActiveQuestToolTip(majorCivID, minorCivID)
	local majorCivID = Game.GetActivePlayer();
	local minorCiv = Players[minorCivID];
	
	local sToolTipText = "";
	local iNumQuests = 0;
	
	if (minorCiv == nil) then
		return Locale.Lookup("TXT_KEY_CITY_STATE_QUEST_NONE_FORMAL");
	end
	
	for i, eType in ipairs(ktQuestsDisplayOrder) do
		if (minorCiv:IsMinorCivActiveQuestForPlayer(majorCivID, eType)) then
		
			iNumQuests = iNumQuests + 1;
			if (sToolTipText ~= "") then
				sToolTipText = sToolTipText .. "[NEWLINE]"
			end
			sToolTipText = sToolTipText .. "[ICON_BULLET]";
			
			-- This data is not pertinent for all quest types, but grab it here for readability
			local iQuestData1 = minorCiv:GetQuestData1(majorCivID, eType);
			local iQuestData2 = minorCiv:GetQuestData2(majorCivID, eType);
			local iTurnsRemaining = minorCiv:GetQuestTurnsRemaining(majorCivID, eType, Game.GetGameTurn() - 1); -- add 1 since began on CS's turn (1 before), and avoids "0 turns remaining"
			
			if (eType == MinorCivQuestTypes.MINOR_CIV_QUEST_ROUTE) then
				sToolTipText = sToolTipText .. Locale.Lookup( "TXT_KEY_CITY_STATE_QUEST_ROUTE_FORMAL" );
			elseif (eType == MinorCivQuestTypes.MINOR_CIV_QUEST_KILL_CAMP) then
				sToolTipText = sToolTipText .. Locale.Lookup( "TXT_KEY_CITY_STATE_QUEST_KILL_CAMP_FORMAL" );
			elseif (eType == MinorCivQuestTypes.MINOR_CIV_QUEST_CONNECT_RESOURCE) then
				sToolTipText = sToolTipText .. Locale.Lookup( "TXT_KEY_CITY_STATE_QUEST_CONNECT_RESOURCE_FORMAL", GameInfo.Resources[iQuestData1].Description );
			elseif eType == MinorCivQuestTypes.MINOR_CIV_QUEST_CONSTRUCT_WONDER then
				sToolTipText = sToolTipText .. Locale.Lookup( "TXT_KEY_CITY_STATE_QUEST_CONSTRUCT_WONDER_FORMAL", GameInfo.Buildings[iQuestData1].Description );
			elseif (eType == MinorCivQuestTypes.MINOR_CIV_QUEST_GREAT_PERSON) then
				sToolTipText = sToolTipText .. Locale.Lookup( "TXT_KEY_CITY_STATE_QUEST_GREAT_PERSON_FORMAL", GameInfo.Units[iQuestData1].Description );
			elseif (eType == MinorCivQuestTypes.MINOR_CIV_QUEST_KILL_CITY_STATE) then
				sToolTipText = sToolTipText .. Locale.Lookup( "TXT_KEY_CITY_STATE_QUEST_KILL_CITY_STATE_FORMAL", Players[iQuestData1]:GetNameKey() );
			elseif (eType == MinorCivQuestTypes.MINOR_CIV_QUEST_FIND_PLAYER) then
				sToolTipText = sToolTipText .. Locale.Lookup( "TXT_KEY_CITY_STATE_QUEST_FIND_PLAYER_FORMAL", Players[iQuestData1]:GetCivilizationShortDescriptionKey() );
			elseif (eType == MinorCivQuestTypes.MINOR_CIV_QUEST_FIND_NATURAL_WONDER) then
				sToolTipText = sToolTipText .. Locale.Lookup( "TXT_KEY_CITY_STATE_QUEST_FIND_NATURAL_WONDER_FORMAL" );
			elseif (eType == MinorCivQuestTypes.MINOR_CIV_QUEST_GIVE_GOLD) then
				sToolTipText = sToolTipText .. Locale.Lookup( "TXT_KEY_CITY_STATE_QUEST_GIVE_GOLD_FORMAL", Players[iQuestData1]:GetCivilizationShortDescriptionKey() );
			elseif (eType == MinorCivQuestTypes.MINOR_CIV_QUEST_PLEDGE_TO_PROTECT) then
				sToolTipText = sToolTipText .. Locale.Lookup( "TXT_KEY_CITY_STATE_QUEST_PLEDGE_TO_PROTECT_FORMAL", Players[iQuestData1]:GetCivilizationShortDescriptionKey() );
			elseif (eType == MinorCivQuestTypes.MINOR_CIV_QUEST_CONTEST_CULTURE) then
				local leaderScore = minorCiv:GetMinorCivContestValueForLeader(MinorCivQuestTypes.MINOR_CIV_QUEST_CONTEST_CULTURE);
				local majorCivScore = minorCiv:GetMinorCivContestValueForPlayer(majorCivID, MinorCivQuestTypes.MINOR_CIV_QUEST_CONTEST_CULTURE);
				if (minorCiv:IsMinorCivContestLeader(majorCivID, MinorCivQuestTypes.MINOR_CIV_QUEST_CONTEST_CULTURE)) then
					sToolTipText = sToolTipText .. Locale.Lookup( "TXT_KEY_CITY_STATE_QUEST_CONTEST_CULTURE_WINNING_FORMAL", majorCivScore );
				else
					sToolTipText = sToolTipText .. Locale.Lookup( "TXT_KEY_CITY_STATE_QUEST_CONTEST_CULTURE_LOSING_FORMAL", leaderScore, majorCivScore );
				end
			elseif (eType == MinorCivQuestTypes.MINOR_CIV_QUEST_CONTEST_FAITH) then
				local leaderScore = minorCiv:GetMinorCivContestValueForLeader(MinorCivQuestTypes.MINOR_CIV_QUEST_CONTEST_FAITH);
				local majorCivScore = minorCiv:GetMinorCivContestValueForPlayer(majorCivID, MinorCivQuestTypes.MINOR_CIV_QUEST_CONTEST_FAITH);
				if (minorCiv:IsMinorCivContestLeader(majorCivID, MinorCivQuestTypes.MINOR_CIV_QUEST_CONTEST_FAITH)) then
					sToolTipText = sToolTipText .. Locale.Lookup( "TXT_KEY_CITY_STATE_QUEST_CONTEST_FAITH_WINNING_FORMAL", majorCivScore );
				else
					sToolTipText = sToolTipText .. Locale.Lookup( "TXT_KEY_CITY_STATE_QUEST_CONTEST_FAITH_LOSING_FORMAL", leaderScore, majorCivScore );
				end
			elseif (eType == MinorCivQuestTypes.MINOR_CIV_QUEST_CONTEST_TECHS) then
				local leaderScore = minorCiv:GetMinorCivContestValueForLeader(MinorCivQuestTypes.MINOR_CIV_QUEST_CONTEST_TECHS);
				local majorCivScore = minorCiv:GetMinorCivContestValueForPlayer(majorCivID, MinorCivQuestTypes.MINOR_CIV_QUEST_CONTEST_TECHS);
				if (minorCiv:IsMinorCivContestLeader(majorCivID, MinorCivQuestTypes.MINOR_CIV_QUEST_CONTEST_TECHS)) then
					sToolTipText = sToolTipText .. Locale.Lookup( "TXT_KEY_CITY_STATE_QUEST_CONTEST_TECHS_WINNING_FORMAL", majorCivScore );
				else
					sToolTipText = sToolTipText .. Locale.Lookup( "TXT_KEY_CITY_STATE_QUEST_CONTEST_TECHS_LOSING_FORMAL", leaderScore, majorCivScore );
				end
			elseif (eType == MinorCivQuestTypes.MINOR_CIV_QUEST_INVEST) then
				sToolTipText = sToolTipText .. Locale.Lookup( "TXT_KEY_CITY_STATE_QUEST_INVEST_FORMAL" );
			elseif (eType == MinorCivQuestTypes.MINOR_CIV_QUEST_BULLY_CITY_STATE) then
				sToolTipText = sToolTipText .. Locale.Lookup( "TXT_KEY_CITY_STATE_QUEST_BULLY_CITY_STATE_FORMAL", Players[iQuestData1]:GetCivilizationShortDescriptionKey() );
			elseif (eType == MinorCivQuestTypes.MINOR_CIV_QUEST_DENOUNCE_MAJOR) then
				sToolTipText = sToolTipText .. Locale.Lookup( "TXT_KEY_CITY_STATE_QUEST_DENOUNCE_MAJOR_FORMAL", Players[iQuestData1]:GetCivilizationShortDescriptionKey() );
			elseif (eType == MinorCivQuestTypes.MINOR_CIV_QUEST_SPREAD_RELIGION) then
				sToolTipText = sToolTipText .. Locale.Lookup( "TXT_KEY_CITY_STATE_QUEST_SPREAD_RELIGION_FORMAL", Game.GetReligionName(iQuestData1) );
			end
			
			if (iTurnsRemaining >= 0) then
				sToolTipText = sToolTipText .. " " .. Locale.Lookup( "TXT_KEY_CITY_STATE_QUEST_TURNS_REMAINING_FORMAL", iTurnsRemaining );
			end
		end
	end
	
	-- Kill invading barbarians is a conditional "pseudo-quest", so handle it here separately
	if (minorCiv:IsThreateningBarbariansEventActiveForPlayer(majorCivID)) then
		iNumQuests = iNumQuests + 1;
		if (sToolTipText ~= "") then
			sToolTipText = sToolTipText .. "[NEWLINE]"
		end
		sToolTipText = sToolTipText .. "[ICON_BULLET]";
		sToolTipText = sToolTipText .. Locale.Lookup("TXT_KEY_CITY_STATE_QUEST_INVADING_BARBS_FORMAL");
	end
	
	if (iNumQuests <= 0) then
		sToolTipText = Locale.Lookup("TXT_KEY_CITY_STATE_QUEST_NONE_FORMAL");
	end
	
	return sToolTipText;
end

function GetCityStateTraitText(minorCivID)
	local strTraitText = "";
	local minorCiv = Players[minorCivID];
	if (minorCiv ~= nil) then
		local iTrait = minorCiv:GetMinorCivTrait();
		if (iTrait == MinorCivTraitTypes.MINOR_CIV_TRAIT_CULTURED) then
			strTraitText = Locale.ConvertTextKey("TXT_KEY_CITY_STATE_CULTURED_ADJECTIVE");
		elseif (iTrait == MinorCivTraitTypes.MINOR_CIV_TRAIT_MILITARISTIC) then
			strTraitText = Locale.ConvertTextKey("TXT_KEY_CITY_STATE_MILITARISTIC_ADJECTIVE");
		elseif (iTrait == MinorCivTraitTypes.MINOR_CIV_TRAIT_MARITIME) then
			strTraitText = Locale.ConvertTextKey("TXT_KEY_CITY_STATE_MARITIME_ADJECTIVE");
		elseif (iTrait == MinorCivTraitTypes.MINOR_CIV_TRAIT_MERCANTILE) then
			strTraitText = Locale.ConvertTextKey("TXT_KEY_CITY_STATE_MERCANTILE_ADJECTIVE");
		elseif (iTrait == MinorCivTraitTypes.MINOR_CIV_TRAIT_RELIGIOUS) then
			strTraitText = Locale.ConvertTextKey("TXT_KEY_CITY_STATE_RELIGIOUS_ADJECTIVE");
		end
	end
	
	return strTraitText;
end

function GetCityStateTraitToolTip(minorCivID)
	local strTraitTT = "";
	local minorCiv = Players[minorCivID];
	if (minorCiv ~= nil) then
		local iTrait = minorCiv:GetMinorCivTrait();
		if (iTrait == MinorCivTraitTypes.MINOR_CIV_TRAIT_CULTURED) then
			strTraitTT = Locale.ConvertTextKey("TXT_KEY_CITY_STATE_CULTURED_TT");
		elseif (iTrait == MinorCivTraitTypes.MINOR_CIV_TRAIT_MILITARISTIC) then
			strTraitTT = Locale.ConvertTextKey("TXT_KEY_CITY_STATE_MILITARISTIC_NO_UU_TT");
			if (minorCiv:IsMinorCivHasUniqueUnit()) then
				local eUniqueUnit = minorCiv:GetMinorCivUniqueUnit();
				if (GameInfo.Units[eUniqueUnit] ~= nil) then
					local ePrereqTech = GameInfo.Units[eUniqueUnit].PrereqTech;
					if (ePrereqTech == nil) then
						-- If no prereq then just make it Agriculture, but make sure that Agriculture is in our database. Otherwise, show the fallback tooltip.
						if (GameInfo.Technologies["TECH_AGRICULTURE"] ~= nil) then
							ePrereqTech = GameInfo.Technologies["TECH_AGRICULTURE"].ID;
						end
					end
					
					if (ePrereqTech ~= nil) then
						if (GameInfo.Technologies[ePrereqTech] ~= nil) then
							strTraitTT = Locale.ConvertTextKey("TXT_KEY_CITY_STATE_MILITARISTIC_TT", GameInfo.Units[eUniqueUnit].Description, GameInfo.Technologies[ePrereqTech].Description);
						end
					end
				else
					print("Scripting error - City-State's unique unit not found!");
				end
			end
		elseif (iTrait == MinorCivTraitTypes.MINOR_CIV_TRAIT_MARITIME) then
			strTraitTT = Locale.ConvertTextKey("TXT_KEY_CITY_STATE_MARITIME_TT");
		elseif (iTrait == MinorCivTraitTypes.MINOR_CIV_TRAIT_MERCANTILE) then
			strTraitTT = Locale.ConvertTextKey("TXT_KEY_CITY_STATE_MERCANTILE_TT");
		elseif (iTrait == MinorCivTraitTypes.MINOR_CIV_TRAIT_RELIGIOUS) then
			strTraitTT = Locale.ConvertTextKey("TXT_KEY_CITY_STATE_RELIGIOUS_TT");
		end
	end
	
	return strTraitTT;
end