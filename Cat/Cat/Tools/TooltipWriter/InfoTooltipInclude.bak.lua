-------------------------------------------------
-- Help text for Info Objects (Units, Buildings, etc.)
-------------------------------------------------

-- Changes to this file were made by Thalassicus, primarily for the AutoTips and YieldLibrary modules of the Civ 5 Unofficial Patch.

include( "YieldLibrary.lua" )

if Game == nil then
	--print("InfoTooltipInclude.lua: Game == nil")
	return
end

local log = Events.LuaLogger:New()
log:SetLevel("WARN")

local timeStart = os.clock()

Game.Fields				= Game.Fields or {}
Game.Fields.Units		= Game.Fields.Units or {}
Game.Fields.Buildings	= Game.Fields.Buildings or {}


-- UNIT
function GetHelpTextForUnit(unitID, bIncludeRequirementsInfo)
	local unitInfo = GameInfo.Units[unitID]
	local unitClassInfo = GameInfo.UnitClasses[unitInfo.Class]
	
	local activePlayer = Players[Game.GetActivePlayer()]
	local activeTeam = Teams[Game.GetActiveTeam()]

	local textBody = ""
	local fieldTextKey = ""
	
	-- Name
	local textName = Locale.ConvertTextKey(unitInfo.Description)
	if os.date and (os.date("%d/%m") == "01/04") then
		textName = string.format("%s %s", Locale.ConvertTextKey("TXT_KEY_APRIL_FOOLS"), textName)
	end
	textBody = textBody .. Locale.ToUpper(textName)
	
	-- Pre-written Help text
	if unitInfo.Help then
		local textHeader = Locale.ConvertTextKey( unitInfo.Help )
		if textHeader and textHeader ~= "" then
			textBody = textBody .. "[NEWLINE]----------------"
			textBody = textBody .. "[NEWLINE]" .. textHeader
		end	
	end
	
	-- Value
	textBody = textBody .. "[NEWLINE]----------------"		
	if Cep.SHOW_GOOD_FOR_UNITS == 1 then
		textBody = textBody .. Game.GetFlavors("Unit_Flavors", "UnitType", unitInfo.Type)
	end
	
	
	--
	-- Abilities
	--
	
	textBody = string.format("%s[NEWLINE][NEWLINE]%s", textBody, Locale.ConvertTextKey("TXT_KEY_TOOLTIP_ABILITIES"))
	
	-- Promotions
	local footerRangedStrength	= ""
	local footerStrength		= ""
	local footerMoves			= ""
	local footerEnd				= ""
	for row in GameInfo.Unit_FreePromotions{UnitType = unitInfo.Type} do
		local promoInfo = GameInfo.UnitPromotions[row.PromotionType]
		if promoInfo.Class ~= "PROMOTION_CLASS_ATTRIBUTE_NEGATIVE" then
			local promoText = Locale.ConvertTextKey(promoInfo.Help)	
			if string.find(promoText, "^.ICON_RANGE_STRENGTH") then
				footerRangedStrength = footerRangedStrength .. "[NEWLINE]" .. promoText
			elseif string.find(promoText, ".ICON_STRENGTH.([^%%]*%% vs)") then
				footerStrength = footerStrength .. "[NEWLINE]" .. promoText
				footerRangedStrength = footerRangedStrength .. "[NEWLINE]" .. string.gsub(promoText, ".ICON_STRENGTH.([^%%]*%% vs)", function(x) return "[ICON_RANGE_STRENGTH]"..x end)
			elseif string.find(promoText, "^.ICON_STRENGTH") then
				footerStrength = footerStrength .. "[NEWLINE]" .. promoText
			elseif string.find(promoText, "^.ICON_MOVES") then
				footerMoves = footerMoves .. "[NEWLINE]" .. promoText
			else
				footerEnd = footerEnd .. "[NEWLINE]" .. promoText
			end
		end
	end
	
	-- Range
	local iRange = unitInfo.Range
	if (iRange ~= 0) then
		textBody = textBody .. "[NEWLINE]"
		textBody = textBody .. Locale.ConvertTextKey("TXT_KEY_PRODUCTION_RANGE", iRange)
	end
	
	-- Ranged Strength
	local iRangedStrength = unitInfo.RangedCombat
	if (iRangedStrength ~= 0) then
		textBody = textBody .. "[NEWLINE]"
		textBody = textBody .. Locale.ConvertTextKey("TXT_KEY_PRODUCTION_RANGED_STRENGTH", iRangedStrength) .. footerRangedStrength
	end
	
	-- Strength
	local iStrength = unitInfo.Combat
	if (iStrength ~= 0) then
		textBody = textBody .. "[NEWLINE]"
		textBody = textBody .. Locale.ConvertTextKey("TXT_KEY_PRODUCTION_STRENGTH", iStrength) .. footerStrength
	end
	
	-- Moves
	textBody = textBody .. "[NEWLINE]"
	textBody = textBody .. Locale.ConvertTextKey("TXT_KEY_PRODUCTION_MOVEMENT", unitInfo.Moves)
	textBody = textBody .. footerMoves	
	textBody = textBody .. footerEnd
	
	-- Special Abilities
	if unitInfo.WorkRate ~= 0 then
		textBody = textBody .. "[NEWLINE]" .. Locale.ConvertTextKey("TXT_KEY_PRODUCTION_UNIT_WORK_RATE", unitInfo.WorkRate)		
	end
	if unitInfo.Found then
		textBody = textBody .. "[NEWLINE]" .. Locale.ConvertTextKey("TXT_KEY_PRODUCTION_UNIT_FOUND")		
	end
	if unitInfo.Food then
		textBody = textBody .. "[NEWLINE]" .. Locale.ConvertTextKey("TXT_KEY_PRODUCTION_UNIT_FOOD")		
	end
	if unitInfo.SpecialCargo then
		textBody = textBody .. "[NEWLINE]" .. Locale.ConvertTextKey("TXT_KEY_PRODUCTION_UNIT_CARGO", "TXT_KEY_" .. unitInfo.SpecialCargo)
	end
	if unitInfo.Suicide then
		textBody = textBody .. "[NEWLINE]" .. Locale.ConvertTextKey("TXT_KEY_PRODUCTION_UNIT_SUICIDE")		
	end
	if unitInfo.NukeDamageLevel >= 1 then
		textBody = textBody .. "[NEWLINE]" .. Locale.ConvertTextKey("TXT_KEY_PRODUCTION_UNIT_NUKE_RADIUS", unitInfo.NukeDamageLevel)		
	end
	
	-- Replaces
	local defaultObjectType = unitClassInfo.DefaultUnit
	if unitInfo.Type ~= defaultObjectType then
		textBody = textBody .. "[NEWLINE]"
		textBody = textBody .. Locale.ConvertTextKey("TXT_KEY_BUILDING_EFFECT_REPLACES", GameInfo.Units[defaultObjectType].Description)
	end
	
	
	--
	-- Requirements
	--
	
	textBody = string.format("%s[NEWLINE][NEWLINE]%s", textBody, Locale.ConvertTextKey("TXT_KEY_TOOLTIP_REQUIREMENTS"))
	
	-- Cost
	local cost = activePlayer:GetUnitProductionNeeded(unitID)
	if unitID == GameInfo.Units.UNIT_SETTLER.ID then
		cost = Game.Round(cost * Cep.UNIT_SETTLER_BASE_COST / 105, -1)
	end
	textBody = textBody .. "[NEWLINE]" .. Locale.ConvertTextKey("TXT_KEY_PRODUCTION_COST", cost)
	
	-- Purchase Cost Multiplier
	local costMultiplier = nil
	if unitInfo.HurryCostModifier ~= -1 then
		costMultiplier = math.pow(cost * GameDefines.GOLD_PURCHASE_GOLD_PER_PRODUCTION, GameDefines.HURRY_GOLD_PRODUCTION_EXPONENT)
		costMultiplier = costMultiplier * (100 + unitInfo.HurryCostModifier)
		costMultiplier = Game.Round(Game.RoundDown(costMultiplier) / cost, -1)
		textBody = textBody .. "[NEWLINE]" .. Locale.ConvertTextKey("TXT_KEY_PRODUCTION_UNIT_HURRY_COST_MODIFIER", costMultiplier, costMultiplier)
	end
	
	-- add help text for how much a new city would cost when looking at a settler
	if (activePlayer.CalcNextCityMaintenance ~= nil) and (unitInfo.Type == "UNIT_SETTLER") and (Unit_GetMaintenance(unitInfo.ID) > 0) then
		textBody = textBody .. "[NEWLINE][NEWLINE]"..Locale.ConvertTextKey("TXT_KEY_NEXT_CITY_SETTLER_MAINTENANCE_TEXT",activePlayer:CalcNextCityMaintenance() or 0)
	end
	
	if Unit_GetMaintenance(unitID) > 0 then
		textBody = textBody .. "[NEWLINE]" .. Locale.ConvertTextKey("TXT_KEY_PRODUCTION_UNIT_MAINTENANCE", Unit_GetMaintenance(unitInfo.ID))
	end
	
	-- Requirements
	if (bIncludeRequirementsInfo) then
		if (unitInfo.Requirements) then
			textBody = textBody .. Locale.ConvertTextKey( unitInfo.Requirements )
		end
	end
	
	if unitInfo.ProjectPrereq then
		local projectName = GameInfo.Projects[unitInfo.ProjectPrereq].Description
		textBody = textBody .. "[NEWLINE]" .. Locale.ConvertTextKey("TXT_KEY_BUILDING_EFFECT_REQUIRES_BUILDING", projectName)		
	end
	
	-- Tech prerequisites
	fieldTextKey = "TXT_KEY_BUILDING_EFFECT_REQUIRES_BUILDING"
	for pEntry in GameInfo.Unit_TechTypes{UnitType = unitInfo.Type} do
		local entryValue = Locale.ConvertTextKey(GameInfo.Technologies[pEntry.TechType].Description)
		textBody = textBody .. "[NEWLINE]" .. Locale.ConvertTextKey(fieldTextKey, entryValue)
	end
	
	-- Obsolescence
	local pObsolete = unitInfo.ObsoleteTech
	if pObsolete ~= nil and pObsolete ~= "" then
		pObsolete = Locale.ConvertTextKey(GameInfo.Technologies[pObsolete].Description)
		textBody = textBody .. "[NEWLINE]"
		textBody = textBody .. Locale.ConvertTextKey("TXT_KEY_PRODUCTION_UNIT_OBSOLETE_TECH", pObsolete)
	end
	
	-- Limit
	local unitLimit = unitClassInfo.MaxPlayerInstances
	if unitLimit ~= -1 then
		textBody = textBody .. "[NEWLINE]"
		textBody = textBody .. Locale.ConvertTextKey("TXT_KEY_BUILDING_EFFECT_NATIONAL_LIMIT", "", "", unitLimit)
	end
	unitLimit = unitClassInfo.MaxTeamInstances
	if unitLimit ~= -1 then
		textBody = textBody .. "[NEWLINE]"
		textBody = textBody .. Locale.ConvertTextKey("TXT_KEY_BUILDING_EFFECT_TEAM_LIMIT", "", "", unitLimit)
	end
	unitLimit = unitClassInfo.MaxGlobalInstances
	if unitLimit ~= -1 then
		textBody = textBody .. "[NEWLINE]"
		textBody = textBody .. Locale.ConvertTextKey("TXT_KEY_BUILDING_EFFECT_WORLD_LIMIT", "", "", unitLimit)
	end
	
	-- Resource Requirements
	local iNumResourcesNeededSoFar = 0
	local iNumResourceNeeded
	local iResourceID
	for pResource in GameInfo.Resources() do
		iResourceID = pResource.ID
		iNumResourceNeeded = Game.GetNumResourceRequiredForUnit(unitID, iResourceID)
		if (iNumResourceNeeded > 0) then
			-- First resource required
			if (iNumResourcesNeededSoFar == 0) then
				textBody = textBody .. "[NEWLINE]"
				textBody = textBody .. Locale.ConvertTextKey("TXT_KEY_PRODUCTION_RESOURCES_REQUIRED")
				textBody = textBody .. " " .. iNumResourceNeeded .. " " .. pResource.IconString .. " " .. Locale.ConvertTextKey(pResource.Description)
			else
				textBody = textBody .. ", " .. iNumResourceNeeded .. " " .. pResource.IconString .. " " .. Locale.ConvertTextKey(pResource.Description)
			end
			
			-- JON: Not using this for now, the formatting is better when everything is on the same line
			--iNumResourcesNeededSoFar = iNumResourcesNeededSoFar + 1
		end
 	end
	
	return textBody	
end


-- BUILDING

-- Deprecated vanilla function
function GetHelpTextForBuilding(iBuildingID, bExcludeName, bExcludeHeader, bNoMaintenance, pCity)
	return GetBuildingTip{buildingID=iBuildingID, hideName=(bExcludeName or bExcludeHeader), hideCosts=bExcludeHeader, buildingCity=pCity}
end

function GetBuildingTip(param)
	-- Optional parameters: buildingCity, hideName, hideGoodFor, hideAbilities, hideCosts, hideFoot
	
	if Game == nil then
		print("GetHelpTextForBuilding: Game does not exist")
		return ""
	end
	if not Game.InitializedFields then
		return ""
	end
	if not param.buildingID	 then
		log:Fatal("GetHelpTextForBuilding: buildingID is nil")
	end
	
	local buildingID	= param.buildingID	
	local buildingInfo	= GameInfo.Buildings[buildingID]
	local textList		= {}
	local textBody		= ""
	local textFoot		= ""
	local city			= param.buildingCity
	local showName		= not param.hideName
	local showGood		= not param.hideGoodFor
	local showAbil		= not param.hideAbilities
	local showCost		= not param.hideCosts
	local showFoot		= not param.hideCosts
	local showSection	= {	
		[0] = showName,
		[1] = showAbil,
		[2] = showAbil,
		[3] = showAbil,
		[4] = showAbil,
		[5] = showCost
	}
	
	if Cep.SHOW_GOOD_FOR_BUILDINGS == 1 and showGood and not showName and not showAbil and not showCost then
		return string.gsub(Game.GetFlavors("Building_Flavors", "BuildingType", buildingInfo.Type, 1, true), "^%[NEWLINE%]", "")
	end

	if Game.Fields.Buildings[buildingID] == nil then
		log:Warn("GetHelpTextForBuilding: field data is nil for %s!", buildingInfo.Type)
		return ""
	elseif Game.Fields.Buildings[buildingID] == {} then
		log:Warn("GetHelpTextForBuilding: field data is empty table for %s!", buildingInfo.Type)
		return ""
	end
	
	if showFoot and buildingInfo.AlwaysShowHelp and buildingInfo.Help and buildingInfo.Help ~= "" then
		textFoot = Locale.ConvertTextKey(buildingInfo.Help)
	end
	
	-- main loop
	for _, field in pairs(Game.Fields.Buildings[buildingID]) do		
		if field.Dynamic then
			for _, subField in pairs(field.Value(buildingID, field.Type, field.Section, field.Priority, field.Value, city)) do
				if subField.Section and subField.Priority and subField.TextBody then
					if showSection[subField.Section] then
						table.insert(textList, {Section=subField.Section, Priority=subField.Priority, TextBody=subField.TextBody, TextFoot=subField.TextFoot})
					end
				else
					log:Error("GetHelpTextForBuilding %s Field %s SubField %s section=%s priority=%s textBody=%s", buildingInfo.Type, field.Type, subField.Type, subField.Section, subField.Priority, subField.TextBody)
				end
			end
		elseif type(field.TextBody) == "string" then
			if field.Section and field.Priority and field.TextBody then
				if showSection[field.Section] then
					table.insert(textList, {Section=field.Section, Priority=field.Priority, TextBody=field.TextBody, TextFoot=field.TextFoot})
				end
			else
				log:Error("GetHelpTextForBuilding %s Field %s section=%s priority=%s textBody=%s", buildingInfo.Type, field.Type, field.Section, field.Priority, field.TextBody)				
			end
		end
	end
		
	table.sort(textList, function (a,b)
		if a.Section ~= b.Section then
			return a.Section < b.Section
		elseif a.Priority ~= b.Priority then
			return a.Priority > b.Priority
		end
		return a.TextBody < b.TextBody
	end)
	
	local section = 0
	for _, field in ipairs(textList) do
		if section < 1 and field.Section >= 1 then			
			-- flavor section
			if showName then
				textBody = textBody .. "[NEWLINE]----------------"
			end
			if Cep.SHOW_GOOD_FOR_BUILDINGS == 1 and showGood then
				local textFlavors = Game.GetFlavors("Building_Flavors", "BuildingType", buildingInfo.Type)
				if textFlavors ~= "" then
					textBody = textBody .. textFlavors .. "[NEWLINE]"
				end
			end
			
			-- ability section
			if (showName or showGood) and showAbil then
				textBody = string.format("%s[NEWLINE]%s", textBody, Locale.ConvertTextKey("TXT_KEY_TOOLTIP_ABILITIES"))
			end
		end
		if section < 5 and field.Section >= 5 and (showName or showGood) and showCost then
			-- requirements section
			textBody = string.format("%s[NEWLINE][NEWLINE]%s", textBody, Locale.ConvertTextKey("TXT_KEY_TOOLTIP_REQUIREMENTS"))
		end
		
		section = field.Section
		
		if field.TextBody then
			textBody = textBody .. "[NEWLINE]" .. field.TextBody
			if field.Type == "Name" and buildingInfo.BuildingClass == "BUILDINGCLASS_PALACE" and GameDefines.GEM_VERSION and GameDefines.GEM_VERSION > 0 then
				field.TextBody = field.TextBody .. " - " .. Locale.ConvertTextKey("TXT_KEY_GEM_VERSION", GameDefines.GEM_VERSION)
			end
		end
		if showFoot and field.TextFoot then
			textFoot = textFoot .. "[NEWLINE][NEWLINE]" .. field.TextFoot
		end
	end
	
	textBody = string.gsub(textBody, "^%[NEWLINE%]", "")
	textFoot = string.gsub(textFoot, "^%[NEWLINE%]", "")
	textFoot = string.gsub(textFoot, "^%[NEWLINE%]", "")
	
	if showFoot and textFoot ~= "" then
		textBody = textBody .. "[NEWLINE]----------------[NEWLINE]"
		textBody = textBody .. textFoot
	end
	
	if textBody == nil or textBody == "" then
		if showAbilities then
			log:Error("GetHelpTextForBuilding: %s textBody is %s for Abilities", buildingInfo.Type, textBody)
		elseif showGoodFor then
			log:Error("GetHelpTextForBuilding: %s textBody is %s for GoodFor", buildingInfo.Type, textBody)
		elseif showCosts then
			log:Error("GetHelpTextForBuilding: %s textBody is %s for Costs", buildingInfo.Type, textBody)
		end
		textBody = "Error: failed to build tooltip!"
	end
	return textBody
end



-- IMPROVEMENT
function GetHelpTextForImprovement(iImprovementID, hideName, showOnlyAbilities, hideMaintenance)
	local pImprovementInfo = GameInfo.Improvements[iImprovementID]
	
	local activePlayer = Players[Game.GetActivePlayer()]
	local activeTeam = Teams[Game.GetActiveTeam()]
	
	local textFoot = ""
	
	if (not showOnlyAbilities) then
		
		if (not hideName) then
			-- Name
			textFoot = textFoot .. Locale.ToUpper(Locale.ConvertTextKey( pImprovementInfo.Description ))
			textFoot = textFoot .. "[NEWLINE]----------------[NEWLINE]"
		end
				
	end
		
	-- if we end up having a lot of these we may need to add some more stuff here
	
	-- Pre-written Help text
	if (pImprovementInfo.Help ~= nil) then
		local textHeader = Locale.ConvertTextKey( pImprovementInfo.Help )
		if (textHeader ~= nil and textHeader ~= "") then
			-- Separator
			-- textFoot = textFoot .. "[NEWLINE]----------------[NEWLINE]"
			textFoot = textFoot .. textHeader
		end
	end
	
	return textFoot
	
end


-- PROJECT
function GetHelpTextForProject(iProjectID, bIncludeRequirementsInfo)
	local pProjectInfo = GameInfo.Projects[iProjectID]
	
	local activePlayer = Players[Game.GetActivePlayer()]
	local activeTeam = Teams[Game.GetActiveTeam()]
	
	local textFoot = ""
	
	-- Name
	textFoot = textFoot .. Locale.ToUpper(Locale.ConvertTextKey( pProjectInfo.Description ))
	
	-- Cost
	local iCost = activePlayer:GetProjectProductionNeeded(iProjectID)
	textFoot = textFoot .. "[NEWLINE]----------------[NEWLINE]"
	textFoot = textFoot .. Locale.ConvertTextKey("TXT_KEY_PRODUCTION_COST", iCost)
	
	-- Pre-written Help text
	local textHeader = Locale.ConvertTextKey( pProjectInfo.Help )
	if (textHeader ~= nil and textHeader ~= "") then
		-- Separator
		textFoot = textFoot .. "[NEWLINE]----------------[NEWLINE]"
		textFoot = textFoot .. textHeader
	end
	
	-- Requirements?
	if (bIncludeRequirementsInfo) then
		if (pProjectInfo.Requirements) then
			textFoot = textFoot .. Locale.ConvertTextKey( pProjectInfo.Requirements )
		end
	end
	
	return textFoot
	
end


-------------------------------------------------
-- Tooltips for Yields
-------------------------------------------------

showYieldString = {
--   show {  base, surplus,  total }  if Consumed YieldMod SurplusMod
		  { false,   false,   true }, --    -        -         -     
		  {  true,   false,   true }, --    -        -     SurplusMod
		  {  true,   false,   true }, --    -     YieldMod     -     
		  {  true,    true,   true }, --    -     YieldMod SurplusMod
		  { false,    true,  false }, -- Consumed    -         -     
		  { false,    true,   true }, -- Consumed    -     SurplusMod
		  {  true,    true,  false }, -- Consumed YieldMod     -     
		  {  true,    true,   true }  -- Consumed YieldMod SurplusMod
}

local surplusModStrings = {
	"TXT_KEY_FOODMOD_PLAYER",
	"TXT_KEY_FOODMOD_CAPITAL",
	"TXT_KEY_FOODMOD_UNHAPPY",
	"TXT_KEY_FOODMOD_WLTKD"
}

local yieldHelp = {
	[YieldTypes.YIELD_FOOD]			= "TXT_KEY_FOOD_HELP_INFO",
	[YieldTypes.YIELD_PRODUCTION]	= "TXT_KEY_PRODUCTION_HELP_INFO",
	[YieldTypes.YIELD_GOLD]			= "TXT_KEY_GOLD_HELP_INFO",
	[YieldTypes.YIELD_SCIENCE]		= "TXT_KEY_SCIENCE_HELP_INFO",
	[YieldTypes.YIELD_CULTURE]		= "TXT_KEY_CULTURE_HELP_INFO",
	[YieldTypes.YIELD_FAITH]		= "TXT_KEY_FAITH_HELP_INFO"
}

-- Deprecated vanilla functions
function GetFoodTooltip(city)		return GetYieldTooltip(city, YieldTypes.YIELD_FOOD)			 end
function GetProductionTooltip(city)	return GetYieldTooltip(city, YieldTypes.YIELD_PRODUCTION)	 end
function GetGoldTooltip(city)		return GetYieldTooltip(city, YieldTypes.YIELD_GOLD)			 end
function GetScienceTooltip(city)	return GetYieldTooltip(city, YieldTypes.YIELD_SCIENCE)		 end
function GetCultureTooltip(city)	return GetYieldTooltip(city, YieldTypes.YIELD_CULTURE)		 end
function GetFaithTooltip(city)		return GetYieldTooltip(city, YieldTypes.YIELD_FAITH)		 end
function GetYieldTooltipHelper(city, iYieldType, strIcon) return GetYieldTooltip(city, iYieldType) end

function GetYieldTooltip(city, yieldID)
	--timeStart = os.clock()
	--log:Debug("City_GetSurplusYieldRate %15s %15s", city:GetName(), GameInfo.Yields[yieldID].Type)
	local playerID			= city:GetOwner()
	local player			= Players[playerID]
	local iBase				= City_GetBaseYieldRate(city, yieldID)
	local iTotal			= City_GetYieldRate(city, yieldID)
	local yieldInfo			= GameInfo.Yields[yieldID]
	local strIconString		= yieldInfo.IconString
	local strTooltip		= ""
	local baseModString		= City_GetBaseYieldModifierTooltip(city, yieldID)
	local surplusModString	= "[NEWLINE]"
	
	if yieldID == YieldTypes.YIELD_SCIENCE then
		if Game.IsOption(GameOptionTypes.GAMEOPTION_NO_SCIENCE) then
			return Locale.ConvertTextKey("TXT_KEY_TOP_PANEL_SCIENCE_OFF_TOOLTIP")
		end
	end
	
	--print(string.format("%3s ms for %s GetYieldTooltip START", math.floor((os.clock() - timeStart) * 1000), yieldInfo.Type))
	--timeStart = os.clock()
	
	-- Header
	local yieldStored	= City_GetYieldStored(city, yieldID)
	local yieldNeeded	= City_GetYieldNeeded(city, yieldID)
	local yieldTurns	= City_GetYieldTurns(city, yieldID)
	yieldTurns			= (yieldTurns == math.huge) and "-" or yieldTurns
	if yieldNeeded > 0 and yieldTurns ~= math.huge then
		strTooltip = strTooltip .. string.format(
			"%s: %.1i/%.1i%s (%s %s)",
			Locale.ConvertTextKey("TXT_KEY_MODDING_HEADING_PROGRESS"),
			yieldStored, 
			yieldNeeded,
			strIconString,
			yieldTurns,
			Locale.ConvertTextKey("TXT_KEY_TURNS")
		)
		strTooltip = strTooltip .. "[NEWLINE][NEWLINE]"
	end
	
	--print(string.format("%3s ms for %s GetYieldTooltip HEADER", math.floor((os.clock() - timeStart) * 1000), yieldInfo.Type))
	--timeStart = os.clock()
	
	-- Base Yield from Terrain
	local iYieldFromTerrain = Game.Round(City_GetBaseYieldFromTerrain(city, yieldID))
	if (iYieldFromTerrain ~= 0) then
		strTooltip = strTooltip .. "[ICON_BULLET]" .. Locale.ConvertTextKey("TXT_KEY_YIELD_FROM_TERRAIN", iYieldFromTerrain, strIconString)
		strTooltip = strTooltip .. "[NEWLINE]"
	end
	
	--print(string.format("%3s ms for %s GetYieldTooltip City_GetBaseYieldFromTerrain", math.floor((os.clock() - timeStart) * 1000), yieldInfo.Type))
	--timeStart = os.clock()
	
	-- Base Yield from Buildings
	local iYieldFromBuildings = Game.Round(City_GetBaseYieldFromBuildings(city, yieldID))
	if (iYieldFromBuildings ~= 0) then
		strTooltip = strTooltip .. "[ICON_BULLET]" .. Locale.ConvertTextKey("TXT_KEY_YIELD_FROM_BUILDINGS", iYieldFromBuildings, strIconString)
		strTooltip = strTooltip .. "[NEWLINE]"
	end
	
	--print(string.format("%3s ms for %s GetYieldTooltip City_GetBaseYieldFromBuildings", math.floor((os.clock() - timeStart) * 1000), yieldInfo.Type))
	--timeStart = os.clock()
	
	-- Base Yield from Specialists
	local iYieldFromSpecialists = Game.Round(City_GetBaseYieldFromSpecialists(city, yieldID))
	if (iYieldFromSpecialists ~= 0) then
		strTooltip = strTooltip .. "[ICON_BULLET]" .. Locale.ConvertTextKey("TXT_KEY_YIELD_FROM_SPECIALISTS", iYieldFromSpecialists, strIconString)
		strTooltip = strTooltip .. "[NEWLINE]"
	end
	
	--print(string.format("%3s ms for %s GetYieldTooltip City_GetBaseYieldFromSpecialists", math.floor((os.clock() - timeStart) * 1000), yieldInfo.Type))
	--timeStart = os.clock()
	
	-- Base Yield from Religion
	local iYieldFromReligion = Game.Round(City_GetBaseYieldFromReligion(city, yieldID))
	if (iYieldFromReligion ~= 0) then
		strTooltip = strTooltip .. "[ICON_BULLET]" .. Locale.ConvertTextKey("TXT_KEY_YIELD_FROM_RELIGION", iYieldFromReligion, strIconString)
		strTooltip = strTooltip .. "[NEWLINE]"
	end
	
	--print(string.format("%3s ms for %s GetYieldTooltip City_GetBaseYieldFromReligion", math.floor((os.clock() - timeStart) * 1000), yieldInfo.Type))
	--timeStart = os.clock()
	
	-- Base Yield from Pop
	local iYieldFromPop = Game.Round(City_GetBaseYieldFromPopulation(city, yieldID))
	if (iYieldFromPop ~= 0) then
		strTooltip = strTooltip .. "[ICON_BULLET]" .. Locale.ConvertTextKey("TXT_KEY_YIELD_FROM_POP", iYieldFromPop, strIconString)
		strTooltip = strTooltip .. "[NEWLINE]"
	end
	
	--print(string.format("%3s ms for %s GetYieldTooltip City_GetBaseYieldFromPopulation", math.floor((os.clock() - timeStart) * 1000), yieldInfo.Type))
	--timeStart = os.clock()
	
	-- Base Yield from Policies
	local iYieldFromPolicies = Game.Round(City_GetBaseYieldFromPolicies(city, yieldID))
	if (iYieldFromPolicies ~= 0) then
		strTooltip = strTooltip .. "[ICON_BULLET]" .. Locale.ConvertTextKey("TXT_KEY_YIELD_FROM_POLICIES", iYieldFromPolicies, strIconString)
		strTooltip = strTooltip .. "[NEWLINE]"
	end
	
	--print(string.format("%3s ms for %s GetYieldTooltip City_GetBaseYieldFromPolicies", math.floor((os.clock() - timeStart) * 1000), yieldInfo.Type))
	--timeStart = os.clock()

	-- Base Yield from Traits
	local iYieldFromTraits = Game.Round(City_GetBaseYieldFromTraits(city, yieldID))
	if (iYieldFromTraits ~= 0) then
		strTooltip = strTooltip .. "[ICON_BULLET]" .. Locale.ConvertTextKey("TXT_KEY_YIELD_FROM_TRAITS", iYieldFromTraits, strIconString)
		strTooltip = strTooltip .. "[NEWLINE]"
	end
	
	--print(string.format("%3s ms for %s GetYieldTooltip City_GetBaseYieldFromTraits", math.floor((os.clock() - timeStart) * 1000), yieldInfo.Type))
	--timeStart = os.clock()
	
	-- Base Yield from Processes
	local iYieldFromProcesses = Game.Round(City_GetBaseYieldFromProcesses(city, yieldID))
	if (iYieldFromProcesses ~= 0) then
		strTooltip = strTooltip .. "[ICON_BULLET]" .. Locale.ConvertTextKey("TXT_KEY_YIELD_FROM_PROCESSES", iYieldFromProcesses, strIconString)
		strTooltip = strTooltip .. "[NEWLINE]"
	end
	
	--print(string.format("%3s ms for %s GetYieldTooltip City_GetBaseYieldFromProcesses", math.floor((os.clock() - timeStart) * 1000), yieldInfo.Type))
	--timeStart = os.clock()
	
	-- Base Yield from Misc
	local iYieldFromMisc = Game.Round(City_GetBaseYieldFromMisc(city, yieldID))
	if (iYieldFromMisc ~= 0) and (yieldID ~= YieldTypes.YIELD_SCIENCE) then
		strTooltip = strTooltip .. "[ICON_BULLET]" .. Locale.ConvertTextKey("TXT_KEY_YIELD_FROM_MISC", iYieldFromMisc, strIconString)
		strTooltip = strTooltip .. "[NEWLINE]"
	end
	
	--print(string.format("%3s ms for %s GetYieldTooltip City_GetBaseYieldFromMisc", math.floor((os.clock() - timeStart) * 1000), yieldInfo.Type))
	--timeStart = os.clock()
	
	-- Base Yield from Citystates
	local cityYieldFromMinorCivs	= City_GetBaseYieldFromMinorCivs(city, yieldID)
	if cityYieldFromMinorCivs ~= 0 then
		strTooltip = strTooltip .. "[ICON_BULLET]" .. Locale.ConvertTextKey("TXT_KEY_YIELD_FROM_MINOR_CIVS", Game.Round(cityYieldFromMinorCivs, 1), strIconString) .. "[NEWLINE]"
	end
	
	--print(string.format("%3s ms for %s GetYieldTooltip City_GetBaseYieldFromMinorCivs", math.floor((os.clock() - timeStart) * 1000), yieldInfo.Type))
	--timeStart = os.clock()
	
	--print(string.format("%3s ms for %s GetYieldTooltip BASE_YIELDS", math.floor((os.clock() - timeStart) * 1000), yieldInfo.Type))
	--timeStart = os.clock()
	
	if Cep.ENABLE_DISTRIBUTED_MINOR_CIV_YIELDS then
		local playerMinorCivYield	= player:GetYieldsFromCitystates()[yieldID]
		if playerMinorCivYield > 0 then
			local cityWeight		= City_GetWeight(city, yieldID)
			local playerWeight		= player:GetTotalWeight(yieldID)
			for weight in GameInfo.CityWeights() do
				if weight.IsCityStatus == true and city[weight.Type](city) then
					local result = city[weight.Type](city)
					if type(result) == "number" then
						if weight.Type == "GetPopulation" then
							result = weight.Value * result
						else
							result = 100 * weight.Value * result
						end
					else
						result = 100 * weight.Value
					end
					strTooltip = strTooltip .. "     " .. Locale.ConvertTextKey(weight.Description, Game.Round(result)) .. "[NEWLINE]"
				end
			end
			if city:GetFocusType() == CityYieldFocusTypes[yieldID] then
				weight = GameInfo.CityWeights.CityFocus
				strTooltip = strTooltip .. "     " .. Locale.ConvertTextKey(weight.Description, Game.Round(weight.Value * 100), strIconString) .. "[NEWLINE]"
			end
			if not Players[playerID]:IsCapitalConnectedToCity(city) then
				weight = GameInfo.CityWeights.NotConnected
				strTooltip = strTooltip .. "     " .. Locale.ConvertTextKey(weight.Description, Game.Round(weight.Value * 100)) .. "[NEWLINE]"
			end
			if yieldID == YieldTypes.YIELD_FOOD and city:IsForcedAvoidGrowth() then
				weight = Game.Round(player:GetAvoidModifier() * 100)
				strTooltip = strTooltip .. "     " .. Locale.ConvertTextKey("TXT_KEY_CITYSTATE_MODIFIER_IS_AVOID", weight) .. "[NEWLINE]"
				if weight > 0 then
					strTooltip = strTooltip .. "     " .. Locale.ConvertTextKey("TXT_KEY_CITYSTATE_MODIFIER_IS_AVOID_MANY", Cep.AVOID_GROWTH_FULL_EFFECT_CUTOFF) .. "[NEWLINE]"
				end
			end
		
			strTooltip = strTooltip .. "     " .. Locale.ConvertTextKey(
				"TXT_KEY_CITYSTATE_MODIFIER_WEIGHT_TOTAL",
				Game.Round(cityWeight, 1),
				Game.Round(playerWeight, 1),
				Game.Round(100 * cityWeight / playerWeight, 0),
				Game.Round(playerMinorCivYield, 1),
				strIconString
			)
			strTooltip = strTooltip .. "[NEWLINE]"
		end
	end
	
	--print(string.format("%3s ms for %s GetYieldTooltip CS_YIELDS", math.floor((os.clock() - timeStart) * 1000), yieldInfo.Type))
	--timeStart = os.clock()
	
	---------------------------
	-- Build combined string
	---------------------------
	
	
	-- Base modifier
	local baseMod = City_GetBaseYieldRateModifier(city, yieldID)
	local hasBaseMod = (baseMod ~= 0)
	
	-- Surplus
	local iYieldEaten = City_GetYieldConsumed(city, yieldID)
	
	local iSurplus = City_GetSurplusYieldRate(city, yieldID)
	local isConsumed = (iYieldEaten ~= 0)
	
	-- Surplus modifier
	local surplusMod = City_GetSurplusYieldRateModifier(city, yieldID)
	local hasSurplusMod = (surplusMod ~= 0)
	
	-- Base and surplus yield
	local truthiness		= Game.GetTruthTableResult(showYieldString, {isConsumed, hasBaseMod, hasSurplusMod})
	local showBaseYield		= truthiness[1]
	local showSurplusYield	= truthiness[2]
	local showTotalYield	= truthiness[3]
	--print("inputs="..tostring(isConsumed)..","..tostring(hasBaseMod)..","..tostring(hasSurplusMod).."  outputs="..tostring(showBaseYield)..","..tostring(showSurplusYield))
	
	--print(string.format("%3s ms for %s GetYieldTooltip Combined_String_Start", math.floor((os.clock() - timeStart) * 1000), yieldInfo.Type))
	--timeStart = os.clock()
	
	--
	-- Append each part to the string
	--
	
	

	if yieldID == YieldTypes.YIELD_FOOD then
		if iSurplus > 0 and Game.Round(player:GetYieldRate(YieldTypes.YIELD_HAPPINESS_NATIONAL)) <= GameDefines.VERY_UNHAPPY_THRESHOLD then
			baseModString = baseModString .. Locale.ConvertTextKey("TXT_KEY_FOODMOD_UNHAPPY", GameDefines.VERY_UNHAPPY_GROWTH_PENALTY)
		end
		local settlerMod = City_GetCapitalSettlerModifier(city)
		if settlerMod ~= 0 then
			baseModString = baseModString .. Locale.ConvertTextKey("TXT_KEY_PRODMOD_YIELD_SETTLER_POLICY", settlerMod)
		end
	--[[elseif yieldID == YieldTypes.YIELD_PRODUCTION then
		local settlerMod = City_GetCapitalSettlerModifier(city)
		if settlerMod ~= 0 then
			baseModString = baseModString .. Locale.ConvertTextKey("TXT_KEY_PRODMOD_YIELD_SETTLER_POLICY", settlerMod)
		end--]]
	elseif yieldID == YieldTypes.YIELD_CULTURE then
		local buildingMod = City_GetBaseYieldModFromBuildings(city, yieldID)
		if buildingMod ~= 0 then
			baseModString = baseModString .. Locale.ConvertTextKey("TXT_KEY_PRODMOD_YIELD_BUILDINGS", buildingMod)				
		end
	end
	
	local baseModFromPuppet = City_GetBaseYieldModFromPuppet(city, yieldID)
	if baseModFromPuppet ~= 0 then
		baseModString = baseModString .. Locale.ConvertTextKey("TXT_KEY_PRODMOD_PUPPET", baseModFromPuppet)
	end
	
	local surplusModFromBuildings = City_GetSurplusYieldModFromBuildings(city, yieldID)
	if surplusModFromBuildings ~= 0 then
		surplusModString = surplusModString .. Locale.ConvertTextKey("TXT_KEY_PRODMOD_YIELD_BUILDINGS", surplusModFromBuildings) 
	end
	
	local surplusModFromReligion = City_GetSurplusYieldModFromReligion(city, yieldID)
	if surplusModFromReligion ~= 0 then
		surplusModString = surplusModString .. Locale.ConvertTextKey("TXT_KEY_PRODMOD_YIELD_BELIEF", surplusModFromReligion)
	end
	
	local surplusModFromGAs = player:GetGoldenAgeSurplusYieldModifier(yieldID)
	if surplusModFromGAs ~= 0 then
		surplusModString = surplusModString .. Locale.ConvertTextKey("TXT_KEY_PRODMOD_YIELD_GOLDEN_AGE", surplusModFromGAs) 
	end
	
	--print(string.format("%3s ms for %s GetYieldTooltip Combined_String_B", math.floor((os.clock() - timeStart) * 1000), yieldInfo.Type))
	--timeStart = os.clock()
	
	if hasSurplusMod then
		local strTarget = ""
		local strStart, strEnd
		for _,v in ipairs(surplusModStrings) do
			strTarget = string.gsub(Game.Literalize(Locale.ConvertTextKey(v, "value")), "value", '%%%-%?%%d+')
			--log:Fatal("strTarget = '%s'", strTarget)
			strStart, strEnd = string.find(baseModString, strTarget)
			if strStart then
				strTarget = string.sub(baseModString, strStart, strEnd)
				baseModString = string.gsub(baseModString, Game.Literalize(strTarget), "")
				surplusModString = surplusModString .. strTarget
			end
		end
	end
	surplusModString = string.gsub(surplusModString, "^"..Game.Literalize("[NEWLINE]"), "")
	baseModString = string.gsub(baseModString, "^"..Game.Literalize("[NEWLINE]"), "")
	baseModString = string.gsub(baseModString, Game.Literalize("[NEWLINE]").."$", "")
	
	strTooltip = strTooltip .. "----------------"
	
	if showBaseYield then
		strTooltip = strTooltip .. "[NEWLINE]"
		strTooltip = strTooltip .. Locale.ConvertTextKey("TXT_KEY_YIELD_BASE", Game.Round(iBase,1), strIconString)
	end
	--print(strTooltip)
	
	--print(string.format("%3s ms for %s GetYieldTooltip Combined_String_C", math.floor((os.clock() - timeStart) * 1000), yieldInfo.Type))
	--timeStart = os.clock()
	
	if hasBaseMod then
		iBase = iBase * (1 + baseMod / 100)
		strTooltip = strTooltip .. "[NEWLINE]"
		strTooltip = strTooltip .. baseModString
	end
	
	--print(strTooltip)
	if showSurplusYield then
		local surplusString = Locale.ConvertTextKey("TXT_KEY_YIELD_SURPLUS", Game.Round(iSurplus,1), strIconString) 
		if iSurplus > 0 then
			surplusString = "[COLOR_POSITIVE_TEXT]"..surplusString.."[ENDCOLOR]"
		elseif iSurplus < 0 then
			surplusString = "[COLOR_NEGATIVE_TEXT]"..surplusString.."[ENDCOLOR]"
		end
		surplusString = surplusString .. "  " .. Locale.ConvertTextKey("TXT_KEY_YIELD_USAGE", Game.Round(iBase, 1), iYieldEaten)
		strTooltip = strTooltip .. "[NEWLINE]"
		strTooltip = strTooltip .. surplusString
	end
	
	--print(string.format("%3s ms for %s GetYieldTooltip Combined_String_D", math.floor((os.clock() - timeStart) * 1000), yieldInfo.Type))
	--timeStart = os.clock()
	
	if hasSurplusMod then
		--strTooltip = strTooltip .. "[NEWLINE]"
		strTooltip = strTooltip .. surplusModString
	end
	
	if showTotalYield then
		strTooltip = strTooltip .. "[NEWLINE]"
		if (iTotal >= 0) then
			strTooltip = strTooltip .. Locale.ConvertTextKey("TXT_KEY_YIELD_TOTAL", Game.Round(iTotal, 1), strIconString)
		else
			strTooltip = strTooltip .. Locale.ConvertTextKey("TXT_KEY_YIELD_TOTAL_NEGATIVE", Game.Round(iTotal, 1), strIconString)
		end
	end
		
	-- Yield from Other Yields (food converted to production)
	local iYieldFromOtherYields = Game.Round(City_GetYieldFromFood(city, yieldID))
	if (iYieldFromOtherYields ~= 0) then
		strTooltip = strTooltip .."  ".. Locale.ConvertTextKey("TXT_KEY_YIELD_FROM_OTHER_YIELDS",
																iTotal - iYieldFromOtherYields,
																strIconString,
																iYieldFromOtherYields,
																"[ICON_FOOD]",
																Locale.ConvertTextKey(GameInfo.Yields.YIELD_FOOD.Description)
																)
		strTooltip = strTooltip .. "[NEWLINE]"
	end
	
	-- Footer
	
	if yieldID == YieldTypes.YIELD_FAITH then
		strTooltip = strTooltip .. "[NEWLINE]----------------[NEWLINE]" .. GetReligionTooltip(city)
	end

	if not OptionsManager.IsNoBasicHelp() then
		strTooltip = strTooltip .. "[NEWLINE][NEWLINE]" .. Locale.ConvertTextKey(yieldHelp[yieldID])
	end
		
	--print(string.format("%3s ms for %s GetYieldTooltip END", math.floor((os.clock() - timeStart) * 1000), yieldInfo.Type))
	
	return strTooltip
end

------------------------------
-- Helper function to build religion tooltip string
function GetReligionTooltip(city)

	local religionToolTip = ""
	
	if (Game.IsOption(GameOptionTypes.GAMEOPTION_NO_RELIGION)) then
		return religionToolTip
	end

	local bFoundAFollower = false
	local eReligion = city:GetReligiousMajority()
	local bFirst = true
	
	if (eReligion >= 0) then
		bFoundAFollower = true
		local religion = GameInfo.Religions[eReligion]
		local strReligion = Locale.ConvertTextKey(Game.GetReligionName(eReligion))
	    local strIcon = religion.IconString
		local strPressure = ""
			
		if (city:IsHolyCityForReligion(eReligion)) then
			if (not bFirst) then
				religionToolTip = religionToolTip .. "[NEWLINE]"
			else
				bFirst = false
			end
			religionToolTip = religionToolTip .. Locale.ConvertTextKey("TXT_KEY_HOLY_CITY_TOOLTIP_LINE", strIcon, strReligion)			
		end

		local iPressure
		local iNumTradeRoutesAddingPressure
		iPressure, iNumTradeRoutesAddingPressure = city:GetPressurePerTurn(eReligion)
		if (iPressure > 0) then
			strPressure = Locale.ConvertTextKey("TXT_KEY_RELIGIOUS_PRESSURE_STRING", math.floor(iPressure/GameDefines["RELIGION_MISSIONARY_PRESSURE_MULTIPLIER"]))
		end
		
		local iFollowers = city:GetNumFollowers(eReligion)			
		if (not bFirst) then
			religionToolTip = religionToolTip .. "[NEWLINE]"
		else
			bFirst = false
		end
		
		--local iNumTradeRoutesAddingPressure = city:GetNumTradeRoutesAddingPressure(eReligion)
		if (iNumTradeRoutesAddingPressure > 0) then
			religionToolTip = religionToolTip .. Locale.ConvertTextKey("TXT_KEY_RELIGION_TOOLTIP_LINE_WITH_TRADE", strIcon, iFollowers, strPressure, iNumTradeRoutesAddingPressure)
		else
			religionToolTip = religionToolTip .. Locale.ConvertTextKey("TXT_KEY_RELIGION_TOOLTIP_LINE", strIcon, iFollowers, strPressure)
		end
	end	
		
	local iReligionID
	for pReligion in GameInfo.Religions() do
		iReligionID = pReligion.ID
		
		if (iReligionID >= 0 and iReligionID ~= eReligion and city:GetNumFollowers(iReligionID) > 0) then
			bFoundAFollower = true
			local religion = GameInfo.Religions[iReligionID]
			local strReligion = Locale.ConvertTextKey(Game.GetReligionName(iReligionID))
			local strIcon = religion.IconString
			local strPressure = ""

			if (city:IsHolyCityForReligion(iReligionID)) then
				if (not bFirst) then
					religionToolTip = religionToolTip .. "[NEWLINE]"
				else
					bFirst = false
				end
				religionToolTip = religionToolTip .. Locale.ConvertTextKey("TXT_KEY_HOLY_CITY_TOOLTIP_LINE", strIcon, strReligion)			
			end
				
			local iPressure = city:GetPressurePerTurn(iReligionID)
			if (iPressure > 0) then
				strPressure = Locale.ConvertTextKey("TXT_KEY_RELIGIOUS_PRESSURE_STRING", math.floor(iPressure/GameDefines["RELIGION_MISSIONARY_PRESSURE_MULTIPLIER"]))
			end
			
			local iFollowers = city:GetNumFollowers(iReligionID)			
			if (not bFirst) then
				religionToolTip = religionToolTip .. "[NEWLINE]"
			else
				bFirst = false
			end
			
			local iNumTradeRoutesAddingPressure = city:GetNumTradeRoutesAddingPressure(iReligionID)
			if (iNumTradeRoutesAddingPressure > 0) then
				religionToolTip = religionToolTip .. Locale.ConvertTextKey("TXT_KEY_RELIGION_TOOLTIP_LINE_WITH_TRADE", strIcon, iFollowers, strPressure, iNumTradeRoutesAddingPressure)
			else
				religionToolTip = religionToolTip .. Locale.ConvertTextKey("TXT_KEY_RELIGION_TOOLTIP_LINE", strIcon, iFollowers, strPressure)
			end
		end
	end
	
	if (not bFoundAFollower) then
		religionToolTip = religionToolTip .. Locale.ConvertTextKey("TXT_KEY_RELIGION_NO_FOLLOWERS")
	end
		
	return religionToolTip
end