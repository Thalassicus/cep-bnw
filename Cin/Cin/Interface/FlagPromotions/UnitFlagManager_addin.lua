-- UnitFlagManager_addin
-- Authors: Thalassicus, Erendir, Xienwolf, tothink
-- DateCreated: 1/23/2011 12:37:36 AM
--------------------------------------------------------------

include("ModTools.lua")
local log = Events.LuaLogger:New()
log:SetLevel("DEBUG")
log:Info("Loading UnitFlagManager_addin.lua A")

include("ModUserData")
--local ModID				= ModID --"44311931-9c7a-4f55-b465-7dc8d814e24d"
--local ModVersion		= ModVersion --Modding.GetActivatedModVersion(modID) or 1
--local ModUserData		= ModUserData --Modding.OpenUserData(modID, modVersion)
--local ignorePromotion	= assert(ignorePromotion, 'ModUserData.lua is not properly loaded')
local OFFSET_NORMAL		= Vector2(0,-28)
local OFFSET_STACK_1	= Vector2(0,0)
local OFFSET_STACK_2	= Vector2(0,-12)

-- Imported globals
local g_MasterList = g_MasterList
local g_UnitFlagClass = g_UnitFlagClass

g_UnitFlagClass.UpdatePromotionsOffset = g_UnitFlagClass.UpdatePromotionsOffset or function( self ) end

-- Shared locals
local bHideAllUnitIcons = false
local bDisplayAllFlagPromotions = true


function AddButton(control, tooltip, texture)
	local button = {}
	texture = texture or "Promotions128.dds"
	ContextPtr:BuildInstanceForControl("PromotionButtonInstance", button, control)
	
	if tooltip then
		tooltip = tostring(tooltip)
		if string.find(tooltip, "TXT_KEY") then
			button.Button:LocalizeAndSetToolTip(tooltip)
		else
			button.Button:SetToolTipString(tooltip)
		end
	else
		button.Button:SetToolTipString("")
	end
	return button
end


LuaEvents.ToggleHideUnitIcon.Add(
	function()
		bHideAllUnitIcons = not bHideAllUnitIcons	-- Modified by Erendir
	end)
	
g_UnitFlagClass.UpdateVisibility = function ( self )
	self.m_IsUnitIconDisplayed = self.m_IsCurrentlyVisible and not self.m_IsInvisible
    self.m_Instance.Anchor:SetHide(not self.m_IsUnitIconDisplayed)
	if InStrategicView() then
		self.m_IsUnitIconDisplayed = self.m_IsUnitIconDisplayed and g_GarrisonedUnitFlagsInStrategicView and self.m_IsGarrisoned
	else
		self.m_IsUnitIconDisplayed = self.m_IsUnitIconDisplayed and (self.m_IsGarrisoned or not bHideAllUnitIcons)
		if self.m_Escort then
			self.m_Escort.m_Instance.Anchor:SetHide(not self.m_IsUnitIconDisplayed)
		end
        if self.m_CargoControls ~= nil and self.m_IsUnitIconDisplayed then
        	self:UpdateCargo()
    	end
	end
    self.m_Instance.FlagShadow:SetHide(not self.m_IsUnitIconDisplayed)
	if (not bDisplayAllFlagPromotions) and self.m_Promotion and self.m_Promotions[1] then
		self:SetHideAllPromotions(true)
	end
	self:UpdatePromotions()
	self:UpdatePromotionsOffset()
end


g_UnitFlagClass.IsFlagDisplayed = function( self )
	return self.m_IsUnitIconDisplayed
end

log:Info("Loading UnitFlagManager_addin.lua B")

-- Options
local iPromotionsStackMax = 9

local unitPromotions, PromotionIDfromType = {}, {}
local PromotionIDlist = {}
for promo in GameInfo.UnitPromotions() do
	unitPromotions[#unitPromotions+1] = {Type=promo.Type, ID = promo.ID}
	PromotionIDfromType[promo.Type]=promo.ID -- map types to IDs
	PromotionIDlist[promo.ID]=true
end

local isPromotionwithlevels = {}
for _, promo in pairs(unitPromotions) do
	local promoType = promo.Type
	local name, suffix = string.match(promoType,'(.+)_([^_]+)$')
	if not string.find(suffix,'%D') then
		local id = promo.ID
		suffix = tonumber(suffix)
		isPromotionwithlevels[id]={Pclass=name, suffix=suffix} -- map id's to Promotion class and place in that class
	
		local t = isPromotionwithlevels[name] or {}
		t[suffix]=id  -- add id to the class list (referenced by number)
		isPromotionwithlevels[name] = t
	end
end

--[[ Currently a hardcoded 9 promotions are available, need to figure out a variable expression for the XML container to allow adjustable rows/columns ]]

log:Info("Loading UnitFlagManager_addin.lua C")

------------------------------------------------------------------
------------------------------------------------------------------
g_UnitFlagClass.UpdatePromotions = function( self, promotionType )
	local player = Players[self.m_PlayerID]
	local unit = player:GetUnitByID(self.m_UnitID)
	if not (unit and bDisplayAllFlagPromotions and self.m_Promotions) then
		return
	end
	
	--log:Debug("UpdatePromotions %15s %15s %15s", player:GetName(), GameInfo.Units[unit:GetUnitType()].Type, promotionType)
	
	local promotionIndex	= 1
	local best_id			= {}
	local checked			= {}
	local newPromotionID	= promotionType and GameInfo.UnitPromotions[promotionType].ID
	if newPromotionID then
		--log:Debug("New  %15s %15s %s", Players[unit:GetOwner()]:GetName(), unit:GetName(), promotionType)
	end
	for k,v in ipairs(self.m_Promotions) do
		v.IsVisible = false
	end
	for promotion in GameInfo.UnitPromotions() do
		local promotionID = promotion.ID
		if not (ignorePromotion[promotionID] or checked[promotionID]) then
			self.m_Promotions[promotionIndex].IsVisible = true
			if not best_id[promotionID] then
				----log:Trace("  Check         :: "..promotion.Type)
				-- handle promotions with levels
				local Plvl = isPromotionwithlevels[promotionID]
				if Plvl then -- is it one of them?
					----log:Trace("        Leveled :: "..promotion.Type)
					local t_Pclass = isPromotionwithlevels[ Plvl.Pclass ] -- get the whole list
					-- find best promo
					local i = #t_Pclass
					local levelID = t_Pclass[i]
					while levelID and not (unit:IsHasPromotion(levelID) or newPromotionID == levelID) do
						checked[levelID]=true
						i=i-1
						levelID = t_Pclass[i]
					end
					if levelID then
						best_id[levelID]=i
					end
					self.m_Promotions[promotionIndex].IsVisible = (levelID==promotionID)
					
					-- mark lower promotions also as checked
					i=i-1 levelID = t_Pclass[i] -- skip current, best one
					while levelID do
						checked[levelID] = true
						i = i - 1
						levelID = t_Pclass[i]
					end -- mark
				else
					----log:Trace("            Not :: "..promotion.Type)
					self.m_Promotions[promotionIndex].IsVisible = unit:IsHasPromotion(promotionID) or newPromotionID == promotionID
				end
			end
			if self.m_Promotions[promotionIndex].IsVisible then
				if self.m_Promotions[promotionIndex].ID ~= promotionID then
					----log:Trace("self.m_Instance['Promotion'.."..promotionIndex.."]:SetHide( false ) :: IconAtlas="..promotion.IconAtlas.."  PortraitIndex="..promotion.PortraitIndex)
					self.m_Promotions[promotionIndex].ID = promotionID
					IconHookup( promotion.PortraitIndex, 16, promotion.IconAtlas, self.m_Instance['Promotion'..promotionIndex] )
				
					-- Tooltip
					local strToolTip = ""
					if promotion.SimpleHelpText then
						strToolTip = Locale.ConvertTextKey(promotion.Help)
					else
						strToolTip = string.format("[COLOR_YELLOW]%s[ENDCOLOR][NEWLINE]%s",
							Locale.ConvertTextKey(promotion.Description),
							Locale.ConvertTextKey(promotion.Help)
						)
					end
					local best_pos = best_id[promotionID]
					if best_pos and best_pos>1 then
						local t_Pclass = isPromotionwithlevels[ isPromotionwithlevels[promotionID].Pclass ]
						-- local i = #t_Pclass
						-- local id = t_Pclass[i]
						-- while id and not (unit:IsHasPromotion(id) or (promotionType and unit:IsHasPromotion(GameInfo.UnitPromotions[promotionType].ID))) do checked[id]=true i=i-1 id = t_Pclass[i] end
					
						local ids = tostring(t_Pclass[1])
						for i = 2,best_pos-1 do
							ids = ids ..','.. t_Pclass[i]
						end
							-- strToolTip = strToolTip..'[COLOR_YELLOW]'..i..'[ENDCOLOR]'..'[NEWLINE]'
						ids = '('..ids..')'
						local sql = string.format("select Description, Help from UnitPromotions where ID in "..ids)
						for res in DB.Query(sql) do
							strToolTip = strToolTip..'[NEWLINE][COLOR_YELLOW]'..Locale.ConvertTextKey(res.Description)..'[ENDCOLOR]'..'[NEWLINE]'..Locale.ConvertTextKey(res.Help)
						end
					end
					self.m_Instance['Promotion'..promotionIndex]:SetToolTipString(strToolTip)
				end
				
				promotionIndex = promotionIndex + 1
				if promotionIndex > iPromotionsStackMax then
					break -- stop the for cycle
				end
			end
		end
	end --for
	
	for k,v in ipairs(self.m_Promotions) do
		self.m_Instance['Promotion'..k]:SetHide(not v.IsVisible)
		if v.IsVisible then
			if GameInfo.UnitPromotions[v.ID] then
				--log:Debug("SHOW "..Players[unit:GetOwner()]:GetName().." "..unit:GetName().." "..GameInfo.UnitPromotions[v.ID].Type)
			else
				--log:Debug("SHOW "..Players[unit:GetOwner()]:GetName().." "..unit:GetName().." INVALID PROMOTION ID: "..v.ID)
			end
		else
			----log:Trace("hide "..Players[unit:GetOwner()]:GetName().." "..unit:GetName().." "..k)			
		end		
	end
	
	self.m_Instance.EarnedPromotionStack1:CalculateSize()
	self.m_Instance.EarnedPromotionStack1:ReprocessAnchoring()
	
	self.m_Instance.EarnedPromotionStack2:CalculateSize()
	self.m_Instance.EarnedPromotionStack2:ReprocessAnchoring()
end

log:Info("Loading UnitFlagManager_addin.lua D")

function OnNewUnitRefresh( playerID, unitID, hexVec, unitType, cultureType, civID, primaryColor, secondaryColor, unitFlagIndex, fogState, selected, military, notInvisible )
	local flag = g_MasterList[ playerID ][ unitID ]
	if flag then
		flag:UpdatePromotions()
	else
		log:Warn( string.format( "Flag not found for OnNewUnitRefresh: Player[%i] Unit[%i]", playerID, unitID ) )
	end
end
Events.SerialEventUnitCreated.Add( OnNewUnitRefresh )

log:Info("Loading UnitFlagManager_addin.lua E")


g_UnitFlagClass.SetHideAllPromotions = function (self, isHidden)
	if isHidden then
		for k,v in ipairs(self.m_Promotions) do
			self.m_Instance['Promotion'..k]:SetHide(isHidden)
			v.IsVisible = false
		end
	end
end

log:Info("Loading UnitFlagManager_addin.lua F")

local OldInitialize = g_UnitFlagClass.Initialize

g_UnitFlagClass.Initialize = function( o, playerID, unitID, fogState, invisible )
	local player = Players[playerID]
	local unit = player:GetUnitByID(unitID)
	--log:Debug("Init %s %s", player:GetName(), unit:GetName())
	OldInitialize( o, playerID, unitID, fogState, invisible )
	
	o.m_IsUnitIconDisplayed = true
	o.m_Promotions = {} -- will store the list of displayed promotions
	for i = 1, iPromotionsStackMax do
		o.m_Promotions[i] = {}
	end
	--o:UpdatePromotions()
end

log:Info("Loading UnitFlagManager_addin.lua G")

local OldUpdateFlagOffset = g_UnitFlagClass.UpdateFlagOffset

g_UnitFlagClass.UpdateFlagOffset = function( self )
	OldUpdateFlagOffset(self)
	self:UpdatePromotions()
	self:UpdatePromotionsOffset()
end

g_UnitFlagClass.UpdatePromotionsOffset = function( self )
	local pUnit = Players[ self.m_PlayerID ]:GetUnitByID( self.m_UnitID )
	if pUnit == nil then
		return
	end	
	
	local plot = pUnit:GetPlot()
	
	if plot == nil then
		return
	end
	
	local offset = Vector2( 0, 0 )
	
	if pUnit:IsGarrisoned() then
		if( Game.GetActiveTeam() == Players[ self.m_PlayerID ]:GetTeam() ) then
			offset = VecAdd( offset, GarrisonOffset)
		else
			offset = VecAdd( offset, GarrisonOtherOffset)
		end
	elseif plot:IsCity() then
		offset = VecAdd( offset, CityNonGarrisonOffset)
	end
	
	
	if( self.m_CarrierFlag ~= nil ) then
		offset = VecAdd( offset, EscortOffset )
		self.m_CarrierFlag:UpdateFlagOffset( EscortOtherOffset )
            
	elseif self.m_Escort and not pUnit:IsGarrisoned() then
		if not self.m_IsCivilian and self.m_Escort.m_IsCivilian then
            offset = VecAdd( offset, EscortOffset )
		elseif self.m_IsCivilian and not self.m_Escort.m_IsCivilian then
            offset = VecAdd( offset, EscortOtherOffset )
		elseif self.m_UnitID < self.m_Escort.m_UnitID then
            offset = VecAdd( offset, EscortOffset )
		else
            offset = VecAdd( offset, EscortOtherOffset )
        end
    end
	
	if self.m_IsUnitIconDisplayed and not InStrategicView() then
		offset = VecAdd( offset, OFFSET_NORMAL)
	end
	
	-- set the ui offset
	self.m_Instance.EarnedPromotionStack1:SetOffset( VecAdd(offset, OFFSET_STACK_1) )
	self.m_Instance.EarnedPromotionStack2:SetOffset( VecAdd(offset, OFFSET_STACK_2) )
end



log:Info("Loading UnitFlagManager_addin.lua H")

-- Independent Events

function OnPromotionEvent(unit, promotionType)
	--log:Debug( "%15s %15s ActiveUnitRefreshFlag", unit, promotionType )

	if not unit then
		return
	end
	local unitID	= unit:GetID() or -1
	local playerID	= unit:GetOwner()
	local player	= Players[ playerID ]
	if not player or not player:IsAlive() or unit:IsDead() then
		return
	end

	--log:Debug( "%s %s ActiveUnitRefreshFlag", unit:GetName(), player:GetName() )
	
	local flag = g_MasterList[playerID][unitID]
	if flag then
		flag:UpdatePromotions(promotionType)
	else
		log:Fatal( "Flag not found for PromotionEvent: Player[%i] Unit[%i]", playerID, unitID )
	end
end

LuaEvents.PromotionEarned.Add(OnPromotionEvent)
LuaEvents.UnitUpgraded.Add(OnPromotionEvent)
	
function RefreshUnitFlagPromotionsGlobally()
	for playerID,unitList in pairs(g_MasterList) do
		for unitID,flag in pairs(unitList) do
			if flag and flag:IsFlagDisplayed() then
				flag:UpdateVisibility()
			end
		end
	end
end

Events.ActivePlayerTurnStart.Add( RefreshUnitFlagPromotionsGlobally )

LuaEvents.ToggleDisplayFlagPromotions.Add(
	function(bIsChecked)
		bDisplayAllFlagPromotions = bIsChecked
		RefreshUnitFlagPromotionsGlobally()
	end)

LuaEvents.UpdateIgnoredFlagPromotions.Add( 
	function()
		log:Info("OnUpdateIgnoredFlagPromotions"..tostring(bDisplayAllFlagPromotions))
		updateIgnoredPromotions()
		RefreshUnitFlagPromotionsGlobally()
	end)

---------------------------------------
-- End FlagPromotions v.2 by Erendir
---------------------------------------


log:Info("Loading UnitFlagManager_addin.lua I")