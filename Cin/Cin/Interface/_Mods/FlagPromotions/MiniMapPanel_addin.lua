-- MiniMapPanelEvents
-- Author: Erendir
-- DateCreated: 1/23/2011 5:49:16 AM
--------------------------------------------------------------
local _VERBOSE = false
local print
if not _VERBOSE then print = function() end end

Events.LoadScreenClose.Add(
function()
	-- Add controls to MiniMapPanel
	local Stack = ContextPtr:LookUpControl("/InGame/WorldView/MiniMapPanel/MainStack")
	Controls.HideUnitIcon:ChangeParent( Stack ); Controls.HideUnitIcon:SetHide(false)
	Controls.DisplayFlagPromotions:ChangeParent( Stack ); Controls.DisplayFlagPromotions:SetHide(false)
	Stack:ReprocessAnchoring()

	-- Added by Kael 07/16/2010
	----------------------------------------------------------------        
	----------------------------------------------------------------        
	local function OnHideUnitIconChecked( bIsChecked )
print'OnHideUnitIconChecked'
		LuaEvents.ToggleHideUnitIcon();
		Events.StrategicViewStateChanged(); -- forces the flag to be redrawn
	end
	Controls.HideUnitIcon:RegisterCheckHandler( OnHideUnitIconChecked );
	-- End Add

	-- Added by Xienwolf
	----------------------------------------------------------------
	----------------------------------------------------------------
	local function OnDisplayFlagPromotionsChecked( bIsChecked )
print'OnDisplayFlagPromotionsChecked'
		LuaEvents.ToggleDisplayFlagPromotions(bIsChecked);
		Events.StrategicViewStateChanged(); -- forces promotions to be redrawn
	end
	Controls.DisplayFlagPromotions:RegisterCheckHandler( OnDisplayFlagPromotionsChecked );
	-- End Add
	Controls.DisplayFlagPromotions:RegisterCallback( Mouse.eRClick,
	function () 
		LuaEvents.ShowFlagPromotionsOptionsScreen()
	end );
end)