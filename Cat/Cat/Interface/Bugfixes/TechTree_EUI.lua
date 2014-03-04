-- modified by bc1 from 1.0.3.144 gods & kings code
-- capture choose tech & steal tech popup events
-- fix escape/enter popup exit code
-- support Technology_ORPrereqTechs in addition to Technology_PrereqTechs
-- code is common except for vanila gk_mode needs to be set false
-- decreased code size by over 1/3 and still do more :lol:
-------------------------------------------------
-- Tech Tree Popup
-------------------------------------------------
g_UseSmallIcons = true;

include( "TechButtonInclude" );
include( "TechHelpInclude" );

--cep
include("YieldLibrary.lua");
include("MT_Events.lua");

local log = Events.LuaLogger:New()
log:SetLevel("WARN")
--function print() end


local gk_mode = Players[0].GetNumTechsToSteal ~= nil;
local GameInfo = GameInfo;	-- minor optimization

local g_scienceEnabled = not Game.IsOption(GameOptionTypes.GAMEOPTION_NO_SCIENCE);

local g_maxGridX = 0;	-- TODO improve this
local g_popupInfoType = false;
local g_stealingTechTargetPlayerID = -1;

local g_NeedsFullRefreshOnOpen = false;
local g_NeedsFullRefresh = false;
local g_isOpen = false;
local g_techButtons = {};
local g_eraBlocks = {};
local g_eraColumns = {};

local g_maxSmallButtons = 5;

local g_activePlayerID = Game.GetActivePlayer();
local g_activePlayer = Players[g_activePlayerID];
local g_activeCivType = GameInfo.Civilizations[g_activePlayer:GetCivilizationType()].Type;
local g_activeTeamID = Game.GetActiveTeam();
local g_activeTeam = Teams[g_activeTeamID];

local g_connectorSizeX = 32;	-- connector texture width
local g_connectorSizeY = 42;	-- connector texture height
local g_connectorXshift = 12;	-- horizontal connector texture shift
local g_connectorYshift = 15;	-- vertical connector texture shift
local g_blockSizeX = 270;	-- tech block width
local g_blockOffsetX = 64;
local g_blockSpacingY = 68;	-- tech block vertical spacing
local g_blockOffsetY = 32 - 5*g_blockSpacingY;
local g_blockSpacingX = g_blockSizeX + 96;
local g_branchOffsetY1 = g_blockOffsetY + 12;
local g_branchOffsetY2 = g_branchOffsetY1 - g_connectorYshift;
local g_deltaHeight = g_connectorSizeY - g_connectorYshift;
local g_pipeStartOffsetX = g_blockOffsetX + g_blockSizeX;
local g_pipeEndOffsetX = g_blockOffsetX;
local g_branchOffsetX1 = 0;
local g_branchOffsetX2 = g_branchOffsetX1 - g_connectorXshift;
local g_branchDeltaX = g_pipeEndOffsetX - g_branchOffsetX1;

local g_maxTechNameLength = 22 - Locale.Length(Locale.Lookup("TXT_KEY_TURNS"));

-------------------------------------------------
-- Do initial setup stuff here
-------------------------------------------------

local function AddNewPipeIcon( x, y )
	local newPipeInstance = {};
	ContextPtr:BuildInstanceForControl( "TechPipeInstance", newPipeInstance, Controls.TechTreeScrollPanel );
	local pipeIcon = newPipeInstance.TechPipeIcon;
	pipeIcon:SetOffsetVal( x, y );
	return pipeIcon;
end
local AddNewPipeIconWithoutColor = AddNewPipeIcon; --save original function for later
local function AddNewPipeIconColored( x, y )
	local pipeIcon = AddNewPipeIconWithoutColor( x, y );
	pipeIcon:SetColor{ x=1.0, y=1.0, z=0.0, w=0.5 };
	return pipeIcon;
end

local function AddElbowPipe( x, y, tox, toy )
	local pipeIcon = AddNewPipeIcon( x, y );
	pipeIcon:SetTexture( "TechBranches.dds" );
	pipeIcon:SetTextureOffsetVal( tox, toy );
end

local function AddHorizontalPipe( x, y, length )
	local pipeIcon = AddNewPipeIcon( x, y );
	pipeIcon:SetSizeVal( length, g_connectorSizeY );
	pipeIcon:SetTexture( "TechBranchH.dds" );
end

local function AddTechPipes( techPairs )
	-- add straight connectors first
	for row in techPairs() do
		local prereq = GameInfo.Technologies[row.PrereqTech];
		local tech = GameInfo.Technologies[row.TechType];
		if tech and prereq then
			local x1 = prereq.GridX*g_blockSpacingX + g_pipeStartOffsetX;
			local x2 = tech.GridX*g_blockSpacingX + g_pipeEndOffsetX;

			local height = math.abs( tech.GridY - prereq.GridY ) * g_blockSpacingY - g_deltaHeight;

			-- vertical connector
			if height > 0 then
				local x = x2 - g_branchDeltaX;
				local pipeIcon = AddNewPipeIcon( x, ( (tech.GridY + prereq.GridY) * g_blockSpacingY - g_connectorYshift ) / 2 + g_branchOffsetY1 );
				pipeIcon:SetTexture( "TechBranchV.dds" );
				pipeIcon:SetSizeVal( g_connectorSizeX, height );
				AddHorizontalPipe( x1, prereq.GridY*g_blockSpacingY + g_branchOffsetY1, x - x1 - g_connectorXshift );
				x = x + g_connectorSizeX;
				AddHorizontalPipe( x, tech.GridY*g_blockSpacingY + g_branchOffsetY1, x2 - x );
			else
				AddHorizontalPipe( x1, prereq.GridY*g_blockSpacingY + g_branchOffsetY1, x2 - x1 );
			end
		end
	end

	-- add elbow connectors on top
	for row in techPairs() do
		local prereq = GameInfo.Technologies[row.PrereqTech];
		local tech = GameInfo.Technologies[row.TechType];
		if tech and prereq then
			local x = tech.GridX*g_blockSpacingX;
			local y1 = prereq.GridY*g_blockSpacingY;
			local y2 = tech.GridY*g_blockSpacingY;

			if y1 < y2 then -- elbow case ¯¯¯¯¯¯|__

				AddElbowPipe( x + g_branchOffsetX2, y1 + g_branchOffsetY1, 72, 0 ); --topRightTexture ¯|
				AddElbowPipe( x + g_branchOffsetX1, y2 + g_branchOffsetY2 , 0, 72 ); -- bottomLeftTexture |_

			elseif y1 > y2 then -- elbow case ______|¯¯

				AddElbowPipe( x + g_branchOffsetX2, y1 + g_branchOffsetY2, 72, 72 ); --bottomRightTexture _|
				AddElbowPipe( x + g_branchOffsetX1, y2 + g_branchOffsetY1, 0, 0 ); --topLeftTexture |¯
			end
		end
	end
end

local function AddEraPanels()
	-- find the range of columns that each era takes
	for tech in GameInfo.Technologies() do
		local eraID = GameInfoTypes[tech.Era];
		local eraColumn = g_eraColumns[eraID];
		if not eraColumn then
			g_eraColumns[eraID] = { minGridX = tech.GridX; maxGridX = tech.GridX; researched = false };
		else
			if tech.GridX < eraColumn.minGridX then
				eraColumn.minGridX = tech.GridX;
			end
			if tech.GridX > eraColumn.maxGridX then
				eraColumn.maxGridX = tech.GridX;
			end
		end
	end

	-- add the era panels
	for era in GameInfo.Eras() do

		local thisEraBlockInstance = {};
		ContextPtr:BuildInstanceForControl( "EraBlockInstance", thisEraBlockInstance, Controls.EraStack );
		-- store this panel off for later
		g_eraBlocks[era.ID] = thisEraBlockInstance;

		-- add the correct text for this era panel
		local localizedLabel = Locale.ConvertTextKey( era.Description );
		thisEraBlockInstance.OldLabel:SetText( localizedLabel );
		thisEraBlockInstance.CurrentLabel:SetText( localizedLabel );
		thisEraBlockInstance.FutureLabel:SetText( localizedLabel );

		-- adjust the sizes of the era panels
		local eraBlockWidth = 1;
		if g_eraColumns[era.ID] then
			eraBlockWidth = g_eraColumns[era.ID].maxGridX - g_eraColumns[era.ID].minGridX + 1;
		end

		eraBlockWidth = eraBlockWidth * g_blockSpacingX;
		if era.ID == 0 then
			eraBlockWidth = eraBlockWidth + 32;
		end
		thisEraBlockInstance.EraBlock:SetSizeX( eraBlockWidth );
		thisEraBlockInstance.FrameBottom:SetSizeX( eraBlockWidth );
		thisEraBlockInstance.OldBar:SetSizeX( eraBlockWidth );
		thisEraBlockInstance.OldBlock:SetSizeX( eraBlockWidth );
		thisEraBlockInstance.CurrentBlock:SetSizeX( eraBlockWidth );
		thisEraBlockInstance.CurrentBlock1:SetSizeX( eraBlockWidth );
		thisEraBlockInstance.CurrentBlock2:SetSizeX( eraBlockWidth );

		thisEraBlockInstance.CurrentTop:SetSizeX( eraBlockWidth );
		thisEraBlockInstance.CurrentTop1:SetSizeX( eraBlockWidth );
		thisEraBlockInstance.CurrentTop2:SetSizeX( eraBlockWidth );
		thisEraBlockInstance.FutureBlock:SetSizeX( eraBlockWidth );
	end
end

local function TechSelected( techID )
	if techID > -1 then
		if g_stealingTechTargetPlayerID ~= -1 then
			Network.SendResearch( techID, 0, g_stealingTechTargetPlayerID, UIManager:GetShift() );
		else
			Network.SendResearch( techID, g_activePlayer:GetNumFreeTechs(), -1, UIManager:GetShift() );
		end
	end
end

local function TechPedia( techID )
	local tech = GameInfo.Technologies[ techID ] or {};
	Events.SearchForPediaEntry( tech.Description );
end

local function TechToolTip( button )
	if button:GetVoid2() < 0 then
		local techID = button:GetVoid1();
		button:SetVoid2( techID );
		local tech = GameInfo.Technologies[ techID ];
		if tech then
--			button.TechPortrait:SetHide( not IconHookup( tech.PortraitIndex, 64, tech.IconAtlas, button.TechPortrait ) );
			button:SetToolTipString( GetHelpTextForTech( techID, g_activePlayer:CanResearch( techID ) ) );
		end
	end
end

local function AddTechButton( tech )
	local thisTechButton = {};
	local techID = tech.ID;
	ContextPtr:BuildInstanceForControl( "TechButtonInstance", thisTechButton, Controls.TechTreeScrollPanel );

	-- store this instance off for later
	g_techButtons[techID] = thisTechButton;

	-- add the input handler to this button
	thisTechButton.TechButton:SetVoids( techID, -1 );
	thisTechButton.TechButton:RegisterCallback( Mouse.eRClick, TechPedia );
	thisTechButton.TechButton:SetToolTipCallback( TechToolTip );

	if g_scienceEnabled then
		thisTechButton.TechButton:RegisterCallback( Mouse.eLClick, TechSelected );
	end

	-- position
	thisTechButton.TechButton:SetOffsetVal( tech.GridX*g_blockSpacingX + g_blockOffsetX, tech.GridY*g_blockSpacingY + g_blockOffsetY );

	-- name
	local techName = Locale.ConvertTextKey( tech.Description );
	techName = Locale.TruncateString( techName, g_maxTechNameLength, true );
	thisTechButton.AlreadyResearchedTechName:SetText( techName );
	thisTechButton.CurrentlyResearchingTechName:SetText( techName );
	thisTechButton.AvailableTechName:SetText( techName );
	thisTechButton.UnavailableTechName:SetText( techName );
	thisTechButton.LockedTechName:SetText( techName );
	thisTechButton.FreeTechName:SetText( techName );

	-- picture
	thisTechButton.TechPortrait:SetHide( not IconHookup( tech.PortraitIndex, 64, tech.IconAtlas, thisTechButton.TechPortrait ) );

	-- small pictures and their tooltips
	AddSmallButtonsToTechButton( thisTechButton, tech, g_maxSmallButtons, 45 );
	for buttonNum = 1, g_maxSmallButtons do
		thisTechButton["B"..buttonNum]:SetVoid1( techID );
	end
end

-------------------------------------------------
-- Display refresh management
-------------------------------------------------

local function CloseTechTree()
	UIManager:DequeuePopup( ContextPtr );
	g_isOpen = false;
end
Controls.CloseButton:RegisterCallback( Mouse.eLClick, CloseTechTree );

Events.SerialEventGameMessagePopup.Add(
function( popupInfo )
	local key;
	if popupInfo.Type == ButtonPopupTypes.BUTTONPOPUP_CHOOSETECH then
		key = false;
		g_stealingTechTargetPlayerID = -1;
	elseif popupInfo.Type == ButtonPopupTypes.BUTTONPOPUP_TECH_TREE or popupInfo.Type == ButtonPopupTypes.BUTTONPOPUP_CHOOSE_TECH_TO_STEAL then
		key = popupInfo.Data1 == 1;
		g_stealingTechTargetPlayerID = gk_mode and popupInfo.Data2 or -1;
	else
		return;
	end

	g_isOpen = true;
	if not g_NeedsFullRefresh then
		g_NeedsFullRefresh = g_NeedsFullRefreshOnOpen;
	end
	g_NeedsFullRefreshOnOpen = false;

	if key then
		if( ContextPtr:IsHidden() == false ) then
			Events.SerialEventGameMessagePopupProcessed.CallImmediate(popupInfo.Type, 0);
			CloseTechTree();
			return;
		else
			g_popupInfoType = popupInfo.Type;
			UIManager:QueuePopup( ContextPtr, PopupPriority.InGameUtmost );
		end
	else
		g_popupInfoType = popupInfo.Type;
		UIManager:QueuePopup( ContextPtr, PopupPriority.TechTree );
	end
	Events.SerialEventGameMessagePopupShown(popupInfo);

end);

local function RefreshDisplayOfSpecificTech( tech )
	local techID = tech.ID;
	local thisTechButton = g_techButtons[techID];
	local numFreeTechs = g_activePlayer:GetNumFreeTechs();
	--cep
	local turnText = Locale.ConvertTextKey( "TXT_KEY_STR_TURNS", g_activePlayer:GetYieldTurns(YieldTypes.YIELD_SCIENCE,  techID) );
	local researchPerTurn = g_activePlayer:GetYieldRate(YieldTypes.YIELD_SCIENCE);

	-- Choosing a free tech - extra conditions may apply
	local isAllowedToGetTechFree = (numFreeTechs > 0) and (not gk_mode or g_activePlayer:CanResearchForFree( techID ));

	-- Espionage - stealing a tech!
	local isAllowedToStealTech = false;
	local isNothingToSteal = false;
	local stealingTechTargetPlayer = Players[g_stealingTechTargetPlayerID];
	if stealingTechTargetPlayer then
		if g_activePlayer:GetNumTechsToSteal(g_stealingTechTargetPlayerID) > 0
			and g_activePlayer:CanResearch( techID )
			and Teams[stealingTechTargetPlayer:GetTeam()]:IsHasTech( techID )
		then
			isAllowedToStealTech = true;
		else
			isNothingToSteal = true;
		end
	end

	-- Rebuild the small buttons if needed
	if g_NeedsFullRefresh then
		AddSmallButtonsToTechButton( thisTechButton, tech, g_maxSmallButtons, 45 );
	end
	thisTechButton.TechButton:SetVoid2( -1 ); -- flag tooltip as stale

	local showAlreadyResearched, showFreeTech, showCurrentlyResearching, showAvailable, showUnavailable, showLocked, queueUpdate, queueText, turnLabel, clearCallback;

	if g_activeTeam:GetTeamTechs():HasTech(techID) then
	-- the active player already has this tech
		showAlreadyResearched = true;
		-- update the era marker for this tech
		local eraColumn = g_eraColumns[GameInfoTypes[tech.Era]];
		if eraColumn then
			eraColumn.researched = true;
		end
		clearCallback = true;
	elseif g_activePlayer:GetCurrentResearch() == techID and not isNothingToSteal then
	-- the active player is currently researching this one
		-- deal with free tech
		if isAllowedToGetTechFree or isAllowedToStealTech then
			showFreeTech = true;
			turnLabel = thisTechButton.FreeTurns;
			queueText = freeString; -- update queue number to say "FREE"
		else
			showCurrentlyResearching = true;
			turnLabel = thisTechButton.CurrentlyResearchingTurns;
			queueUpdate = g_activePlayer:GetLengthResearchQueue() > 1; -- update queue number if needed
		end
		-- turn on the meter; cep
		local currentResearchProgress = g_activePlayer:GetYieldStored(YieldTypes.YIELD_SCIENCE);
		local researchNeeded = g_activePlayer:GetYieldNeeded(YieldTypes.YIELD_SCIENCE);
		local currentResearchPlusThisTurn = currentResearchProgress + researchPerTurn;
		local researchProgressPercent = currentResearchProgress / researchNeeded;
		local researchProgressPlusThisTurnPercent = math.min( 1, currentResearchPlusThisTurn / researchNeeded );

	elseif g_activePlayer:CanResearch( techID )
		and g_scienceEnabled
		and not isNothingToSteal
	then
	-- the active player can research this one right now if he wants
		-- deal with free
		if isAllowedToGetTechFree or isAllowedToStealTech then
			showFreeTech = true;
			turnLabel = thisTechButton.FreeTurns;
			queueText = freeString; -- update queue number to say "FREE"
		else
			showAvailable = true;
			turnLabel = thisTechButton.AvailableTurns;
			queueUpdate = true; -- update queue number if needed
		end

	elseif not g_activePlayer:CanEverResearch( techID )
		or isAllowedToGetTechFree
		or isAllowedToStealTech
		or isNothingToSteal
	then
		showLocked = true;
		queueText = lockedString; -- have queue number say "LOCKED"
		clearCallback = true;
	else -- currently unavailable
		showUnavailable = true;
		queueUpdate = true; -- update queue number if needed
		turnLabel = thisTechButton.UnavailableTurns;
		clearCallback = isAllowedToGetTechFree;
	end
	thisTechButton.AlreadyResearched:SetHide( not showAlreadyResearched );
	thisTechButton.FreeTech:SetHide( not showFreeTech );
	thisTechButton.CurrentlyResearching:SetHide( not showCurrentlyResearching );
	thisTechButton.Available:SetHide( not showAvailable );
	thisTechButton.Unavailable:SetHide( not showUnavailable );
	thisTechButton.Locked:SetHide( not showLocked );
	if queueUpdate then
		local queuePosition = g_activePlayer:GetQueuePosition( techID );
		if queuePosition ~= -1 then
			queueText = tostring( queuePosition );
		end
	end
	if queueText then
		thisTechButton.TechQueueLabel:SetText( queueText );
	end
	thisTechButton.TechQueue:SetHide( not queueText );
	if clearCallback then
		thisTechButton.TechButton:ClearCallback( Mouse.eLClick );
		for buttonNum = 1, g_maxSmallButtons do
			thisTechButton["B"..buttonNum]:ClearCallback( Mouse.eLClick );
		end
	else
		thisTechButton.TechButton:RegisterCallback( Mouse.eLClick, TechSelected );
		for buttonNum = 1, g_maxSmallButtons do
			thisTechButton["B"..buttonNum]:RegisterCallback( Mouse.eLClick, TechSelected );
		end
	end
	if turnLabel then
		if not isAllowedToStealTech and researchPerTurn > 0 and g_scienceEnabled then
			turnLabel:SetText( turnText );
			turnLabel:SetHide( false );
		else
			turnLabel:SetHide( true );
		end
	end
end

local function RefreshDisplay()

	for tech in GameInfo.Technologies() do
		RefreshDisplayOfSpecificTech( tech );
	end

	-- update the era panels
	local highestEra = 0;
	for thisEra = 0, #g_eraBlocks, 1  do
		if g_eraColumns[thisEra] and g_eraColumns[thisEra].researched then
			highestEra = thisEra;
		end
	end
	for thisEra = 0, #g_eraBlocks, 1  do
		local thisEraBlockInstance = g_eraBlocks[thisEra];
		thisEraBlockInstance.OldBar:SetHide( thisEra >= highestEra );
		thisEraBlockInstance.CurrentBlock:SetHide( thisEra ~= highestEra );
		thisEraBlockInstance.CurrentTop:SetHide( thisEra ~= highestEra );
		thisEraBlockInstance.FutureBlock:SetHide( thisEra <= highestEra );
	end

	g_NeedsFullRefresh = false;
end

--cep
function RefreshDisplayWonder(player, city, buildingID)
	local buildingInfo = GameInfo.Buildings[buildingID];
	local techInfo = GameInfo.Technologies[buildingInfo.PrereqTech];
	local thisTechButton = g_techButtons[techInfo.ID];
	
	if GameInfo.BuildingClasses[buildingInfo.BuildingClass].MaxGlobalInstances == 1 then
		AddSmallButtonsToTechButton( thisTechButton, techInfo, g_maxSmallButtons, 45 );
	end
end
LuaEvents.BuildingConstructed.Add( RefreshDisplayWonder );

-------------------------------------------------
-- Input processing
-------------------------------------------------

ContextPtr:SetInputHandler(
function ( uiMsg, wParam, lParam )
	if g_isOpen
		and uiMsg == KeyEvents.KeyDown
		and (wParam == Keys.VK_ESCAPE or wParam == Keys.VK_RETURN)
	then
		CloseTechTree();
		return true;
	end
end);

ContextPtr:SetShowHideHandler(
function( bIsHide, bIsInit )
	if not bIsInit then
		if bIsHide then
			Events.SerialEventResearchDirty.Remove( RefreshDisplay );
			if g_popupInfoType then
				Events.SerialEventGameMessagePopupProcessed.CallImmediate(g_popupInfoType, 0);
				g_popupInfoType = false;
			end
			UI.decTurnTimerSemaphore();
		else
			UI.incTurnTimerSemaphore();
			Events.SerialEventResearchDirty.Add( RefreshDisplay );
			RefreshDisplay();

			-- update scrollbar position
			local pPlayer = Players[Game.GetActivePlayer()];
			local techID = pPlayer:GetCurrentResearch();
			local scrollBias = 0;
			if techID < 0 then
				techID = Teams[pPlayer:GetTeam()]:GetTeamTechs():GetLastTechAcquired();
				scrollBias = 1;
			end
			if techID >= 0 then
				local blocks = Controls.TechTreeScrollPanel:GetSizeX() / g_blockSpacingX - 1;
				Controls.TechTreeScrollPanel:SetScrollValue( math.min(1,math.max(0,(GameInfo.Technologies[techID].GridX + scrollBias - (blocks / 2)) / math.max(1,g_maxGridX - blocks) ) ) );
			end
		end
	end
end);

-------------------------------------------------
-- 'Active' (local human) has changed
-------------------------------------------------
Events.GameplaySetActivePlayer.Add(
function( iActivePlayer, iPrevActivePlayer )
	g_activePlayerID = Game.GetActivePlayer();
	g_activePlayer = Players[g_activePlayerID];
	g_activeCivType = GameInfo.Civilizations[g_activePlayer:GetCivilizationType()].Type;
	g_activeTeamID = Game.GetActiveTeam();
	g_activeTeam = Teams[g_activeTeamID];
	-- Rebuild some tables
	GatherInfoAboutUniqueStuff( g_activeCivType );

	-- So some extra stuff gets re-built on the refresh call
	if g_isOpen then
		g_NeedsFullRefresh = true;
	else
		g_NeedsFullRefreshOnOpen = true;
	end

	-- Close it, so the next active player does not have to.
	CloseTechTree();
end);

-------------------------------------------------
-- One time initialization
-------------------------------------------------

-- make the scroll bar the correct size for the display size
Controls.TechTreeScrollBar:SetSizeX( Controls.TechTreeScrollPanel:GetSizeX() - 150 );

-- gather info about this active player's unique units and buldings
GatherInfoAboutUniqueStuff( g_activeCivType );

-- add the era panels to the background
AddEraPanels();

-- add the tech button pipes
AddTechPipes( GameInfo.Technology_PrereqTechs );
AddNewPipeIcon = AddNewPipeIconColored;
AddTechPipes( GameInfo.Technology_ORPrereqTechs );

-- add the tech buttons
for tech in GameInfo.Technologies() do
	g_maxGridX = math.max(g_maxGridX, tech.GridX);
	AddTechButton( tech );
end

-- resize the panel to fit the contents
Controls.EraStack:CalculateSize();
Controls.EraStack:ReprocessAnchoring();
Controls.TechTreeScrollPanel:CalculateInternalSize();
