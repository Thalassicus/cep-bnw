-- CEAI_Events.lua
-- Author: Thalassicus
-- DateCreated: 6/6/2011 2:11:50 PM
--------------------------------------------------------------

include("MT_Events.lua")
include("YieldLibrary.lua")
include("FLuaVector")

local log = Events.LuaLogger:New()
log:SetLevel("INFO")

if not Cep then
	print("Cep table does not exist!")
	--return
end
--

--
-- Spend AI gold more intelligently
--

--[[

The AI faces two questions:	
	1)  Will I spend gold?
		Yes, if I have more goldStored than the goldHigh, and my profit-per-turn is positive.
	2)  How much gold will I spend?
		The budget is (goldStored - goldMin), stopping when under goldLow
	
An AI with +20g per turn, 400 goldStored and a 500 goldHigh threshold decides:
	1)  I will not spend gold.
	
An AI with -10g per turn, 800 goldStored and a 500 goldHigh threshold decides:
	1)  I will not spend gold.
	
An AI with +20g per turn, 800 goldStored and a 500 goldHigh threshold decides:
	1)  I will spend gold.
	2)  My budget is 700 gold (800-100).
	3)  I will continue purchasing things until I spend 700 gold,
		without going below the minimum of 100 gold,
		and without going below 0g per turn profit.

--]]

local warUnitFlavorsEarly = {
	{FlavorType="FLAVOR_MOBILE",			Mult=1, Promos={GameInfo.UnitPromotions.PROMOTION_SHOCK_1.ID}}		,
	{FlavorType="FLAVOR_MELEE",				Mult=3, Promos={GameInfo.UnitPromotions.PROMOTION_DRILL_1.ID}}		,
	{FlavorType="FLAVOR_SIEGE",				Mult=1, Promos={GameInfo.UnitPromotions.PROMOTION_SIEGE.ID}}			,
	{FlavorType="FLAVOR_RANGED",			Mult=2, Promos={GameInfo.UnitPromotions.PROMOTION_BARRAGE_1.ID}}		,
	{FlavorType="FLAVOR_NAVAL_BOMBARDMENT",	Mult=1, Promos={GameInfo.UnitPromotions.PROMOTION_BOMBARDMENT_1.ID}}	,
	{FlavorType="FLAVOR_ANTI_MOBILE",		Mult=1, Promos={GameInfo.UnitPromotions.PROMOTION_SHOCK_1.ID}}
}

local warUnitFlavorsLate = {
	{FlavorType="FLAVOR_MOBILE",			Mult=1, Promos={GameInfo.UnitPromotions.PROMOTION_SHOCK_1.ID,		GameInfo.UnitPromotions.PROMOTION_SHOCK_2.ID}}			,
	{FlavorType="FLAVOR_AIR",				Mult=1, Promos={}},
	{FlavorType="FLAVOR_MELEE",				Mult=3, Promos={GameInfo.UnitPromotions.PROMOTION_DRILL_1.ID,		GameInfo.UnitPromotions.PROMOTION_DRILL_2.ID}}			,
	{FlavorType="FLAVOR_SIEGE",				Mult=1, Promos={GameInfo.UnitPromotions.PROMOTION_ACCURACY_1.ID,		GameInfo.UnitPromotions.PROMOTION_SIEGE.ID}}			,
	{FlavorType="FLAVOR_RANGED",			Mult=2, Promos={GameInfo.UnitPromotions.PROMOTION_DRILL_1.ID,		GameInfo.UnitPromotions.PROMOTION_DRILL_2.ID}}			,
	{FlavorType="FLAVOR_NAVAL_BOMBARDMENT",	Mult=1, Promos={GameInfo.UnitPromotions.PROMOTION_BOMBARDMENT_1.ID,	GameInfo.UnitPromotions.PROMOTION_BOMBARDMENT_2.ID}}	,
	{FlavorType="FLAVOR_ANTI_MOBILE",		Mult=1, Promos={GameInfo.UnitPromotions.PROMOTION_SHOCK_1.ID,		GameInfo.UnitPromotions.PROMOTION_AMBUSH_1.ID}},
	{FlavorType="FLAVOR_ANTIAIR",			Mult=1, Promos={}}			
}

function SpendAIGold(player)
	if (player:IsHuman()
			or not player:GetCapitalCity() 
			or player:IsBudgetGone(0)
			--or (Game.GetAdjustedTurn() < 10)
			) then
		return
	end
	
	if player:IsMinorCiv() then
		return UpgradeSomeUnit(player, player:GetYieldStored(YieldTypes.YIELD_GOLD))
	end

	local capital			= player:GetCapitalCity()	
	local playerID			= player:GetID()
	local eraID				= Game.GetAverageHumanEra()
	local isWarHuman		= player:IsAtWarWithHuman()
	local isWarAny			= player:IsAtWarWithAny()
	local isEarlyEra		= (player:GetCurrentEra() < GameInfo.Eras.ERA_RENAISSANCE.ID)
	local activePlayer		= Players[Game.GetActivePlayer()]
	local costRA			= GameInfo.Eras[eraID].ResearchAgreementCost * Game.GetSpeedInfo().GoldPercent / 100
	local goldStored		= player:GetYieldStored(YieldTypes.YIELD_GOLD)
	local goldHigh			= Game.Round(costRA * Cep.AI_PURCHASE_BUDGET_HIGH)
	local goldLow			= Game.Round(costRA * Cep.AI_PURCHASE_BUDGET_LOW)
	local goldMin			= Game.Round(costRA * Cep.AI_PURCHASE_BUDGET_MINIMUM)
	local cities			= {}
	local citiesReverse		= {}
	local ports				= {}
	local portsReverse		= {}
	local numMilitaryLand	= 0
	local numMilitaryTotal	= 0
	local numHealers		= 0
	local numWorkers		= 0
	local totalUnitFlavor	= {}
	local medicID			= GameInfo.UnitPromotions.PROMOTION_MEDIC.ID
	
	--
	log:Debug("%-15s %20s %3s available (%s threshold, %s minimum)",
		"AIPurchase",
		player:GetName(),
		goldStored,
		goldHigh,
		goldMin
	)
	--]]
	
	if goldStored < goldHigh then
		return
	end
	
	--
	-- Create lists
	--
	
	for city in player:Cities() do
		if not city:IsResistance() and not city:IsRazing() and not city:IsCapital() then
			table.insert(cities, {id=City_GetID(city), pop=city:GetPopulation()})
			if city:IsCoastal() then
				table.insert(ports, {id=City_GetID(city), pop=city:GetPopulation()})				
			end
		end
	end
	table.sort(cities, function(a, b) return a.pop < b.pop end)
	table.sort(ports, function(a, b) return a.pop < b.pop end)
	citiesReverse = Game.Reverse(cities)
	portsReverse = Game.Reverse(ports)
	
	-- capital gets first priority
	table.insert(cities, 			1, {id=City_GetID(capital), pop=capital:GetPopulation()})
	table.insert(citiesReverse, 	1, {id=City_GetID(capital), pop=capital:GetPopulation()})
	if capital:IsCoastal() then
		table.insert(ports, 		1, {id=City_GetID(capital), pop=capital:GetPopulation()})
		table.insert(portsReverse,	1, {id=City_GetID(capital), pop=capital:GetPopulation()})
	end
	
	for flavorInfo in GameInfo.Flavors() do
		totalUnitFlavor[flavorInfo.Type] = 0
	end
	
	for unit in player:Units() do
		if Unit_IsWorker(unit) then
			numWorkers = numWorkers + 1
		elseif Unit_IsCombatDomain(unit, "DOMAIN_LAND") then
			if unit:IsHasPromotion(medicID) then
				numHealers = numHealers + 1
			else
				numMilitaryLand = numMilitaryLand + 1
			end
		end
		if unit:IsCombatUnit() then
			numMilitaryTotal = numMilitaryTotal + 1
		end
		
		for info in GameInfo.Unit_Flavors{UnitType = GameInfo.Units[unit:GetUnitType()].Type} do
			totalUnitFlavor[info.FlavorType] = totalUnitFlavor[info.FlavorType] + info.Flavor / 8
		end
	end
	for k, v in pairs(totalUnitFlavor) do
		totalUnitFlavor[k] = Game.Round(totalUnitFlavor[k])
	end

	--
	-- Critical priorities
	--
	
	-- Negative income
	if player:GetYieldRate(YieldTypes.YIELD_GOLD) < 0 then
		local attempt = 0
		while PurchaseBuildingOfFlavor(player, cities, 0, "FLAVOR_GOLD") and attempt <= Cep.AI_PURCHASE_FLAVOR_MAX_ATTEMPTS do
			attempt = attempt + 1
		end
		if player:IsBudgetGone(0) then return end
	end
	
	-- Severe negative happiness
	if player:GetYieldRate(YieldTypes.YIELD_HAPPINESS_CITY) <= -10 then
		local attempt = 0
		while PurchaseBuildingOfFlavor(player, cities, 0, "FLAVOR_HAPPINESS") and attempt <= Cep.AI_PURCHASE_FLAVOR_MAX_ATTEMPTS do
			attempt = attempt + 1
		end
		if player:IsBudgetGone(0) then return end
	end
	
	-- Found religion
	if player:CanFoundFaith() then
		local leaderInfo = GameInfo.Leaders[player:GetLeaderType()]
		local relFlavor = Game.GetValue("Flavor", {LeaderType=leaderInfo.Type, FlavorType="FLAVOR_RELIGION"}, GameInfo.Leader_Flavors)
		-- Go for faith if religious, or pantheons are available.
		if relFlavor >= 7 or (player:CanCreatePantheon(false) and not player:HasCreatedPantheon()) then
			if relFlavor >= Map.Rand(10, "Found religion") then
				PurchaseBuildingOfFlavor(player, cities, 0, "FLAVOR_RELIGION")
			end
		end
		if player:IsBudgetGone(0) then return end
	end

	-- First workers
	if isEarlyEra then
		PurchaseUnitsOfFlavor(player, cities, 0, "FLAVOR_TILE_IMPROVEMENT", (player:IsMilitaristicLeader() and 1 or 2) - numWorkers)
		if player:IsBudgetGone(0) then return end
	end
	
	-- Settle cities
	if #cities < 3 and isEarlyEra then
		PurchaseUnitsOfFlavor(player, cities, 0, "FLAVOR_EXPANSION", 3 - (#cities + totalUnitFlavor.FLAVOR_EXPANSION))
		if player:IsBudgetGone(0) then
			-- save gold for settlers
			return
		end
	end
	
	--
	-- Moderate priorities
	--

	if player:IsBudgetGone(goldLow) then return end
	
	-- City Defense
	local numBuy = 0
	if isWarAny or player:IsMilitaristicLeader() then
		numBuy = math.min(isWarHuman and 5 or 1, #cities - numMilitaryLand)
		PurchaseUnitsOfFlavor(player, cities, goldMin, "FLAVOR_CITY_DEFENSE", numBuy)
		if player:IsBudgetGone(goldLow) then return end
		
		PurchaseUnitsOfFlavor(player, ports, goldMin,
			"FLAVOR_NAVAL",
			1 + #ports - totalUnitFlavor.FLAVOR_NAVAL,
			{GameInfo.UnitPromotions.PROMOTION_TARGETING_1.ID}
		)
		if player:IsBudgetGone(goldLow) then return end
	end
	
	-- Negative happiness
	if player:GetYieldRate(YieldTypes.YIELD_HAPPINESS_CITY) < 0 then
		local attempt = 0
		while PurchaseBuildingOfFlavor(player, cities, goldMin, "FLAVOR_HAPPINESS") and attempt <= Cep.AI_PURCHASE_FLAVOR_MAX_ATTEMPTS do
			attempt = attempt + 1
		end
		if player:IsBudgetGone(goldLow) then return end
	end
	
	-- Upgrades
	local upgradesPerformed = 0
	if player:IsMilitaristicLeader() or isWarHuman then
		while UpgradeSomeUnit(player, goldMin) and upgradesPerformed < 10 do
			upgradesPerformed = upgradesPerformed + 1
			if player:IsBudgetGone(goldLow) then return end
		end
	end
	
	-- Diplomatic victory
	if MapModData.Cep_DiploVictoryUnlocked then
		PurchaseAllInfluence(player, goldMin)
		if player:IsBudgetGone(goldLow) then return end
	end

	-- Workers
	PurchaseUnitsOfFlavor(player, cities, goldMin, "FLAVOR_TILE_IMPROVEMENT",	1 + #cities - numWorkers)
	if player:IsBudgetGone(goldLow) then return end
	
	-- Research
	PurchaseBuildingOfFlavor(player, cities, goldMin, "FLAVOR_SCIENCE")
	if player:IsBudgetGone(goldLow) then return end
	
	-- Monuments
	if #cities <= 2 and isEarlyEra then
		PurchaseBuildingOfFlavor(player, cities, goldMin, "FLAVOR_CULTURE")
		if player:IsBudgetGone(goldLow) then return end
	end
	
	-- Healers
	PurchaseUnitsOfFlavor(player, cities, goldMin,
		"FLAVOR_HEALING",
		1 + numMilitaryLand/5 - numHealers,
		{GameInfo.UnitPromotions.PROMOTION_SCOUTING_1.ID, medicID}
	)
	if player:IsBudgetGone(goldLow) then return end
	
	-- War
	if isWarAny then
		local numBuy = 1
		local maxMilitary = 1 + #cities
		if player:IsMilitaristicLeader() or isWarHuman then
			numBuy = 2 * numBuy
			maxMilitary = Game.Round(2 * maxMilitary)
		end
		
		if isEarlyEra then
			for _, info in ipairs(warUnitFlavorsEarly) do
				if numMilitaryTotal >= maxMilitary then break end
				numMilitaryTotal = numMilitaryTotal + PurchaseUnitsOfFlavor(player, cities, goldMin, info.FlavorType, info.Mult * numBuy - (totalUnitFlavor[flavorType] or 0), info.Promos)
				if player:IsBudgetGone(goldLow) then return end
			end
		else
			for _, info in ipairs(warUnitFlavorsLate) do
				if numMilitaryTotal >= maxMilitary then break end
				numMilitaryTotal = numMilitaryTotal + PurchaseUnitsOfFlavor(player, cities, goldMin, info.FlavorType, info.Mult * numBuy - (totalUnitFlavor[flavorType] or 0), info.Promos)
				if player:IsBudgetGone(goldLow) then return end
			end
		end
	end
	
	-- Scouts
	if isEarlyEra then
		PurchaseUnitsOfFlavor(player, cities, goldMin, "FLAVOR_RECON", 3 - totalUnitFlavor.FLAVOR_RECON, {GameInfo.UnitPromotions.PROMOTION_SCOUTING_1.ID, GameInfo.UnitPromotions.PROMOTION_SCOUTING_2.ID})
		if player:IsBudgetGone(goldLow) then return end
	end
	
	--log:Debug("goldStored=%s goldHigh=%s goldMin=%s", player:GetYieldStored(YieldTypes.YIELD_GOLD), goldHigh, goldMin)
	if player:IsBudgetGone(goldLow) then return end
	
	
	-- 
	-- Low priorities
	-- 
	
	local leaderInfo	= GameInfo.Leaders[player:GetLeaderType()]
	local unitMod		= 0
	local doUnits		= (GetCurrentUnitSupply(player) < GetMaxUnitSupply(player))
	local attempt		= 1
	local flavorWeights	= {}
	local flavorMod		= {
		FLAVOR_DIPLOMACY			= GetCitystateMod(player),
		FLAVOR_NAVAL				= player:HasTech("TECH_SAILING") and 1 or 0,
		FLAVOR_AIR					= player:HasTech("TECH_FLIGHT") and 1 or 0,
		FLAVOR_EXPANSION			= isWarAny and 0 or 5 / #cities,
		FLAVOR_TILE_IMPROVEMENT		= 0, --numWorkers - #cities and 1 or 0,
		FLAVOR_GROWTH				= 1.1 ^ (10 - citiesReverse[1].pop),
		FLAVOR_HAPPINESS			= 1.1 ^ (10 - player:GetYieldRate(YieldTypes.YIELD_HAPPINESS_CITY)),
		FLAVOR_RELIGION				= player:CanFoundFaith() and 2 or 0.5
	}

	if isWarHuman then
		unitMod = 2
	elseif Game.GetAdjustedTurn() > 25 then
		unitMod = Game.GetValue("Flavor", {LeaderType=leaderInfo.Type, FlavorType="FLAVOR_MILITARY_TRAINING"}, GameInfo.Leader_Flavors) / 4
	end
	
	for row in GameInfo.Leader_Flavors{LeaderType = leaderInfo.Type} do
		local flavorType = row.FlavorType
		local flavorValue = row.Flavor
		local priority = GameInfo.Flavors[flavorType].PurchasePriority * (flavorMod[flavorType] or 1)
		if DoFlavorFunction[flavorType] then
			if DoFlavorFunction[flavorType] == PurchaseOneUnitOfFlavor then
				priority = priority * unitMod
			end
			if flavorValue > 0 and priority > 0 then
				if doUnits or DoFlavorFunction[flavorType] ~= PurchaseOneUnitOfFlavor then
					--log:Info("%-15s %20s %3s/%-4s %-20s priority=%-3s", "AIPurchase", player:GetName(), " ", string.gsub(flavorType, "FLAVOR_", ""), flavorValue)
					flavorWeights[flavorType] = flavorValue * priority
				end
			end
		end
	end
	
	local attempt = 0
	while attempt <= Cep.AI_PURCHASE_FLAVOR_MAX_ATTEMPTS do		
		attempt = attempt + 1

		local flavorType = Game.GetRandomWeighted(flavorWeights)
		if flavorType == -1 then
			log:Warn("%15s %20s %3s %-4s no valid flavors for purchase", "AIPurchase", player:GetName(), " ", " ")
			break
		end
		
		local success = false
		if flavorType == "FLAVOR_EXPANSION" then
			success = DoFlavorFunction[flavorType](player, cities, goldMin, flavorType)
		elseif flavorType == "FLAVOR_GROWTH" or flavorType == "FLAVOR_PRODUCTION" then
			success = DoFlavorFunction[flavorType](player, citiesReverse, goldMin, flavorType)
		else
			if not flavorType or not DoFlavorFunction[flavorType] then
				log:Error("DoFlavorFunction[%s] == nil", flavorType)
			else
				success = DoFlavorFunction[flavorType](player, cities, goldMin, flavorType)
			end
		end
		
		if flavorType == "FLAVOR_DIPLOMACY" or not success then
			flavorWeights[flavorType] = 0
		else
			flavorWeights[flavorType] = 0.5 * flavorWeights[flavorType]
		end
		
		if player:IsBudgetGone(goldLow) then return end
	end

	-- No affordable purchase
	log:Info("%-15s %20s %3s of %-4s (+%s/turn) saved", "", player:GetName(), player:GetYieldStored(YieldTypes.YIELD_GOLD) - goldMin, player:GetYieldStored(YieldTypes.YIELD_GOLD), player:GetYieldRate(YieldTypes.YIELD_GOLD))
end
LuaEvents.ActivePlayerTurnEnd_Player.Add(SpendAIGold)

function UpgradeSomeUnit(player, goldMin)
	local playerID = player:GetID()
	for unit in player:Units() do
		local newID = unit:GetUpgradeUnitType()
		if Unit_CanUpgrade(unit, newID, goldMin) then
			log:Info("%-15s %20s %3s/%-4s PAID for upgrading            %s (#%s)", "AIPurchase", player:GetName(), unit:UpgradePrice(newID), player:GetYieldStored(YieldTypes.YIELD_GOLD), unit:GetName(), unit:GetID())
			Unit_Replace(unit, GameInfo.Units[newID].Class)
			return true
		end
	end
	return false
end

function GetCitystateMod(player)
	local playerID		= player:GetID()
	local csWeight		= 0
	local csTotal		= 0
	local breakpoint	= 15 --GameDefines.FRIENDSHIP_THRESHOLD_FRIENDS
	for minorCivID, minorCiv in pairs(Players) do
		if minorCiv:IsAliveCiv() and minorCiv:IsMinorCiv() and player:IsAtPeace(minorCiv) then
			if not minorCiv:IsAllies(playerID) then
				local influence = minorCiv:GetMinorCivFriendshipWithMajor(playerID)
				if influence < breakpoint then
					csWeight = csWeight + 1
				else
					csWeight = csWeight + breakpoint / influence
				end
			end
			csTotal = csTotal + 1
		end
	end
	if csTotal == 0 then
		-- no known citystates
		return 0
	end
	return (csWeight / csTotal)
end


function PurchaseUnitsOfFlavor(player, cities, goldMin, flavorType, quantity, promotions)
	local unitsBought = 0
	while quantity > 0 do
		quantity = quantity - 1
		local unit = PurchaseOneUnitOfFlavor(player, cities, goldMin, flavorType)
		if unit then
			unitsBought = unitsBought + 1
			for _, promoID in ipairs(promotions or {}) do
				unit:SetHasPromotion(promoID, true)
				unit:ChangeLevel(1)
			end
			if player:IsBudgetGone(goldMin) then break end
		else
			break
		end
	end
	return unitsBought
end

function PurchaseOneUnitOfFlavor(player, cities, goldMin, flavorType)
	for _,cityInfo in ipairs(cities) do
		local city = Map_GetCity(cityInfo.id)
		local units = City_GetUnitsOfFlavor(city, flavorType, goldMin)
		if #units > 0 then
			local itemID = Game.GetRandomWeighted(units)
			if itemID ~= -1 then
				local cost = City_GetPurchaseCost(city, YieldTypes.YIELD_GOLD, GameInfo.Units, itemID)
				local unit = player:InitUnitType(itemID, city:Plot(), City_GetUnitExperience(city, itemID))				
				log:Info("%-15s %20s %3s/%-4s PAID for                      %-25s %s", "AIPurchase", player:GetName(), cost, player:GetYieldStored(YieldTypes.YIELD_GOLD), flavorType, GameInfo.Units[itemID].Type)
				player:ChangeYieldStored(YieldTypes.YIELD_GOLD, -1 * cost)
				return unit
			end
		end
	end
	log:Info("%-15s %20s %3s %-4s no affordable unit of         %s", "", player:GetName(), " ", " ", flavorType)
	return false
end

function PurchaseBuildingOfFlavor(player, cities, goldMin, flavorType)
	if not flavorType then
		log:Error("PurchaseBuildingOfFlavor: flavorType=nil!")
		return
	end
	for _,cityInfo in ipairs(cities) do
		local city = Map_GetCity(cityInfo.id)
		local buildings = City_GetBuildingsOfFlavor(city, flavorType, goldMin)
		if #buildings > 0 then
			local itemID = Game.GetRandomWeighted(buildings)
			if itemID ~= -1 then
				local cost = City_GetPurchaseCost(city, YieldTypes.YIELD_GOLD, GameInfo.Buildings, itemID)
				city:SetNumRealBuilding(itemID, 1)	
				log:Info("%-15s %20s %3s/%-4s PAID for                      %-25s %s", "AIPurchase", player:GetName(), cost, player:GetYieldStored(YieldTypes.YIELD_GOLD), flavorType, GameInfo.Buildings[itemID].Type)
				player:ChangeYieldStored(YieldTypes.YIELD_GOLD, -1 * cost)
				return true
			end
		end
	end
	log:Info("%-15s %20s %3s %-4s no affordable building of     %s", "", player:GetName(), " ", " ", flavorType)
	return false
end

function PurchaseInfluence(player, cities, goldMin, flavorType)
	local playerID		= player:GetID()
	local playerTeam	= Teams[player:GetTeam()]
	local leaderInfo	= GameInfo.Leaders[player:GetLeaderType()]
	local capitalPlot	= player:GetCapitalCity():Plot()
	local chosenMinor	= nil
	local chosenWeight	= -1
	local cost			= math.min(Game.Round(player:GetYieldStored(YieldTypes.YIELD_GOLD) - goldMin, -1), 500)

	for minorCivID, minorCiv in pairs(Players) do
		if minorCiv:IsAliveCiv() and minorCiv:IsMinorCiv() and player:IsAtPeace(minorCiv) then

			local minorTeamID		= minorCiv:GetTeam()
			local minorCapitalPlot	= minorCiv:GetCapitalCity():Plot()			
			local influence			= minorCiv:GetMinorCivFriendshipWithMajor(playerID)
			local influenceDiff		= influence - player:GetRivalInfluence(minorCiv)
			local distance			= Map.PlotDistance(capitalPlot:GetX(), capitalPlot:GetY(), minorCapitalPlot:GetX(), minorCapitalPlot:GetY())
			local military			= Game.GetValue("Flavor", {LeaderType=leaderInfo.Type, FlavorType="FLAVOR_MILITARY_TRAINING"}, GameInfo.Leader_Flavors) - 4
			local weight			= 1
			
			-- influence
			if influence < 50 then
				weight = 10 - 0.002 * influence ^ 2
			else
				weight = 280 / influence
			end
			
			-- rival influence difference
			if influenceDiff <= -10 then
				weight = weight * 10
			else
				weight = weight * 100 / (influenceDiff + 20)
			end
			
			-- distance
			weight = weight / math.max(0.01, distance)
			
			-- trait
			if minorCiv:GetMinorCivTrait() == MinorCivTraitTypes.MINOR_CIV_TRAIT_MILITARISTIC then
				weight = weight * math.max(0.01, 1.1 ^ military)
			else
				weight = weight / math.max(0.01, 1.1 ^ military)
			end
			
			-- personality
			if minorCiv:GetPersonality() == MinorCivPersonalityTypes.MINOR_CIV_PERSONALITY_HOSTILE then
				weight = weight * 0.66
			elseif minorCiv:GetPersonality() == MinorCivPersonalityTypes.MINOR_CIV_PERSONALITY_NEUTRAL then
				weight = weight * 1.5
			end
			
			if weight > chosenWeight then
				chosenMinor = minorCiv
				chosenWeight = weight
			elseif weight == chosenWeight and 1 == Map.Rand(2, "InitUnitFromList") then
				chosenMinor = minorCiv
				chosenWeight = weight
			end
		end
	end
	
	if chosenMinor then
		local influence = chosenMinor:GetFriendshipFromGoldGift(playerID, cost)
		chosenMinor:ChangeMinorCivFriendshipWithMajor(playerID, influence)
		log:Info("%-15s %20s %3s/%-4s PAID for %2s influence with   %-25s", "AIPurchase", player:GetName(), cost, player:GetYieldStored(YieldTypes.YIELD_GOLD), influence, chosenMinor:GetName())
		player:ChangeYieldStored(YieldTypes.YIELD_GOLD, -1 * cost)
		return true
	end
	
	return false
end

function PurchaseAllInfluence(player, goldMin)
	goldMin = goldMin or 100
	local attempts = 0
	local playerID = player:GetID()
	while player:GetYieldStored(YieldTypes.YIELD_GOLD) > goldMin and attempts < 10 do
		local chosenMinor	= nil
		local chosenWeight	= -1
		local cost			= math.min(500, player:GetYieldStored(YieldTypes.YIELD_GOLD))
		for minorCivID, minorCiv in pairs(Players) do
			if minorCiv:IsAliveCiv() and minorCiv:IsMinorCiv() and player:IsAtPeace(minorCiv) then
				local influence		= minorCiv:GetMinorCivFriendshipWithMajor(playerID)
				local influenceDiff	= influence - player:GetRivalInfluence(minorCiv)
				local weight		= 1

				weight = weight * 10 / (influence + 200)
				weight = weight * math.max(50, 100 - math.abs(influenceDiff + 20))
				
				if weight > chosenWeight then
					chosenMinor = minorCiv
					chosenWeight = weight
				elseif weight == chosenWeight and 1 == Map.Rand(2, "InitUnitFromList") then

					chosenMinor = minorCiv
					chosenWeight = weight
				end
			end
		end
		if chosenMinor then
			local influence = chosenMinor:GetFriendshipFromGoldGift(playerID, cost)
			chosenMinor:ChangeMinorCivFriendshipWithMajor(playerID, influence)
			log:Info("%-15s %20s %3s/%-4s PAID for %2s influence with   %-25s(Diplo victory unlocked!)", "AIPurchase", player:GetName(), cost, player:GetYieldStored(YieldTypes.YIELD_GOLD), influence, chosenMinor:GetName())
			player:ChangeYieldStored(YieldTypes.YIELD_GOLD, -1 * cost)
		else
			return
		end
		attempts = attempts + 1
	end
end

function CheckDiploVictoryUnlocked()	
	if MapModData.Cep_DiploVictoryUnlocked or not PreGame.IsVictory(GameInfo.Victories.VICTORY_DIPLOMATIC.ID) then
		return
	end
	
	for playerID, player in pairs(Players) do
		if player:IsAliveCiv() and not player:IsMinorCiv() and player:GetCurrentEra() >= GameInfo.Eras.ERA_POSTMODERN.ID then
			log:Info("DiploVictoryUnlocked")
			MapModData.Cep_DiploVictoryUnlocked = true
			return
		end
	end
	
	--[[
	for buildingInfo in GameInfo.Buildings("VictoryPrereq = 'VICTORY_DIPLOMATIC'") do
		local tech = buildingInfo.PrereqTech
		for playerID, player in pairs(Players) do
			if player:IsAliveCiv() and not player:IsMinorCiv() and player:HasTech(tech) then
				log:Info("DiploVictoryUnlocked")
				MapModData.Cep_DiploVictoryUnlocked = true
				return
			end
		end
	end
	--]]
end
LuaEvents.ActivePlayerTurnStart_Turn.Add(CheckDiploVictoryUnlocked)

DoFlavorFunction = {
	FLAVOR_DIPLOMACY			= PurchaseInfluence,
	FLAVOR_OFFENSE				= PurchaseOneUnitOfFlavor,
	FLAVOR_DEFENSE				= PurchaseOneUnitOfFlavor,
	FLAVOR_SOLDIER				= PurchaseOneUnitOfFlavor,
	FLAVOR_MOBILE				= PurchaseOneUnitOfFlavor,
	FLAVOR_ANTI_MOBILE			= PurchaseOneUnitOfFlavor,
	FLAVOR_RECON				= PurchaseOneUnitOfFlavor,
	FLAVOR_HEALING				= PurchaseOneUnitOfFlavor,
	FLAVOR_PILLAGE				= PurchaseOneUnitOfFlavor,
	FLAVOR_MELEE				= PurchaseOneUnitOfFlavor,
	FLAVOR_RANGED				= PurchaseOneUnitOfFlavor,
	FLAVOR_SIEGE				= PurchaseOneUnitOfFlavor,
	FLAVOR_NAVAL				= PurchaseOneUnitOfFlavor,
	FLAVOR_NAVAL_BOMBARDMENT	= PurchaseOneUnitOfFlavor,
	FLAVOR_NAVAL_RECON			= PurchaseOneUnitOfFlavor,
	FLAVOR_NAVAL_TILE_IMPROVEMENT	= PurchaseOneUnitOfFlavor,
	FLAVOR_AIR					= PurchaseOneUnitOfFlavor,
	FLAVOR_ANTIAIR				= PurchaseOneUnitOfFlavor,
	FLAVOR_NUKE					= PurchaseOneUnitOfFlavor,
	FLAVOR_TILE_IMPROVEMENT		= PurchaseOneUnitOfFlavor,
	FLAVOR_EXPANSION			= PurchaseBuildingOfFlavor,
	FLAVOR_NAVAL_GROWTH			= PurchaseBuildingOfFlavor,
	FLAVOR_WATER_CONNECTION		= PurchaseBuildingOfFlavor,
	FLAVOR_GREAT_PEOPLE			= PurchaseBuildingOfFlavor,
	FLAVOR_CITY_DEFENSE			= PurchaseBuildingOfFlavor,
	FLAVOR_MILITARY_TRAINING	= PurchaseBuildingOfFlavor,
	FLAVOR_GROWTH				= PurchaseBuildingOfFlavor,
	FLAVOR_PRODUCTION			= PurchaseBuildingOfFlavor,
	FLAVOR_GOLD					= PurchaseBuildingOfFlavor,
	FLAVOR_SCIENCE				= PurchaseBuildingOfFlavor,
	FLAVOR_CULTURE				= PurchaseBuildingOfFlavor,
	FLAVOR_HAPPINESS			= PurchaseBuildingOfFlavor,
	FLAVOR_GREAT_PEOPLE			= PurchaseBuildingOfFlavor,
	FLAVOR_INFRASTRUCTURE		= PurchaseBuildingOfFlavor,
	FLAVOR_WONDER				= PurchaseBuildingOfFlavor,
	FLAVOR_SPACESHIP			= PurchaseBuildingOfFlavor,
	FLAVOR_ESPIONAGE			= PurchaseBuildingOfFlavor,
	FLAVOR_RELIGION				= PurchaseBuildingOfFlavor
}

if Cep.USING_CSD > 0 then
	DoFlavorFunction.FLAVOR_DIPLOMACY = PurchaseOneUnitOfFlavor
end

--]=]


















--
-- Start Bonuses
--
--[==
function PlayerStartBonuses(player)
	--print("PlayerStartBonuses "..player:GetName())
	local activePlayer	= Players[Game.GetActivePlayer()]
	local worldInfo		= Game.GetWorldInfo()
	local speedInfo		= Game.GetSpeedInfo()
	local handicapInfo	= Game.GetHandicapInfo()
	local leaderInfo	= GameInfo.Leaders[player:GetLeaderType()]
	local handicapID	= 1 + handicapInfo.ID
	local trait			= player:GetTraitInfo()
	local teamID		= player:GetTeam()
	local capitalCity	= player:GetCapitalCity()
	local startPlot		= capitalCity and capitalCity:Plot()
	local isCoastal		= false	
	local settlerID		= player:GetUniqueUnitID("UNITCLASS_SETTLER")
	local warriorID		= player:GetUniqueUnitID("UNITCLASS_WARRIOR")
	local searchRange	= worldInfo.AISearchRange
	
	if trait.NoWarrior then
		for unit in player:Units() do
			if unit:GetUnitType() == warriorID then
				unit:Kill()
				break
			end
		end
	end
	if not startPlot then
		for unit in player:Units() do
			if unit:GetUnitType() == settlerID then
				startPlot = unit:GetPlot()
				if player:IsHuman() then-- and trait.NoWarrior and trait.FreeUnit == "UNITCLASS_WORKER" then
					for nearPlot in Plot_GetPlotsInCircle(startPlot, 2, 3) do
						nearPlot:SetRevealed(teamID, true)
					end
					UI.SelectUnit(unit)
				end
				break
			end
		end
	end	
	if not startPlot then
		log:Error("PlayerStartBonuses: %s has no capital or settler!", player:GetName())
		return
	end
	
	--log:Info("PlayerStartBonuses %s", player:GetName())

	local oceanPlot	= Plot_GetNearestOceanPlot(startPlot, 1, searchRange)
	if not oceanPlot then
		oceanPlot	= Plot_GetNearestOceanPlot(startPlot, searchRange + 1, searchRange * 2)
	end
	if oceanPlot then
		isCoastal	= (Plot_GetAreaWeights(startPlot, 1, 8).SEA >= 0.5)
		for unit in player:Units() do
			local unitInfo = GameInfo.Units[unit:GetUnitType()]
			if unitInfo.Domain == "DOMAIN_SEA" then
				player:InitUnitClass(unitInfo.Class, oceanPlot)
				unit:Kill()
			end
		end
	end
	
	if trait.FreeShip and oceanPlot then
		player:InitUnitClass(trait.FreeShip, oceanPlot)
	end

	-- FreeUnit does not work for Mayan Atlatlist?
	if trait.Type == "TRAIT_LONG_COUNT" and trait.FreeUnit == "UNITCLASS_ARCHER" and not trait.FreeUnitPrereqTech then
		player:InitUnitClass(trait.FreeUnit, startPlot)
	end

	
	--
	-- AI Bonuses
	--
	
	if player:IsMinorCiv() or player:IsHuman() then
		return
	end
	
	local modMilitaristic	= player:IsMilitaristicLeader() and 1 or 0.5
	local numUnits			= 0.25 * handicapID * modMilitaristic * speedInfo.TrainPercent/100
	local handicapYields	= {	YieldTypes.YIELD_GOLD,
								YieldTypes.YIELD_SCIENCE,
								YieldTypes.YIELD_CULTURE }
	
	--Plot_ChangeYield(startPlot, YieldTypes.YIELD_GOLD, modMilitaristic * handicapID)
	
	if isCoastal then
		for i=1, Game.Round(numUnits/2) do
			player:InitUnitClass("UNITCLASS_TRIREME", oceanPlot)
			player:InitUnitClass("UNITCLASS_ARCHER", startPlot)
			--player:InitUnitClass("UNITCLASS_WORKER", startPlot)
		end
	else
		for i=1, Game.Round(numUnits) do
			player:InitUnitClass("UNITCLASS_ARCHER", startPlot)
			--player:InitUnitClass("UNITCLASS_WORKER", startPlot)
		end
	end

	if leaderInfo.AIBonus then
		player:InitUnitClass("UNITCLASS_WARRIOR", startPlot)
	end

	--print("PlayerStartBonuses "..player:GetName().." Done")
end

function CheckPlayerStartBonuses()
	if UI:IsLoadedGame() then
		return
	end
	print("CheckPlayerStartBonuses")
	for playerID,player in pairs(Players) do
		if player:IsAliveCiv() then
			--PlayerStartBonuses(player)
			SafeCall(PlayerStartBonuses, player)
		end
	end
	print("CheckPlayerStartBonuses Done")
end
Events.SequenceGameInitComplete.Add(CheckPlayerStartBonuses)

function AIEarlyBonuses(player)
	--print("AIEarlyBonuses "..player:GetName())
	local playerID		= player:GetID()
	local activePlayer	= Players[Game.GetActivePlayer()]
	local worldInfo		= Game.GetWorldInfo()
	local speedInfo		= Game.GetSpeedInfo()
	local handicapInfo	= Game.GetHandicapInfo()
	local leaderInfo	= GameInfo.Leaders[player:GetLeaderType()]
	local handicapID	= 1 + handicapInfo.ID
	local capitalCity	= player:GetCapitalCity()
	local startPlot		= capitalCity and capitalCity:Plot()
	local isCoastal		= false	
	local settlerID		= player:GetUniqueUnitID("UNITCLASS_SETTLER")
	local searchRange	= worldInfo.AISearchRange
	local relFlavor		= Game.GetValue("Flavor", {LeaderType=leaderInfo.Type, FlavorType="FLAVOR_RELIGION"}, GameInfo.Leader_Flavors)
	
	if not startPlot then
		for unit in player:Units() do
			if unit:GetUnitType() == settlerID then
				startPlot = unit:GetPlot()
				break
			end
		end
	end	
	if not startPlot then
		log:Error("AIEarlyBonuses: %s has no capital or settler!", player:GetName())
		return
	end

	local oceanPlot	= Plot_GetNearestOceanPlot(startPlot, 1, searchRange)
	if not oceanPlot then
		oceanPlot	= Plot_GetNearestOceanPlot(startPlot, searchRange + 1, searchRange * 2)
	end
	if oceanPlot then
		isCoastal	= (Plot_GetAreaWeights(startPlot, 1, 8).SEA >= 0.5)
	end
	
	log:Debug("AIEarlyBonuses %s", player:GetName())
	
	for nearPlot, distance in Plot_GetPlotsInCircle(startPlot, 2, searchRange) do
		nearPlot:SetRevealed(player:GetTeam(), true)
		--[[
		local improvement = GameInfo.Improvements[nearPlot:GetImprovementType()]
		if improvement and improvement.Goody and not Plot_IsNearHuman(nearPlot, searchRange) then
			nearPlot:SetImprovementType(-1)
		end
		--]]
	end
	
	if player:IsMinorCiv() then
		if handicapInfo.Type == "HANDICAP_CHIEFTAIN" then
			City_SetNumBuildingClass(capitalCity, "BUILDINGCLASS_CARAVANSARY", 1)
			player:InitUnitClass("UNITCLASS_SPEARMAN", startPlot)
		end
		if handicapInfo.Type == "HANDICAP_PRINCE" then
			if isCoastal then
				player:InitUnitClass("UNITCLASS_TRIREME", oceanPlot)
			else
				player:InitUnitClass("UNITCLASS_ARCHER", startPlot)
			end
		end		
		if handicapInfo.Type == "HANDICAP_IMMORTAL" then
			player:InitUnitClass("UNITCLASS_SPEARMAN", startPlot)
		end		
		if handicapInfo.Type == "HANDICAP_DEITY" then
			if isCoastal then
				player:InitUnitClass("UNITCLASS_ARCHER", startPlot)
			else
				player:InitUnitClass("UNITCLASS_SPEARMAN", startPlot)
			end
		end
	else
		if handicapInfo.Type == "HANDICAP_CHIEFTAIN" then
			City_SetNumBuildingClass(capitalCity, "BUILDINGCLASS_CARAVANSARY", 1)
		end
		if handicapInfo.Type == "HANDICAP_WARLORD" then
			City_SetNumBuildingClass(capitalCity, "BUILDINGCLASS_GRANARY", 1)	
		end
		if handicapInfo.Type == "HANDICAP_PRINCE" then
			City_SetNumBuildingClass(capitalCity, "BUILDINGCLASS_MONUMENT", 1)
		end
		if handicapInfo.Type == "HANDICAP_KING" then
			City_SetNumBuildingClass(capitalCity, "BUILDINGCLASS_LIBRARY", 1)
		end
		if handicapInfo.Type == "HANDICAP_EMPEROR" then
			if relFlavor >= 7 then
				City_SetNumBuildingClass(capitalCity, "BUILDINGCLASS_SHRINE", 1)
				log:Info("Gave %20s a Shrine", player:GetName())
			elseif leaderInfo.Personality == "PERSONALITY_EXPANSIONIST" then
				City_SetNumBuildingClass(capitalCity, "BUILDINGCLASS_COLOSSEUM", 1)
				log:Info("Gave %20s a Colosseum", player:GetName())
			elseif leaderInfo.Personality == "PERSONALITY_COALITION" or leaderInfo.Personality == "PERSONALITY_DIPLOMAT" then
				local bestCS = nil
				local bestCSDistance = searchRange * 2
				for csID, cs in pairs(Players) do
					if cs:IsMinorCiv() and cs:GetAlly() == -1 then
						local minorPlot = cs:GetCapitalCity():Plot()
						local distance = Map.PlotDistance(startPlot:GetX(), startPlot:GetY(), minorPlot:GetX(), minorPlot:GetY())
						if distance < bestCSDistance then
							bestCS = cs
							bestCSDistance = distance
						end
					end
				end
				if bestCS then
					local influence = 80 --bestCS:GetFriendshipFromGoldGift(playerID, 500)
					bestCS:ChangeMinorCivFriendshipWithMajor(playerID, influence)
					log:Info("Gave %20s %s influence with %s", player:GetName(), influence, bestCS:GetName())
				end
			else
				log:Info("Gave %20s a Barracks", player:GetName())
				City_SetNumBuildingClass(capitalCity, "BUILDINGCLASS_BARRACKS", 1)
			end
		end		
		if handicapInfo.Type == "HANDICAP_IMMORTAL" then
			City_SetNumBuildingClass(capitalCity, "BUILDINGCLASS_WALLS", 1)
		end		
		if handicapInfo.Type == "HANDICAP_DEITY" then
			City_SetNumBuildingClass(capitalCity, "BUILDINGCLASS_CASTLE", 1)
		end
	end
end

function CheckAIEarlyBonuses(player)
	if Game.GetAdjustedTurn() ~= 10 or player:IsHuman() then
		return
	end

	SafeCall(AIEarlyBonuses, player)
end
LuaEvents.ActivePlayerTurnEnd_Player.Add(CheckAIEarlyBonuses)

--
function AIPerTurnBonuses(player)
	local capitalCity = player:GetCapitalCity()
	if capitalCity == nil or player:IsMinorCiv() or player:IsHuman() then
		return
	end
	log:Debug("%-25s %15s", "AIPerTurnBonuses", player:GetName())
	local activePlayer		= Players[Game.GetActivePlayer()]
	local handicapInfo		= Game.GetHandicapInfo()
	local yieldStored		= player:GetYieldStored(YieldTypes.YIELD_SCIENCE)
	local yieldRate			= player:GetYieldRate(YieldTypes.YIELD_SCIENCE)
	local yieldMod			= handicapInfo.AIResearchPercent/100
	local yieldModPerEra	= handicapInfo.AIResearchPercentPerEra/100 * Game.GetAverageHumanEra()
	player:ChangeYieldStored(YieldTypes.YIELD_SCIENCE, Game.Round(yieldRate * (yieldMod + yieldModPerEra)))
	--
	log:Debug("Sci bonus for %-25s: %5s + %4s * (%4s + %-4s) = %5s (+%s)",
		player:GetName(),
		yieldStored,
		yieldRate,
		Game.Round(yieldMod, 2),
		Game.Round(yieldModPerEra, 2),
		player:GetYieldStored(YieldTypes.YIELD_SCIENCE),
		Game.Round(yieldRate * (yieldMod + yieldModPerEra))
	)
	--]]
end

LuaEvents.ActivePlayerTurnEnd_Player.Add(AIPerTurnBonuses)
--]=]

--]==]

--
-- AI military bonuses
--

function AIMilitaryHandicap(  playerID,
								unitID,
								hexVec,
								unitType,
								cultureType,
								civID,
								primaryColor,
								secondaryColor,
								unitFlagIndex,
								fogState,
								selected,
								military,
								notInvisible )
	local player = Players[playerID]
	local activePlayer = Players[Game.GetActivePlayer()]
    if not player:IsAliveCiv() or player:IsHuman() then
		return
	end

	local unit = player:GetUnitByID( unitID )
	if unit == nil or unit:IsDead() then
        return
    end

	--[[
	if military then
		local hostileMultiplier = 1
		if player:IsMinorCiv() then
			hostileMultiplier = 0.5
		elseif not player:IsMilitaristicLeader() then
			if player:IsAtWarWithHuman() then
				hostileMultiplier = 1
			elseif player:EverAtWarWithHuman() then
				hostileMultiplier = 0.5
			else
				hostileMultiplier = 0
			end
		end
		local freeXP = hostileMultiplier * Game.GetHandicapInfo().AIFreeXP
		local freeXPPerEra = hostileMultiplier * 4 * (Game.GetAverageHumanHandicap() - 1)
		--local freeXPPerEra = hostileMultiplier * Game.GetHandicapInfo().AIFreeXPPerEra
		if freeXP > 0 or freeXPPerEra > 0 then
			local era = 1 + Game.GetAverageHumanEra()
			--log:Warn(player:GetName().. " " ..unit:GetName().. " " ..freeXP.. " + " ..freeXPPerEra.. "*" ..Game.GetAverageHumanHandicap().. " xp")
			unit:ChangeExperience(freeXP + freeXPPerEra * era)
		end
	end
	--]]

	local handicapInfo = GameInfo.HandicapInfos[Players[Game.GetActivePlayer()]:GetHandicapType()]
	local freePromotion = "PROMOTION_HANDICAP"--handicapInfo.AIFreePromotion
	local unitInfo = GameInfo.Units[unit:GetUnitType()]

	if freePromotion then
		unit:SetHasPromotion(GameInfo.UnitPromotions[freePromotion].ID, true)
	end
	
	--[[
	if unitInfo.CombatClass == "COMBATCLASS_RECON" then
		unit:SetHasPromotion(GameInfo.UnitPromotions.PROMOTION_ATTACK_BONUS_NOUPGRADE_I.ID, true)
	end
	--]]
	
	if (1 + handicapInfo.ID) >= 5 then -- king
		-- The AI is not good at using siege units
		unit:SetHasPromotion(GameInfo.UnitPromotions.PROMOTION_CITY_PENALTY.ID, false)
		unit:SetHasPromotion(GameInfo.UnitPromotions.PROMOTION_SMALL_CITY_PENALTY.ID, false)
		--]]
	end

	if player:IsMinorCiv() then
		unit:SetHasPromotion(GameInfo.UnitPromotions.PROMOTION_FREE_UPGRADES.ID, true)
	end
	
	local capital = player:GetCapitalCity()
	if capital and Game.GetAdjustedTurn() < 50 then
		local plot = capital:Plot()
		if plot:IsCoastalLand() and Plot_GetAreaWeights(plot, 1, 8).SEA >= 0.5 then
			unit:SetHasPromotion(GameInfo.UnitPromotions.PROMOTION_EMBARKATION.ID, true)
		end
	end
end
LuaEvents.NewUnit.Add(function(playerID, unitID, hexVec, unitType, cultureType, civID, primaryColor, secondaryColor, unitFlagIndex, fogState, selected, military, notInvisible) 
		return SafeCall(AIMilitaryHandicap, playerID, unitID, hexVec, unitType, cultureType, civID, primaryColor, secondaryColor, unitFlagIndex, fogState, selected, military, notInvisible)
	end
)

function AIMilitaryHandicapPerTurn(unit)
	local player = Players[unit:GetOwner()]
	if player:IsHuman() or player:IsBarbarian() or not unit:IsCombatUnit() then
		return
	end
	
	local handicap = Game.GetHandicapInfo()
	
	if handicap.AIFreeXPPerTurn == 0 then
		return
	end
	
	local hostileMultiplier = 1
	if player:IsMinorCiv() then
		hostileMultiplier = 0.5
	elseif not player:IsMilitaristicLeader() then
		if player:IsAtWarWithHuman() then
			hostileMultiplier = 1
		elseif player:EverAtWarWithHuman() then
			hostileMultiplier = 0.5
		else
			hostileMultiplier = 0
		end
	end
	
	if unit:GetExperience() > handicap.AIFreeXPMax * hostileMultiplier then
		return
	end
	
	local odds = hostileMultiplier * handicap.AIFreeXPPerTurn
	
	if odds > Map.Rand(100, "AI bonus experience") then
		unit:ChangeExperience(1)
	end
end
LuaEvents.ActivePlayerTurnEnd_Unit.Add(function(unit) return SafeCall(AIMilitaryHandicapPerTurn, unit) end)

function WarHandicap(humanPlayerID, aiPlayerID, isAtWar)
	local humanPlayer = Players[humanPlayerID]
	local aiPlayer = Players[aiPlayerID]
	if (not humanPlayer:IsHuman() 
		or aiPlayer:IsHuman()
		or (MapModData.Cep_EverAtWarWithHuman[aiPlayerID] ~= 1)
		or aiPlayer:IsMilitaristicLeader()
		) then
		return
	end
	log:Warn("War State %s %s %s", humanPlayer:GetName(), aiPlayer:GetName(), isAtWar and "War" or "Peace")
	MapModData.Cep_EverAtWarWithHuman[aiPlayerID] = 1
	SaveValue(1, "MapModData.Cep_EverAtWarWithHuman[%s]", aiPlayerID)
	
	local freeXP = Game.GetHandicapInfo().AIFreeXP
	local freeXPPerEra = 4 * (Game.GetAverageHumanHandicap() - 1) --Game.GetHandicapInfo().AIFreeXPPerEra
	local era = 1 + Game.GetAverageHumanEra()
	if freeXP > 0 or freeXPPerEra > 0 then
		for unit in aiPlayer:Units() do
			unit:ChangeExperience(freeXP + freeXPPerEra * era)
			log:Info("%-15s %s %20s warXP = %s + %s * %s", aiPlayer:GetName(), unit:GetName(), freeXP, freeXPPerEra, era)
		end
	end
end
Events.WarStateChanged.Add(WarHandicap)



function DeclareWarNearestCitystate(player)
	-- Conquerors vs citystates
	local turn = Game.GetGameTurn()
	if (Game.GetAdjustedTurn() <= 50
		or turn % 7 ~= 0
		or player:IsHuman()
		or player:IsMinorCiv()
		or player:GetPersonalityInfo().Type ~= "PERSONALITY_CONQUEROR"
		--or player:IsAtWarWithAny()
		) then
		return
	end
	local capital = player:GetCapitalCity()
	if not capital then
		log:Warn("DeclareWarNearestCitystate: %s has no capital", player:GetName())
		return
	end
	log:Info("DeclareWarNearestCitystate %-20s %s", player:GetName(), player:GetPersonalityInfo().Type)
	local teamID			= player:GetTeam()
	local team				= Teams[teamID]
	local closestMinorID	= nil
	local closestMinor		= nil
	local closestDistance	= math.huge
	local usPlot			= capital:Plot()
	local startX			= capital:Plot():GetX()
	local startY			= capital:Plot():GetY()
	local iW, iH			= Map.GetGridSize()

	for minorCivID, minorCiv in pairs(Players) do
		if minorCiv and minorCiv:IsMinorCiv() and minorCiv:IsAlive() and (minorCiv:GetAlly() == -1 or player:IsAtWar(minorCiv)) then
			local minorCapital = minorCiv:GetCapitalCity()
			if minorCapital then
				if team:IsPermanentWarPeace(minorCiv:GetTeam()) then 
					return
				end
				local themPlot = minorCapital:Plot()
				local distance = Map.PlotDistance(startX, startY, themPlot:GetX(), themPlot:GetY())
				if (distance < closestDistance) and (distance < 0.25 * iW) and (usPlot:Area() == themPlot:Area()) then
					closestMinor = minorCiv
					closestDistance = distance
					log:Info("  %-15s distance = %s", closestMinor:GetName(), distance)
				end
			end
		end
	end
	if not closestMinor then
		for minorCivID, minorCiv in pairs(Players) do
			if minorCiv and minorCiv:IsMinorCiv() and minorCiv:IsAlive() and (minorCiv:GetAlly() == -1 or player:IsAtWar(minorCiv)) then
				local minorCapital = minorCiv:GetCapitalCity()
				if minorCapital then
					if team:IsPermanentWarPeace(minorCiv:GetTeam()) then 
						return
					end
					local themPlot = minorCapital:Plot()
					local distance = Map.PlotDistance(startX, startY, themPlot:GetX(), themPlot:GetY())
					if distance < closestDistance then
						closestMinor = minorCiv
						closestDistance = distance
						log:Info("  %-15s distance = %s", closestMinor:GetName(), distance)
					end
				end
			end
		end
	end
	if not closestMinor then
		return
	end
	
	local minorTeamID = closestMinor:GetTeam()

	team:SetPermanentWarPeace(minorTeamID, true)
	if not team:IsAtWar(minorTeamID) then
		team:DeclareWar(minorTeamID)
	end
	log:Info("%s declared permanent war on %s", player:GetName(), closestMinor:GetName())

	for nearPlot in Plot_GetPlotsInCircle(closestMinor:GetCapitalCity():Plot(), 0, 3) do
		nearPlot:SetRevealed(teamID, true)
	end
	if Game.GetAdjustedTurn() <= 20 then
		for unit in closestMinor:Units() do
			local unitClass = GameInfo.Units[unit:GetUnitType()].Class
			if unitClass ~= "UNITCLASS_WARRIOR" then
				unit:Kill()
			end
		end
	end
end
LuaEvents.ActivePlayerTurnEnd_Player.Add(DeclareWarNearestCitystate)



-- AI city capture decision: keep or raze
function DoAICaptureDecision(city, player)
	--
	if player:IsHuman() then
		return
	end
	--]]
	if city:GetResistanceTurns() < 1 then
		-- peaceful acquisition
		return
	end
	
	local valBuildings	= 0
	for buildingInfo in GameInfo.Buildings() do
		if city:IsHasBuilding(buildingInfo.ID) then
			if Building_IsWonder(buildingInfo.Type) then
				valBuildings = 99999
				break
			else
				valBuildings = valBuildings + player:GetBuildingProductionNeeded(buildingInfo.ID)
			end
		end
	end
	valBuildings = Cep.AI_VALUE_BUILDINGS * valBuildings
	
	local happiness		= player:GetExcessHappiness() + City_GetYieldChangeForAction(city, player, "CAPTURE_PUPPET")
	local happyTarget	= Cep.AI_CAPTURE_HAPPINESS_TARGET
	local valPop		= Cep.AI_VALUE_POPULATION * city:GetPopulation()
	local valPlots		= Cep.AI_VALUE_FERTILITY * Plot_GetFertilityInRange(city:Plot(), 3)
	local valTotal		= valPop + valPlots + valBuildings
	local valRequired	= Cep.AI_CAPTURE_VALUE_MULTIPLIER * (happyTarget - math.min(happyTarget, happiness)) ^ Cep.AI_CAPTURE_VALUE_EXPONENT + Cep.AI_CAPTURE_VALUE_CONSTANT
	
	if player:CanRaze(city, false) and (valTotal < valRequired) then
		log:Info("%s captured %s decision: raze (happiness=%s valPop=%s valPlots=%s valBuildings=%s valRequired=%s)", player:GetName(), city:GetName(), happiness, valPop, valPlots, valBuildings, valRequired)
		City_Capture(city, player, "CAPTURE_RAZE")
	elseif happiness < happyTarget then
		log:Info("%s captured %s decision: sack (happiness=%s valPop=%s valPlots=%s valBuildings=%s valRequired=%s)", player:GetName(), city:GetName(), happiness, valPop, valPlots, valBuildings, valRequired)
		City_Capture(city, player, "CAPTURE_SACK")
	else
		log:Info("%s captured %s decision: intact (happiness=%s valPop=%s valPlots=%s valBuildings=%s valRequired=%s)", player:GetName(), city:GetName(), happiness, valPop, valPlots, valBuildings, valRequired)
		City_Capture(city, player, "CAPTURE_PUPPET")
	end
end
LuaEvents.AICaptureDecision.Add(function(city, player) return SafeCall(DoAICaptureDecision, city, player) end)



-- Manually clear barbarian camps

function ClearCamps()
	if Game.GetAdjustedTurn() <= 20 or Game.GetGameTurn() % 3 ~= 0 then
		return
	end
	local nonHumans = {}
	for playerID, player in pairs(Players) do
		if player:IsAliveCiv() and not player:IsHuman() and not player:IsMinorCiv() then
			table.insert(nonHumans, player)
		end
	end
	Shuffle(nonHumans)
	for _, player in pairs(nonHumans) do
		for city in player:Cities() do
			ClearCampsCity(city, player)
		end
		for unit in player:Units() do
			ClearCampsUnit(unit)
		end
	end
end
--LuaEvents.ActivePlayerTurnEnd_Turn.Add(function() return SafeCall(ClearCamps) end)

function ClearCampsCity(city, player)
	if player:IsHuman() or player:IsMinorCiv() then
		return
	end
	
	local searchRange = Game.GetWorldInfo().AISearchRange
	local campID = GameInfo.Improvements.IMPROVEMENT_BARBARIAN_CAMP.ID
	local clearOdds = 5
	log:Debug("ClearCampsCity %s %s distance=%s", player:GetName(), city:GetName(), searchRange)
	for nearPlot, distance in Plot_GetPlotsInCircle(city:Plot(), 2, searchRange) do
		local impID = nearPlot:GetImprovementType()
		if impID ~= -1 then
			log:Trace("%s", GameInfo.Improvements[impID].Type)
		end
		if impID == campID then
			log:Debug("ClearCampsCity %s %s distance=%s", player:GetName(), city:GetName(), distance)
			local campUnit = nearPlot:GetUnit(0)
			if Plot_IsNearHuman(nearPlot, 2 * distance) then
				log:Debug("ClearCampsCity aborting: near human", player:GetName(), city:GetName())
			elseif (not campUnit) or campUnit:FortifyModifier() > GameDefines.FORTIFY_MODIFIER_PER_TURN then  -- barb has been here a while
				if clearOdds > Map.Rand(100, "Clear barb camp near AI") then
					ClearCamp(player, nearPlot)
				end
			end
		end
	end
end
--LuaEvents.ActivePlayerTurnEnd_City.Add(function(city, player) return SafeCall(ClearCampsCity, city, player) end)

function ClearCampsUnit(unit)
	local player = Players[unit:GetOwner()]
	if player:IsHuman() or player:IsMinorCiv() or not unit:IsCombatUnit() then
		return
	end
	
	local searchRange = Game.GetWorldInfo().AISearchRange
	local campID = GameInfo.Improvements.IMPROVEMENT_BARBARIAN_CAMP.ID
	local clearOdds = 5
	for nearPlot in Plot_GetPlotsInCircle(unit:GetPlot(), 1, 1) do
		if nearPlot:GetImprovementType() == campID then
			if nearPlot:IsVisibleToWatchingHuman() then
				log:Info("ClearCampsUnit aborting: visible to human", player:GetName(), unit:GetName())
			else
				if clearOdds > Map.Rand(100, "Clear barb camp near AI") then
					log:Debug("ClearCampsUnit %s %s", player:GetName(), unit:GetName())
					ClearCamp(player, nearPlot)
					for i=0, nearPlot:GetNumUnits()-1 do
						local nearUnit = nearPlot:GetUnit(i)
						if Players[nearUnit:GetOwner()]:IsBarbarian() and nearUnit:IsCombatUnit() then
							nearUnit:Kill()
							unit:ChangeExperience(10)
							log:Info("Killed barbarian %s with 10 experience for %s", nearUnit:GetName(), unit:GetName())
							break
						end
					end
				end
			end
		end
	end
end
--LuaEvents.ActivePlayerTurnEnd_Unit.Add(function(unit) return SafeCall(ClearCampsUnit, unit) end)

function ClearCamp(player, plot)
	local campGold = Game.GetHandicapInfo().BarbCampGold
	plot:SetImprovementType(-1)
	player:ChangeGold(campGold)
	log:Info("Cleared camp +%s gold for %s", campGold, player:GetName())
end




--
-- Manually place Moai Statues
--

function PlaceMoai(player)
	if player:IsHuman() or not (player:GetTraitInfo().CombatBonusImprovement == "IMPROVEMENT_MOAI") then
		return
	end
	if not player:HasTech(GameInfo.Builds.BUILD_MOAI.PrereqTech) then
		return
	end
	log:Info("PlaceMoai %s", player:GetName())

	--[[
	local cities = {}
	for city in player:Cities() do
		if not city:IsResistance() and not city:IsRazing() then
			table.insert(cities, {id=City_GetID(city), pop=city:GetPopulation()})
		end
	end
	table.sort(cities, function(a, b) return a.pop > b.pop end)

	for _,cityInfo in ipairs(cities) do
		local city = Map_GetCity(cityInfo.id)		
	--]]

	local playerID = player:GetID()
	local moaiID = GameInfo.Improvements.IMPROVEMENT_MOAI.ID
	for city in player:Cities() do
		for i = 0, city:GetNumCityPlots() - 1, 1 do
			local plot = city:GetCityIndexPlot(i);
			if plot then
				local featureID = plot:GetFeatureType()
				if (plot:GetOwner() == playerID
					and plot:GetImprovementType() ~= moaiID
					and plot:GetResourceType() == -1
					and plot:IsCoastalLand()
					and (featureID == -1
						or featureID == FeatureTypes.FEATURE_JUNGLE
						or featureID == FeatureTypes.FEATURE_FOREST
						or featureID == FeatureTypes.FEATURE_MARSH)
					and not plot:IsCity()
					and not plot:IsVisibleToWatchingHuman()
					) then
					log:Info("Placed moai for %s", player:GetName())
					plot:SetImprovementType(moaiID)
					if plot:GetFeatureType() ~= -1 then
						plot:SetFeatureType(FeatureTypes.NO_FEATURE, -1)
					end
					break
				end
			end
		end
	end
end

if GameInfo.Builds.BUILD_MOAI then
	LuaEvents.ActivePlayerTurnEnd_Player.Add(PlaceMoai)
end


--
-- Manually place Terrace Farms
--

function PlaceTerrace(player)
	if player:IsHuman() or (GameInfo.Civilizations[player:GetCivilizationType()].Type ~= GameInfo.Improvements.IMPROVEMENT_TERRACE_FARM.CivilizationType) then
		return
	end
	if not player:HasTech(GameInfo.Builds.BUILD_TERRACE_FARM.PrereqTech) then
		return
	end
	log:Info("PlaceTerrace %s", player:GetName())

	--[[
	local cities = {}
	for city in player:Cities() do
		if not city:IsResistance() and not city:IsRazing() then
			table.insert(cities, {id=City_GetID(city), pop=city:GetPopulation()})
		end
	end
	table.sort(cities, function(a, b) return a.pop > b.pop end)

	for _,cityInfo in ipairs(cities) do
		local city = Map_GetCity(cityInfo.id)		
	--]]

	local playerID = player:GetID()
	local impID = GameInfo.Improvements.IMPROVEMENT_TERRACE_FARM.ID
	for city in player:Cities() do
		for i = 0, city:GetNumCityPlots() - 1, 1 do
			local plot = city:GetCityIndexPlot(i);
			if plot then
				local featureID = plot:GetFeatureType()
				if (plot:GetOwner() == playerID
						and plot:GetImprovementType() ~= impID
						and plot:GetResourceType() == -1
						and (featureID == -1
							or featureID == FeatureTypes.FEATURE_JUNGLE
							or featureID == FeatureTypes.FEATURE_FOREST
							or featureID == FeatureTypes.FEATURE_MARSH)
						and not plot:IsCity()
						and not plot:IsVisibleToWatchingHuman()
						) then
					local placeTerrace = false
					for nearPlot in Plot_GetPlotsInCircle(plot, 1) do
						if nearPlot:IsMountain() then
							placeTerrace = true
							break
						end
					end
					if placeTerrace then
						log:Info("Placed terrace for %s", player:GetName())
						plot:SetImprovementType(impID)
						if plot:GetFeatureType() ~= -1 then
							plot:SetFeatureType(FeatureTypes.NO_FEATURE, -1)
						end
						break
					end
				end
			end
		end
	end
end

if GameInfo.Builds.BUILD_TERRACE_FARM then
	LuaEvents.ActivePlayerTurnEnd_Player.Add(PlaceMoai)
end