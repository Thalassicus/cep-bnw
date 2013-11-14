--
-- Upgrade Utility functions
--

--
-- Action upgrade functions
--

function GetActionForUpgrade()
  for iAction, action in pairs(GameInfoActions) do
    if (action.Type == "COMMAND_UPGRADE") then
	  return iAction
    end
  end

  return nil
end



function GetUpgradeUnitType(sCivType, sUnitType)
  return GetCivUnitType(sCivType, GetUpgradeUnitClassType(sUnitType))
end

function GetUpgradeUnitClassType(sUnitType)
  local sQuery = "SELECT UnitClassType FROM Unit_ClassUpgrades WHERE UnitType = ?"

  for row in DB.Query(sQuery, sUnitType) do
    return row.UnitClassType
  end

  return nil
end

function GetCivUnitType(sCivType, sUnitClass)
  local sUnitType = nil

  if (sUnitClass ~= nil) then
    if (sCivType ~= nil) then
      local sQuery = "SELECT UnitType FROM Civilization_UnitClassOverrides WHERE CivilizationType = ? AND UnitClassType = ?"
      for row in DB.Query(sQuery, sCivType, sUnitClass) do
        sUnitType = row.UnitType
      end
    end

    if (sUnitType == nil) then
      local sQuery = "SELECT DefaultUnit FROM UnitClasses WHERE Type = ?"
      for row in DB.Query(sQuery, sUnitClass) do
        sUnitType = row.DefaultUnit
      end
    end
  end

  return sUnitType
end

function GetUpgradePath(sCivType, sUnitClassType)
  local path = {}

  local sUnitType = GetCivUnitType(sCivType, sUnitClassType)
  while (sUnitType ~= nil) do
    table.insert(path, sUnitType)

    sUnitType = GetUpgradeUnitType(sCivType, sUnitType)
  end

  return path
end

-- All combat classes that terminate one or more upgrade paths
function GetUpgradeCombatClasses()
  local combatClasses = {}
  local sQuery = "SELECT DISTINCT u.CombatClass FROM Units u, UnitClasses uc WHERE NOT EXISTS (SELECT 1 FROM Unit_ClassUpgrades up where u.Type = up.UnitType) AND u.Type = uc.DefaultUnit AND u.CombatClass NOT NULL AND (u.Combat > 1 OR u.RangedCombat > 0)"

  for row in DB.Query(sQuery) do
    table.insert(combatClasses, row.CombatClass)
  end

  return combatClasses
end

-- All final unit classes for a combat class
function GetFinalUnitClasses(sCombatClass)
  local unitClasses = {}
  local sQuery = "SELECT u.Class FROM Units u, UnitClasses uc WHERE (NOT EXISTS (SELECT 1 FROM Unit_ClassUpgrades up where u.Type = up.UnitType) OR EXISTS (SELECT 1 FROM Unit_ClassUpgrades up, Units upu, UnitClasses upc WHERE u.Type = up.UnitType AND up.UnitClassType = upc.Type AND upc.DefaultUnit = upu.Type AND upu.CombatClass <> u.CombatClass)) AND u.Type = uc.DefaultUnit AND u.CombatClass = ? AND (u.Combat > 1 OR u.RangedCombat > 0) AND u.Cost > 0 ORDER BY u.Cost DESC"

  for row in DB.Query(sQuery, sCombatClass) do
    table.insert(unitClasses, row.Class)
  end

  return unitClasses
end

-- All unit classes that upgrade to the given unit class
function GetPriorUnitClasses(sUnitClass)
  local unitClasses = {}
  local sQuery = "SELECT uc.Type FROM UnitClasses uc, Unit_ClassUpgrades up, Units u WHERE up.UnitClassType = ? AND up.UnitType = uc.DefaultUnit AND up.UnitType = u.Type AND u.Cost > 0 ORDER BY u.Cost DESC"

  for row in DB.Query(sQuery, sUnitClass) do
    table.insert(unitClasses, row.Type)
  end

  return unitClasses
end

function GetDefaultUnit(sUnitClass)
  return GameInfo.UnitClasses[sUnitClass].DefaultUnit
end

function GetUniqueUnits(sUnitClass)
  local units = {}
  local sQuery = "SELECT UnitType FROM Civilization_UnitClassOverrides WHERE UnitClassType = ?"

  for row in DB.Query(sQuery, sUnitClass) do
    table.insert(unitClasses, row.UnitType)
  end

  return unitClasses
end

function CanUpgrade(pUnit, sUnitType)
  return (pUnit:CanUpgradeRightNow() and pUnit:GetUpgradeUnitType() == GameInfoTypes[sUnitType])
end

function HasFreePromotion(sUnit, sPromotion)
  for fp in GameInfo.Unit_FreePromotions{UnitType=sUnit, PromotionType=sPromotion} do
    return true
  end

  return false
end

function IsIgnoreTerrain(sUnit)
  return HasFreePromotion(sUnit, "PROMOTION_IGNORE_TERRAIN_COST")
end

function IsRoughTerrain(sUnit)
  return HasFreePromotion(sUnit, "PROMOTION_ROUGH_TERRAIN_ENDS_TURN")
end

function IsFollowUp(sUnit)
  return HasFreePromotion(sUnit, "PROMOTION_CAN_MOVE_AFTER_ATTACKING")
end

function IsSetup(sUnit)
  return HasFreePromotion(sUnit, "PROMOTION_MUST_SET_UP")
end

function IsIndirectFire(sUnit)
  return HasFreePromotion(sUnit, "PROMOTION_INDIRECT_FIRE")
end

function IsImmobile(sUnit)
  return GameInfo.Units[sUnit].Immobile
end

function GetRequirements(sUnit, pUnit)
  local sReqs = ""
  local sPostfix = ""
  local sPrefix = ""

  sPrefix = sPostfix .. "Resources: "
  for r in GameInfo.Unit_ResourceQuantityRequirements{UnitType=sUnit} do
    local iResource = GameInfoTypes[r.ResourceType]

    if (pUnit == nil or pUnit:GetNumResourceNeededToUpgrade(iResource) > Players[pUnit:GetOwner()]:GetNumResourceAvailable(iResource)) then
      sReqs = sReqs .. sPrefix .. GameInfo.Resources[r.ResourceType].IconString
      if (r.Cost > 1) then
        sReqs = sreqs .. string.format("(%i)", r.Cost)
      end
      sPrefix = ", "
      sPostfix = "[NEWLINE]"
    end
  end

  if (pUnit == nil) then
    sPrefix = sPostfix .. "Buildings: "
    for b in GameInfo.Unit_BuildingClassRequireds{UnitType=sUnit} do
      sReqs = sReqs .. sPrefix .. Locale.ConvertTextKey(GameInfo.BuildingClasses[b.BuildingClassType].Description)
      sPrefix = ", "
      sPostfix = "[NEWLINE]"
    end
  end

  if (GameInfo.Units[sUnit].ProjectPrereq ~= nil) then
    local project = GameInfo.Projects[GameInfo.Units[sUnit].ProjectPrereq]

    if (pUnit == nil or Teams[Players[pUnit:GetOwner()]:GetTeam()]:GetProjectCount(project.ID) > 0) then
      sReqs = sreqs .. sPostfix .. "Project: " .. Locale.ConvertTextKey(project.Description)
      sPrefix = ", "
      sPostfix = "[NEWLINE]"
	end
  end

  return sReqs
end