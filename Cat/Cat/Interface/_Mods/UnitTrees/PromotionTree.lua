--
-- To display the Promotion Tree call either
--	 LuaEvents.PromotionTreeDisplay(iUnit)
-- to display the tree for a specific unit, or
--	 LuaEvents.PromotionTreeDisplay()
-- to display the tree with the Combat Class drop-down menu
--
-- For example, for a button on the UnitPanel screen
--	 function OnPromotionTreeButton(iUnit)
--		 LuaEvents.PromotionTreeDisplay(iUnit)
--	 end
--	 Controls.PromotionTreeButton:SetVoid1(UI.GetHeadSelectedUnit():GetID())
--	 Controls.PromotionTreeButton:RegisterCallback(Mouse.eLClick, OnPromotionTreeButton)
--
-- For example, for a tab in the Additional Information list
--	 function OnPromotionTreeView()
--		 LuaEvents.PromotionTreeDisplay()
--	 end
--	 instance.Tab:RegisterCallback(Mouse.eLClick, OnPromotionTreeView)
--

include("IconSupport")
include("InstanceManager")
include("InfoTooltipInclude")
include("ModTools.lua")

local log = Events.LuaLogger:New()
log:SetLevel("INFO")

bDebug = false

include("DebugPrint")
include("ControlUtils")
include("ButtonManager")
include("PipeManager")
include("PromotionUtils")

local config = {
	normal = {NAME="Normal", PANEL=740, GAP=50, PIPE=32, BUTTON="ButtonInstance"},
	small	= {NAME="Small",	PANEL=680, GAP=44, PIPE=16, BUTTON="ButtonInstanceSmall"}
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

function PlaceDropDown(iBaseX, iBaseY)
	DrawPromotionDropDown(iBaseX, iBaseY - (iDropDownSizeY / 2))

	AdjustClassGroupWidth(iDropDownSizeX + iPipeSizeX/2)

	OnSelectCombatClass(iDefaultCombatClass)
end

function PlaceUnit(pUnit, iBaseX, iBaseY)
	local sCombatClass = GameInfo.UnitCombatInfos[pUnit:GetUnitCombatType()].Type

	if UseGrid(sCombatClass) then
		local iUnitBoxX = iBaseX
		local iUnitBoxY = iBaseY - (iUnitBoxSizeY / 2)

		DrawUnitBox(iUnitBoxX, iUnitBoxY, pUnit)
		AdjustClassGroupWidth(iUnitBoxSizeX + iPipeSizeX/2)
		iBaseY = iBaseY - (3 * (iButtonSizeY + iGapY))
		PlacePromotions(pUnit, sCombatClass, iUnitBoxX + iUnitBoxSizeX, iBaseY)

	else
		local iUnitBoxX = iBaseX
		local iUnitBoxY = iBaseY - (iUnitBoxSizeY / 2)

		DrawUnitBox(iUnitBoxX, iUnitBoxY, pUnit)
		AdjustClassGroupWidth(iUnitBoxSizeX + iPipeSizeX/2)
		PlacePromotions(pUnit, sCombatClass, iUnitBoxX + iUnitBoxSizeX, iBaseY - (iUnitBoxSizeY / 2))
	end
end

function PlacePromotions(pUnit, sCombatClass, iBaseX, iBaseY)
	ButtonManagerReset()
	PipeManagerReset()

	local iWidth = iButtonSizeX + 3*iPipeSizeX
	AdjustBaseGroupWidth(iWidth)
	AdjustDependentGroupWidth(iWidth)

	if UseGrid(sCombatClass) then
		local gridPromotions = GetGridPromotions(sCombatClass)

		PlaceGridPipes(iBaseX, iBaseY, gridPromotions, PlaceGridButtons(pUnit, sCombatClass, gridPromotions, iBaseX, iBaseY))
	else
		local basePromotions = GetBasePromotions(sCombatClass)

		if (basePromotions and #basePromotions > 0) then
			local iPipeHorizX = iBaseX
			local iPipeHorizY = iBaseY - (iPipeSizeY / 2)
			PipeManagerDrawHorizontalPipe(iPipeHorizX, iPipeHorizY, iPipeSizeX)

			PlaceBasePromotions(pUnit, sCombatClass, basePromotions[1], iPipeHorizX + iPipeSizeX, iBaseY, -1)

			if (#basePromotions > 1) then
				PlaceBasePromotions(pUnit, sCombatClass, basePromotions[2], iPipeHorizX + iPipeSizeX, iBaseY, 1)
			end
		end
	end

	AdjustPanelWidth()
end

function PlaceGridButtons(pUnit, sCombatClass, gridPromotions, iBaseX, iBaseY)
	local iWidth = iButtonSizeX + 3*iPipeSizeX
	local iMaxBasicX = 1
	local iMaxAdvX = 0

	for _,gridPromotion in ipairs(gridPromotions) do
		local iButtonX = iBaseX + ((gridPromotion.x - 1) * iWidth) + 3*iPipeSizeX
		local iButtonY = iBaseY - (gridPromotion.y * (iButtonSizeY + iGapY)) - (iButtonSizeY/2)

		if gridPromotion.b then
			iMaxBasicX = math.max(iMaxBasicX, gridPromotion.x)
		else
			iMaxAdvX = math.max(iMaxAdvX, gridPromotion.x)
		end

		DrawPromotionButton(iButtonX, iButtonY, pUnit, gridPromotion.p)
	end

	if (iMaxAdvX > iMaxBasicX) then
		AdjustBaseGroupWidth(iMaxBasicX * iWidth)
		AdjustDependentGroupWidth((iMaxAdvX - iMaxBasicX) * iWidth)

		Controls.DependentLabel:SetText("TXT_KEY_PROMO_GROUP_DEPENDANT")
		Controls.DependentBar:SetToolTipString("TXT_KEY_PROMO_GROUP_DEPENDANT_TT")
		Controls.BaseBar:SetHide(false)
		Controls.AllBar:SetHide(true)
	else
		local screenSizeX, screenSizeY = UIManager:GetScreenSizeVal()
		AdjustBaseGroupWidth(math.max(iMaxBasicX * iWidth, screenSizeX - 280))
		AdjustDependentGroupWidth(-1)

		Controls.AllBar:SetHide(false)
		Controls.BaseBar:SetHide(true)
	end

	return (iMaxBasicX + 1)
end

function PlaceGridPipes(iBaseX, iBaseY, gridPromotions, iAdvX)
	-- Invert the promotions table, keying on the promotion name
	local promotions = {}
	for _,gridPromotion in ipairs(gridPromotions) do
		promotions[gridPromotion.p] = gridPromotion
	end
	promotions.PROMOTION_LEVEL_0 = {x=0, y=-3}
	promotions.PROMOTION_ANTI_TANK = {x=0, y=-3}	
	
	local iWidth = iButtonSizeX + 3*iPipeSizeX
	local horizontals = {}
	local quadrants = {}

	-- Draw all the verticals first, so they pass under the horizontals
	for _, gridPipe in ipairs(GetGridPipes(gridPromotions)) do
		local pFrom = promotions[gridPipe.from]
		local pTo = promotions[gridPipe.to]
		if (pFrom and pTo) or (gridPipe.from == "PROMOTION_LEVEL_0" or gridPipe.from == "PROMOTION_ANTI_TANK") then
			local iPipeHorizX = iBaseX + (pFrom.x * iWidth)
			local iPipeHorizY = iBaseY - (pFrom.y * (iButtonSizeY + iGapY)) - (iPipeSizeY/2)

			if (pFrom.y == pTo.y) then
				local iPipeLength = ((pTo.x - pFrom.x - 1) * iWidth) + 3*iPipeSizeX
				table.insert(horizontals, {x=iPipeHorizX, y=iPipeHorizY, l=iPipeLength})
			else
				-- Default is "across then down"
				local iPipeLengthPre = ((pTo.x - pFrom.x - 1) * iWidth) + iPipeSizeX
				local iPipeLengthPost = iPipeSizeX

				if (pTo.x == iAdvX) then
					-- Target is the first advanced promotion, so switch to "down then across"
					local t = iPipeLengthPre
					iPipeLengthPre = iPipeLengthPost
					iPipeLengthPost = t
				end

				table.insert(horizontals, {x=iPipeHorizX, y=iPipeHorizY, l=iPipeLengthPre})
				iPipeHorizX = iPipeHorizX + iPipeLengthPre

				local iOffset = pTo.y - pFrom.y
				local iDirection = (pTo.y > pFrom.y) and -1 or 1
				iOffset = iDirection * iOffset * -1

				table.insert(quadrants, {x=iPipeHorizX, y=iPipeHorizY, d=iDirection, b=true})

				local iPipeHeight = (iOffset * (iButtonSizeY + iGapY)) - iPipeSizeY

				if (iDirection > 0) then
					iPipeHorizY = iPipeHorizY + iPipeSizeY
					PipeManagerDrawVerticalPipe(iPipeHorizX, iPipeHorizY, iPipeHeight)
					iPipeHorizY = iPipeHorizY + iPipeHeight
				else
					iPipeHorizY = iPipeHorizY - iPipeHeight
					PipeManagerDrawVerticalPipe(iPipeHorizX, iPipeHorizY, iPipeHeight)
					iPipeHorizY = iPipeHorizY - iPipeSizeY
				end

				table.insert(quadrants, {x=iPipeHorizX, y=iPipeHorizY, d=iDirection, b=false})

				iPipeHorizX = iPipeHorizX + iPipeSizeX
				table.insert(horizontals, {x=iPipeHorizX, y=iPipeHorizY, l=iPipeLengthPost})
			end
		end
	end

	-- Draw all the (cached) horizontals over the verticals
	for _,h in ipairs(horizontals) do
		PipeManagerDrawHorizontalPipe(h.x, h.y, h.l, h.c)
	end

	-- Finally draw all the (cached) quadrants on top of the other pipes
	for _,q in ipairs(quadrants) do
		if q.b then
			DrawBottomPipe(q.x, q.y, q.d)
		else
			DrawTopPipe(q.x, q.y, q.d)
		end
	end
end

function PlaceBasePromotions(pUnit, sCombatClass, basePromotions, iBaseX, iBaseY, iDirection)
	local iGutterY = (iBaseY - (3 * (iButtonSizeY + iGapY))) / 2

	for iPromotion = 1, #basePromotions, 1 do
		local sPromotion = basePromotions[iPromotion]
		local iButtonX = iBaseX + (2*iPipeSizeX) + ((iPromotion-1) * (2*iPipeSizeX + iButtonSizeX + iPipeSizeX))
		local iButtonY = iBaseY + (iDirection * (iGutterY + ((iPromotion-1) * (iButtonSizeY + iGapY))))
		if (iDirection == -1) then
			iButtonY = iButtonY - iButtonSizeY
		end
		DrawPromotionButton(iButtonX, iButtonY, pUnit, sPromotion)

		local iPipeHorizX = iButtonX + iButtonSizeX
		local iPipeHorizY = iButtonY + ((iButtonSizeY - iPipeSizeY) / 2)

		PipeManagerDrawHorizontalPipe(iButtonX - iPipeSizeX, iPipeHorizY, iPipeSizeX)

		local iPipeVertX = iButtonX - 2*iPipeSizeX
		DrawTopPipe(iPipeVertX, iPipeHorizY, iDirection)

		local iPipeUpY
		if (iPromotion == 1) then
			iPipeUpY = iBaseY - (iPipeSizeY / 2)
		else
			iPipeUpY = iPipeHorizY - (iDirection * (iButtonSizeY + iGapY))
		end
		DrawBottomPipe(iPipeVertX, iPipeUpY, iDirection)

		local iPipeVertY, iPipeVertLen
		if (iDirection == -1) then
			iPipeVertY = iPipeHorizY + iPipeSizeY
			iPipeVertLen = iPipeUpY - iPipeVertY
		else
			iPipeVertY = iPipeUpY + iPipeSizeY
			iPipeVertLen = iPipeHorizY - iPipeVertY
		end
		PipeManagerDrawVerticalPipe(iPipeVertX, iPipeVertY, iPipeVertLen)

		local iWidth = math.max(Controls.BaseGroup:GetSize().x, #basePromotions * (iButtonSizeX + 3*iPipeSizeX))
		AdjustBaseGroupWidth(iWidth)

		local chainedPromotions = GetDependentPromotions(sCombatClass, sPromotion)
		if (#chainedPromotions > 0) then
			local iPipeHorizLen = ((#basePromotions-iPromotion) * (2*iPipeSizeX + iButtonSizeX + iPipeSizeX)) + iPipeSizeX
			PipeManagerDrawHorizontalPipe(iPipeHorizX, iPipeHorizY, iPipeHorizLen)

			PlaceDependentPromotions(pUnit, sCombatClass, chainedPromotions, iPipeHorizX + iPipeHorizLen, iButtonY, iDirection)
		else
			-- There are no dependant promotions, but we need a short length of pipe to join the next base promotion onto
			if (iPromotion < #basePromotions) then
				PipeManagerDrawHorizontalPipe(iPipeHorizX, iPipeHorizY, iPipeSizeX)
			end
		end
	end
end

function PlaceDependentPromotions(pUnit, sCombatClass, chainedPromotions, iBaseX, iBaseY, iDirection)
	local iPipeSpanY = iBaseY + ((iButtonSizeY - iPipeSizeY) / 2)
	local iPipeSpanAboveY = iPipeSpanY + (iDirection * (iButtonSizeY + iGapY))

	local iButtonX = iBaseX + 2*iPipeSizeX
	local iButtonY
	if (iDirection == -1) then
		iButtonY = iPipeSpanAboveY + iPipeSizeY + ((iPipeSpanY - (iPipeSpanAboveY + iPipeSizeY) - iButtonSizeY) / 2)
	else
		iButtonY = iPipeSpanY + iPipeSizeY + ((iPipeSpanAboveY - (iPipeSpanY + iPipeSizeY) - iButtonSizeY) / 2)
	end

	local iPipeJoinY = iButtonY + ((iButtonSizeY - iPipeSizeY) / 2)

	PipeManagerDrawHorizontalPipe(iBaseX - iPipeSizeX, iPipeSpanY, iPipeSizeX)

	local iSpanPromotions = 0
	for i = 1, #chainedPromotions-1, 1 do
		iSpanPromotions = iSpanPromotions + #chainedPromotions[i]
	end

	if (iSpanPromotions > 0) then
		local iPipeSpanLen = iSpanPromotions * (2*iPipeSizeX + iButtonSizeX + iPipeSizeX)
		PipeManagerDrawHorizontalPipe(iBaseX, iPipeSpanY, iPipeSpanLen)
	end

	local iWidth = math.max(Controls.DependentGroup:GetSize().x, (iSpanPromotions + #chainedPromotions[#chainedPromotions]) * (iButtonSizeX + 3*iPipeSizeX))
	AdjustDependentGroupWidth(iWidth)

	for i = 1, #chainedPromotions, 1 do
		for j = 1, #chainedPromotions[i], 1 do
			local sDependentPromotion = chainedPromotions[i][j]
			DrawPromotionButton(iButtonX, iButtonY, pUnit, sDependentPromotion)

			if (j == 1) then
				local iPipeVertX = iButtonX - 2*iPipeSizeX
				local iPipeVertY, iPipeVertLen
				if (iDirection == -1) then
					iPipeVertY = iPipeJoinY + iPipeSizeY
					iPipeVertLen = iPipeSpanY - iPipeVertY
				else
					iPipeVertY = iPipeSpanY + iPipeSizeY
					iPipeVertLen = iPipeJoinY - iPipeVertY
				end

				PipeManagerDrawHorizontalPipe(iButtonX - iPipeSizeX, iPipeJoinY, iPipeSizeX)
				DrawTopPipe(iPipeVertX, iPipeJoinY, iDirection)
				PipeManagerDrawVerticalPipe(iPipeVertX, iPipeVertY, iPipeVertLen)
				DrawBottomPipe(iPipeVertX, iPipeSpanY, iDirection)
			else
				PipeManagerDrawHorizontalPipe(iButtonX - 3*iPipeSizeX, iPipeJoinY, 3*iPipeSizeX)
			end

			iButtonX = iButtonX + (2*iPipeSizeX + iButtonSizeX + iPipeSizeX)
		end
	end
end


--
-- AdjustAbc(iSize) functions
--

function AdjustPanelHeight(iBaseX, iBaseY, iHeight)
	local iPanelHeight = iHeight + 2*iTopMargin
	local iScrollHeight = iPanelHeight - iTopMargin
	local iGroupHeight = iPanelHeight
	local iDividerHeight = iScrollHeight - iTopMargin
	local iBlockHeight = iScrollHeight

	SetHeight(Controls.TreePanel, iPanelHeight)
	SetHeight(Controls.ScrollPanel, iScrollHeight)
	SetHeight(Controls.PipesPanel, iScrollHeight)
	SetHeight(Controls.ButtonsPanel, iScrollHeight)

	SetHeight(Controls.ClassGroup, iGroupHeight)
	SetHeight(Controls.ClassDivider, iDividerHeight)

	SetHeight(Controls.BaseGroup, iGroupHeight)
	SetHeight(Controls.BaseDivider, iDividerHeight)
	SetHeight(Controls.BaseBlock, iBlockHeight)

	SetHeight(Controls.DependentGroup, iGroupHeight)
	SetHeight(Controls.DependentDivider, iDividerHeight)
	SetHeight(Controls.DependentBlock, iBlockHeight)

	Controls.DropDownBox:SetOffset({x=iBaseX, y=(iBaseY - iDropDownSizeY/2)})
	Controls.UnitBox:SetOffset({x=iBaseX, y=(iBaseY - iUnitBoxSizeY/2)})

	-- It would appear that changing the height of the container doesn't move the bottom anchored Close Button or the Legend
	-- so move them to (0,0) then move them back from whence they came!
	OffsetAgain(Controls.CloseButton)
	OffsetAgain(Controls.ResizeButton)

	Controls.ScrollPanel:CalculateInternalSize()
	Controls.ScrollBar:SetSizeX(Controls.ScrollPanel:GetSizeX() - iScrollBarMagicX)
end

function AdjustPanelWidth()
	Controls.GroupsStack:CalculateSize()
	Controls.GroupsStack:ReprocessAnchoring()
	SetWidth(Controls.PipesPanel, Controls.GroupsStack:GetSizeX())
	SetWidth(Controls.ButtonsPanel, Controls.GroupsStack:GetSizeX())
	Controls.ScrollPanel:CalculateInternalSize()
end

function AdjustClassGroupWidth(iWidth)
	SetWidth(Controls.ClassGroup, iWidth)
	SetWidth(Controls.ClassBar, iWidth)
end

function AdjustBaseGroupWidth(iWidth)
	if (iWidth > 0) then
		Controls.BaseGroup:SetHide(false)
		SetWidth(Controls.BaseGroup, iWidth)
		SetWidth(Controls.BaseBlock, iWidth)
		SetWidth(Controls.BaseBar, iWidth)
		SetWidth(Controls.AllBar, iWidth)
	else
		Controls.BaseGroup:SetHide(true)
	end
end

function AdjustDependentGroupWidth(iWidth)
	if (iWidth > 0) then
		Controls.DependentGroup:SetHide(false)
		SetWidth(Controls.DependentGroup, iWidth)
		SetWidth(Controls.DependentBlock, iWidth)
		SetWidth(Controls.DependentBar, iWidth)
	else
		Controls.DependentGroup:SetHide(true)
	end
end


--
-- DrawXyz(iX, iY, ...) functions
--
-- Create instance components and configure them
--
-- Note: The colour parameter in the pipe drawing functions is intended only for debugging!
--

function DrawPromotionDropDown(iX, iY)
	dprint("Place dropdown menu at (%i, %i)", iX, iY)

	Controls.ClassLabel:SetText(Locale.ConvertTextKey("TXT_KEY_PROMO_GROUP_CLASS"))

	Controls.DropDownBox:SetHide(false)
	Controls.UnitBox:SetHide(true)

	PopulateClassDropDown()

	Controls.Legend:SetHide(true)
end

function DrawUnitBox(iX, iY, pUnit)
	dprint("Place unit box for %s at (%i, %i)", pUnit:GetName(), iX, iY)

	Controls.ClassLabel:SetText(Locale.ConvertTextKey("TXT_KEY_PROMO_GROUP_UNIT"))

	Controls.UnitBox:SetHide(false)
	Controls.DropDownBox:SetHide(true)

	Controls.UnitBox:SetOffset({x=iX, y=iY})

	Controls.UnitName:SetText(pUnit:GetName())

	local unit = GameInfo.Units[pUnit:GetUnitType()]
	Controls.UnitPortraitFrame:SetHide(IconHookup(unit.PortraitIndex, iUnitIconSize, unit.IconAtlas, Controls.UnitPortrait) ~= true)

	Controls.UnitBox:SetToolTipString(GetPromotionsToolTip(pUnit))

	Controls.Legend:SetHide(false)
	OffsetAgain(Controls.Legend)
end

function DrawPromotionButton(iX, iY, pUnit, sPromotion)
	dprint("Place %s at (%i, %i)", sPromotion, iX, iY)
	local promotion = GameInfo.UnitPromotions[sPromotion]
	if not promotion then
		log:Warn("%s does not exist", sPromotion)
		return
	end
	
	local sName = Locale.ConvertTextKey(promotion.Description) -- string.gsub(promotion.Type, "PROMOTION_", ""))
	local sToolTip = Locale.ConvertTextKey(promotion.Help)

	local button = ButtonManagerGetButton(iX, iY, sToolTip, promotion.IconAtlas, promotion.PortraitIndex, promotion.TechPrereq)

	if (pUnit == nil or HasPromotion(pUnit, promotion.ID)) then
		button.EarntName:SetText(sName)
		button.Earnt:SetHide(false)
		button.Available:SetHide(true)
		button.Unavailable:SetHide(true)
	elseif (CanAcquirePromotion(pUnit, promotion.ID)) then
		button.AvailableName:SetText(sName)
		button.Available:SetHide(false)
		button.Earnt:SetHide(true)
		button.Unavailable:SetHide(true)

		button.Button:SetVoid1(promotion.ID)
		button.Button:RegisterCallback(Mouse.eLClick, OnSelectPromotion)
	else
		button.UnavailableName:SetText(sName)
		button.Unavailable:SetHide(false)
		button.Earnt:SetHide(true)
		button.Available:SetHide(true)
	end
end

function DrawBottomPipe(iX, iY, iDirection, colour)
	local sType
	if (iDirection == -1) then
		sType = "bottom-right"
	else
		sType = "top-right"
	end
	PipeManagerDrawQuadrantPipe(iX, iY, sType, colour)
end

function DrawTopPipe(iX, iY, iDirection, colour)
	local sType
	if (iDirection == -1) then
		sType = "top-left"
	else
		sType = "bottom-left"
	end
	PipeManagerDrawQuadrantPipe(iX, iY, sType, colour)
end


--
-- Helper functions
--

function GetPromotionsToolTip(pUnit)
	local sPromotions = ""

	local sRankedPromotions = ""
	local sRankedPrefix = ""
	local sPositivePromotions = ""
	local sPositivePrefix = ""
	local sNegativePromotions = ""
	local sNegativePrefix = ""

	for promotion in GameInfo.UnitPromotions() do
		if (pUnit:IsHasPromotion(promotion.ID)) then
			if (IsRankedPromotion(promotion.Type)) then
				sRankedPromotions = sRankedPromotions .. sRankedPrefix .. "[COLOR_YELLOW]" .. Locale.ConvertTextKey(promotion.Description) .. "[ENDCOLOR]: " .. Locale.ConvertTextKey(promotion.Help)
				sRankedPrefix = "[NEWLINE]"
			else
				if (promotion.PortraitIndex == 57) then
					sNegativePromotions = sNegativePromotions .. sNegativePrefix .. "[COLOR_RED]" .. Locale.ConvertTextKey(promotion.Description) .. "[ENDCOLOR]: " .. Locale.ConvertTextKey(promotion.Help)
					sNegativePrefix = "[NEWLINE]"
				else
					sPositivePromotions = sPositivePromotions .. sPositivePrefix .. "[COLOR_YELLOW]" .. Locale.ConvertTextKey(promotion.Description) .. "[ENDCOLOR]: " .. Locale.ConvertTextKey(promotion.Help)
					sPositivePrefix = "[NEWLINE]"
				end
			end
		end
	end

	if (sNegativePromotions ~= "") then
		if (sPositivePromotions ~= "") then
			sPositivePromotions = sPositivePromotions .. "[NEWLINE]" .. sNegativePromotions
		else
			sPositivePromotions = sNegativePromotions
		end
	end

	if (sRankedPromotions ~= "") then
		if (sPositivePromotions ~= "") then
			sPromotions = sRankedPromotions .. "[NEWLINE][NEWLINE]" .. sPositivePromotions
		else
			sPromotions = sRankedPromotions
		end
	elseif (sPositivePromotions ~= "") then
		sPromotions = sPositivePromotions
	end

	return sPromotions
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

	local sQuery = "SELECT x.CombatClass, x.IsDefault, c.Description, x.DefaultUnitType FROM UnitCombatInfos c, UnitCombatInfosEx x WHERE c.Type = x.CombatClass"
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
			PlaceDropDown(iLeftMargin, iCentreLine)
		else
			PlaceUnit(Players[Game.GetActivePlayer()]:GetUnitByID(iSelectedUnit), iLeftMargin, iCentreLine)
		end
	end

	bTreeVisible = (bIsHide == false)
end
ContextPtr:SetShowHideHandler(ShowHideHandler)

function OnDisplay(iUnit)
	iSelectedUnit = iUnit
	dprint("OnDisplay(%i)", iSelectedUnit or 0)

	UIManager:QueuePopup(ContextPtr, PopupPriority.BarbarianCamp)
end
LuaEvents.PromotionTreeDisplay.Add(OnDisplay)

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

	local iBaseX = iLeftMargin
	local iBaseY = iCentreLine

	local sCombatClass = g_ClassList[iIndex].CombatClass

	Controls.DropDownBox:SetOffset({x=iBaseX, y=(iBaseY - iDropDownSizeY/2)})

	if UseGrid(sCombatClass) then
		iBaseY = iBaseY - (3 * (iButtonSizeY + iGapY))
	end

	PlacePromotions(nil, sCombatClass, iBaseX + iDropDownSizeX, iBaseY)
end

function OnSelectPromotion(iPromotion)
	local pUnit = UI.GetHeadSelectedUnit()
	dprint("Selected %s for %s", GameInfo.UnitPromotions[iPromotion].Type, pUnit:GetName())

	Events.AudioPlay2DSound("AS2D_INTERFACE_UNIT_PROMOTION")
	Game.HandleAction(GetActionForPromotion(iPromotion))
end

function OnUnitInfoDirty()
	if (bTreeVisible) then
		local pUnit = UI.GetHeadSelectedUnit()

		if (pUnit and pUnit:GetID() == iSelectedUnit) then
			PlaceUnit(pUnit, iLeftMargin, iCentreLine)
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
		ButtonManagerReset()
	PipeManagerReset()
	end

	iHeight = config.PANEL
	iGapY = config.GAP
	iCentreLine = iTopMargin + iHeight / 2
	AdjustPanelHeight(iLeftMargin, iCentreLine, iHeight)

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


--
-- Assuming the table
-- <Table name="UnitPromotions_Grid">
--	 <Column name="PromotionType" type="text" reference="UnitPromotions(Type)"/>
--	 <Column name="UnitCombatType" type="text" reference="UnitCombatInfos(Type)"/>
--	 <Column name="Base" type="boolean" default="true"/>
--	 <Column name="GridX" type="integer"/>
--	 <Column name="GridY" type="integer"/>
-- </Table>
--

function UseGrid(sCombatClass)
	for pg in GameInfo.UnitPromotions_Grid{UnitCombatType=sCombatClass} do
		return true
	end
	return false
end

function GetGridPromotions(sCombatClass)
	local promotions = {}
	for pg in GameInfo.UnitPromotions_Grid{UnitCombatType=sCombatClass} do
		table.insert(promotions, {p=pg.PromotionType, x=pg.GridX, y=(-1 * pg.GridY), b=pg.Base})
	end
	return promotions
end

function GetGridPipes(promotions)
	local pipes = {}	
	for _, data in pairs(promotions) do
		local promoInfo = GameInfo.UnitPromotions[data.p]
		if not promoInfo then
			log:Warn("%s does not exist", data.p)
		else
			if not promoInfo.PromotionPrereqOr1 and not promoInfo.PromotionPrereqOr2 and not promoInfo.PromotionPrereqOr3 and not promoInfo.PromotionPrereqOr4 then
				table.insert(pipes, {from="PROMOTION_LEVEL_0", to=promoInfo.Type})
			else
				if promoInfo.PromotionPrereqOr1 then table.insert(pipes, {from=promoInfo.PromotionPrereqOr1, to=promoInfo.Type}) end
				if promoInfo.PromotionPrereqOr2 then table.insert(pipes, {from=promoInfo.PromotionPrereqOr2, to=promoInfo.Type}) end
				if promoInfo.PromotionPrereqOr3 then table.insert(pipes, {from=promoInfo.PromotionPrereqOr3, to=promoInfo.Type}) end
				if promoInfo.PromotionPrereqOr4 then table.insert(pipes, {from=promoInfo.PromotionPrereqOr4, to=promoInfo.Type}) end
				if promoInfo.PromotionPrereqOr5 then table.insert(pipes, {from=promoInfo.PromotionPrereqOr5, to=promoInfo.Type}) end
				if promoInfo.PromotionPrereqOr6 then table.insert(pipes, {from=promoInfo.PromotionPrereqOr6, to=promoInfo.Type}) end
			end
		end
	end	
	return pipes
end


local bStandardInsert = true
LuaEvents.DiploCornerExtended.Add(function() bStandardInsert = false; end)

function OnDiploCornerPopup()
  OnDisplay()
end

function OnAdditionalInformationDropdownGatherEntries(additionalEntries)
  if (bStandardInsert) then
    table.insert(additionalEntries, {text=Locale.ConvertTextKey("TXT_KEY_PROMO_DIPLO_CORNER_HOOK"), call=OnDiploCornerPopup})
  end
end
LuaEvents.AdditionalInformationDropdownGatherEntries.Add(OnAdditionalInformationDropdownGatherEntries)
LuaEvents.RequestRefreshAdditionalInformationDropdownEntries()
