include( "IconSupport" );
include( "TutorialPopupScreen" );
-------------------------------------------------
-- Diplomatic
-------------------------------------------------

local m_CurrentPanel = Controls.TradesPanel;
local m_PopupInfo = nil;

-------------------------------------------------
-- On Popup
-------------------------------------------------
function OnPopup( popupInfo )

	if( popupInfo.Type == ButtonPopupTypes.BUTTONPOPUP_DIPLOMATIC_OVERVIEW ) then
		m_PopupInfo = popupInfo;
		if( m_PopupInfo.Data1 == 1 ) then
        	if( ContextPtr:IsHidden() == false ) then
        	    OnClose();
            else
            	UIManager:QueuePopup( ContextPtr, PopupPriority.eUtmost );
        	end
    	else
        	UIManager:QueuePopup( ContextPtr, PopupPriority.DiploOverview );
    	end
	end
end
Events.SerialEventGameMessagePopup.Add( OnPopup );


-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
function OnDeals()
	-- Set Tabs
	Controls.DealsSelectHighlight:SetHide(false);
	Controls.RelationsSelectHighlight:SetHide(true);
	Controls.TradesSelectHighlight:SetHide(true);
	Controls.CityStatesSelectHighlight:SetHide(true);
	Controls.GlobalSelectHighlight:SetHide(true);
	
	-- Set Panels
    Controls.RelationsPanel:SetHide( true );
    Controls.TradesPanel:SetHide( true );
    Controls.CityStatesPanel:SetHide( true );
    Controls.DealsPanel:SetHide( false );
    Controls.GlobalPanel:SetHide( true );
    m_CurrentPanel = Controls.DealsPanel;

    Controls.RefreshButton:SetHide(true);
end
Controls.DealsButton:RegisterCallback( Mouse.eLClick, OnDeals );


-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
function OnRelations()
	-- Set Tabs
	Controls.DealsSelectHighlight:SetHide(true);
	Controls.RelationsSelectHighlight:SetHide(false);
	Controls.TradesSelectHighlight:SetHide(true);
	Controls.CityStatesSelectHighlight:SetHide(true);
	Controls.GlobalSelectHighlight:SetHide(true);
	
	-- Set Panels
    Controls.RelationsPanel:SetHide( false );
    Controls.TradesPanel:SetHide( true );
    Controls.CityStatesPanel:SetHide( true );
    Controls.DealsPanel:SetHide( true );
    Controls.GlobalPanel:SetHide( true );
    m_CurrentPanel = Controls.RelationsPanel;

    Controls.RefreshButton:SetHide(true);
end
Controls.RelationsButton:RegisterCallback( Mouse.eLClick, OnRelations );


-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
function OnTrades()
	-- Set Tabs
	Controls.DealsSelectHighlight:SetHide(true);
	Controls.RelationsSelectHighlight:SetHide(true);
	Controls.TradesSelectHighlight:SetHide(false);
	Controls.CityStatesSelectHighlight:SetHide(true);
	Controls.GlobalSelectHighlight:SetHide(true);
	
	-- Set Panels
    Controls.RelationsPanel:SetHide( true );
    Controls.TradesPanel:SetHide( false );
    Controls.CityStatesPanel:SetHide( true );
    Controls.DealsPanel:SetHide( true );
    Controls.GlobalPanel:SetHide( true );
    m_CurrentPanel = Controls.TradesPanel;

    Controls.RefreshButton:SetHide(true);
end
Controls.TradesButton:RegisterCallback( Mouse.eLClick, OnTrades );


-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
function OnCityStates()
	-- Set Tabs
	Controls.DealsSelectHighlight:SetHide(true);
	Controls.RelationsSelectHighlight:SetHide(true);
	Controls.TradesSelectHighlight:SetHide(true);
	Controls.CityStatesSelectHighlight:SetHide(false);
	Controls.GlobalSelectHighlight:SetHide(true);
	
	-- Set Panels
    Controls.RelationsPanel:SetHide( true );
    Controls.TradesPanel:SetHide( true );
    Controls.CityStatesPanel:SetHide( false );
    Controls.DealsPanel:SetHide( true );
    Controls.GlobalPanel:SetHide( true );
    m_CurrentPanel = Controls.CityStatesPanel;

    Controls.RefreshButton:SetHide(true);
end
Controls.CityStatesButton:RegisterCallback( Mouse.eLClick, OnCityStates );


-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
function OnGlobal()
	-- Set Tabs
	Controls.DealsSelectHighlight:SetHide(true);
	Controls.RelationsSelectHighlight:SetHide(true);
	Controls.TradesSelectHighlight:SetHide(true);
	Controls.CityStatesSelectHighlight:SetHide(true);
	Controls.GlobalSelectHighlight:SetHide(false);
	
	-- Set Panels
    Controls.RelationsPanel:SetHide( true );
    Controls.TradesPanel:SetHide( true );
    Controls.CityStatesPanel:SetHide( true );
    Controls.DealsPanel:SetHide( true );
    Controls.GlobalPanel:SetHide( false );
    m_CurrentPanel = Controls.GlobalPanel;

    Controls.RefreshButton:SetHide(true);
end
Controls.GlobalPoliticsButton:RegisterCallback( Mouse.eLClick, OnGlobal );


-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
function OnClose()
    UIManager:DequeuePopup( ContextPtr );
end
Controls.CloseButton:RegisterCallback( Mouse.eLClick, OnClose);

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
function OnRefresh()
    m_CurrentPanel:SetHide(false);
end
Controls.RefreshButton:RegisterCallback( Mouse.eLClick, OnRefresh);

function OnShowRefresh()
    Controls.RefreshButton:SetHide(false);
end
LuaEvents.DiploShowRefreshButtonEvent.Add( OnShowRefresh );

----------------------------------------------------------------
-- 'Active' (local human) player has changed
----------------------------------------------------------------
Events.GameplaySetActivePlayer.Add(OnClose);

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
function InputHandler( uiMsg, wParam, lParam )
    if uiMsg == KeyEvents.KeyDown then
        if wParam == Keys.VK_ESCAPE or wParam == Keys.VK_RETURN then
            OnClose();
            return true;
        end
    end
end
ContextPtr:SetInputHandler( InputHandler );


-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
function ShowHideHandler( bIsHide, bInitState )
	-- Set player icon at top of screen
	CivIconHookup( Game.GetActivePlayer(), 64, Controls.Icon, Controls.CivIconBG, Controls.CivIconShadow, false, true );

    if( not bInitState ) then
        if( not bIsHide ) then
        	UI.incTurnTimerSemaphore();
        	--OpenAdvisorPopup(ButtonPopupTypes.BUTTONPOPUP_DIPLOMATIC_OVERVIEW);
        	-- trigger the show/hide handler to update state
        	m_CurrentPanel:SetHide( false );
        	Events.SerialEventGameMessagePopupShown(m_PopupInfo);
        else
        	UI.decTurnTimerSemaphore();
        	--CloseAdvisorPopup(ButtonPopupTypes.BUTTONPOPUP_DIPLOMATIC_OVERVIEW);
        	Events.SerialEventGameMessagePopupProcessed.CallImmediate(ButtonPopupTypes.BUTTONPOPUP_DIPLOMATIC_OVERVIEW, 0);
        end
    end
end
ContextPtr:SetShowHideHandler( ShowHideHandler );

OnTrades();
