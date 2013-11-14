--
-- Promotion Utility functions
--

--
-- Unit promotion functions
--

function HasPromotion(pUnit, iPromotion)
  return (pUnit and pUnit:IsHasPromotion(iPromotion))
end

function CanAcquirePromotion(pUnit, iPromotion)
  if (pUnit and pUnit:CanAcquirePromotion(iPromotion)) then
    local iAction = GetActionForPromotion(iPromotion)
	return (iAction and Game.CanHandleAction(iAction))
  end

  return false
end


--
-- Action promotion functions
--

function GetActionForPromotion(iPromotion)
  local promotion = GameInfo.UnitPromotions[iPromotion]

  for iAction, action in pairs(GameInfoActions) do
    if (action.SubType == ActionSubTypes.ACTIONSUBTYPE_PROMOTION and action.Type == promotion.Type) then
	  return iAction
    end
  end

  return nil
end


--
-- Promotions database lookup functions
--
local sMatchRank = "_[0-9I]+$"

function IsRankedPromotion(sPromotion)
  return (sPromotion:match(sMatchRank) ~= nil)
end

function GetPromotionBase(sPromotion)
  if (not IsRankedPromotion(sPromotion)) then
    return sPromotion
  end

  local sRank = sPromotion:match(sMatchRank)
  return sPromotion:sub(1, sPromotion:len()-sRank:len())
end

function GetNextPromotion(sPromotion)
  if (not IsRankedPromotion(sPromotion)) then
    return nil
  end

  local sBase = GetPromotionBase(sPromotion)

  local promotions = {}
  local sQuery = "SELECT p2.Type FROM UnitPromotions p1, UnitPromotions p2 WHERE p1.Type = ? AND (p1.Type = p2.PromotionPrereqOr1 OR p1.Type = p2.PromotionPrereqOr2 OR p1.Type = p2.PromotionPrereqOr3 OR p1.Type = p2.PromotionPrereqOr4 OR p1.Type = p2.PromotionPrereqOr5 OR p1.Type = p2.PromotionPrereqOr6) AND p2.Type LIKE ?"
  for row in DB.Query(sQuery, sPromotion, sBase .. "%") do
    table.insert(promotions, row.Type)
  end

  return promotions[1]
end

function GetPromotionChain(sPromotion)
  local promotions = {}

  repeat
	table.insert(promotions, sPromotion)

	sPromotion = GetNextPromotion(sPromotion)
  until (sPromotion == nil)

  return promotions
end

function GetBasicPromotions(sCombatClass)
  local promotions = {}

  local sQuery = "SELECT p.Type FROM UnitPromotions p, UnitPromotions_UnitCombats c WHERE c.UnitCombatType = ? AND c.PromotionType = p.Type AND p.PromotionPrereqOr1 IS NULL AND NOT p.CannotBeChosen"
  for row in DB.Query(sQuery, sCombatClass) do
    if (IsRankedPromotion(row.Type)) then
      table.insert(promotions, row.Type)
	end
  end

  return promotions
end

function GetBasePromotions(sCombatClass)
  local promotions = {}

  for _, sPromotion in ipairs(GetBasicPromotions(sCombatClass)) do
	table.insert(promotions, GetPromotionChain(sPromotion))
  end

  return promotions
end

function GetDependentPromotions(sCombatClass, sPromotion)
  local promotions = {}

  if (IsRankedPromotion(sPromotion)) then
    local sBase = GetPromotionBase(sPromotion)

    local sQuery = "SELECT p2.Type FROM UnitPromotions p1, UnitPromotions p2, UnitPromotions_UnitCombats c WHERE p1.Type = ? AND (p1.Type = p2.PromotionPrereqOr1 OR p1.Type = p2.PromotionPrereqOr2 OR p1.Type = p2.PromotionPrereqOr3 OR p1.Type = p2.PromotionPrereqOr4 OR p1.Type = p2.PromotionPrereqOr5 OR p1.Type = p2.PromotionPrereqOr6) AND p2.Type = c.PromotionType AND c.UnitCombatType = ? AND p2.Type NOT LIKE ?"
    for row in DB.Query(sQuery, sPromotion, sCombatClass, sBase .. "%") do
      table.insert(promotions, GetPromotionChain(row.Type))
    end
  end

  return promotions
end
