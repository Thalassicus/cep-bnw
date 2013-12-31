-------------------------------------------------
-- Help text for Info Objects (Units, Buildings, etc.)
-------------------------------------------------

-- Changes to this file were made by Thalassicus, primarily for the AutoTips and YieldLibrary modules of the Civ 5 Unofficial Patch.

include( "YieldLibrary.lua" )

if Game == nil then
	--print("Game is nil")
	return
end

--print("Initializing InfoTooltipInclude.lua")

local log = Events.LuaLogger:New()
log:SetLevel("DEBUG")

local timeStart = os.clock()

Game.Stats				= Game.Stats or {}
Game.Stats.Units		= Game.Stats.Units or {}
Game.Stats.Buildings	= Game.Stats.Buildings or {}


local holidayFun = {
	["01/01"] = "TXT_KEY_HOLIDAY_NEW_YEAR"		,
	["04/01"] = "TXT_KEY_HOLIDAY_APRIL_FOOLS"	,
	["07/02"] = "TXT_KEY_HOLIDAY_UFO"			,
	["10/31"] = "TXT_KEY_HOLIDAY_HALLOWEEN"		
}

--[[
local holidayFun = {
	["01/01"] = "TXT_KEY_HOLIDAY_NEW_YEAR"		,
	["02/10"] = "TXT_KEY_HOLIDAY_CHINESE_NEW_YEAR" 	,
	["02/14"] = "TXT_KEY_HOLIDAY_VALENTINE'S_DAY" 	,
	["03/10"] = "TXT_KEY_HOLIDAY_DAYLIGHT_SAVING_TIME"	,
	["03/17"] = "TXT_KEY_HOLIDAY_ST._PATRICK'S"	,
	["04/01"] = "TXT_KEY_HOLIDAY_APRIL_FOOLS"	,
	["07/01"] = "TXT_KEY_HOLIDAY_CANADA_DAY"	,
	["07/02"] = "TXT_KEY_HOLIDAY_UFO"		,
	["07/04"] = "TXT_KEY_HOLIDAY_INDEPENDENCE_DAY"	,
	["10/14"] = "TXT_KEY_HOLIDAY_CANADIAN_THANKSGIVING"	,
	["10/31"] = "TXT_KEY_HOLIDAY_HALLOWEEN"		,
	["11/02"] = "TXT_KEY_HOLIDAY_DAYLIGHT_SAVING_TIME_ENDS"	,
	["11/28"] = "TXT_KEY_HOLIDAY_AMERICAN_THANKSGIVING"	,
	["12/25"] = "TXT_KEY_HOLIDAY_CHRISTMAS"		,
	["12/26"] = "TXT_KEY_HOLIDAY_BOXING_DAY"	,
	["12/31"] = "TXT_KEY_HOLIDAY_NEW_YEARS_EVE"	,
}
--]]




-- UNIT

-- Deprecated vanilla function
function GetHelpTextForUnit(unitIDA, showRequirementsInfo)
	return GetUnitTip{unitID=unitIDA, hideCosts=(not showRequirementsInfo)}
end

function GetUnitTip(args)
	-- Required arguments: unitID
	-- Optional arguments: hideName, hideGoodFor, hideAbilities, hideCosts
	
	if Game == nil then
		print("GetBuildingTip: Game is nil")
		return ""
	end
	if not Game.InitializedStats then
		--[[
		
		Interfaces like TechTree load twice:
		once when the game starts, then again when the user first sees the inferface.
		
		The game loads TW_Init after the interfaces (at game start),
		so only return data the second time (when first seeing the interface).
		
		--]]
		
		return ""
	end
	
	local unitID		= args.unitID
	local showName		= not args.hideName
	local showGood		= not args.hideGoodFor
	local showAbil		= not args.hideAbilities
	local showCost		= not args.hideCosts
	
	local unitInfo = GameInfo.Units[unitID]
	local unitClassInfo = GameInfo.UnitClasses[unitInfo.Class]
	
	local activePlayer = Players[Game.GetActivePlayer()]
	local activeTeam = Teams[Game.GetActiveTeam()]

	local textBody = ""
	local statTextKey = ""
	
	-- Name
	if showName then
		local textName = Locale.ConvertTextKey(unitInfo.Description)
		
		local holidayName = holidayFun[os.date("%m/%d")]
		if holidayName then
			textName = string.format("%s %s", Locale.ConvertTextKey(holidayName), textName)
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
		textBody = textBody .. "[NEWLINE]----------------"	
	end
	
	-- Value
	local showOnlyGood = (showGood and not showName and not showAbil and not showCost)
	if Cep.SHOW_GOOD_FOR_UNITS == 1 and showGood then
		local textGoodFor = Game.GetFlavors("Unit_Flavors", "UnitType", unitInfo.Type, 1, showOnlyGood)
		if showOnlyGood then
			textBody = string.gsub(textGoodFor, "^%[NEWLINE%]", "")
			return textBody
		end	
		textBody = textBody .. textGoodFor
	end
	
	
	--
	-- Abilities
	--
	
	if showAbil then
		if showName then
			textBody = string.format("%s[NEWLINE][NEWLINE]%s", textBody, Locale.ConvertTextKey("TXT_KEY_TOOLTIP_ABILITIES"))
		end
		
		-- Promotions
		local header				= ""
		local footerRangedStrength	= ""
		local footerStrength		= ""
		local footerMoves			= ""
		local footerEnd				= ""
		--
		for row in GameInfo.Unit_FreePromotions{UnitType = unitInfo.Type} do
			local promoInfo = GameInfo.UnitPromotions[row.PromotionType]
			if promoInfo.Class ~= "PROMOTION_CLASS_ATTRIBUTE_NEGATIVE" then
				--
				local promoText, section = GetPromotionTip(promoInfo.ID, unit)
				
				footerRangedStrength	= footerRangedStrength	.. section[TipSection.PROMO_RANGE]
				footerRangedStrength	= footerRangedStrength	.. section[TipSection.PROMO_RANGED_STRENGTH]
				footerStrength			= footerStrength		.. section[TipSection.PROMO_STRENGTH]
				footerStrength			= footerStrength		.. section[TipSection.PROMO_AIR]
				footerMoves				= footerMoves			.. section[TipSection.PROMO_MOVES]
				footerMoves				= footerMoves			.. section[TipSection.PROMO_HEAL]
				footerEnd				= footerEnd				.. section[TipSection.PROMO_SIGHT]
				footerEnd				= footerEnd				.. section[TipSection.PROMO_NAVAL]
				footerEnd				= footerEnd				.. section[TipSection.PROMO_GOLD]
				footerEnd				= footerEnd				.. section[TipSection.PROMO_GREAT_GENERAL]
				footerEnd				= footerEnd				.. section[TipSection.PROMO_RES_URANIUM]
				footerEnd				= footerEnd				.. section[TipSection.PROMO_WAR]
				footerEnd				= footerEnd				.. section[TipSection.PROMO_NEGATIVE]
				footerEnd				= footerEnd				.. section[TipSection.PROMO_OTHER]
				--]]
				
				--[[
				local promoText = ModLocale.ConvertTextKey(promoInfo.Help) or promoInfo.Type
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
				--]]
			end
		end
		--]=]
		
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
		
		-- Category
		local category = GameInfo.UnitCombatInfos[unitInfo.CombatClass]
		if category then
			textBody = textBody .. "[NEWLINE]" .. Locale.ConvertTextKey("TXT_KEY_PRODUCTION_UNIT_CATEGORY", category.Description)
		else
			log:Error("GetUnitTip %s CombatClass=%s", unitInfo.Type, unitInfo.CombatClass)
		end
		
		-- Replaces
		local defaultObjectType = unitClassInfo.DefaultUnit
		if unitInfo.Type ~= defaultObjectType then
			textBody = textBody .. "[NEWLINE]"
			textBody = textBody .. Locale.ConvertTextKey("TXT_KEY_BUILDING_EFFECT_REPLACES", GameInfo.Units[defaultObjectType].Description)
		end
	end
	
	
	--
	-- Requirements
	--
	if showCost then
		if showAbil then
			textBody = textBody .. "[NEWLINE][NEWLINE]"	
		end
		if showName then
			textBody = textBody .. Locale.ConvertTextKey("TXT_KEY_TOOLTIP_REQUIREMENTS")
		end
		
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
		if (showRequirementsInfo) then
			if (unitInfo.Requirements) then
				textBody = textBody .. Locale.ConvertTextKey( unitInfo.Requirements )
			end
		end
		
		if unitInfo.ProjectPrereq then
			local projectName = GameInfo.Projects[unitInfo.ProjectPrereq].Description
			textBody = textBody .. "[NEWLINE]" .. Locale.ConvertTextKey("TXT_KEY_BUILDING_EFFECT_REQUIRES_BUILDING", projectName)		
		end
		
		-- Tech prerequisites
		statTextKey = "TXT_KEY_BUILDING_EFFECT_REQUIRES_BUILDING"
		for pEntry in GameInfo.Unit_TechTypes{UnitType = unitInfo.Type} do
			local entryValue = Locale.ConvertTextKey(GameInfo.Technologies[pEntry.TechType].Description)
			textBody = textBody .. "[NEWLINE]" .. Locale.ConvertTextKey(statTextKey, entryValue)
		end
		
		-- Obsolescence
		local pObsolete = unitInfo.ObsoleteTech
		if pObsolete and pObsolete ~= "" then
			if GameInfo.Technologies[pObsolete] then
				pObsolete = Locale.ConvertTextKey(GameInfo.Technologies[pObsolete].Description)
				textBody = textBody .. "[NEWLINE]"
				textBody = textBody .. Locale.ConvertTextKey("TXT_KEY_PRODUCTION_UNIT_OBSOLETE_TECH", pObsolete)
			else
				log:Warn("%s obsolete tech %s does not exist", unitInfo.Type, unitInfo.ObsoleteTech)
			end
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
	end
	
	textBody = Game.RemoveExtraNewlines(textBody)
	return textBody	
end

-- BUILDING

-- Deprecated vanilla function
function GetHelpTextForBuilding(iBuildingID, bExcludeName, bExcludeHeader, bNoMaintenance, pCity)
	return GetBuildingTip{buildingID=iBuildingID, hideName=(bExcludeName or bExcludeHeader), hideCosts=bExcludeHeader, buildingCity=pCity}
end

function GetBuildingTip(args)
	-- Required arguments: buildingID
	-- Optional arguments: buildingCity, hideName, hideGoodFor, hideAbilities, hideCosts, hideFoot
	
	if Game == nil then
		print("GetBuildingTip: Game is nil")
		return ""
	end
	if not Game.InitializedStats then
		--[[
		
		Interfaces like TechTree load twice:
		once when the game starts, then again when the user first sees the inferface.
		
		The game loads TW_Init after the interfaces (at game start),
		so only return data the second time (when first seeing the interface).
		
		--]]
		
		return ""
	end
	if not args.buildingID	or not GameInfo.Buildings[args.buildingID] then
		log:Fatal("GetHelpTextForBuilding: buildingID = %s", args.buildingID)
	end
	
	local buildingID	= args.buildingID	
	local objectInfo	= GameInfo.Buildings[buildingID]
	local textList		= {}
	local textBody		= ""
	local textFoot		= ""
	local city			= args.buildingCity
	local showName		= not args.hideName
	local showGood		= not args.hideGoodFor
	local showAbil		= not args.hideAbilities
	local showCost		= not args.hideCosts
	local showFoot		= not args.hideCosts
	local showSection	= {	
		[0] = showName,
		[1] = showAbil,
		[2] = showAbil,
		[3] = showAbil,
		[4] = showAbil,
		[5] = showCost
	}
	
	if Cep.SHOW_GOOD_FOR_BUILDINGS == 1 and showGood and not showName and not showAbil and not showCost then
		return Game.RemoveExtraNewlines(Game.GetFlavors("Building_Flavors", "BuildingType", objectInfo.Type, 1, true))
	end

	if Game.Stats.Buildings[buildingID] == nil then
		log:Warn("GetHelpTextForBuilding: stat data is nil for %s!", objectInfo.Type)
		return ""
	elseif Game.Stats.Buildings[buildingID] == {} then
		log:Warn("GetHelpTextForBuilding: stat data is empty table for %s!", objectInfo.Type)
		return ""
	end
	
	if showFoot and objectInfo.AlwaysShowHelp and objectInfo.Help and objectInfo.Help ~= "" then
		textFoot = Locale.ConvertTextKey(objectInfo.Help)
	end
	
	-- main loop
	for _, stat in pairs(Game.Stats.Buildings[buildingID]) do		
		if stat.Dynamic then
			for _, subStat in pairs(stat.Value(buildingID, stat.Type, stat.Section, stat.Priority, stat.Value, city)) do
				if subStat.Section and subStat.Priority and subStat.TextBody then
					if showSection[subStat.Section] then
						table.insert(textList, {Section=subStat.Section, Priority=subStat.Priority, TextBody=subStat.TextBody, TextFoot=subStat.TextFoot})
					end
				else
					log:Error("GetHelpTextForBuilding %s Stat %s SubStat %s section=%s priority=%s textBody=%s", objectInfo.Type, stat.Type, subStat.Type, subStat.Section, subStat.Priority, subStat.TextBody)
				end
			end
		elseif type(stat.TextBody) == "string" then
			if stat.Section and stat.Priority and stat.TextBody then
				if showSection[stat.Section] then
					table.insert(textList, {Section=stat.Section, Priority=stat.Priority, TextBody=stat.TextBody, TextFoot=stat.TextFoot})
				end
			else
				log:Error("GetHelpTextForBuilding %s Stat %s section=%s priority=%s textBody=%s", objectInfo.Type, stat.Type, stat.Section, stat.Priority, stat.TextBody)				
			end
		end
	end
		
	table.sort(textList, function (a,b)
		if a.Section ~= b.Section then
			return a.Section < b.Section
		elseif a.Priority ~= b.Priority then
			return a.Priority < b.Priority
		end
		return a.TextBody < b.TextBody
	end)
	
	local section = 0
	for _, stat in ipairs(textList) do
		if section < 1 and stat.Section >= 1 then			
			-- flavor section
			if showName then
				textBody = textBody .. "[NEWLINE]----------------"
			end
			if Cep.SHOW_GOOD_FOR_BUILDINGS == 1 and showGood then
				local textFlavors = Game.GetFlavors("Building_Flavors_Human", "BuildingType", objectInfo.Type)
				if textFlavors ~= "" then
					textBody = textBody .. textFlavors .. "[NEWLINE]"
				end
			end
			
			-- ability section
			if (showName or showGood) and showAbil then
				textBody = string.format("%s[NEWLINE]%s", textBody, Locale.ConvertTextKey("TXT_KEY_TOOLTIP_ABILITIES"))
			end
		end
		if section < 5 and stat.Section >= 5 and (showName or showGood) and showCost then
			-- requirements section
			textBody = string.format("%s[NEWLINE][NEWLINE]%s", textBody, Locale.ConvertTextKey("TXT_KEY_TOOLTIP_REQUIREMENTS"))
		end
		
		section = stat.Section
		
		if stat.TextBody then
			textBody = textBody .. "[NEWLINE]" .. stat.TextBody
			if stat.Type == "Name" and objectInfo.BuildingClass == "BUILDINGCLASS_PALACE" and GameDefines.GEM_VERSION and GameDefines.GEM_VERSION > 0 then
				stat.TextBody = stat.TextBody .. " - " .. Locale.ConvertTextKey("TXT_KEY_GEM_VERSION", GameDefines.GEM_VERSION)
			end
		end
		if showFoot and stat.TextFoot then
			textFoot = textFoot .. "[NEWLINE][NEWLINE]" .. stat.TextFoot
		end
	end
	
	textBody = Game.RemoveExtraNewlines(textBody)
	
	if showFoot and textFoot ~= "" then
		textBody = textBody .. "[NEWLINE]----------------[NEWLINE]"
		textBody = textBody .. textFoot
	end
	
	if textBody == nil or textBody == "" then
		if showAbilities then
			log:Error("GetHelpTextForBuilding: %s textBody=%s for Abilities", objectInfo.Type, textBody)
		elseif showGoodFor then
			log:Error("GetHelpTextForBuilding: %s textBody=%s for GoodFor", objectInfo.Type, textBody)
		elseif showCosts then
			log:Error("GetHelpTextForBuilding: %s textBody=%s for Costs", objectInfo.Type, textBody)
		end
		textBody = objectInfo.Type
	end
	return textBody
end


-- PROMOTION
function GetPromotionTip(promoID, unit)
	if Game == nil then
		print("GetPromotionTip: Game does not exist")
		return ""
	end
	if not Game.InitializedStats then
		print("GetPromotionTip: not initialized")
		return ""
	end
	
	local objectInfo	= GameInfo.UnitPromotions[promoID]
	local textList		= {}
	local textBody		= ""
	local textFoot		= ""
	local unit			= unit
	local textSection	= {}
		
	textSection[TipSection.PROMO_RANGE]				= ""
	textSection[TipSection.PROMO_RANGED_STRENGTH]	= ""
	textSection[TipSection.PROMO_STRENGTH]			= ""
	textSection[TipSection.PROMO_MOVES]				= ""
	textSection[TipSection.PROMO_HEAL]				= ""
	textSection[TipSection.PROMO_SIGHT]				= ""
	textSection[TipSection.PROMO_AIR]				= ""
	textSection[TipSection.PROMO_NAVAL]				= ""
	textSection[TipSection.PROMO_GOLD]				= ""
	textSection[TipSection.PROMO_GREAT_GENERAL]		= ""
	textSection[TipSection.PROMO_RES_URANIUM]		= ""
	textSection[TipSection.PROMO_WAR]				= ""
	textSection[TipSection.PROMO_NEGATIVE]			= ""
	textSection[TipSection.PROMO_OTHER]				= ""
	
	if Game.Stats.Promotions[promoID] == nil then
		log:Warn("GetHelpTextForPromotion: stat data is nil for %s!", objectInfo.Type)
		return ""
	elseif Game.Stats.Promotions[promoID] == {} then
		log:Warn("GetHelpTextForPromotion: stat data is empty table for %s!", objectInfo.Type)
		return ""
	end
	
	-- main loop
	for _, stat in pairs(Game.Stats.Promotions[promoID]) do		
		if stat.Dynamic then
			for _, subStat in pairs(stat.Value(promoID, stat.Type, stat.Section, stat.Priority, stat.Value, unit)) do
				if subStat.Section and subStat.Priority and subStat.TextBody then
					table.insert(textList, {Section=subStat.Section, Priority=subStat.Priority, TextBody=subStat.TextBody, TextFoot=subStat.TextFoot})
				else
					log:Error("GetHelpTextForPromotion %s Stat %s SubStat %s textSection=%s priority=%s textBody=%s", objectInfo.Type, stat.Type, subStat.Type, subStat.Section, subStat.Priority, subStat.TextBody)
				end
			end
		elseif type(stat.TextBody) == "string" then
			if stat.Section and stat.Priority and stat.TextBody then
				table.insert(textList, {Section=stat.Section, Priority=stat.Priority, TextBody=stat.TextBody, TextFoot=stat.TextFoot})
			else
				log:Error("GetHelpTextForPromotion %s Stat %s textSection=%s priority=%s textBody=%s", objectInfo.Type, stat.Type, stat.Section, stat.Priority, stat.TextBody)				
			end
		end
	end
	
	table.sort(textList, function (a,b)
		if a.Section ~= b.Section then
			return a.Section < b.Section
		elseif a.Priority ~= b.Priority then
			return a.Priority < b.Priority
		end
		return a.TextBody < b.TextBody
	end)
	
	for _, stat in ipairs(textList) do
		if stat.TextBody then
			textBody = textBody .. "[NEWLINE]" .. stat.TextBody
			textSection[stat.Section] = textSection[stat.Section] .. "[NEWLINE]" .. stat.TextBody
		end
	end
	
	if textBody == nil or textBody == "" then
		--log:Warn("GetPromotionTip: %s textBody=%s", objectInfo.Type, textBody)
		textBody = "[NEWLINE][ICON_BULLET] " .. ModLocale.ConvertTextKey(objectInfo.Description)
		textSection[TipSection.PROMO_OTHER] = textBody
	end
	
	textBody = string.gsub(textBody, "^%[NEWLINE%]", "")
	
	log:Trace("GetPromotionTip %30s %s %s", objectInfo.Type, textBody, textSection)
	return textBody, textSection
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
function GetHelpTextForProject(iProjectID, showRequirementsInfo)
	local objectInfo = GameInfo.Projects[iProjectID]
	
	local activePlayer = Players[Game.GetActivePlayer()]
	local activeTeam = Teams[Game.GetActiveTeam()]
	
	local textFoot = ""
	
	-- Name
	textFoot = textFoot .. Locale.ToUpper(Locale.ConvertTextKey( objectInfo.Description ))

	-- Pre-written Help text
	local textHeader = Locale.ConvertTextKey( objectInfo.Help )
	if (textHeader ~= nil and textHeader ~= "") then
		-- Separator
		textFoot = textFoot .. "[NEWLINE]----------------[NEWLINE]"
		textFoot = textFoot .. textHeader
	end

	textFoot = textFoot .. "[NEWLINE]----------------"

	if Cep.SHOW_GOOD_FOR_BUILDINGS == 1 then
		local textFlavors = Game.GetFlavors("Project_Flavors", "ProjectType", objectInfo.Type)
		if textFlavors ~= "" then
			textFoot = textFoot .. textFlavors .. "[NEWLINE]"
		end
	end
	
	-- Cost
	local iCost = activePlayer:GetProjectProductionNeeded(iProjectID)
	textFoot = textFoot .. "[NEWLINE]----------------[NEWLINE]"
	textFoot = textFoot .. Locale.ConvertTextKey("TXT_KEY_PRODUCTION_COST", iCost)
	

	
	-- Requirements?
	if (showRequirementsInfo) then
		if (objectInfo.Requirements) then
			textFoot = textFoot .. Locale.ConvertTextKey( objectInfo.Requirements )
		end
	end
	
	return textFoot
	
end

-- PROCESS
function GetHelpTextForProcess(iProcessID, showRequirementsInfo)
	local pProcessInfo = GameInfo.Processes[iProcessID]
	local activePlayer = Players[Game.GetActivePlayer()]
	local activeTeam = Teams[Game.GetActiveTeam()]
	
	local textBody = ""
	
	-- Name
	textBody = textBody .. Locale.ToUpper(Locale.ConvertTextKey(pProcessInfo.Description))
	
	-- Pre-written Help text
	local strWrittenHelpText = Locale.ConvertTextKey(pProcessInfo.Help)
	if (strWrittenHelpText ~= nil and strWrittenHelpText ~= "") then
		textBody = textBody .. "[NEWLINE]----------------[NEWLINE]"
		textBody = textBody .. strWrittenHelpText
	end
	
	-- League Project text
	local tProject = nil
	for t in GameInfo.LeagueProjects() do
		if (iProcessID == GameInfo.Processes[t.Process].ID) then
			tProject = t
			break
		end
	end
	local pLeague = Game.GetActiveLeague()
	if (tProject ~= nil and pLeague ~= nil) then
		textBody = textBody .. "[NEWLINE][NEWLINE]"
		textBody = textBody .. pLeague:GetProjectDetails(GameInfo.LeagueProjects[tProject.Type].ID, Game.GetActivePlayer())
	end
	
	return textBody
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

-- TOURISM
function GetTourismTooltip(pCity)
	return pCity:GetTourismTooltip();
end

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

----------------------------------------------------------------        
-- MOOD INFO
----------------------------------------------------------------        
function GetMoodInfo(iOtherPlayer)
	
	local strInfo = ""
	
	-- Always war!
	if (Game.IsOption(GameOptionTypes.GAMEOPTION_ALWAYS_WAR)) then
		return "[ICON_BULLET]" .. Locale.ConvertTextKey("TXT_KEY_ALWAYS_WAR_TT")
	end
	
	local iActivePlayer = Game.GetActivePlayer()
	local activePlayer = Players[iActivePlayer]
	local activeTeam = Teams[activePlayer:GetTeam()]
	local pOtherPlayer = Players[iOtherPlayer]
	local iOtherTeam = pOtherPlayer:GetTeam()
	local pOtherTeam = Teams[iOtherTeam]
	
	--local iVisibleApproach = Players[iActivePlayer]:GetApproachTowardsUsGuess(iOtherPlayer)
	
	-- At war right now
	--[[if (activeTeam:IsAtWar(iOtherTeam)) then
		strInfo = strInfo .. "[ICON_BULLET]" .. Locale.ConvertTextKey("TXT_KEY_DIPLO_AT_WAR") .. "[NEWLINE]"
		
	-- Not at war right now
	else
		
		-- We've fought before
		if (activePlayer:GetNumWarsFought(iOtherPlayer) > 0) then
			-- They don't appear to be mad
			if (iVisibleApproach == MajorCivApproachTypes.MAJOR_CIV_APPROACH_FRIENDLY or 
				iVisibleApproach == MajorCivApproachTypes.MAJOR_CIV_APPROACH_NEUTRAL) then
				strInfo = strInfo .. "[ICON_BULLET]" .. Locale.ConvertTextKey("TXT_KEY_DIPLO_PAST_WAR_NEUTRAL") .. "[NEWLINE]"
			-- They aren't happy with us
			else
				strInfo = strInfo .. "[ICON_BULLET]" .. Locale.ConvertTextKey("TXT_KEY_DIPLO_PAST_WAR_BAD") .. "[NEWLINE]"
			end
		end
	end]]--
		
	-- Neutral things
	--[[if (iVisibleApproach == MajorCivApproachTypes.MAJOR_CIV_APPROACH_AFRAID) then
		strInfo = strInfo .. "[ICON_BULLET]" .. Locale.ConvertTextKey("TXT_KEY_DIPLO_AFRAID") .. "[NEWLINE]"
	end]]--
		
	-- Good things
	--[[if (pOtherPlayer:WasResurrectedBy(iActivePlayer)) then
		strInfo = strInfo .. "[ICON_BULLET]" .. Locale.ConvertTextKey("TXT_KEY_DIPLO_RESURRECTED") .. "[NEWLINE]"
	end]]--
	--[[if (activePlayer:IsDoF(iOtherPlayer)) then
		strInfo = strInfo .. "[ICON_BULLET]" .. Locale.ConvertTextKey("TXT_KEY_DIPLO_DOF") .. "[NEWLINE]"
	end]]--
	--[[if (activePlayer:IsPlayerDoFwithAnyFriend(iOtherPlayer)) then		-- Human has a mutual friend with the AI
		strInfo = strInfo .. "[ICON_BULLET]" .. Locale.ConvertTextKey("TXT_KEY_DIPLO_MUTUAL_DOF") .. "[NEWLINE]"
	end]]--
	--[[if (activePlayer:IsPlayerDenouncedEnemy(iOtherPlayer)) then		-- Human has denounced an enemy of the AI
		strInfo = strInfo .. "[ICON_BULLET]" .. Locale.ConvertTextKey("TXT_KEY_DIPLO_MUTUAL_ENEMY") .. "[NEWLINE]"
	end]]--
	--[[if (pOtherPlayer:GetNumCiviliansReturnedToMe(iActivePlayer) > 0) then
		strInfo = strInfo .. "[ICON_BULLET]" .. Locale.ConvertTextKey("TXT_KEY_DIPLO_CIVILIANS_RETURNED") .. "[NEWLINE]"
	end]]--
	--[[if (pOtherTeam:HasEmbassyAtTeam(iActivePlayer)) then
		strInfo = strInfo .. "[ICON_BULLET]" .. Locale.ConvertTextKey("TXT_KEY_DIPLO_HAS_EMBASSY") .. "[NEWLINE]"
	end]]--
	--[[if (pOtherPlayer:GetNumTimesIntrigueSharedBy(iActivePlayer) > 0) then
		strInfo = strInfo .. "[ICON_BULLET]" .. Locale.ConvertTextKey("TXT_KEY_DIPLO_SHARED_INTRIGUE") .. "[NEWLINE]"
	end]]--
	--[[if (pOtherPlayer:IsPlayerForgivenForSpying(iActivePlayer)) then
		strInfo = strInfo .. "[ICON_BULLET]" .. Locale.ConvertTextKey("TXT_KEY_DIPLO_FORGAVE_FOR_SPYING") .. "[NEWLINE]"
	end]]--
	
	-- Bad things
	--[[if (pOtherPlayer:IsFriendDeclaredWarOnUs(iActivePlayer)) then		-- Human was a friend and declared war on us
		strInfo = strInfo .. "[ICON_BULLET]" .. Locale.ConvertTextKey("TXT_KEY_DIPLO_HUMAN_FRIEND_DECLARED_WAR") .. "[NEWLINE]"
	end]]--
	--[[if (pOtherPlayer:IsFriendDenouncedUs(iActivePlayer)) then			-- Human was a friend and denounced us
		strInfo = strInfo .. "[ICON_BULLET]" .. Locale.ConvertTextKey("TXT_KEY_DIPLO_HUMAN_FRIEND_DENOUNCED") .. "[NEWLINE]"
	end]]--
	--[[if (activePlayer:GetWeDeclaredWarOnFriendCount() > 0) then		-- Human declared war on friends
		strInfo = strInfo .. "[ICON_BULLET]" .. Locale.ConvertTextKey("TXT_KEY_DIPLO_HUMAN_DECLARED_WAR_ON_FRIENDS") .. "[NEWLINE]"
	end]]--
	--[[if (activePlayer:GetWeDenouncedFriendCount() > 0) then			-- Human has denounced his friends
		strInfo = strInfo .. "[ICON_BULLET]" .. Locale.ConvertTextKey("TXT_KEY_DIPLO_HUMAN_DENOUNCED_FRIENDS") .. "[NEWLINE]"
	end]]--
	--[[if (activePlayer:GetNumFriendsDenouncedBy() > 0) then			-- Human has been denounced by friends
		strInfo = strInfo .. "[ICON_BULLET]" .. Locale.ConvertTextKey("TXT_KEY_DIPLO_HUMAN_DENOUNCED_BY_FRIENDS") .. "[NEWLINE]"
	end]]--
	--[[if (activePlayer:IsDenouncedPlayer(iOtherPlayer)) then
		strInfo = strInfo .. "[ICON_BULLET]" .. Locale.ConvertTextKey("TXT_KEY_DIPLO_DENOUNCED_BY_US") .. "[NEWLINE]"
	end]]--
	--[[if (pOtherPlayer:IsDenouncedPlayer(iActivePlayer)) then
		strInfo = strInfo .. "[ICON_BULLET]" .. Locale.ConvertTextKey("TXT_KEY_DIPLO_DENOUNCED_BY_THEM") .. "[NEWLINE]"
	end]]--
	--[[if (pOtherPlayer:IsPlayerDoFwithAnyEnemy(iActivePlayer)) then
		strInfo = strInfo .. "[ICON_BULLET]" .. Locale.ConvertTextKey("TXT_KEY_DIPLO_HUMAN_DOF_WITH_ENEMY") .. "[NEWLINE]"
	end]]--
	--[[if (pOtherPlayer:IsPlayerDenouncedFriend(iActivePlayer)) then
		strInfo = strInfo .. "[ICON_BULLET]" .. Locale.ConvertTextKey("TXT_KEY_DIPLO_HUMAN_DENOUNCED_FRIEND") .. "[NEWLINE]"
	end]]--
	--[[if (pOtherPlayer:IsPlayerNoSettleRequestEverAsked(iActivePlayer)) then
		strInfo = strInfo .. "[ICON_BULLET]" .. Locale.ConvertTextKey("TXT_KEY_DIPLO_NO_SETTLE_ASKED") .. "[NEWLINE]"
	end]]--
	--[[if (pOtherPlayer:IsPlayerStopSpyingRequestEverAsked(iActivePlayer)) then
		strInfo = strInfo .. "[ICON_BULLET]" .. Locale.ConvertTextKey("TXT_KEY_DIPLO_STOP_SPYING_ASKED") .. "[NEWLINE]"
	end]]--
	--[[if (pOtherPlayer:IsDemandEverMade(iActivePlayer)) then
		strInfo = strInfo .. "[ICON_BULLET]" .. Locale.ConvertTextKey("TXT_KEY_DIPLO_TRADE_DEMAND") .. "[NEWLINE]"
	end]]--
	--[[if (pOtherPlayer:GetNumTimesRobbedBy(iActivePlayer) > 0) then
		strInfo = strInfo .. "[ICON_BULLET]" .. Locale.ConvertTextKey("TXT_KEY_DIPLO_CAUGHT_STEALING") .. "[NEWLINE]"
	end]]--
	--[[if (pOtherPlayer:GetNumTimesCultureBombed(iActivePlayer) > 0) then
		strInfo = strInfo .. "[ICON_BULLET]" .. Locale.ConvertTextKey("TXT_KEY_DIPLO_CULTURE_BOMB") .. "[NEWLINE]"
	end]]--
	--[[if (pOtherPlayer:GetNegativeReligiousConversionPoints(iActivePlayer) > 0) then
		strInfo = strInfo .. "[ICON_BULLET]" .. Locale.ConvertTextKey("TXT_KEY_DIPLO_RELIGIOUS_CONVERSIONS") .. "[NEWLINE]"
	end]]--
	--[[if (pOtherPlayer:HasOthersReligionInMostCities(iActivePlayer)) then
		strInfo = strInfo .. "[ICON_BULLET]" .. Locale.ConvertTextKey("TXT_KEY_DIPLO_ADOPTING_MY_RELIGION") .. "[NEWLINE]"
	end]]--
	--[[if (activePlayer:HasOthersReligionInMostCities(iOtherPlayer)) then
		strInfo = strInfo .. "[ICON_BULLET]" .. Locale.ConvertTextKey("TXT_KEY_DIPLO_ADOPTING_HIS_RELIGION") .. "[NEWLINE]"
	end]]--
	--[[local myLateGamePolicies = activePlayer:GetLateGamePolicyTree()
	local otherLateGamePolicies = pOtherPlayer:GetLateGamePolicyTree()
	if (myLateGamePolicies ~= PolicyBranchTypes.NO_POLICY_BRANCH_TYPE and otherLateGamePolicies ~= PolicyBranchTypes.NO_POLICY_BRANCH_TYPE) then
	    local myPoliciesStr = Locale.ConvertTextKey(GameInfo.PolicyBranchTypes[myLateGamePolicies].Description)
	    print (myPoliciesStr)
		if (myLateGamePolicies == otherLateGamePolicies) then
			strInfo = strInfo .. "[ICON_BULLET]" .. Locale.ConvertTextKey("TXT_KEY_DIPLO_SAME_LATE_POLICY_TREES", myPoliciesStr) .. "[NEWLINE]"
		else
			local otherPoliciesStr = Locale.ConvertTextKey(GameInfo.PolicyBranchTypes[otherLateGamePolicies].Description)
			strInfo = strInfo .. "[ICON_BULLET]" .. Locale.ConvertTextKey("TXT_KEY_DIPLO_DIFFERENT_LATE_POLICY_TREES", myPoliciesStr, otherPoliciesStr) .. "[NEWLINE]"
		end
	end]]--
	--[[if (pOtherPlayer:IsPlayerBrokenMilitaryPromise(iActivePlayer)) then
		strInfo = strInfo .. "[ICON_BULLET]" .. Locale.ConvertTextKey("TXT_KEY_DIPLO_MILITARY_PROMISE") .. "[NEWLINE]"
	end]]--
	--[[if (pOtherPlayer:IsPlayerIgnoredMilitaryPromise(iActivePlayer)) then
		strInfo = strInfo .. "[ICON_BULLET]" .. Locale.ConvertTextKey("TXT_KEY_DIPLO_MILITARY_PROMISE_IGNORED") .. "[NEWLINE]"
	end]]--
	--[[if (pOtherPlayer:IsPlayerBrokenExpansionPromise(iActivePlayer)) then
		strInfo = strInfo .. "[ICON_BULLET]" .. Locale.ConvertTextKey("TXT_KEY_DIPLO_EXPANSION_PROMISE") .. "[NEWLINE]"
	end]]--
	--[[if (pOtherPlayer:IsPlayerIgnoredExpansionPromise(iActivePlayer)) then
		strInfo = strInfo .. "[ICON_BULLET]" .. Locale.ConvertTextKey("TXT_KEY_DIPLO_EXPANSION_PROMISE_IGNORED") .. "[NEWLINE]"
	end]]--
	--[[if (pOtherPlayer:IsPlayerBrokenBorderPromise(iActivePlayer)) then
		strInfo = strInfo .. "[ICON_BULLET]" .. Locale.ConvertTextKey("TXT_KEY_DIPLO_BORDER_PROMISE") .. "[NEWLINE]"
	end]]--
	--[[if (pOtherPlayer:IsPlayerIgnoredBorderPromise(iActivePlayer)) then
		strInfo = strInfo .. "[ICON_BULLET]" .. Locale.ConvertTextKey("TXT_KEY_DIPLO_BORDER_PROMISE_IGNORED") .. "[NEWLINE]"
	end]]--
	--[[if (pOtherPlayer:IsPlayerBrokenAttackCityStatePromise(iActivePlayer)) then
		strInfo = strInfo .. "[ICON_BULLET]" .. Locale.ConvertTextKey("TXT_KEY_DIPLO_CITY_STATE_PROMISE") .. "[NEWLINE]"
	end]]--
	--[[if (pOtherPlayer:IsPlayerIgnoredAttackCityStatePromise(iActivePlayer)) then
		strInfo = strInfo .. "[ICON_BULLET]" .. Locale.ConvertTextKey("TXT_KEY_DIPLO_CITY_STATE_PROMISE_IGNORED") .. "[NEWLINE]"
	end]]--
	--[[if (pOtherPlayer:IsPlayerBrokenBullyCityStatePromise(iActivePlayer)) then
		strInfo = strInfo .. "[ICON_BULLET]" .. Locale.ConvertTextKey("TXT_KEY_DIPLO_BULLY_CITY_STATE_PROMISE_BROKEN") .. "[NEWLINE]"
	end]]--
	--[[if (pOtherPlayer:IsPlayerIgnoredBullyCityStatePromise(iActivePlayer)) then
		strInfo = strInfo .. "[ICON_BULLET]" .. Locale.ConvertTextKey("TXT_KEY_DIPLO_BULLY_CITY_STATE_PROMISE_IGNORED") .. "[NEWLINE]"
	end]]--
	--[[if (pOtherPlayer:IsPlayerBrokenSpyPromise(iActivePlayer)) then
		strInfo = strInfo .. "[ICON_BULLET]" .. Locale.ConvertTextKey("TXT_KEY_DIPLO_SPY_PROMISE_BROKEN") .. "[NEWLINE]"
	end]]--
	--[[if (pOtherPlayer:IsPlayerIgnoredSpyPromise(iActivePlayer)) then
		strInfo = strInfo .. "[ICON_BULLET]" .. Locale.ConvertTextKey("TXT_KEY_DIPLO_SPY_PROMISE_IGNORED") .. "[NEWLINE]"
	end]]--
	--[[if (pOtherPlayer:IsPlayerBrokenNoConvertPromise(iActivePlayer)) then
		strInfo = strInfo .. "[ICON_BULLET]" .. Locale.ConvertTextKey("TXT_KEY_DIPLO_NO_CONVERT_PROMISE_BROKEN") .. "[NEWLINE]"
	end]]--
	--[[if (pOtherPlayer:IsPlayerIgnoredNoConvertPromise(iActivePlayer)) then
		strInfo = strInfo .. "[ICON_BULLET]" .. Locale.ConvertTextKey("TXT_KEY_DIPLO_NO_CONVERT_PROMISE_IGNORED") .. "[NEWLINE]"
	end]]--
	--[[if (pOtherPlayer:IsPlayerBrokenCoopWarPromise(iActivePlayer)) then
		strInfo = strInfo .. "[ICON_BULLET]" .. Locale.ConvertTextKey("TXT_KEY_DIPLO_COOP_WAR_PROMISE") .. "[NEWLINE]"
	end]]--
	--[[if (pOtherPlayer:IsPlayerRecklessExpander(iActivePlayer)) then
		strInfo = strInfo .. "[ICON_BULLET]" .. Locale.ConvertTextKey("TXT_KEY_DIPLO_RECKLESS_EXPANDER") .. "[NEWLINE]"
	end]]--
	--[[if (pOtherPlayer:GetNumRequestsRefused(iActivePlayer) > 0) then
		strInfo = strInfo .. "[ICON_BULLET]" .. Locale.ConvertTextKey("TXT_KEY_DIPLO_REFUSED_REQUESTS") .. "[NEWLINE]"
	end]]--
	--[[if (pOtherPlayer:GetRecentTradeValue(iActivePlayer) > 0) then
		strInfo = strInfo .. "[ICON_BULLET]" .. Locale.ConvertTextKey("TXT_KEY_DIPLO_TRADE_PARTNER") .. "[NEWLINE]"	
	end]]--
	--[[if (pOtherPlayer:GetCommonFoeValue(iActivePlayer) > 0) then
		strInfo = strInfo .. "[ICON_BULLET]" .. Locale.ConvertTextKey("TXT_KEY_DIPLO_COMMON_FOE") .. "[NEWLINE]"	
	end]]--
	--[[if (pOtherPlayer:GetRecentAssistValue(iActivePlayer) > 0) then
		strInfo = strInfo .. "[ICON_BULLET]" .. Locale.ConvertTextKey("TXT_KEY_DIPLO_ASSISTANCE_TO_THEM") .. "[NEWLINE]"	
	end	]]--
	--[[if (pOtherPlayer:IsLiberatedCapital(iActivePlayer)) then
		strInfo = strInfo .. "[ICON_BULLET]" .. Locale.ConvertTextKey("TXT_KEY_DIPLO_LIBERATED_CAPITAL") .. "[NEWLINE]"	
	end]]--
	--[[if (pOtherPlayer:IsLiberatedCity(iActivePlayer)) then
		strInfo = strInfo .. "[ICON_BULLET]" .. Locale.ConvertTextKey("TXT_KEY_DIPLO_LIBERATED_CITY") .. "[NEWLINE]"	
	end	]]--
	--[[if (pOtherPlayer:IsGaveAssistanceTo(iActivePlayer)) then
		strInfo = strInfo .. "[ICON_BULLET]" .. Locale.ConvertTextKey("TXT_KEY_DIPLO_ASSISTANCE_FROM_THEM") .. "[NEWLINE]"	
	end	]]--	
	--[[if (pOtherPlayer:IsHasPaidTributeTo(iActivePlayer)) then
		strInfo = strInfo .. "[ICON_BULLET]" .. Locale.ConvertTextKey("TXT_KEY_DIPLO_PAID_TRIBUTE") .. "[NEWLINE]"	
	end	]]--
	--[[if (pOtherPlayer:IsNukedBy(iActivePlayer)) then
		strInfo = strInfo .. "[ICON_BULLET]" .. Locale.ConvertTextKey("TXT_KEY_DIPLO_NUKED") .. "[NEWLINE]"	
	end]]--	
	--[[if (pOtherPlayer:IsCapitalCapturedBy(iActivePlayer)) then
		strInfo = strInfo .. "[ICON_BULLET]" .. Locale.ConvertTextKey("TXT_KEY_DIPLO_CAPTURED_CAPITAL") .. "[NEWLINE]"	
	end	]]--

	-- Protected Minors
	--[[if (pOtherPlayer:IsAngryAboutProtectedMinorKilled(iActivePlayer)) then
		strInfo = strInfo .. "[ICON_BULLET]" .. Locale.ConvertTextKey("TXT_KEY_DIPLO_PROTECTED_MINORS_KILLED") .. "[NEWLINE]"
	end]]--
	--[[if (pOtherPlayer:IsAngryAboutProtectedMinorAttacked(iActivePlayer)) then
		strInfo = strInfo .. "[ICON_BULLET]" .. Locale.ConvertTextKey("TXT_KEY_DIPLO_PROTECTED_MINORS_ATTACKED") .. "[NEWLINE]"
	end]]--
	--[[if (pOtherPlayer:IsAngryAboutProtectedMinorBullied(iActivePlayer)) then
		strInfo = strInfo .. "[ICON_BULLET]" .. Locale.ConvertTextKey("TXT_KEY_DIPLO_PROTECTED_MINORS_BULLIED") .. "[NEWLINE]"
	end]]--
	
	-- Bullied Minors
	--[[if (pOtherPlayer:IsAngryAboutSidedWithTheirProtectedMinor(iActivePlayer)) then
		strInfo = strInfo .. "[ICON_BULLET]" .. Locale.ConvertTextKey("TXT_KEY_DIPLO_SIDED_WITH_MINOR") .. "[NEWLINE]"
	end]]--
	
	--local iActualApproach = pOtherPlayer:GetMajorCivApproach(iActivePlayer)
	
	-- MOVED TO LUAPLAYER
	--[[
	-- Bad things we don't want visible if someone is friendly (acting or truthfully)
	if (iVisibleApproach ~= MajorCivApproachTypes.MAJOR_CIV_APPROACH_FRIENDLY) then-- and
		--iActualApproach ~= MajorCivApproachTypes.MAJOR_CIV_APPROACH_DECEPTIVE) then
		if (pOtherPlayer:GetLandDisputeLevel(iActivePlayer) > DisputeLevelTypes.DISPUTE_LEVEL_NONE) then
			strInfo = strInfo .. "[ICON_BULLET]" .. Locale.ConvertTextKey("TXT_KEY_DIPLO_LAND_DISPUTE") .. "[NEWLINE]"
		end
		--if (pOtherPlayer:GetVictoryDisputeLevel(iActivePlayer) > DisputeLevelTypes.DISPUTE_LEVEL_NONE) then
			--strInfo = strInfo .. "[ICON_BULLET]" .. Locale.ConvertTextKey("TXT_KEY_DIPLO_VICTORY_DISPUTE") .. "[NEWLINE]"
		--end
		if (pOtherPlayer:GetWonderDisputeLevel(iActivePlayer) > DisputeLevelTypes.DISPUTE_LEVEL_NONE) then
			strInfo = strInfo .. "[ICON_BULLET]" .. Locale.ConvertTextKey("TXT_KEY_DIPLO_WONDER_DISPUTE") .. "[NEWLINE]"
		end
		if (pOtherPlayer:GetMinorCivDisputeLevel(iActivePlayer) > DisputeLevelTypes.DISPUTE_LEVEL_NONE) then
			strInfo = strInfo .. "[ICON_BULLET]" .. Locale.ConvertTextKey("TXT_KEY_DIPLO_MINOR_CIV_DISPUTE") .. "[NEWLINE]"
		end
		if (pOtherPlayer:GetWarmongerThreat(iActivePlayer) > ThreatTypes.THREAT_NONE) then
			strInfo = strInfo .. "[ICON_BULLET]" .. Locale.ConvertTextKey("TXT_KEY_DIPLO_WARMONGER_THREAT") .. "[NEWLINE]"
		end
	end
	]]--
	
	local aOpinion = pOtherPlayer:GetOpinionTable(iActivePlayer)
	--local aOpinionList = {}
	for i,v in ipairs(aOpinion) do
		--aOpinionList[i] = "[ICON_BULLET]" .. v .. "[NEWLINE]"
		strInfo = strInfo .. "[ICON_BULLET]" .. v .. "[NEWLINE]"
	end
	--strInfo = table.cat(aOpinionList, "[NEWLINE]")

	--  No specific events - let's see what string we should use
	if (strInfo == "") then
		
		-- Appears Friendly
		if (iVisibleApproach == MajorCivApproachTypes.MAJOR_CIV_APPROACH_FRIENDLY) then
			strInfo = strInfo .. "[ICON_BULLET]" .. Locale.ConvertTextKey("TXT_KEY_DIPLO_FRIENDLY")
		-- Appears Guarded
		elseif (iVisibleApproach == MajorCivApproachTypes.MAJOR_CIV_APPROACH_GUARDED) then
			strInfo = strInfo .. "[ICON_BULLET]" .. Locale.ConvertTextKey("TXT_KEY_DIPLO_GUARDED")
		-- Appears Hostile
		elseif (iVisibleApproach == MajorCivApproachTypes.MAJOR_CIV_APPROACH_HOSTILE) then
			strInfo = strInfo .. "[ICON_BULLET]" .. Locale.ConvertTextKey("TXT_KEY_DIPLO_HOSTILE")
		-- Neutral - default string
		else
			strInfo = "[ICON_BULLET]" .. Locale.ConvertTextKey("TXT_KEY_DIPLO_DEFAULT_STATUS")
		end
	end
	
	-- Remove extra newline off the end if we have one
	if (Locale.EndsWith(strInfo, "[NEWLINE]")) then
		local iNewLength = Locale.Length(strInfo)-9
		strInfo = Locale.Substring(strInfo, 1, iNewLength)
	end
	
	return strInfo
	
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
