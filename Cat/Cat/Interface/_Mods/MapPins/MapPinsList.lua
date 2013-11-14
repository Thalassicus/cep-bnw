include("IconSupport")
include("InstanceManager")
include("SupportFunctions")

local m_pins
local m_PinIM = InstanceManager:new("PinInstance", "Root", Controls.PinStack)

local eType = 0
local eText = 1
local m_sortTable
local m_SortMode = eType
local m_bSortReverse = false


function ShowHideHandler(bIsHide, bIsInit)
  if (not bIsHide) then
    LuaEvents.MapPins_SendVisibility()
    UpdateDisplay()
  end
end
ContextPtr:SetShowHideHandler(ShowHideHandler)

function OnClose()
  ContextPtr:SetHide(true)
  Events.OpenInfoCorner(InfoCornerID.None)
end
Controls.CloseButton:RegisterCallback(Mouse.eLClick, OnClose)

function InputHandler(uiMsg, wParam, lParam)
  if uiMsg == KeyEvents.KeyDown then
    if wParam == Keys.VK_ESCAPE then
      OnClose()
      return true
    end
  end
end
ContextPtr:SetInputHandler(InputHandler)

function OnChangeEvent()
  if (ContextPtr:IsHidden() == false) then
    UpdateDisplay()
  end
end
LuaEvents.MapPins_ListDirty.Add(OnChangeEvent)


function UpdateDisplay()
  m_PinIM:ResetInstances()
  m_SortTable = {}

  m_pins = {}
  LuaEvents.MapPins_Get(m_pins)

  for id, pin in ipairs(m_pins) do
    pin.id = id

    local p = m_PinIM:GetInstance()
    p.Type:SetText(pin.flag)
    p.Text:LocalizeAndSetText(pin.text)

    p.Button:SetVoid1(id)
    p.Button:RegisterCallback(Mouse.eLClick, OnPlotClick)
    p.Button:RegisterCallback(Mouse.eRClick, OnPinClick)

    m_SortTable[tostring(p.Root)] = pin
  end

  Controls.PinStack:SortChildren(SortFunction)
  Controls.PinStack:CalculateSize()
  Controls.PinStack:ReprocessAnchoring()

  Controls.ScrollPanel:CalculateInternalSize()
  Controls.ScrollPanel:ReprocessAnchoring()
end


function SortFunction(a, b)
  local valueA, valueB
  local entryA = m_SortTable[tostring(a)]
  local entryB = m_SortTable[tostring(b)]
  
  if (entryA == nil) or (entryB == nil) then 
    if entryA and (entryB == nil) then
      return false
    elseif (entryA == nil) and entryB then
      return true
    else
      if (m_bSortReverse) then
        return tostring(a) > tostring(b) -- gotta do something deterministic
      else
        return tostring(a) < tostring(b) -- gotta do something deterministic
      end
    end
  else
    if (m_SortMode == eType) then
      valueA = entryA.type
      valueB = entryB.type
    elseif (m_SortMode == eText) then
      valueA = entryA.text
      valueB = entryB.text
    end
    
    if (valueA == valueB) then
      valueA = entryA.id
      valueB = entryB.id
    end
    
    if (m_bSortReverse) then
      return valueA > valueB
    else
      return valueA < valueB
    end
  end
end

function OnSort(type)
  if (m_SortMode == type) then
    m_bSortReverse = not m_bSortReverse
  else
    m_bSortReverse = false
  end

  m_SortMode = type
  Controls.PinStack:SortChildren(SortFunction)
end
Controls.SortType:RegisterCallback(Mouse.eLClick, OnSort)
Controls.SortType:SetVoid1(eType)
Controls.SortText:RegisterCallback(Mouse.eLClick, OnSort)
Controls.SortText:SetVoid1(eText)


function OnOpenInfoCorner(iInfoType)
  if (iInfoType == InfoCornerID.MapPins) then
    ContextPtr:SetHide(false)
  else
    ContextPtr:SetHide(true)
  end
end
Events.OpenInfoCorner.Add(OnOpenInfoCorner)

function OnPlotClick(i)
  local plot = Map.GetPlot(m_pins[i].plot.x, m_pins[i].plot.y)
  if (plot ~= nil) then
    UI.LookAt(plot)
  end
end

function OnPinClick(i)
  if UIManager:GetShift() then
    LuaEvents.MapPins_Delete(m_pins[i].id)
  else
    LuaEvents.MapPins_PopupEdit(m_pins[i].id)
  end
end


function OnVisibilityChange(bIsVisible)
  if (bIsVisible ~= Controls.TogglePins:IsChecked()) then
    Controls.TogglePins:SetCheck(bIsVisible)
  end
end
LuaEvents.MapPins_Visibility.Add(OnVisibilityChange)

function OnToggle(bIsChecked)
  LuaEvents.MapPins_Toggle()
end
Controls.TogglePins:RegisterCallback(Mouse.eLClick, OnToggle)
