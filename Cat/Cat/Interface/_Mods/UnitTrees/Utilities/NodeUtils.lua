--
-- Node utility classes
--

--
-- NodeFactory class - makes and hands out Nodes
--
NodeFactory = {
  m_nodes = {},

  Reset = function(self)
    for _, node in ipairs(self.m_nodes) do
      node._destroy()
    end

    self.m_nodes = {}
  end,

  GetNode = function(self, parentNode, unitType)
    local node = Node:_new(parentNode, unitType)

    table.insert(self.m_nodes, node)

    return node
  end,

  GetNodes = function(self)
    local i = 0

    return function()
      i = i + 1

      return ((i > #self.m_nodes) and nil or self.m_nodes[i])
    end
  end,
}


--
-- Node class - wraps up useful operations on a "node" in the upgrade tree
--
Node = {
  m_parentNode = nil,
  -- m_childNodes = {},
  m_hasChildren = false,

  m_unit = nil,
  m_tech = nil,
  m_gridX = 0,
  m_gridY = 0,

  _new = function(self, parentNode, unitType)
    local me = {}
    setmetatable(me, self)
    self.__index = self

    me.m_parentNode = parentNode
    -- me.m_childNodes = {}
    me.m_hasChildren = false

    me.m_unit = GameInfo.Units[unitType]
    me.m_tech = (me.m_unit.PrereqTech ~= nil) and GameInfo.Technologies[me.m_unit.PrereqTech] or nil
    me.m_gridX = (me.m_tech ~= nil) and me.m_tech.GridX or 0
    me.m_gridY = 0

    if (parentNode ~= nil) then
      parentNode:AddChild(me)
    end

    return me
  end,

  _destroy = function(self)
    -- self.m_childNodes = {}
  end,

  GetUnit = function(self)
    return self.m_unit
  end,

  GetTech = function(self)
    return self.m_tech
  end,

  GetEra = function(self)
    return GameInfo.Eras[(self.m_tech ~= nil) and self.m_tech.Era or 0]
  end,

  HasParent = function(self)
    return (self.m_parentNode ~= nil)
  end,

  GetParent = function(self)
    return self.m_parentNode
  end,

  AddChild = function(self, child)
    -- table.insert(self.m_childNodes, child)
    self.m_hasChildren = true
  end,

  HasChildren = function(self)
    -- return (#self.m_childNodes ~= 0)
    return self.m_hasChildren
  end,

  -- GetChildren = function(self)
  --   return self.m_childNodes
  -- end,

  GetGridX = function(self)
    return self.m_gridX
  end,

  SetGridX = function(self, iGridX)
    self.m_gridX = iGridX
  end,

  GetGridY = function(self)
    return self.m_gridY
  end,

  SetGridY = function(self, iGridY)
    self.m_gridY = iGridY
  end,
}
