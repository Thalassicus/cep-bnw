--[[
	FlagPromotionsOptions.lua
	Author: Erendir
	Credits: alpaca
	
	Description: Creates a window for FlagPromotions options.
]]--

local startClockTime = os.clock()

-- global mod vars
include("ModUserData")
include("ModTools.lua")

local log = Events.LuaLogger:New()
log:SetLevel("WARN")

-- how do the window popup?
LuaEvents.ShowFlagPromotionsOptionsScreen.RemoveAll()
LuaEvents.ShowFlagPromotionsOptionsScreen.Add(
	function()
		UIManager:QueuePopup( ContextPtr, PopupPriority.BarbarianCamp );
	end
);

-- UI
include("InstanceManager");
local InstanceCheckButton = InstanceManager:new("FlagPromotionsOptionsInstance", "RootCheckButton", Controls.CheckTextStack);
local InstanceIcon = InstanceManager:new("FlagPromotionsOptionsIcon", "RootIcon", Controls.IconsStack);

--[[
	Initialises the FlagPromotions settings from user data 
]]--
local bOptionsWindowIsHide
local bFirstTime = true
function InitSettings()
	bOptionsWindowIsHide = true
end


--[[
	Initialize the window. This loads all FlagPromotions options with their current values and displays them.
]]--
include("IconSupport");
local change_ignorePromotion = change_ignorePromotion or {}
local doUpdate = false
function InitFlagPromotionsOptions()	
	Controls.MainGrid:SetHide(false)
	InstanceCheckButton:ResetInstances();

	for promotion in GameInfo.UnitPromotions() do
		local rootButton = InstanceCheckButton:GetInstance().RootCheckButton		
		rootButton:GetTextButton():SetText( Locale.ConvertTextKey(promotion.PediaEntry) );
		rootButton:SetToolTipString( Locale.ConvertTextKey(promotion.Help) );
		rootButton:SetCheck(ModUserData.GetValue(promotion.ID) ~= 0);
		rootButton:RegisterCheckHandler(
			function(bCheck)
				--log:Debug("change_ignorePromotion[%s] = %s", promotion.ID, not bCheck)
				change_ignorePromotion[promotion.ID] = not bCheck
				doUpdate = true
			end
		);
		
		local rootIcon = InstanceIcon:GetInstance().RootIcon
		IconHookup( promotion.PortraitIndex, 32, promotion.IconAtlas, rootIcon );
		rootIcon:SetToolTipString(Locale.ConvertTextKey(promotion.Help));
	end
	
	Controls.IconsStack:CalculateSize();
	Controls.IconsStack:ReprocessAnchoring();
	
	Controls.CheckTextStack:CalculateSize();
	Controls.CheckTextStack:ReprocessAnchoring();
	Controls.ScrollPanel1:CalculateInternalSize();--]]
end

function OnCancel()
	change_ignorePromotion = {}
	UIManager:DequeuePopup( ContextPtr );
end
Controls.CancelButton:RegisterCallback( Mouse.eLClick, OnCancel );

function OnAccept()
	--log:Debug("doUpdate = %s", doUpdate)
	if doUpdate then
		for k,v in pairs(change_ignorePromotion) do
			ignorePromotion[k] = v
			ModUserData.SetValue(k, v and 0 or 1)
		end
		change_ignorePromotion = {}
		doUpdate = false
		LuaEvents.UpdateIgnoredFlagPromotions()
	end
	UIManager:DequeuePopup( ContextPtr );
end
Controls.AcceptButton:RegisterCallback( Mouse.eLClick, OnAccept );

function ShowHideHandler( bIsHide, bIsInit )
	bOptionsWindowIsHide = bIsHide
	if bIsInit then
		InitSettings()
	elseif bFirstTime and not bIsHide then
		InitFlagPromotionsOptions()
		bFirstTime = false
	end
end
ContextPtr:SetShowHideHandler( ShowHideHandler );

-- close window on escape
ContextPtr:SetInputHandler(function(uiMsg, wParam, lParam)
	if bOptionsWindowIsHide then return end
	if uiMsg == KeyEvents.KeyDown then
		if wParam == Keys.VK_ESCAPE then
			OnCancel();
			return true;
		end
	end
end);

print(string.format("%3s ms loading OptionsScreen.lua", Game.Round((os.clock() - startClockTime)*1000)))