--
-- Group Manager functions
--

local m_sBaseInstanceName = nil
local m_sRootControl = nil
local m_parentControl = nil
local iGroupHeight, iDividerHeight, iBlockHeight

function GroupManagerInit(iHeight, iMargin, sInstanceNames, sBaseInstanceName, sRootControl, parentControl)
  dprint("GroupManagerInit(%s)", sBaseInstanceName)

  m_sBaseInstanceName = sBaseInstanceName
  m_sRootControl = sRootControl
  m_parentControl = parentControl

  iGroupHeight = iHeight + 2 * iMargin
  iDividerHeight = iHeight
  iBlockHeight = iHeight + iMargin
end

function GroupManagerReset()
  dprint("GroupManagerReset()")

  if (m_parentControl ~= nil) then
    m_parentControl:DestroyAllChildren()
  end
end

function GroupManagerGetGroup(sInstanceName, iWidth, sText)
  local group = {};
  ContextPtr:BuildInstanceForControl(m_sBaseInstanceName .. sInstanceName, group, m_parentControl)
  group[m_sRootControl]:SetHide(false)

  group.Label:SetText(Locale.ConvertTextKey(sText))

  SetWidth(group.Group, iWidth)
  SetHeight(group.Group, iGroupHeight)

  SetWidth(group.Bar, iWidth)

  SetHeight(group.Divider, iDividerHeight)

  if (group.Block ~= nil) then 
    SetHeight(group.Block, iBlockHeight)
    SetWidth(group.Block, iWidth)
  end

  return group
end
