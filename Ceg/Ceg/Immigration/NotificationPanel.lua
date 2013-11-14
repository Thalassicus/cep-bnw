-------------------------------------------------
-- Action Info Panel
-------------------------------------------------
include( "IconSupport" );
include( "InstanceManager" );

local g_ActiveNotifications = {};
local g_Instances = {};

-- Mod
local g_CustomNotifications = {};	--string names instead of type codes
local g_CustomInstances = {};
local g_Locations = {{}, {}};
local g_CustomId = 0;
-- /Mod

-------------------------------------------------------------------------------
-- details for dynamically sizing the small notification stack
-------------------------------------------------------------------------------
local DIPLO_SIZE_GUESS = 120;
local _, screenY = UIManager:GetScreenSizeVal();
local _, offsetY = Controls.OuterStack:GetOffsetVal();
local g_SmallScrollMax = screenY - offsetY - DIPLO_SIZE_GUESS;



-------------------------------------------------
-------------------------------------------------
function GenericLeftClick( Id )
	UI.ActivateNotification( Id )
end


-------------------------------------------------
-------------------------------------------------
function GenericRightClick ( Id )
	UI.RemoveNotification( Id )
end

-- Mod
function ExtraLeftClick(Id)
	--[[		debug stuff
	local player = Players[ Game.GetActivePlayer() ];
	local city = player:GetCityByID(0);
	city:SetPopulation(city:GetPopulation() + 1, true);
	--]]
	---[[
	local x = g_Locations[Id][1];
	local y = g_Locations[Id][2];

	plot = Map.GetPlot(x, y);
	UI.LookAt(plot, 0);
	--]]
end

function ExtraRightClick(Id)
	if g_CustomNotifications[Id] == nil then
		print("Removing unknown Custom Notification" .. tostring(Id));
		return;
	end

	local name = g_CustomNotifications[Id];
	local instance = g_CustomInstances[Id];
	if (instance ~= nil) then
		Controls.SmallStack:ReleaseChild(instance[name .. "Container"]);
		g_CustomInstances[Id] = nil;
	end
	ProcessStackSizes();
end

function OnTurnEnd()
	for Id, type in pairs(g_CustomInstances) do
		ExtraRightClick(Id);
	end
end
Events.ActivePlayerTurnEnd.Add(OnTurnEnd);
-- /Mod

------------------------------------------------------------------------------------
-- set up the exceptions
------------------------------------------------------------------------------------
Controls[ "TechButton" ]:RegisterCallback( Mouse.eLClick, GenericLeftClick );
Controls[ "TechButton" ]:RegisterCallback( Mouse.eRClick, GenericRightClick );
Controls[ "ProductionButton" ]:RegisterCallback( Mouse.eLClick, GenericLeftClick );
Controls[ "ProductionButton" ]:RegisterCallback( Mouse.eRClick, GenericRightClick );
Controls[ "FreeTechButton" ]:RegisterCallback( Mouse.eLClick, GenericLeftClick );
Controls[ "FreeTechButton" ]:RegisterCallback( Mouse.eRClick, GenericRightClick );

------------------------------------------------------------------------------------
-- build the list of types we can handle
------------------------------------------------------------------------------------
local g_NameTable = {};
g_NameTable[ -1 ]																= "Generic";
g_NameTable[ NotificationTypes.NOTIFICATION_POLICY ]							= "SocialPolicy";
g_NameTable[ NotificationTypes.NOTIFICATION_MET_MINOR ]							= "MetCityState";
g_NameTable[ NotificationTypes.NOTIFICATION_MINOR ]								= "CityState";
g_NameTable[ NotificationTypes.NOTIFICATION_MINOR_QUEST ]						= "CityState";
g_NameTable[ NotificationTypes.NOTIFICATION_ENEMY_IN_TERRITORY ]				= "EnemyInTerritory";
g_NameTable[ NotificationTypes.NOTIFICATION_CITY_RANGE_ATTACK ]					= "Generic";
g_NameTable[ NotificationTypes.NOTIFICATION_BARBARIAN ]							= "Barbarian";
g_NameTable[ NotificationTypes.NOTIFICATION_GOODY ]								= "AncientRuins";
g_NameTable[ NotificationTypes.NOTIFICATION_BUY_TILE ]							= "BuyTile";
g_NameTable[ NotificationTypes.NOTIFICATION_CITY_GROWTH ]						= "CityGrowth";
g_NameTable[ NotificationTypes.NOTIFICATION_CITY_TILE ]							= "CityTile";
g_NameTable[ NotificationTypes.NOTIFICATION_DEMAND_RESOURCE ]					= "BonusResource";
g_NameTable[ NotificationTypes.NOTIFICATION_UNIT_PROMOTION ]					= "UnitPromoted";
--g_NameTable[ NotificationTypes.NOTIFICATION_WONDER_STARTED ]					= "WonderConstructed";
g_NameTable[ NotificationTypes.NOTIFICATION_WONDER_COMPLETED_ACTIVE_PLAYER]     = "WonderConstructed";
g_NameTable[ NotificationTypes.NOTIFICATION_WONDER_COMPLETED ]					= "WonderConstructed";
g_NameTable[ NotificationTypes.NOTIFICATION_WONDER_BEATEN ]						= "WonderConstructed";
g_NameTable[ NotificationTypes.NOTIFICATION_GOLDEN_AGE_BEGUN_ACTIVE_PLAYER ]	= "GoldenAge";
--g_NameTable[ NotificationTypes.NOTIFICATION_GOLDEN_AGE_BEGUN ]				= "GoldenAge";
g_NameTable[ NotificationTypes.NOTIFICATION_GOLDEN_AGE_ENDED_ACTIVE_PLAYER ]	= "GoldenAge";
--g_NameTable[ NotificationTypes.NOTIFICATION_GOLDEN_AGE_ENDED ]				= "GoldenAge";
g_NameTable[ NotificationTypes.NOTIFICATION_GREAT_PERSON_ACTIVE_PLAYER ]		= "GreatPerson";
--g_NameTable[ NotificationTypes.NOTIFICATION_GREAT_PERSON ]					= "GreatPerson";
g_NameTable[ NotificationTypes.NOTIFICATION_STARVING ]							= "Starving";
g_NameTable[ NotificationTypes.NOTIFICATION_WAR_ACTIVE_PLAYER ]                 = "War";
g_NameTable[ NotificationTypes.NOTIFICATION_WAR ]								= "WarOther";
g_NameTable[ NotificationTypes.NOTIFICATION_PEACE_ACTIVE_PLAYER ]				= "Peace";
g_NameTable[ NotificationTypes.NOTIFICATION_PEACE ]								= "PeaceOther";
g_NameTable[ NotificationTypes.NOTIFICATION_VICTORY ]							= "Victory";
g_NameTable[ NotificationTypes.NOTIFICATION_UNIT_DIED ]							= "UnitDied";
g_NameTable[ NotificationTypes.NOTIFICATION_CITY_LOST ]							= "CapitalLost";
g_NameTable[ NotificationTypes.NOTIFICATION_CAPITAL_LOST_ACTIVE_PLAYER ]        = "CapitalLost";
g_NameTable[ NotificationTypes.NOTIFICATION_CAPITAL_LOST ]						= "CapitalLost";
g_NameTable[ NotificationTypes.NOTIFICATION_CAPITAL_RECOVERED ]					= "CapitalRecovered";
g_NameTable[ NotificationTypes.NOTIFICATION_PLAYER_KILLED ]						= "CapitalLost";
g_NameTable[ NotificationTypes.NOTIFICATION_DISCOVERED_LUXURY_RESOURCE ]		= "LuxuryResource";
g_NameTable[ NotificationTypes.NOTIFICATION_DISCOVERED_STRATEGIC_RESOURCE ]		= "StrategicResource";
g_NameTable[ NotificationTypes.NOTIFICATION_DISCOVERED_BONUS_RESOURCE ]			= "BonusResource";
--g_NameTable[ NotificationTypes.NOTIFICATION_POLICY_ADOPTION ]					= "Generic";
g_NameTable[ NotificationTypes.NOTIFICATION_DIPLO_VOTE ]						= "Generic";
g_NameTable[ NotificationTypes.NOTIFICATION_RELIGION_RACE ]						= "Generic";
g_NameTable[ NotificationTypes.NOTIFICATION_EXPLORATION_RACE ]					= "NaturalWonder";
g_NameTable[ NotificationTypes.NOTIFICATION_DIPLOMACY_DECLARATION ]				= "Diplomacy";
g_NameTable[ NotificationTypes.NOTIFICATION_DEAL_EXPIRED_GPT ]					= "DiplomacyX";
g_NameTable[ NotificationTypes.NOTIFICATION_DEAL_EXPIRED_RESOURCE ]				= "DiplomacyX";
g_NameTable[ NotificationTypes.NOTIFICATION_DEAL_EXPIRED_OPEN_BORDERS ]			= "DiplomacyX";
g_NameTable[ NotificationTypes.NOTIFICATION_DEAL_EXPIRED_DEFENSIVE_PACT ]		= "DiplomacyX";
g_NameTable[ NotificationTypes.NOTIFICATION_DEAL_EXPIRED_RESEARCH_AGREEMENT ]	= "DiplomacyX";
g_NameTable[ NotificationTypes.NOTIFICATION_DEAL_EXPIRED_TRADE_AGREEMENT ]		= "DiplomacyX";
g_NameTable[ NotificationTypes.NOTIFICATION_TECH_AWARD ]						= "TechAward";
g_NameTable[ NotificationTypes.NOTIFICATION_PLAYER_DEAL ]						= "Diplomacy";
g_NameTable[ NotificationTypes.NOTIFICATION_PLAYER_DEAL_RECEIVED ]				= "Diplomacy";
g_NameTable[ NotificationTypes.NOTIFICATION_PLAYER_DEAL_RESOLVED ]				= "Diplomacy";
g_NameTable[ NotificationTypes.NOTIFICATION_PROJECT_COMPLETED ]					= "ProjectConstructed";


g_NameTable[ NotificationTypes.NOTIFICATION_TECH ]       = "Tech";
g_NameTable[ NotificationTypes.NOTIFICATION_PRODUCTION ] = "Production";
g_NameTable[ NotificationTypes.NOTIFICATION_FREE_TECH ]	 = "FreeTech";

-- Mod
local g_CustomNotification = 999;	-- custom notification type
-- / Mod

------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
--- Actual new notification entry point
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------

-------------------------------------------------
-------------------------------------------------
function OnNotificationAdded( Id, type, toolTip, strSummary, iGameValue, iExtraGameData )
    --[[
    print( "NotificationAdded " .. tostring( Id ) .. " " 
                                .. tostring( type ) .. " " 
                                .. tostring( iGameValue ) .. " " 
                                .. tostring( iExtraGameData ) .. " " 
                                .. tostring( strSummary ) .. " " 
                                .. tostring( toolTip ) );
    --]]
    -- Mod
    if (g_ActiveNotifications[ Id ] ~= nil and type ~= g_CustomNotification) or (g_CustomNotifications[Id] ~= nil and type == g_CustomNotification)
	-- was:
	-- if( g_ActiveNotifications[ Id ] ~= nil )
	-- /Mod
    then
        print( "Redundant Notification Id: "..tostring(type) );
        return;
    end
    
	-- Mod
	local name = "";
	if (type ~= g_CustomNotification) then
		name = g_NameTable[ type ];
	else
		name = strSummary;
	end
	-- was:
	-- local name = g_NameTable[ type ];
	-- /Mod
	   
    local button;
--    local title;
    local text;
--    local frame;
    local bg;
    local fingerTitle;
    local root;
        
    if( name == "Production" or
        name == "Tech" or
        name == "FreeTech" )
    then
        button = Controls[ name .. "Button"  ];
--        title  = Controls[ name .. "Title"  ];
        text   = Controls[ name .. "Text"   ];
--        frame  = Controls[ name .. "Frame"  ];
        bg     = Controls[ name .. "BG"   ];
        
    else
		--[[
        if( name == nil )
        then
            print( "Unknown Notification, Adding generic " .. Id );
            name = "Generic";
        end
		]]

        local instance = {};
        ContextPtr:BuildInstanceForControl( name .. "Item", instance, Controls.SmallStack );
		-- Mod
		if type ~= g_CustomNotification then
			g_Instances[ Id ] = instance;
		else
			g_CustomInstances[Id] = instance;
		end
		-- was:
		-- g_Instances[ Id ] = instance;
		-- /Mod
        
        button = instance[ name .. "Button" ];
		--print(name.."Button: "..tostring(button))
        text   = instance[ name .. "Text" ];
        root   = instance[ name .. "Container" ];
        
        
        instance.FingerTitle:SetText( strSummary );
        root:BranchResetAnimation();
        
		--if type == NotificationTypes.NOTIFICATION_WONDER_STARTED
		if type == NotificationTypes.NOTIFICATION_WONDER_COMPLETED_ACTIVE_PLAYER
		or type == NotificationTypes.NOTIFICATION_WONDER_COMPLETED
		or type == NotificationTypes.NOTIFICATION_WONDER_BEATEN then
			if iGameValue ~= -1 then
				local portraitIndex = GameInfo.Buildings[iGameValue].PortraitIndex;
				if portraitIndex ~= -1 then
					IconHookup( portraitIndex, 80, GameInfo.Buildings[iGameValue].IconAtlas, instance.WonderConstructedAlphaAnim );				
				end
			end
			if iExtraGameData ~= -1 then
				CivIconHookup( iExtraGameData, 45, instance.CivIcon, instance.CivIconBG, instance.CivIconShadow, false, true );
				instance.WonderSmallCivFrame:SetHide(false);				
			else
				CivIconHookup( 22, 45, instance.CivIcon, instance.CivIconBG, instance.CivIconShadow, false, true );
				instance.WonderSmallCivFrame:SetHide(true);				
			end
		elseif type == NotificationTypes.NOTIFICATION_PROJECT_COMPLETED then
			if iGameValue ~= -1 then
				local portraitIndex = GameInfo.Projects[iGameValue].PortraitIndex;
				if portraitIndex ~= -1 then
					IconHookup( portraitIndex, 80, GameInfo.Projects[iGameValue].IconAtlas, instance.ProjectConstructedAlphaAnim );				
				end
			end
			if iExtraGameData ~= -1 then
				CivIconHookup( iExtraGameData, 45, instance.CivIcon, instance.CivIconBG, instance.CivIconShadow, false, true );
				instance.ProjectSmallCivFrame:SetHide(false);				
			else
				CivIconHookup( 22, 45, instance.CivIcon, instance.CivIconBG, instance.CivIconShadow, false, true );
				instance.ProjectSmallCivFrame:SetHide(true);				
			end
		elseif type == NotificationTypes.NOTIFICATION_DISCOVERED_LUXURY_RESOURCE 
		or type == NotificationTypes.NOTIFICATION_DISCOVERED_STRATEGIC_RESOURCE 
		or type == NotificationTypes.NOTIFICATION_DISCOVERED_BONUS_RESOURCE 
		or type == NotificationTypes.NOTIFICATION_DEMAND_RESOURCE then
			local thisResourceInfo = GameInfo.Resources[iGameValue];
			local portraitIndex = thisResourceInfo.PortraitIndex;
			if portraitIndex ~= -1 then
				IconHookup( portraitIndex, 80, thisResourceInfo.IconAtlas, instance.ResourceImage );				
			end
		elseif type == NotificationTypes.NOTIFICATION_EXPLORATION_RACE then
			local thisFeatureInfo = GameInfo.Features[iGameValue];
			local portraitIndex = thisFeatureInfo.PortraitIndex;
			if portraitIndex ~= -1 then
				IconHookup( portraitIndex, 80, thisFeatureInfo.IconAtlas, instance.NaturalWonderImage );				
			end
		elseif type == NotificationTypes.NOTIFICATION_TECH_AWARD then
			local thisTechInfo = GameInfo.Technologies[iExtraGameData];
			local portraitIndex = thisTechInfo.PortraitIndex;
			if portraitIndex ~= -1 then
				IconHookup( portraitIndex, 80, thisTechInfo.IconAtlas, instance.TechAwardImage );				
			else
				instance.TechAwardImage:SetHide( true );
			end
		elseif type == NotificationTypes.NOTIFICATION_UNIT_PROMOTION
		or type == NotificationTypes.NOTIFICATION_UNIT_DIED 
		or type == NotificationTypes.NOTIFICATION_GREAT_PERSON_ACTIVE_PLAYER 			
		or type == NotificationTypes.NOTIFICATION_ENEMY_IN_TERRITORY then
			local thisUnitType = iGameValue;
			local thisUnitInfo = GameInfo.Units[thisUnitType];
			local portraitIndex = thisUnitInfo.PortraitIndex;
			if portraitIndex ~= -1 then
				IconHookup( portraitIndex, 80, thisUnitInfo.IconAtlas, instance.UnitImage );				
			end
		elseif type == NotificationTypes.NOTIFICATION_WAR_ACTIVE_PLAYER then
			local index = iGameValue;
			CivIconHookup( index, 80, instance.WarImage, instance.CivIconBG, instance.CivIconShadow, false, true ); 
		elseif type == NotificationTypes.NOTIFICATION_WAR then
			local index = iGameValue;
			CivIconHookup( index, 45, instance.War1Image, instance.Civ1IconBG, instance.Civ1IconShadow, false, true );
			index = iExtraGameData;
			CivIconHookup( index, 45, instance.War2Image, instance.Civ2IconBG, instance.Civ2IconShadow, false, true );
		elseif type == NotificationTypes.NOTIFICATION_PEACE_ACTIVE_PLAYER then
			local index = iGameValue;
			CivIconHookup( index, 80, instance.PeaceImage, instance.CivIconBG, instance.CivIconShadow, false, true );
		elseif type == NotificationTypes.NOTIFICATION_PEACE then
			local index = iGameValue;
			CivIconHookup( index, 45, instance.Peace1Image, instance.Civ1IconBG, instance.Civ1IconShadow, false, true );
			index = iExtraGameData;
			CivIconHookup( index, 45, instance.Peace2Image, instance.Civ2IconBG, instance.Civ2IconShadow, false, true );
		end
       
    end
    
    button:SetHide( false );
    button:SetVoid1( Id );
	-- Mod
	if type == g_CustomNotification then
		button:RegisterCallback(Mouse.eLClick, ExtraLeftClick);
		button:RegisterCallback(Mouse.eRClick, ExtraRightClick);
		g_CustomNotifications[ Id ] = name;	--not type
		g_Locations[ Id ] = {iGameValue, iExtraGameData};
	else
		button:RegisterCallback( Mouse.eLClick, GenericLeftClick );
		button:RegisterCallback( Mouse.eRClick, GenericRightClick );
		g_ActiveNotifications[ Id ] = type;
	end
	-- was:
    -- button:RegisterCallback( Mouse.eLClick, GenericLeftClick );
    -- button:RegisterCallback( Mouse.eRClick, GenericRightClick );
    -- g_ActiveNotifications[ Id ] = type;
	-- /Mod

--    title:SetText( name );
--    text:SetText( toolTip );
    
    local strToolTip = toolTip;
    button:SetToolTipString(strToolTip);
    
    ProcessStackSizes();

end
Events.NotificationAdded.Add( OnNotificationAdded );



-------------------------------------------------
-------------------------------------------------
function NotificationRemoved( Id )

    --print( "removing Notification " .. Id .. " " .. tostring( g_ActiveNotifications[ Id ] ) .. " " .. tostring( g_NameTable[ g_ActiveNotifications[ Id ] ] ) );
    
    if( g_ActiveNotifications[ Id ] == nil )
    then
        print( "Attempt to remove unknown Notification " .. tostring( Id ) );
        return;
    end
    
    
    local name = g_NameTable[ g_ActiveNotifications[ Id ] ];
    
    if( name == "Production" or
        name == "Tech" or
        name == "FreeTech" )
    then
        Controls[ name .. "Button" ]:SetHide( true );
    else
     
        if( name == nil ) then
            name = "Generic";
        end
        
        local instance = g_Instances[ Id ];
        if( instance ~= nil ) then
			Controls.SmallStack:ReleaseChild( instance[ name .. "Container" ] );
		    g_Instances[ Id ] = nil;
		end
        
    end

    ProcessStackSizes();

end
Events.NotificationRemoved.Add( NotificationRemoved );



-------------------------------------------------
-------------------------------------------------
function ProcessStackSizes()

    Controls.BigStack:CalculateSize();
    local bigY = Controls.BigStack:GetSizeY();
    Controls.SmallScrollPanel:SetSizeY( g_SmallScrollMax - bigY );

    Controls.SmallStack:CalculateSize();
    Controls.SmallStack:ReprocessAnchoring();

	Controls.SmallScrollPanel:CalculateInternalSize();
    if( Controls.SmallScrollPanel:GetRatio() ~= 1 ) then
        Controls.SmallScrollPanel:SetOffsetVal( 20, 0 );
    else
        Controls.SmallScrollPanel:SetOffsetVal( 0, 0 );
    end
    
    Controls.OuterStack:CalculateSize();
    Controls.OuterStack:ReprocessAnchoring();


    --[[   logic for autosized background grids
    local _, y = Controls.BigStack:GetSizeVal();
    if( y > 0 ) then
    	Controls.BigGrid:DoAutoSize();
    	Controls.BigGrid:SetHide( false );
    else
    	Controls.BigGrid:SetHide( true );
    end
    
    local _, y = Controls.SmallStack:GetSizeVal();
	if( y > 0 ) then
    	Controls.SmallGrid:DoAutoSize();
    	Controls.SmallGrid:SetHide( false );
	else
    	Controls.SmallGrid:SetHide( true );
	end
	--]]
	  
end

-- Mod
LuaEvents.CustomNotification.Add(
function(x, y, toolTip, Summary)
	g_CustomId = g_CustomId + 1;
	OnNotificationAdded(g_CustomId, g_CustomNotification, toolTip, Summary, x, y);
end);
-- /Mod

UI.RebroadcastNotifications();
ProcessStackSizes();