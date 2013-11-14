--
-- To display the Upgrade Tree call either
--   LuaEvents.UpgradeTreeDisplay(iUnit)
-- to display the tree for a specific unit, or
--   LuaEvents.UpgradeTreeDisplay()
-- to display the tree with the Combat Class drop-down menu
--
-- For example, for a button on the UnitPanel screen
--   function OnUpgradeTreeButton(iUnit)
--     LuaEvents.UpgradeTreeDisplay(iUnit)
--   end
--   Controls.UpgradeTreeButton:SetVoid1(UI.GetHeadSelectedUnit():GetID())
--   Controls.UpgradeTreeButton:RegisterCallback(Mouse.eLClick, OnUpgradeTreeButton)
--
-- For example, for a tab in the Additional Information list
--   function OnUpgradeTreeView()
--     LuaEvents.UpgradeTreeDisplay()
--   end
--   instance.Tab:RegisterCallback(Mouse.eLClick, OnUpgradeTreeView)
--

include("IconSupport")
include("InstanceManager")
include("InfoTooltipInclude")

bDebug = false

include("DebugPrint")
include("ControlUtils")
include("GroupManager")
include("ButtonManager")
include("PipeManager")
include("UpgradeUtils")
include("NodeUtils")

local config = {
  normal = {NAME="Normal", PANEL=740, GAP=20, PIPE=32, BUTTON="ButtonInstance"},
  small  = {NAME="Small",  PANEL=680, GAP=20, PIPE=16, BUTTON="ButtonInstanceSmall"}
}

-- These are set by Resize()
local iHeight = nil
local iGapY = nil
local iCentreLine = nil

local iLeftMargin = 20
local iTopMargin = 20

local iCloseButtonSixeX = 100
local iCloseButtonSixeY = 32
local iScrollBarMagicX = iLeftMargin + iCloseButtonSixeX + 43

local iDropDownSizeX = 230
local iDropDownSizeY = 60
local iDropDownIconSize = 32
local iDefaultCombatClass = 0

local iUnitBoxSizeX = 230
local iUnitBoxSizeY = 60
local iUnitIconSize = 64

-- These will be determined by the ButtonManager
local iButtonSizeX = nil
local iButtonSizeY = nil

-- These are set by Resize()
local iPipeSizeX = nil
local iPipeSizeY = nil


local iSelectedUnit = nil
local bTreeVisible = false


--
-- PlaceAbc(...) functions
--
-- Calculate locations of logical drawing elements in the tree
--

function PlaceDropDown()
  DrawUpgradeDropDown(iLeftMargin, iCentreLine - (iDropDownSizeY / 2), sDefaultCombatClass)

  OnSelectCombatClass(iDefaultCombatClass)
end

function PlaceUnit(pUnit)
  local iUnitBoxX = iLeftMargin
  local iUnitBoxY = iCentreLine - (iUnitBoxSizeY / 2)
  DrawUnitBox(iUnitBoxX, iUnitBoxY, pUnit)

  ButtonManagerReset()
  PipeManagerReset()

  GroupManagerReset()
  GroupManagerGetGroup("Black", iUnitBoxSizeX + iPipeSizeX/2, "TXT_KEY_UPGRADE_GROUP_UNIT")

  PlaceUpgrades(pUnit, iUnitBoxX + iUnitBoxSizeX, iCentreLine)

  AdjustPanelWidth()
end

function PlaceUpgrades(pUnit, iBaseX, iCentreLine)
  local sCivType = GameInfo.Civilizations[Players[pUnit:GetOwner()]:GetCivilizationType()].Type
  local sUnitClassType = GameInfo.UnitClasses[pUnit:GetUnitClassType()].Type

  local path = GetUpgradePath(sCivType, sUnitClassType)
  if (#path > 1) then
    local iButtonX = iBaseX + iPipeSizeX/2
    local iButtonY = iCentreLine - (iButtonSizeY/2)

    -- Connect the drop down to the first button
    PipeManagerDrawHorizontalPipe(iBaseX, iCentreLine - (iPipeSizeY/2), iPipeSizeX/2 + iPipeSizeX)

    NodeFactory:Reset()

	local rootNode = nil
    local parentNode = nil
    for i = #path, 2, -1 do
      parentNode = NodeFactory:GetNode(parentNode, path[i])
      parentNode:SetGridY(1)

	  if (rootNode == nil) then
	    rootNode = parentNode
	  end
    end

    local eras = LayoutColumns(rootNode:GetGridX())

    PlaceEras(eras)
    PlacePipes(iButtonX, iButtonY)
    PlaceButtons(iButtonX, iButtonY, pUnit)
  end
end

function PlaceUpgradeClass(sCivType, sUnitClass, parentNode)
  dprint("Place upgrade class %s%s", sUnitClass, (sCivType ~= nil) and string.format(" (for %s)", sCivType) or "")

  local node = NodeFactory:GetNode(parentNode, GetCivUnitType(sCivType, sUnitClass))

  for _, sUnitPriorClass in ipairs(GetPriorUnitClasses(sUnitClass)) do
    PlaceUpgradeClass(sCivType, sUnitPriorClass, node)
  end

  return node
end

function PlaceClass(sCivType, sCombatClass, iOffsetX, iCentreLine)
  dprint("Place class %s%s", sCombatClass, (sCivType ~= nil) and string.format(" (for %s)", sCivType) or "")

  NodeFactory:Reset()

  local finalNodes = {}
  local iGridY = 1

  for _, sUnitClass in ipairs(GetFinalUnitClasses(sCombatClass)) do
    table.insert(finalNodes, PlaceUpgradeClass(sCivType, sUnitClass, nil))
    iGridY = LayoutRows(iGridY)
  end

  local iMaxColumn = 0
  for _, finalNode in ipairs(finalNodes) do
    iMaxColumn = math.max(iMaxColumn, finalNode:GetGridX())
  end

  local iOffsetY = iCentreLine - ((((iGridY-1) * (iButtonSizeY + iGapY)) - iGapY) / 2)
  local eras = LayoutColumns(iMaxColumn)

  PlaceEras(eras)
  PlacePipes(iOffsetX, iOffsetY)
  PlaceButtons(iOffsetX, iOffsetY)
end

function PlaceEras(eras)
  local iStart = 1

  local i = 2
  while (eras[i] ~= nil) do
    if (eras[i] ~= eras[iStart]) then
      PlaceEra(eras[iStart], i - iStart)
      iStart = i
    end

    i = i + 1
  end

  PlaceEra(eras[iStart], i - iStart)
end

function PlaceEra(iEra, iColumns)
  if not era then return end	
  local era = GameInfo.Eras[iEra]
  dprint("Era: %s for %i columns", era.Type, iColumns)

  GroupManagerGetGroup("Blue", iColumns * (iButtonSizeX + (2 * iPipeSizeX)), era.Description)
end

function PlaceButtons(iOffsetX, iOffsetY, pUnit)
  for node in NodeFactory:GetNodes() do
    local unit = node:GetUnit()
    dprint("Unit: %s in row %i, column %i", unit.Type, node:GetGridY(), node:GetGridX())

    local iX = iOffsetX + iPipeSizeX + ((node:GetGridX() - 1) * (iButtonSizeX + (2 * iPipeSizeX)))
    local iY = iOffsetY + ((node:GetGridY() - 1) * (iButtonSizeY + iGapY))
    PlaceButton(iX, iY, unit, pUnit)
  end
end

function PlaceButton(iX, iY, unit, pUnit)
  local sName = Locale.ConvertTextKey(unit.Description)
  local button = ButtonManagerGetButton(iX, iY, sName, unit.IconAtlas, unit.PortraitIndex, unit.PrereqTech)
 
  SetMoves(button, unit, pUnit)
  SetCombat(button, unit, pUnit)
  SetResources(button, unit, pUnit)
  SetGold(button, unit, pUnit)

  if (pUnit ~= nil and CanUpgrade(pUnit, unit.Type)) then
    button.Available:SetHide(false)
    button.AvailableName:SetText(sName)
    button.MouseOverContainer:SetHide(false)
    button.Unavailable:SetHide(true)

    button.ReqTech:SetHide(true)

    button.Button:RegisterCallback(Mouse.eLClick, OnSelectUpgrade)
  elseif (pUnit ~= nil and Teams[Players[pUnit:GetOwner()]:GetTeam()]:IsHasTech(GameInfoTypes[unit.PrereqTech])) then
    button.Available:SetHide(false)
    button.AvailableName:SetText(sName)
    button.MouseOverContainer:SetHide(true)
    button.Unavailable:SetHide(true)

    button.ReqTech:SetHide(true)
  else
    button.Available:SetHide(true)
    button.Unavailable:SetHide(false)
    button.UnavailableName:SetText(sName)
  end
  button.Earnt:SetHide(true)
end

function PlacePipes(iOffsetX, iOffsetY)
  local horizontals = {}
  local quadrants = {}

  -- Draw all the vertical pipes first, so they pass under the horizontals
  for node in NodeFactory:GetNodes() do
    local parentNode = node:GetParent()
    local iGridY = node:GetGridY()

    local iX = iOffsetX + iPipeSizeX + ((node:GetGridX() - 1) * (iButtonSizeX + (2 * iPipeSizeX))) + iButtonSizeX
    local iY = iOffsetY + ((node:GetGridY() - 1) * (iButtonSizeY + iGapY)) + ((iButtonSizeY - iPipeSizeY) / 2)

    if node:HasParent() then
      if (iGridY == parentNode:GetGridY()) then
        dprint("Straight pipe in row %i, from column %i to %i", iGridY, node:GetGridX(), parentNode:GetGridX())
        local iLength = (((parentNode:GetGridX() - node:GetGridX()) - 1) * (iButtonSizeX + 2 * iPipeSizeX)) + (2 * iPipeSizeX)

        table.insert(horizontals, {x=iX, y=iY, l=iLength})
      else
        dprint("Bent pipe from row %i, column %i to row %i, column %i", iGridY, node:GetGridX(), parentNode:GetGridY(), parentNode:GetGridX())
        local iLength = (((parentNode:GetGridX() - node:GetGridX()) - 1) * (iButtonSizeX + 2 * iPipeSizeX)) + iPipeSizeX
        local iHeight = ((iGridY - parentNode:GetGridY()) * (iButtonSizeY + iGapY)) - iPipeSizeY

        table.insert(horizontals, {x=iX, y=iY, l=iLength})
        table.insert(quadrants, {x=iX+iLength, y=iY, t='bottom-right'})
        PipeManagerDrawVerticalPipe(iX+iLength, iY-iHeight, iHeight)
        table.insert(quadrants, {x=iX+iLength, y=iY-iHeight-iPipeSizeY, t='top-left'})
      end
    elseif (GetUpgradeUnitClassType(node:GetUnit().Type) ~= nil) then
      local iLength = math.floor(iPipeSizeY / 5)
        table.insert(horizontals, {x=iX, y=iY, l=iLength})
        table.insert(horizontals, {x=(iX + 2*iLength), y=iY, l=iLength})
        table.insert(horizontals, {x=(iX + 4*iLength), y=iY, l=iLength})
    end
  end

  -- Draw all the horizontal pipes next
  for _, h in ipairs(horizontals) do
    PipeManagerDrawHorizontalPipe(h.x, h.y, h.l)
  end

  -- Finally draw all the quadrants so as to get the nice curves on top of the plain pipes
  for _, q in ipairs(quadrants) do
    PipeManagerDrawQuadrantPipe(q.x, q.y, q.t)
  end
end


--
-- AdjustAbc(iSize) functions
--

function AdjustPanelHeight(iHeight)
  local iPanelHeight = iHeight + 2*iTopMargin
  local iScrollHeight = iPanelHeight - iTopMargin

  SetHeight(Controls.TreePanel, iPanelHeight)
  SetHeight(Controls.ScrollPanel, iScrollHeight)
  SetHeight(Controls.PipesPanel, iScrollHeight)
  SetHeight(Controls.ButtonsPanel, iScrollHeight)

  Controls.DropDownBox:SetOffset({x=iLeftMargin, y=(iCentreLine - iDropDownSizeY/2)})
  Controls.UnitBox:SetOffset({x=iLeftMargin, y=(iCentreLine - iUnitBoxSizeY/2)})

  -- It would appear that changing the height of the container doesn't move the bottom anchored controls
  -- so move them to (0,0) then move them back from whence they came!
  OffsetAgain(Controls.CloseButton)
  OffsetAgain(Controls.ResizeButton)

  Controls.ScrollPanel:CalculateInternalSize()
  SetWidth(Controls.ScrollBar, (Controls.ScrollPanel:GetSizeX() - iScrollBarMagicX))
end

function AdjustPanelWidth()
  Controls.GroupsStack:CalculateSize()
  Controls.GroupsStack:ReprocessAnchoring()
  SetWidth(Controls.PipesPanel, Controls.GroupsStack:GetSizeX())
  SetWidth(Controls.ButtonsPanel, Controls.GroupsStack:GetSizeX())
  Controls.ScrollPanel:CalculateInternalSize()
end


--
-- DrawXyz(iX, iY, ...) functions
--
-- Create instance components and configure them
--
-- Note: The colour parameter in the pipe drawing functions is intended only for debugging!
--

function DrawUpgradeDropDown(iX, iY)
  dprint("Place dropdown menu at (%i, %i)", iX, iY)

  Controls.DropDownBox:SetHide(false)
  Controls.UnitBox:SetHide(true)

  PopulateClassDropDown()
end

function DrawUnitBox(iX, iY, pUnit)
  dprint("Place unit box for %s at (%i, %i)", pUnit:GetName(), iX, iY)

  Controls.UnitBox:SetHide(false)
  Controls.DropDownBox:SetHide(true)

  Controls.UnitName:SetText(pUnit:GetName())
  SetMoves(Controls, GameInfo.Units[pUnit:GetUnitType()], pUnit)
  SetCombat(Controls, GameInfo.Units[pUnit:GetUnitType()], pUnit)

  local unit = GameInfo.Units[pUnit:GetUnitType()]
  Controls.UnitPortraitFrame:SetHide(IconHookup(unit.PortraitIndex, iUnitIconSize, unit.IconAtlas, Controls.UnitPortrait) ~= true)
end

function DrawUpgradeButton(iX, iY, sUnit)
  local unit = GameInfo.Units[sUnit]
  local sName = Locale.ConvertTextKey(unit.Description)
  dprint("Place %s at (%i, %i)", sName, iX, iY)

  local sToolTip = Locale.ConvertTextKey(unit.Help)

  local button = ButtonManagerGetButton(iX, iY, sToolTip, unit.IconAtlas, unit.PortraitIndex, unit.TechPrereq)

  button.EarntName:SetText(sName)
  button.Earnt:SetHide(false)
  button.Available:SetHide(true)
  button.Unavailable:SetHide(true)
end


--
-- Helper functions
--

function LayoutRows(iGridY)
  local startNodes = {}

  for node in NodeFactory:GetNodes() do
    if (node:GetGridY() == 0 and not node:HasChildren()) then
      table.insert(startNodes, node)
    end
  end

  table.sort(startNodes, ByGridX)

  for _, node in ipairs(startNodes) do
    while (node ~= nil and node:GetGridY() == 0) do
      node:SetGridY(iGridY)
      node = node:GetParent()
    end
  
    iGridY = iGridY + 1
  end

  return iGridY
end

function LayoutColumns(iMaxColumn)
  local eras = {}
  local columns = {}

  -- Set all column counts to 0
  for i = 0, iMaxColumn, 1 do
    columns[i] = 0
    eras[i] = nil
  end

  -- Count the number of nodes in each column
  for node in NodeFactory:GetNodes() do
    local iGridX = node:GetGridX()
    columns[iGridX] = columns[iGridX] + 1
  end

  -- Adjust the first column
  if (columns[0] ~= 0) then
    columns[0] = 1
  else
    columns[0] = 0
  end

  -- Find empty columns
  for i = 1, iMaxColumn, 1 do
    if (columns[i] == 0) then
      columns[i] = columns[i-1] - 1
    else
      columns[i] = columns[i-1]
    end
  end

  -- Finally adjust all the nodes, this removes empty columns in the grid
  for node in NodeFactory:GetNodes() do
    local iGridX = node:GetGridX()
    iGridX = iGridX + columns[iGridX]
    node:SetGridX(iGridX)

    -- Make a note of the era this column is in
    eras[iGridX] = node:GetEra().ID
  end

  return eras
end

function ByGridX(a, b)
  return a:GetGridX() < b:GetGridX()
end

function SetMoves(button, unit, pUnit)
  if IsImmobile(unit.Type) then
    -- Aircraft are immobile!
    button.Moves:SetHide(true)
  else
    local sMoves = Locale.ConvertTextKey("TXT_KEY_UPGRADE_UNIT_MOVES", unit.Moves)
    local sPrefix = " ("
    local sPostfix = ""
    if IsIgnoreTerrain(unit.Type) then
      sMoves = sMoves .. sPrefix .. Locale.ConvertTextKey("TXT_KEY_PROMOTION_IGNORE_TERRAIN_COST")
      sPrefix = ", "
      sPostfix = ")"
    end
    if IsFollowUp(unit.Type) then
      sMoves = sMoves .. sPrefix .. Locale.ConvertTextKey("TXT_KEY_PROMOTION_CAN_MOVE_AFTER_ATTACKING")
      sPrefix = ", "
      sPostfix = ")"
    end
    if IsRoughTerrain(unit.Type) then
      sMoves = sMoves .. sPrefix .. Locale.ConvertTextKey("TXT_KEY_PROMOTION_ROUGH_TERRAIN_ENDS")
      sPrefix = ", "
      sPostfix = ")"
    end
    button.Moves:SetToolTipString(sMoves .. sPostfix)
    button.Moves:SetHide(false)
  end
end

function SetCombat(button, unit, pUnit)
  if (unit.RangedCombat > 0) then
    local sRangedText = Locale.ConvertTextKey("TXT_KEY_UPGRADE_UNIT_RANGED", unit.RangedCombat, unit.Range)
      local sPrefix = " ("
    local sPostfix = ""
    if IsSetup(unit.Type) then
      sRangedText = sRangedText .. sPrefix .. Locale.ConvertTextKey("TXT_KEY_PROMOTION_MUST_SET_UP")
      sPrefix = ", "
      sPostfix = ")"
    end
    if IsIndirectFire(unit.Type) then
      sRangedText = sRangedText .. sPrefix .. Locale.ConvertTextKey("TXT_KEY_PROMOTION_INDIRECT_FIRE")
      sPrefix = ", "
      sPostfix = ")"
    end

     button.Ranged:SetToolTipString(sRangedText .. sPostfix)
    button.Ranged:SetHide(false)
    button.Combat:SetHide(true)
  else
    local sCombatText = Locale.ConvertTextKey("TXT_KEY_UPGRADE_UNIT_COMBAT", unit.Combat)

    button.Combat:SetToolTipString(sCombatText)
    button.Combat:SetHide(false)
    button.Ranged:SetHide(true)
  end
end

function SetResources(button, unit, pUnit)
  local sReqsText = GetRequirements(unit.Type, pUnit)
  if (sReqsText == "") then
    button.Needs:SetHide(true)
  else
    button.Needs:SetToolTipString(sReqsText)
    button.Needs:SetHide(false)
  end
end

function SetGold(button, unit, pUnit)
  if (pUnit ~= nil and pUnit:GetUpgradeUnitType() == unit.ID) then
    local sUpgradeText = Locale.ConvertTextKey("TXT_KEY_UPGRADE_UNIT_UPGRADE_COST", pUnit:UpgradePrice(unit.ID))
    button.Gold:SetToolTipString(sUpgradeText)
    button.Gold:SetHide(false)
  else
    button.Gold:SetHide(true)
  end
end


--
-- UI functions
--

g_ClassList = nil

function PopulateClassDropDown()
  if (g_ClassList == nil) then
    PopulateClassList()

    for iIndex = 1, #g_ClassList, 1 do
      local controlTable = {}
      Controls.ClassDropDown:BuildEntry("InstanceOne", controlTable)

      controlTable.Button:SetVoid1(iIndex)
      controlTable.Button:SetText(Locale.ConvertTextKey(g_ClassList[iIndex].TextKey))
    end
       
    Controls.ClassDropDown:GetButton():SetText(Locale.ConvertTextKey(g_ClassList[iDefaultCombatClass].TextKey))
    
    Controls.ClassDropDown:CalculateInternals()
    Controls.ClassDropDown:RegisterSelectionCallback(OnSelectCombatClass)
  end
end

function PopulateClassList()
  g_ClassList = {}

  local sQuery = "SELECT x.CombatClass, x.IsDefault, c.Description, x.DefaultUnitType FROM UnitCombatInfos c, UpgradeInfosEx x WHERE c.Type = x.CombatClass"
  for row in DB.Query(sQuery) do
    table.insert(g_ClassList, {CombatClass=row.CombatClass, TextKey=row.Description, UnitType=row.DefaultUnitType})

    if (iDefaultCombatClass < 1 and row.IsDefault == true) then
      iDefaultCombatClass = #g_ClassList
    end
  end
end


--
-- UI handlers
--

function ShowHideHandler(bIsHide, bIsInit)
  if (not bIsHide and not bIsInit) then
    if (iSelectedUnit == nil) then
      PlaceDropDown()
    else
      PlaceUnit(Players[Game.GetActivePlayer()]:GetUnitByID(iSelectedUnit))
    end
  end

  bTreeVisible = (bIsHide == false)
end
ContextPtr:SetShowHideHandler(ShowHideHandler)

function OnDisplay(iUnit)
  iSelectedUnit = iUnit
  dprint("OnDisplay(%i)", iSelectedUnit or 0)
  print("UpgradeTreeDisplay B")

  UIManager:QueuePopup(ContextPtr, PopupPriority.BarbarianCamp)
end
LuaEvents.UpgradeTreeDisplay.Add(OnDisplay)

function OnResize(bIsChecked)
  dprint("OnResize(%s)", (bIsChecked and "true" or "false"))

  if (bIsChecked) then
    Small()
  else
    Normal()
  end
end
Controls.ResizeButton:RegisterCheckHandler(OnResize)

function OnClose()
  Hide()
  UIManager:DequeuePopup(ContextPtr)
end
Controls.CloseButton:RegisterCallback(Mouse.eLClick, OnClose)
Events.GameplaySetActivePlayer.Add(OnClose)

function InputHandler(uiMsg, wParam, lParam)
  if (uiMsg == KeyEvents.KeyDown) then
    if (wParam == Keys.VK_ESCAPE or wParam == Keys.VK_RETURN) then
      OnClose()
      return true
    end
  end
end
ContextPtr:SetInputHandler(InputHandler)

function OnSelectCombatClass(iIndex)
  if (iIndex == nil or iIndex < 1 or iIndex > #g_ClassList) then 
    iIndex = iDefaultCombatClass or 1
  end

  iDefaultCombatClass = iIndex

  Controls.ClassDropDown:GetButton():SetText(Locale.ConvertTextKey(g_ClassList[iIndex].TextKey))

  local unit = GameInfo.Units[g_ClassList[iIndex].UnitType]
  Controls.ClassPortraitFrame:SetHide(IconHookup(unit.UnitFlagIconOffset, iDropDownIconSize, unit.UnitFlagAtlas, Controls.ClassPortrait) ~= true)

  PipeManagerReset()
  ButtonManagerReset()

  GroupManagerReset()
  GroupManagerGetGroup("Black", iDropDownSizeX + iPipeSizeX/2, "TXT_KEY_UPGRADE_GROUP_CLASS")

  PlaceClass(nil, g_ClassList[iIndex].CombatClass, iLeftMargin + iDropDownSizeX + iPipeSizeX/2, iCentreLine)

  AdjustPanelWidth()
end

function OnSelectUpgrade()
  local pUnit = UI.GetHeadSelectedUnit()
  dprint("Upgrade for %s", pUnit:GetName())

  Events.AudioPlay2DSound("AS2D_INTERFACE_UNIT_PROMOTION")
  Game.HandleAction(GetActionForUpgrade())

  OnClose()
end

function OnUnitInfoDirty()
  if (bTreeVisible) then
    local pUnit = UI.GetHeadSelectedUnit()

    if (pUnit and pUnit:GetID() == iSelectedUnit) then
      PlaceUnit(pUnit)
    end
  end
end
Events.SerialEventUnitInfoDirty.Add(OnUnitInfoDirty)

function Hide()
  dprint("Hide()")

  ContextPtr:SetHide(true)
end

function Show()
  dprint("Show()")

  ContextPtr:SetHide(false)
end

function Small()
  dprint("Small()")

  Resize(config.small)
  Show()
end

function Normal()
  dprint("Normal()")

  Resize(config.normal)
  Show()
end

function Resize(config)
  dprint("Resize to %s", config.NAME)

  if (iHeight ~= config.PANEL) then
    GroupManagerReset()
    ButtonManagerReset()
    PipeManagerReset()
  end

  iHeight = config.PANEL
  iGapY = config.GAP
  iCentreLine = iTopMargin + (iHeight / 2)
  AdjustPanelHeight(iHeight)

  GroupManagerInit(iHeight, iTopMargin, {"Black", "Blue", "Gold"}, "GroupInstance", "Group", Controls.GroupsStack)

  iButtonSizeX, iButtonSizeY = ButtonManagerInit(config.BUTTON, "Button", Controls.ButtonsPanel)

  iPipeSizeX = config.PIPE
  iPipeSizeY = iPipeSizeX
  PipeManagerInit(iPipeSizeY, "PipeInstance", "PipeBox", Controls.PipesPanel)
end

function Debug()
  bDebug = true
end

function NoDebug()
  bDebug = false
end

function Init()
  dprint("Init()")

  Resize(OptionsManager.GetSmallUIAssets() and config.small or config.normal)
  Controls.ResizeButton:SetCheck(OptionsManager.GetSmallUIAssets())
  Hide()
end

Init()


local bStandardInsert = true
LuaEvents.DiploCornerExtended.Add(function() bStandardInsert = false; end)

function OnDiploCornerPopup()
  OnDisplay()
end

function OnAdditionalInformationDropdownGatherEntries(additionalEntries)
  if (bStandardInsert) then
    table.insert(additionalEntries, {text=Locale.ConvertTextKey("TXT_KEY_UPGRADE_DIPLO_CORNER_HOOK"), call=OnDiploCornerPopup})
  end
end
LuaEvents.AdditionalInformationDropdownGatherEntries.Add(OnAdditionalInformationDropdownGatherEntries)
LuaEvents.RequestRefreshAdditionalInformationDropdownEntries()
