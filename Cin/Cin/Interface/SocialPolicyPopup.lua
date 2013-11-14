
-------------------------------------------------
-- SocialPolicy Chooser Popup
-------------------------------------------------

include("IconSupport");
include("InstanceManager");
include("YieldLibrary.lua");

local log = Events.LuaLogger:New()
log:SetLevel("WARN")

function getCulturePerPop(player)
	local playerCulturePerPop = 0
	for pCity in player:Cities() do
		for building in GameInfo.Buildings() do
			local buildingID = building.ID;
			if building.CulturePerPop ~= nil and building.CulturePerPop ~= 0 and pCity:IsHasBuilding(building.ID) then
				playerCulturePerPop = playerCulturePerPop + building.CulturePerPop * pCity:GetPopulation() / 100
			end
		end
	end
	return playerCulturePerPop
end

local m_PopupInfo = nil;

local g_LibertyPipeManager = InstanceManager:new( "ConnectorPipe", "ConnectorImage", Controls.LibertyPanel );
local g_TraditionPipeManager = InstanceManager:new( "ConnectorPipe", "ConnectorImage", Controls.TraditionPanel );
local g_HonorPipeManager = InstanceManager:new( "ConnectorPipe", "ConnectorImage", Controls.HonorPanel );
local g_PietyPipeManager = InstanceManager:new( "ConnectorPipe", "ConnectorImage", Controls.PietyPanel );
local g_PatronagePipeManager = InstanceManager:new( "ConnectorPipe", "ConnectorImage", Controls.PatronagePanel );
local g_CommercePipeManager = InstanceManager:new( "ConnectorPipe", "ConnectorImage", Controls.CommercePanel );
local g_RationalismPipeManager = InstanceManager:new( "ConnectorPipe", "ConnectorImage", Controls.RationalismPanel );
local g_FreedomPipeManager = InstanceManager:new( "ConnectorPipe", "ConnectorImage", Controls.FreedomPanel );
local g_OrderPipeManager = InstanceManager:new( "ConnectorPipe", "ConnectorImage", Controls.OrderPanel );
local g_AutocracyPipeManager = InstanceManager:new( "ConnectorPipe", "ConnectorImage", Controls.AutocracyPanel );

local g_LibertyInstanceManager = InstanceManager:new( "PolicyButton", "PolicyIcon", Controls.LibertyPanel );
local g_TraditionInstanceManager = InstanceManager:new( "PolicyButton", "PolicyIcon", Controls.TraditionPanel );
local g_HonorInstanceManager = InstanceManager:new( "PolicyButton", "PolicyIcon", Controls.HonorPanel );
local g_PietyInstanceManager = InstanceManager:new( "PolicyButton", "PolicyIcon", Controls.PietyPanel );
local g_PatronageInstanceManager = InstanceManager:new( "PolicyButton", "PolicyIcon", Controls.PatronagePanel );
local g_CommerceInstanceManager = InstanceManager:new( "PolicyButton", "PolicyIcon", Controls.CommercePanel );
local g_RationalismInstanceManager = InstanceManager:new( "PolicyButton", "PolicyIcon", Controls.RationalismPanel );
local g_FreedomInstanceManager = InstanceManager:new( "PolicyButton", "PolicyIcon", Controls.FreedomPanel );
local g_OrderInstanceManager = InstanceManager:new( "PolicyButton", "PolicyIcon", Controls.OrderPanel );
local g_AutocracyInstanceManager = InstanceManager:new( "PolicyButton", "PolicyIcon", Controls.AutocracyPanel );

include("FLuaVector");

local fullColor = {x = 1, y = 1, z = 1, w = 1};
local fadeColor = {x = 1, y = 1, z = 1, w = 0};
local fadeColorRV = {x = 1, y = 1, z = 1, w = 0.2};
local pinkColor = {x = 2, y = 0, z = 2, w = 1};
local lockTexture = "48Lock.dds";
local checkTexture = "48Checked.dds";

local hTexture = "Connect_H.dds";
local vTexture = "Connect_V.dds";

local topRightTexture =		"Connect_JonCurve_TopRight.dds"
local topLeftTexture =		"Connect_JonCurve_TopLeft.dds"
local bottomRightTexture =	"Connect_JonCurve_BottomRight.dds"
local bottomLeftTexture =	"Connect_JonCurve_BottomLeft.dds"

local policyIcons = {};

local g_PolicyXOffset = 28;
local g_PolicyYOffset = 68;

local g_PolicyPipeXOffset = 28;
local g_PolicyPipeYOffset = 68;

local m_gPolicyID;
local m_gAdoptingPolicy;

local numBranchesRequiredForUtopia = GameInfo.Projects["PROJECT_UTOPIA_PROJECT"].CultureBranchesRequired;

-------------------------------------------------
-- On Policy Selected
-------------------------------------------------
function PolicySelected( policyIndex )
    
    --print("Clicked on Policy: " .. tostring(policyIndex));
    
	if policyIndex == -1 then
		return;
	end
    local player = Players[Game.GetActivePlayer()];   
    if player == nil then
		return;
    end
    
    local bHasPolicy = player:HasPolicy(policyIndex);
    local bCanAdoptPolicy = player:CanAdoptPolicy(policyIndex);
    
    --print("bHasPolicy: " .. tostring(bHasPolicy));
    --print("bCanAdoptPolicy: " .. tostring(bCanAdoptPolicy));
    --print("Policy Blocked: " .. tostring(player:IsPolicyBlocked(policyIndex)));
    
    local bPolicyBlocked = false;
    
    -- If we can get this, OR we already have it, see if we can unblock it first
    if (bHasPolicy or bCanAdoptPolicy) then
    
		-- Policy blocked off right now? If so, try to activate
		if (player:IsPolicyBlocked(policyIndex)) then
			
			bPolicyBlocked = true;
			
			local strPolicyBranch = GameInfo.Policies[policyIndex].PolicyBranchType;
			local iPolicyBranch = GameInfoTypes[strPolicyBranch];
			
			--print("Policy Branch: " .. tostring(iPolicyBranch));
			
			local popupInfo = {
				Type = ButtonPopupTypes.BUTTONPOPUP_CONFIRM_POLICY_BRANCH_SWITCH,
				Data1 = iPolicyBranch;
			}
			Events.SerialEventGameMessagePopup(popupInfo);
			
		end
    end
    
    -- Can adopt Policy right now - don't try this if we're going to unblock the Policy instead
    if (bCanAdoptPolicy and not bPolicyBlocked) then
		m_gPolicyID = policyIndex;
		m_gAdoptingPolicy = true;
		Controls.PolicyConfirm:SetHide(false);
		Controls.BGBlock:SetHide(true);
		--Network.SendUpdatePolicies(policyIndex, true, true);
		--Events.AudioPlay2DSound("AS2D_INTERFACE_POLICY");		
	end
	
end

-------------------------------------------------
-- On Policy Branch Selected
-------------------------------------------------
function PolicyBranchSelected( policyBranchIndex )
    
    --print("Clicked on PolicyBranch: " .. tostring(policyBranchIndex));
    
	if policyBranchIndex == -1 then
		return;
	end
    local player = Players[Game.GetActivePlayer()];   
    if player == nil then
		return;
    end
    
    local bHasPolicyBranch = player:IsPolicyBranchUnlocked(policyBranchIndex);
    local bCanAdoptPolicyBranch = player:CanUnlockPolicyBranch(policyBranchIndex);
    
    --print("bHasPolicyBranch: " .. tostring(bHasPolicyBranch));
    --print("bCanAdoptPolicyBranch: " .. tostring(bCanAdoptPolicyBranch));
    --print("PolicyBranch Blocked: " .. tostring(player:IsPolicyBranchBlocked(policyBranchIndex)));
    
    local bUnblockingPolicyBranch = false;
    
    -- If we can get this, OR we already have it, see if we can unblock it first
    if (bHasPolicyBranch or bCanAdoptPolicyBranch) then
    
		-- Policy Branch blocked off right now? If so, try to activate
		if (player:IsPolicyBranchBlocked(policyBranchIndex)) then
			
			bUnblockingPolicyBranch = true;
			
			local popupInfo = {
				Type = ButtonPopupTypes.BUTTONPOPUP_CONFIRM_POLICY_BRANCH_SWITCH,
				Data1 = policyBranchIndex;
			}
			Events.SerialEventGameMessagePopup(popupInfo);
		end
    end
    
    -- Can adopt Policy Branch right now - don't try this if we're going to unblock the Policy Branch instead
    if (bCanAdoptPolicyBranch and not bUnblockingPolicyBranch) then
		m_gPolicyID = policyBranchIndex;
		m_gAdoptingPolicy = false;
		Controls.PolicyConfirm:SetHide(false);
		Controls.BGBlock:SetHide(true);
	end
	
	---- Are we allowed to unlock this Branch right now?
	--if player:CanUnlockPolicyBranch( policyBranchIndex ) then
		--
		---- Can't adopt the Policy Branch - can we switch active branches though?
		--if (player:IsPolicyBranchBlocked(policyBranchIndex)) then
		--
			--local popupInfo = {
				--Type = ButtonPopupTypes.BUTTONPOPUP_CONFIRM_POLICY_BRANCH_SWITCH,
				--Data1 = policyBranchIndex;
			--}
			--Events.SerialEventGameMessagePopup(popupInfo);
	    --
		---- Can adopt this Policy Branch right now
		--else
			--Network.SendUpdatePolicies(policyBranchIndex, false, true);
		--end
	--end
end

-------------------------------------------------
-------------------------------------------------
function OnPopupMessage(popupInfo)
	
	local popupType = popupInfo.Type;
	if popupType ~= ButtonPopupTypes.BUTTONPOPUP_CHOOSEPOLICY then
		return;
	end
	
	m_PopupInfo = popupInfo;

	UpdateDisplay();
	
	if( m_PopupInfo.Data1 == 1 ) then
    	if( ContextPtr:IsHidden() == false ) then
    	    OnClose();
    	else
        	UIManager:QueuePopup( ContextPtr, PopupPriority.eUtmost );
    	end
	else
    	UIManager:QueuePopup( ContextPtr, PopupPriority.SocialPolicy );
	end
end
Events.SerialEventGameMessagePopup.Add( OnPopupMessage );

-------------------------------------------------
-------------------------------------------------
function UpdateDisplay()

    local player = Players[Game.GetActivePlayer()];
    local pTeam = Teams[player:GetTeam()];
	local culturePerTurn = Game.Round(player:GetYieldRate(YieldTypes.YIELD_CULTURE));
    
    if player == nil then
		return;
    end
    
    local playerHas1City = player:GetNumCities() > 0;
    
    Controls.AnarchyBlock:SetHide( not player:IsAnarchy() );

    local bShowAll = OptionsManager.GetPolicyInfo();
    
    local szText = Locale.ConvertTextKey("TXT_KEY_NEXT_POLICY_COST_LABEL", player:GetYieldNeeded(YieldTypes.YIELD_CULTURE));
    Controls.NextCost:SetText(szText);
    
    szText = Locale.ConvertTextKey("TXT_KEY_CURRENT_CULTURE_LABEL", player:GetYieldStored(YieldTypes.YIELD_CULTURE));
    Controls.CurrentCultureLabel:SetText(szText);
    
    szText = Locale.ConvertTextKey("TXT_KEY_CULTURE_PER_TURN_LABEL", culturePerTurn);
    Controls.CulturePerTurnLabel:SetText(szText);
    
    local iTurns;
    local iCultureNeeded = player:GetYieldNeeded(YieldTypes.YIELD_CULTURE) - player:GetYieldStored(YieldTypes.YIELD_CULTURE);
    if (iCultureNeeded <= 0) then
		iTurns = 0;
    else
		if (culturePerTurn == 0) then
			iTurns = "?";
		else
			iTurns = iCultureNeeded / culturePerTurn;
			iTurns = math.ceil(iTurns);
		end
    end
    szText = Locale.ConvertTextKey("TXT_KEY_NEXT_POLICY_TURN_LABEL", iTurns);
    Controls.NextPolicyTurnLabel:SetText(szText);
    
    -- Player Title
    local iDominantBranch = player:GetDominantPolicyBranchForTitle();
    if (iDominantBranch ~= -1) then
		
		local strTextKey = GameInfo.PolicyBranchTypes[iDominantBranch].Title;
		
		local strText = Locale.ConvertTextKey(strTextKey, player:GetNameKey(), player:GetCivilizationShortDescriptionKey());
		
	    Controls.PlayerTitleLabel:SetHide(false);
	    Controls.PlayerTitleLabel:SetText(strText);
	else
	    Controls.PlayerTitleLabel:SetHide(true);
    end
    
    -- Free Policies
    local iNumFreePolicies = player:GetNumFreePolicies();
    if (iNumFreePolicies > 0) then
	    szText = Locale.ConvertTextKey("TXT_KEY_FREE_POLICIES_LABEL", iNumFreePolicies);
	    Controls.FreePoliciesLabel:SetText( szText );
	    Controls.FreePoliciesLabel:SetHide( false );
	else
	    Controls.FreePoliciesLabel:SetHide( true );
    end
    
	Controls.InfoStack:ReprocessAnchoring();
    
	--szText = Locale.ConvertTextKey( "TXT_KEY_SOCIAL_POLICY_DIRECTIONS" );
    --Controls.ReminderText:SetText( szText );

	local justLooking = true;
	if player:GetYieldStored(YieldTypes.YIELD_CULTURE) >= player:GetYieldNeeded(YieldTypes.YIELD_CULTURE) then
		justLooking = false;
	end
	
	-- Adjust Policy Branches
	local i = 0;
	local numUnlockedBranches = player:GetNumPolicyBranchesUnlocked();
--	if numUnlockedBranches > 0 then
		local policyBranchInfo = GameInfo.PolicyBranchTypes[i];
		while policyBranchInfo ~= nil do
			local numString = tostring( i );
			
			local buttonName = "BranchButton"..numString;
			local backName = "BranchBack"..numString;
			local DisabledBoxName = "DisabledBox"..numString;
			local LockedBoxName = "LockedBox"..numString;
			local ImageMaskName = "ImageMask"..numString;
			local DisabledMaskName = "DisabledMask"..numString;
			--local EraLabelName = "EraLabel"..numString;
			
			
			local thisButton = Controls[buttonName];
			local thisBack = Controls[backName];
			local thisDisabledBox = Controls[DisabledBoxName];
			local thisLockedBox = Controls[LockedBoxName];
			
			local thisImageMask = Controls[ImageMaskName];
			local thisDisabledMask = Controls[DisabledMaskName];
			
			local policyInfo = GameInfo.Policies[policyBranchInfo.FreePolicy]
			
			
			if(thisImageMask == nil) then
				--print(ImageMaskName);
			end
			--local thisEraLabel = Controls[EraLabelName];
			
			local helpText = Locale.ConvertTextKey(policyBranchInfo.Help or "")
			local helpExtra = (Cep.USING_CSD == 1) and Locale.ConvertTextKey((policyBranchInfo.Description or "") .. "_HELP_EXTRA") or ""
			if helpExtra == (policyBranchInfo.Description or "") .. "_HELP_EXTRA" then
				helpExtra = ""
			end
			helpText = string.format("[COLOR_POSITIVE_TEXT]%s[ENDCOLOR][NEWLINE]%s%s", Locale.ConvertTextKey(policyBranchInfo.Description), helpText, helpExtra)
			
			-- Power
			if Cep.SHOW_GOOD_FOR_POLICIES == 1 then
				helpText = helpText .. "[NEWLINE][NEWLINE]----------------"
				helpText = helpText .. Game.GetFlavors("Policy_Flavors", "PolicyType", policyInfo.Type)
			end
			
			-- Era Prereq
			local iEraPrereq = GameInfoTypes[policyBranchInfo.EraPrereq]
			local bEraLock = false;
			if (iEraPrereq ~= nil and pTeam:GetCurrentEra() < iEraPrereq) then
				bEraLock = true;
			else
				--thisEraLabel:SetHide(true);
			end
			
			local lockName = "Lock"..numString;
			local thisLock = Controls[lockName];
			
			-- Branch is not yet unlocked
			if not player:IsPolicyBranchUnlocked( i ) then
				
				-- Cannot adopt this branch right now
				if (not player:CanUnlockPolicyBranch(i)) then
					
					helpText = helpText .. "[NEWLINE][NEWLINE]" .. Locale.ConvertTextKey("TXT_KEY_POLICY_BRANCH_CANNOT_UNLOCK");
					
					-- Not in prereq Era
					if (bEraLock) then
						local strEra = GameInfo.Eras[iEraPrereq].Description;
						helpText = helpText .. " " .. Locale.ConvertTextKey("TXT_KEY_POLICY_BRANCH_CANNOT_UNLOCK_ERA", strEra);
						
						-- Era Label
						--local strEraTitle = "[COLOR_WARNING_TEXT]" .. Locale.ConvertTextKey(strEra) .. "[ENDCOLOR]";
						local strEraTitle = Locale.ConvertTextKey(strEra);
						thisButton:SetText( strEraTitle );
						--thisEraLabel:SetText(strEraTitle);
						--thisEraLabel:SetHide( true );
						
						--thisButton:SetHide( true );
						
					-- Don't have enough Culture Yet
					else
						helpText = helpText .. " " .. Locale.ConvertTextKey("TXT_KEY_POLICY_BRANCH_CANNOT_UNLOCK_CULTURE", player:GetYieldNeeded(YieldTypes.YIELD_CULTURE));
						thisButton:SetHide( false );
						thisButton:SetText( Locale.ConvertTextKey( "TXT_KEY_POP_ADOPT_BUTTON" ) );
						--thisEraLabel:SetHide( true );
					end
					
					thisLock:SetHide( false );
					thisButton:SetDisabled( true );
				-- Can adopt this branch right now
				else
					helpText = helpText .. "[NEWLINE][NEWLINE]" .. Locale.ConvertTextKey("TXT_KEY_POLICY_BRANCH_UNLOCK_SPEND", player:GetYieldNeeded(YieldTypes.YIELD_CULTURE));
					thisLock:SetHide( true );
					--thisEraLabel:SetHide( true );
					thisButton:SetDisabled( false );
					thisButton:SetHide( false );
					thisButton:SetText( Locale.ConvertTextKey( "TXT_KEY_POP_ADOPT_BUTTON" ) );
				end
				
				if(not playerHas1City) then
					thisButton:SetDisabled(true);
				end
				
				thisBack:SetColor( fadeColor );
				thisLockedBox:SetHide(false);
				
				thisImageMask:SetHide(true);
				thisDisabledMask:SetHide(false);
				
			-- Branch is unlocked, but blocked by another branch
			elseif (player:IsPolicyBranchBlocked(i)) then
				thisButton:SetHide( false );
				thisBack:SetColor( fadeColor );
				thisLock:SetHide( false );
				thisLockedBox:SetHide(true);
				
				helpText = helpText .. "[NEWLINE][NEWLINE]" .. Locale.ConvertTextKey("TXT_KEY_POLICY_BRANCH_BLOCKED");
				
			-- Branch is unlocked already
			else
				thisButton:SetHide( true );
				thisBack:SetColor( fullColor );
				thisLockedBox:SetHide(true);
				
				thisImageMask:SetHide(false);
				thisDisabledMask:SetHide(true);
			end
			
			-- Update tooltips
			thisButton:SetToolTipString(helpText);
			
			-- If the player doesn't have the era prereq, then dim out the branch
			if (bEraLock) then
				thisDisabledBox:SetHide(false);
				thisLockedBox:SetHide(true);
			else
				thisDisabledBox:SetHide(true);
			end
			
			if (bShowAll) then
				thisDisabledBox:SetHide(true);
				thisLockedBox:SetHide(true);
			end
			
			i = i + 1;
			policyBranchInfo = GameInfo.PolicyBranchTypes[i];
		end
	--else
		--local policyBranchInfo = GameInfo.PolicyBranchTypes[i];
		--while policyBranchInfo ~= nil do
			--local numString = tostring(i);
			--local buttonName = "BranchButton"..numString;
			--local backName = "BranchBack"..numString;
			--local thisButton = Controls[buttonName];
			--local thisBack = Controls[backName];
			--thisBack:SetColor( fullColor );
			--thisButton:SetHide( true );
			--i = i + 1;
			--policyBranchInfo = GameInfo.PolicyBranchTypes[i];
		--end
	--end
	
	-- Adjust Policy buttons
	
	
	i = 0;
	local policyInfo = GameInfo.Policies[i];
	while policyInfo ~= nil do
		
		local iBranch = policyInfo.PolicyBranchType;
		
		-- If this is nil it means the Policy is a freebie handed out with the Branch, so don't display it
		if (iBranch ~= nil) then
			
			local thisPolicyIcon = policyIcons[i];
			
			
			-- Tooltip
			local helpText = Locale.ConvertTextKey(policyInfo.Help or "")
			local helpExtra = (Cep.USING_CSD == 1) and Locale.ConvertTextKey((policyInfo.Description or "") .. "_HELP_EXTRA") or ""
			if helpExtra == (policyInfo.Description or "") .. "_HELP_EXTRA" then
				helpExtra = ""
			end
			helpText = string.format("[COLOR_POSITIVE_TEXT]%s[ENDCOLOR][NEWLINE]%s%s", Locale.ConvertTextKey(policyInfo.Description), helpText, helpExtra)
			
			-- Power
			if Cep.SHOW_GOOD_FOR_POLICIES == 1 then
				helpText = helpText .. "[NEWLINE][NEWLINE]----------------"
				helpText = helpText .. Game.GetFlavors("Policy_Flavors", "PolicyType", policyInfo.Type)
			end
			
			-- Player already has Policy
			if player:HasPolicy( i ) then
				--thisPolicyIcon.Lock:SetTexture( checkTexture ); 
				--thisPolicyIcon.Lock:SetHide( true ); 
				thisPolicyIcon.MouseOverContainer:SetHide( true );
				thisPolicyIcon.PolicyIcon:SetDisabled( true );
				--thisPolicyIcon.PolicyIcon:SetVoid1( -1 );
				thisPolicyIcon.PolicyImage:SetColor( fullColor );
				IconHookup( policyInfo.PortraitIndex, 64, policyInfo.IconAtlasAchieved, thisPolicyIcon.PolicyImage );

			elseif(not playerHas1City) then
				--thisPolicyIcon.Lock:SetTexture( lockTexture ); 
				thisPolicyIcon.MouseOverContainer:SetHide( true );
				--thisPolicyIcon.Lock:SetHide( true ); 
				thisPolicyIcon.PolicyIcon:SetDisabled( true );
				--thisPolicyIcon.Lock:SetHide( false ); 
				--thisPolicyIcon.PolicyIcon:SetVoid1( -1 );
				thisPolicyIcon.PolicyImage:SetColor( fadeColorRV );
				IconHookup( policyInfo.PortraitIndex, 64, policyInfo.IconAtlas, thisPolicyIcon.PolicyImage );
				-- Tooltip
				--helpText = helpText .. "[NEWLINE][NEWLINE]"
			
			-- Can adopt the Policy right now
			elseif player:CanAdoptPolicy( i ) then
				--thisPolicyIcon.Lock:SetHide( true ); 
				thisPolicyIcon.MouseOverContainer:SetHide( false );
				thisPolicyIcon.PolicyIcon:SetDisabled( false );
				if justLooking then
					--thisPolicyIcon.PolicyIcon:SetVoid1( -1 );
					thisPolicyIcon.PolicyImage:SetColor( fullColor );
				else
					thisPolicyIcon.PolicyIcon:SetVoid1( i ); -- indicates policy to be chosen
					thisPolicyIcon.PolicyImage:SetColor( fullColor );
				end
				IconHookup( policyInfo.PortraitIndex, 64, policyInfo.IconAtlas, thisPolicyIcon.PolicyImage );
				
			-- Policy is locked
			else
				--thisPolicyIcon.Lock:SetTexture( lockTexture ); 
				thisPolicyIcon.MouseOverContainer:SetHide( true );
				--thisPolicyIcon.Lock:SetHide( true ); 
				thisPolicyIcon.PolicyIcon:SetDisabled( true );
				--thisPolicyIcon.Lock:SetHide( false ); 
				--thisPolicyIcon.PolicyIcon:SetVoid1( -1 );
				thisPolicyIcon.PolicyImage:SetColor( fadeColorRV );
				IconHookup( policyInfo.PortraitIndex, 64, policyInfo.IconAtlas, thisPolicyIcon.PolicyImage );
				-- Tooltip
				helpText = helpText .. "[NEWLINE][NEWLINE]" .. Locale.ConvertTextKey("TXT_KEY_POLICY_CANNOT_UNLOCK");
			end
			
			-- Policy is Blocked
			if player:IsPolicyBlocked(i) then
				thisPolicyIcon.PolicyImage:SetColor( fadeColorRV );
				IconHookup( policyInfo.PortraitIndex, 64, policyInfo.IconAtlas, thisPolicyIcon.PolicyImage );
				
				-- Update tooltip if we have this Policy
				if player:HasPolicy( i ) then
					helpText = helpText .. "[NEWLINE][NEWLINE]" .. Locale.ConvertTextKey("TXT_KEY_POLICY_BRANCH_BLOCKED");
				end
			end
				
			thisPolicyIcon.PolicyIcon:SetToolTipString( helpText );
		end
		
		i = i + 1;
		policyInfo = GameInfo.Policies[i];
	end
	
	-- update the Utopia bar
	local numDone = player:GetNumPolicyBranchesFinished();
	local percentDone = numDone / numBranchesRequiredForUtopia;
	if percentDone > 1 then
		percentDone = 1;
	end
	Controls.UtopiaBar:SetPercent( percentDone );
end
Events.EventPoliciesDirty.Add( UpdateDisplay );

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
function OnClose()
    UIManager:DequeuePopup( ContextPtr );
end
Controls.CloseButton:RegisterCallback( Mouse.eLClick, OnClose );

----------------------------------------------------------------
----------------------------------------------------------------
function OnPolicyInfo( bIsChecked )
	local bUpdateScreen = false;
	
	if (bIsChecked ~= OptionsManager.GetPolicyInfo()) then
		bUpdateScreen = true;
	end
	
    OptionsManager.SetPolicyInfo_Cached( bIsChecked );
    OptionsManager.CommitGameOptions();
    
    if (bUpdateScreen) then
		Events.EventPoliciesDirty();
	end
end
Controls.PolicyInfo:RegisterCheckHandler( OnPolicyInfo );

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
function InputHandler( uiMsg, wParam, lParam )
    ----------------------------------------------------------------        
    -- Key Down Processing
    ----------------------------------------------------------------        
    if uiMsg == KeyEvents.KeyDown then
        if (wParam == Keys.VK_RETURN or wParam == Keys.VK_ESCAPE) then
			if(Controls.PolicyConfirm:IsHidden())then
	            OnClose();
	        else
				Controls.PolicyConfirm:SetHide(true);
            	Controls.BGBlock:SetHide(false);
			end
			return true;
        end
    end
end
ContextPtr:SetInputHandler( InputHandler );

function GetPipe(branchType)
	local controlTable = nil;
	-- decide which panel it goes on
	if branchType == "POLICY_BRANCH_LIBERTY" then
		controlTable = g_LibertyPipeManager:GetInstance();
	elseif branchType == "POLICY_BRANCH_TRADITION" then
		controlTable = g_TraditionPipeManager:GetInstance();
	elseif branchType == "POLICY_BRANCH_HONOR" then
		controlTable = g_HonorPipeManager:GetInstance();
	elseif branchType == "POLICY_BRANCH_PIETY" then
		controlTable = g_PietyPipeManager:GetInstance();
	elseif branchType == "POLICY_BRANCH_PATRONAGE" then
		controlTable = g_PatronagePipeManager:GetInstance();
	elseif branchType == "POLICY_BRANCH_COMMERCE" then
		controlTable = g_CommercePipeManager:GetInstance();
	elseif branchType == "POLICY_BRANCH_RATIONALISM" then
		controlTable = g_RationalismPipeManager:GetInstance();
	elseif branchType == "POLICY_BRANCH_FREEDOM" then
		controlTable = g_FreedomPipeManager:GetInstance();
	elseif branchType == "POLICY_BRANCH_ORDER" then
		controlTable = g_OrderPipeManager:GetInstance();
	elseif branchType == "POLICY_BRANCH_AUTOCRACY" then
		controlTable = g_AutocracyPipeManager:GetInstance();
	end
	return controlTable;
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
function Init()

	local bDisablePolicies = Game.IsOption(GameOptionTypes.GAMEOPTION_NO_POLICIES);
	
	Controls.LabelPoliciesDisabled:SetHide(not bDisablePolicies);
	Controls.InfoStack:SetHide(bDisablePolicies);
	Controls.InfoStack2:SetHide(bDisablePolicies);
	
	-- Activate the Branch buttons
	local i = 0;
	local policyBranchInfo = GameInfo.PolicyBranchTypes[i];
	while policyBranchInfo ~= nil do
		local buttonName = "BranchButton"..tostring( i );
		local thisButton = Controls[buttonName];
		thisButton:SetVoid1( i ); -- indicates type
		thisButton:RegisterCallback( Mouse.eLClick, PolicyBranchSelected );
		i = i + 1;
		policyBranchInfo = GameInfo.PolicyBranchTypes[i];
	end

	-- add the pipes
	local policyPipes = {};
	for row in GameInfo.Policies() do
		policyPipes[row.Type] = 
		{
			upConnectionLeft = false;
			upConnectionRight = false;
			upConnectionCenter = false;
			upConnectionType = 0;
			downConnectionLeft = false;
			downConnectionRight = false;
			downConnectionCenter = false;
			downConnectionType = 0;
			yOffset = 0;
			policyType = row.Type;
		};
	end
	
	local cnxCenter = 1
	local cnxLeft = 2
	local cnxRight = 4

	-- Figure out which top and bottom adapters we need
	for row in GameInfo.Policy_PrereqPolicies() do
		local prereq = GameInfo.Policies[row.PrereqPolicy];
		local policy = GameInfo.Policies[row.PolicyType];
		if policy and prereq then
			if policy.GridX < prereq.GridX then
				policyPipes[policy.Type].upConnectionRight = true;
				policyPipes[prereq.Type].downConnectionLeft = true;
			elseif policy.GridX > prereq.GridX then
				policyPipes[policy.Type].upConnectionLeft = true;
				policyPipes[prereq.Type].downConnectionRight = true;
			else -- policy.GridX == prereq.GridX
				policyPipes[policy.Type].upConnectionCenter = true;
				policyPipes[prereq.Type].downConnectionCenter = true;
			end
			local yOffset = (policy.GridY - prereq.GridY) - 1;
			if yOffset > policyPipes[prereq.Type].yOffset then
				policyPipes[prereq.Type].yOffset = yOffset;
			end
		end
	end

	for pipeIndex, thisPipe in pairs(policyPipes) do
		if thisPipe.upConnectionLeft then
			thisPipe.upConnectionType = thisPipe.upConnectionType + cnxLeft;
		end 
		if thisPipe.upConnectionRight then
			thisPipe.upConnectionType = thisPipe.upConnectionType + cnxRight;
		end 
		if thisPipe.upConnectionCenter then
			thisPipe.upConnectionType = thisPipe.upConnectionType + cnxCenter;
		end 
		if thisPipe.downConnectionLeft then
			thisPipe.downConnectionType = thisPipe.downConnectionType + cnxLeft;
		end 
		if thisPipe.downConnectionRight then
			thisPipe.downConnectionType = thisPipe.downConnectionType + cnxRight;
		end 
		if thisPipe.downConnectionCenter then
			thisPipe.downConnectionType = thisPipe.downConnectionType + cnxCenter;
		end 
	end

	-- three passes down, up, connection
	-- connection
	for row in GameInfo.Policy_PrereqPolicies() do
		local prereq = GameInfo.Policies[row.PrereqPolicy];
		local policy = GameInfo.Policies[row.PolicyType];
		if policy and prereq then
		
			local thisPipe = policyPipes[row.PrereqPolicy];
		
			if policy.GridY - prereq.GridY > 1 or policy.GridY - prereq.GridY < -1 then
				local xOffset = (prereq.GridX-1)*g_PolicyPipeXOffset + 30;
				local pipe = GetPipe(policy.PolicyBranchType);
				pipe.ConnectorImage:SetOffsetVal( xOffset, (prereq.GridY-1)*g_PolicyPipeYOffset + 58 );
				pipe.ConnectorImage:SetTexture(vTexture);
				local size = { x = 19; y = g_PolicyPipeYOffset*(policy.GridY - prereq.GridY - 1); };
				pipe.ConnectorImage:SetSize(size);
			end
			
			if policy.GridX - prereq.GridX == 1 then
				local xOffset = (prereq.GridX-1)*g_PolicyPipeXOffset + 30;
				local pipe = GetPipe(policy.PolicyBranchType);
				pipe.ConnectorImage:SetOffsetVal( xOffset + 16, (prereq.GridY-1 + thisPipe.yOffset)*g_PolicyPipeYOffset + 58 );
				pipe.ConnectorImage:SetTexture(hTexture);
				local size = { x = 19; y = 19; };
				pipe.ConnectorImage:SetSize(size);
			end
			if policy.GridX - prereq.GridX == 2 then
				local xOffset = (prereq.GridX-1)*g_PolicyPipeXOffset + 30;
				local pipe = GetPipe(policy.PolicyBranchType);
				pipe.ConnectorImage:SetOffsetVal( xOffset + 16, (prereq.GridY-1 + thisPipe.yOffset)*g_PolicyPipeYOffset + 58 );
				pipe.ConnectorImage:SetTexture(hTexture);
				local size = { x = 40; y = 19; };
				pipe.ConnectorImage:SetSize(size);
			end
			if policy.GridX - prereq.GridX == -2 then
				local xOffset = (policy.GridX-1)*g_PolicyPipeXOffset + 30;
				local pipe = GetPipe(policy.PolicyBranchType);
				pipe.ConnectorImage:SetOffsetVal( xOffset + 16, (prereq.GridY-1 + thisPipe.yOffset)*g_PolicyPipeYOffset + 58 );
				pipe.ConnectorImage:SetTexture(hTexture);
				local size = { x = 40; y = 19; };
				pipe.ConnectorImage:SetSize(size);
			end
			if policy.GridX - prereq.GridX == -1 then
				local xOffset = (policy.GridX-1)*g_PolicyPipeXOffset + 30;
				local pipe = GetPipe(policy.PolicyBranchType);
				pipe.ConnectorImage:SetOffsetVal( xOffset + 16, (prereq.GridY-1 + thisPipe.yOffset)*g_PolicyPipeYOffset + 58 );
				pipe.ConnectorImage:SetTexture(hTexture);
				local size = { x = 20; y = 19; };
				pipe.ConnectorImage:SetSize(size);
			end
			
		end
	end
	
	-- Down	
	for pipeIndex, thisPipe in pairs(policyPipes) do
		local policy = GameInfo.Policies[thisPipe.policyType];
		local xOffset = (policy.GridX-1)*g_PolicyPipeXOffset + 30;
		if thisPipe.downConnectionType >= 1 then
			
			local startPipe = GetPipe(policy.PolicyBranchType);
			startPipe.ConnectorImage:SetOffsetVal( xOffset, (policy.GridY-1)*g_PolicyPipeYOffset + 48 );
			startPipe.ConnectorImage:SetTexture(vTexture);
			
			local pipe = GetPipe(policy.PolicyBranchType);			
			if thisPipe.downConnectionType == 1 then
				pipe.ConnectorImage:SetOffsetVal( xOffset, (policy.GridY-1)*g_PolicyPipeYOffset + 58 );
				pipe.ConnectorImage:SetTexture(vTexture);
			elseif thisPipe.downConnectionType == 2 then
				pipe.ConnectorImage:SetOffsetVal( xOffset, (policy.GridY-1 + thisPipe.yOffset)*g_PolicyPipeYOffset + 58 );
				pipe.ConnectorImage:SetTexture(bottomRightTexture);
			elseif thisPipe.downConnectionType == 3 then
				pipe.ConnectorImage:SetOffsetVal( xOffset, (policy.GridY-1)*g_PolicyPipeYOffset + 58 );
				pipe.ConnectorImage:SetTexture(vTexture);
				pipe = GetPipe(policy.PolicyBranchType);			
				pipe.ConnectorImage:SetOffsetVal( xOffset, (policy.GridY-1 + thisPipe.yOffset)*g_PolicyPipeYOffset + 58 );
				pipe.ConnectorImage:SetTexture(bottomRightTexture);
			elseif thisPipe.downConnectionType == 4 then
				pipe.ConnectorImage:SetOffsetVal( xOffset, (policy.GridY-1)*g_PolicyPipeYOffset + 58 );
				pipe.ConnectorImage:SetTexture(bottomLeftTexture);
			elseif thisPipe.downConnectionType == 5 then
				pipe.ConnectorImage:SetOffsetVal( xOffset, (policy.GridY-1)*g_PolicyPipeYOffset + 58 );
				pipe.ConnectorImage:SetTexture(vTexture);
				pipe = GetPipe(policy.PolicyBranchType);			
				pipe.ConnectorImage:SetOffsetVal( xOffset, (policy.GridY-1 + thisPipe.yOffset)*g_PolicyPipeYOffset + 58 );
				pipe.ConnectorImage:SetTexture(bottomLeftTexture);
			elseif thisPipe.downConnectionType == 6 then
				pipe.ConnectorImage:SetOffsetVal( xOffset, (policy.GridY-1 + thisPipe.yOffset)*g_PolicyPipeYOffset + 58 );
				pipe.ConnectorImage:SetTexture(bottomRightTexture);
				pipe = GetPipe(policy.PolicyBranchType);		
				pipe.ConnectorImage:SetOffsetVal( xOffset, (policy.GridY-1 + thisPipe.yOffset)*g_PolicyPipeYOffset + 58 );
				pipe.ConnectorImage:SetTexture(bottomLeftTexture);
			else
				pipe.ConnectorImage:SetOffsetVal( xOffset, (policy.GridY-1)*g_PolicyPipeYOffset + 58 );
				pipe.ConnectorImage:SetTexture(vTexture);
				pipe = GetPipe(policy.PolicyBranchType);		
				pipe.ConnectorImage:SetOffsetVal( xOffset, (policy.GridY-1 + thisPipe.yOffset)*g_PolicyPipeYOffset + 58 );
				pipe.ConnectorImage:SetTexture(bottomRightTexture);
				pipe = GetPipe(policy.PolicyBranchType);
				pipe.ConnectorImage:SetOffsetVal( xOffset, (policy.GridY-1 + thisPipe.yOffset)*g_PolicyPipeYOffset + 58 );
				pipe.ConnectorImage:SetTexture(bottomLeftTexture);
			end
		end
	end

	-- Up
	for pipeIndex, thisPipe in pairs(policyPipes) do
		local policy = GameInfo.Policies[thisPipe.policyType];
		local xOffset = (policy.GridX-1)*g_PolicyPipeXOffset + 30;
		
		if thisPipe.upConnectionType >= 1 then
			
			local startPipe = GetPipe(policy.PolicyBranchType);
			startPipe.ConnectorImage:SetOffsetVal( xOffset, (policy.GridY-1)*g_PolicyPipeYOffset + 0 );
			startPipe.ConnectorImage:SetTexture(vTexture);
			
			local pipe = GetPipe(policy.PolicyBranchType);			
			if thisPipe.upConnectionType == 1 then
				pipe.ConnectorImage:SetOffsetVal( xOffset, (policy.GridY-1)*g_PolicyPipeYOffset - 10 );
				pipe.ConnectorImage:SetTexture(vTexture);
			elseif thisPipe.upConnectionType == 2 then
				pipe.ConnectorImage:SetOffsetVal( xOffset, (policy.GridY-1)*g_PolicyPipeYOffset - 10 );
				pipe.ConnectorImage:SetTexture(topRightTexture);
			elseif thisPipe.upConnectionType == 3 then
				pipe.ConnectorImage:SetOffsetVal( xOffset, (policy.GridY-1)*g_PolicyPipeYOffset - 10 );
				pipe.ConnectorImage:SetTexture(vTexture);
				pipe = GetPipe(policy.PolicyBranchType);			
				pipe.ConnectorImage:SetOffsetVal( xOffset, (policy.GridY-1)*g_PolicyPipeYOffset - 10 );
				pipe.ConnectorImage:SetTexture(topRightTexture);
			elseif thisPipe.upConnectionType == 4 then
				pipe.ConnectorImage:SetOffsetVal( xOffset, (policy.GridY-1)*g_PolicyPipeYOffset - 10 );
				pipe.ConnectorImage:SetTexture(topLeftTexture);
			elseif thisPipe.upConnectionType == 5 then
				pipe.ConnectorImage:SetOffsetVal( xOffset, (policy.GridY-1)*g_PolicyPipeYOffset - 10 );
				pipe.ConnectorImage:SetTexture(vTexture);
				pipe = GetPipe(policy.PolicyBranchType);			
				pipe.ConnectorImage:SetOffsetVal( xOffset, (policy.GridY-1)*g_PolicyPipeYOffset - 10 );
				pipe.ConnectorImage:SetTexture(topLeftTexture);
			elseif thisPipe.upConnectionType == 6 then
				pipe.ConnectorImage:SetOffsetVal( xOffset, (policy.GridY-1)*g_PolicyPipeYOffset - 10 );
				pipe.ConnectorImage:SetTexture(topRightTexture);
				pipe = GetPipe(policy.PolicyBranchType);		
				pipe.ConnectorImage:SetOffsetVal( xOffset, (policy.GridY-1)*g_PolicyPipeYOffset - 10 );
				pipe.ConnectorImage:SetTexture(topLeftTexture);
			else
				pipe.ConnectorImage:SetOffsetVal( xOffset, (policy.GridY-1)*g_PolicyPipeYOffset - 10 );
				pipe.ConnectorImage:SetTexture(vTexture);
				pipe = GetPipe(policy.PolicyBranchType);		
				pipe.ConnectorImage:SetOffsetVal( xOffset, (policy.GridY-1)*g_PolicyPipeYOffset - 10 );
				pipe.ConnectorImage:SetTexture(topRightTexture);
				pipe = GetPipe(policy.PolicyBranchType);
				pipe.ConnectorImage:SetOffsetVal( xOffset, (policy.GridY-1)*g_PolicyPipeYOffset - 10 );
				pipe.ConnectorImage:SetTexture(topLeftTexture);
			end
		end
	end

	-- Add Policy buttons
	i = 0;
	policyInfo = GameInfo.Policies[i];
	while policyInfo ~= nil do
		
		local iBranch = policyInfo.PolicyBranchType;
		
		-- If this is nil it means the Policy is a freebie handed out with the Branch, so don't display it
		if (iBranch ~= nil) then
			
			local controlTable = nil;
			
			-- decide which panel it goes on
			if iBranch == "POLICY_BRANCH_LIBERTY" then
				controlTable = g_LibertyInstanceManager:GetInstance();
			elseif iBranch == "POLICY_BRANCH_TRADITION" then
				controlTable = g_TraditionInstanceManager:GetInstance();
			elseif iBranch == "POLICY_BRANCH_HONOR" then
				controlTable = g_HonorInstanceManager:GetInstance();
			elseif iBranch == "POLICY_BRANCH_PIETY" then
				controlTable = g_PietyInstanceManager:GetInstance();
			elseif iBranch == "POLICY_BRANCH_PATRONAGE" then
				controlTable = g_PatronageInstanceManager:GetInstance();
			elseif iBranch == "POLICY_BRANCH_COMMERCE" then
				controlTable = g_CommerceInstanceManager:GetInstance();
			elseif iBranch == "POLICY_BRANCH_RATIONALISM" then
				controlTable = g_RationalismInstanceManager:GetInstance();
			elseif iBranch == "POLICY_BRANCH_FREEDOM" then
				controlTable = g_FreedomInstanceManager:GetInstance();
			elseif iBranch == "POLICY_BRANCH_ORDER" then
				controlTable = g_OrderInstanceManager:GetInstance();
			elseif iBranch == "POLICY_BRANCH_AUTOCRACY" then
				controlTable = g_AutocracyInstanceManager:GetInstance();
			end
			
			IconHookup( policyInfo.PortraitIndex, 64, policyInfo.IconAtlas, controlTable.PolicyImage );

			-- this math should match Russ's mocked up layout
			controlTable.PolicyIcon:SetOffsetVal((policyInfo.GridX-1)*g_PolicyXOffset+16,(policyInfo.GridY-1)*g_PolicyYOffset+12);
			controlTable.PolicyIcon:SetVoid1( i ); -- indicates which policy
			controlTable.PolicyIcon:RegisterCallback( Mouse.eLClick, PolicySelected );
			
			-- store this away for later
			policyIcons[i] = controlTable;
		end
		
		i = i + 1;
		policyInfo = GameInfo.Policies[i];
	end
	
end

Events.PolicyAdopted = Events.PolicyAdopted or function(policyID, isPolicy) end

function OnYes( )
	Controls.PolicyConfirm:SetHide(true);
	Controls.BGBlock:SetHide(false);
	
	Network.SendUpdatePolicies(m_gPolicyID, m_gAdoptingPolicy, true);
	Events.PolicyAdopted(m_gPolicyID, m_gAdoptingPolicy);
	Events.AudioPlay2DSound("AS2D_INTERFACE_POLICY");

	if m_gAdoptingPolicy then
		local policyBranchType = GameInfo.Policies[m_gPolicyID].PolicyBranchType
		--log:Debug("m_gPolicyID=%s type=%s policyBranchType = %s", m_gPolicyID, GameInfo.Policies[m_gPolicyID].Type, policyBranchType)
		if HasFinishedBranch(Players[Game.GetActivePlayer()], policyBranchType, m_gPolicyID) then
			Events.PolicyAdopted(GetBranchFinisherID(policyBranchType), true);
		end
	end
	--Game.DoFromUIDiploEvent( FromUIDiploEventTypes.FROM_UI_DIPLO_EVENT_HUMAN_DECLARES_WAR, g_iAIPlayer, 0, 0 );
end
Controls.Yes:RegisterCallback( Mouse.eLClick, OnYes );

function OnNo( )
	Controls.PolicyConfirm:SetHide(true);
	Controls.BGBlock:SetHide(false);
end
Controls.No:RegisterCallback( Mouse.eLClick, OnNo );


-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
function ShowHideHandler( bIsHide, bInitState )
    if( not bInitState ) then
        Controls.PolicyInfo:SetCheck( OptionsManager.GetPolicyInfo() );
        if( not bIsHide ) then
        	UI.incTurnTimerSemaphore();
        	Events.SerialEventGameMessagePopupShown(m_PopupInfo);
        else
            UI.decTurnTimerSemaphore();
            Events.SerialEventGameMessagePopupProcessed.CallImmediate(ButtonPopupTypes.BUTTONPOPUP_CHOOSEPOLICY, 0);
        end
    end
end
ContextPtr:SetShowHideHandler( ShowHideHandler );

----------------------------------------------------------------
-- 'Active' (local human) player has changed
----------------------------------------------------------------
function OnActivePlayerChanged()
	if (not Controls.PolicyConfirm:IsHidden()) then
		Controls.PolicyConfirm:SetHide(true);
    	Controls.BGBlock:SetHide(false);
	end
	OnClose();
end
Events.GameplaySetActivePlayer.Add(OnActivePlayerChanged);

Init();