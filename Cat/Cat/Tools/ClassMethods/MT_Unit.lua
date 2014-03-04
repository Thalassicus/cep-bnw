-- MT_Unit
-- Author: Thalassicus
-- DateCreated: 2/29/2012 8:19:32 AM
--------------------------------------------------------------

include("MT_LuaLogger.lua")
include("MT_Events.lua")
local log = Events.LuaLogger:New()
log:SetLevel("WARN")



---------------------------------------------------------------------
--[[ Unit_GetClass(unit) usage example:

]]
function Unit_GetClass(unit)
	return GameInfo.Units[unit:GetUnitType()].Class
end

---------------------------------------------------------------------
--[[ Unit_GetMaintenance(unit) usage example:

]]
function Unit_GetMaintenance(unitType)
	return GameInfo.Units[unitType].ExtraMaintenanceCost --* 0.01 * Game.GetSpeedInfo().GoldPercent
end
----------------------------------------------------------------
--[[ Unit_IsCombatDomain(unit, domain) usage example:
if Unit_IsCombatDomain(unit, "DOMAIN_LAND") then
	return unit
end
]]
function Unit_IsCombatDomain(unit, domain)
	return unit and unit:IsCombatUnit() and unit:GetDomainType() == DomainTypes[domain]
end

----------------------------------------------------------------
--[[ Unit_IsWorker(pUnit) usage example:

]]
function Unit_IsWorker(pUnit)
	if (pUnit:WorkRate() > 0 and not pUnit:IsCombatUnit() and pUnit:GetDomainType() == DomainTypes.DOMAIN_LAND and pUnit:GetSpecialUnitType() == -1) then
		return true
	else
		return false
	end	
end



----------------------------------------------------------------
--[[ Unit_CanUpgrade(unit, newID, goldMin) usage example:

local newID = unit:GetUpgradeUnitType()
if Unit_CanUpgrade(unit, newID, goldMin) then
	Unit_Replace(unit, GameInfo.Units[newID].Class)
end
]]

function Unit_CanUpgrade(unit, newID, goldMin)
	newID = newID or unit:GetUpgradeUnitType()
	local player = Players[unit:GetOwner()]
	local itemInfo = GameInfo.Units[newID]
		
	if not newID or newID == -1 then
		log:Debug("                        %25s %-15s cannot upgrade", newID, unit:GetName())
		return false
	elseif (unit:GetPlot():GetOwner() ~= unit:GetOwner()) then
		log:Debug("                        %25s %-15s not on owned land", newID, unit:GetName())
		return false
	elseif goldMin and player:IsBudgetGone(goldMin + unit:UpgradePrice(newID), itemInfo.ExtraMaintenanceCost) then
		log:Debug("                        %25s %-15s upgrade too expensive", newID, unit:GetName())
		return false
	elseif itemInfo.PrereqTech and not player:HasTech(itemInfo.PrereqTech) then
		log:Debug("                        %25s %-15s does not have tech", newID, unit:GetName())
		return false
	end

	local activePlayer = Players[Game.GetActivePlayer()]
	local query = string.format("ResourceClassType <> 'RESOURCECLASS_BONUS' AND ResourceClassType <> 'RESOURCECLASS_LUXURY'")
	for resourceInfo in GameInfo.Resources(query) do
		local resRequired = unit:GetNumResourceNeededToUpgrade(resourceInfo.ID)				
		if (resRequired > 0 and resRequired > activePlayer:GetNumResourceAvailable(resourceInfo.ID)) then
			log:Debug("                        %25s %-15s upgrade needs strategic resource", newID, unit:GetName())
			return false
		end
	end
	
	log:Debug("                        %25s %-15s can upgrade for %sg", unit:GetID(), unit:GetName(), unit:UpgradePrice(newID))
	return true
end

---------------------------------------------------------------------
--[[ Unit_GetXPStored(level) usage example:
local iExperience = Unit_GetXPStored(unit)

-- also available:
-- Unit_GetXPStored(unit)
-- Unit_GetXPNeeded(unit)
-- GetExperienceForLevel(level)
]]

function Unit_GetXPStored(unit)
	return unit:GetExperience() - GetExperienceForLevel(unit:GetLevel())
end

function Unit_GetXPNeeded(unit)
	return unit:ExperienceNeeded() - GetExperienceForLevel(unit:GetLevel())
end

function GetExperienceForLevel(level)
	local xpSum = 0
	for i=1, level-1 do
		xpSum = xpSum + i*GameDefines.EXPERIENCE_PER_LEVEL
	end
	return xpSum
end

---------------------------------------------------------------------
--[[ Unit_Replace(oldUnit, unitClass) usage example:

]]
function Unit_Replace(oldUnit, unitClass)
	MapModData.Cep_ReplacingUnit = true
	local newUnit = Players[oldUnit:GetOwner()]:InitUnitClass(unitClass, oldUnit:GetPlot(), oldUnit:GetExperience())
	MapModData.Cep_ReplacingUnit = false
	for promoInfo in GameInfo.UnitPromotions() do
		if oldUnit:IsHasPromotion(promoInfo.ID) and promoInfo.Class == "PROMOTION_CLASS_PERSISTENT" then
			newUnit:SetHasPromotion(promoInfo.ID, true)
		end
	end
	newUnit:SetEmbarked(oldUnit:IsEmbarked())
	newUnit:SetDamage(oldUnit:GetDamage())
	newUnit:SetLevel(oldUnit:GetLevel())
	newUnit:SetPromotionReady(newUnit:GetExperience() >= newUnit:ExperienceNeeded())
	newUnit:FinishMoves()
	oldUnit:Kill()
	return newUnit
end

---------------------------------------------------------------------
--[[ Unit_ReplaceWithType(oldUnit, unitType) usage example:

]]
function Unit_ReplaceWithType(oldUnit, unitType)
	local newUnit = Players[oldUnit:GetOwner()]:InitUnitType(unitType, oldUnit:GetPlot(), oldUnit:GetExperience())
	for promoInfo in GameInfo.UnitPromotions() do
		if oldUnit:IsHasPromotion(promoInfo.ID) and promoInfo.Class == "PROMOTION_CLASS_PERSISTENT" then
			newUnit:SetHasPromotion(promoInfo.ID, true)
		end
	end
	newUnit:SetDamage(oldUnit:GetDamage())
	newUnit:SetLevel(oldUnit:GetLevel())
	newUnit:SetPromotionReady(newUnit:GetExperience() >= newUnit:ExperienceNeeded())
	newUnit:FinishMoves()
	oldUnit:Kill()
	--LuaEvents.UnitUpgraded(newUnit) --something going wrong here
	return newUnit
end