-------------------------------------------------
-- Game View 
-------------------------------------------------
include("IconSupport")
include("InstanceManager")
include("SupportFunctions")
include("TutorialPopupScreen")
include("InfoTooltipInclude")

local log = Events.LuaLogger:New()
log:SetLevel("WARN")

local showTimers = Civup.DEBUG_TIMER_LEVEL

local g_BuildingIM   = InstanceManager:new( "BuildingInstance", "BuildingButton", Controls.BuildingStack )
local g_GPIM   = InstanceManager:new( "GPInstance", "GPBox", Controls.GPStack )
local g_SlackerIM   = InstanceManager:new( "SlackerInstance", "SlackerButton", Controls.BoxOSlackers )
local g_PlotButtonIM   = InstanceManager:new( "PlotButtonInstance", "PlotButtonAnchor", Controls.PlotButtonContainer )
local g_BuyPlotButtonIM   = InstanceManager:new( "BuyPlotButtonInstance", "BuyPlotButtonAnchor", Controls.PlotButtonContainer )
--Specialist
local g_SpecialistSlotIM   = InstanceManager:new( "SpecialistSlotInstance", "SpecialistSlotButton", Controls.SpecialistBox )
local g_SpecialistIconIM   = InstanceManager:new( "SpecialistIconInstance", "SpecialistIconButton", Controls.SpecialistBox )

local WorldPositionOffset = { x = 0, y = 0, z = 30 }

local WorldPositionOffset2 = { x = 0, y = 35, z = 0 }

local g_iPortraitSize = Controls.ProductionPortrait:GetSize().x

local screenSizeX, screenSizeY = UIManager:GetScreenSizeVal()

local pediaSearchStrings = {}

local gPreviousCity = nil
local specialistTable = {}

local g_iBuildingToSell = -1

local g_bRazeButtonDisabled = false

function FormatYield(num)
	num = Game.Round(num)
	return (num >= 0) and num or string.format("[COLOR_WARNING_TEXT]%s[ENDCOLOR]", num)
end


-- Add any interface modes that need special processing to this table
local InterfaceModeMessageHandler = 
{
	[InterfaceModeTypes.INTERFACEMODE_SELECTION] = {},
	--[InterfaceModeTypes.INTERFACEMODE_CITY_PLOT_SELECTION] = {},
	[InterfaceModeTypes.INTERFACEMODE_PURCHASE_PLOT] = {}
}
-------------------------------------------------
-- Clear out the UI so that when a player changes
-- the next update doesn't show the previous player's
-- values for a frame
-------------------------------------------------
function ClearCityUIInfo()

	Controls.b1number:SetHide( true )
	Controls.b1down:SetHide( true )
	Controls.b1remove:SetHide( true )
	Controls.b2box:SetHide( true )
	Controls.b3box:SetHide( true )
	Controls.b4box:SetHide( true )
	Controls.b5box:SetHide( true )
	Controls.b6box:SetHide( true )

	Controls.ProductionItemName:SetText("")	
	Controls.ProductionPortraitButton:SetHide(true)		
	Controls.ProductionHelp:SetHide(true)

end

-----------------------------------------------------------------
-- CITY SCREEN CLOSED
-----------------------------------------------------------------
function CityScreenClosed()
	
	UI.SetInterfaceMode(InterfaceModeTypes.INTERFACEMODE_SELECTION)
	OnCityViewUpdate()
	-- We may get here after a player change, clear the UI if this is not the active player's city
	local city = UI.GetHeadSelectedCity()
	if city ~= nil then
		if city:GetOwner() ~= Game.GetActivePlayer() then
			ClearCityUIInfo()
		end
	end
	UI.ClearSelectedCities()
	
	LuaEvents.TryDismissTutorial("CITY_SCREEN")
	
	g_iCurrentSpecialist = -1
	if (not Controls.SellBuildingConfirm:IsHidden()) then 
		Controls.SellBuildingConfirm:SetHide(true)
	end
	g_iBuildingToSell = -1
		
	UI.SetCityScreenViewingMode(false)
end
Events.SerialEventExitCityScreen.Add(CityScreenClosed)

local DefaultMessageHandler = {}

DefaultMessageHandler[KeyEvents.KeyDown] =
function( wParam, lParam )
	
	local interfaceMode = UI.GetInterfaceMode()
	if (--	interfaceMode == InterfaceModeTypes.INTERFACEMODE_CITY_PLOT_SELECTION or
		interfaceMode == InterfaceModeTypes.INTERFACEMODE_PURCHASE_PLOT) then
		if ( wParam == Keys.VK_ESCAPE or wParam == Keys.VK_RETURN ) then
			UI.SetInterfaceMode(InterfaceModeTypes.INTERFACEMODE_SELECTION)
			return true
		end	
	else
		if ( wParam == Keys.VK_ESCAPE or wParam == Keys.VK_RETURN ) then
			if(Controls.SellBuildingConfirm:IsHidden())then
				--CloseScreen()
				Events.SerialEventExitCityScreen()
				return true
			else
				Controls.SellBuildingConfirm:SetHide(true)
				g_iBuildingToSell = -1
				return true
			end
		elseif wParam == Keys.VK_LEFT then
			Game.DoControl(GameInfoTypes.CONTROL_PREVCITY)
			return true
		elseif wParam == Keys.VK_RIGHT then
			Game.DoControl(GameInfoTypes.CONTROL_NEXTCITY)
			return true
		end
	end
	
    return false
end


InterfaceModeMessageHandler[InterfaceModeTypes.INTERFACEMODE_SELECTION][MouseEvents.LButtonDown] = 
function( wParam, lParam )	
	if GameDefines.CITY_SCREEN_CLICK_WILL_EXIT == 1 then
		UI.ClearSelectedCities()
		return true
	end

	return false
end


--InterfaceModeMessageHandler[InterfaceModeTypes.INTERFACEMODE_PURCHASE_PLOT][MouseEvents.LButtonDown] = 
--function( wParam, lParam )
	--local hexX, hexY = UI.GetMouseOverHex()
	--local plot = Map.GetPlot( hexX, hexY )
	--local plotX = plot:GetX()
	--local plotY = plot:GetY()
	--local bShift = UIManager:GetShift()
	--local bAlt = UIManager:GetAlt()
	--local bCtrl = UIManager:GetControl()
	--local activePlayerID = Game.GetActivePlayer()
	--local pHeadSelectedCity = UI.GetHeadSelectedCity()
	--if pHeadSelectedCity then
		--if (plot:GetOwner() ~= activePlayerID) then
			--Events.AudioPlay2DSound("AS2D_INTERFACE_BUY_TILE")		
		--end
		--Network.SendCityBuyPlot(pHeadSelectedCity:GetID(), plotX, plotY)
	--end
	--return true
--end
--
----------------------------------------------------------------        
----------------------------------------------------------------        
InterfaceModeMessageHandler[InterfaceModeTypes.INTERFACEMODE_PURCHASE_PLOT][MouseEvents.RButtonUp] = 
function( wParam, lParam )
	UI.SetInterfaceMode(InterfaceModeTypes.INTERFACEMODE_SELECTION)
end


----------------------------------------------------------------        
-- Input handling 
-- (this may be overkill for now because there is currently only 
-- one InterfaceMode on this display, but if we add some, which we did...)
----------------------------------------------------------------        
function InputHandler( uiMsg, wParam, lParam )
	local interfaceMode = UI.GetInterfaceMode()
	local currentInterfaceModeHandler = InterfaceModeMessageHandler[interfaceMode]
	if currentInterfaceModeHandler and currentInterfaceModeHandler[uiMsg] then
		return currentInterfaceModeHandler[uiMsg]( wParam, lParam )
	elseif DefaultMessageHandler[uiMsg] then
		return DefaultMessageHandler[uiMsg]( wParam, lParam )
	end
	return false
end
ContextPtr:SetInputHandler( InputHandler )

SpecControlArt = {}
SpecControlArt["SPECIALIST_ARTIST"] = {}
SpecControlArt["SPECIALIST_ARTIST"].Texture = "citizenArtist.dds"
SpecControlArt["SPECIALIST_ARTIST"].Label = "[ICON_CULTURE]"
SpecControlArt["SPECIALIST_ENGINEER"] = {}
SpecControlArt["SPECIALIST_ENGINEER"].Texture = "citizenEngineer.dds"
SpecControlArt["SPECIALIST_ENGINEER"].Label = "[ICON_PRODUCTION]"
SpecControlArt["SPECIALIST_MERCHANT"] = {}
SpecControlArt["SPECIALIST_MERCHANT"].Texture = "citizenMerchant.dds"
SpecControlArt["SPECIALIST_MERCHANT"].Label = "[ICON_GOLD]"
SpecControlArt["SPECIALIST_SCIENTIST"] = {}
SpecControlArt["SPECIALIST_SCIENTIST"].Texture = "citizenScientist.dds"
SpecControlArt["SPECIALIST_SCIENTIST"].Label = "[ICON_RESEARCH]"

local defaultErrorTextureSheet = "ProductionAtlas.dds"
local nullOffset = Vector2( 0, 0 )

local artistTexture = "citizenArtist.dds"
local engineerTexture = "citizenEngineer.dds"
local merchantTexture = "citizenMerchant.dds"
local scientistTexture = "citizenScientist.dds"
local unemployedTexture = "citizenUnemployed.dds"
local workerTexture = "citizenWorker.dds"
local emptySlotString = Locale.ConvertTextKey("TXT_KEY_CITYVIEW_EMPTY_SLOT")

---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

local otherSortedList = {}
local sortOrder = 0

function CVSortFunction( a, b )

    local aVal = otherSortedList[ tostring( a ) ]
    local bVal = otherSortedList[ tostring( b ) ]
    
    if (aVal == nil) or (bVal == nil) then 
		if aVal and (bVal == nil) then
			return false
		elseif (aVal == nil) and bVal then
			return true
		else
			return tostring(a) < tostring(b) -- gotta do something deterministic
        end
    else
        return aVal < bVal
    end
end

---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

local workerHeadingOpen = true--OptionsManager.IsNoCitizenWarning()
local slackerHeadingOpen = true
local GPHeadingOpen = true
local specialistHeadingOpen = true
local wonderHeadingOpen = false
local specialistBuildingHeadingOpen = false
local marketplaceBuildingHeadingOpen = false
local buildingHeadingOpen = false
local productionQueueOpen = false

function OnSlackersSelected()
	local city = UI.GetHeadSelectedCity()
	if city ~= nil then
		Network.SendDoTask(city:GetID(), TaskTypes.TASK_REMOVE_SLACKER, 0, -1, false, bAlt, bShift, bCtrl)
	end
end

function OnWorkerHeaderSelected()
	workerHeadingOpen = not workerHeadingOpen
	OnCityViewUpdate()
end

function OnSlackerHeaderSelected()
	slackerHeadingOpen = not slackerHeadingOpen
	OnCityViewUpdate()
end

function OnSpecialistHeaderSelected()
	specialistHeadingOpen = not specialistHeadingOpen
	OnCityViewUpdate()
end

function OnGPHeaderSelected()
	GPHeadingOpen = not GPHeadingOpen
	OnCityViewUpdate()
end

function OnWondersHeaderSelected()
	wonderHeadingOpen = not wonderHeadingOpen
	OnCityViewUpdate()
end

function OnMarketplaceHeaderSelected()
	marketplaceBuildingHeadingOpen = not marketplaceBuildingHeadingOpen
	OnCityViewUpdate()
end

function OnSpecialistBuildingsHeaderSelected()
	specialistBuildingHeadingOpen = not specialistBuildingHeadingOpen
	OnCityViewUpdate()
end

function OnBuildingsHeaderSelected()
	buildingHeadingOpen = not buildingHeadingOpen
	OnCityViewUpdate()
end

function GetPedia( void1, void2, button )
	local searchString = pediaSearchStrings[tostring(button)]
	Events.SearchForPediaEntry( searchString )		
end

-------------------------------------------------
-------------------------------------------------
function OnEditNameClick()
	if UI.GetHeadSelectedCity() then
		local popupInfo = {
				Type = ButtonPopupTypes.BUTTONPOPUP_RENAME_CITY,
				Data1 = UI.GetHeadSelectedCity():GetID(),
				Data2 = -1,
				Data3 = -1,
				Option1 = false,
				Option2 = false
			}
		Events.SerialEventGameMessagePopup(popupInfo)
	end
end
Controls.EditButton:RegisterCallback( Mouse.eLClick, OnEditNameClick )


function AddBuildingButton( city, building )
	local buildingID			= building.ID
	local buildingClass			= building.BuildingClass
	local isMarketplace			= (building.IsMarketplace ~= 0 and isBuildingAddonParent)
	local isBuildingAddon 		= Game.HasValue({BuildingType=building.Type}, GameInfo.Building_Addons)
	local isBuildingAddonParent	= Game.HasValue({ParentBuildingClass=buildingClass}, GameInfo.Building_Addons)
	local buildingSize			= 64
	local buildingOffsetX		= 0
	
	if not (city:IsHasBuilding(buildingID) and building.IsVisible) then
		return
	end
	
	local controlTable = g_BuildingIM:GetInstance()
	
	sortOrder = sortOrder + 1
	otherSortedList[tostring( controlTable.BuildingButton )] = sortOrder
	
	--controlTable.BuildingButton:RegisterCallback( Mouse.eLClick, OnBuildingClick )
	--controlTable.BuildingButton:SetVoid1( buildingID )

	if (city:GetNumFreeBuilding(buildingID) > 0) then
		bIsBuildingFree = true
	else
		bIsBuildingFree = false
	end

	-- Empires Enhanced
	-- Check if Addition/Marketplace
	if isMarketplace or isBuildingAddon then
		buildingSize = 32
		buildingOffsetX = 10
	end
	
	-- Name
	local strBuildingName
	local strBuildingNameIcon
	
	-- Small Icon
	if (building.IsMarketplace == 1) then
		strBuildingNameIcon = " "
	elseif isBuildingAddon then
		strBuildingNameIcon = "[ICON_WTF2]"
		controlTable.BuildingNameIcon:SetAnchor("L,T")
	else
		strBuildingNameIcon = " "

		if city:IsHasBuilding(buildingID) and isBuildingAddonParent then
			strBuildingNameIcon = "[ICON_CITY_STATE]"
			controlTable.BuildingNameIcon:SetAnchor("L,B")
		end
	end

	-- Religious Buildings have special names
	if (building.IsReligious) then
		strBuildingName = Locale.ConvertTextKey("TXT_KEY_RELIGIOUS_BUILDING", building.Description, player:GetStateReligionKey())
	elseif isBuildingAddon then
		strBuildingName = Locale.ConvertTextKey(building.ShortDescription)
	else
		strBuildingName = Locale.ConvertTextKey(building.Description)
	end

	-- Building is free, add an asterisk to the name
	if (bIsBuildingFree) then
		strBuildingName = strBuildingName .. " (" .. Locale.ConvertTextKey("TXT_KEY_FREE") .. ")"
	end

	-- Multiple copies of the building
	local numCopies = City_GetNumBuilding(city, buildingID)
	if numCopies ~= 1 then
		strBuildingName = strBuildingName .. " (x" .. numCopies .. ")"
	end
	
	controlTable.BuildingName:SetText(strBuildingName)
	controlTable.BuildingNameIcon:SetText(strBuildingNameIcon)

	pediaSearchStrings[tostring(controlTable.BuildingButton)] = Locale.ConvertTextKey(building.Description)
	controlTable.BuildingButton:RegisterCallback( Mouse.eRClick, GetPedia )
			
	-- Empires Enhanced
	-- Size
	--controlTable.BuildingImageFrame:SetSizeX(buildingSize)
	controlTable.BuildingImageFrame:SetSizeY(buildingSize)
	--controlTable.BuildingImageFrame:SetOffsetX(buildingOffsetX)	
	controlTable.BuildingButton:SetSizeY(buildingSize)
	--controlTable.BuildingButton:SetSizeX(buildingSize)
	
	-- Portrait
	
	if not isMarketplace and not isBuildingAddon and IconHookup( building.PortraitIndex, buildingSize, building.IconAtlas, controlTable.BuildingImage ) then
		controlTable.BuildingImage:SetHide( false )
		controlTable.BuildingImageFrame:SetHide( false )
		controlTable.BuildingName:SetOffsetX( 64 )
	else
		controlTable.BuildingImage:SetHide( true )
		controlTable.BuildingImageFrame:SetHide( true )
		controlTable.BuildingName:SetOffsetX( 2 )
	end
	
	-- Empty Specialist Slots
	iNumSpecialists = city:GetNumSpecialistsAllowedByBuilding(buildingID)	
	controlTable.BuildingEmptySpecialistSlot1:SetHide(true)
	controlTable.BuildingEmptySpecialistSlot2:SetHide(true)
	controlTable.BuildingEmptySpecialistSlot3:SetHide(true)
	
	-- Filled Specialist Slots
	iNumAssignedSpecialists = city:GetNumSpecialistsInBuilding(buildingID)	
	controlTable.BuildingFilledSpecialistSlot1:SetHide(true)
	controlTable.BuildingFilledSpecialistSlot2:SetHide(true)
	controlTable.BuildingFilledSpecialistSlot3:SetHide(true)

	-- Tool Tip
	local strToolTip = GetBuildingTip{buildingID=buildingID, buildingCity=city}
	if strToolTip == nil then
		log:Fatal("GetHelpTextForBuilding=nil for %s", Game.Buildings[buildingID].Type)
	end
	
	if (iNumAssignedSpecialists > 0) then
		if(building.SpecialistType) then
			local specialistInfo = GameInfo.Specialists[building.SpecialistType]
			local iSpecialistID = specialistInfo.ID
			
			strToolTip = strToolTip .. "[NEWLINE][NEWLINE]"
			strToolTip = strToolTip .. iNumAssignedSpecialists .. " " .. Locale.ConvertTextKey(specialistInfo.Description) .. "..."
			
			-- Culture
			local iCultureFromSpecialist = city:GetCultureFromSpecialist(iSpecialistID)
			if (iCultureFromSpecialist > 0) then
				strToolTip = strToolTip .. " " .. iCultureFromSpecialist .. "[ICON_CULTURE]"
			end
			
			-- Yield
			for yieldInfo in GameInfo.Yields() do
				local iYieldID = yieldInfo.ID
				local iYieldAmount = City_GetSpecialistYield(city, iYieldID, iSpecialistID)
				
				if (iYieldAmount > 0) then
					--log:Debug("A %s %s = %s", specialistInfo.Type, yieldInfo.Type, iYieldAmount)
					strToolTip = strToolTip .. " " .. iYieldAmount .. yieldInfo.IconString
				end
			end
			
			strToolTip = strToolTip .. Locale.ConvertTextKey( "TXT_KEY_CITYVIEW_EACH" )
		end				
	end
	
	-- Can we sell this thing?
	if (city:IsBuildingSellable(buildingID)) then
		strToolTip = strToolTip .. "[NEWLINE][NEWLINE]" .. Locale.ConvertTextKey( "TXT_KEY_CLICK_TO_SELL" )
		controlTable.BuildingButton:RegisterCallback( Mouse.eLClick, OnBuildingClicked )
		controlTable.BuildingButton:SetVoid1( buildingID )
	-- We have to clear the data out here or else the instance manager will recycle it in other cities!
	else
		controlTable.BuildingButton:ClearCallback(Mouse.eLClick)
		controlTable.BuildingButton:SetVoid1( -1 )
	end
	
	controlTable.BuildingButton:SetToolTipString(strToolTip)
	
	-- Viewing Mode only
	if (UI.IsCityScreenViewingMode()) then
		controlTable.BuildingButton:SetDisabled( true )

		controlTable.BuildingFilledSpecialistSlot1:SetDisabled( true )
		controlTable.BuildingFilledSpecialistSlot2:SetDisabled( true )
		controlTable.BuildingFilledSpecialistSlot3:SetDisabled( true )
		controlTable.BuildingEmptySpecialistSlot1:SetDisabled( true )
		controlTable.BuildingEmptySpecialistSlot2:SetDisabled( true )
		controlTable.BuildingEmptySpecialistSlot3:SetDisabled( true )
	else
		controlTable.BuildingButton:SetDisabled( false )

		controlTable.BuildingFilledSpecialistSlot1:SetDisabled( false )
		controlTable.BuildingFilledSpecialistSlot2:SetDisabled( false )
		controlTable.BuildingFilledSpecialistSlot3:SetDisabled( false )
		controlTable.BuildingEmptySpecialistSlot1:SetDisabled( false )
		controlTable.BuildingEmptySpecialistSlot2:SetDisabled( false )
		controlTable.BuildingEmptySpecialistSlot3:SetDisabled( false )
	end
end

function UpdateThisQueuedItem(city, queuedItemNumber, queueLength)
	local buttonPrefix = "b"..tostring(queuedItemNumber)
	local queuedOrderType
	local queuedData1
	local queuedData2
	local queuedSave
	local queuedRush
	local controlBox = buttonPrefix.."box"
	local controlImage = buttonPrefix.."image"
	local controlName = buttonPrefix.."name"
	local controlTurns = buttonPrefix.."turns"
	local isMaint = false
	
	local strToolTip = ""
	
	Controls[controlTurns]:SetHide( false )
	queuedOrderType, queuedData1, queuedData2, queuedSave, queuedRush = city:GetOrderFromQueue( queuedItemNumber-1 )
	local thisTable = nil
    if (queuedOrderType == OrderTypes.ORDER_TRAIN) then
		thisTable = GameInfo.Units
    elseif (queuedOrderType == OrderTypes.ORDER_CONSTRUCT) then
		thisTable = GameInfo.Buildings
    elseif (queuedOrderType == OrderTypes.ORDER_CREATE) then
		thisTable = GameInfo.Projects
    elseif (queuedOrderType == OrderTypes.ORDER_MAINTAIN) then
		thisTable = GameInfo.Processes
		isMaint = true
		Controls[controlTurns]:SetHide( true )
	end
	if thisTable then
		local thisItemInfo = thisTable[queuedData1]
		IconHookup( thisItemInfo.PortraitIndex, 45, thisItemInfo.IconAtlas, Controls[controlImage] )
		Controls[controlName]:SetText( Locale.ConvertTextKey( thisItemInfo.Description ) )
		Controls[controlTurns]:SetText(  Locale.ConvertTextKey("TXT_KEY_PRODUCTION_HELP_NUM_TURNS",City_GetYieldTurns( city, YieldTypes.YIELD_PRODUCTION, thisTable, queuedData1, queuedItemNumber-1)) )
		
		if (thisItemInfo.Help ~= nil) then
			strToolTip = thisItemInfo.Help
		end
	end
   
	Controls[controlBox]:SetToolTipString(Locale.ConvertTextKey(strToolTip))
	return isMaint
end

-------------------------------------------------
-- City View Update
-------------------------------------------------
function OnCityViewUpdate()
    if( ContextPtr:IsHidden() ) then
        return
    end
    
	local city = UI.GetHeadSelectedCity()
	
	if gPreviousCity ~= city then
		gPreviousCity = city
		specialistTable = {}
	end
	
	if not city then
		return
	end
	
	if showTimers >= 1 then timeStart = os.clock() end

	pediaSearchStrings = {}
	
	-- Auto Specialist checkbox
	Controls.NoAutoSpecialistCheckbox:SetCheck(city:IsNoAutoAssignSpecialists())

	-- slewis - I'm showing this because when we're in espionage mode we hide this button
	Controls.EditButton:SetHide(false)
	Controls.PurchaseButton:SetDisabled(false)
	Controls.EndTurnText:SetText(Locale.ConvertTextKey("TXT_KEY_CITYVIEW_RETURN_TO_MAP"))
	
	
	-------------------------------------------
	-- City Banner
	-------------------------------------------
	local player = Players[city:GetOwner()]
	local isActiveTeamCity = true
	
	-- Update capital icon
	local isCapital = city:IsCapital()
	Controls.CityCapitalIcon:SetHide(not isCapital)
	
	-- Connected to capital?
	if (isActiveTeamCity) then
		if (not isCapital and player:IsCapitalConnectedToCity(city) and not city:IsBlockaded()) then
			Controls.ConnectedIcon:SetHide(false)
			Controls.ConnectedIcon:LocalizeAndSetToolTip("TXT_KEY_CITY_CONNECTED")
		else
			Controls.ConnectedIcon:SetHide(true)
		end
	end
		
	-- Blockaded
	if (city:IsBlockaded()) then
		Controls.BlockadedIcon:SetHide(false)
		Controls.BlockadedIcon:LocalizeAndSetToolTip("TXT_KEY_CITY_BLOCKADED")
	else
		Controls.BlockadedIcon:SetHide(true)
	end
	
	-- Being Razed
	if (city:IsRazing()) then
		Controls.RazingIcon:SetHide(false)
		Controls.RazingIcon:LocalizeAndSetToolTip("TXT_KEY_CITY_BURNING", city:GetRazingTurns())
	else
		Controls.RazingIcon:SetHide(true)
	end
	
	-- In Resistance
	if (city:IsResistance()) then
		Controls.ResistanceIcon:SetHide(false)
		Controls.ResistanceIcon:LocalizeAndSetToolTip("TXT_KEY_CITY_RESISTANCE", city:GetResistanceTurns())
	else
		Controls.ResistanceIcon:SetHide(true)
	end

	-- Puppet Status
	if (city:IsPuppet()) then
		Controls.PuppetIcon:SetHide(false)
		Controls.PuppetIcon:LocalizeAndSetToolTip("TXT_KEY_CITY_PUPPET")
	else
		Controls.PuppetIcon:SetHide(true)
	end
	
	-- Occupation Status
	if (city:IsOccupied() and not city:IsNoOccupiedUnhappiness()) then
		Controls.OccupiedIcon:SetHide(false)
		Controls.OccupiedIcon:LocalizeAndSetToolTip("TXT_KEY_CITY_OCCUPIED")
	else
		Controls.OccupiedIcon:SetHide(true)
	end	
	
	local cityName = city:GetNameKey()
	local convertedKey = Locale.ConvertTextKey(cityName)
	
	if (city:IsRazing()) then
		convertedKey = convertedKey .. " (" .. Locale.ConvertTextKey("TXT_KEY_BURNING") .. ")"
	end
	
	if (player:GetNumCities() <= 1) then
		Controls.PrevCityButton:SetDisabled( true )
		Controls.NextCityButton:SetDisabled( true )
	else
		Controls.PrevCityButton:SetDisabled( false )
		Controls.NextCityButton:SetDisabled( false )
	end
	
	OnCitySetDamage(city:GetDamage(), city:GetMaxHitPoints())
	
	convertedKey = Locale.ToUpper(convertedKey)

	local cityNameSize = (math.abs(Controls.NextCityButton:GetOffsetX()) * 2) - (Controls.PrevCityButton:GetSizeX()) 
				 
	if(isCapital)then
		cityNameSize = cityNameSize - Controls.CityCapitalIcon:GetSizeX()
	end
	TruncateString(Controls.CityNameTitleBarLabel, cityNameSize, convertedKey) 
	
	Controls.TitleStack:CalculateSize()
	Controls.TitleStack:ReprocessAnchoring()

	Controls.Defense:SetText(  math.floor( city:GetStrengthValue() / 100 ) )

	CivIconHookup( player:GetID(), 64, Controls.CivIcon, Controls.CivIconBG, Controls.CivIconShadow, false, true )

	-------------------------------------------
	-- Deal with the production queue buttons
	-------------------------------------------
	local qLength = city:GetOrderQueueLength()
	if qLength > 0 then
		Controls.HideQueueButton:SetHide( false )
	else
		Controls.HideQueueButton:SetHide( true )
	end
	
	-- hide the queue buttons
	Controls.b1number:SetHide( true )
	Controls.b1down:SetHide( true )
	Controls.b1remove:SetHide( true )
	Controls.b2box:SetHide( true )
	Controls.b3box:SetHide( true )
	Controls.b4box:SetHide( true )
	Controls.b5box:SetHide( true )
	Controls.b6box:SetHide( true )
	
	local anyMaint = false
	
	Controls.ProductionPortraitButton:SetHide( false )
	
	local panelSize = Controls.ProdQueueBackground:GetSize()
	if productionQueueOpen and qLength > 0 then
		panelSize.y = 470
		Controls.ProductionButtonLabel:SetText( Locale.ConvertTextKey( "TXT_KEY_CITYVIEW_QUEUE_PROD") )
		Controls.ProductionButton:SetToolTipString( Locale.ConvertTextKey( "TXT_KEY_CITYVIEW_QUEUE_PROD_TT") )
		
		-- show the queue buttons
		Controls.b1number:SetHide( false )
		Controls.b1remove:SetHide( false )
		if qLength > 1 then
			Controls.b1down:SetHide( false )
		end
		for i = 2, qLength, 1 do
			local isMaint = UpdateThisQueuedItem(city, i, qLength)
			local buttonName = "b"..tostring(i).."box"
			Controls[buttonName]:SetHide( false )
			--update the down buttons
			local buttonDown = "b"..tostring(i).."down"
			if qLength == i then
				Controls[buttonDown]:SetHide( true )
			else
				Controls[buttonDown]:SetHide( false )
			end
			local buttonUp = "b"..tostring(i).."up"
			if isMaint then
				anyMaint = true
				Controls[buttonUp]:SetHide( true )
				buttonDown = "b"..tostring(i-1).."down"
				Controls[buttonDown]:SetHide( true )
			else
				Controls[buttonUp]:SetHide( false )
			end				
		end
	else
		if qLength == 0 then
			Controls.ProductionButtonLabel:SetText( Locale.ConvertTextKey( "TXT_KEY_CITYVIEW_CHOOSE_PROD") )
			Controls.ProductionButton:SetToolTipString( Locale.ConvertTextKey( "TXT_KEY_CITYVIEW_CHOOSE_PROD_TT") )
		else
			Controls.ProductionButtonLabel:SetText( Locale.ConvertTextKey( "TXT_KEY_CITYVIEW_CHANGE_PROD") )
			Controls.ProductionButton:SetToolTipString( Locale.ConvertTextKey( "TXT_KEY_CITYVIEW_CHANGE_PROD_TT") )
		end
		panelSize.y = 280
	end
	Controls.ProdQueueBackground:SetSize(panelSize)
	if productionQueueOpen and (qLength >= 6 or anyMaint == true) then
		Controls.ProductionButton:SetDisabled( true )
	else
		Controls.ProductionButton:SetDisabled( false )
	end
	if qLength == 1 then
		Controls.b1remove:SetHide( true )
	end

	-------------------------------------------
	-- Item under Production
	-------------------------------------------
	local szItemName = Locale.ConvertTextKey(city:GetProductionNameKey())
	szItemName = Locale.ToUpper(szItemName)
	Controls.ProductionItemName:SetText(szItemName)
	
	-------------------------------------------
	-- Description and picture of Item under Production
	-------------------------------------------
	local szHelpText = ""
	local unitProduction = city:GetProductionUnit()
	local buildingProduction = city:GetProductionBuilding()
	local projectProduction = city:GetProductionProject()
	local processProduction = city:GetProductionProcess()
	local noProduction = false

	if unitProduction ~= -1 then
		local thisUnitInfo = GameInfo.Units[unitProduction]
		szHelpText = thisUnitInfo.Help
		if IconHookup( thisUnitInfo.PortraitIndex, g_iPortraitSize, thisUnitInfo.IconAtlas, Controls.ProductionPortrait ) then
			Controls.ProductionPortrait:SetHide( false )
		else
			Controls.ProductionPortrait:SetHide( true )
		end
	elseif buildingProduction ~= -1 then
		local thisBuildingInfo = GameInfo.Buildings[buildingProduction]
		
		szHelpText = GetBuildingTip{buildingID=buildingProduction, hideName=true, hideGoodFor=true, buildingCity=city}
		
		if IconHookup( thisBuildingInfo.PortraitIndex, g_iPortraitSize, thisBuildingInfo.IconAtlas, Controls.ProductionPortrait ) then
			Controls.ProductionPortrait:SetHide( false )
		else
			Controls.ProductionPortrait:SetHide( true )
		end
	elseif projectProduction ~= -1 then
		local thisProjectInfo = GameInfo.Projects[projectProduction]
		szHelpText = thisProjectInfo.Help
		if IconHookup( thisProjectInfo.PortraitIndex, g_iPortraitSize, thisProjectInfo.IconAtlas, Controls.ProductionPortrait ) then
			Controls.ProductionPortrait:SetHide( false )
		else
			Controls.ProductionPortrait:SetHide( true )
		end
	elseif processProduction ~= -1 then
		local thisProcessInfo = GameInfo.Processes[processProduction]
		szHelpText = thisProcessInfo.Help
		if IconHookup( thisProcessInfo.PortraitIndex, g_iPortraitSize, thisProcessInfo.IconAtlas, Controls.ProductionPortrait ) then
			Controls.ProductionPortrait:SetHide( false )
		else
			Controls.ProductionPortrait:SetHide( true )
		end
	else
		Controls.ProductionPortrait:SetHide(true)
		noProduction = true
	end
	
	if szHelpText ~= nil and szHelpText ~= "" then
		Controls.ProductionHelp:SetText(Locale.ConvertTextKey(szHelpText))
		Controls.ProductionHelp:SetHide(false)
		Controls.ProductionHelpScroll:CalculateInternalSize()
	else
		Controls.ProductionHelp:SetHide(true)
	end
	
	-------------------------------------------
	-- Buildings (etc.) List
	-------------------------------------------
	
	g_BuildingIM:ResetInstances()
	g_GPIM:ResetInstances()
	g_SlackerIM:ResetInstances()
	g_PlotButtonIM:ResetInstances()
	g_BuyPlotButtonIM:ResetInstances()
	g_SpecialistSlotIM:ResetInstances()
	g_SpecialistIconIM:ResetInstances()

	
	
	local controlTable
	local bIsFreeBuilding		
	local iNumSpecialists

	local slackerType = GameDefines.DEFAULT_SPECIALIST
	local numSlackersInThisCity = city:GetSpecialistCount( slackerType )
	
	-- header
	if workerHeadingOpen then
		local localizedLabel = "[ICON_MINUS] "..Locale.ConvertTextKey( "TXT_KEY_CITYVIEW_CITIZEN_ALLOCATION" )
		Controls.WorkerHeaderLabel:SetText(localizedLabel)
		local focusType = city:GetFocusType()
		if focusType == CityAIFocusTypes.NO_CITY_AI_FOCUS_TYPE then
			Controls.BalancedFocusButton:SetCheck( true )
		elseif focusType == CityAIFocusTypes.CITY_AI_FOCUS_TYPE_FOOD then
			Controls.FoodFocusButton:SetCheck( true )
		elseif focusType == CityAIFocusTypes.CITY_AI_FOCUS_TYPE_PRODUCTION then
			Controls.ProductionFocusButton:SetCheck( true )
		elseif focusType == CityAIFocusTypes.CITY_AI_FOCUS_TYPE_GOLD then
			Controls.GoldFocusButton:SetCheck( true )
		elseif focusType == CityAIFocusTypes.CITY_AI_FOCUS_TYPE_SCIENCE then
			Controls.ResearchFocusButton:SetCheck( true )
		elseif focusType == CityAIFocusTypes.CITY_AI_FOCUS_TYPE_CULTURE then
			Controls.CultureFocusButton:SetCheck( true )
		elseif focusType == CityAIFocusTypes.CITY_AI_FOCUS_TYPE_GREAT_PEOPLE then
			Controls.GPFocusButton:SetCheck( true )
		elseif focusType == CityAIFocusTypes.CITY_AI_FOCUS_TYPE_FAITH then
			Controls.FaithFocusButton:SetCheck( true )
		else
			Controls.BalancedFocusButton:SetCheck( true )
		end
		Controls.AvoidGrowthButton:SetCheck( city:IsForcedAvoidGrowth() )
		if city:GetNumForcedWorkingPlots() > 0 or numSlackersInThisCity > 0 then
			Controls.ResetButton:SetHide( false )
			Controls.ResetFooter:SetHide( false )
		else
			Controls.ResetButton:SetHide( true )
			Controls.ResetFooter:SetHide( true )
		end
		Events.RequestYieldDisplay( YieldDisplayTypes.CITY_OWNED, city:GetX(), city:GetY() )
		Controls.WorkerManagementBox:SetHide( false )
	else
		local localizedLabel = "[ICON_PLUS] "..Locale.ConvertTextKey( "TXT_KEY_CITYVIEW_CITIZEN_ALLOCATION" )
		Controls.WorkerHeaderLabel:SetText(localizedLabel)
		Events.RequestYieldDisplay( YieldDisplayTypes.CITY_WORKED, city:GetX(), city:GetY() )
		Controls.WorkerManagementBox:SetHide( true )
	end
	Controls.WorkerHeader:RegisterCallback( Mouse.eLClick, OnWorkerHeaderSelected )
	
	-- add in the Great Person Meters
	local numGPs = 0		
	for specialistInfo in GameInfo.Specialists() do
		local threshold = city:GetSpecialistUpgradeThreshold()			
		local iSpecialistIndex = specialistInfo.ID			
		local iProgress = city:GetSpecialistGreatPersonProgress(iSpecialistIndex)
		if (iProgress > 0) then		
			numGPs = numGPs + 1		
			controlTable = g_GPIM:GetInstance()
			local percent = iProgress / threshold
			controlTable.GPMeter:SetPercent( percent )
		
			local unitClass = GameInfo.UnitClasses[specialistInfo.GreatPeopleUnitClass]
			if(unitClass ~= nil) then
				local gp = GameInfo.Units[ unitClass.DefaultUnit ]
				local labelText = Locale.ConvertTextKey(unitClass.Description)
				controlTable.GreatPersonLabel:SetText(labelText)
				pediaSearchStrings[tostring(controlTable.GPImage)] = labelText
				controlTable.GPImage:RegisterCallback( Mouse.eRClick, GetPedia )
				
				local strToolTipText = Locale.ConvertTextKey("TXT_KEY_PROGRESS_TOWARDS",labelText)
				strToolTipText = strToolTipText .. ": " .. tostring(iProgress) .. "/" .. tostring(threshold)					
				local iCount = city:GetSpecialistCount( specialistInfo.ID )
				local iGPPChange = specialistInfo.GreatPeopleRateChange * iCount * 100
				for building in GameInfo.Buildings{SpecialistType = specialistInfo.Type} do
					local buildingID = building.ID
					if (city:IsHasBuilding(buildingID)) then
						iGPPChange = iGPPChange + building.GreatPeopleRateChange * 100
					end
				end
				if iGPPChange > 0 then
					local iMod = 0
					local iCityMod = city:GetGreatPeopleRateModifier()
					local iPlayerMod = player:GetGreatPeopleRateModifier()
					iMod = iCityMod + iPlayerMod
					if (specialistInfo.GreatPeopleUnitClass == "UNITCLASS_SCIENTIST") then
						iMod = iMod + player:GetTraitGreatScientistRateModifier()
					end
					iGPPChange = (iGPPChange * (100 + iMod)) / 100
					strToolTipText = strToolTipText .. " (+" .. math.floor(iGPPChange/100) .. "[ICON_GREAT_PEOPLE])"	
					if (iCityMod > 0) then
						strToolTipText = strToolTipText .. "[NEWLINE]" .. Locale.ConvertTextKey("TXT_KEY_CITY_GP_MOD", iCityMod)
					end
					if (iPlayerMod > 0) then
						strToolTipText = strToolTipText .. "[NEWLINE]" .. Locale.ConvertTextKey("TXT_KEY_PLAYER_GP_MOD", iPlayerMod)
					end										
				end
				controlTable.GPBox:SetToolTipString(strToolTipText)
				
				if IconHookup( gp.PortraitIndex, 64, gp.IconAtlas, controlTable.GPImage ) then
					controlTable.GPImage:SetHide( false )
				end
			end
		end			
	end
	-- header
	if GPHeadingOpen then
		local localizedLabel = "[ICON_MINUS] "..Locale.ConvertTextKey( "TXT_KEY_CITYVIEW_GREAT_PEOPLE_TEXT" )
		Controls.GPHeaderLabel:SetText(localizedLabel)
		Controls.GPStack:SetHide( false )
	else
		local localizedLabel = "[ICON_PLUS] "..Locale.ConvertTextKey( "TXT_KEY_CITYVIEW_GREAT_PEOPLE_TEXT" )
		Controls.GPHeaderLabel:SetText(localizedLabel)
		Controls.GPStack:SetHide( true )
	end
	if numGPs > 0 then
		Controls.GPHeader:SetHide( false )
	else
		Controls.GPHeader:SetHide( true )
		Controls.GPStack:SetHide( true )
	end
	Controls.GPHeader:RegisterCallback( Mouse.eLClick, OnGPHeaderSelected )

	if showTimers >= 2 then
		print(string.format("%3s ms for OnCityViewUpdate START", math.floor((os.clock() - timeStart) * 1000)))
		timeStart = os.clock()
	end
	
	----------------------------
	-- Specialist Control Box --
	----------------------------
	--Initialize Variables
	numSS = 0
	local numberOfSpecialistsPerRow = 8
	local specialistSize = 32
	local specialistPadding = 2
	specialistSlotTable = {}

	--Header
	if specialistHeadingOpen then
		local localizedLabel = "[ICON_MINUS] "..Locale.ConvertTextKey( "TXT_KEY_CITYVIEW_SPECIAL_TEXT" )
		Controls.SpecialistHeaderLabel:SetText(localizedLabel)
		Controls.SpecialistBox:SetHide( false )
		Controls.SpecialistControlBox:SetHide( false )
	else
		local localizedLabel = "[ICON_PLUS] "..Locale.ConvertTextKey( "TXT_KEY_CITYVIEW_SPECIAL_TEXT" )
		Controls.SpecialistHeaderLabel:SetText(localizedLabel)
		Controls.SpecialistBox:SetHide( true )
		Controls.SpecialistControlBox:SetHide( true )
	end

	--Build Table
	for building in GameInfo.Buildings("SpecialistCount > 0") do
		local buildingID = building.ID
		local buildingSC = building.SpecialistCount
		if city:IsHasBuilding(buildingID) then
			local buildingST = building.SpecialistType
			local buildingFC = city:GetNumSpecialistsInBuilding(buildingID)
			for i = 1,buildingSC do
				numSS = numSS + 1
				local isFilled = not(i > buildingFC)
				specialistSlotTable[numSS] = {ID = numSS, Type = buildingST, Building = buildingID, Slot = i, Filled = isFilled}

			end
		end
	end

	
	local SlotX = 32
	local SlotY = 2
	local IconX = 0
	local IconY = 2
	local SCount = 0

	if numSS > 0 then
		Controls.SpecialistHeader:SetHide( false )
		if specialistHeadingOpen then
			Controls.SpecialistBox:SetHide( false )
			Controls.SpecialistControlBox:SetHide( false )
			Controls.SpecialistHeader:RegisterCallback( Mouse.eLClick, OnSpecialistHeaderSelected )
			for specialistInfo in GameInfo.Specialists() do
				local STCount = 0
				local pSIType = specialistInfo.Type
				local iSpecialistID = specialistInfo.ID
				--print("Building Slots for "..pSIType)
				IconY = SlotY
				for slot = 1, numSS do
					if specialistSlotTable[slot].Type == pSIType then
						slotid = specialistSlotTable[slot].ID
						slotbuilding = specialistSlotTable[slot].Building
						slotfilled = specialistSlotTable[slot].Filled
						slotnum = specialistSlotTable[slot].Slot
						STCount = STCount + 1
						SCount = SCount + 1
						controlTable = g_SpecialistSlotIM:GetInstance()	
						controlTable.SpecialistSlotButton:SetOffsetX(SlotX)
						controlTable.SpecialistSlotButton:SetOffsetY(SlotY)
						--print(pSIType.." at "..SlotX..", "..SlotY)
						controlTable.EmptySpecialistSlot:SetHide(slotfilled)
						controlTable.FilledSpecialistSlot:SetHide(not(slotfilled))
						local specialistName = Locale.ConvertTextKey(specialistInfo.Description)
						local ToolTipString = specialistName .. " employed at " .. Locale.ConvertTextKey(GameInfo.Buildings[slotbuilding].Description) .."[NEWLINE] "
						for yieldInfo in GameInfo.Yields() do
							local iYieldID = yieldInfo.ID
							local iYieldAmount = City_GetSpecialistYield(city, iYieldID, iSpecialistID)
							if (iYieldAmount > 0) then
								--log:Debug("B %s %s = %s", specialistInfo.Type, yieldInfo.Type, iYieldAmount)
								ToolTipString = ToolTipString .. " " .. iYieldAmount .. yieldInfo.IconString
							end
						end
						controlTable.FilledSpecialistSlot:SetToolTipString(ToolTipString)
						ToolTipString = emptySlotString.."[NEWLINE]("..ToolTipString..")"
						controlTable.EmptySpecialistSlot:SetToolTipString(ToolTipString)
						local filledSlotTexture = SpecControlArt[pSIType].Texture
						controlTable.FilledSpecialistSlot:SetTexture(filledSlotTexture)
						controlTable.FilledSpecialistSlot:RegisterCallback( Mouse.eLClick, RemoveSpecialist )
						pediaSearchStrings[tostring(controlTable.FilledSpecialistSlot)] = specialistName
						controlTable.FilledSpecialistSlot:RegisterCallback( Mouse.eRClick, GetPedia )
						controlTable.FilledSpecialistSlot:SetVoids( slotbuilding, slotnum)
						controlTable.EmptySpecialistSlot:RegisterCallback( Mouse.eLClick, AddSpecialist )
						controlTable.EmptySpecialistSlot:SetVoids( slotbuilding, slotnum)
						if (UI.IsCityScreenViewingMode()) then
							controlTable.FilledSpecialistSlot:SetDisabled( true )
							controlTable.EmptySpecialistSlot:SetDisabled( true )
						else
							controlTable.FilledSpecialistSlot:SetDisabled( false )
							controlTable.EmptySpecialistSlot:SetDisabled( false )
						end
						SlotX = SlotX + 32
						if SlotX > 250 then
							SlotX =  32
							SlotY = SlotY + 32
						end
					end
				end
				if STCount > 0 then
					controlTable = g_SpecialistIconIM:GetInstance()
					controlTable.SpecialistIconButton:SetOffsetX(IconX)
					controlTable.SpecialistIconButton:SetOffsetY(IconY)	
					local localizedLabel = SpecControlArt[pSIType].Label
					controlTable.SpecialistIcon:SetText(localizedLabel)
					--print(localizedLabel.." at "..IconX..", "..IconY)
					if SlotX ~= 32 then
						SlotX = 32
						SlotY = SlotY + 32
					end
				end
			end
			if SCount > 0 then
				local frameSize = {}
				local h = SlotY + 2
				frameSize.x = 254
				frameSize.y = h
				Controls.SpecialistBox:SetSize( frameSize )
			end
		else 
			Controls.SpecialistBox:SetHide( true )
			Controls.SpecialistControlBox:SetHide( true )
		end
	else
		Controls.SpecialistHeader:SetHide( true )
		Controls.SpecialistBox:SetHide( true )
		Controls.SpecialistControlBox:SetHide( true )
	end
	



	----------------------------
	-- Slackers               --
	----------------------------
	local numberOfSlackersPerRow = 8
	local slackerSize = 32
	local slackerPadding = 2
	-- header
	if slackerHeadingOpen then
		local localizedLabel = "[ICON_MINUS] "..Locale.ConvertTextKey( "TXT_KEY_CITYVIEW_UNEMPLOYED_TEXT" )
		Controls.SlackerHeaderLabel:SetText(localizedLabel)
	else
		local localizedLabel = "[ICON_PLUS] "..Locale.ConvertTextKey( "TXT_KEY_CITYVIEW_UNEMPLOYED_TEXT" )
		Controls.SlackerHeaderLabel:SetText(localizedLabel)
	end
	if numSlackersInThisCity > 0 then
		--if header is not hidden and is open
		Controls.SlackerHeader:SetHide( false )
		if slackerHeadingOpen then
			Controls.BoxOSlackers:SetHide( false )
			
			Controls.SlackerHeader:RegisterCallback( Mouse.eLClick, OnSlackerHeaderSelected )
			Controls.BoxOSlackers:RegisterCallback( Mouse.eLClick, OnSlackersSelected )

			-- build the tooltip for slackers
			local specialistInfo = GameInfo.Specialists[slackerType]
			local specialistName = Locale.ConvertTextKey(specialistInfo.Description)
			local ToolTipString = specialistName .. " "	

			for yieldInfo in GameInfo.Yields() do
				local iYieldID = yieldInfo.ID
				local iYieldAmount = City_GetSpecialistYield(city, iYieldID, specialistInfo.ID)
				if (iYieldAmount > 0) then
					ToolTipString = ToolTipString .. " " .. iYieldAmount .. yieldInfo.IconString
				end
			end

			-- bunch-o-slackers
			local slackerAdded = 0
			for i = 1, numSlackersInThisCity do
				controlTable = g_SlackerIM:GetInstance()
				controlTable.SlackerButton:SetOffsetVal( (slackerAdded % numberOfSlackersPerRow) * slackerSize + slackerPadding, math.floor(slackerAdded / numberOfSlackersPerRow) * slackerSize + slackerPadding )				
				controlTable.SlackerButton:SetToolTipString( ToolTipString )
				controlTable.SlackerButton:RegisterCallback( Mouse.eLClick, OnSlackersSelected )
				pediaSearchStrings[tostring(controlTable.SlackerButton)] = specialistName
				controlTable.SlackerButton:RegisterCallback( Mouse.eRClick, GetPedia )
				slackerAdded = slackerAdded + 1
			end
			if slackerAdded > 0 then
				local frameSize = {}
				local h = (math.floor((slackerAdded - 1) / numberOfSlackersPerRow) + 1) * slackerSize + (slackerPadding * 2)
				frameSize.x = 254
				frameSize.y = h
				Controls.BoxOSlackers:SetSize( frameSize )
			end
		else
			Controls.BoxOSlackers:SetHide( true )
		end
	else
		Controls.SlackerHeader:SetHide( true )
		Controls.BoxOSlackers:SetHide( true )
	end
	
	sortOrder = 0
	otherSortedList = {}
	
	local iBuildingMaintenance = city:GetTotalBaseBuildingMaintenance()
	local strMaintenanceTT = Locale.ConvertTextKey("TXT_KEY_BUILDING_MAINTENANCE_TT", iBuildingMaintenance)
	Controls.SpecialBuildingsHeader:SetToolTipString(strMaintenanceTT)
	Controls.BuildingsHeader:SetToolTipString(strMaintenanceTT)
	Controls.MarketplaceHeader:SetToolTipString(strMaintenanceTT)

	-- Marketplace Controls	
	local numMarketplaceBuildingsInThisCity = 0
	if marketplaceBuildingHeadingOpen then
		local localizedLabel = "[ICON_MINUS] "..Locale.ConvertTextKey( "TXT_KEY_CITYVIEW_MARKETPLACE_TEXT" )
		Controls.MarketplaceHeaderLabel:SetText(localizedLabel)
	else
		local localizedLabel = "[ICON_PLUS] "..Locale.ConvertTextKey( "TXT_KEY_CITYVIEW_MARKETPLACE_TEXT" )
		Controls.MarketplaceHeaderLabel:SetText(localizedLabel)
	end
	sortedList = {}
	thisId = 1
	for building in GameInfo.Buildings{IsMarketplace = 1} do
		local buildingID= building.ID
		if city:IsHasBuilding(buildingID) then
			numMarketplaceBuildingsInThisCity = numMarketplaceBuildingsInThisCity + 1
			local element = {}
			local name = Locale.ConvertTextKey( building.Description )
			element.name = name
			element.ID = building.ID
			sortedList[thisId] = element
			thisId = thisId + 1
		end
	end
	if numMarketplaceBuildingsInThisCity > 0 then
		--if header is not hidden and is open
		Controls.MarketplaceHeader:SetHide( false )
		sortOrder = sortOrder + 1
		otherSortedList[tostring( Controls.MarketplaceHeader )] = sortOrder
		Controls.MarketplaceHeader:RegisterCallback( Mouse.eLClick, OnMarketplaceHeaderSelected )
		if marketplaceBuildingHeadingOpen then
			table.sort(sortedList, function(a, b) return a.name < b.name end)
			for i, v in ipairs(sortedList) do
				local building = GameInfo.Buildings[v.ID]
				local buildingClass = building.BuildingClass
				AddBuildingButton( city, building )
				for buildingAddon in GameInfo.Building_Addons{ParentBuildingClass = buildingClass} do
					local buildingAddonInfo = GameInfo.Buildings[buildingAddon.BuildingType]
					if city:IsHasBuilding(buildingAddonInfo.ID) then
						log:Debug("Add Marketplace: %s", buildingAddonInfo.Type)
						AddBuildingButton( city, buildingAddonInfo )
					end
				end
			end
		end			
	else
		Controls.MarketplaceHeader:SetHide( true )
	end

	if showTimers >= 2 then
		print(string.format("%3s ms for OnCityViewUpdate NEW_MOD_STUFF", math.floor((os.clock() - timeStart) * 1000)))
		timeStart = os.clock()
	end
	
	-- Buildings that take specialists	
	local numSpecialBuildingsInThisCity = 0
	if specialistBuildingHeadingOpen then
		local localizedLabel = "[ICON_MINUS] "..Locale.ConvertTextKey( "TXT_KEY_CITYVIEW_SPECIAL_TEXT" )
		Controls.SpecialBuildingsHeaderLabel:SetText(localizedLabel)
	else
		local localizedLabel = "[ICON_PLUS] "..Locale.ConvertTextKey( "TXT_KEY_CITYVIEW_SPECIAL_TEXT" )
		Controls.SpecialBuildingsHeaderLabel:SetText(localizedLabel)
	end
	sortedList = {}
	thisId = 1
	for building in GameInfo.Buildings{IsMarketplace = 6} do
		local buildingID = building.ID
		if city:IsHasBuilding(buildingID) and city:GetNumSpecialistsAllowedByBuilding(buildingID) > 0 and not Building_IsWonder(building.Type) and not Building_IsAddon(building.Type) then
			numSpecialBuildingsInThisCity = numSpecialBuildingsInThisCity + 1
			local element = {}
			local name = Locale.ConvertTextKey( building.Description )
			element.name = name
			element.ID = building.ID
			sortedList[thisId] = element
			thisId = thisId + 1
		end
	end
	if numSpecialBuildingsInThisCity > 0 then
		--if header is not hidden and is open
		Controls.SpecialBuildingsHeader:SetHide( false )
		--Controls.SpecialistControlBox:SetHide( false )
		sortOrder = sortOrder + 1
		otherSortedList[tostring( Controls.SpecialBuildingsHeader )] = sortOrder
		--sortOrder = sortOrder + 1
		--otherSortedList[tostring( Controls.SpecialistControlBox )] = sortOrder
		Controls.SpecialBuildingsHeader:RegisterCallback( Mouse.eLClick, OnSpecialistBuildingsHeaderSelected )
		if specialistBuildingHeadingOpen then
			table.sort(sortedList, function(a, b) return a.name < b.name end)
			for i, v in ipairs(sortedList) do
				local building = GameInfo.Buildings[v.ID]
				local buildingClass = building.BuildingClass
				AddBuildingButton( city, building )
				for buildingAddon in GameInfo.Building_Addons{ParentBuildingClass = buildingClass} do
					local buildingAddonInfo = GameInfo.Buildings[buildingAddon.BuildingType]
					if city:IsHasBuilding(buildingAddonInfo.ID) then
						log:Debug("Add Special Building: %s", buildingAddonInfo.Type)
						AddBuildingButton( city, buildingAddonInfo )
					end
				end
			end
		--else
			--Controls.SpecialistControlBox:SetHide( true )
		end			
	else
		Controls.SpecialBuildingsHeader:SetHide( true )
		--Controls.SpecialistControlBox:SetHide( true )
	end

	if showTimers >= 2 then
		print(string.format("%3s ms for OnCityViewUpdate SPECIALIST_BUILDINGS", math.floor((os.clock() - timeStart) * 1000)))
		timeStart = os.clock()
	end
	

	
	-- now add the wonders
	local numWondersInThisCity = 0
	if wonderHeadingOpen then
		local localizedLabel = "[ICON_MINUS] "..Locale.ConvertTextKey( "TXT_KEY_CITYVIEW_WONDERS_TEXT" )
		Controls.WondersHeaderLabel:SetText(localizedLabel)
	else
		local localizedLabel = "[ICON_PLUS] "..Locale.ConvertTextKey( "TXT_KEY_CITYVIEW_WONDERS_TEXT" )
		Controls.WondersHeaderLabel:SetText(localizedLabel)
	end
	local sortedList = {}
	local thisId = 1
	for building in GameInfo.Buildings{IsMarketplace = 0} do
		if city:IsHasBuilding(building.ID) and Building_IsWonder(building.Type) and not Building_IsAddon(building.Type) then
			numWondersInThisCity = numWondersInThisCity + 1
			local element = {}
			local name = Locale.ConvertTextKey( building.Description )
			element.name = name
			element.ID = building.ID
			sortedList[thisId] = element
			thisId = thisId + 1
		end
	end
	if numWondersInThisCity > 0 then
		--if header is not hidden and is open
		Controls.WondersHeader:SetHide( false )
		sortOrder = sortOrder + 1
		otherSortedList[tostring( Controls.WondersHeader )] = sortOrder
		Controls.WondersHeader:RegisterCallback( Mouse.eLClick, OnWondersHeaderSelected )
		if wonderHeadingOpen then
			table.sort(sortedList, function(a, b) return a.name < b.name end)
			for i, v in ipairs(sortedList) do
				local building = GameInfo.Buildings[v.ID]
				local buildingClass = building.BuildingClass
				AddBuildingButton( city, building )
				for buildingAddon in GameInfo.Building_Addons{ParentBuildingClass = buildingClass} do
					local buildingAddonInfo = GameInfo.Buildings[buildingAddon.BuildingType]
					if city:IsHasBuilding(buildingAddonInfo.ID) then
						log:Debug("Add Wonder: %s", buildingAddonInfo.Type)
						AddBuildingButton( city, buildingAddonInfo )
					end
				end
			end
		end
	else
		Controls.WondersHeader:SetHide( true )
	end

	if showTimers >= 2 then
		print(string.format("%3s ms for OnCityViewUpdate WONDERS", math.floor((os.clock() - timeStart) * 1000)))
		timeStart = os.clock()
	end
		
	-- the rest of the buildings
	local numBuildingsInThisCity = 0
	if buildingHeadingOpen then
		local localizedLabel = "[ICON_MINUS] "..Locale.ConvertTextKey( "TXT_KEY_CITYVIEW_REGULARBUILDING_TEXT" )
		Controls.BuildingsHeaderLabel:SetText(localizedLabel)
	else
		local localizedLabel = "[ICON_PLUS] "..Locale.ConvertTextKey( "TXT_KEY_CITYVIEW_REGULARBUILDING_TEXT" )
		Controls.BuildingsHeaderLabel:SetText(localizedLabel)
	end
	sortedList = {}
	thisId = 1
	for building in GameInfo.Buildings{IsMarketplace = 0} do
		local buildingID = building.ID
		if city:IsHasBuilding(buildingID) and not Building_IsWonder(building.Type) and not Building_IsAddon(building.Type) then
			numBuildingsInThisCity = numBuildingsInThisCity + 1
			local element = {}
			local name = Locale.ConvertTextKey( building.Description )
			element.name = name
			element.ID = building.ID
			sortedList[thisId] = element
			thisId = thisId + 1
		end
	end
	if numBuildingsInThisCity > 0 then
		--if header is not hidden and is open
		Controls.BuildingsHeader:SetHide( false )
		sortOrder = sortOrder + 1
		otherSortedList[tostring( Controls.BuildingsHeader )] = sortOrder
		Controls.BuildingsHeader:RegisterCallback( Mouse.eLClick, OnBuildingsHeaderSelected )
		if buildingHeadingOpen then
			table.sort(sortedList, function(a, b) return a.name < b.name end)
			for i, v in ipairs(sortedList) do
				local building = GameInfo.Buildings[v.ID]
				local buildingClass = building.BuildingClass
				log:Debug("Add Regular Building: %s", building.Type)
				AddBuildingButton( city, building )
				for buildingAddon in GameInfo.Building_Addons{ParentBuildingClass = buildingClass} do
					local buildingAddonInfo = GameInfo.Buildings[buildingAddon.BuildingType]
					if city:IsHasBuilding(buildingAddonInfo.ID) then
						log:Debug("Add Addon: %s", buildingAddonInfo.Type)
						AddBuildingButton( city, buildingAddonInfo )
					end
				end
			end
		end
	else
		Controls.BuildingsHeader:SetHide( true )
	end

	if showTimers >= 2 then
		print(string.format("%3s ms for OnCityViewUpdate OTHER_BUILDINGS", math.floor((os.clock() - timeStart) * 1000)))
		timeStart = os.clock()
	end
	
	Controls.BuildingStack:SortChildren( CVSortFunction )
	
	Controls.BuildingStack:CalculateSize()
	Controls.BuildingStack:ReprocessAnchoring()
	
	Controls.WorkerManagementBox:CalculateSize()
	Controls.WorkerManagementBox:ReprocessAnchoring()
	
	Controls.GPStack:CalculateSize()
	Controls.GPStack:ReprocessAnchoring()
	
	RecalcPanelSize()
	
	-----------------------------------------
	-- Buying Plots
	-------------------------------------------
	szText = string.format( Locale.ConvertTextKey( "TXT_KEY_CITYVIEW_BUY_TILE") )
	Controls.BuyPlotButton:SetToolTipString( Locale.ConvertTextKey( "TXT_KEY_CITYVIEW_BUY_TILE_TT" ) )
	Controls.BuyPlotText:SetText(szText)
	if (GameDefines["BUY_PLOTS_DISABLED"] ~= 0) then
		Controls.BuyPlotButton:SetDisabled(true)			
	end
	
	
	-------------------------------------------
	-- Resource Demanded
	-------------------------------------------
	
	local szResourceDemanded = "??? (Research Required)"
	
	if (city:GetResourceDemanded(true) ~= -1) then
		local pResourceInfo = GameInfo.Resources[city:GetResourceDemanded()]
		szResourceDemanded = Locale.ConvertTextKey(pResourceInfo.IconString) .. " " .. Locale.ConvertTextKey(pResourceInfo.Description)
		Controls.ResourceDemandedBox:SetHide(false)
		
	else
		Controls.ResourceDemandedBox:SetHide(true)
	end
			
	local iNumTurns = city:GetWeLoveTheKingDayCounter()
	if (iNumTurns > 0) then
		szText = Locale.ConvertTextKey( "TXT_KEY_CITYVIEW_WLTKD_COUNTER", tostring(iNumTurns) )
		Controls.ResourceDemandedBox:SetToolTipString(Locale.ConvertTextKey( "TXT_KEY_CITYVIEW_RESOURCE_FULFILLED_TT" ) )
	else
		szText = Locale.ConvertTextKey( "TXT_KEY_CITYVIEW_RESOURCE_DEMANDED", szResourceDemanded )
		Controls.ResourceDemandedBox:SetToolTipString(Locale.ConvertTextKey( "TXT_KEY_CITYVIEW_RESOURCE_DEMANDED_TT" ) )
	end
	
	Controls.ResourceDemandedString:SetText(szText)
	Controls.ResourceDemandedBox:SetSizeX(Controls.ResourceDemandedString:GetSizeX() + 10)
	
	Controls.IconsStack:CalculateSize()
	Controls.IconsStack:ReprocessAnchoring()
	
	Controls.NotificationStack:CalculateSize()
	Controls.NotificationStack:ReprocessAnchoring()

	if showTimers >= 2 then
		print(string.format("%3s ms for OnCityViewUpdate PLOTS", math.floor((os.clock() - timeStart) * 1000)))
		timeStart = os.clock()
	end
	
	-------------------------------------------
	-- Raze City Button (Occupied Cities only)
	-------------------------------------------
	
	if (not city:IsOccupied() or city:IsRazing()) then		
		g_bRazeButtonDisabled = true
		Controls.RazeCityButton:SetHide(true)
	else
		-- Can we not actually raze this city?
		if (not player:CanRaze(city, false)) then
			-- We COULD raze this city if it weren't a capital
			if (player:CanRaze(city, true)) then
				g_bRazeButtonDisabled = true
				Controls.RazeCityButton:SetHide(false)
				Controls.RazeCityButton:SetDisabled(true)
				Controls.RazeCityButton:SetToolTipString( Locale.ConvertTextKey( "TXT_KEY_CITYVIEW_RAZE_BUTTON_DISABLED_BECAUSE_CAPITAL_TT" ) )
			-- Can't raze this city period
			else
				g_bRazeButtonDisabled = true
				Controls.RazeCityButton:SetHide(true)
			end
		else
			g_bRazeButtonDisabled = false
			Controls.RazeCityButton:SetHide(false)
			Controls.RazeCityButton:SetDisabled(false)		
			Controls.RazeCityButton:SetToolTipString( Locale.ConvertTextKey( "TXT_KEY_CITYVIEW_RAZE_BUTTON_TT" ) )
		end
	end

	-- Stop city razing
	if (city:IsRazing()) then
		g_bRazeButtonDisabled = false
		Controls.UnrazeCityButton:SetHide(false)
	else
		g_bRazeButtonDisabled = true
		Controls.UnrazeCityButton:SetHide(true)
	end

	if showTimers >= 2 then
		print(string.format("%3s ms for OnCityViewUpdate RAZING", math.floor((os.clock() - timeStart) * 1000)))
		timeStart = os.clock()
	end
	
--		UpdateSpecialists(city)
	UpdateWorkingHexes()
	if showTimers >= 2 then
		print(string.format("%3s ms for OnCityViewUpdate UpdateWorkingHexes", math.floor((os.clock() - timeStart) * 1000)))
		timeStart = os.clock()
	end
	
	UpdateBuyPlotButton()
	if showTimers >= 2 then
		print(string.format("%3s ms for OnCityViewUpdate UpdateBuyPlotButton", math.floor((os.clock() - timeStart) * 1000)))
		timeStart = os.clock()
	end

	-- Update left corner tooltips
	DoUpdateUpperLeftTooltips()
	if showTimers >= 2 then
		print(string.format("%3s ms for OnCityViewUpdate DoUpdateUpperLeftTooltips", math.floor((os.clock() - timeStart) * 1000)))
		timeStart = os.clock()
	end
	
	
	-- display city happiness	
	Controls.HappinessCityLabel:SetText(FormatYield(City_GetYieldRate(city, YieldTypes.YIELD_HAPPINESS_CITY)))
	Controls.HappinessNationalLabel:SetText(FormatYield(City_GetYieldRate(city, YieldTypes.YIELD_HAPPINESS_NATIONAL)))
	
	-- display gold income
	Controls.GoldPerTurnLabel:SetText(FormatYield(City_GetYieldRate(city, YieldTypes.YIELD_GOLD)))
	
	-- display science income
	if (Game.IsOption(GameOptionTypes.GAMEOPTION_NO_SCIENCE)) then
		Controls.SciencePerTurnLabel:SetText( Locale.ConvertTextKey("TXT_KEY_CITYVIEW_OFF") )
	else
		Controls.SciencePerTurnLabel:SetText(FormatYield(City_GetYieldRate(city, YieldTypes.YIELD_SCIENCE)))
	end
	--Controls.ScienceBox:SetToolTipString(strToolTip)
	
	-- culture
	Controls.CulturePerTurnLabel:SetText(FormatYield(City_GetYieldRate(city, YieldTypes.YIELD_CULTURE)))
	local cultureTurns = City_GetYieldTurns(city, YieldTypes.YIELD_CULTURE)
	if cultureTurns ~= math.huge then
		Controls.CultureTimeTillGrowthLabel:SetText( Locale.ConvertTextKey("TXT_KEY_CITYVIEW_TURNS_TILL_TILE_TEXT", cultureTurns) )
		Controls.CultureTimeTillGrowthLabel:SetHide( false )
	else
		Controls.CultureTimeTillGrowthLabel:SetHide( true )
	end
	Controls.CultureMeter:SetPercent( City_GetYieldStored(city, YieldTypes.YIELD_CULTURE) / City_GetYieldNeeded(city, YieldTypes.YIELD_CULTURE) )
	
	if (Game.IsOption(GameOptionTypes.GAMEOPTION_NO_RELIGION)) then
		Controls.FaithPerTurnLabel:SetText( Locale.ConvertTextKey("TXT_KEY_CITYVIEW_OFF") )
	else
		Controls.FaithPerTurnLabel:SetText( FormatYield(City_GetYieldRate(city, YieldTypes.YIELD_FAITH)) )
	end
	
	-- food
	
	local cityPopulation			= math.floor(city:GetPopulation())
	local yieldRate					= city:IsFoodProduction() and 0 or City_GetYieldRate(city, YieldTypes.YIELD_FOOD)
	local yieldNeeded				= City_GetYieldNeeded(city, YieldTypes.YIELD_FOOD)
	local yieldStored				= City_GetYieldStored(city, YieldTypes.YIELD_FOOD)
	local yieldStoredPlusTurn		= yieldStored + yieldRate		
	local yieldPercent				= yieldStored / yieldNeeded
	local yieldPercentPlusTurn		= math.min(1, yieldStoredPlusTurn / yieldNeeded)
	
	Controls.FoodPerTurnLabel:SetText(FormatYield(yieldRate))
	Controls.CityPopulationLabel:SetText(cityPopulation)
	Controls.CityPopulationLabelSuffix:LocalizeAndSetText("TXT_KEY_CITYVIEW_CITIZENS_TEXT", cityPopulation)
	Controls.PeopleMeter:SetPercent(yieldPercent)
	
	if yieldRate == 0 then
		Controls.CityGrowthLabel:SetText(Locale.ConvertTextKey("TXT_KEY_CITYVIEW_STAGNATION_TEXT"))
	elseif yieldRate < 0 then
		Controls.CityGrowthLabel:SetText(Locale.ConvertTextKey("TXT_KEY_CITYVIEW_STARVATION_TEXT"))
	else
		Controls.CityGrowthLabel:SetText(Locale.ConvertTextKey("TXT_KEY_CITYVIEW_TURNS_TILL_CITIZEN_TEXT", City_GetYieldTurns(city, YieldTypes.YIELD_FOOD)))
	end

	-- Production
	
	DoUpdateProductionInfo( noProduction )
	
	
	if showTimers >= 2 then
		print(string.format("%3s ms for OnCityViewUpdate DISPLAY_INCOME", math.floor((os.clock() - timeStart) * 1000)))
		timeStart = os.clock()
	end

	
	-- Viewing mode only
	if (UI.IsCityScreenViewingMode()) then
		
		-- City Cycling
		Controls.PrevCityButton:SetDisabled( true )
		Controls.NextCityButton:SetDisabled( true )
		
		-- Governor
		Controls.BalancedFocusButton:SetDisabled( true )
		Controls.FoodFocusButton:SetDisabled( true )
		Controls.ProductionFocusButton:SetDisabled( true )
		Controls.GoldFocusButton:SetDisabled( true )
		Controls.ResearchFocusButton:SetDisabled( true )
		Controls.CultureFocusButton:SetDisabled( true )
		Controls.GPFocusButton:SetDisabled( true )
		Controls.FaithFocusButton:SetDisabled( true )
		Controls.AvoidGrowthButton:SetDisabled( true )
		Controls.ResetButton:SetDisabled( true )
		
		Controls.BoxOSlackers:SetDisabled( true )
		Controls.NoAutoSpecialistCheckbox:SetDisabled( true )
		
		-- Other
		Controls.RazeCityButton:SetDisabled( true )
		Controls.UnrazeCityButton:SetDisabled( true )
		
		Controls.BuyPlotButton:SetDisabled( true )
		
	else
		
		-- City Cycling
		Controls.PrevCityButton:SetDisabled( false )
		Controls.NextCityButton:SetDisabled( false )
		
		-- Governor
		Controls.BalancedFocusButton:SetDisabled( false )
		Controls.FoodFocusButton:SetDisabled( false )
		Controls.ProductionFocusButton:SetDisabled( false )
		Controls.GoldFocusButton:SetDisabled( false )
		Controls.ResearchFocusButton:SetDisabled( false )
		Controls.CultureFocusButton:SetDisabled( false )
		Controls.GPFocusButton:SetDisabled( false )
		Controls.FaithFocusButton:SetDisabled( false )
		Controls.AvoidGrowthButton:SetDisabled( false )
		Controls.ResetButton:SetDisabled( false )
		
		Controls.BoxOSlackers:SetDisabled( false )
		Controls.NoAutoSpecialistCheckbox:SetDisabled( false )
		
		-- Other
		if (not g_bRazeButtonDisabled) then
			Controls.RazeCityButton:SetDisabled( false )
			Controls.UnrazeCityButton:SetDisabled( false )
		end
		
		Controls.BuyPlotButton:SetDisabled( false )
	end
	
	if (city:GetOwner() ~= Game.GetActivePlayer()) then
		Controls.ProductionButton:SetDisabled(true)
		Controls.PurchaseButton:SetDisabled(true)
		Controls.EditButton:SetHide(true)
		Controls.EndTurnText:SetText(Locale.ConvertTextKey("TXT_KEY_CITYVIEW_RETURN_TO_ESPIONAGE"))
	end
	

	if showTimers >= 1 then
		print(string.format("%3s ms for OnCityViewUpdate END", math.floor((os.clock() - timeStart) * 1000)))
		print(" ")
	end
end
Events.SerialEventCityScreenDirty.Add(OnCityViewUpdate)
Events.SerialEventCityInfoDirty.Add(OnCityViewUpdate)


-----------------------------------------------------------------
-----------------------------------------------------------------
function RecalcPanelSize()
	Controls.RightStack:CalculateSize()
	local size = math.min( screenSizeY + 30, Controls.RightStack:GetSizeY() + 85 )
	size = math.max( size, 160 )
    Controls.BuildingListBackground:SetSizeY( size )
    
	size = math.min( screenSizeY - 65, Controls.RightStack:GetSizeY() + 85 )
    Controls.ScrollPanel:SetSizeY( size )
	Controls.ScrollPanel:CalculateInternalSize()
	Controls.ScrollPanel:ReprocessAnchoring()
end


-------------------------------------------------
-- On City Set Damage
-------------------------------------------------
function OnCitySetDamage(iDamage, iMaxDamage)
	
	local iHealthPercent = 1 - (iDamage / iMaxDamage)

    Controls.HealthMeter:SetPercent(iHealthPercent)
    
    if iHealthPercent > 0.66 then
        Controls.HealthMeter:SetTexture("CityNamePanelHealthBarGreen.dds")
    elseif iHealthPercent > 0.33 then
        Controls.HealthMeter:SetTexture("CityNamePanelHealthBarYellow.dds")
    else
        Controls.HealthMeter:SetTexture("CityNamePanelHealthBarRed.dds")
    end
    
    -- Show or hide the Health Bar as necessary
    if (iDamage == 0) then
		Controls.HealthFrame:SetHide(true)
	else
		Controls.HealthFrame:SetHide(false)
    end

end

-------------------------------------------------
-- Update Production Info
-------------------------------------------------
function DoUpdateProductionInfo( bNoProduction )
	
	local city = UI.GetHeadSelectedCity()
	local player = Players[city:GetOwner()]

	-- Production stored and needed
	local yieldStored = City_GetYieldStored(city, YieldTypes.YIELD_PRODUCTION)
	local yieldNeeded = City_GetYieldNeeded(city, YieldTypes.YIELD_PRODUCTION)
	if (city:IsProductionProcess()) then
		yieldNeeded = 0
	end
	
	-- Base Production per turn
	local yieldRate = City_GetYieldRate(city, YieldTypes.YIELD_PRODUCTION)
	local yieldMod = city:GetProductionModifier() + 100
	
	Controls.ProductionOutput:SetText(Locale.ConvertTextKey("TXT_KEY_CITY_SCREEN_PROD_PER_TURN", Game.Round(yieldRate)))
	
	-- Progress info for meter
	local yieldStoredPlusThisTurn = yieldStored + yieldRate
	
	local fProductionProgressPercent = yieldStored / yieldNeeded
	local fProductionProgressPlusThisTurnPercent = yieldStoredPlusThisTurn / yieldNeeded
	if (fProductionProgressPlusThisTurnPercent > 1) then
		fProductionProgressPlusThisTurnPercent = 1
	end
	
	Controls.ProductionMeter:SetPercents( fProductionProgressPercent, fProductionProgressPlusThisTurnPercent )
	
	-- Turns left
	local productionTurnsLeft = City_GetYieldTurns(city, YieldTypes.YIELD_PRODUCTION)
	
	--if city:IsOccupation() then
		--Controls.ProductionTurnsLabel:SetText(" (City in unrest)")
	--else
	
	local strNumTurns
	if(productionTurnsLeft > 99) then
		strNumTurns = Locale.ConvertTextKey("TXT_KEY_PRODUCTION_HELP_99PLUS_TURNS")
	else
		strNumTurns = Locale.ConvertTextKey("TXT_KEY_PRODUCTION_HELP_NUM_TURNS", productionTurnsLeft)
	end
	
	
	
	local bGeneratingProduction = city:IsProductionProcess() or City_GetYieldRate(city, YieldTypes.YIELD_PRODUCTION) == 0
	
	if (bGeneratingProduction) then
		strNumTurns = ""
	end
	
	-- Indicator for the fact that the empire is very unhappy
	if (player:IsEmpireVeryUnhappy()) then
		strNumTurns = strNumTurns .. " [ICON_HAPPINESS_4]"
	end
	
	if (not bGeneratingProduction) then
		Controls.ProductionTurnsLabel:SetText("(" .. strNumTurns .. ")")
	else
		Controls.ProductionTurnsLabel:SetText(strNumTurns)
	end
	
	--end
	
	if bNoProduction then
		Controls.ProductionTurnsLabel:SetHide(true)
	else
		Controls.ProductionTurnsLabel:SetHide(false)
	end
	
	-----------------------------
	-- TOOLTIP
	-----------------------------
	
	local strToolTip = ""

	-- What is being produced right now?
	if (bNoProduction) then
		strToolTip = strToolTip .. Locale.ConvertTextKey("TXT_KEY_PRODUCTION_HELP_NOTHING")
	else
		if (not city:IsProductionProcess()) then
			strToolTip = strToolTip .. Locale.ConvertTextKey("TXT_KEY_PRODUCTION_HELP_TEXT", city:GetProductionNameKey(), strNumTurns)
			strToolTip = strToolTip .. "[NEWLINE]----------------[NEWLINE]"
			strToolTip = strToolTip .. Locale.ConvertTextKey("TXT_KEY_PRODUCTION_PROGRESS", yieldStored, yieldNeeded)
		end
	end
	
	local iBaseProductionPT = city:GetBaseYieldRate(YieldTypes.YIELD_PRODUCTION)
	
	-- Output
	local strBase = Locale.ConvertTextKey("TXT_KEY_YIELD_BASE", iBaseProductionPT, "[ICON_PRODUCTION]")
	local strTotal = Locale.ConvertTextKey("TXT_KEY_YIELD_TOTAL", yieldRate, "[ICON_PRODUCTION]")
	local strOutput = strBase .. "[NEWLINE]" .. strTotal
	strToolTip = strToolTip .. "[NEWLINE]"
	
	-- This builds the tooltip from C++
	local strCodeToolTip = city:GetYieldModifierTooltip(YieldTypes.YIELD_PRODUCTION)
	if (strCodeToolTip ~= "") then
		strOutput = strOutput .. "[NEWLINE]----------------" .. strCodeToolTip
	end

	strToolTip = strToolTip .. strOutput
	
	--Controls.ProductionDescriptionBox:SetToolTipString(strToolTip)
	Controls.ProductionPortraitButton:SetToolTipString(strToolTip)
	
	-- Info for the upper-left display
	Controls.ProdPerTurnLabel:SetText(FormatYield(yieldRate))
	
	local strProductionHelp = GetYieldTooltip(city, YieldTypes.YIELD_PRODUCTION)
	
	Controls.ProdBox:SetToolTipString(strProductionHelp)
	
end


-------------------------------------------------
-- Update Tooltips in the upper-left part of the screen
-------------------------------------------------
function DoUpdateUpperLeftTooltips()
	
	local city = UI.GetHeadSelectedCity()
	
	local strFoodToolTip = GetYieldTooltip(city, YieldTypes.YIELD_FOOD)
	Controls.FoodBox:SetToolTipString(strFoodToolTip)
	Controls.PopulationBox:SetToolTipString(strFoodToolTip)
	Controls.HappinessCityBox:SetToolTipString(GetYieldTooltip(city, YieldTypes.YIELD_HAPPINESS_CITY))
	Controls.HappinessNationalBox:SetToolTipString(GetYieldTooltip(city, YieldTypes.YIELD_HAPPINESS_NATIONAL))
	Controls.GoldBox:SetToolTipString(GetYieldTooltip(city, YieldTypes.YIELD_GOLD))
	Controls.ScienceBox:SetToolTipString(GetYieldTooltip(city, YieldTypes.YIELD_SCIENCE))
	Controls.CultureBox:SetToolTipString(GetYieldTooltip(city, YieldTypes.YIELD_CULTURE))
	Controls.FaithBox:SetToolTipString(GetYieldTooltip(city, YieldTypes.YIELD_FAITH))
end

-------------------------------------------------
-- Enter City Screen
-------------------------------------------------
function OnEnterCityScreen()
	
	local city = UI.GetHeadSelectedCity()
	
	if (city ~= nil) then
		Network.SendUpdateCityCitizens(city:GetID())
		LuaEvents.DirtyYieldCacheCity(city)
	end

	LuaEvents.TryQueueTutorial("CITY_SCREEN", true)
	
	UI.SetInterfaceMode(InterfaceModeTypes.INTERFACEMODE_SELECTION)
end
Events.SerialEventEnterCityScreen.Add(OnEnterCityScreen)


-------------------------------------------------
-------------------------------------------------
function PlotButtonClicked( iPlotIndex )
	if iPlotIndex > 0 then
		local city = UI.GetHeadSelectedCity()
		Network.SendDoTask(city:GetID(), TaskTypes.TASK_CHANGE_WORKING_PLOT, iPlotIndex, -1, false, bAlt, bShift, bCtrl)
		LuaEvents.DirtyYieldCacheCity(city)
	end
end

-------------------------------------------------
-------------------------------------------------
function BuyPlotAnchorButtonClicked(plotID, cityID)
	local plot = Map.GetPlotByIndex(plotID)
	local city = Map_GetCity(cityID)
	local purchaseCost = Plot_GetCost(city, plot)
	local activePlayerID = Game.GetActivePlayer()
	local pHeadSelectedCity = UI.GetHeadSelectedCity()
	if pHeadSelectedCity then
		local plotX = plot:GetX()
		local plotY = plot:GetY()
		--Network.SendCityBuyPlot(pHeadSelectedCity:GetID(), plotX, plotY)
		Plot_Buy(plot, Players[activePlayerID], city, purchaseCost)
		UI.UpdateCityScreen()
		Events.AudioPlay2DSound("AS2D_INTERFACE_BUY_TILE")
		LuaEvents.DirtyYieldCacheCity(city)
	end
	return true
end


-------------------------------------------------
-------------------------------------------------
function UpdateWorkingHexes()
		
	local city = UI.GetHeadSelectedCity()
	local player = Players[Game.GetActivePlayer()]	
	
    if( city == nil ) then
        return
    end
    
	if not UI.IsCityScreenUp() then
		return
	end
	-- display worked plots
	g_PlotButtonIM:ResetInstances()
	for i = 0, city:GetNumCityPlots() - 1, 1 do
		local plot = city:GetCityIndexPlot( i )
		if (plot ~= nil) then
			
			bNoHighlight = false
			
			if ( plot:GetOwner() == city:GetOwner() ) then
			
				if workerHeadingOpen then
					local hexPos = ToHexFromGrid( Vector2( plot:GetX(), plot:GetY() ) )
					local worldPos = HexToWorld( hexPos )
				
					-- the city itself
					if ( i == 0 ) then
						local controlTable = g_PlotButtonIM:GetInstance()						
						controlTable.PlotButtonAnchor:SetWorldPosition( VecAdd( worldPos, WorldPositionOffset ) )
						IconHookup(	11, 45, "CITIZEN_ATLAS", controlTable.PlotButtonImage)
						controlTable.PlotButtonImage:SetToolTipString( Locale.ConvertTextKey("TXT_KEY_CITYVIEW_CITY_CENTER") )
						controlTable.PlotButtonImage:SetVoid1( -1 )
						controlTable.PlotButtonImage:RegisterCallback( Mouse.eLCLick, OnResetForcedTiles)
						
						DoTestViewingModeOnly(controlTable)
						
						--Events.SerialEventHexHighlight( ToHexFromGrid( Vector2( plot:GetX(), plot:GetY() ) ), true, Vector4( 1.0, 1.0, 1.0, 1 ) )
					-- FORCED worked plot
					elseif ( city:IsWorkingPlot( plot ) and city:IsForcedWorkingPlot( plot ) ) then
						local controlTable = g_PlotButtonIM:GetInstance()						
						controlTable.PlotButtonAnchor:SetWorldPosition( VecAdd( worldPos, WorldPositionOffset ) )
						IconHookup(	10, 45, "CITIZEN_ATLAS", controlTable.PlotButtonImage)
						controlTable.PlotButtonImage:SetToolTipString( Locale.ConvertTextKey("TXT_KEY_CITYVIEW_FORCED_WORK_TILE") )
						controlTable.PlotButtonImage:SetVoid1( i )
						controlTable.PlotButtonImage:RegisterCallback( Mouse.eLCLick, PlotButtonClicked)
						
						DoTestViewingModeOnly(controlTable)
						
						--Events.SerialEventHexHighlight( ToHexFromGrid( Vector2( plot:GetX(), plot:GetY() ) ), true, Vector4( 1.0, 1.0, 1.0, 1 ) )
					-- AI-picked worked plot
					elseif ( city:IsWorkingPlot( plot ) ) then						
						local controlTable = g_PlotButtonIM:GetInstance()						
						controlTable.PlotButtonAnchor:SetWorldPosition( VecAdd( worldPos, WorldPositionOffset ) )
						IconHookup(	0, 45, "CITIZEN_ATLAS", controlTable.PlotButtonImage)
						controlTable.PlotButtonImage:SetToolTipString( Locale.ConvertTextKey("TXT_KEY_CITYVIEW_GUVNA_WORK_TILE") )
						controlTable.PlotButtonImage:SetVoid1( i )
						controlTable.PlotButtonImage:RegisterCallback( Mouse.eLCLick, PlotButtonClicked)
						
						DoTestViewingModeOnly(controlTable)
						
						--Events.SerialEventHexHighlight( ToHexFromGrid( Vector2( plot:GetX(), plot:GetY() ) ), true, Vector4( 0.0, 1.0, 0.0, 1 ) )
					-- Owned by another one of our Cities
					elseif ( plot:GetWorkingCity():GetID() ~= city:GetID() and  plot:GetWorkingCity():IsWorkingPlot( plot ) ) then
						local controlTable = g_PlotButtonIM:GetInstance()						
						controlTable.PlotButtonAnchor:SetWorldPosition( VecAdd( worldPos, WorldPositionOffset ) )
						IconHookup(	12, 45, "CITIZEN_ATLAS", controlTable.PlotButtonImage)
						controlTable.PlotButtonImage:SetToolTipString( Locale.ConvertTextKey("TXT_KEY_CITYVIEW_NUTHA_CITY_TILE") )
						controlTable.PlotButtonImage:SetVoid1( i )
						controlTable.PlotButtonImage:RegisterCallback( Mouse.eLCLick, PlotButtonClicked)
						
						DoTestViewingModeOnly(controlTable)
						
						--Events.SerialEventHexHighlight( ToHexFromGrid( Vector2( plot:GetX(), plot:GetY() ) ), true, Vector4( 0.0, 0.0, 1.0, 1 ) )
					-- Blockaded water plot
					elseif ( plot:IsWater() and city:IsPlotBlockaded( plot ) ) then
						local controlTable = g_PlotButtonIM:GetInstance()						
						controlTable.PlotButtonAnchor:SetWorldPosition( VecAdd( worldPos, WorldPositionOffset ) )
						IconHookup(	13, 45, "CITIZEN_ATLAS", controlTable.PlotButtonImage)
						controlTable.PlotButtonImage:SetToolTipString( Locale.ConvertTextKey("TXT_KEY_CITYVIEW_BLOCKADED_CITY_TILE") )
						controlTable.PlotButtonImage:SetVoid1( -1 )
						controlTable.PlotButtonImage:RegisterCallback( Mouse.eLCLick, PlotButtonClicked)
						
						DoTestViewingModeOnly(controlTable)
						
						--Events.SerialEventHexHighlight( ToHexFromGrid( Vector2( plot:GetX(), plot:GetY() ) ), true, Vector4( 1.0, 0.0, 0.0, 1 ) )
					-- Enemy Unit standing here
					elseif ( plot:IsVisibleEnemyUnit(city:GetOwner()) ) then
						local controlTable = g_PlotButtonIM:GetInstance()						
						controlTable.PlotButtonAnchor:SetWorldPosition( VecAdd( worldPos, WorldPositionOffset ) )
						IconHookup(	13, 45, "CITIZEN_ATLAS", controlTable.PlotButtonImage)
						controlTable.PlotButtonImage:SetToolTipString( Locale.ConvertTextKey("TXT_KEY_CITYVIEW_ENEMY_UNIT_CITY_TILE") )
						controlTable.PlotButtonImage:SetVoid1( -1 )
						controlTable.PlotButtonImage:RegisterCallback( Mouse.eLCLick, PlotButtonClicked)
						
						DoTestViewingModeOnly(controlTable)
						
						--Events.SerialEventHexHighlight( ToHexFromGrid( Vector2( plot:GetX(), plot:GetY() ) ), true, Vector4( 1.0, 0.0, 0.0, 1 ) )
					-- Other: turn off highlight
					elseif ( city:CanWork( plot ) or plot:GetWorkingCity():GetID() ~= city:GetID() ) then
						local controlTable = g_PlotButtonIM:GetInstance()						
						controlTable.PlotButtonAnchor:SetWorldPosition( VecAdd( worldPos, WorldPositionOffset ) )
						controlTable.PlotButtonImage:SetToolTipString( Locale.ConvertTextKey("TXT_KEY_CITYVIEW_UNWORKED_CITY_TILE") )
						IconHookup(	9, 45, "CITIZEN_ATLAS", controlTable.PlotButtonImage)
						controlTable.PlotButtonImage:SetVoid1( i )
						controlTable.PlotButtonImage:RegisterCallback( Mouse.eLCLick, PlotButtonClicked)
						bNoHighlight = true
						
						DoTestViewingModeOnly(controlTable)
						
					end
					
				else
					bNoHighlight = true
				end
			end
			
			--if (bNoHighlight) then
				Events.SerialEventHexHighlight( ToHexFromGrid( Vector2( plot:GetX(), plot:GetY() ) ), false, Vector4( 0.0, 1.0, 0.0, 1 ) )
			--end
		end
	end
	
	-- Add buy plot buttons
	g_BuyPlotButtonIM:ResetInstances()
	if UI.GetInterfaceMode() ~= InterfaceModeTypes.INTERFACEMODE_PURCHASE_PLOT then
		-- Standard mode - show plots that will be acquired by culture
		local aPurchasablePlots = {city:GetBuyablePlotList()}
		for i = 1, #aPurchasablePlots, 1 do
			Events.SerialEventHexHighlight( ToHexFromGrid( Vector2( aPurchasablePlots[i]:GetX(), aPurchasablePlots[i]:GetY() ) ), true, Vector4( 1.0, 0.0, 1.0, 1 ) )
		end
		return
	end
	

	local timeStart = os.clock()
	Events.RequestYieldDisplay( YieldDisplayTypes.CITY_PURCHASABLE, city:GetX(), city:GetY() )
	local goldStored = player:GetYieldStored(YieldTypes.YIELD_GOLD)
	for plotID, plot in Plots() do
		if Map.PlotDistance(city:Plot():GetX(), city:Plot():GetY(), plot:GetX(), plot:GetY()) <= GameDefines.MAXIMUM_BUY_PLOT_DISTANCE then
			local hexPos = ToHexFromGrid( Vector2( plot:GetX(), plot:GetY() ) )
			local worldPos = HexToWorld( hexPos )
			local purchaseCity, purchaseCost = City_GetBestPlotPurchaseCity(city, plot)
			if purchaseCity then
				if purchaseCost <= goldStored then
					local controlTable = g_BuyPlotButtonIM:GetInstance()						
					controlTable.BuyPlotButtonAnchor:SetWorldPosition( VecAdd( worldPos, WorldPositionOffset2 ) )
					local strText = Locale.ConvertTextKey("TXT_KEY_CITYVIEW_CLAIM_NEW_LAND",purchaseCost)
					controlTable.BuyPlotAnchoredButton:SetToolTipString( strText )
					controlTable.BuyPlotAnchoredButtonLabel:SetText( tostring(purchaseCost) )
					controlTable.BuyPlotAnchoredButton:SetDisabled( false )
					controlTable.BuyPlotAnchoredButton:RegisterCallback( Mouse.eLCLick, BuyPlotAnchorButtonClicked)
					controlTable.BuyPlotAnchoredButton:SetVoids(plotID, City_GetID(purchaseCity))
				elseif purchaseCost ~= math.huge then
					local controlTable = g_BuyPlotButtonIM:GetInstance()						
					controlTable.BuyPlotButtonAnchor:SetWorldPosition( VecAdd( worldPos, WorldPositionOffset2 ) )
					local strText = Locale.ConvertTextKey("TXT_KEY_CITYVIEW_NEED_MONEY_BUY_TILE",purchaseCost)
					controlTable.BuyPlotAnchoredButton:SetToolTipString( strText )
					controlTable.BuyPlotAnchoredButton:SetDisabled( true )
					controlTable.BuyPlotAnchoredButtonLabel:SetText( "[COLOR_WARNING_TEXT]"..tostring(purchaseCost).."[ENDCOLOR]" )
				end
			end
		end
	end
	if showTimers >= 2 then
		print(string.format("%3s ms for UpdateWorkingHexes City_GetBestPlotPurchaseCity", math.floor((os.clock() - timeStart) * 1000)))
		timeStart = os.clock()
	end
	local aPurchasablePlots = {city:GetBuyablePlotList()}
	for i = 1, #aPurchasablePlots, 1 do
		Events.SerialEventHexHighlight( ToHexFromGrid( Vector2( aPurchasablePlots[i]:GetX(), aPurchasablePlots[i]:GetY() ) ), true, Vector4( 1.0, 0.0, 1.0, 1 ) )
	end
end
Events.SerialEventCityHexHighlightDirty.Add(UpdateWorkingHexes)

-------------------------------------------------
function DoTestViewingModeOnly(controlTable)
	
	-- Viewing mode only?
	if (	UI.IsCityScreenViewingMode()) then
		controlTable.PlotButtonImage:SetDisabled(true)
	else
		controlTable.PlotButtonImage:SetDisabled(false)
	end
	
end	



-------------------------------------------------
-------------------------------------------------
function OnProductionClick()
	
	local city = UI.GetHeadSelectedCity()
	local cityID = city:GetID()
	local popupInfo = {
		Type = ButtonPopupTypes.BUTTONPOPUP_CHOOSEPRODUCTION,
		Data1 = cityID,
		Data2 = -1,
		Data3 = -1,
		Option1 = (productionQueueOpen and city:GetOrderQueueLength() > 0),
		Option2 = false
	}
	Events.SerialEventGameMessagePopup(popupInfo)
    -- send production popup message
end
Controls.ProductionButton:RegisterCallback( Mouse.eLClick, OnProductionClick )


-------------------------------------------------
-------------------------------------------------
function OnRemoveClick( num )	
	Game.SelectedCitiesGameNetMessage(GameMessageTypes.GAMEMESSAGE_POP_ORDER, num)
end
Controls.b1remove:RegisterCallback( Mouse.eLClick, OnRemoveClick )
Controls.b1remove:SetVoid1( 0 )
Controls.b2remove:RegisterCallback( Mouse.eLClick, OnRemoveClick )
Controls.b2remove:SetVoid1( 1 )
Controls.b3remove:RegisterCallback( Mouse.eLClick, OnRemoveClick )
Controls.b3remove:SetVoid1( 2 )
Controls.b4remove:RegisterCallback( Mouse.eLClick, OnRemoveClick )
Controls.b4remove:SetVoid1( 3 )
Controls.b5remove:RegisterCallback( Mouse.eLClick, OnRemoveClick )
Controls.b5remove:SetVoid1( 4 )
Controls.b6remove:RegisterCallback( Mouse.eLClick, OnRemoveClick )
Controls.b6remove:SetVoid1( 5 )

-------------------------------------------------
-------------------------------------------------
function OnSwapClick( num )
	print()
	Game.SelectedCitiesGameNetMessage(GameMessageTypes.GAMEMESSAGE_SWAP_ORDER, num)
end
Controls.b1down:RegisterCallback( Mouse.eLClick, OnSwapClick )
Controls.b1down:SetVoid1( 0 )

Controls.b2up:RegisterCallback( Mouse.eLClick, OnSwapClick )
Controls.b2up:SetVoid1( 0 )
Controls.b2down:RegisterCallback( Mouse.eLClick, OnSwapClick )
Controls.b2down:SetVoid1( 1 )

Controls.b3up:RegisterCallback( Mouse.eLClick, OnSwapClick )
Controls.b3up:SetVoid1( 1 )
Controls.b3down:RegisterCallback( Mouse.eLClick, OnSwapClick )
Controls.b3down:SetVoid1( 2 )

Controls.b4up:RegisterCallback( Mouse.eLClick, OnSwapClick )
Controls.b4up:SetVoid1( 2 )
Controls.b4down:RegisterCallback( Mouse.eLClick, OnSwapClick )
Controls.b4down:SetVoid1( 3 )

Controls.b5up:RegisterCallback( Mouse.eLClick, OnSwapClick )
Controls.b5up:SetVoid1( 3 )
Controls.b5down:RegisterCallback( Mouse.eLClick, OnSwapClick )
Controls.b5down:SetVoid1( 4 )

Controls.b6up:RegisterCallback( Mouse.eLClick, OnSwapClick )
Controls.b6up:SetVoid1( 4 )
--Controls.b6down:RegisterCallback( Mouse.eLClick, OnSwapClick )
--Controls.b6down:SetVoid1( 5 )


-------------------------------------------------
-------------------------------------------------

local g_iCurrentSpecialist = -1
local g_bCurrentSpecialistGrowth = true

---------------------------------------------------------------
-- Specialist Automation Checkbox
---------------------------------------------------------------
function OnNoAutoSpecialistCheckboxClick()
	local bValue = false
	local city = UI.GetHeadSelectedCity()
	
	-- Checkbox was JUST turned on, 
	if (not city:IsNoAutoAssignSpecialists()) then
		bValue = true
	end
	
	Game.SelectedCitiesGameNetMessage(GameMessageTypes.GAMEMESSAGE_DO_TASK, TaskTypes.TASK_NO_AUTO_ASSIGN_SPECIALISTS, -1, -1, bValue)
	LuaEvents.DirtyYieldCacheCity(city)
end
Controls.NoAutoSpecialistCheckbox:RegisterCallback(Mouse.eLClick, OnNoAutoSpecialistCheckboxClick)

---------------------------------------------------------------
-- Clicking on Building instances to add or remove Specialists
---------------------------------------------------------------
function OnBuildingClick(iBuilding)
	--local city = UI.GetHeadSelectedCity()
	--
	--local iNumSpecialistsAllowed = city:GetNumSpecialistsAllowedByBuilding(iBuilding)
	--local iNumSpecialistsAssigned = city:GetNumSpecialistsInBuilding(iBuilding)
	--
	--if (iNumSpecialistsAllowed > 0) then
		--
		---- If Specialists are automated then you can't change things with them
		--if (not city:IsNoAutoAssignSpecialists()) then
			--local bValue = true
			--Game.SelectedCitiesGameNetMessage(GameMessageTypes.GAMEMESSAGE_DO_TASK, TaskTypes.TASK_NO_AUTO_ASSIGN_SPECIALISTS, -1, -1, bValue)
			--Controls.NoAutoSpecialistCheckbox:SetCheck(true)
		--end
		--
		--local iSpecialist = GameInfoTypes[GameInfo.Buildings[iBuilding].SpecialistType]
		--
		---- Switched to a different specialist type, so clicking on the building will grow the count
		--if (iSpecialist ~= g_iCurrentSpecialist) then
			--g_bCurrentSpecialistGrowth = true
		--end
		--
		---- Nobody assigned yet, so we must grow
		--if (iNumSpecialistsAssigned == 0) then
			--g_bCurrentSpecialistGrowth = true
		--end
		--
		---- If we can add something, add it
		--if (g_bCurrentSpecialistGrowth and city:IsCanAddSpecialistToBuilding(iBuilding)) then
			--Game.SelectedCitiesGameNetMessage(GameMessageTypes.GAMEMESSAGE_DO_TASK, TaskTypes.TASK_ADD_SPECIALIST, iSpecialist, iBuilding)
			--
		---- Can't add something, so remove what's here instead
		--elseif (iNumSpecialistsAssigned > 0) then
			--Game.SelectedCitiesGameNetMessage(GameMessageTypes.GAMEMESSAGE_DO_TASK, TaskTypes.TASK_REMOVE_SPECIALIST, iSpecialist, iBuilding)
			--
			---- Start removing Specialists
			--g_bCurrentSpecialistGrowth = false
		--end
		--
		--g_iCurrentSpecialist = iSpecialist
	--end
	--
end


function DisableSpecialist(iBuilding, slot)
end


function AddSpecialist(iBuilding, slot)
	local city = UI.GetHeadSelectedCity()
				
	-- If Specialists are automated then you can't change things with them
	if (not city:IsNoAutoAssignSpecialists()) then
		Game.SelectedCitiesGameNetMessage(GameMessageTypes.GAMEMESSAGE_DO_TASK, TaskTypes.TASK_NO_AUTO_ASSIGN_SPECIALISTS, -1, -1, true)
		Controls.NoAutoSpecialistCheckbox:SetCheck(true)
	end
	
	local iSpecialist = GameInfoTypes[GameInfo.Buildings[iBuilding].SpecialistType]
	
	-- If we can add something, add it
	if (city:IsCanAddSpecialistToBuilding(iBuilding)) then
		Game.SelectedCitiesGameNetMessage(GameMessageTypes.GAMEMESSAGE_DO_TASK, TaskTypes.TASK_ADD_SPECIALIST, iSpecialist, iBuilding)
	end

	LuaEvents.DirtyYieldCacheCity(city)
	
	--g_iCurrentSpecialist = iSpecialist
	specialistSlotTable[slotid] = {ID = slotid, Type = iSpecialist, Building = iBuilding, Slot = slot, Filled = true}
	
end

function RemoveSpecialist(iBuilding, slot)
	local city = UI.GetHeadSelectedCity()
	
	local iNumSpecialistsAssigned = city:GetNumSpecialistsInBuilding(iBuilding)
				
	-- If Specialists are automated then you can't change things with them
	if (not city:IsNoAutoAssignSpecialists()) then
		Game.SelectedCitiesGameNetMessage(GameMessageTypes.GAMEMESSAGE_DO_TASK, TaskTypes.TASK_NO_AUTO_ASSIGN_SPECIALISTS, -1, -1, true)
		Controls.NoAutoSpecialistCheckbox:SetCheck(true)
	end
	
	local iSpecialist = GameInfoTypes[GameInfo.Buildings[iBuilding].SpecialistType]
	
	-- If we can remove something, remove it
	if (iNumSpecialistsAssigned > 0) then
		Game.SelectedCitiesGameNetMessage(GameMessageTypes.GAMEMESSAGE_DO_TASK, TaskTypes.TASK_REMOVE_SPECIALIST, iSpecialist, iBuilding)
	end
	
	--g_iCurrentSpecialist = iSpecialist

	specialistSlotTable[slotid] = {ID = slotid, Type = iSpecialist, Building = iBuilding, Slot = slot, Filled = false}
	
	LuaEvents.DirtyYieldCacheCity(city)
end

-------------------------------------------------
-------------------------------------------------
function OnNextCityButton()
	Game.DoControl(GameInfoTypes.CONTROL_NEXTCITY)
end
Controls.NextCityButton:RegisterCallback( Mouse.eLClick, OnNextCityButton )

-------------------------------------------------
-------------------------------------------------
function OnPrevCityButton()
	Game.DoControl(GameInfoTypes.CONTROL_PREVCITY)
end
Controls.PrevCityButton:RegisterCallback( Mouse.eLClick, OnPrevCityButton )

-------------------------------------------------
-------------------------------------------------
function UpdateBuyPlotButton()
	--local city = UI.GetHeadSelectedCity()
	--
	--if (city == nil) then
		--return
	--end
	--
	--if not city:CanBuyAnyPlot() then
		--return
	--end
	--
	--local cost = city:GetBuyPlotCost(-1,-1) -- leaving GetBuyPlotCost() blank means get the price of the plot at (0,0) as opposed to the generic price
	--local str = Locale.ConvertTextKey("TXT_KEY_CITYVIEW_CLAIM_NEW_LAND" ,cost )
--
	--Controls.BuyPlotText:SetText(str)
end

-------------------------------------------------
-------------------------------------------------
function OnBuyPlotClick()
	local city = UI.GetHeadSelectedCity()
	
	if (city == nil) then
		return
	end
	
	UI.SetInterfaceMode(InterfaceModeTypes.INTERFACEMODE_PURCHASE_PLOT)
	UpdateWorkingHexes()
	
	--Network.SendCityBuyPlot(city:GetID(), -1, -1)
	--UpdateBuyPlotButton()
end
Controls.BuyPlotButton:RegisterCallback( Mouse.eLClick, OnBuyPlotClick )

-------------------------------------------------
-- Plot moused over
-------------------------------------------------
function OnMouseOverHex( hexX, hexY )
	
	if UI.GetInterfaceMode() == InterfaceModeTypes.INTERFACEMODE_PURCHASE_PLOT then
		
		local city = UI.GetHeadSelectedCity()
		
		if (city == nil) then
			return
		end

		local strText = "---"
		
		-- Can buy this plot
		if (city:CanBuyPlotAt( hexX, hexY, true)) then
			local iPlotCost = Plot_GetCost(city, Map.GetPlot( hexX, hexY ))
			strText = "[ICON_GOLD] " .. iPlotCost
		end
		
		Controls.BuyPlotText:SetText(strText)
	end
	
end
Events.SerialEventMouseOverHex.Add( OnMouseOverHex )

-------------------------------------------------
-------------------------------------------------
function OnReturnToMapButton()
	--CloseScreen()
	Events.SerialEventExitCityScreen()
end
Controls.ReturnToMapButton:RegisterCallback( Mouse.eLClick, OnReturnToMapButton)

-------------------------------------------------
-------------------------------------------------
function OnRazeButton()

	local city = UI.GetHeadSelectedCity()
	
	if (city == nil) then
		return
	end
	
	local popupInfo = {
		Type = ButtonPopupTypes.BUTTONPOPUP_CONFIRM_CITY_TASK,
		Data1 = city:GetID(),
		Data2 = TaskTypes.TASK_RAZE,
		}
    
	Events.SerialEventGameMessagePopup( popupInfo )
end
Controls.RazeCityButton:RegisterCallback( Mouse.eLClick, OnRazeButton)

-------------------------------------------------
-------------------------------------------------
function OnUnrazeButton()

	local city = UI.GetHeadSelectedCity()
	
	if (city == nil) then
		return
	end
	
	Network.SendDoTask(city:GetID(), TaskTypes.TASK_UNRAZE, -1, -1, false, false, false, false)
end
Controls.UnrazeCityButton:RegisterCallback( Mouse.eLClick, OnUnrazeButton)

-------------------------------------------------
-------------------------------------------------
function OnPurchaseButton()
	local city = UI.GetHeadSelectedCity()
	local cityID = city:GetID()
	local popupInfo = {
		Type = ButtonPopupTypes.BUTTONPOPUP_CHOOSEPRODUCTION,
		Data1 = cityID,
		Data2 = -1,
		Data3 = -1,
		Option1 = (productionQueueOpen and city:GetOrderQueueLength() > 0),
		Option2 = true
	}
	Events.SerialEventGameMessagePopup(popupInfo)
    -- send production popup message

end
Controls.PurchaseButton:RegisterCallback( Mouse.eLClick, OnPurchaseButton)


function OnPortraitRClicked()
	local city = UI.GetHeadSelectedCity()
	local cityID = city:GetID()

	local searchString = ""
	local unitProduction = city:GetProductionUnit()
	local buildingProduction = city:GetProductionBuilding()
	local projectProduction = city:GetProductionProject()
	local processProduction = city:GetProductionProcess()
	local noProduction = false

	if unitProduction ~= -1 then
		local thisUnitInfo = GameInfo.Units[unitProduction]
		searchString = Locale.ConvertTextKey( thisUnitInfo.Description )
	elseif buildingProduction ~= -1 then
		local thisBuildingInfo = GameInfo.Buildings[buildingProduction]
		searchString = Locale.ConvertTextKey( thisBuildingInfo.Description )
	elseif projectProduction ~= -1 then
		local thisProjectInfo = GameInfo.Projects[projectProduction]
		searchString = Locale.ConvertTextKey( thisProjectInfo.Description )
	elseif processProduction ~= -1 then
		local pProcessInfo = GameInfo.Processes[processProduction]
		searchString = Locale.ConvertTextKey( pProcessInfo.Description )
	else
		noProduction = true
	end
		
	if noProduction == false then
	
		--CloseScreen()

		-- search by name
		Events.SearchForPediaEntry( searchString )		
	end
		
end
Controls.ProductionPortraitButton:RegisterCallback( Mouse.eRClick, OnPortraitRClicked )


----------------------------------------------------------------
----------------------------------------------------------------
function OnHideQueue( bIsChecked )
	productionQueueOpen = bIsChecked
	OnCityViewUpdate()
end
Controls.HideQueueButton:RegisterCheckHandler( OnHideQueue )


----------------------------------------------------------------
----------------------------------------------------------------

function FocusChanged( focus )
	local city = UI.GetHeadSelectedCity()
	Network.SendSetCityAIFocus( city:GetID(), focus )
	LuaEvents.DirtyYieldCachePlayer(Players[Game.GetActivePlayer()])
end
Controls.BalancedFocusButton:SetVoid1( CityAIFocusTypes.NO_CITY_AI_FOCUS_TYPE )
Controls.BalancedFocusButton:RegisterCallback( Mouse.eLClick, FocusChanged )

Controls.FoodFocusButton:SetVoid1( CityAIFocusTypes.CITY_AI_FOCUS_TYPE_FOOD )
Controls.FoodFocusButton:RegisterCallback( Mouse.eLClick, FocusChanged )

Controls.ProductionFocusButton:SetVoid1( CityAIFocusTypes.CITY_AI_FOCUS_TYPE_PRODUCTION )
Controls.ProductionFocusButton:RegisterCallback( Mouse.eLClick, FocusChanged )

Controls.GoldFocusButton:SetVoid1( CityAIFocusTypes.CITY_AI_FOCUS_TYPE_GOLD )
Controls.GoldFocusButton:RegisterCallback( Mouse.eLClick, FocusChanged )

Controls.ResearchFocusButton:SetVoid1( CityAIFocusTypes.CITY_AI_FOCUS_TYPE_SCIENCE )
Controls.ResearchFocusButton:RegisterCallback( Mouse.eLClick, FocusChanged )

Controls.CultureFocusButton:SetVoid1( CityAIFocusTypes.CITY_AI_FOCUS_TYPE_CULTURE )
Controls.CultureFocusButton:RegisterCallback( Mouse.eLClick, FocusChanged )

Controls.GPFocusButton:SetVoid1( CityAIFocusTypes.CITY_AI_FOCUS_TYPE_GREAT_PEOPLE )
Controls.GPFocusButton:RegisterCallback( Mouse.eLClick, FocusChanged )

Controls.FaithFocusButton:SetVoid1( CityAIFocusTypes.CITY_AI_FOCUS_TYPE_FAITH )
Controls.FaithFocusButton:RegisterCallback( Mouse.eLClick, FocusChanged )

----------------------------------------------------------------
----------------------------------------------------------------

function OnAvoidGrowth( )
	local city = UI.GetHeadSelectedCity()
	Network.SendSetCityAvoidGrowth( city:GetID(), not city:IsForcedAvoidGrowth() )
	LuaEvents.DirtyYieldCachePlayer(Players[Game.GetActivePlayer()])
end
Controls.AvoidGrowthButton:RegisterCallback( Mouse.eLClick, OnAvoidGrowth )

----------------------------------------------------------------
----------------------------------------------------------------

function OnResetForcedTiles( )
	local city = UI.GetHeadSelectedCity()
	if city ~= nil then
		-- calling this with the city center (0 in the third param) causes it to reset all forced tiles
		Network.SendDoTask(city:GetID(), TaskTypes.TASK_CHANGE_WORKING_PLOT, 0, -1, false, bAlt, bShift, bCtrl)
		LuaEvents.DirtyYieldCacheCity(city)
	end
end
Controls.ResetButton:RegisterCallback( Mouse.eLClick, OnResetForcedTiles )

---------------------------------------------------------------------------------------
-- Support for Modded Add-in UI's
---------------------------------------------------------------------------------------
g_uiAddins = {}
for addin in Modding.GetActivatedModEntryPoints("CityViewUIAddin") do
	local addinFile = Modding.GetEvaluatedFilePath(addin.ModID, addin.Version, addin.File)
	local addinPath = addinFile.EvaluatedPath
	
	-- Get the absolute path and filename without extension.
	local extension = Path.GetExtension(addinPath)
	local path = string.sub(addinPath, 1, #addinPath - #extension)
	
	table.insert(g_uiAddins, ContextPtr:LoadNewContext(path))
end


---------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------
function OnProductionPopup( bIsHide )
	if OptionsManager.GetSmallUIAssets() then
		Controls.TopLeft:SetHide( not bIsHide )
		Controls.CivIconFrame:SetHide( not bIsHide )
		Controls.ProdQueueBackground:SetHide( not bIsHide )
		Controls.LeftTrim:SetHide( not bIsHide )
    else
		Controls.TopLeft:SetHide( not bIsHide )
		Controls.InfoBG:SetHide( not bIsHide )
		Controls.CityInfo:SetHide( not bIsHide )
		Controls.ProdQueueBackground:SetHide( not bIsHide )
		Controls.LeftTrim:SetHide( not bIsHide )
    end
end
LuaEvents.ProductionPopup.Add( OnProductionPopup )


------------------------------------------------------------
-- Selling Buildings
------------------------------------------------------------
	
function OnBuildingClicked(iBuildingID)

	local city = UI.GetHeadSelectedCity()
	
	-- Can this building even be sold?
	if (not city:IsBuildingSellable(iBuildingID)) then
		return
	end
	
	-- Build info string
	local pBuilding = GameInfo.Buildings[iBuildingID]
	
	local iRefund = 0 --city:GetSellBuildingRefund(iBuildingID)
	local iMaintenance = pBuilding.GoldMaintenance
	
	local localizedLabel = Locale.ConvertTextKey( "TXT_KEY_SELL_BUILDING_INFO", iRefund, iMaintenance )
	Controls.SellBuildingPopupText:SetText(localizedLabel)
	
	g_iBuildingToSell = iBuildingID
	
	Controls.SellBuildingConfirm:SetHide(false)
end

function OnYes( )
	Controls.SellBuildingConfirm:SetHide(true)
	local city = UI.GetHeadSelectedCity()
	city:SetNumRealBuilding(g_iBuildingToSell, 0)
	--Network.SendSellBuilding(city:GetID(), g_iBuildingToSell)
	LuaEvents.DirtyYieldCacheCity(city)
	g_iBuildingToSell = -1
end
Controls.YesButton:RegisterCallback( Mouse.eLClick, OnYes )

function OnNo( )
	Controls.SellBuildingConfirm:SetHide(true)
	g_iBuildingToSell = -1
end
Controls.NoButton:RegisterCallback( Mouse.eLClick, OnNo )


------------------------------------------------------------
------------------------------------------------------------
local NormalWorldPositionOffset  = WorldPositionOffset
local NormalWorldPositionOffset2 = WorldPositionOffset2
local StrategicViewWorldPositionOffset = { x = 0, y = 20, z = 0 }
function OnStrategicViewStateChanged( bStrategicView )
	if bStrategicView then
		WorldPositionOffset  = StrategicViewWorldPositionOffset
		WorldPositionOffset2 = StrategicViewWorldPositionOffset
	else
		WorldPositionOffset  = NormalWorldPositionOffset
		WorldPositionOffset2 = NormalWorldPositionOffset2
	end
end
Events.StrategicViewStateChanged.Add(OnStrategicViewStateChanged)

----------------------------------------------------------------
-- 'Active' (local human) player has changed
----------------------------------------------------------------
function OnEventActivePlayerChanged( iActivePlayer, iPrevActivePlayer )
	ClearCityUIInfo()
    if( not ContextPtr:IsHidden() ) then
		Events.SerialEventExitCityScreen()	
	end
end
Events.GameplaySetActivePlayer.Add(OnEventActivePlayerChanged)
