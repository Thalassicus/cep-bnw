--
-- Replace the logic in PlotHelpManager.lua with our own code. Since this is heavily modified, it was best to just override the whole file
-- Author: csebal (based on the original lua files from CIV5)
--
-- Description:
-- The info box will give information in multiple stages:
-- stage 1: Basic information - Terrain / Feature, Owner, Resource 
-- stage 2: Additional information - Improvement, Yield, Resource yield preview (unless it is already improved)
-- stage 3: Even more information - Preview of absolute tile yields with all the applicable improvements built on it, along with the difference to the current yield.
--

include("EPM_Common.lua");

local m_fTime = 0;
local m_bVisible = false;
local m_bFirstUpdate = true;

local m_plotHelpText;
local m_bAltPressed;

local tipControls = {};
TTManager:GetTypeControlTable( "HexDetails", tipControls );

local m_iCurrentX = -1;
local m_iCurrentY = -1;

-------------------------------------------------
-- Hide the popup, when the mouse is moved
-------------------------------------------------
function ProcessInput( uiMsg, wParam, lParam )
    if( uiMsg == MouseEvents.MouseMove ) then
        x, y = UIManager:GetMouseDelta();
        if( x ~= 0 or y ~= 0 ) then 
			Reset();
        end
    end
end
ContextPtr:SetInputHandler( ProcessInput );

-------------------------------------------------
-- Hide the popup, when we switch between 
-- strategic and map view
-------------------------------------------------
function OnStrategicViewStateChanged( )
    Reset();
end
Events.StrategicViewStateChanged.Add(OnStrategicViewStateChanged);

-------------------------------------------------
-- Hide the popup when the camera view is 
-- changed.
-------------------------------------------------
function OnCameraViewChanged()
	Reset();
end
Events.CameraViewChanged.Add( OnCameraViewChanged );

-------------------------------------------------
-- Hide the popup
-------------------------------------------------
function Reset()
	m_fTime = 0;
	if( m_bVisible ) then
		Controls.TheBox:SetToolTipType();
		m_bVisible = false;
	end
end

-------------------------------------------------
-- Update the coordinates of the plot we are
-- looking at
-------------------------------------------------
function DoUpdateXY( hexX, hexY )
	
	local plot = Map.GetPlot( hexX, hexY );
	
	if (plot ~= nil) then
		m_iCurrentX = hexX;
		m_iCurrentY = hexY;
	end
	
end
Events.SerialEventMouseOverHex.Add( DoUpdateXY );

-------------------------------------------------
-- some house keeping, i guess this enables /
-- disables the mouse over logic depending
-- on whether the mouse is inside or our outside
-- the game's window.
-------------------------------------------------
Controls.TheBox:RegisterCallback( Mouse.eMouseEnter, function() Events.WorldMouseOver( true  ); end );
Controls.TheBox:RegisterCallback( Mouse.eMouseExit,  function() Events.WorldMouseOver( false ); end );

-------------------------------------------------
-- Update to run periodically, to check for
-- elapsed time so we can display information
-- fDTime: the time elapsed since the last update
-------------------------------------------------
function OnUpdate( fDTime )

    if( m_bFirstUpdate ) then    
        m_plotHelpText = ContextPtr:LookUpControl( "/InGame/WorldView/PlotHelpText" );
        m_bFirstUpdate = false;
        return;
    end
    
    m_fTime = m_fTime + fDTime;
	--local bShift = UIManager:GetShift();
	local bAlt = UIManager:GetAlt();
	--local bCtrl = UIManager:GetControl();	

    if( m_fTime > (OptionsManager.GetTooltip1Seconds() / 100) and (not m_bVisible or bAlt ~= m_bAltPressed)) then
		m_bAltPressed = bAlt;
		OnMouseOverHex(m_iCurrentX, m_iCurrentY, bAlt);
		m_bVisible = true;
    end
		    
end
ContextPtr:SetUpdate( OnUpdate );

-------------------------------------------------
-- Called when the mouse enters a new plot
-------------------------------------------------
function OnMouseOverHex( hexX, hexY, bExpanded )
	local TextString		= "";
	local plot				= Map.GetPlot( hexX, hexY );
	local bShowBasicHelp	= not OptionsManager.IsNoBasicHelp()
	local iActiveTeam		= Game.GetActiveTeam();

	if (plot and plot:IsRevealed(iActiveTeam, false)) then -- if the plot is valid and visible to the active team

		-- Display unit military information
		if (plot:IsVisible(iActiveTeam, false)) then
			local strUnitsText = GetUnitsString(plot);			
			if (strUnitsText ~= "") then
				TextString = TextString .. strUnitsText;
			end
		end

		-- Display City/plot owner information
		local strOwner = GetOwnerString(plot);
		if (strOwner ~= "") then
			TextString = TextString .. "[NEWLINE]" .. strOwner;
		end	

		--[[ Improvement under construction
		local UnderConstructionStr = "";
		for i=0, plot:GetNumUnits()-1 do
			local iBuildID = plot:GetUnit( i ):GetBuildType();
			if iBuildID ~= -1 then
				--local iTurnsLeft = plot:GetBuildTurnsLeft(pBuildInfo.ID, 0, 0); -- vanilla version is bugged
				local iTurnsLeft = PlotGetBuildTurnsLeft(plot, iBuildID);
				
				if (iTurnsLeft < 4000 and iTurnsLeft >= 0) then
					local convertedKey = Locale.ConvertTextKey(GameInfo.Builds[iBuildID].Description);
					UnderConstructionStr = UnderConstructionStr .. Locale.ConvertTextKey("TXT_KEY_WORKER_BUILD_PROGRESS", iTurnsLeft, convertedKey);
				end
			end
		end

		if (UnderConstructionStr ~= "") then
			TextString = TextString .. "[NEWLINE]" .. UnderConstructionStr;
		end
		--]]

		-- Defense
		if bShowBasicHelp then
			local iDefensePlotTotal = plot:DefenseModifier(Teams[Game.GetActiveTeam()], false);
			if (iDefensePlotTotal ~= 0) then
				if (iDefensePlotTotal > 0) then
					strResult = Locale.ConvertTextKey("TXT_KEY_CSB_PLOTROLL_LABEL_DEFENSE_BLOCK_PLUS", iDefensePlotTotal)
				end
				if (iDefensePlotTotal < 0) then
					strResult = Locale.ConvertTextKey("TXT_KEY_CSB_PLOTROLL_LABEL_DEFENSE_BLOCK_MINUS", iDefensePlotTotal)
				end
				TextString = TextString .. "[NEWLINE]" .. strResult;
			end
		end
		
		-- City state quest
		local CityStateStr = GetCivStateQuestString(plot, false);
		if (CityStateStr ~= "") then
			TextString = TextString .. "[NEWLINE]" .. CityStateStr;
		end
		
		-- Terrain type, feature
		local natureStr = GetNatureString(plot);
		
		if (natureStr ~= "") then
			TextString = TextString .. "[NEWLINE]"
			if bShowBasicHelp then
				TextString = TextString .. "[COLOR_POSITIVE_TEXT]" .. Locale.ConvertTextKey("TXT_KEY_PEDIA_TERRAIN_LABEL") .. "[ENDCOLOR]" .. " : "
			end
			TextString = TextString .. natureStr;
		end
		
		-- Improvement, route
		local strImprovement = GetImprovementString(plot);

		--if (strImprovement ~= "") then
		if (strImprovement ~= "" or plot:IsTradeRoute()) then		
			local bWroteImprovement = false;	
			if (strImprovement ~= "") then
				TextString = TextString .. "[NEWLINE]"
				if bShowBasicHelp then
					TextString = TextString .. "[COLOR_POSITIVE_TEXT]" .. Locale.ConvertTextKey("TXT_KEY_IMPROVEMENT") .. "[ENDCOLOR]" .. " : "
				end
				TextString = TextString .. strImprovement;
				bWroteImprovement = true;		
			end
		
			-- Trade Route
			if (plot:IsTradeRoute()) then
				local strTradeRouteBlock;
			
				if (bWroteImprovement) then
					strTradeRouteBlock = ", " .. Locale.ConvertTextKey( "TXT_KEY_PLOTROLL_TRADE_ROUTE" );
				else
					strTradeRouteBlock = Locale.ConvertTextKey( "TXT_KEY_PLOTROLL_TRADE_ROUTE" );			
				end
			
				TextString = TextString .. strTradeRouteBlock;
			end
		end	
		
		--[[Presence of fresh water
		if (plot:IsFreshWater()) then
			TextString = TextString .. "[NEWLINE]" .. Locale.ConvertTextKey( "TXT_KEY_PLOTROLL_FRESH_WATER" );
		end--]]
		
		-- Resource
		local strResource = GetResourceString(plot);

		if (strResource ~= "") then
			TextString = TextString .. "[NEWLINE]"
			if bShowBasicHelp then
				TextString = TextString .. "[COLOR_POSITIVE_TEXT]" .. Locale.ConvertTextKey("TXT_KEY_RESOURCE") .. "[ENDCOLOR]" .. " : "
			end
			TextString = TextString .. strResource;
		end	

		-- Yields
		local strYield = GetYieldLines(plot, bExpanded);
		if (strYield ~= "") then
			TextString = TextString .. "[NEWLINE]" .. strYield;
		end
	end
	
    if( TextString ~= "" ) then	
		TextString = string.gsub(TextString, "^"..Game.Literalize("[NEWLINE]"), "")
        tipControls.Text:SetText( TextString );
        tipControls.Grid:DoAutoSize();
        Controls.TheBox:SetToolTipType( "HexDetails" );
    else
        Controls.TheBox:SetToolTipType();
    end
end