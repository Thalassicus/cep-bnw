include( "InstanceManager" );
include( "IconSupport" );
include( "SupportFunctions" );
include( "UniqueBonuses" );

local g_IsSingle = true;
local g_IsAuto   = false;
local g_IsDeletingFile = true;

-- Global Constants
g_InstanceManager = InstanceManager:new( "LoadButton", "Button", Controls.LoadFileButtonStack );
s_maxCloudSaves = Steam.GetMaxCloudSaves();

-- Global Variables
g_SavedGames = {};			-- A list of all saved game entries.
g_SelectedEntry = nil;		-- The currently selected entry.

----------------------------------------------------------------        
----------------------------------------------------------------
function OnSave()
	if(g_SelectedEntry == nil) then
		local newSave = Controls.NameBox:GetText();
		for i, v in ipairs(g_SavedGames) do
			if(v.DisplayName ~= nil and Locale.Length(v.DisplayName) > 0) then
				if(Locale.ToUpper(newSave) == Locale.ToUpper(v.DisplayName)) then
					g_SelectedEntry = v;		
				end
			end
		end
	end
	
	if(g_SelectedEntry ~= nil) then
		if(g_SelectedEntry.SaveData == nil and g_SelectedEntry.IsCloudSave) then
			for i, v in ipairs(g_SavedGames) do
				if(v == g_SelectedEntry) then
					if (Game:IsNetworkMultiPlayer()) then
						Steam.CopyLastAutoSaveToSteamCloud( i );
					else
						Steam.SaveGameToCloud(i);
					end
					break;
				end
			end
		else
			g_IsDeletingFile = false;
			Controls.Message:SetText( Locale.ConvertTextKey("TXT_KEY_OVERWRITE_TXT") );
			Controls.DeleteConfirm:SetHide(false);
			return;
		end
	else
		if (Game:IsNetworkMultiPlayer()) then
			UI.CopyLastAutoSave( Controls.NameBox:GetText() );
		else
			Game.CivupSaveGame( Controls.NameBox:GetText() );
		end
	end
	
	Controls.NameBox:ClearString();
	SetupFileButtonList();
	OnBack();
end
Controls.SaveButton:RegisterCallback( Mouse.eLClick, OnSave );

----------------------------------------------------------------        
----------------------------------------------------------------
function OnEditBoxChange( _, _, bIsEnter )	
	local text = Controls.NameBox:GetText();
	
	if( g_SelectedEntry ~= nil ) then
		local iPlayer = Game.GetActivePlayer();
		g_SelectedEntry.Instance.SelectHighlight:SetHide( true );
		SetSaveInfoToCiv(PreGame.GetCivilization(), PreGame.GetGameSpeed(), PreGame.GetEra(), 0, 
						 PreGame.GetHandicap(), PreGame.GetWorldSize(), PreGame.GetMapScript(), nil, 
						 PreGame.GetLeaderName(iPlayer),PreGame.GetCivilizationDescription(iPlayer), Players[iPlayer]:GetCurrentEra(), PreGame.GetGameType() );
						 
		g_SelectedEntry = nil;
	end
	
	if(not ValidateText(text)) then
		Controls.SaveButton:SetDisabled(true);
	else
		Controls.SaveButton:SetDisabled(false);
	end	
	Controls.Delete:SetDisabled(true); 
	
	if( bIsEnter ) then
	    OnSave();
	end
end
Controls.NameBox:RegisterCallback( OnEditBoxChange )

----------------------------------------------------------------        
----------------------------------------------------------------
function OnDelete()
	g_IsDeletingFile = true;
	Controls.Message:SetText( Locale.ConvertTextKey("TXT_KEY_CONFIRM_TXT") );
	Controls.DeleteConfirm:SetHide(false);
	Controls.BGBlock:SetHide(true);
end
Controls.Delete:RegisterCallback( Mouse.eLClick, OnDelete );

----------------------------------------------------------------        
----------------------------------------------------------------
function OnYes()
	Controls.DeleteConfirm:SetHide(true);
	Controls.BGBlock:SetHide(false);
	if(g_IsDeletingFile) then
		UI.DeleteSavedGame( g_SelectedEntry.FileName );
	else
		if(g_SelectedEntry.IsCloudSave) then
			for i, v in ipairs(g_SavedGames) do
				if(v == g_SelectedEntry) then
					Steam.SaveGameToCloud(i);
					break;
				end
			end
		else
			Game.CivupSaveGame( Controls.NameBox:GetText() );
		end
		
		OnBack();
	end
	
	SetupFileButtonList();
	Controls.NameBox:ClearString();
	Controls.SaveButton:SetDisabled(true);
end
Controls.Yes:RegisterCallback( Mouse.eLClick, OnYes );

----------------------------------------------------------------        
----------------------------------------------------------------
function OnNo( )
	Controls.DeleteConfirm:SetHide(true);
	Controls.BGBlock:SetHide(false);
end
Controls.No:RegisterCallback( Mouse.eLClick, OnNo );
-------------------------------------------------
-------------------------------------------------
function OnBack()
	-- Test if we are modal or a popup
	if (UIManager:IsModal( ContextPtr )) then
		UIManager:PopModal( ContextPtr );
	else
		UIManager:DequeuePopup( ContextPtr );
	end
    Controls.NameBox:ClearString();
    SetSelected( nil );
end
Controls.BackButton:RegisterCallback( Mouse.eLClick, OnBack );
-------------------------------------------------
-------------------------------------------------
Controls.CloudCheck:RegisterCheckHandler(function(checked)
	Controls.NameBox:ClearString();
	SetSelected( nil );
	SetupFileButtonList();
end);
-------------------------------------------------
-------------------------------------------------
function SetSelected( entry )
    if( g_SelectedEntry ~= nil ) then
        g_SelectedEntry.Instance.SelectHighlight:SetHide( true );
    end
    
    g_SelectedEntry = entry;
    
    if( entry ~= nil) then
		Controls.NameBox:SetText( entry.DisplayName );
		entry.Instance.SelectHighlight:SetHide( false );
		
		if(entry.SaveData == nil and entry.FileName ~= nil and not entry.IsCloudSave) then
			entry.SaveData = PreGame.GetFileHeader(entry.FileName);
		end
		
		if(entry.SaveData ~= nil) then
			local header = entry.SaveData;
			
			local date;
			if(entry.FileName) then
				date = UI.GetSavedGameModificationTime(entry.FileName);
			end
			
			SetSaveInfoToCiv(header.PlayerCivilization, header.GameSpeed, header.StartEra, header.TurnNumber, header.Difficulty, header.WorldSize, header.MapScript, date, header.LeaderName, header.CivilizationName, header.CurrentEra, header.GameType);
			Controls.Delete:SetDisabled(false); 
		
		elseif(entry.IsCloudSave) then
			SetSaveInfoToEmptyCloudSave();
		else
			SetSaveInfoToNone();
		end
		
		Controls.SaveButton:SetDisabled(false);  
			
	else -- No saves are selected
		local iPlayer = Game.GetActivePlayer();
		SetSaveInfoToCiv(PreGame.GetCivilization(), PreGame.GetGameSpeed(), PreGame.GetEra(), Game.GetElapsedGameTurns(), 
						 PreGame.GetHandicap(), PreGame.GetWorldSize(), PreGame.GetMapScript(), nil,
						 PreGame.GetLeaderName(iPlayer), PreGame.GetCivilizationDescription(iPlayer), Players[iPlayer]:GetCurrentEra(), PreGame.GetGameType() );
		Controls.Delete:SetDisabled(true);
    end
end

-------------------------------------------------
-------------------------------------------------
function SetSaveInfoToCiv(civType, gameSpeed, era, turn, difficulty, mapSize, mapScript, date, leaderName, civName, curEra, gameType)
	--Set Era Text
	if(curEra ~= "")then
		Controls.EraTurn:SetText( Locale.ConvertTextKey("TXT_KEY_CUR_ERA_TURNS_FORMAT", 
								  Locale.ConvertTextKey(GameInfo.Eras[curEra].Description), turn));
	else
		Controls.EraTurn:SetText( Locale.ConvertTextKey("TXT_KEY_CUR_ERA_TURNS_FORMAT", 
								  Locale.ConvertTextKey("TXT_KEY_MISC_UNKNOWN"), turn));
	end
				  
	Controls.StartEra:SetText(  Locale.ConvertTextKey("TXT_KEY_START_ERA", Locale.ConvertTextKey(GameInfo.Eras[era].Description)));
							  
	-- Set Save file time
	if(date ~= nil) then
		Controls.TimeSaved:SetText(date);	
	else
		Controls.TimeSaved:SetText("");
	end
	
	if (gameType == GameTypes.GAME_HOTSEAT_MULTIPLAYER) then
		Controls.GameType:SetText( Locale.ConvertTextKey("TXT_KEY_MULTIPLAYER_HOTSEAT_GAME") );
	else
		if (gameType == GameTypes.GAME_NETWORK_MULTIPLAYER) then
			Controls.GameType:SetText(  Locale.ConvertTextKey("TXT_KEY_MULTIPLAYER_STRING") );
		else
			if (gameType == GameTypes.GAME_SINGLE_PLAYER) then
				Controls.GameType:SetText(  Locale.ConvertTextKey("TXT_KEY_SINGLE_PLAYER") );
			else
				Controls.GameType:SetText( "" );
			end
		end
	end
	
	
	-- ? leader icon
	IconHookup( 22, 128, "LEADER_ATLAS", Controls.Portrait );
	local civDesc = Locale.ConvertTextKey("TXT_KEY_MISC_UNKNOWN");
	local leaderDescription = Locale.ConvertTextKey("TXT_KEY_MISC_UNKNOWN");
	
	-- Sets civ icon and tool tip
	local civ = GameInfo.Civilizations[civType];
	if (civ ~= nil) then
		civDesc = Locale.ConvertTextKey(civ.Description);
		local leader = GameInfo.Leaders[GameInfo.Civilization_Leaders( "CivilizationType = '" .. civ.Type .. "'" )().LeaderheadType];
		if (leader ~= nil) then		
			leaderDescription = Locale.ConvertTextKey(leader.Description);
			IconHookup( leader.PortraitIndex, 128, leader.IconAtlas, Controls.Portrait );
		end
		local textureOffset, textureAtlas = IconLookup( civ.PortraitIndex, 64, civ.IconAtlas );
		if textureOffset ~= nil then       
			Controls.CivIcon:SetTexture( textureAtlas );
			Controls.CivIcon:SetTextureOffset( textureOffset );
			Controls.CivIcon:SetToolTipString( Locale.ConvertTextKey( civ.ShortDescription) );
		end
		Controls.LargeMapImage:UnloadTexture();
		local mapTexture = civ.MapImage;
		Controls.LargeMapImage:SetTexture(mapTexture);		
	end
		
	if(leaderName ~= nil and leaderName ~= "")then
		leaderDescription = leaderName;
	end
	
	if(civName ~= nil and civName ~= "")then
		civDesc = civName;
	end
	Controls.Title:LocalizeAndSetText("TXT_KEY_RANDOM_LEADER_CIV", leaderDescription, civDesc );
	
	-- Sets map type icon and tool tip
	--First check if it's a map script
	for row in GameInfo.MapScripts{FileName = mapScript, SupportsSinglePlayer = 1, Hidden = 0} do
		IconHookup( row.IconIndex or 0, 64, row.IconAtlas, Controls.MapType );
		Controls.MapType:SetToolTipString( Locale.ConvertTextKey( row.Name or "" ) );
		bFound = true;
		break;
	end
	
	--Then check if it's a known earth map,
	if(not bFound) then
	
		local earthMaps = {
			"Assets\\Maps\\Earth_Duel.Civ5Map",
			"Assets\\Maps\\Earth_Huge.Civ5Map",
			"Assets\\Maps\\Earth_Large.Civ5Map",
			"Assets\\Maps\\Earth_Small.Civ5Map",
			"Assets\\Maps\\Earth_Standard.Civ5Map",
			"Assets\\Maps\\Earth_Tiny.Civ5Map",
		}

		
		for i,v in ipairs(earthMaps) do
			if(v == mapScript) then
				IconHookup(3, 64, "WORLDTYPE_ATLAS", Controls.MapType);
				Controls.MapType:LocalizeAndSetToolTip("TXT_KEY_MAP_EARTH_TITLE");
				bFound = true;
				break;
			end
		end
	end
	
	--Then attempt to use it as a WB map
	if(not bFound) then
		local mapData = UI.GetMapPreview(mapScript);
		if(mapData ~= nil) then
			local name = mapData.Name;
			if(name == nil) then
				name = Path.GetFileNameWithoutExtension(mapScript);
			end
			IconHookup(4, 64, "WORLDTYPE_ATLAS", Controls.MapType);
			Controls.MapType:LocalizeAndSetToolTip(name);
		end
	end
	
	-- Sets map size icon and tool tip
	info = GameInfo.Worlds[ mapSize ];
	if(info ~= nil) then
		IconHookup( info.PortraitIndex, 64, info.IconAtlas, Controls.MapSize );
		Controls.MapSize:SetToolTipString( Locale.ConvertTextKey( info.Description) );
	else
		if(questionOffset ~= nil) then
			Controls.MapSize:SetTexture( questionTextureSheet );
			Controls.MapSize:SetTextureOffset( questionOffset );
			Controls.MapSize:SetToolTipString( unknownString );
		end
	end
	
	-- Sets handicap icon and tool tip
	info = GameInfo.HandicapInfos[ difficulty ];
	if(info ~= nil) then
		IconHookup( info.PortraitIndex, 64, info.IconAtlas, Controls.Handicap );
		Controls.Handicap:SetToolTipString( Locale.ConvertTextKey( info.Description ) );
	else
		if(questionOffset ~= nil) then
			Controls.Handicap:SetTexture( questionTextureSheet );
			Controls.Handicap:SetTextureOffset( questionOffset );
			Controls.Handicap:SetToolTipString( unknownString );
		end
	end
	
	-- Sets game pace icon and tool tip
	info = GameInfo.GameSpeeds[ gameSpeed ];
	if(info ~= nil) then
		IconHookup( info.PortraitIndex, 64, info.IconAtlas, Controls.SpeedIcon );
		Controls.SpeedIcon:SetToolTipString( Locale.ConvertTextKey( info.Description ) );
	else
		if(questionOffset ~= nil) then
			Controls.SpeedIcon:SetTexture( questionTextureSheet );
			Controls.SpeedIcon:SetTextureOffset( questionOffset );
			Controls.SpeedIcon:SetToolTipString( unknownString );
		end
	end
end

function SetSaveInfoToNone()
	-- Disable ability to enter game if none are selected
	Controls.SaveButton:SetDisabled(true);
	Controls.Delete:SetDisabled(true);
	
	-- Empty all text fields
	Controls.Title:SetText( "" );
	Controls.EraTurn:SetText( "" );
	Controls.TimeSaved:SetText( "" );
	Controls.StartEra:SetText( "" );
	Controls.GameType:SetText( "" );

	-- ? leader icon
	IconHookup( 22, 128, "LEADER_ATLAS", Controls.Portrait );
	
	-- Set all icons across bottom of left panel to ?
	if questionOffset ~= nil then      
		-- Civ Icon 
		Controls.CivIcon:SetTexture( questionTextureSheet );
		Controls.CivIcon:SetTextureOffset( questionOffset );
		Controls.CivIcon:SetToolTipString( unknownString );

		-- Map Type Icon 
		Controls.MapType:SetTexture( questionTextureSheet );
		Controls.MapType:SetTextureOffset( questionOffset );
		Controls.MapType:SetToolTipString( unknownString );
		-- Map Size Icon 
		Controls.MapSize:SetTexture( questionTextureSheet );
		Controls.MapSize:SetTextureOffset( questionOffset );
		Controls.MapSize:SetToolTipString( unknownString );
		-- Handicap Icon 
		Controls.Handicap:SetTexture( questionTextureSheet );
		Controls.Handicap:SetTextureOffset( questionOffset );
		Controls.Handicap:SetToolTipString( unknownString );
		-- Game Speed Icon 
		Controls.SpeedIcon:SetTexture( questionTextureSheet );
		Controls.SpeedIcon:SetTextureOffset( questionOffset );
		Controls.SpeedIcon:SetToolTipString( unknownString );
	end
    
	-- Set Selected Civ Map
	Controls.LargeMapImage:UnloadTexture();
	local mapTexture="MapRandom512.dds";
	Controls.LargeMapImage:SetTexture(mapTexture);
end

function SetSaveInfoToEmptyCloudSave()
	
	-- Empty all text fields
	Controls.Title:LocalizeAndSetText("TXT_KEY_STEAM_EMPTY_SAVE");
	Controls.EraTurn:SetText("");
	Controls.TimeSaved:SetText("");
	Controls.StartEra:SetText( "" );
	Controls.GameType:SetText("");

	-- ? leader icon
	IconHookup( 22, 128, "LEADER_ATLAS", Controls.Portrait );
	
	-- Set all icons across bottom of left panel to ?
	if questionOffset ~= nil then      
		-- Civ Icon 
		Controls.CivIcon:SetTexture( questionTextureSheet );
		Controls.CivIcon:SetTextureOffset( questionOffset );
		Controls.CivIcon:SetToolTipString( unknownString );

		-- Map Type Icon 
		Controls.MapType:SetTexture( questionTextureSheet );
		Controls.MapType:SetTextureOffset( questionOffset );
		Controls.MapType:SetToolTipString( unknownString );
		-- Map Size Icon 
		Controls.MapSize:SetTexture( questionTextureSheet );
		Controls.MapSize:SetTextureOffset( questionOffset );
		Controls.MapSize:SetToolTipString( unknownString );
		-- Handicap Icon 
		Controls.Handicap:SetTexture( questionTextureSheet );
		Controls.Handicap:SetTextureOffset( questionOffset );
		Controls.Handicap:SetToolTipString( unknownString );
		-- Game Speed Icon 
		Controls.SpeedIcon:SetTexture( questionTextureSheet );
		Controls.SpeedIcon:SetTextureOffset( questionOffset );
		Controls.SpeedIcon:SetToolTipString( unknownString );
	end
    
	-- Set Selected Civ Map
	Controls.LargeMapImage:UnloadTexture();
	local mapTexture="MapRandom512.dds";
	Controls.LargeMapImage:SetTexture(mapTexture);
end
----------------------------------------------------------------        
----------------------------------------------------------------
function ChopFileName(file)
	_, _, chop = string.find(file,"\\.+\\(.+)%."); 
	return chop;
end

----------------------------------------------------------------        
----------------------------------------------------------------
function ValidateText(text)
	local isAllWhiteSpace = true;
	for i = 1, #text, 1 do
		if (string.byte(text, i) ~= 32) then
			isAllWhiteSpace = false;
			break;
		end
	end
	
	if (isAllWhiteSpace) then
		return false;
	end

	-- don't allow % character
	for i = 1, #text, 1 do
		if string.byte(text, i) == 37 then
			return false;
		end
	end

	local invalidCharArray = { '\"', '<', '>', '|', '\b', '\0', '\t', '\n', '/', '\\', '*', '?', ':' };

	for i, ch in ipairs(invalidCharArray) do
		if (string.find(text, ch) ~= nil) then
			return false;
		end
	end

	-- don't allow control characters
	for i = 1, #text, 1 do
		if (string.byte(text, i) < 32) then
			return false;
		end
	end

	return true;
end

----------------------------------------------------------------        
----------------------------------------------------------------
function SetupFileButtonList()
	SetSelected( nil );
    g_InstanceManager:ResetInstances();
    
    SetSaveInfoToNone();
    
    local bUsingSteamCloud = Controls.CloudCheck:IsChecked();
    
    if(bUsingSteamCloud) then
		local cloudSaveData = Steam.GetCloudSaves();
		
		local sortTable = {};
		
		for i = 1, s_maxCloudSaves, 1 do
			
			local instance = g_InstanceManager:GetInstance();
			local data = cloudSaveData[i];
			
			g_SavedGames[i] = {
				Instance = instance,
				SaveData = data,
				IsCloudSave = true,
			}
			
			local title = Locale.ConvertTextKey("TXT_KEY_STEAM_EMPTY_SAVE");
			if(data ~= nil) then
			
				local civName = Locale.ConvertTextKey("TXT_KEY_MISC_UNKNOWN");
				local leaderDescription = Locale.ConvertTextKey("TXT_KEY_MISC_UNKNOWN");
				
				local civ = GameInfo.Civilizations[ data.PlayerCivilization ];
				if(civ ~= nil) then
					local leader = GameInfo.Leaders[GameInfo.Civilization_Leaders( "CivilizationType = '" .. civ.Type .. "'" )().LeaderheadType];
					leaderDescription = Locale.Lookup(leader.Description);
					civName = Locale.Lookup(civ.Description);
				end

				if(not Locale.IsNilOrWhitespace(data.CivilizationName)) then
					civName = data.CivilizationName;
				end
				
				if(not Locale.IsNilOrWhitespace(data.LeaderName)) then
					leaderDescription = data.LeaderName;
				end
				
				title = Locale.Lookup("TXT_KEY_RANDOM_LEADER_CIV", leaderDescription, civName );
			end
			
			instance.ButtonText:LocalizeAndSetText("TXT_KEY_STEAMCLOUD_SAVE", i, title);
			instance.Button:RegisterCallback( Mouse.eLClick, function() SetSelected(g_SavedGames[i]); end);
		end
    else
        -- build a table of all save file names that we found
        local savedGames = {};
        local gameType = GameTypes.GAME_SINGLE_PLAYER;
        if (Game:IsGameMultiPlayer()) then
	        if (Game:IsNetworkMultiPlayer()) then
				gameType = GameTypes.GAME_NETWORK_MULTIPLAYER;
	        else
				gameType = GameTypes.GAME_HOTSEAT_MULTIPLAYER;
			end
        end
		UI.SaveFileList( savedGames, gameType, false, true);
	   
		for i, v in ipairs(savedGames) do
    		local instance = g_InstanceManager:GetInstance();
    		
    		-- chop the part that we are going to display out of the bigger string
			local displayName = Path.GetFileNameWithoutExtension(v);
						
			g_SavedGames[i] = {
				Instance = instance,
				FileName = v,
				DisplayName = displayName,
			}
	    	
			TruncateString(instance.ButtonText, instance.Button:GetSizeX(), displayName); 
			
			instance.Button:SetVoid1( i );
			instance.Button:RegisterCallback( Mouse.eLClick, function() SetSelected(g_SavedGames[i]); end);
		end
    end
    
	Controls.Delete:SetHide(bUsingSteamCloud);
	Controls.NameBoxFrame:SetHide(bUsingSteamCloud);
	
	Controls.LoadFileButtonStack:CalculateSize();
    Controls.LoadFileButtonStack:ReprocessAnchoring();
    Controls.ScrollPanel:CalculateInternalSize();
end


----------------------------------------------------------------        
---------------------------------------------------------------- 
function OnSaveMap()
    UIManager:QueuePopup( Controls.SaveMapMenu, PopupPriority.SaveMapMenu );
end
Controls.SaveMapButton:RegisterCallback( Mouse.eLClick, OnSaveMap );


----------------------------------------------------------------        
-- Key Down Processing
----------------------------------------------------------------        
function InputHandler( uiMsg, wParam, lParam )
    if uiMsg == KeyEvents.KeyDown then
        if wParam == Keys.VK_ESCAPE then
			if(Controls.DeleteConfirm:IsHidden())then
				OnBack();
			else
				Controls.DeleteConfirm:SetHide(true);
            	Controls.BGBlock:SetHide(false);
			end
        end
    end
    return true;
end
ContextPtr:SetInputHandler( InputHandler );

----------------------------------------------------------------        
----------------------------------------------------------------
function ShowHideHandler( isHide )
    if( not isHide ) then

    	-- If the lock mods option is on then disable the save map button
    	if( Game:IsNetworkMultiPlayer() or
    	    Modding.AnyActivatedModsContainPropertyValue( "DisableSaveMapOption", "1" ) or
        	Game.IsOption( GameOptionTypes.GAMEOPTION_LOCK_MODS ) or
        	UIManager:IsModal( ContextPtr ) ) then
        	Controls.SaveMapButton:SetHide( true );
    	else
        	Controls.SaveMapButton:SetHide( false );
    	end
    	
		local iPlayer = Game.GetActivePlayer();
		local leaderName = PreGame.GetLeaderName(iPlayer);
		local civ = PreGame.GetCivilization();
		local civInfo = GameInfo.Civilizations[civ];
		local leader = GameInfo.Leaders[GameInfo.Civilization_Leaders( "CivilizationType = '" .. civInfo.Type .. "'" )().LeaderheadType];
		
		local leaderDescription = Locale.ConvertTextKey(leader.Description);
		if leaderName ~= nil and leaderName ~= "" then
			leaderDescription = leaderName;
		end
        
        Controls.NameBox:SetText(leaderDescription.."_"..Game.GetTimeString());
        Controls.NameBox:TakeFocus();
		SetupFileButtonList();
		OnEditBoxChange();
	end
end
ContextPtr:SetShowHideHandler( ShowHideHandler );