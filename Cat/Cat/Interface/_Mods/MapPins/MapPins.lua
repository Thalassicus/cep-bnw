--
-- Use Control-X to enter "pinboard mode"
--
-- When in "pinboard mode" click on the map to place a pin
-- Use Control-X or Escape to cancel "pinboard mode"
--
-- Right-Click on a pin to edit/move/delete it
-- Use Shift-X to toggle the pins on and off
--
-- Adds an entry to the InfoCorner (top left) to display a list of all pins, sortable by type and notes
-- From the pin list, click to view, right-click to edit, shift-right-click to delete
--

local startClockTime = os.clock()

include("IconSupport")
include("InstanceManager")

local bDebug = false
local modId = "96b31a10-8777-442f-9e6b-0f8fa969b86f"

local g_PinManager = InstanceManager:new("Pin", "Anchor", Controls.PinContainer)
local g_WorldOffset = {x=0, y=-15, z=0}

local g_FlagTypes = {
  {icon="TXT_KEY_MAPPINS_FLAG_1"}, {icon="TXT_KEY_MAPPINS_FLAG_2"}, {icon="TXT_KEY_MAPPINS_FLAG_3"}, {icon="TXT_KEY_MAPPINS_FLAG_4"}, {icon="TXT_KEY_MAPPINS_FLAG_5"},
  {icon="TXT_KEY_MAPPINS_FLAG_6"}, {icon="TXT_KEY_MAPPINS_FLAG_7"}, {icon="TXT_KEY_MAPPINS_FLAG_8"}, {icon="TXT_KEY_MAPPINS_FLAG_9"}, {icon="TXT_KEY_MAPPINS_FLAG_10"},
}

--
-- Player state data
--
local g_OptionFlagsVisible = "Player_%i_FlagsVisible"
local g_PlayerState = {}

--
-- Active state data
--
local m_ActivePlayer = 0
local m_Pins = {}
local m_ActivePinID = nil
local m_ActiveMode = nil
local m_ActiveType = 3


--
-- DebugPrint
--

function dprint(...)
  if (bDebug) then
    print(string.format(...))
  end
end


--
-- Pin database functions
--
--   id                     - primary key auto-increment
--   player                 - int
--   type                   - int
--   text                   - text
--   plotx, ploty           - int
--   worldx, worldy, worldz - float
--

local modDb = nil
local modDbTable  = "MapPins"
local modDbCreate = 'CREATE TABLE IF NOT EXISTS ' ..
                    'MapPins("id" INTEGER PRIMARY KEY AUTOINCREMENT, ' ..
                            '"player" INTEGER NOT NULL, ' ..
                            '"type" INTEGER NOT NULL, "text" TEXT, ' ..
                            '"plotx" INTEGER, "ploty" INTEGER, ' ..
                            '"worldx" REAL, "worldy" REAL, "worldz" REAL' ..
                           ')'
local modDbSelect = "SELECT id, type, text, plotx, ploty, worldx, worldy, worldz FROM MapPins WHERE player=%i"
local modDbInsert = "INSERT INTO MapPins(player, type, text, plotx, ploty, worldx, worldy, worldz) VALUES(%i, %i, %s, %i, %i, %f, %f, %f)"
local modDbUpdate = "UPDATE MapPins SET type=%i, text=%s, plotx=%i, ploty=%i, worldx=%f, worldy=%f, worldz=%f WHERE id=%i"
local modDbDelete = "DELETE FROM MapPins WHERE id=%i"

-- Initialise the database sub-system
function DbmOpen(sStmt)
  dprint("DbmOpen(%s)", sStmt)
  local bInit = true
  if (modDb == nil) then
    modDb = Modding.OpenSaveData()

    if (sStmt ~= nil) then
      bInit = DbmExec(sStmt)
    end
  end

  return (bInit and (modDb ~= nil))
end

-- Close the database sub-system
function DbmClose()
  dprint("DbmClose()")
  modDb = nil

  return true
end

-- Execute a SQL statement
function DbmExec(sStmt)
  dprint("DbmExec(%s)", sStmt)
  local rows = DbmRows(sStmt)

  if (rows ~= nil) then
    for _ in rows do end

    return true
  end

  return false
end

-- Execute an SQL query
function DbmRows(sQuery)
  dprint("DbmRows(%s)", sQuery)
  if (modDb ~= nil and sQuery ~= nil) then
    return modDb.Query(sQuery)
  end

  return nil
end

-- Get the last auto-inc used
function DbmAutoId(sTable)
  for row in DbmRows(string.format("SELECT seq FROM sqlite_sequence WHERE name='%s'", sTable)) do
    return row.seq
  end
end

function DbmQuote(sText)
  string.gsub(sText, "'", "''")

  return "'" .. sText .. "'"
end


function SetToggle(sSwitch, bValue)
  local sKey = modId .. "_" .. sSwitch
  local iValue = 0
  if (bValue) then iValue = 1 end

  modDb.SetValue(sKey, iValue)
end

function IsToggle(sSwitch)
  local sKey = modId .. "_" .. sSwitch
  local value = modDb.GetValue(sKey)

  return (value ~= nil and value == 1)
end


function LoadPins()
  dprint("LoadPins()")
  m_Pins = {}

  for row in DbmRows(string.format(modDbSelect, m_ActivePlayer)) do
    local iPin = AddPin(Map.GetPlot(row.plotx, row.ploty), row.text, row.type, {x=row.worldx, y=row.worldy, z=row.worldz}, false)
    if (iPin ~= nil) then
      m_Pins[iPin].id = row.id
    end
  end

  LuaEvents.MapPins_ListDirty()
end

function SavePin(iPin)
  if (iPin ~= nil) then
    dprint("SavePin(%i)", iPin)
    local pin = m_Pins[iPin]
    if (pin ~= nil and pin ~= 0) then
      if (pin.id == nil) then
        dprint("Add pin %i to the DB", iPin)
        DbmExec(string.format(modDbInsert, m_ActivePlayer, pin.type, DbmQuote(pin.text), pin.plot.x, pin.plot.y, pin.world.x, pin.world.y, pin.world.z))

        pin.id = DbmAutoId(modDbTable)
        dprint("  id is %i", pin.id)
      else
        dprint("Update pin %i in the DB", iPin)
        DbmExec(string.format(modDbUpdate, pin.type, DbmQuote(pin.text), pin.plot.x, pin.plot.y, pin.world.x, pin.world.y, pin.world.z, pin.id))
      end
    else
      dprint("ERROR: SavePin(%i) is nil", iPin)
    end
  else
    dprint("ERROR: SavePin() called with nil")
  end

  LuaEvents.MapPins_ListDirty()
end

function RemovePin(iPin)
  if (iPin ~= nil) then
    dprint("RemovePin(%i)", iPin)
    local pin = m_Pins[iPin]
    if (pin ~= nil and pin ~= 0) then
      if (pin.id ~= nil) then
        dprint("Remove pin %i from the DB", iPin)
        DbmExec(string.format(modDbDelete, iPin))
      end
    else
      dprint("ERROR: RemovePin(%i) is nil", iPin)
    end
  else
    dprint("ERROR: RemovePin() called with nil")
  end

  m_Pins[iPin] = 0
  LuaEvents.MapPins_ListDirty()
end


--
-- Pin create functions
--

function IsPinMode()
  return ("pin" == m_ActiveMode)
end

function AddPinViaLuaEvent(response, pPlot, sText, iType)
  response.pinID = AddPin(pPlot, sText, iType, nil, true)
end

function AddPin(pPlot, sText, iType, world, bSave)
  if (pPlot ~= nil) then
    dprint("X marks the plot (%i, %i)", pPlot:GetX(), pPlot:GetY())

    if (world == nil) then
      world = GetWorldPos(pPlot)
    end
    dprint("X marks the spot (%i, %i, %i)", world.x, world.y, world.z)

    if (sText == nil) then
      sText = ""
    end

    if (iType == nil) then
      iType = m_ActiveType
    end

    local pin = {}
    local instance = g_PinManager:GetInstance()
    if (instance ~= nil) then
      table.insert(m_Pins, pin)
      local iPin = #m_Pins

      pin.instance = instance

      pin.plot = {x=pPlot:GetX(), y=pPlot:GetY()}
      pin.world = world
      PlaceInWorld(pin.instance.Anchor, world)

      pin.instance.Text:SetVoid1(iPin)
      -- Enabling left click edit makes it hard to click on a tile that has a pin
      -- pin.instance.Text:RegisterCallback(Mouse.eLClick, OnPinLeftClick)
      pin.instance.Text:RegisterCallback(Mouse.eRClick, OnPinRightClick)

      EditPin(iPin, sText, iType, true)

      if bSave then
        SavePin(iPin)
      end

      return iPin
    else
      dprint("ERROR: AddPin(), instance is nil")
    end
  else
    dprint("ERROR: AddPin() called with nil plot")
  end

  return nil
end


--
-- Pin retrieval functions
--

function GetPins(pins)
  dprint("GetPins()")
  if (pins == nil) then
    pins = {}
  end

  for iPin, pin in ipairs(m_Pins) do
    if (pin ~= nil and pin ~= 0) then
      -- Do NOT insert pin, a copy MUST be made!
      table.insert(pins, {id=iPin, type=pin.type, flag=GetFlag(pin.type), text=pin.text, plot={x=pin.plot.x, y=pin.plot.y}})
    end
  end

  dprint("GetPins() found %i pins", #pins)
  return pins
end


--
-- Pin context menu functions
--

function IsContextMenuMode()
  return ("menu" == m_ActiveMode)
end

function ShowPinContextMenu(iPin)
  if (iPin ~= nil) then
    dprint("ShowPinContextMenu(%i)", iPin)
    local pin = m_Pins[iPin]
    if (pin ~= nil and pin ~= 0) then
      m_ActiveMode = "menu"
      m_ActivePinID = iPin

      SetPinCursor()
	    PlaceInWorld(Controls.PinContextMenuAnchor, pin.world)
      Controls.PinContextMenu:SetHide(false)
    else
      dprint("ERROR! pin %i is nil", iPin)
    end
  else
    dprint("ERROR! ShowPinContextMenu called with nil iPin")
  end
end

function HidePinContextMenu()
  local iPin = m_ActivePinID

  m_ActiveMode = (not Controls.PinView:IsHidden()) and "pin" or nil
  m_ActivePinID = nil

  SetPinCursor()
  Controls.PinContextMenu:SetHide(true)

  return iPin
end

function OnEditPin()
  ShowEditPinPopup(HidePinContextMenu())
end
Controls.PinContextMenuEdit:RegisterCallback(Mouse.eLClick, OnEditPin)

function OnMovePin()
  SetMoveMode(HidePinContextMenu())
end
Controls.PinContextMenuMove:RegisterCallback(Mouse.eLClick, OnMovePin)

function OnDeletePin()
  ShowConfirmDeletePinPopup(HidePinContextMenu())
end
Controls.PinContextMenuDelete:RegisterCallback(Mouse.eLClick, OnDeletePin)


--
-- Pin edit functions
--

function IsEditMode()
  return ("edit" == m_ActiveMode)
end

function ShowEditPinPopup(iPin)
  if (iPin ~= nil) then
    dprint("ShowEditPinPopup(%i)", iPin)
    local pin = m_Pins[iPin]
    if (pin ~= nil and pin ~= 0) then
      m_ActiveMode = "edit"
      m_ActivePinID = iPin

      Controls.EditPinText:TakeFocus()
      Controls.EditPinText:LocalizeAndSetText(pin.text)
      m_ActiveType = pin.type
      g_FlagTypes[m_ActiveType].instance.EditPinType:SetCheck(true)

      IconHookup(23, 80, "CIV_COLOR_ATLAS", Controls.EditPinPopupIcon) -- Question mark icon
      SetPinCursor()
      Controls.EditPinPopup:SetHide(false)
    else
      dprint("ERROR! pin %i is nil", iPin)
    end
  else
    dprint("ERROR! ShowEditPinPopup called with nil iPin")
  end
end

function HideEditPinPopup()
  local iPin = m_ActivePinID

  m_ActiveMode = (not Controls.PinView:IsHidden()) and "pin" or nil
  m_ActivePinID = nil

  SetPinCursor()
  Controls.EditPinPopup:SetHide(true)

  return iPin
end

function OnEditOk()
  EditPin(HideEditPinPopup(), Controls.EditPinText:GetText(), m_ActiveType)

  if IsPinMode() then
    Hide()
  end
end
Controls.EditPinPopupOk:RegisterCallback(Mouse.eLClick, OnEditOk)

function OnValidatePinText(sText, control, bFire)
  local bValid = ValidateText(sText)
  Controls.EditPinPopupOk:SetDisabled(not bValid)
end
Controls.EditPinText:RegisterCallback(OnValidatePinText)

function OnEditPinTypeChanged(iType)
  m_ActiveType = iType
end
-- Callback registration is in Init()

function EditPin(iPin, sText, iType, bNoSave)
  if (iPin ~= nil) then
    dprint("EditPin(%i, %s, %i)", iPin, (sText or "nil"), (iType or 0))
    local pin = m_Pins[iPin]
    if (pin ~= nil and pin ~= 0) then
      if (sText ~= nil) then
        pin.text = sText
        pin.instance.Text:SetToolTipString(Locale.ConvertTextKey(sText))
      end

      if (iType ~= nil) then
        pin.type = iType
        pin.instance.Text:SetText(GetFlag(iType))
      end

      if not bNoSave then
        SavePin(iPin)
      end
    else
      dprint("ERROR! pin %i is nil", iPin)
    end
  else
    dprint("ERROR! EditPin called with nil iPin")
  end
end


--
-- Pin move functions
--

function IsMoveMode()
  return ("move" == m_ActiveMode)
end

function SetMoveMode(iPin)
  if (iPin ~= nil) then
    dprint("SetMoveMode(%i)", iPin)
    m_ActiveMode = "move"
    m_ActivePinID = iPin

    SetPinCursor()
  else
    dprint("ERROR! SetMoveMode called with nil iPin")
  end
end

function ClearMoveMode()
  local iPin = m_ActivePinID

  m_ActiveMode = (not Controls.PinView:IsHidden()) and "pin" or nil
  m_ActivePinID = nil

  SetPinCursor()

  return iPin
end

function OnMoveYes()
  local pPlot = GetMousePlot()
  MovePin(ClearMoveMode(), pPlot, GetWorldPos(pPlot))
end

function OnMoveNo()
  ClearMoveMode()
end

function MovePin(iPin, pPlot, world)
  if (iPin ~= nil) then
    dprint("MovePin(%i)", iPin)
    local pin = m_Pins[iPin]
    if (pin ~= nil and pin ~= 0) then
      pin.plot = {x=pPlot:GetX(), y=pPlot:GetY()}
      pin.world = world
	    PlaceInWorld(pin.instance.Anchor, world)

      SavePin(iPin)
    else
      dprint("ERROR! pin %i is nil", iPin)
    end
  else
    dprint("ERROR! MovePin called with nil iPin")
  end
end


--
-- Pin delete functions
--

function IsDeleteMode()
  return ("delete" == m_ActiveMode)
end

function ShowConfirmDeletePinPopup(iPin)
  if (iPin ~= nil) then
    dprint("ShowConfirmDeletePinPopup(%i)", iPin)
    local pin = m_Pins[iPin]
    if (pin ~= nil and pin ~= 0) then
      m_ActiveMode = "delete"
      m_ActivePinID = iPin

      Controls.DeletePinText:SetText(string.format("%s %s", GetFlag(pin.type), Locale.ConvertTextKey(pin.text)))

      SetPinCursor()
      Controls.DeletePinPopup:SetHide(false)
    else
      dprint("ERROR! pin %i is nil", iPin)
    end
  else
    dprint("ERROR! ShowConfirmDeletePinPopup called with nil iPin")
  end
end

function HideConfirmDeletePinPopup()
  local iPin = m_ActivePinID

  m_ActiveMode = (not Controls.PinView:IsHidden()) and "pin" or nil
  m_ActivePinID = nil

  SetPinCursor()
  Controls.DeletePinPopup:SetHide(true)

  return iPin
end

function OnDeleteYes()
  DeletePin(HideConfirmDeletePinPopup())
end
Controls.DeletePinPopupYes:RegisterCallback(Mouse.eLClick, OnDeleteYes)

function OnDeleteNo()
  HideConfirmDeletePinPopup()
end
Controls.DeletePinPopupNo:RegisterCallback(Mouse.eLClick, OnDeleteNo)

function DeletePin(iPin)
  if (iPin ~= nil) then
    dprint("DeletePin(%i)", iPin)
    local pin = m_Pins[iPin]
    RemovePin(iPin)

    if (pin ~= nil and pin ~= 0) then
      g_PinManager:ReleaseInstance(pin.instance)
    end
  else
    dprint("ERROR! DeletePin called with nil iPin")
  end
end


--
-- Helper functions
--

function GetPlayerState(iPlayer)
  local playerState = g_PlayerState[iPlayer]

  if (playerState == nil) then
    playerState = {}
	g_PlayerState[iPlayer] = playerState

	playerState.type = 3
	playerState.flagsVisible = IsToggle(string.format(g_OptionFlagsVisible, iPlayer))
  end

  return playerState
end

function GetMousePlot()
  local iMouseX, iMouseY = UI.GetMouseOverHex()

  return Map.GetPlot(iMouseX, iMouseY)
end

function GetWorldPos(pPlot)
  return HexToWorld(ToHexFromGrid({x=pPlot:GetX(), y=pPlot:GetY()}))
end

function PlaceInWorld(control, world)
  dprint("PlaceInWorld: %f, %f, %f", world.x, world.y, world.z)
  control:SetWorldPosition(VecAdd(world, g_WorldOffset))
end

-- Modified from SetCityName
function ValidateText(text)
  local invalidCharArray = { '\"', '<', '>', '|', '\b', '\0', '\t', '\n', '/', '\\', '*', '?', '%[', ']' }

  for i = 1, #text, 1 do
    if string.byte(text, i) < 32 then
      -- don't allow control characters
      return false
    elseif string.byte(text, i) == 37 then
      -- don't allow % character
      return false
    end
  end
    
  for i, ch in ipairs(invalidCharArray) do
    if string.find(text, ch) ~= nil then
      return false
    end
  end
    
  return true
end

function GetFlag(iType)
  if (iType < 1 or iType > #g_FlagTypes) then
    return Locale.ConvertTextKey("TXT_KEY_MAPPINS_FLAG_UNKNOWN")
  end

  return Locale.ConvertTextKey(g_FlagTypes[iType].icon)
end


--
-- Pin event functions
--

function OnPinLeftClick(iPin)
  dprint("OnPinLeftClick(%i)", iPin)
  EditPin(iPin)
end

function OnPinRightClick(iPin)
  dprint("OnPinRightClick(%i)", iPin)
  ShowPinContextMenu(iPin)
end


--
-- Pin board functions
--

function SetPinCursor()
  if IsPinMode() then
    UIManager:SetUICursor(GameInfoTypes["CURSOR_PING"])
  elseif IsMoveMode() then
    UIManager:SetUICursor(GameInfoTypes["CURSOR_MOVE"])
  else
    UIManager:SetUICursor(0)
  end
end

function OnPinBoardClick()
  if IsMoveMode() then
    OnMoveYes()
  else
    local iPin = AddPin(GetMousePlot())
    if (iPin ~= nil) then
      ShowEditPinPopup(iPin)
    end
  end
end
Controls.PinBoard:RegisterCallback(Mouse.eLClick, OnPinBoardClick)

function InputHandler(uiMsg, wParam, lParam)
  if (uiMsg == KeyEvents.KeyDown) then
    if IsContextMenuMode() then
      if (wParam == Keys.VK_ESCAPE) then
        HidePinContextMenu()
      end

      return true
    elseif IsEditMode() then
      if (wParam == Keys.VK_RETURN) then
        OnEditOk()
      end

      return true
    elseif IsMoveMode() then
      if (wParam == Keys.VK_ESCAPE) then
        OnMoveNo()
      elseif (wParam == Keys.VK_RETURN) then
        OnMoveYes()
      end

      return true
    elseif IsDeleteMode() then
      if (wParam == Keys.VK_ESCAPE) then
        OnDeleteNo()
      elseif (wParam == Keys.VK_RETURN) then
        OnDeleteYes()
      end

      return true
    elseif IsPinMode() then
      if ((wParam == Keys.VK_ESCAPE) or (wParam == Keys.X and UIManager:GetControl())) then
        Hide()
      end

      return true
    elseif (wParam == Keys.X) then
      if (UIManager:GetControl()) then
		    print("Control-X detected, activating the pin-board")
		    LuaEvents.MapPins_Show()
		    return true;
      elseif (UIManager:GetShift()) then
		    print("Shift-X detected, toggling pin visibility")
		    LuaEvents.MapPins_Toggle()
		    return true;
      end
    end
	end
end
ContextPtr:SetInputHandler(InputHandler)

function SendVisibility()
  LuaEvents.MapPins_Visibility(not Controls.PinContainer:IsHidden())
end

function Toggle()
  Controls.PinContainer:SetHide(not Controls.PinContainer:IsHidden())
  SetToggle(string.format(g_OptionFlagsVisible, m_ActivePlayer), not Controls.PinContainer:IsHidden())
  SendVisibility()
end

function Show()
  m_ActiveMode = "pin"
  Controls.PinView:SetHide(false)
  if Controls.PinContainer:IsHidden() then Toggle() end
  SetPinCursor()
end

function Hide()
  m_ActiveMode = nil
  Controls.PinView:SetHide(true)
  SetPinCursor()
end

function OnMinimapAreaClick(_, _, _, x, y)
  Events.MinimapClickedEvent(x, y)
end
Controls.MinimapArea:RegisterCallback(Mouse.eLClick, OnMinimapAreaClick)

function OnActivePlayerChanged(iPlayer, iPrevPlayer)
  g_PinManager:ResetInstances()

  local prevPlayerState = GetPlayerState(iPrevPlayer)
  local playerState = GetPlayerState(iPlayer)

  prevPlayerState.flagsVisible = not Controls.PinContainer:IsHidden()
  Controls.PinContainer:SetHide(not playerState.flagsVisible)

  prevPlayerState.type = m_ActiveType
  m_ActiveType = playerState.type

  m_ActivePinID = nil
  m_ActiveMode = nil

  m_ActivePlayer = iPlayer
  m_Pins = playerState.pins

  if (m_Pins == nil) then
    LoadPins()
	  playerState.pins = m_Pins
  end
end
Events.GameplaySetActivePlayer.Add(OnActivePlayerChanged)


--
-- Hide/Show the pin board when pop-ups, the City View, etc are active
--

local bFlagsHiddenInWorldView

function OnModalEnter()
  bFlagsHiddenInWorldView = Controls.PinContainer:IsHidden()
  Controls.PinContainer:SetHide(true)
end
Events.SerialEventEnterCityScreen.Add(OnModalEnter)
-- Events.SerialEventGameMessagePopup.Add(OnModalEnter)

function OnModalExit()
  Controls.PinContainer:SetHide(bFlagsHiddenInWorldView)
end
Events.SerialEventExitCityScreen.Add(OnModalExit)
-- Events.SerialEventGameMessagePopupShown.Add(OnModalExit)
-- Events.SerialEventGameMessagePopupProcessed.Add(OnModalExit)


function Init()
  DbmOpen(modDbCreate)

  -- Register all the edit popup radio-buttons
  local stack = Controls.EditPinFlagsStack1
  for i=1, #g_FlagTypes, 1 do
    local instance = {}
    ContextPtr:BuildInstanceForControl("Flag", instance, stack)
    g_FlagTypes[i].instance = instance

    instance.EditPinType:SetVoid1(i)
    instance.EditPinType:RegisterCallback(Mouse.eLClick, OnEditPinTypeChanged)

	  -- AMAZING! You can't set the text on a radio button!!! (So we have to have an inner label)
    instance.EditPinFlag:SetText(GetFlag(i))

    if (i == math.ceil(#g_FlagTypes/2)) then
      stack = Controls.EditPinFlagsStack2
    end
  end

  -- Adjust the stacks to fit now they have content
  Controls.EditPinFlagsStack1:CalculateSize()
  Controls.EditPinFlagsStack1:ReprocessAnchoring()
  Controls.EditPinFlagsStack2:CalculateSize()
  Controls.EditPinFlagsStack2:ReprocessAnchoring()

  -- Register the WorldView Lua events
  LuaEvents.MapPins_Show.Add(Show)
  LuaEvents.MapPins_Toggle.Add(Toggle)
  LuaEvents.MapPins_SendVisibility.Add(SendVisibility)

  -- Register the API Lua events (some used by InfoCorner MapPinsList)
  LuaEvents.MapPins_Get.Add(GetPins)
  LuaEvents.MapPins_Add.Add(AddPinViaLuaEvent)
  LuaEvents.MapPins_Edit.Add(EditPin)
  LuaEvents.MapPins_PopupEdit.Add(ShowEditPinPopup)
  LuaEvents.MapPins_Move.Add(MovePin)
  LuaEvents.MapPins_Delete.Add(DeletePin)
  LuaEvents.MapPins_PopupDelete.Add(ShowConfirmDeletePinPopup)

  -- Hide the pinboard and load any saved pins
  Hide()
  Controls.PinContainer:SetHide(not IsToggle(string.format(g_OptionFlagsVisible, 0)))
end

Init()

print(string.format("%3s ms loading MapPins.lua", Game.Round((os.clock() - startClockTime)*1000)))