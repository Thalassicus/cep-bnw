include("FLuaVector")
include("InstanceManager")
include("YieldLibrary.lua")


-------------------------------------------------
-- Yield Icon Manager
-------------------------------------------------
local g_AnchorIM = InstanceManager:new("AnchorInstance", "Anchor", Controls.Scrap)
local g_ImageIM  = InstanceManager:new("ImageInstance",  "Image",  Controls.Scrap)

local g_VisibleSet = {}
local g_YieldCache = {}


local g_gridWidth, _ = Map.GetGridSize()
function IndexFromGrid(x, y)
    return x + (y * g_gridWidth)
end


-----------------------------------------------------------------------
-----------------------------------------------------------------------
function ShowHexYield(x, y, bShow)
    local index = IndexFromGrid(x, y)
    if (bShow) then
        DestroyYield(index)
        BuildYield(x, y, index)
    else
        DestroyYield(index)
    end 
end
Events.ShowHexYield.Add(ShowHexYield)


------------------------------------------------------------------
-- update the controls to reflect the current known yield 
------------------------------------------------------------------
function BuildYield(x, y, index)
    local plot = Map.GetPlot(x, y)
    if not plot then
        print("Missing Plot information [" .. x .. " " .. y .. "]")
        return
    end
    if not plot:IsRevealed(Game.GetActiveTeam(), false) then
        return
    end
	
    --print("Showing hex(" .. tostring(x) .. " " .. tostring(y) .. ") index: " .. index)
	
	local yields = GetYieldCache(x, y, index, plot)
    if not yields then   
        yields = SetYieldCache(x, y, index, plot)		
        if not yields then
			-- no yield for this tile
            return
        end
    end

    record = {}
    record.AnchorInstance = g_AnchorIM:GetInstance()
    record.AnchorInstance.Anchor:ChangeParent(Controls.YieldStore)
    g_VisibleSet[index] = record
    local anchor = record.AnchorInstance
	
	for yieldID, yield in ipairs(yields) do
		SetYieldIcon(yieldID, yield, anchor.Stack, record)
	end
	--[[
    SetYieldIcon(0, yieldInfo.m_Food,       anchor.Stack, record)
    SetYieldIcon(1, yieldInfo.m_Production, anchor.Stack, record)
    SetYieldIcon(2, yieldInfo.m_Gold,       anchor.Stack, record)
    SetYieldIcon(3, yieldInfo.m_Science,    anchor.Stack, record)
    SetYieldIcon(4, yieldInfo.m_Culture,    anchor.CultureContainer, record)
    SetYieldIcon(5, yieldInfo.m_Faith,      anchor.Stack, record)
	--]]

    anchor.Stack:CalculateSize()
    anchor.Stack:ReprocessAnchoring()
    anchor.Anchor:SetHexPosition(x, y)
end


------------------------------------------------------------------
------------------------------------------------------------------
function SetYieldIcon(yieldID, yield, parent, record)
    if yield == 0 then
		return
	end
	local imageInstance = g_ImageIM:GetInstance()
	local yieldInfo = GameInfo.Yields[yieldID]
	
	if (yieldID < 4) then
		imageInstance.Image:SetTexture(yieldInfo.TileTexture)
		if (yield >= 6) then
			imageInstance.Image:SetTextureOffsetVal(yieldID * 128, 512)
		else
			imageInstance.Image:SetTextureOffsetVal(yieldID * 128, 128 * (yield - 1))
		end

		imageInstance.Image:ChangeParent(parent)

		if (record.ImageInstances == nil) then
			record.ImageInstances = {}
		end
		table.insert(record.ImageInstances, imageInstance)

		if (yield >= 6) then
			local textImageInstance = g_ImageIM:GetInstance()

			textImageInstance.Image:SetTextureOffsetVal(GetNumberOffset(yield))
			
			textImageInstance.Image:ChangeParent(imageInstance.Image)
			table.insert(record.ImageInstances, textImageInstance)
		end
	elseif yieldInfo.TileTexture then
		imageInstance.Image:SetTexture(yieldInfo.TileTexture)
		if (yield >= 5) then
			imageInstance.Image:SetTextureOffsetVal(0 * 128, 512)
		else
			imageInstance.Image:SetTextureOffsetVal(0 * 128, 128 * (yield - 1))
		end
		
		imageInstance.Image:ChangeParent(parent)

		if (record.ImageInstances == nil) then
			record.ImageInstances = {}
		end
		table.insert(record.ImageInstances, imageInstance)

	end
end


------------------------------------------------------------------
------------------------------------------------------------------
function GetNumberOffset(number)
    if (number > 12) then
        number = 12
    end
    
    local x = 128 * ((number - 6) % 4)
    
    local y
    if (number > 9) then
        y = 768
    else
        y = 640
    end
    
    return x, y
end


------------------------------------------------------------------
------------------------------------------------------------------
function DestroyYield(index)
    --print("Hiding hex(" .. tostring(x) .. " " .. tostring(y) .. ")  index: " .. index)
    --g_Hidden = g_Hidden + 1
    
    -- we can get double hide requests when an icon scrolls off the corner of the view
    local instanceSet = g_VisibleSet[index]
    if (instanceSet) then
        local instance = instanceSet.AnchorInstance
        if (instance) then
            instance.Anchor:ChangeParent(Controls.Scrap)
            g_AnchorIM:ReleaseInstance(instance)
        end
        
		if instanceSet.ImageInstances then
			for i, instance in ipairs(instanceSet.ImageInstances) do
				instance.Image:ChangeParent(Controls.Scrap)
				g_ImageIM:ReleaseInstance(instance)
			end
		end
        
        g_VisibleSet[index] = nil
    end
    
end


------------------------------------------------------------------
------------------------------------------------------------------
function InitYieldCache(x, y, index, plot)
    if not g_YieldCache[index] then
        g_YieldCache[index] = {}
    end
end

function GetYieldCache(x, y, index, plot)
	--InitYieldCache(x, y, index, plot)
	return g_YieldCache[index]
end

function SetYieldCache(x, y, index, plot)
    InitYieldCache(x, y, index, plot)    
	local hasYield = false
	for yieldInfo in GameInfo.Yields{IsTileYield = 1} do
		local yieldID = yieldInfo.ID
		local yield = Plot_GetYield(plot, yieldID)
		g_YieldCache[index][yieldID] = yield
		if yield > 0 then
			hasYield = true
		end
	end
	if hasYield then
		return g_YieldCache[index]
	end
	return false
end


-------------------------------------------------
-------------------------------------------------
function OnYieldChangeEvent(gridX, gridY)

    local plot = Map.GetPlot(gridX, gridY)
    if (plot == nil)
    then
        print("Missing Plot information [" .. gridX .. " " .. gridY .. "]")
        return
    end
    
    if (not plot:IsRevealed(Game.GetActiveTeam(), false)) then
        return
    end

    local index = IndexFromGrid(gridX, gridY)
    
    SetYieldCache(gridX, gridY, index, plot)
    
    if (g_VisibleSet[index] ~= nil) then
        DestroyYield(index)
        BuildYield(gridX, gridY, index)
    end
    
end
Events.HexYieldMightHaveChanged.Add(OnYieldChangeEvent)

----------------------------------------------------------------
-- 'Active' (local human) player has changed
----------------------------------------------------------------
function OnActivePlayerChanged(iActivePlayer, iPrevActivePlayer)
	
	-- Reset the yield data.
	for index, pYield in pairs(g_VisibleSet) do
        DestroyYield(index)
   	end

	for index, pInfo in pairs(g_YieldCache) do
        g_YieldCache[index] = nil
   	end
	UI.RefreshYieldVisibleMode()
end
Events.GameplaySetActivePlayer.Add(OnActivePlayerChanged)

-- Bit of a hack here, we want to ensure that the yield icons are properly refreshed
-- when starting a new game.
UI.RefreshYieldVisibleMode()