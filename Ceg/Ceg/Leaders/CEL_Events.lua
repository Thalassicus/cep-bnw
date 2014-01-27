-- BL - General
-- Author: Thalassicus
-- DateCreated: 2/17/2011 4:00:14 PM
--------------------------------------------------------------

include("MT_Events.lua")
include("YieldLibrary.lua")

local log = Events.LuaLogger:New()
log:SetLevel("INFO")

--[[
function DoEndCombatLeaderBonuses(
		attPlayerID,
		attUnitID,
		attUnitDamage,
		attFinalUnitDamage,
		attMaxHitPoints,
		defPlayerID,
		defUnitID,
		defUnitDamage,
		defFinalUnitDamage,
		defMaxHitPoints
		)
	log:Debug("DoEndCombatLeaderBonuses")

	local wonPlayer, wonUnit, wonCity, lostPlayer, lostUnit, lostCity

	if defFinalUnitDamage >= defMaxHitPoints then
		wonPlayer	= Players[attPlayerID]
		lostPlayer	= Players[defPlayerID]
		wonUnit		= wonPlayer:GetUnitByID(attUnitID)
		lostUnit	= lostPlayer:GetUnitByID(defUnitID)
	elseif attFinalUnitDamage >= attMaxHitPoints then
		wonPlayer	= Players[defPlayerID]
		lostPlayer	= Players[attPlayerID]
		wonUnit		= wonPlayer:GetUnitByID(defUnitID)
		lostUnit	= lostPlayer:GetUnitByID(attUnitID)
	end

	if not wonPlayer then
		return
	end
	
	wonCity = not wonUnit
	lostCity = not lostUnit

	--log:Trace("%20s   %3s", "attPlayerID",			attPlayerID)
	--log:Trace("%20s   %3s", "attUnitID",			attUnitID)
	--log:Trace("%20s   %3s", "attUnitDamage",		attUnitDamage)
	--log:Trace("%20s   %3s", "attFinalUnitDamage",	attFinalUnitDamage)
	--log:Trace("%20s   %3s", "attMaxHitPoints",		attMaxHitPoints)
	--log:Trace("%20s   %3s", "defPlayerID",			defPlayerID)
	--log:Trace("%20s   %3s", "defUnitID",			defUnitID)
	--log:Trace("%20s   %3s", "defUnitDamage",		defUnitDamage)
	--log:Trace("%20s   %3s", "defFinalUnitDamage",	defFinalUnitDamage)
	--log:Trace("%20s   %3s", "defMaxHitPoints",		defMaxHitPoints)
	--log:Trace("%20s   %3s", "wonPlayer",			wonPlayer:GetName())
	--log:Trace("%20s   %3s", "lostPlayer",			lostPlayer:GetName())
	--log:Trace("%20s   %3s", "wonUnit",				wonUnit and GameInfo.Units[wonUnit:GetUnitType()].Type or "City")
	--log:Trace("%20s   %3s", "lostUnit",				lostUnit and GameInfo.Units[lostUnit:GetUnitType()].Type or "City")

	local playerTrait		= wonPlayer:GetTraitInfo()
	local culturePerStr		= playerTrait.CultureFromKills / 100
	local barbCaptureLand	= playerTrait.LandBarbarianCapturePercent
	local barbCaptureSea	= playerTrait.SeaBarbarianCapturePercent
	local goldenPoints		= 0
	if wonUnit then
		for promoInfo in GameInfo.UnitPromotions("GoldenPoints <> 0") do
			if wonUnit:IsHasPromotion(promoInfo.ID) then
				goldenPoints = goldenPoints + promoInfo.GoldenPoints
			end
		end
		if goldenPoints > 0 then
			local yield = wonPlayer:GetUnitProductionNeeded(lostUnit:GetUnitType())
			yield = math.pow(yield * GameDefines.GOLD_PURCHASE_GOLD_PER_PRODUCTION, GameDefines.HURRY_GOLD_PRODUCTION_EXPONENT)
			yield = yield * (1 + GameInfo.Units[lostUnit:GetUnitType()].HurryCostModifier / 100)
			yield = Game.Round(yield / 100)
			wonPlayer:ChangeYieldStored(YieldTypes.YIELD_HAPPINESS_CITY, yield)
		end
	end
	if lostUnit and culturePerStr > 0 then
		local strength = GameInfo.Units[lostUnit:GetUnitType()].Combat
		local culture = culturePerStr * strength
		local leastCultureCity = wonPlayer:GetCapitalCity()
		for city in wonPlayer:Cities() do
			if not city:IsPuppet() and not city:IsRazing() then
				if city:GetJONSCultureLevel() == leastCultureCity:GetJONSCultureLevel() then
					if City_GetYieldStored(city, YieldTypes.YIELD_CULTURE) < City_GetYieldStored(leastCultureCity, YieldTypes.YIELD_CULTURE) then
						leastCultureCity = city
					end
				elseif city:GetJONSCultureLevel() < leastCultureCity:GetJONSCultureLevel() then
					leastCultureCity = city
				end
			end
		end
		leastCultureCity:ChangeJONSCultureStored(culture)
		--log:Debug(leastCultureCity:GetName().." +"..culture.." culture from killing "..lostUnit:GetName())
		cultureStored = City_GetYieldStored(leastCultureCity, YieldTypes.YIELD_CULTURE)
		cultureNext = City_GetYieldNeeded(leastCultureCity, YieldTypes.YIELD_CULTURE)
		cultureDiff = cultureNext - cultureStored
		if cultureDiff <= 0 then
			leastCultureCity:DoJONSCultureLevelIncrease()
			leastCultureCity:SetJONSCultureStored(-cultureDiff)
		end
	end
	if (lostPlayer:IsBarbarian()
		and lostUnit
		and lostUnit:IsCombatUnit()
		and ((lostUnit:GetDomainType() == DomainTypes.DOMAIN_LAND and barbCaptureLand > 0)
			or (lostUnit:GetDomainType() == DomainTypes.DOMAIN_SEA and barbCaptureSea > 0))
		) then
		--if wonCity or (wonUnit:GetDomainType() == lostUnit:GetDomainType()) then
		local randChance = (1 + Map.Rand(99, "BL - General: DoEndCombatLeaderBonuses - barbCapture"))
		log:Debug("Barbarian dead, checking " ..barbCaptureLand.. " >= " ..randChance)
		if barbCaptureLand >= randChance or barbCaptureSea >= randChance then
			--log:Debug("%s captured barbarian %s", wonPlayer:GetName(), lostUnit:GetName())
			local plot = lostUnit:GetPlot()
			local newUnitID = GameInfo.Units[lostUnit:GetUnitType()].ID
			if newUnitID == GameInfo.Units.UNIT_SETTLER.ID then
				newUnitID = GameInfo.Units.UNIT_WORKER.ID
			end
			local newUnit = wonPlayer:InitUnit( newUnitID, plot:GetX(), plot:GetY() )
			if lostUnit:GetDomainType() == DomainTypes.DOMAIN_LAND then
				newUnit:SetDamage(0.75 * newUnit:GetMaxHitPoints(), wonPlayer)
			end
			newUnit:SetMadeAttack(true)
			newUnit:SetMoves(1)
		end
	end
end

Events.EndCombatSim.Add( DoEndCombatLeaderBonuses )
--]]

---------------------------------------------------------------------
---------------------------------------------------------------------


--
function FreeUnitWithTech(player, techID, changeID)
	local playerID = player:GetID()
	
	local player = Players[playerID]
	--print(tostring(player))
	--print(tostring(player.GetID))
	--print(tostring(player:GetID())) -- crashes with citystates?!
	local techInfo = GameInfo.Technologies[techID]
	local centerPlot = player:GetCapitalCity()
	
	--print(tostring(playerID), tostring(techID))
	if player:IsMinorCiv() or Game.GetGameTurn() <= 1 then
		return
	end
	
	if centerPlot then
		centerPlot = centerPlot:Plot()
	else
		-- no capital yet
		for unit in player:Units() do
			if unit:GetUnitType() == player:GetUniqueUnitID("UNITCLASS_SETTLER") then
				centerPlot = unit:GetPlot()
				break
			end
		end
	end
	
	log:Debug("FreeUnitWithTech A player=%s tech=%s", player:GetName(), techID)
	local query = string.format("TraitType='%s' AND TechType='%s'", player:GetTraitInfo().Type, techInfo.Type)
	for row in GameInfo.Trait_FreeUnitAtTech(query) do
		local unitInfo = GameInfo.Units[player:GetUniqueUnitID(row.UnitClassType)]		
		local plot = centerPlot
		local unit = nil
		if unitInfo.Domain == "DOMAIN_SEA" then		
			plot = Plot_GetNearestOceanPlot(centerPlot, 10, 0.1 * Map.GetNumPlots())
			if not plot then
				log:Warn("Could not find large ocean near %s for free ship. Searching smaller bodies of water...", player:GetName())
				plot = Plot_GetNearestOceanPlot(centerPlot, 10)
			end
			if plot then
				log:Info("FreeUnitWithTech %s %s", player:GetName(), techInfo.Type)
				unit = player:InitUnitType(unitInfo.Type, plot)
			else
				log:Warn("No coastal plot near %s for free ship!", player:GetName())
				plot = centerPlot
				if plot:IsCoastalLand() then
					unit = player:InitUnitType(unitInfo.Type, plot)
				end
			end
		else
			unit = player:InitUnitType(unitInfo.Type, plot)
		end
		local promotionType = row.PromotionType
		if promotionType then
			local promotionID = GameInfo.UnitPromotions[promotionType].ID
			unit:SetHasPromotion(promotionID, true)
		end
	end
end
LuaEvents.NewTech.Add(FreeUnitWithTech)
--]]

--[[
MapModData.CepHasFreeShip = {}
for playerID, player in pairs(Players) do
	if player:IsAliveCiv() and not player:IsMinorCiv() then
		MapModData.CepHasFreeShip[playerID] = player:HasTech("TECH_COMPASS")
	end
end

function DoSpainCaravelHack(player)
	if player:GetTraitInfo().Type ~= "TRAIT_SEVEN_CITIES" or MapModData.CepHasFreeShip[player:GetID()] then
		return
	end
	
	local capital = player:GetCapitalCity()
	if capital and player:HasTech("TECH_COMPASS") then
		MapModData.CepHasFreeShip[playerID] = true
		local centerPlot = capital:Plot()

		local plot = Plot_GetNearestOceanPlot(centerPlot, 10, 0.1 * Map.GetNumPlots())
		if not plot then
			log:Warn("Could not find large ocean near %s for free ship. Searching smaller bodies of water...", player:GetName())
			plot = Plot_GetNearestOceanPlot(centerPlot, 10)
		end
		if plot then
			player:InitUnitType("UNIT_CARAVEL", plot)
		else
			log:Warn("No coastal plot near %s for free ship!", player:GetName())
			plot = centerPlot
			if plot:IsCoastalLand() then
				player:InitUnitType("UNIT_CARAVEL", plot)
			end
		end
	end
end
LuaEvents.ActivePlayerTurnStart_Player.Add(DoSpainCaravelHack)
--]]

---------------------------------------------------------------------
---------------------------------------------------------------------

function NationalWonderDiscoveryBonus(...)
	local arg = {...}
	for index,value in ipairs(arg) do
		log:Warn("arg=%s type=%s value=%s", index, type(value), value)
	end
end

--Events.NaturalWonderRevealed.Add(NationalWonderDiscoveryBonus)

---------------------------------------------------------------------
---------------------------------------------------------------------

function DoLeaderCaptureBonuses(city, player)
	local traitInfo = player:GetTraitInfo()
	
	for info in GameInfo.Trait_CityCaptureInstantYield{TraitType = traitInfo.Type} do
		local yieldInfo = GameInfo.Yields[info.YieldType]
		local totalYield = (info.Yield or 0)
		if info.YieldPerPop then
			totalYield = totalYield + info.YieldPerPop * city:GetPopulation()
		end
		if info.YieldPerEra then
			totalYield = totalYield + info.YieldPerEra * (info.YieldPerEraExponent or 1) ^ player:GetCurrentEra()
		end
		player:ChangeYieldStored(yieldInfo.ID, totalYield)
		
		local yieldName = Locale.ConvertTextKey(yieldInfo.Description)
		local alertText = Locale.ConvertTextKey("TXT_KEY_CITY_CAPTURE_YIELD", totalYield, yieldInfo.IconString, yieldName, city:GetName())
		log:Info("%s: +%s %s %s from %s", player:GetName(), totalYield, yieldInfo.IconString, yieldName, city:GetName())
		log:Info("%s: '%s'", player:GetName(), alertText)
		Game.AlertIfActive(alertText, player)
	end
end
LuaEvents.CityCaptureBonuses.Add(function(city, player) return SafeCall(DoLeaderCaptureBonuses, city, player) end)

function DoReligiousUnitSafety(unit)
	local unitInfo = GameInfo.Units[unit:GetUnitType()]
	
	if unitInfo.ReligionSpreads == 0 then
		return
	end
	
	if not unit:IsCombatUnit() or unit:GetSpreadsLeft() > 1 then
		-- missionary, or safe number of spreads remaining
		return
	end
	
	Unit_ReplaceWithType(unit, unitInfo.Type .. "_NO_RELIGION")
end
LuaEvents.ActivePlayerTurnEnd_Unit.Add(function(unit) return SafeCall(DoReligiousUnitSafety, unit) end)

function DoLeaderStartBonuses(player)
	if Game.GetGameTurn() > 10 then
		--DoImmigration(player)
		DoCitystateSurrender(player)
	end
	DoLuxuryTradeBonus(player)
	
	local traitInfo = player:GetTraitInfo()
	local capital = player:GetCapitalCity()
	
	if traitInfo.HanseaticLeague then
		local building = GameInfo.Buildings[traitInfo.HanseaticLeague]
		if building and capital then
			capital:SetNumRealBuilding(building.ID, 1)
		end
	end
end
LuaEvents.ActivePlayerTurnStart_Player.Add(function(player) return SafeCall(DoLeaderStartBonuses, player) end)

function DoImmigration(player)
	local immigrationFrequency = player:GetTraitInfo().ImmigrationFrequency
	if Game.GetGameTurn() < 10 or immigrationFrequency == nil or immigrationFrequency <= 0 then
		return
	end
	
	log:Debug("%-25s %15s", "DoImmigration", player:GetName())
end

function DoCitystateSurrender(player)
	if not player:GetTraitInfo().BullySurrender then
		return
	end
	
	local playerID = player:GetID()
	local activePlayer = Players[Game.GetActivePlayer()]
	for csID, cs in pairs(Players) do
		if cs:IsAliveCiv() and cs:IsMinorCiv() and cs:CanMajorBullyUnit(playerID) and cs:IsAtPeace(player) then
			local capital = cs:GetCapitalCity()
				local alertText = string.format("%s surrenders in fear to %s!", cs:GetName(), player:GetName())
				log:Info(alertText)
				for city in cs:Cities() do
					player:AcquireCity(city, true, false)
				end
				if activePlayer:HasMet(cs) then
					Events.GameplayAlertMessage(alertText, player)
				end
		end
	end
end

function DoLuxuryTradeBonus(player)
	local capital = player:GetCapitalCity()
	
	if not capital then
		return
	end
	local traitInfo = player:GetTraitInfo()
	local luxuryPercent = traitInfo.CityGoldPerLuxuryPercent
	if luxuryPercent == 0 then
		return
	end
	
	log:Info("%-25s %15s", "DoLuxuryTradeBonus", player:GetName())
	local luxuryTotal = 0
	for resourceInfo in GameInfo.Resources() do
		local resourceID = resourceInfo.ID;
		if Game.GetResourceUsageType(resourceID) == ResourceUsageTypes.RESOURCEUSAGE_LUXURY then
			if player:GetNumResourceAvailable(resourceID, true) > 0 then
				luxuryTotal = luxuryTotal + 1
			end
		end
	end

	local buildingID = player:GetUniqueBuildingID(traitInfo.CityGoldPerLuxuryBuildingClass or "BUILDINGCLASS_AMSTERDAM_BOURSE")
	capital:SetNumRealBuilding(buildingID, luxuryTotal * luxuryPercent)
end


function CheckMigration(player)
	local trait = player:GetTraitInfo()
	if not trait.ImmigrationFrequency or trait.ImmigrationFrequency == 0 then--or Game.GetAdjustedTurn() % trait.ImmigrationFrequency ~= 0 then
		return
	end
	
	local migrationRoutes = {}
	local migrationWeights = {}
	for routeID, route in ipairs(player:GetTradeRoutes()) do
		if route.FromID == route.ToID then
			-- domestic route
			local cityID = City_GetID(route.FromCity)
			if route.Food and route.Food > 0 then
				table.insert(migrationRoutes, {fromCity = route.FromCity, toCity = route.ToCity})
				table.insert(migrationWeights, route.FromCity:GetPopulation() / (route.ToCity:GetPopulation() or 1))
			end
		end
	end

	if #migrationRoutes == 0 then
		log:Info("No migration routes for %s", player:GetName())
		return
	end
	
	local chosenRouteID = Game.GetRandomWeighted(migrationWeights)
	--log:Error("migrationRoutes[%s]=%s fromCity=%s", chosenRouteID, migrationRoutes[chosenRouteID], migrationRoutes[chosenRouteID] and migrationRoutes[chosenRouteID].fromCity and migrationRoutes[chosenRouteID].fromCity:GetName())
	migrationRoutes[chosenRouteID].fromCity:ChangePopulation(-1, true)
	migrationRoutes[chosenRouteID].toCity:ChangePopulation(1, true)
	
	local odds = migrationWeights[chosenRouteID] * 100
	
	if odds >= Map.Rand(100, "Migration - Lua") then
		local alertText = Game.ConvertTextKey("TXT_KEY_MIGRATE_WITHIN", fromCity:GetName(), toCity:GetName())
		log:Info("%s: '%s'", player:GetName(), alertText)
		Game.AlertIfActive(alertText, player)
	end	
end
LuaEvents.ActivePlayerTurnEnd_Player.Add(function(player) return SafeCall(CheckMigration, player) end)

function UpdateTribute(player)
	local trait = player:GetTraitInfo()
	if not trait.Tribute then
		return
	end

	local tributeCities = {}
	for routeID, route in ipairs(player:GetTradeRoutes()) do
		if route.FromID == route.ToID then
			-- domestic route
			local cityID = City_GetID(route.ToCity)
			tributeCities[cityID] = (tributeCities[cityID] or 0) + 5 + 2 * player:GetCurrentEra()
		end
	end

	local tributeBuildingID = GameInfo.Buildings[trait.Tribute].ID
	for city in player:Cities() do
		city:SetNumRealBuilding(tributeBuildingID, tributeCities[City_GetID(city)] or 0)
	end
end


LuaEvents.ActivePlayerTurnStart_Player.Add(function(player) return SafeCall(UpdateTribute, player) end)
LuaEvents.ActivePlayerTurnEnd_Player.Add(function(player) return SafeCall(UpdateTribute, player) end)