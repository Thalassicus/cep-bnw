-- InfoAddictHooks
-- Author: Rob
-- DateCreated: 7/9/2012 6:33:58 PM
--------------------------------------------------------------

include("InfoAddictLib")


-- UI Hooks are set up here upon initialize of the mod. The scroll menu entry is added and
-- then buttons are added to the leader screens.



-- Add an item to the DiploCorner drop down (scroll menu) to access InfoAddict

function OnDiploCornerPopup()
  UIManager:PushModal(MapModData.InfoAddict.InfoAddictScreenContext)
end

function OnAdditionalInformationDropdownGatherEntries(additionalEntries)
  table.insert(additionalEntries, {
    text=Locale.ConvertTextKey("TXT_KEY_INFOADDICT_MAIN_TITLE"), 
    call=OnDiploCornerPopup
  })
end
LuaEvents.AdditionalInformationDropdownGatherEntries.Add(OnAdditionalInformationDropdownGatherEntries)
LuaEvents.RequestRefreshAdditionalInformationDropdownEntries()



-- Set up buttons that will open InfoAddict from other screens. Once the game is done loading,
-- these buttons are moved to the appropriate locations.

function OnInfoAddict()
  local InfoAddictControl = MapModData.InfoAddict.InfoAddictScreenContext;
  UIManager:PushModal(InfoAddictControl);
end;
Controls.IAB_DiploTrade:RegisterCallback( Mouse.eLClick, OnInfoAddict );
Controls.IAB_DiscussLeader:RegisterCallback( Mouse.eLClick, OnInfoAddict );
Controls.IAB_DiscussionDialog:RegisterCallback( Mouse.eLClick, OnInfoAddict );


-- Had to tie this to LoadScreenClose because the LeaderHead contexts are not loaded before
-- mods (or, at least, are not available though LookUpControl)

function MoveIAButtons()
 
  --logger:info("Changing InfoAddict button visibility to LeaderHead contexts");

  Controls.IAB_DiploTrade:ChangeParent(ContextPtr:LookUpControl("/LeaderHeadRoot/DiploTrade"));
  ContextPtr:LookUpControl("/LeaderHeadRoot/DiploTrade"):ReprocessAnchoring();
 
  Controls.IAB_DiscussionDialog:ChangeParent(ContextPtr:LookUpControl("/LeaderHeadRoot/DiscussionDialog"));
  ContextPtr:LookUpControl("/LeaderHeadRoot/DiscussionDialog"):ReprocessAnchoring();
 
  Controls.IAB_DiscussLeader:ChangeParent(ContextPtr:LookUpControl("/LeaderHeadRoot/DiscussionDialog/DiscussLeader"));
  ContextPtr:LookUpControl("/LeaderHeadRoot/DiscussionDialog/DiscussLeader"):ReprocessAnchoring();

end;
Events.LoadScreenClose.Add(MoveIAButtons)
