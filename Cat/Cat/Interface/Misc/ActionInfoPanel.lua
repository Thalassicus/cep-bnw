-------------------------------------------------
-- Action Info Panel
-------------------------------------------------
include( "FLuaVector" );

local NO_FLASHING         = 0;
local FLASHING_END_TURN   = 1;
local FLASHING_SCIENCE    = 2;
local FLASHING_PRODUCTION = 3;
local FLASHING_FREE_TECH  = 4;

local pleaseWaitString = Locale.ConvertTextKey( "TXT_KEY_PLEASE_WAIT" );
local pleaseWaitTooltipString = Locale.ConvertTextKey( "TXT_KEY_PLEASE_WAIT_TT" );
local choosePolicyString = Locale.ConvertTextKey( "TXT_KEY_CHOOSE_POLICY" );
local choosePolicyTooltipString = Locale.ConvertTextKey( "TXT_KEY_NOTIFICATION_ENOUGH_CULTURE_FOR_POLICY" );
local choosePolicyDismissTooltipString = Locale.ConvertTextKey( "TXT_KEY_NOTIFICATION_ENOUGH_CULTURE_FOR_POLICY_DISMISS" );
local chooseResearchString = Locale.ConvertTextKey( "TXT_KEY_CHOOSE_RESEARCH" );
local chooseResearchTooltipString = Locale.ConvertTextKey( "TXT_KEY_CHOOSE_RESEARCH_TT" );
local chooseProductionString = Locale.ConvertTextKey( "TXT_KEY_CHOOSE_PRODUCTION" );
local chooseProductionTooltipString = Locale.ConvertTextKey( "TXT_KEY_CHOOSE_PRODUCTION_TT" );
local skipTurnString = Locale.ConvertTextKey( "TXT_KEY_SKIP_TURN" );
local skipTurnTooltipString = Locale.ConvertTextKey( "TXT_KEY_SKIP_TURN_TT" );
local moveStackedUnitString = Locale.ConvertTextKey( "TXT_KEY_MOVE_STACKED_UNIT" );
local moveStackedUnitTooltipString = Locale.ConvertTextKey( "TXT_KEY_MOVE_STACKED_UNIT_TT" );
local unitNeedsOrdersString = Locale.ConvertTextKey( "TXT_KEY_UNIT_NEEDS_ORDERS" );
local unitNeedsOrdersTooltipString = Locale.ConvertTextKey( "TXT_KEY_UNIT_NEEDS_ORDERS_TT" );
local unitPromotionString = Locale.ConvertTextKey( "TXT_KEY_UNIT_PROMOTION" );
local unitPromotionTooltipString = Locale.ConvertTextKey( "TXT_KEY_UNIT_PROMOTION_TT" );
local cityRangeAttackString = Locale.ConvertTextKey( "TXT_KEY_CITY_RANGE_ATTACK" );
local cityRangeAttackTooltipString = Locale.ConvertTextKey( "TXT_KEY_CITY_RANGE_ATTACK_TT" );
local diploVoteString = Locale.ConvertTextKey( "TXT_KEY_DIPLO_VOTE" );
local diploVoteTooltipString = Locale.ConvertTextKey( "TXT_KEY_DIPLO_VOTE_TT" );
local waitForPlayersString = Locale.ConvertTextKey( "TXT_KEY_WAITING_FOR_PLAYERS" );
local waitForPlayersTooltipString = Locale.ConvertTextKey( "TXT_KEY_WAITING_FOR_PLAYERS_TT" );
local nextTurnString = Locale.ConvertTextKey( "TXT_KEY_NEXT_TURN" );
local nextTurnTooltipString = Locale.ConvertTextKey( "TXT_KEY_NEXT_TURN_TT" );
local chooseFreeTechString = Locale.ConvertTextKey( "TXT_KEY_CHOOSE_FREE_TECH" );
local chooseFreeTechTooltipString = Locale.ConvertTextKey( "TXT_KEY_CHOOSE_FREE_TECH_TT" );


function SetEndTurnFlashing (iFlashingState)

	local bHideEndTurnFlash    = true;
	local bHideScienceFlash    = true;
	local bHideFreeTechFlash   = true;
	local bHideProductionFlash = true;
	local bHideNormalMouseover = false;
	if (iFlashingState == FLASHING_END_TURN) then
		bHideEndTurnFlash = false;
		bHideNormalMouseover = true;
	elseif (iFlashingState == FLASHING_SCIENCE) then
		bHideScienceFlash = false;
	elseif (iFlashingState == FLASHING_PRODUCTION) then
		bHideProductionFlash = false;
	elseif (iFlashingState == FLASHING_FREE_TECH) then
		bHideFreeTechFlash = false;
	elseif (iFlashingState == NO_FLASHING) then	
	end
	
	Controls.EndTurnButtonEndTurnAlpha:SetHide(bHideEndTurnFlash);
	Controls.EndTurnButtonScienceAlpha:SetHide(bHideScienceFlash);
	Controls.EndTurnButtonFreeTechAlpha:SetHide(bHideFreeTechFlash);
	Controls.EndTurnButtonProductionAlpha:SetHide(bHideProductionFlash);
	Controls.EndTurnButtonMouseOverAlpha:SetHide(bHideNormalMouseover);
end

-------------------------------------------------
-- End Turn Button Handler
-------------------------------------------------

function OnEndTurnClicked()

	local player = Players[Game.GetActivePlayer()];
	if not player:IsTurnActive() then
		print("Player's turn not active");
		return;
	end
	if Game.IsProcessingMessages() then
		print("The game is busy processing messages");
		return;
	end
	-- Have we already signaled that we are done?
	if Network.HasSentNetTurnComplete() and PreGame.IsMultiplayerGame() then
		if Network.SendTurnUnready() then
			-- Success
			OnEndTurnDirty();
		end
		return;
	end

	local blockingType = player:GetEndTurnBlockingType();
	local blockingNotificationIndex = player:GetEndTurnBlockingNotificationIndex();
	
	if (blockingType == EndTurnBlockingTypes.ENDTURN_BLOCKING_POLICY
		or blockingType == EndTurnBlockingTypes.ENDTURN_BLOCKING_PRODUCTION
		or blockingType == EndTurnBlockingTypes.ENDTURN_BLOCKING_DIPLO_VOTE
		or blockingType == EndTurnBlockingTypes.ENDTURN_BLOCKING_FREE_ITEMS
		or blockingType == EndTurnBlockingTypes.ENDTURN_BLOCKING_FREE_POLICY
		or blockingType == EndTurnBlockingTypes.ENDTURN_BLOCKING_FOUND_PANTHEON
		or blockingType == EndTurnBlockingTypes.ENDTURN_BLOCKING_FOUND_RELIGION
		or blockingType == EndTurnBlockingTypes.ENDTURN_BLOCKING_ENHANCE_RELIGION
		or blockingType == EndTurnBlockingTypes.ENDTURN_BLOCKING_STEAL_TECH
		or blockingType == EndTurnBlockingTypes.ENDTURN_BLOCKING_MAYA_LONG_COUNT
		or blockingType == EndTurnBlockingTypes.ENDTURN_BLOCKING_FAITH_GREAT_PERSON) then
		UI.ActivateNotification(blockingNotificationIndex);
	elseif (blockingType == EndTurnBlockingTypes.ENDTURN_BLOCKING_RESEARCH
		or blockingType == EndTurnBlockingTypes.ENDTURN_BLOCKING_FREE_TECH) then
		Events.SerialEventGameMessagePopup( { Type = ButtonPopupTypes.BUTTONPOPUP_TECH_TREE, Data2 = -1 } );
	elseif (blockingType == EndTurnBlockingTypes.ENDTURN_BLOCKING_UNIT_PROMOTION) then
		for v in player:Units() do
			if (v:IsPromotionReady()) then
				local pPlot = v:GetPlot();
				UI.LookAt(pPlot, 0);
				UI.SelectUnit(v);
				local hex = ToHexFromGrid( Vector2(pPlot:GetX(), pPlot:GetY() ) );
				Events.GameplayFX(hex.x, hex.y, -1);
				break;
			end
		end
	elseif (blockingType == EndTurnBlockingTypes.ENDTURN_BLOCKING_STACKED_UNITS
		or blockingType == EndTurnBlockingTypes.ENDTURN_BLOCKING_UNIT_NEEDS_ORDERS
		or blockingType == EndTurnBlockingTypes.ENDTURN_BLOCKING_UNITS) then
		local pUnit = player:GetFirstReadyUnit();
		if (pUnit) then
			local pPlot = pUnit:GetPlot();
			UI.LookAt(pPlot, 0);
			UI.SelectUnit(pUnit);
			local hex = ToHexFromGrid( Vector2(pPlot:GetX(), pPlot:GetY() ) );
			Events.GameplayFX(hex.x, hex.y, -1);				
		end	
		
	elseif (blockingType == EndTurnBlockingTypes.ENDTURN_BLOCKING_CITY_RANGE_ATTACK) then
		local pCity = UI.GetHeadSelectedCity();
		if (pCity) then
			UI.LookAt(pCity:Plot(), 0);
		end
	--elseif (blockingType == EndTurnBlockingTypes.ENDTURN_BLOCKING_UNITS) then
	--	-- Skip active Unit's turn
	--	local pUnit = UI.GetHeadSelectedUnit();
	--	if (pUnit ~= nil) then
	--		local iSkipUnitMission = GameInfoTypes.MISSION_SKIP;
	--		Game.SelectionListGameNetMessage(GameMessageTypes.GAMEMESSAGE_PUSH_MISSION, GameInfoTypes.MISSION_SKIP, pUnit:GetID(), 0, 0, false);
	--	end	
	else
		if (not UI.CanEndTurn()) then
			print("UI thinks that we can't end turn, but the notification system disagrees");
		end
	
		local iEndTurnControl = GameInfoTypes.CONTROL_ENDTURN;
		Game.DoControl(iEndTurnControl)	
	end
end
Controls.EndTurnButton:RegisterCallback( Mouse.eLClick, OnEndTurnClicked );

function InputHandler( uiMsg, wParam, lParam )
	if uiMsg == KeyEvents.KeyDown then
		if wParam == Keys.VK_RETURN then
			OnEndTurnClicked();
			return true;
		end
    end
end
ContextPtr:SetInputHandler( InputHandler );

-- RIGHT CLICK
function OnEndTurnRightClicked()

	local player = Players[Game.GetActivePlayer()];
	if not player:IsTurnActive() or (PreGame.IsMultiplayerGame() and Network.HasSentNetTurnComplete()) then
		print("Player's turn not active");
		return;
	end

	local blockingType = player:GetEndTurnBlockingType();
	local blockingNotificationIndex = player:GetEndTurnBlockingNotificationIndex();
	
	if (blockingType == EndTurnBlockingTypes.ENDTURN_BLOCKING_RESEARCH
		or blockingType == EndTurnBlockingTypes.ENDTURN_BLOCKING_FREE_TECH
		or blockingType == EndTurnBlockingTypes.ENDTURN_BLOCKING_PRODUCTION
		or blockingType == EndTurnBlockingTypes.ENDTURN_BLOCKING_FREE_ITEMS
		or blockingType == EndTurnBlockingTypes.ENDTURN_BLOCKING_FREE_POLICY
		or blockingType == EndTurnBlockingTypes.ENDTURN_BLOCKING_DIPLO_VOTE
		or blockingType == EndTurnBlockingTypes.ENDTURN_BLOCKING_FOUND_PANTHEON
		or blockingType == EndTurnBlockingTypes.ENDTURN_BLOCKING_FOUND_RELIGION
		or blockingType == EndTurnBlockingTypes.ENDTURN_BLOCKING_ENHANCE_RELIGION
		or blockingType == EndTurnBlockingTypes.ENDTURN_BLOCKING_STEAL_TECH
		or blockingType == EndTurnBlockingTypes.ENDTURN_BLOCKING_MAYA_LONG_COUNT
		or blockingType == EndTurnBlockingTypes.ENDTURN_BLOCKING_FAITH_GREAT_PERSON) then
		UI.ActivateNotification(blockingNotificationIndex);
	elseif (blockingType == EndTurnBlockingTypes.ENDTURN_BLOCKING_POLICY) then
		UI.RemoveNotification( blockingNotificationIndex );
	elseif (blockingType == EndTurnBlockingTypes.ENDTURN_BLOCKING_UNIT_PROMOTION) then
		for v in player:Units() do
			if (v:IsPromotionReady()) then
				local pPlot = v:GetPlot();
				UI.LookAt(pPlot, 0);
				UI.SelectUnit(v);
				local hex = ToHexFromGrid( Vector2(pPlot:GetX(), pPlot:GetY() ) );
				Events.GameplayFX(hex.x, hex.y, -1);
				break;
			end
		end
	elseif (blockingType == EndTurnBlockingTypes.ENDTURN_BLOCKING_STACKED_UNITS
		or blockingType == EndTurnBlockingTypes.ENDTURN_BLOCKING_UNIT_NEEDS_ORDERS
		or blockingType == EndTurnBlockingTypes.ENDTURN_BLOCKING_UNITS) then
		local pUnit = player:GetFirstReadyUnit();
		if (pUnit) then
			local pPlot = pUnit:GetPlot();
			UI.LookAt(pPlot, 0);
			UI.SelectUnit(pUnit);
			local hex = ToHexFromGrid( Vector2(pPlot:GetX(), pPlot:GetY() ) );
			Events.GameplayFX(hex.x, hex.y, -1);				
		end	
		
	elseif (blockingType == EndTurnBlockingTypes.ENDTURN_BLOCKING_CITY_RANGE_ATTACK) then
		local pCity = UI.GetHeadSelectedCity();
		if (pCity) then
			UI.LookAt(pCity:Plot(), 0);
		end
	--elseif (blockingType == EndTurnBlockingTypes.ENDTURN_BLOCKING_UNITS) then
	--	-- Skip active Unit's turn
	--	local pUnit = UI.GetHeadSelectedUnit();
	--	if (pUnit ~= nil) then
	--		local iSkipUnitMission = GameInfoTypes.MISSION_SKIP;
	--		Game.SelectionListGameNetMessage(GameMessageTypes.GAMEMESSAGE_PUSH_MISSION, GameInfoTypes.MISSION_SKIP, pUnit:GetID(), 0, 0, false);
	--	end	
	--else
		--if (not UI.CanEndTurn()) then
			--print("UI thinks that we can't end turn, but the notification system disagrees");
		--end
	--
		--local iEndTurnControl = GameInfoTypes.CONTROL_ENDTURN;
		--Game.DoControl(iEndTurnControl)	
	end
end
Controls.EndTurnButton:RegisterCallback( Mouse.eRClick, OnEndTurnRightClicked );

function showEndTurnTimer()
	return Game.IsOption(GameOptionTypes.GAMEOPTION_END_TURN_TIMER_ENABLED);
end

function setupPleaseWaitToolTipString()
	-- If the active player has sent the AllComplete message, disable the button
	if Network.HasSentNetTurnAllComplete() and PreGame.IsMultiplayerGame() then
		Controls.EndTurnButton:SetDisabled( true );
	end
	
	Controls.EndTurnText:SetText(waitForPlayersString);
	pleaseWait = waitForPlayersTooltipString;
	
	playersWaiting = 0;
	
	local iActivePlayer = Game.GetActivePlayer();
	if Network.HasSentNetTurnComplete() and PreGame.IsMultiplayerGame() then
		playersWaiting = 1;
	end
	
	for iPlayerLoop = 0, GameDefines.MAX_MAJOR_CIVS-1, 1 do
		if (iPlayerLoop ~= iActivePlayer) then
			local otherPlayer = Players[iPlayerLoop];
			if(otherPlayer ~= nil) then
				if(otherPlayer:IsHuman() and otherPlayer:IsTurnActive()) then
					local playerName = otherPlayer:GetName();
					pleaseWait = pleaseWait .. "[NEWLINE]" .. "(" .. otherPlayer:GetNickName() .. ") " .. playerName;
					playersWaiting = playersWaiting + 1;
				end
			end
		end
	end
	
	if(playersWaiting == 0) then
		Controls.EndTurnText:SetText( pleaseWaitString );
		pleaseWait = pleaseWaitTooltipString;
	end
	Controls.EndTurnButton:SetToolTipString( pleaseWait );
	
	SetEndTurnFlashing(FLASHING_END_TURN);
end

-----------------------------------------------------
function OnActivePlayerTurnEnd()
	Controls.EndTurnText:SetText( pleaseWaitString );
	setupPleaseWaitToolTipString()
end
Events.ActivePlayerTurnEnd.Add( OnActivePlayerTurnEnd );

-----------------------------------------------------
function OnEndTurnDirty()
	Controls.EndTurnTimerButton:SetHide(not showEndTurnTimer());
	
	local player = Players[Game.GetActivePlayer()];
	if not player:IsTurnActive() or (PreGame.IsMultiplayerGame() and Network.HasSentNetTurnComplete()) or Game.IsProcessingMessages() then
		setupPleaseWaitToolTipString();			
		Controls.EndTurnText:SetText( pleaseWaitString );
		return;
	end
	
	local strEndTurnMessage;
	local strButtonToolTip;
	local buttonDisabled;
	local iFlashingState = NO_FLASHING;	
	
	local EndTurnBlockingType = player:GetEndTurnBlockingType();
	--print("EndTurnBlockingType " .. EndTurnBlockingType);
	if (EndTurnBlockingType == EndTurnBlockingTypes.ENDTURN_BLOCKING_POLICY) then
		--print("Choose Policy");
		strEndTurnMessage = choosePolicyString;
		if (Game.IsOption(GameOptionTypes.GAMEOPTION_POLICY_SAVING)) then
			strButtonToolTip = choosePolicyDismissTooltipString;
		else
			strButtonToolTip = choosePolicyTooltipString;
		end
		buttonDisabled = false;
		iFlashingState = FLASHING_END_TURN;
	elseif (EndTurnBlockingType == EndTurnBlockingTypes.ENDTURN_BLOCKING_RESEARCH) then
		--print("Choose research");
		strEndTurnMessage = chooseResearchString;
		strButtonToolTip = chooseResearchTooltipString;
		buttonDisabled = false;
		iFlashingState = FLASHING_SCIENCE;
	elseif (EndTurnBlockingType == EndTurnBlockingTypes.ENDTURN_BLOCKING_FREE_TECH) then
		--print("Choose free tech");
		strEndTurnMessage = chooseFreeTechString;
		strButtonToolTip = chooseFreeTechTooltipString;
		buttonDisabled = false;
		iFlashingState = FLASHING_FREE_TECH;
	elseif (EndTurnBlockingType == EndTurnBlockingTypes.ENDTURN_BLOCKING_PRODUCTION) then
		--print("Choose production");
		strEndTurnMessage = chooseProductionString;
		strButtonToolTip = chooseProductionTooltipString;
		buttonDisabled = false;
		iFlashingState = FLASHING_PRODUCTION;
	elseif (EndTurnBlockingType == EndTurnBlockingTypes.ENDTURN_BLOCKING_UNITS) then
		--print("Skip unit's turn");
		strEndTurnMessage = unitNeedsOrdersString;
		strButtonToolTip = unitNeedsOrdersTooltipString;
		buttonDisabled = false;
	elseif (EndTurnBlockingType == EndTurnBlockingTypes.ENDTURN_BLOCKING_STACKED_UNITS) then
		strEndTurnMessage = moveStackedUnitString;
		strButtonToolTip = moveStackedUnitTooltipString;
		buttonDisabled = false;		
		iFlashingState = FLASHING_END_TURN;
	elseif (EndTurnBlockingType == EndTurnBlockingTypes.ENDTURN_BLOCKING_UNIT_NEEDS_ORDERS) then
		strEndTurnMessage = unitNeedsOrdersString;
		strButtonToolTip = unitNeedsOrdersTooltipString;
		buttonDisabled = false;		
		iFlashingState = FLASHING_END_TURN;				
	elseif (EndTurnBlockingType == EndTurnBlockingTypes.ENDTURN_BLOCKING_UNIT_PROMOTION) then
		strEndTurnMessage = unitPromotionString;
		strButtonToolTip = unitPromotionTooltipString;
		buttonDisabled = false;		
		iFlashingState = FLASHING_END_TURN;				
	elseif (EndTurnBlockingType == EndTurnBlockingTypes.ENDTURN_BLOCKING_CITY_RANGE_ATTACK) then
		strEndTurnMessage = cityRangeAttackString;
		strButtonToolTip = cityRangeAttackTooltipString;
		buttonDisabled = false;		
		iFlashingState = FLASHING_END_TURN;				
	elseif (EndTurnBlockingType == EndTurnBlockingTypes.ENDTURN_BLOCKING_DIPLO_VOTE) then
		--print("Diplo Vote");
		strEndTurnMessage = diploVoteString;
		strButtonToolTip = diploVoteTooltipString;
		buttonDisabled = false;
		iFlashingState = FLASHING_END_TURN;
	elseif (EndTurnBlockingType == EndTurnBlockingTypes.ENDTURN_BLOCKING_FREE_ITEMS) then
		
		
		local blockingNotificationIndex = player:GetEndTurnBlockingNotificationIndex();
					
		local numNotifications = player:GetNumNotifications();
		for i = 0, numNotifications - 1	do
			if (player:GetNotificationIndex(i) == blockingNotificationIndex) then
				strEndTurnMessage = player:GetNotificationSummaryStr(i);
				strButtonToolTip =  player:GetNotificationStr(i);
			end
		end
		
		buttonDisabled = false;
		iFlashingState = FLASHING_PRODUCTION;
		
	elseif (EndTurnBlockingType == EndTurnBlockingTypes.ENDTURN_BLOCKING_FREE_POLICY) then
		--print("Choose free policy");
		strEndTurnMessage = Locale.ConvertTextKey("TXT_KEY_CHOOSE_POLICY");
		strButtonToolTip = Locale.ConvertTextKey("TXT_KEY_NOTIFICATION_FREE_POLICY");
		buttonDisabled = false;
		iFlashingState = FLASHING_PRODUCTION;
	elseif (EndTurnBlockingType == EndTurnBlockingTypes.ENDTURN_BLOCKING_FOUND_PANTHEON) then
		strEndTurnMessage = Locale.ConvertTextKey("TXT_KEY_NOTIFICATION_SUMMARY_ENOUGH_FAITH_FOR_PANTHEON");
		strButtonToolTip = Locale.ConvertTextKey("TXT_KEY_NOTIFICATION_ENOUGH_FAITH_FOR_PANTHEON");
		buttonDisabled = false;
		iFlashingState = FLASHING_PRODUCTION;	
	elseif (EndTurnBlockingType == EndTurnBlockingTypes.ENDTURN_BLOCKING_FOUND_RELIGION) then
		strEndTurnMessage = Locale.ConvertTextKey("TXT_KEY_NOTIFICATION_SUMMARY_FOUND_RELIGION");
		strButtonToolTip = Locale.ConvertTextKey("TXT_KEY_NOTIFICATION_FOUND_RELIGION");
		buttonDisabled = false;
		iFlashingState = FLASHING_PRODUCTION;	
	elseif (EndTurnBlockingType == EndTurnBlockingTypes.ENDTURN_BLOCKING_ENHANCE_RELIGION) then
		strEndTurnMessage = Locale.ConvertTextKey("TXT_KEY_NOTIFICATION_SUMMARY_ENHANCE_RELIGION");
		strButtonToolTip = Locale.ConvertTextKey("TXT_KEY_NOTIFICATION_ENHANCE_RELIGION");
		buttonDisabled = false;
		iFlashingState = FLASHING_PRODUCTION;
	elseif (EndTurnBlockingType == EndTurnBlockingTypes.ENDTURN_BLOCKING_STEAL_TECH) then
		strEndTurnMessage = Locale.ConvertTextKey("TXT_KEY_NOTIFICATION_SPY_STEAL_BLOCKING");
		strButtonToolTip = Locale.ConvertTextKey("TXT_KEY_NOTIFICATION_SPY_STEAL_BLOCKING_TT");
		buttonDisabled = false;
		iFlashingState = FLASHING_FREE_TECH;
	elseif (EndTurnBlockingType == EndTurnBlockingTypes.ENDTURN_BLOCKING_MAYA_LONG_COUNT) then
		strEndTurnMessage = Locale.ConvertTextKey("TXT_KEY_NOTIFICATION_MAYA_LONG_COUNT");
		strButtonToolTip = Locale.ConvertTextKey("TXT_KEY_NOTIFICATION_MAYA_LONG_COUNT_TT");
		buttonDisabled = false;
		iFlashingState = FLASHING_FREE_TECH;
	elseif (EndTurnBlockingType == EndTurnBlockingTypes.ENDTURN_BLOCKING_FAITH_GREAT_PERSON) then
		strEndTurnMessage = Locale.ConvertTextKey("TXT_KEY_NOTIFICATION_FAITH_GREAT_PERSON");
		strButtonToolTip = Locale.ConvertTextKey("TXT_KEY_NOTIFICATION_FAITH_GREAT_PERSON_TT");
		buttonDisabled = false;
		iFlashingState = FLASHING_FREE_TECH;
	else
		--print("None of the states match");
		if UI.WaitingForRemotePlayers() then
			strEndTurnMessage = waitForPlayersString;
			strButtonToolTip = waitForPlayersTooltipString;
			buttonDisabled = true;
		else
			strEndTurnMessage = nextTurnString;
			
			if (not OptionsManager.IsNoBasicHelp()) then
				strButtonToolTip = nextTurnTooltipString;
			else
				strButtonToolTip = "";
			end
			
			buttonDisabled = false;
			iFlashingState = FLASHING_END_TURN;
		end		
	end

	Controls.EndTurnButton:SetDisabled( buttonDisabled );
	Controls.EndTurnText:SetText( strEndTurnMessage );
	Controls.EndTurnButton:SetToolTipString( strButtonToolTip );
	
	SetEndTurnFlashing(iFlashingState);
end
Events.SerialEventEndTurnDirty.Add( OnEndTurnDirty );

OnEndTurnDirty();

-----------------------------------------------------
function OnEndTurnBlockingChanged(ePrevEndTurnBlockingType, eNewEndTurnBlockingType)
	
	local pPlayer = Players[Game.GetActivePlayer()];
	if (pPlayer ~= nil) then
		if pPlayer:IsTurnActive() then
		
			-- If they have auto-unit-cycling off, then don't change the selection.
			if (not OptionsManager.GetAutoUnitCycle()) then
				return;
			end
			
			local pSelectedUnit = UI.GetHeadSelectedUnit();
			if (pSelectedUnit ~= nil) then
				if (not pSelectedUnit:IsAutomated() and not pSelectedUnit:IsDelayedDeath() and pSelectedUnit:IsReadyToMove()) then
					return;
				end
			end
			
			-- GetFirstReadyUnit can return a unit that has automation and we don't want to select and center on that, manually look for a unit		
			for pUnit in pPlayer:Units() do
				if (pUnit ~= nil) then
					if (not pUnit:IsAutomated() and not pUnit:IsDelayedDeath() and pUnit:IsReadyToMove()) then
						local pPlot = pUnit:GetPlot();
						UI.LookAt(pPlot, 0);
						UI.SelectUnit(pUnit);
						return;
					end
				end
			end
		end
	end
end
Events.EndTurnBlockingChanged.Add( OnEndTurnBlockingChanged );

-------------------------------------------------
-- End Turn Timer Handler
-------------------------------------------------
function OnEndTurnTimerUpdate(percentComplete)
	Controls.EndTurnTimeMeter:SetPercents( percentComplete, percentComplete );
	timeLeft = math.ceil(getEndTurnTimerLength() - (getEndTurnTimerLength() * percentComplete));
	if timeLeft < 1 then
		timeLeft = 0;
	end
	Controls.TimerCountDown:SetText(timeLeft);
end
Events.EndTurnTimerUpdate.Add(OnEndTurnTimerUpdate);

-------------------------------------------------
-- Player changed handler
-------------------------------------------------
function OnPlayerChangedEvent()
	if not Controls.EndTurnTimeMeter:IsHidden() then
		OnEndTurnTimerUpdate(0);
	end
end
Events.GameplaySetActivePlayer.Add( OnPlayerChangedEvent );

-------------------------------------------------------------------------
-- AI player's turn
-------------------------------------------------------------------------
function OnAITurnStart()
	-- Make sure the turn timer is hidden, the AI processing UI is in the same location
	Controls.EndTurnTimerButton:SetHide( true );
end
if Events.AIProcessingStartedForPlayer ~= nil then
    Events.AIProcessingStartedForPlayer.Add( OnAITurnStart );
end
-------------------------------------------------------------------------
-- Human player's turn
-------------------------------------------------------------------------
function OnActivePlayerTurnStart()
	-- Show the turn timer if needed
	Controls.EndTurnTimerButton:SetHide(not showEndTurnTimer());
end
Events.ActivePlayerTurnStart.Add( OnActivePlayerTurnStart );

-------------------------------------------------
function ShowHide( isHide )
	Controls.EndTurnTimerButton:SetHide(not showEndTurnTimer());
end
ContextPtr:SetShowHideHandler( ShowHide );

-------------------------------------------------
function OnEndTurnTimerClicked()
	UI.interruptTurnTimer();
end
Controls.EndTurnTimerButton:RegisterCallback( Mouse.eLClick, OnEndTurnTimerClicked );
