----------------------------------------------------------------
----------------------------------------------------------------
include("IconSupport");
include("InstanceManager");
include("GameplayUtilities");
include("InfoTooltipInclude");

local g_InstanceManager = InstanceManager:new( "Leader Button", "Button", Controls.LeaderStack );
local g_iAIPlayer = -1;
local g_iAITeam = -1;
local g_CurrentTopic = -1;

local g_bCanGoBack = true;

local g_DiploUIState = -1;
local g_iDiploData = -1;

-- Discussion modes
local g_iModeDiscussionRoot = 0;
--local g_iModeDiscussionWorkAgainst = 1;
local g_iModeDiscussionWar = 1;
local g_iInvokedDiscussionMode = g_iModeDiscussionRoot;

local g_strDefaultDiscussionText = Locale.ConvertTextKey("TXT_KEY_DIPLOMACY_DISCUSS_WHAT");

local offsetOfString = 32;
local bonusPadding = 16
local innerFrameWidth = 554;
local outerFrameWidth = 550;
local offsetsBetweenFrames = 4;

local oldCursor = 0;

----------------------------------------------------------------        
-- LEADER MESSAGE HANDLER
----------------------------------------------------------------        
function LeaderMessageHandler( iPlayer, iDiploUIState, szLeaderMessage, iAnimationAction, iData1 )
    
    g_DiploUIState = iDiploUIState;
    g_iDiploData = iData1;
    
	g_iAIPlayer = iPlayer;
	g_iAITeam = Players[g_iAIPlayer]:GetTeam();
	
	local pAIPlayer = Players[g_iAIPlayer];
	local iActivePlayer = Game.GetActivePlayer();
	
	local pActiveTeam = Teams[Game.GetActiveTeam()];
	local pAITeam = Teams[g_iAITeam];
	
	local activePlayer = Players[iActivePlayer];
	
	local themCivType = pAIPlayer:GetCivilizationType();
	local themCivInfo = GameInfo.Civilizations[themCivType];
	CivIconHookup( g_iAIPlayer, 64, Controls.ThemSymbolShadow, Controls.CivIconBG, Controls.CivIconShadow, false, true );
    
    local player = Players[g_iAIPlayer];
	local strTitleText = GameplayUtilities.GetLocalizedLeaderTitle(player);
	Controls.TitleText:SetText(strTitleText);
	
	local otherLeader = GameInfo.Leaders[player:GetLeaderType()];

	if MapModData.InfoAddict then
		Controls.InfoAddictButton:SetHide(false);
	else
		Controls.InfoAddictButton:SetHide(true);
	end
	
	-- Mood
	local iApproach = Players[iActivePlayer]:GetApproachTowardsUsGuess(g_iAIPlayer);
	local strMoodText = Locale.ConvertTextKey("TXT_KEY_EMOTIONLESS");
	
	if (pActiveTeam:IsAtWar(g_iAITeam)) then
		strMoodText = Locale.ConvertTextKey( "TXT_KEY_DIPLO_MAJOR_CIV_DIPLO_STATE_WAR" );
	elseif (Players[g_iAIPlayer]:IsDenouncingPlayer(iActivePlayer)) then
		strMoodText = Locale.ConvertTextKey( "TXT_KEY_DIPLO_MAJOR_CIV_DIPLO_STATE_DENOUNCING" );	
	else
		if( iApproach == MajorCivApproachTypes.MAJOR_CIV_APPROACH_WAR ) then
			strMoodText = Locale.ConvertTextKey( "TXT_KEY_WAR_CAPS" );
		elseif( iApproach == MajorCivApproachTypes.MAJOR_CIV_APPROACH_HOSTILE ) then
			strMoodText = Locale.ConvertTextKey( "TXT_KEY_DIPLO_MAJOR_CIV_DIPLO_STATE_HOSTILE", otherLeader.Description );
		elseif( iApproach == MajorCivApproachTypes.MAJOR_CIV_APPROACH_GUARDED ) then
			strMoodText = Locale.ConvertTextKey( "TXT_KEY_DIPLO_MAJOR_CIV_DIPLO_STATE_GUARDED", otherLeader.Description  );
		elseif( iApproach == MajorCivApproachTypes.MAJOR_CIV_APPROACH_AFRAID ) then
			strMoodText = Locale.ConvertTextKey( "TXT_KEY_DIPLO_MAJOR_CIV_DIPLO_STATE_AFRAID", otherLeader.Description  );
		elseif( iApproach == MajorCivApproachTypes.MAJOR_CIV_APPROACH_FRIENDLY ) then
			strMoodText = Locale.ConvertTextKey( "TXT_KEY_DIPLO_MAJOR_CIV_DIPLO_STATE_FRIENDLY", otherLeader.Description  );
		elseif( iApproach == MajorCivApproachTypes.MAJOR_CIV_APPROACH_NEUTRAL ) then
			strMoodText = Locale.ConvertTextKey( "TXT_KEY_DIPLO_MAJOR_CIV_DIPLO_STATE_NEUTRAL", otherLeader.Description  );
		end
	end
	
	Controls.MoodText:SetText(strMoodText);
	
	local strMoodInfo = GetMoodInfo(g_iAIPlayer);
	Controls.MoodText:SetToolTipString(strMoodInfo);
	
	local bMyMode = false;
	
	local strExtra = "";
	
	-- Are we in Discussion Mode?
	if (iDiploUIState == DiploUIStateTypes.DIPLO_UI_STATE_DISCUSS_HUMAN_INVOKED) then
		bMyMode = true;
	elseif (iDiploUIState == DiploUIStateTypes.DIPLO_UI_STATE_BLANK_DISCUSSION_RETURN_TO_ROOT) then
		bMyMode = true;
	elseif (iDiploUIState == DiploUIStateTypes.DIPLO_UI_STATE_BLANK_DISCUSSION) then
		bMyMode = true;
	elseif (iDiploUIState == DiploUIStateTypes.DIPLO_UI_STATE_BLANK_DISCUSSION_MEAN_HUMAN) then
		bMyMode = true;
	elseif (iDiploUIState == DiploUIStateTypes.DIPLO_UI_STATE_BLANK_DISCUSSION_MEAN_AI) then
		bMyMode = true;
	elseif (iDiploUIState == DiploUIStateTypes.DIPLO_UI_STATE_AI_DECLARED_WAR) then
		-- Add text to this string
		strExtra = "[NEWLINE][NEWLINE](" .. Locale.ConvertTextKey("TXT_KEY_WAR_DECLARED") .. ")";
		bMyMode = true;
	elseif (iDiploUIState == DiploUIStateTypes.DIPLO_UI_STATE_DISCUSS_AGGRESSIVE_MILITARY_WARNING) then
		bMyMode = true;
	elseif (iDiploUIState == DiploUIStateTypes.DIPLO_UI_STATE_DISCUSS_I_ATTACKED_YOUR_MINOR_CIV) then
		bMyMode = true;
	elseif (iDiploUIState == DiploUIStateTypes.DIPLO_UI_STATE_DISCUSS_PROTECT_MINOR_CIV) then
		bMyMode = true;
	elseif (iDiploUIState == DiploUIStateTypes.DIPLO_UI_STATE_DISCUSS_YOU_ATTACKED_MINOR_CIV) then
		bMyMode = true;
	elseif (iDiploUIState == DiploUIStateTypes.DIPLO_UI_STATE_DISCUSS_YOU_KILLED_MINOR_CIV) then
		bMyMode = true;
	elseif (iDiploUIState == DiploUIStateTypes.DIPLO_UI_STATE_DISCUSS_YOU_EXPANSION_SERIOUS_WARNING) then
		bMyMode = true;
	elseif (iDiploUIState == DiploUIStateTypes.DIPLO_UI_STATE_DISCUSS_YOU_EXPANSION_WARNING) then
		bMyMode = true;
	elseif (iDiploUIState == DiploUIStateTypes.DIPLO_UI_STATE_DISCUSS_YOU_PLOT_BUYING_SERIOUS_WARNING) then
		bMyMode = true;
	elseif (iDiploUIState == DiploUIStateTypes.DIPLO_UI_STATE_DISCUSS_YOU_PLOT_BUYING_WARNING) then
		bMyMode = true;
	elseif (iDiploUIState == DiploUIStateTypes.DIPLO_UI_STATE_DISCUSS_WORK_WITH_US) then
		bMyMode = true;
	elseif (iDiploUIState == DiploUIStateTypes.DIPLO_UI_STATE_DISCUSS_WORK_AGAINST_SOMEONE) then
		bMyMode = true;
	elseif (iDiploUIState == DiploUIStateTypes.DIPLO_UI_STATE_DISCUSS_COOP_WAR) then
		bMyMode = true;
	elseif (iDiploUIState == DiploUIStateTypes.DIPLO_UI_STATE_DISCUSS_COOP_WAR_TIME) then
		bMyMode = true;
	elseif (iDiploUIState == DiploUIStateTypes.DIPLO_UI_STATE_DISCUSS_PLAN_RESEARCH_AGREEMENT) then
		bMyMode = true;
	elseif (iDiploUIState == DiploUIStateTypes.DIPLO_UI_STATE_DISCUSS_AI_REQUEST_DENOUNCE) then
		bMyMode = true;
	end
    
    if (bMyMode) then
    
        if( ContextPtr:IsHidden() ) then
    	    UIManager:QueuePopup( ContextPtr, PopupPriority.LeaderDiscuss );
	    end
		
		--print("Handling LeaderMessage: " .. iDiploUIState .. ", ".. szLeaderMessage .. strExtra);
		
		Controls.LeaderSpeech:SetText( szLeaderMessage .. strExtra );
		
		-- Resize the height of the box to fit the text
		local contentSize = Controls.LeaderSpeech:GetSize().y + offsetOfString + bonusPadding;
		Controls.LeaderSpeechBorderFrame:SetSizeY( contentSize );
		Controls.LeaderSpeechFrame:SetSizeY( contentSize - offsetsBetweenFrames );
		
		local strButton1Text = -1;
		local strButton2Text = -1;
		local strButton3Text = -1;
		local strButton4Text = -1;
		
		local strButton1Tooltip = "";
		local strButton2Tooltip = "";
		local strButton3Tooltip = "";
		local strButton4Tooltip = "";
		
		-- Make sure none of the buttons start disabled
 		Controls.Button1:SetDisabled(false);
 		Controls.Button2:SetDisabled(false);
 		Controls.Button3:SetDisabled(false);
 		Controls.Button4:SetDisabled(false);
		
		local bHideBackButton = false;
	    
		-- Human invoked discussion
		if (g_DiploUIState == DiploUIStateTypes.DIPLO_UI_STATE_DISCUSS_HUMAN_INVOKED) then
			
			-- Discussion Root Mode
			if (g_iInvokedDiscussionMode == g_iModeDiscussionRoot) then
				
				-- Ask the AI player to not settle nearby
				if (not pAIPlayer:IsDontSettleMessageTooSoon(iActivePlayer)) then
					strButton1Text = Locale.ConvertTextKey( "TXT_KEY_DIPLO_DISCUSS_MESSAGE_DONT_SETTLE" );
				end
				
				-- If we're teammates, there's no need to work together or against anyone
				if (pAIPlayer:GetTeam() ~= Players[iActivePlayer]:GetTeam()) then
					-- Ask the AI player to work together
					if (not pAIPlayer:IsDoFMessageTooSoon(iActivePlayer)) and (not pAIPlayer:IsDoF(iActivePlayer)) then  --Sneaks
						strButton2Text = Locale.ConvertTextKey( "TXT_KEY_DIPLO_DISCUSS_MESSAGE_DEC_FRIENDSHIP" );
						strButton2Tooltip = Locale.ConvertTextKey( "TXT_KEY_DIPLO_DISCUSS_MESSAGE_DEC_FRIENDSHIP_TT" );
					-- Tell the player we're done working with him
					--elseif (pAIPlayer:IsDoF(iActivePlayer)) then
						--strButton2Text = Locale.ConvertTextKey( "TXT_KEY_DIPLO_DISCUSS_MESSAGE_END_WORK_WITH_US" );
					end
					
					local strLeaderName;
					if(pAIPlayer:GetNickName() ~= "" and Game:IsNetworkMultiPlayer()) then
						strLeaderName = pAIPlayer:GetNickName();
					else
						strLeaderName = pAIPlayer:GetName();
					end
					
					if(not activePlayer:IsDenouncedPlayer(iPlayer)) then
						strButton3Text = Locale.ConvertTextKey( "TXT_KEY_DIPLO_DISCUSS_DENOUNCE", strLeaderName );
						strButton3Tooltip = Locale.ConvertTextKey( "TXT_KEY_DIPLO_DISCUSS_DENOUNCE_TT" );
		 			end
				end
		 		
				strButton4Text = Locale.ConvertTextKey( "TXT_KEY_DIPLO_DISCUSS_MESSAGE_DECLARE_WAR" );
		 		Controls.Button4:SetDisabled(true);
				
				-- Discussion buttons valid?
				for iPlayerLoop = 0, GameDefines.MAX_MAJOR_CIVS-1, 1 do
					
					-- Working Against button
					--if (IsWorkingAgainstThirdPartyPlayerValid(iPlayerLoop)) then
				 		--Controls.Button3:SetDisabled(false);
				 	--end
					
					-- War button
					if (IsWarAgainstThirdPartyPlayerValid(iPlayerLoop)) then
				 		Controls.Button4:SetDisabled(false);
				 	end
				end
			end
			
		-- Human did something mean, AI responded, and human responds in turn with fluff
		elseif (g_DiploUIState == DiploUIStateTypes.DIPLO_UI_STATE_BLANK_DISCUSSION_MEAN_HUMAN) then
			strButton1Text = Locale.ConvertTextKey( "TXT_KEY_DIPLO_DISCUSS_MESSAGE_SORRY" );
			strButton2Text = Locale.ConvertTextKey( "TXT_KEY_DIPLO_DISCUSS_MESSAGE_DEAL" );
			bHideBackButton = true;
			
		-- AI did something mean, and human responds in turn with fluff
		elseif (g_DiploUIState == DiploUIStateTypes.DIPLO_UI_STATE_BLANK_DISCUSSION_MEAN_AI) then
			strButton1Text = Locale.ConvertTextKey( "TXT_KEY_DIPLO_DISCUSS_MESSAGE_OKAY" );
			strButton2Text = Locale.ConvertTextKey( "TXT_KEY_DIPLO_DISCUSS_MESSAGE_YOULL_PAY" );
			bHideBackButton = true;
			
		-- AI declared war on us!
		elseif (g_DiploUIState == DiploUIStateTypes.DIPLO_UI_STATE_AI_DECLARED_WAR) then
			strButton1Text = Locale.ConvertTextKey( "TXT_KEY_DIPLO_DISCUSS_MESSAGE_OKAY" );
			strButton2Text = Locale.ConvertTextKey( "TXT_KEY_DIPLO_DISCUSS_MESSAGE_YOULL_PAY" );
			
			bHideBackButton = true;
			
		-- Human has Units on our borders
		elseif (g_DiploUIState == DiploUIStateTypes.DIPLO_UI_STATE_DISCUSS_AGGRESSIVE_MILITARY_WARNING) then
			strButton1Text = Locale.ConvertTextKey( "TXT_KEY_DIPLO_DISCUSS_WE_MEAN_NO_HARM" );
			strButton2Text = Locale.ConvertTextKey( "TXT_KEY_DIPLO_DISCUSS_TIME_TO_DIE" );
			bHideBackButton = true;
		-- AI attacked a Minor the Human is friends with
		elseif (g_DiploUIState == DiploUIStateTypes.DIPLO_UI_STATE_DISCUSS_I_ATTACKED_YOUR_MINOR_CIV) then
			strButton1Text = Locale.ConvertTextKey( "TXT_KEY_DIPLO_DISCUSS_NO_DIVIDE" );
			strButton2Text = Locale.ConvertTextKey( "TXT_KEY_DIPLO_DISCUSS_YOU_WILL_PAY" );
			bHideBackButton = true;
		-- Human attacked a Protected Minor
		elseif (g_DiploUIState == DiploUIStateTypes.DIPLO_UI_STATE_DISCUSS_YOU_ATTACKED_MINOR_CIV) then
			strButton1Text = Locale.ConvertTextKey( "TXT_KEY_DIPLO_DISCUSS_NOT_YOUR_BUSINESS" );
			strButton2Text = Locale.ConvertTextKey( "TXT_KEY_DIPLO_DISCUSS_WILL_WITHDRAW" );
			bHideBackButton = true;
		-- Human killed a Protected Minor
		elseif (g_DiploUIState == DiploUIStateTypes.DIPLO_UI_STATE_DISCUSS_YOU_KILLED_MINOR_CIV) then
			strButton1Text = Locale.ConvertTextKey( "TXT_KEY_DIPLO_DISCUSS_DONT_CARE" );
			strButton2Text = Locale.ConvertTextKey( "TXT_KEY_DIPLO_DISCUSS_OFFER_TO_APPEASE" );
			bHideBackButton = true;
		---- AI seriously warning human about his expansion
		elseif (g_DiploUIState == DiploUIStateTypes.DIPLO_UI_STATE_DISCUSS_YOU_EXPANSION_SERIOUS_WARNING) then
			strButton1Text = Locale.ConvertTextKey( "TXT_KEY_DIPLO_DISCUSS_MAKE_US" );
			strButton2Text = Locale.ConvertTextKey( "TXT_KEY_DIPLO_DISCUSS_OFFER_TO_APPEASE" );
			bHideBackButton = true;
		-- AI warning human about his expansion
		elseif (g_DiploUIState == DiploUIStateTypes.DIPLO_UI_STATE_DISCUSS_YOU_EXPANSION_WARNING) then
			strButton1Text = Locale.ConvertTextKey( "TXT_KEY_DIPLO_DISCUSS_SETTLE_WHAT_WE_PLEASE") ;
			strButton2Text = Locale.ConvertTextKey( "TXT_KEY_DIPLO_DISCUSS_SORRY_FOR_SETTLING") ;
			bHideBackButton = true;
		-- AI seriously warning human about his plot buying
		elseif (g_DiploUIState == DiploUIStateTypes.DIPLO_UI_STATE_DISCUSS_YOU_PLOT_BUYING_SERIOUS_WARNING) then
			strButton1Text = Locale.ConvertTextKey( "TXT_KEY_DIPLO_DISCUSS_CLAIM_WHAT_WE_WANT" );
			strButton2Text = Locale.ConvertTextKey( "TXT_KEY_DIPLO_DISCUSS_OFFER_TO_APPEASE" );
			bHideBackButton = true;
		-- AI warning human about his plot buying
		elseif (g_DiploUIState == DiploUIStateTypes.DIPLO_UI_STATE_DISCUSS_YOU_PLOT_BUYING_WARNING) then
			strButton1Text = Locale.ConvertTextKey( "TXT_KEY_DIPLO_DISCUSS_NOT_YOUR_BUSINESS" );
			strButton2Text = Locale.ConvertTextKey( "TXT_KEY_DIPLO_DISCUSS_SORRY_FOR_CLAIMING" );
			bHideBackButton = true;
		-- AI asking player to work with him
		elseif (g_DiploUIState == DiploUIStateTypes.DIPLO_UI_STATE_DISCUSS_WORK_WITH_US) then
			strButton1Text = Locale.ConvertTextKey( "TXT_KEY_DIPLO_DISCUSS_YES_WORK_TOGETHER" );
			strButton2Text = Locale.ConvertTextKey( "TXT_KEY_DIPLO_DISCUSS_NO_GO_IT_ALONE" );
			bHideBackButton = true;
		-- AI asking player to work against someone
		elseif (g_DiploUIState == DiploUIStateTypes.DIPLO_UI_STATE_DISCUSS_WORK_AGAINST_SOMEONE) then
			strButton1Text = Locale.ConvertTextKey( "TXT_KEY_DIPLO_DISCUSS_SORRY_NO_INTEREST" );
			strButton2Text = Locale.ConvertTextKey( "TXT_KEY_DIPLO_DISCUSS_HOW_DARE_YOU" );
			strButton3Text = Locale.ConvertTextKey( "TXT_KEY_DIPLO_DISCUSS_DO_WHAT_WE_CAN" );
			bHideBackButton = true;
		-- AI asking player to declare war against someone
		elseif (g_DiploUIState == DiploUIStateTypes.DIPLO_UI_STATE_DISCUSS_COOP_WAR) then
			strButton1Text = Locale.ConvertTextKey( "TXT_KEY_DIPLO_DISCUSS_SORRY_NO_INTEREST" );
			strButton2Text = Locale.ConvertTextKey( "TXT_KEY_DIPLO_DISCUSS_HOW_DARE_YOU" );
			strButton3Text = Locale.ConvertTextKey( "TXT_KEY_DIPLO_DISCUSS_COOP_WAR_SOON" );
			strButton4Text = Locale.ConvertTextKey( "TXT_KEY_DIPLO_DISCUSS_COOP_WAR_YES" );
			bHideBackButton = true;
		-- AI shows up saying it's time to declare war against someone
		elseif (g_DiploUIState == DiploUIStateTypes.DIPLO_UI_STATE_DISCUSS_COOP_WAR_TIME) then
			strButton1Text = Locale.ConvertTextKey( "TXT_KEY_DIPLO_DISCUSS_COOP_WAR_NOW" );
			strButton2Text = Locale.ConvertTextKey( "TXT_KEY_DIPLO_DISCUSS_CHANGED_MIND" );
			bHideBackButton = true;
		-- AI asking player to make RA in the future - NOT CURRENTLY IN USE
		elseif (g_DiploUIState == DiploUIStateTypes.DIPLO_UI_STATE_DISCUSS_PLAN_RESEARCH_AGREEMENT) then
			strButton1Text = Locale.ConvertTextKey( "TXT_KEY_DIPLO_DISCUSS_YES_LET_US_PREPARE" );
			strButton2Text = Locale.ConvertTextKey( "TXT_KEY_DIPLO_DISCUSS_SORRY_OTHER_PLANS" );
			bHideBackButton = true;
		-- AI asking player to denounce someone
		elseif (g_DiploUIState == DiploUIStateTypes.DIPLO_UI_STATE_DISCUSS_AI_REQUEST_DENOUNCE) then
			strButton1Text = Locale.ConvertTextKey( "TXT_KEY_DIPLO_DISCUSS_DO_WHAT_WE_CAN" );
			strButton2Text = Locale.ConvertTextKey( "TXT_KEY_DIPLO_DISCUSS_SORRY_NO_INTEREST" );
			bHideBackButton = true;
		end
	    
		-- Buttons: change text or hide
		if (strButton1Text == -1) then
	 		Controls.Button1:SetHide(true);
		else
	 		Controls.Button1Label:SetText(strButton1Text);		
	 		Controls.Button1:SetHide(false);
	 		Controls.Button1:SetToolTipString(strButton1Tooltip);
		end
	    
		if (strButton2Text == -1) then
	 		Controls.Button2:SetHide(true);
		else
	 		Controls.Button2Label:SetText(strButton2Text);		
	 		Controls.Button2:SetHide(false);
	 		Controls.Button2:SetToolTipString(strButton2Tooltip);
		end

		if (strButton3Text == -1) then
	 		Controls.Button3:SetHide(true);
		else
	 		Controls.Button3Label:SetText(strButton3Text);		
	 		Controls.Button3:SetHide(false);
	 		Controls.Button3:SetToolTipString(strButton3Tooltip);
		end

		if (strButton4Text == -1) then
	 		Controls.Button4:SetHide(true);
		else
	 		Controls.Button4Label:SetText(strButton4Text);		
	 		Controls.Button4:SetHide(false);
	 		Controls.Button4:SetToolTipString(strButton4Tooltip);
		end

		-- Some situations we force the human to answer - he can't back out
		if (bHideBackButton) then
	 		Controls.BackButton:SetHide(true);
	 		g_bCanGoBack = false;
		else
	 		Controls.BackButton:SetHide(false);
	 		g_bCanGoBack = true;
		end
		
	end
    
end
Events.AILeaderMessage.Add( LeaderMessageHandler );


----------------------------------------------------------------
-- BACK
----------------------------------------------------------------
function OnBack(bForce)
    
    if (g_bCanGoBack or bForce) then
		
	    UIManager:DequeuePopup( ContextPtr );
		Controls.LeaderPanel:SetHide( true );
	    
    	UI.RequestLeaveLeader();
	end

end
Controls.BackButton:RegisterCallback( Mouse.eLClick, OnBack );


----------------------------------------------------------------        
-- SHOW/HIDE
----------------------------------------------------------------        
local bEverShown = false;
function OnShowHide( bHide, bIsInit )
	
	if( not bIsInit ) then
    	-- Showing Screen
    	if (not bHide) then
    		oldCursor = UIManager:SetUICursor(0); -- make sure we start with the default cursor
    		
    		bEverShown = true;
    	    
    		local pPlayer = Players[Game.GetActivePlayer()];
    		local pTeam = Teams[pPlayer:GetTeam()];
    		
    		local pThirdPartyPlayer;
    		local iThirdPartyTeam;
    		
    		--Controls.LeaderSpeech:SetText(g_strDefaultDiscussionText);		-- This will be overwritten immediately by a Leader Message
     		--Controls.Button1:SetHide(true);
     		--Controls.Button2:SetHide(true);
     		--Controls.Button3:SetHide(true);
     		--Controls.Button4:SetHide(true);
    		
    		--------------------------------------------------------------------------
    		-- THE CODE AFTER THIS LINE SHOULD BE REWRITTEN - IT IS OBSOLETE
    		--------------------------------------------------------------------------
    		
    		local iNumPlayers = 0;
    		
    		-- Loop through all the Majors the active player knows
    		for iPlayerLoop = 0, GameDefines.MAX_MAJOR_CIVS-1, 1 do
    			
    			pThirdPartyPlayer = Players[iPlayerLoop];
    			iThirdPartyTeam = pThirdPartyPlayer:GetTeam();
    			
    			-- Valid player? - Can't be us and has to be alive
    			if (pPlayer:GetTeam() ~= iThirdPartyTeam and pThirdPartyPlayer:IsAlive()) then
    				
    				-- Can't be the guy we're already talking to
    --				if (g_iAITeam ~= iThirdPartyTeam) then
    					
    					-- Met this player?
    					if (pTeam:IsHasMet(iThirdPartyTeam)) then
    						iNumPlayers = iNumPlayers + 1;
    					end
    --				end
    			end
    		end
    		
    	-- Hiding Screen
    	else
    		UIManager:SetUICursor(oldCursor); -- make sure we retrun the cursor to the previous state
    		
    		g_bCanGoBack	= true;		
    		g_DiploUIState = -1;
    		g_iDiploData = -1;
    		
    		-- Reset to Default mode
    		g_iInvokedDiscussionMode = g_iModeDiscussionRoot;
    	end
	end
	
end
ContextPtr:SetShowHideHandler( OnShowHide );


----------------------------------------------------------------
-- Key Down Processing
----------------------------------------------------------------
function InputHandler( uiMsg, wParam, lParam )
    if( uiMsg == KeyEvents.KeyDown )
    then
        if( wParam == Keys.VK_ESCAPE or wParam == Keys.VK_RETURN ) then
			
			if(Controls.DenounceConfirm:IsHidden()) then
				-- Talk-about-a-leader mode
				if (g_iInvokedDiscussionMode ~= g_iModeDiscussionRoot) then
					OnCloseLeaderPanelButton();
					
				-- In base discussion mode, so exit
				else
					OnBack();
				end
			else
				OnDenounceConfirmNo();
			end
	
			
			
        end
    end
    return true;
end
ContextPtr:SetInputHandler( InputHandler );


----------------------------------------------------------------
-- BUTTON 1
----------------------------------------------------------------
function OnButton1()
    g_InstanceManager:ResetInstances();
    	
	local pPlayer = Players[Game.GetActivePlayer()];
	local pTeam = Teams[pPlayer:GetTeam()];
	
	local iButtonID = 1;	-- This format is also used in DiploTrade.lua in the OnBack() function.  If functionality here changes it should be updated there as well.
        
    -- Human-invoked discussion
	if (g_DiploUIState == DiploUIStateTypes.DIPLO_UI_STATE_DISCUSS_HUMAN_INVOKED) then
		if (g_iInvokedDiscussionMode == g_iModeDiscussionRoot) then
			-- Ask the AI player not to settle nearby
			Game.DoFromUIDiploEvent( FromUIDiploEventTypes.FROM_UI_DIPLO_EVENT_HUMAN_DISCUSSION_DONT_SETTLE, g_iAIPlayer, 0, 0 );
		end
        
    -- Fluff discussion mode
	elseif (g_DiploUIState == DiploUIStateTypes.DIPLO_UI_STATE_BLANK_DISCUSSION_MEAN_HUMAN) then
	    OnBack(true);
    -- Fluff discussion mode 2
	elseif (g_DiploUIState == DiploUIStateTypes.DIPLO_UI_STATE_BLANK_DISCUSSION_MEAN_AI) then
	    OnBack(true);
    -- AI declared war on us
	elseif (g_DiploUIState == DiploUIStateTypes.DIPLO_UI_STATE_AI_DECLARED_WAR) then
	    OnBack(true);
    
    -- AI seriously warning us about expansion - we tell him we mean no harm
	elseif (g_DiploUIState == DiploUIStateTypes.DIPLO_UI_STATE_DISCUSS_AGGRESSIVE_MILITARY_WARNING) then
	    Game.DoFromUIDiploEvent( FromUIDiploEventTypes.FROM_UI_DIPLO_EVENT_AGGRESSIVE_MILITARY_WARNING_RESPONSE, g_iAIPlayer, iButtonID, 0 );
    
    -- AI told us he attacked a Minor we're friends with - we forgive him
	elseif (g_DiploUIState == DiploUIStateTypes.DIPLO_UI_STATE_DISCUSS_I_ATTACKED_YOUR_MINOR_CIV) then
	    Game.DoFromUIDiploEvent( FromUIDiploEventTypes.FROM_UI_DIPLO_EVENT_I_ATTACKED_YOUR_MINOR_CIV_RESPONSE, g_iAIPlayer, iButtonID, 0 );

    -- AI warned us about attacking a Minor - we tell him to go away
	elseif (g_DiploUIState == DiploUIStateTypes.DIPLO_UI_STATE_DISCUSS_YOU_ATTACKED_MINOR_CIV) then
	    Game.DoFromUIDiploEvent( FromUIDiploEventTypes.FROM_UI_DIPLO_EVENT_ATTACKED_MINOR_RESPONSE, g_iAIPlayer, iButtonID, 0 );
    
    -- AI scolded us for killing a Minor - we tell him to go away
	elseif (g_DiploUIState == DiploUIStateTypes.DIPLO_UI_STATE_DISCUSS_YOU_KILLED_MINOR_CIV) then
	    Game.DoFromUIDiploEvent( FromUIDiploEventTypes.FROM_UI_DIPLO_EVENT_KILLED_MINOR_RESPONSE, g_iAIPlayer, iButtonID, 0 );
    
    -- AI seriously warning us about expansion - we tell him to go away
	elseif (g_DiploUIState == DiploUIStateTypes.DIPLO_UI_STATE_DISCUSS_YOU_EXPANSION_SERIOUS_WARNING) then
	    Game.DoFromUIDiploEvent( FromUIDiploEventTypes.FROM_UI_DIPLO_EVENT_EXPANSION_SERIOUS_WARNING_RESPONSE, g_iAIPlayer, iButtonID, 0 );
    
    -- AI warning us about expansion - we tell him to go away
	elseif (g_DiploUIState == DiploUIStateTypes.DIPLO_UI_STATE_DISCUSS_YOU_EXPANSION_WARNING) then
	    Game.DoFromUIDiploEvent( FromUIDiploEventTypes.FROM_UI_DIPLO_EVENT_EXPANSION_WARNING_RESPONSE, g_iAIPlayer, iButtonID, 0 );
    
    -- AI seriously warning us about plot buying - we tell him to go away
	elseif (g_DiploUIState == DiploUIStateTypes.DIPLO_UI_STATE_DISCUSS_YOU_PLOT_BUYING_SERIOUS_WARNING) then
	    Game.DoFromUIDiploEvent( FromUIDiploEventTypes.FROM_UI_DIPLO_EVENT_PLOT_BUYING_SERIOUS_WARNING_RESPONSE, g_iAIPlayer, iButtonID, 0 );
    
    -- AI warning us about plot buying - we tell him to go away
	elseif (g_DiploUIState == DiploUIStateTypes.DIPLO_UI_STATE_DISCUSS_YOU_PLOT_BUYING_WARNING) then
	    Game.DoFromUIDiploEvent( FromUIDiploEventTypes.FROM_UI_DIPLO_EVENT_PLOT_BUYING_WARNING_RESPONSE, g_iAIPlayer, iButtonID, 0 );
    
    -- AI asking to work together - we agree
	elseif (g_DiploUIState == DiploUIStateTypes.DIPLO_UI_STATE_DISCUSS_WORK_WITH_US) then
	    Game.DoFromUIDiploEvent( FromUIDiploEventTypes.FROM_UI_DIPLO_EVENT_WORK_WITH_US_RESPONSE, g_iAIPlayer, iButtonID, 0 );
    
    -- AI asking to work against someone - we tell him sorry
	elseif (g_DiploUIState == DiploUIStateTypes.DIPLO_UI_STATE_DISCUSS_WORK_AGAINST_SOMEONE) then
		local iAgainstPlayer = g_iDiploData;	-- This should be set when receiving the leader message
	    Game.DoFromUIDiploEvent( FromUIDiploEventTypes.FROM_UI_DIPLO_EVENT_WORK_AGAINST_SOMEONE_RESPONSE, g_iAIPlayer, iButtonID, iAgainstPlayer );
        
    -- AI asking to declare war against someone - we say no
	elseif (g_DiploUIState == DiploUIStateTypes.DIPLO_UI_STATE_DISCUSS_COOP_WAR) then
		local iAgainstPlayer = g_iDiploData;	-- This should be set when receiving the leader message
	    Game.DoFromUIDiploEvent( FromUIDiploEventTypes.FROM_UI_DIPLO_EVENT_COOP_WAR_RESPONSE, g_iAIPlayer, iButtonID, iAgainstPlayer );
	    
    -- AI asking to declare war against someone NOW - we agree
	elseif (g_DiploUIState == DiploUIStateTypes.DIPLO_UI_STATE_DISCUSS_COOP_WAR_TIME) then
		local iAgainstPlayer = g_iDiploData;	-- This should be set when receiving the leader message
	    Game.DoFromUIDiploEvent( FromUIDiploEventTypes.FROM_UI_DIPLO_EVENT_COOP_WAR_NOW_RESPONSE, g_iAIPlayer, iButtonID, iAgainstPlayer );
    
    -- AI asking to make RA in the future - we agree
	elseif (g_DiploUIState == DiploUIStateTypes.DIPLO_UI_STATE_DISCUSS_PLAN_RESEARCH_AGREEMENT) then
	    Game.DoFromUIDiploEvent( FromUIDiploEventTypes.FROM_UI_DIPLO_EVENT_PLAN_RA_RESPONSE, g_iAIPlayer, iButtonID, 0 );
    
    -- AI asking to denounce another player - we agree
	elseif (g_DiploUIState == DiploUIStateTypes.DIPLO_UI_STATE_DISCUSS_AI_REQUEST_DENOUNCE) then
		local iAgainstPlayer = g_iDiploData;	-- This should be set when receiving the leader message
	    Game.DoFromUIDiploEvent( FromUIDiploEventTypes.FROM_UI_DIPLO_EVENT_AI_REQUEST_DENOUNCE_RESPONSE, g_iAIPlayer, iButtonID, iAgainstPlayer );
		
    -- Default mode - TBR
    elseif (g_DiploUIState == DiploUIStateTypes.DIPLO_UI_STATE_DEFAULT_ROOT) then
		
		local pThirdPartyPlayer;
		local iThirdPartyTeam;
		
		local iNumPlayers = 0;
		
		-- Loop through all the Majors the active player knows
		for iPlayerLoop = 0, GameDefines.MAX_MAJOR_CIVS-1, 1 do
			
			pThirdPartyPlayer = Players[iPlayerLoop];
			iThirdPartyTeam = pThirdPartyPlayer:GetTeam();
			
			-- Valid player? - Can't be us and has to be alive
			if (pPlayer:GetTeam() ~= iThirdPartyTeam and pThirdPartyPlayer:IsAlive()) then
				
				-- Can't be the guy we're already talking to
				if (g_iAITeam ~= iThirdPartyTeam) then
					
					-- Met this player?
					if (pTeam:IsHasMet(iThirdPartyTeam)) then
						iNumPlayers = iNumPlayers + 1;
						AddLeaderButton( iPlayerLoop, pThirdPartyPlayer:GetName() );
					end
				end
			end
		end

		-- If there's no one to talk about then don't do anything
		if (iNumPlayers > 0) then
			Controls.LeaderPanel:SetHide( false );
		end
	end
	
end
Controls.Button1:RegisterCallback( Mouse.eLClick, OnButton1 );


----------------------------------------------------------------
-- BUTTON 2
----------------------------------------------------------------
function OnButton2()
    g_InstanceManager:ResetInstances();
    	
	local pPlayer = Players[Game.GetActivePlayer()];
	local pTeam = Teams[pPlayer:GetTeam()];
	
	local pAIPlayer = Players[g_iAIPlayer];
	
	local iActivePlayer = Game.GetActivePlayer();
	
	local iButtonID = 2;	-- This format is also used in DiploTrade.lua in the OnBack() function.  If functionality here changes it should be updated there as well.
        
    -- Human-invoked discussion
	if (g_DiploUIState == DiploUIStateTypes.DIPLO_UI_STATE_DISCUSS_HUMAN_INVOKED) then
		if (g_iInvokedDiscussionMode == g_iModeDiscussionRoot) then
			-- Ask the AI player to work together
			if (not pAIPlayer:IsDoFMessageTooSoon(iActivePlayer)) and (not pAIPlayer:IsDoF(iActivePlayer)) then
				Game.DoFromUIDiploEvent( FromUIDiploEventTypes.FROM_UI_DIPLO_EVENT_HUMAN_DISCUSSION_WORK_WITH_US, g_iAIPlayer, 0, 0 );
			-- Tell the player we're done working with him
			--elseif (pAIPlayer:IsDoF(iActivePlayer)) then
				--Game.DoFromUIDiploEvent( FromUIDiploEventTypes.FROM_UI_DIPLO_EVENT_HUMAN_DISCUSSION_END_WORK_WITH_US, g_iAIPlayer, 0, 0 );
			end
		end
        
    -- Fluff discussion mode
	elseif (g_DiploUIState == DiploUIStateTypes.DIPLO_UI_STATE_BLANK_DISCUSSION_MEAN_HUMAN) then
	    OnBack(true);
    -- Fluff discussion mode 2
	elseif (g_DiploUIState == DiploUIStateTypes.DIPLO_UI_STATE_BLANK_DISCUSSION_MEAN_AI) then
	    OnBack(true);
    -- AI declared war on us!
	elseif (g_DiploUIState == DiploUIStateTypes.DIPLO_UI_STATE_AI_DECLARED_WAR) then
	    OnBack(true);
        
    -- AI is telling us he sees a military buildup - we tell him to die
	elseif (g_DiploUIState == DiploUIStateTypes.DIPLO_UI_STATE_DISCUSS_AGGRESSIVE_MILITARY_WARNING) then
	    Game.DoFromUIDiploEvent( FromUIDiploEventTypes.FROM_UI_DIPLO_EVENT_AGGRESSIVE_MILITARY_WARNING_RESPONSE, g_iAIPlayer, iButtonID, 0 );

    -- AI told us he attacked a Minor we're friends with - we're going to get revenge for this
	elseif (g_DiploUIState == DiploUIStateTypes.DIPLO_UI_STATE_DISCUSS_I_ATTACKED_YOUR_MINOR_CIV) then
	    Game.DoFromUIDiploEvent( FromUIDiploEventTypes.FROM_UI_DIPLO_EVENT_I_ATTACKED_YOUR_MINOR_CIV_RESPONSE, g_iAIPlayer, iButtonID, 0 );
    
    -- AI warned us about attacking a Minor - we tell him we'll be nice from now on
	elseif (g_DiploUIState == DiploUIStateTypes.DIPLO_UI_STATE_DISCUSS_YOU_ATTACKED_MINOR_CIV) then
	    Game.DoFromUIDiploEvent( FromUIDiploEventTypes.FROM_UI_DIPLO_EVENT_ATTACKED_MINOR_RESPONSE, g_iAIPlayer, iButtonID, 0 );
    
    -- AI scolded us for killing a Minor - we offer to give him something to keep the peace
	elseif (g_DiploUIState == DiploUIStateTypes.DIPLO_UI_STATE_DISCUSS_YOU_KILLED_MINOR_CIV) then
	    Game.DoFromUIDiploEvent( FromUIDiploEventTypes.FROM_UI_DIPLO_EVENT_KILLED_MINOR_RESPONSE, g_iAIPlayer, iButtonID, 0 );
    
    -- AI seriously warning us about expansion - we offer to give him something to keep the peace
	elseif (g_DiploUIState == DiploUIStateTypes.DIPLO_UI_STATE_DISCUSS_YOU_EXPANSION_SERIOUS_WARNING) then
	    Game.DoFromUIDiploEvent( FromUIDiploEventTypes.FROM_UI_DIPLO_EVENT_EXPANSION_SERIOUS_WARNING_RESPONSE, g_iAIPlayer, iButtonID, 0 );
    
    -- AI warning us about expansion - we apologize
	elseif (g_DiploUIState == DiploUIStateTypes.DIPLO_UI_STATE_DISCUSS_YOU_EXPANSION_WARNING) then
	    Game.DoFromUIDiploEvent( FromUIDiploEventTypes.FROM_UI_DIPLO_EVENT_EXPANSION_WARNING_RESPONSE, g_iAIPlayer, iButtonID, 0 );
    
    -- AI seriously warning us about plot buying - we offer to give him something to keep the peace
	elseif (g_DiploUIState == DiploUIStateTypes.DIPLO_UI_STATE_DISCUSS_YOU_PLOT_BUYING_SERIOUS_WARNING) then
	    Game.DoFromUIDiploEvent( FromUIDiploEventTypes.FROM_UI_DIPLO_EVENT_PLOT_BUYING_SERIOUS_WARNING_RESPONSE, g_iAIPlayer, iButtonID, 0 );
    
    -- AI warning us about plot buying - we apologize
	elseif (g_DiploUIState == DiploUIStateTypes.DIPLO_UI_STATE_DISCUSS_YOU_PLOT_BUYING_WARNING) then
	    Game.DoFromUIDiploEvent( FromUIDiploEventTypes.FROM_UI_DIPLO_EVENT_PLOT_BUYING_WARNING_RESPONSE, g_iAIPlayer, iButtonID, 0 );
    
    -- AI asking to work with us - we tell him sorry
	elseif (g_DiploUIState == DiploUIStateTypes.DIPLO_UI_STATE_DISCUSS_WORK_WITH_US) then
	    Game.DoFromUIDiploEvent( FromUIDiploEventTypes.FROM_UI_DIPLO_EVENT_WORK_WITH_US_RESPONSE, g_iAIPlayer, iButtonID, 0 );
    
    -- AI asking to work against someone - we're offended
	elseif (g_DiploUIState == DiploUIStateTypes.DIPLO_UI_STATE_DISCUSS_WORK_AGAINST_SOMEONE) then
		local iAgainstPlayer = g_iDiploData;	-- This should be set when receiving the leader message
	    Game.DoFromUIDiploEvent( FromUIDiploEventTypes.FROM_UI_DIPLO_EVENT_WORK_AGAINST_SOMEONE_RESPONSE, g_iAIPlayer, iButtonID, iAgainstPlayer );
        
    -- AI asking to declare war against someone - we're offended
	elseif (g_DiploUIState == DiploUIStateTypes.DIPLO_UI_STATE_DISCUSS_COOP_WAR) then
		local iAgainstPlayer = g_iDiploData;	-- This should be set when receiving the leader message
	    Game.DoFromUIDiploEvent( FromUIDiploEventTypes.FROM_UI_DIPLO_EVENT_COOP_WAR_RESPONSE, g_iAIPlayer, iButtonID, iAgainstPlayer );
    
    -- AI asking to declare war against someone NOW - we tell him no
	elseif (g_DiploUIState == DiploUIStateTypes.DIPLO_UI_STATE_DISCUSS_COOP_WAR_TIME) then
		local iAgainstPlayer = g_iDiploData;	-- This should be set when receiving the leader message
	    Game.DoFromUIDiploEvent( FromUIDiploEventTypes.FROM_UI_DIPLO_EVENT_COOP_WAR_NOW_RESPONSE, g_iAIPlayer, iButtonID, iAgainstPlayer );
    
    -- AI asking to make RA in the future - we tell him sorry
	elseif (g_DiploUIState == DiploUIStateTypes.DIPLO_UI_STATE_DISCUSS_PLAN_RESEARCH_AGREEMENT) then
	    Game.DoFromUIDiploEvent( FromUIDiploEventTypes.FROM_UI_DIPLO_EVENT_PLAN_RA_RESPONSE, g_iAIPlayer, iButtonID, 0 );
    
    -- AI asking to denounce another player - we agree
	elseif (g_DiploUIState == DiploUIStateTypes.DIPLO_UI_STATE_DISCUSS_AI_REQUEST_DENOUNCE) then
		local iAgainstPlayer = g_iDiploData;	-- This should be set when receiving the leader message
	    Game.DoFromUIDiploEvent( FromUIDiploEventTypes.FROM_UI_DIPLO_EVENT_AI_REQUEST_DENOUNCE_RESPONSE, g_iAIPlayer, iButtonID, iAgainstPlayer );
		
    -- Default mode
    elseif (g_DiploUIState == DiploUIStateTypes.DIPLO_UI_STATE_DEFAULT_ROOT) then
		
	end
	
end
Controls.Button2:RegisterCallback( Mouse.eLClick, OnButton2 );


----------------------------------------------------------------
-- BUTTON 3
----------------------------------------------------------------
function OnButton3()
    g_InstanceManager:ResetInstances();
    
	local pPlayer = Players[Game.GetActivePlayer()];
	local pTeam = Teams[pPlayer:GetTeam()];
	
	local pAIPlayer = Players[g_iAIPlayer];
	
	local iButtonID = 3;	-- This format is also used in DiploTrade.lua in the OnBack() function.  If functionality here changes it should be updated there as well.
	
	-- Discussion mode brought up by the human
	if (g_DiploUIState == DiploUIStateTypes.DIPLO_UI_STATE_DISCUSS_HUMAN_INVOKED) then
		
		-- Discussion Root Mode
		if (g_iInvokedDiscussionMode == g_iModeDiscussionRoot) then
			Controls.DenounceConfirm:SetHide(false);
			--if (not pAIPlayer:IsWorkingAgainstPlayerMessageTooSoon(iActivePlayer, 0)) then
				--Game.DoFromUIDiploEvent( FromUIDiploEventTypes.FROM_UI_DIPLO_EVENT_HUMAN_DISCUSSION_WORK_WITH_US, g_iAIPlayer, 0, 0 );
			--end
			--g_iInvokedDiscussionMode = g_iModeDiscussionWorkAgainst;
			--OpenLeadersPanel();
		end
    
    -- AI asking to work against someone - we agree
	elseif (g_DiploUIState == DiploUIStateTypes.DIPLO_UI_STATE_DISCUSS_WORK_AGAINST_SOMEONE) then
		local iAgainstPlayer = g_iDiploData;	-- This should be set when receiving the leader message
	    Game.DoFromUIDiploEvent( FromUIDiploEventTypes.FROM_UI_DIPLO_EVENT_WORK_AGAINST_SOMEONE_RESPONSE, g_iAIPlayer, iButtonID, iAgainstPlayer );
    
    -- AI asking to declare war against someone - we tell him yes, but not yet
	elseif (g_DiploUIState == DiploUIStateTypes.DIPLO_UI_STATE_DISCUSS_COOP_WAR) then
		local iAgainstPlayer = g_iDiploData;	-- This should be set when receiving the leader message
	    Game.DoFromUIDiploEvent( FromUIDiploEventTypes.FROM_UI_DIPLO_EVENT_COOP_WAR_RESPONSE, g_iAIPlayer, iButtonID, iAgainstPlayer );
		
    -- Default mode
    elseif (g_DiploUIState == DiploUIStateTypes.DIPLO_UI_STATE_DEFAULT_ROOT) then
		
	end
	
end
Controls.Button3:RegisterCallback( Mouse.eLClick, OnButton3 );

----------------------------------------------------------------
-- BUTTON 4
----------------------------------------------------------------
function OnButton4()
    g_InstanceManager:ResetInstances();
    	
	local pPlayer = Players[Game.GetActivePlayer()];
	local pTeam = Teams[pPlayer:GetTeam()];
	
	local iButtonID = 4;	-- This format is also used in DiploTrade.lua in the OnBack() function.  If functionality here changes it should be updated there as well.
	
	-- Discussion mode brought up by the human
	if (g_DiploUIState == DiploUIStateTypes.DIPLO_UI_STATE_DISCUSS_HUMAN_INVOKED) then
		
		-- Discussion Root Mode
		if (g_iInvokedDiscussionMode == g_iModeDiscussionRoot) then
			g_iInvokedDiscussionMode = g_iModeDiscussionWar;
			OpenLeadersPanel();
		end
    
    -- AI asking to declare war against someone - we agree
	elseif (g_DiploUIState == DiploUIStateTypes.DIPLO_UI_STATE_DISCUSS_COOP_WAR) then
		local iAgainstPlayer = g_iDiploData;	-- This should be set when receiving the leader message
	    Game.DoFromUIDiploEvent( FromUIDiploEventTypes.FROM_UI_DIPLO_EVENT_COOP_WAR_RESPONSE, g_iAIPlayer, iButtonID, iAgainstPlayer );
		
    -- Default mode
    elseif (g_DiploUIState == DiploUIStateTypes.DIPLO_UI_STATE_DEFAULT_ROOT) then
		
	end
	
end
Controls.Button4:RegisterCallback( Mouse.eLClick, OnButton4 );


----------------------------------------------------------------
-- Time to show the leaders!
----------------------------------------------------------------
function OpenLeadersPanel()
	
	local iNumPlayers = 0;
	
	-- Loop through all the Majors the active player knows
	for iPlayerLoop = 0, GameDefines.MAX_MAJOR_CIVS-1, 1 do
		
		-- Working Against mode
		--if (g_iInvokedDiscussionMode == g_iModeDiscussionWorkAgainst and IsWorkingAgainstThirdPartyPlayerValid(iPlayerLoop)) then
			--iNumPlayers = iNumPlayers + 1;
			--AddLeaderButton( iPlayerLoop, Players[iPlayerLoop]:GetName() );
		--end
		
		-- War mode
		if (g_iInvokedDiscussionMode == g_iModeDiscussionWar and IsWarAgainstThirdPartyPlayerValid(iPlayerLoop)) then
			iNumPlayers = iNumPlayers + 1;
			AddLeaderButton( iPlayerLoop, Players[iPlayerLoop]:GetName() );
		end
		
	end

	-- If there's no one to talk about then don't do anything
	if (iNumPlayers > 0) then
		
		Controls.LeaderStack:CalculateSize();
		Controls.LeaderStack:ReprocessAnchoring();
		Controls.LeaderScrollPanel:CalculateInternalSize();
		
		Controls.LeaderPanel:SetHide( false );

		-- Disable normal buttons
 		Controls.Button1:SetDisabled(true);
 		Controls.Button2:SetDisabled(true);
 		Controls.Button3:SetDisabled(true);
 		Controls.Button4:SetDisabled(true);
	end

end

----------------------------------------------------------------
----------------------------------------------------------------
function IsThirdPartyPlayerValid(iThirdPartyPlayer)

	local pActivePlayer = Players[Game.GetActivePlayer()];
	local pActiveTeam = Teams[pActivePlayer:GetTeam()];
	
	local pThirdPartyPlayer = Players[iThirdPartyPlayer];
	local iThirdPartyTeam = pThirdPartyPlayer:GetTeam();
	
	-- Can't be someone on our team
	if (pActivePlayer:GetTeam() == iThirdPartyTeam) then
		return false;
	end
	
	-- Has to be alive
	if (not pThirdPartyPlayer:IsAlive()) then
		return false;
	end
	
	-- Can't be the guy we're already talking to
	if (g_iAITeam == iThirdPartyTeam) then
		return false;
	end
	
	-- Active player met them?
	if (not pActiveTeam:IsHasMet(iThirdPartyTeam)) then
		return false;
	end
	
	-- Other player met them?
	if (not Teams[g_iAITeam]:IsHasMet(iThirdPartyTeam)) then
		return false;
	end
	
	return true;
	
end

----------------------------------------------------------------
----------------------------------------------------------------
--function IsWorkingAgainstThirdPartyPlayerValid(iThirdPartyPlayer)
	--
	--if (not IsThirdPartyPlayerValid(iThirdPartyPlayer)) then
		--return false;
	--end
	--
	--local pActivePlayer = Players[Game.GetActivePlayer()];
	--
    ---- Have we already agreed?
	--if (Players[g_iAIPlayer]:IsWorkingAgainstPlayerAccepted(pActivePlayer:GetID(), iThirdPartyPlayer)) then
		--return false;
	--end
	--
	--return true;
	--
--end

----------------------------------------------------------------
----------------------------------------------------------------
function IsWarAgainstThirdPartyPlayerValid(iThirdPartyPlayer)
	
	if (not IsThirdPartyPlayerValid(iThirdPartyPlayer)) then
		return false;
	end
	
	local pActivePlayer = Players[Game.GetActivePlayer()];
	
    -- Have we already agreed?
    local iCoopState = Players[g_iAIPlayer]:GetCoopWarAcceptedState(pActivePlayer:GetID(), iThirdPartyPlayer);
	if (iCoopState == CoopWarStates.COOP_WAR_STATE_ACCEPTED or iCoopState == CoopWarStates.COOP_WAR_STATE_SOON) then
		return false;
	end
	
	return true;
	
end

----------------------------------------------------------------
----------------------------------------------------------------
function AddLeaderButton( iLeaderId, sLeaderName )
    instanceControls = g_InstanceManager:GetInstance();
    instanceControls.Button:SetVoid1( iLeaderId ); -- leader ID
    instanceControls.LeaderButtonLabel:SetText( sLeaderName );
    instanceControls.Button:RegisterCallback( Mouse.eLClick, OnLeaderSelect );
end

----------------------------------------------------------------
----------------------------------------------------------------
function OnCloseLeaderPanelButton()
	g_iInvokedDiscussionMode = g_iModeDiscussionRoot;
	
	-- Re-enable normal buttons
	Controls.Button1:SetDisabled(false);
	Controls.Button2:SetDisabled(false);
	Controls.Button3:SetDisabled(false);
	Controls.Button4:SetDisabled(false);
	
    Controls.LeaderPanel:SetHide( true );
end
Controls.CloseLeaderPanelButton:RegisterCallback( Mouse.eLClick, OnCloseLeaderPanelButton );

----------------------------------------------------------------
----------------------------------------------------------------
function OnLeaderSelect( iLeaderId )
    g_CurrentTopic = iLeaderId;
    
    Controls.LeaderPanel:SetHide( true );
    
    -- Working Against discussion mode
	--if (g_iInvokedDiscussionMode == g_iModeDiscussionWorkAgainst) then
	    --Game.DoFromUIDiploEvent( FromUIDiploEventTypes.FROM_UI_DIPLO_EVENT_DENOUNCE, g_iAIPlayer, iLeaderId, -1 );
	--end
    
    -- War discussion mode
	if (g_iInvokedDiscussionMode == g_iModeDiscussionWar) then
	    Game.DoFromUIDiploEvent( FromUIDiploEventTypes.FROM_UI_DIPLO_EVENT_COOP_WAR_OFFER, g_iAIPlayer, iLeaderId, -1 );
	end
	
end


----------------------------------------------------------------        
----------------------------------------------------------------        
function OnLeavingLeader()
    UIManager:DequeuePopup( ContextPtr );
end
Events.LeavingLeaderViewMode.Add( OnLeavingLeader );

function OnDenonceConfirmYes( )
	Controls.DenounceConfirm:SetHide(true);

	Game.DoFromUIDiploEvent( FromUIDiploEventTypes.FROM_UI_DIPLO_EVENT_DENOUNCE, g_iAIPlayer, 0, 0 );				
end
Controls.DenounceConfirmYes:RegisterCallback( Mouse.eLClick, OnDenonceConfirmYes );

function OnDenounceConfirmNo( )
	Controls.DenounceConfirm:SetHide(true);
end
Controls.DenounceConfirmNo:RegisterCallback( Mouse.eLClick, OnDenounceConfirmNo );

----------------------------------------------------------------
----------------------------------------------------------------
function OnInfoAddict()
	if MapModData.InfoAddict then
		UIManager:PushModal(MapModData.InfoAddict.InfoAddictScreenContext);
	end
end
Controls.InfoAddictButton:RegisterCallback( Mouse.eLClick, OnInfoAddict );