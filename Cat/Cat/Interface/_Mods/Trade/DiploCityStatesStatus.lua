include("IconSupport")
include("SupportFunctions")
include("InstanceManager")
include("InfoTooltipInclude")

local iGoldGiftLarge  = GameDefines.MINOR_GOLD_GIFT_LARGE
local iGoldGiftMedium = GameDefines.MINOR_GOLD_GIFT_MEDIUM
local iGoldGiftSmall  = GameDefines.MINOR_GOLD_GIFT_SMALL

local gCsIM = InstanceManager:new("CsStatusInstance", "CsBox", Controls.CsStack)

local gSortTable
local sLastSort = "name"
local bReverseSort = false

--local gCsControls

function ShowHideHandler(bIsHide, bIsInit)
  if (not bIsInit and not bIsHide) then
    InitCsList()
  end
end
ContextPtr:SetShowHideHandler(ShowHideHandler)

function InitCsList()
  local iPlayer = Game.GetActivePlayer()
  local pPlayer = Players[iPlayer]
  local iTeam   = pPlayer:GetTeam()
  local pTeam   = Teams[iTeam]

  local iCount = 0

  gCsIM:ResetInstances()
  gCsControls = {}

  gSortTable = {}

  -- Don't include the Barbarians (so -2)
  for iCs = GameDefines.MAX_MAJOR_CIVS, GameDefines.MAX_PLAYERS-2, 1 do
    local pCs = Players[iCs]
    if (pCs:IsAlive() and pTeam:IsHasMet(pCs:GetTeam())) then
      GetCsControl(gCsIM, iCs, iPlayer, bIsFirst)
      iCount = iCount + 1
    end
  end
  
  if (iCount == 0) then
    Controls.CsNoneMetText:SetHide(false)
    Controls.CsScrollPanel:SetHide(true)
  else
    OnSortCs()
    Controls.CsStack:CalculateSize()
    Controls.CsStack:ReprocessAnchoring()
    Controls.CsScrollPanel:CalculateInternalSize()
  end
end

function GetCsControl(im, iCs, iPlayer)
  local pPlayer = Players[iPlayer]
  local iTeam = pPlayer:GetTeam()
  local pTeam = Teams[iTeam]

  local pCs = Players[iCs]
  local sCsTrait = GameInfo.MinorCivilizations[pCs:GetMinorCivType()].MinorCivTrait
        
  local controlTable = im:GetInstance()
  gCsControls[iCs] = controlTable

  local sortEntry = {trait=sCsTrait, name=pCs:GetName()}
  gSortTable[tostring(controlTable.CsBox)] = sortEntry

  -- Trait
  controlTable.CsTraitIcon:SetTexture(GameInfo.MinorCivTraits[sCsTrait].TraitIcon)
  local primaryColor, secondaryColor = pCs:GetPlayerColors()
  controlTable.CsTraitIcon:SetColor({x = secondaryColor.x, y = secondaryColor.y, z = secondaryColor.z, w = 1})

  -- Name
  controlTable.CsName:SetText(pCs:GetName() .. getUnitSpawnFlag(pCs, pPlayer))

  -- CS Button
  controlTable.CsButton:SetVoid1(iCs)
  controlTable.CsButton:RegisterCallback(Mouse.eLClick, OnCsSelected)

  -- Allied with anyone?
  local sAlly, sAllyText = getAlly(pCs, pPlayer)
  controlTable.CsAlly:SetText(sAllyText)
  sortEntry.ally = sAlly
  
  -- Protected by anyone?
  local sProtectingPlayers = getProtectingPlayers(pCs, pPlayer)

  if (sProtectingPlayers ~= "") then
    controlTable.CsProtect:SetText(sProtectingPlayers)
    controlTable.CsProtect:SetToolTipString(Locale.ConvertTextKey("TXT_KEY_DO_CS_STATUS_PROTECT_TT", pCs:GetName(), sProtectingPlayers))
  else
    controlTable.CsProtect:SetText("")
    controlTable.CsProtect:SetToolTipString(Locale.ConvertTextKey("TXT_KEY_DO_CS_STATUS_NO_PROTECT_TT", pCs:GetName()))
  end

  -- Quests
  local sCsQuests, sCsQuestsDesc = getQuests(pCs, pPlayer)

  if (sCsQuests ~= "") then
    controlTable.CsQuest:SetText(sCsQuests)
    controlTable.CsQuest:SetToolTipString(Locale.ConvertTextKey("TXT_KEY_DO_CS_STATUS_QUEST_TT", pCs:GetName(), sCsQuestsDesc))
  else
    controlTable.CsQuest:SetText("")
    controlTable.CsQuest:SetToolTipString(Locale.ConvertTextKey("TXT_KEY_DO_CS_STATUS_NO_QUEST_TT", pCs:GetName()))
  end

  -- Influence
  local iInfluence, sInfluenceText = getInfluence(pCs, pPlayer)
  controlTable.CsInfluence:SetText(sInfluenceText)
  sortEntry.influence = iInfluence

  -- At war?
  setWarPeaceIcon(controlTable.CsWarPeace, pCs, pPlayer, false)

  -- Gold gifts
  setGoldGiftIcons(controlTable, pCs, pPlayer)

  return controlTable
end

function getUnitSpawnFlag(pCs, pPlayer)
  local sFlag = ""
  local iPlayer = pPlayer:GetID()

  if (pCs:GetMinorCivTrait() == MinorCivTraitTypes.MINOR_CIV_TRAIT_MILITARISTIC) then
    if (pCs:IsFriends(iPlayer)) then
      if (pCs:IsMinorCivUnitSpawningDisabled(iPlayer)) then
        -- Unit spawning is off
        sFlag = " [ICON_TEAM_2]"
      else
        -- Unit spawning is on
        sFlag = " [ICON_TEAM_4]"
      end
    end
  end

  return sFlag
end

function getAlly(pCs, pPlayer)
  local sAlly, sAllyText

  if (pCs:IsAllies(iPlayer)) then
    sAlly = Locale.ConvertTextKey("TXT_KEY_YOU")
    sAllyText = "[COLOR_POSITIVE_TEXT]" .. sAlly .. "[ENDCOLOR]"
  else
    local iAlly = pCs:GetAlly() or -1

    if (iAlly ~= -1) then
      sAlly = Locale.ConvertTextKey(Players[iAlly]:GetCivilizationShortDescriptionKey())
      sAllyText = sAlly
    else
      sAlly = ""
      sAllyText = Locale.ConvertTextKey("TXT_KEY_CITY_STATE_NOBODY")
    end
  end

  return sAlly, sAllyText
end

function getProtectingPlayers(pCs, pPlayer)
  local sProtecting = ""
  local iCs = pCs:GetID()
  local iPlayer = pPlayer:GetID()
  
  for iCivPlayer = 0, GameDefines.MAX_MAJOR_CIVS-1, 1 do
    pCivPlayer = Players[iCivPlayer]

    if (pCivPlayer:IsAlive()) then
      if (pCivPlayer:IsProtectingMinor(iCs)) then

        if (sProtecting ~= "") then
          sProtecting = sProtecting .. ", "
        end

        if (iCivPlayer == iPlayer) then
          sProtecting = sProtecting .. "[COLOR_POSITIVE_TEXT]" .. Locale.ConvertTextKey("TXT_KEY_YOU") .. "[ENDCOLOR]"
        else
          sProtecting = sProtecting .. Locale.ConvertTextKey(Players[iCivPlayer]:GetCivilizationShortDescriptionKey())
        end
      end
    end
  end

  return sProtecting
end

function getQuests(pCs, pPlayer)
  local sQuestText = ""
  local pCsTeam = Teams[pCs:GetTeam()]

  -- No quests if at war with player!
  if (not pCsTeam:IsAtWar(pPlayer:GetTeam())) then
    -- At war with any majors?
    local sWarCivs = ""
    for iCivPlayer = 0, GameDefines.MAX_MAJOR_CIVS-1, 1 do
      if (iCivPlayer ~= iPlayer) then
        local pCivPlayer = Players[iCivPlayer]

        if (pCivPlayer:IsAlive()) then
          local iCivTeam = pCivPlayer:GetTeam()
      
          if (pCsTeam:IsAtWar(iCivTeam)) then
            if (pCs:IsMinorWarQuestWithMajorActive(iCivPlayer)) then
              sWarCivs = sWarCivs .. ", " .. Locale.ConvertTextKey(pCivPlayer:GetNameKey())
            end
          end
        end
      end
    end

    if (sWarCivs:len() > 0) then
      sQuestText = sQuestText .. " " .. Locale.ConvertTextKey("TXT_KEY_DO_CS_STATUS_QUEST_WAR_WITH_PLAYERS", sWarCivs:sub(2))
    end
    
    -- Barbarians
    if (pCs:GetTurnsSinceThreatenedByBarbarians() >= 0) then
      sQuestText = sQuestText .. ", " .. Locale.ConvertTextKey("TXT_KEY_DO_CS_STATUS_QUEST_BARBARIANS")
    end
    
    -- Normal Quests
    local iQuest = pCs:GetActiveQuestForPlayer(iPlayer)
    local iQuestData1 = pCs:GetQuestData1(iPlayer)
    
    if (iQuest == MinorCivQuestTypes.MINOR_CIV_QUEST_ROUTE) then
      sQuestText = sQuestText .. ", " .. Locale.ConvertTextKey("TXT_KEY_DO_CS_STATUS_QUEST_ROUTE")
    elseif (iQuest == MinorCivQuestTypes.MINOR_CIV_QUEST_KILL_CAMP) then
      sQuestText = sQuestText .. ", " .. Locale.ConvertTextKey("TXT_KEY_DO_CS_STATUS_QUEST_KILL_CAMP")
    elseif (iQuest == MinorCivQuestTypes.MINOR_CIV_QUEST_CONNECT_RESOURCE) then
      sQuestText = sQuestText .. ", " .. Locale.ConvertTextKey("TXT_KEY_DO_CS_STATUS_QUEST_CONNECT_RESOURCE", GameInfo.Resources[iQuestData1].Description)
    elseif (iQuest == MinorCivQuestTypes.MINOR_CIV_QUEST_CONSTRUCT_WONDER) then
      sQuestText = sQuestText .. ", " .. Locale.ConvertTextKey("TXT_KEY_DO_CS_STATUS_QUEST_CONSTRUCT_WONDER", GameInfo.Buildings[iQuestData1].Description)
    elseif (iQuest == MinorCivQuestTypes.MINOR_CIV_QUEST_GREAT_PERSON) then
      sQuestText = sQuestText .. ", " .. Locale.ConvertTextKey("TXT_KEY_DO_CS_STATUS_QUEST_GREAT_PERSON", GameInfo.Units[iQuestData1].Description)
    elseif (iQuest == MinorCivQuestTypes.MINOR_CIV_QUEST_KILL_CITY_STATE) then
      sQuestText = sQuestText .. ", " .. Locale.ConvertTextKey("TXT_KEY_DO_CS_STATUS_QUEST_KILL_CITY_STATE", Players[iQuestData1]:GetNameKey())
    elseif (iQuest == MinorCivQuestTypes.MINOR_CIV_QUEST_FIND_PLAYER) then
      sQuestText = sQuestText .. ", " .. Locale.ConvertTextKey("TXT_KEY_DO_CS_STATUS_QUEST_FIND_PLAYER", Players[iQuestData1]:GetCivilizationShortDescriptionKey())
    elseif (iQuest == MinorCivQuestTypes.MINOR_CIV_QUEST_FIND_NATURAL_WONDER) then
      sQuestText = sQuestText .. ", " .. Locale.ConvertTextKey("TXT_KEY_DO_CS_STATUS_QUEST_FIND_NATURAL_WONDER")
    end

    if (sQuestText:len() > 0) then
      sQuestText = sQuestText:sub(3)
    end
  end

  return sQuestText, sQuestText
end

function getInfluence(pCs, pPlayer)
  local iPlayer = pPlayer:GetID()
  local iTeam = pPlayer:GetTeam()
  local bWar = Teams[iTeam]:IsAtWar(pCs:GetTeam())
  local iInfluence = pCs:GetMinorCivFriendshipWithMajor(iPlayer)

  local sColour = ""
  local sEndColour = "[ENDCOLOR]"
  if (pCs:IsAllies(iPlayer)) then
    sColour = "[COLOR_CYAN]"
  elseif (pCs:IsFriends(iPlayer)) then
    sColour = "[COLOR_GREEN]"
  elseif (pCs:IsMinorPermanentWar(iTeam) or pCs:IsPeaceBlocked(iTeam) or bWar or (iInfluence < 0)) then
    sColour = "[COLOR_RED]"
  else
    sEndColour = ""
  end

  return iInfluence, sColour .. iInfluence .. sEndColour 
end

function setWarPeaceIcon(pIcon, pCs, pPlayer, bForcePeace)
  local iCs = pCs:GetID()
  local iTeam = pPlayer:GetTeam()
  local pTeam = Teams[iTeam]

  local bWar = not bForcePeace and pTeam:IsAtWar(pCs:GetTeam())
  local bCanMakePeace = (bWar and not pCs:IsPeaceBlocked(iTeam))

  if (bCanMakePeace) then
    pIcon:SetHide(false)
    pIcon:SetText("[ICON_PEACE]")
    pIcon:SetToolTipString(Locale.ConvertTextKey("TXT_KEY_DO_CS_STATUS_PEACE_TT"))

    pIcon:SetVoid1(iCs)
    pIcon:RegisterCallback(Mouse.eLClick, OnMakePeaceSelected)
  elseif (bWar) then
    pIcon:SetHide(false)
    pIcon:SetText("[ICON_WAR]")
    pIcon:SetToolTipString(Locale.ConvertTextKey("TXT_KEY_DO_CS_STATUS_WAR_TT"))

    pIcon:RegisterCallback(Mouse.eLClick, OnIgnore)
  else
    pIcon:SetHide(true)
  end
end

function setGoldGiftIcons(controlTable, pCs, pPlayer)
  local iCs = pCs:GetID()
  local iPlayer = pPlayer:GetID()
  local pTeam = Teams[pPlayer:GetTeam()]
  local iPlayerGold = pPlayer:GetGold()
  local bWar = pTeam:IsAtWar(pCs:GetTeam())

  -- Small Gold
  if (Civup.DISABLE_GOLD_GIFTS ~= 1 and not bWar and iPlayerGold >= iGoldGiftSmall) then
    controlTable.CsGiftSmall:SetHide(false)
    controlTable.CsGiftSmall:SetToolTipString(Locale.ConvertTextKey("TXT_KEY_DO_CS_STATUS_GIFT_INFLUENCE_TT", iGoldGiftSmall, pCs:GetFriendshipFromGoldGift(iPlayer, iGoldGiftSmall)))

    controlTable.CsGiftSmall:SetVoid1(iCs)
    controlTable.CsGiftSmall:SetVoid2(iGoldGiftSmall)
    controlTable.CsGiftSmall:RegisterCallback(Mouse.eLClick, OnGiftSelected)
  else
    controlTable.CsGiftSmall:SetHide(true)
  end

  -- Medium Gold
  if (Civup.DISABLE_GOLD_GIFTS ~= 1 and not bWar and iPlayerGold >= iGoldGiftMedium) then
    controlTable.CsGiftMedium:SetHide(false)
    controlTable.CsGiftMedium:SetToolTipString(Locale.ConvertTextKey("TXT_KEY_DO_CS_STATUS_GIFT_INFLUENCE_TT", iGoldGiftMedium, pCs:GetFriendshipFromGoldGift(iPlayer, iGoldGiftMedium)))

    controlTable.CsGiftMedium:SetVoid1(iCs)
    controlTable.CsGiftMedium:SetVoid2(iGoldGiftMedium)
    controlTable.CsGiftMedium:RegisterCallback(Mouse.eLClick, OnGiftSelected)
  else
    controlTable.CsGiftMedium:SetHide(true)
  end

  -- Large Gold
  if (Civup.DISABLE_GOLD_GIFTS ~= 1 and not bWar and iPlayerGold >= iGoldGiftLarge) then
    controlTable.CsGiftLarge:SetHide(false)
    controlTable.CsGiftLarge:SetToolTipString(Locale.ConvertTextKey("TXT_KEY_DO_CS_STATUS_GIFT_INFLUENCE_TT", iGoldGiftLarge, pCs:GetFriendshipFromGoldGift(iPlayer, iGoldGiftLarge)))

    controlTable.CsGiftLarge:SetVoid1(iCs)
    controlTable.CsGiftLarge:SetVoid2(iGoldGiftLarge)
    controlTable.CsGiftLarge:RegisterCallback(Mouse.eLClick, OnGiftSelected)
  else
    controlTable.CsGiftLarge:SetHide(true)
  end
end


function UpdateCsList(iCs, iSpentGold, bMadePeace)
  local pCs = Players[iCs]

  local iPlayer = Game.GetActivePlayer()
  local pPlayer = Players[iPlayer]

  -- update all the gold gift buttons
  local iPlayerGold = pPlayer:GetGold() - iSpentGold
  for _, csControls in pairs(gCsControls) do
    if (iPlayerGold < iGoldGiftSmall) then
      csControls.CsGiftSmall:SetHide(true)
    end

    if (iPlayerGold < iGoldGiftMedium) then
      csControls.CsGiftMedium:SetHide(true)
    end

    if (iPlayerGold < iGoldGiftLarge) then
      csControls.CsGiftLarge:SetHide(true)
    end
  end

  -- update the CS specific values
  local csControls = gCsControls[iCs]
  if (csControls ~= nil) then
    local sortEntry = gSortTable[tostring(csControls.CsBox)]

    -- Ally
    local sAlly, sAllyText = getAlly(pCs, pPlayer)
    csControls.CsAlly:SetText(sAllyText)
    sortEntry.ally = sAlly

    -- Influence
    local iInfluence, sInfluenceText = getInfluence(pCs, pPlayer)
    csControls.CsInfluence:SetText(sInfluenceText)
    sortEntry.influence = iInfluence

    -- War/Peace
    setWarPeaceIcon(csControls.CsWarPeace, pCs, pPlayer, bMadePeace)
  end

  OnSortCs()

  LuaEvents.DiploShowRefreshButtonEvent()
end

function OnIgnore()
end

function OnCsSelected(iCs)
  local popupInfo = {
    Type = ButtonPopupTypes.BUTTONPOPUP_CITY_STATE_DIPLO,
    Data1 = iCs
  }
    
  Events.SerialEventGameMessagePopup(popupInfo)
  LuaEvents.DiploShowRefreshButtonEvent()
end

function OnMakePeaceSelected(iCs)
  -- It would appear that Network.SendChangeWar() runs asynchronously, so we need to account for making peace
  Network.SendChangeWar(Players[iCs]:GetTeam(), false)
  UpdateCsList(iCs, 0, true)
end

function OnGiftSelected(iCs, iGold)
  -- It would appear that Game.DoMinorGoldGift() runs asynchronously, so we need to account for the spent gold when updating the CS list
  Game.DoMinorGoldGift(iCs, iGold)
  UpdateCsList(iCs, iGold, false)
end


function OnSortCs(sSort)
  if (sSort) then
    if (sLastSort == sSort) then
      bReverseSort = not bReverseSort
    else
      bReverseSort = (sSort == "influence")
    end 

    sLastSort = sSort
  end

  Controls.CsStack:SortChildren(ByMethod)
end


function ByMethod(a, b)
  local entryA = gSortTable[tostring(a)]
  local entryB = gSortTable[tostring(b)]

  local bReverse = bReverseSort

  if ((entryA == nil) or (entryB == nil)) then 
    if ((entryA ~= nil) and (entryB == nil)) then
      if (bReverse) then
        return false
      else
        return true
      end
    elseif ((entryA == nil) and (entryB ~= nil)) then
      if (bReverse) then
        return true
      else
        return false
      end
    else
      -- gotta do something!
      if (bReverse) then
        return (tostring(a) >= tostring(b))
      else
        return (tostring(a) < tostring(b))
      end
    end
  end

  local valueA = entryA[sLastSort]
  local valueB = entryB[sLastSort]

  if (valueA == valueB) then
    valueA = entryA.name
    valueB = entryB.name

    bReverse = false
  end

  if (bReverse) then
    return (valueA >= valueB)
  else
    return (valueA < valueB)
  end
end

function OnSortCsTrait()
  OnSortCs("trait")
end
Controls.SortCsTrait:RegisterCallback(Mouse.eLClick, OnSortCsTrait)

function OnSortCsName()
  OnSortCs("name")
end
Controls.SortCsName:RegisterCallback(Mouse.eLClick, OnSortCsName)

function OnSortCsAlly()
  OnSortCs("ally")
end
Controls.SortCsAlly:RegisterCallback(Mouse.eLClick, OnSortCsAlly)

function OnSortCsInfluence()
  OnSortCs("influence")
end
Controls.SortCsInfluence:RegisterCallback(Mouse.eLClick, OnSortCsInfluence)
