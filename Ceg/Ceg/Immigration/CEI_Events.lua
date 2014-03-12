--------------------------------------------------------------
-- Immigration Mod
-- Authors: killmeplease, thalassicus
-- DateCreated: 10/4/2010 6:23:59 PM
--------------------------------------------------------------

-- TODO: immigration for all players, with bonus for America

include("MT_Events.lua")

local log = Events.LuaLogger:New()
log:SetLevel("INFO")

--[[

Credits:
killmeplease	- original Emigration mod
Afforess		- save/load procedure
Thalassicus		- expansion and polishing

--]]

--
-- Globals
--

DebugMode = GameInfo.Immigration["Debug"].Value == 1
QUEUE_CAPACITY = GameInfo.Immigration["HappinessAverageTurns"].Value * GameInfo.CepGameSpeeds[PreGame.GetGameSpeed()].GrowthPercent / 100
AverageHappiness = {}
HappinessTable = nil
america = nil
americaID = -1

--
-- Main
--

function DoImmigration()
	if not HappinessTable then
		DoGameInitialization()
	end
	
	if not america or not america:IsAliveCiv() or america:GetExcessHappiness() <= 0 or america:GetNumCities() <= 1 then
		return
	end

	UpdateHappinessInfo()
	
	local odds = 0.5 * america:GetExcessHappiness() / Game.GetSpeedInfo(america).GrowthPercent * (1.2 ^ america:GetNumCities())
	local random = Map.Rand(100, "Immigration Chance")
	log:Info("DoImmigration (%s >= %s) = %s", 100 * odds, random, 100 * odds >= random)
	if 100 * odds >= random then
		-- do immigration
	else
		return
	end
	
	
	local immigrateWeight = {}
	for playerID, player in pairs(Players) do
		if (player:IsAliveCiv()
				and not player:IsMinorCiv()
				and player ~= america
				and player:IsAtPeace(america)
				) then
				
			local influence		= america:GetInfluenceOn(playerID)
			local culture		= player:GetJONSCultureEverGenerated()
			local cultureWeight	= 1.1 ^ (10 * influence / (culture or 10))
			local happyWeight	= 1.05 ^ (-1 * player:GetExcessHappiness())
			local popWeight		= 0
			for city in player:Cities() do
				popWeight = popWeight + city:GetPopulation()
			end
			
			immigrateWeight[playerID] = popWeight * cultureWeight * happyWeight
			log:Debug("%30s weight=%s", player:GetName(), immigrateWeight[playerID])
		end
	end
	
	local playerID = Game.GetRandomWeighted(immigrateWeight)
	local player = Players[playerID]
	
	if player then
		DoEmigratePlayer(player, 1)
	end
	
	--[[
	local avgHappy = HappinessTable[playerID]:average()
	
	local bShouldEmigrate = (player:GetExcessHappiness() < america:GetExcessHappiness() and avgHappy < america:GetExcessHappiness())
	log:Info("%30s americaHappy:%2s excessHappy:%2s avgHappy:%2s immigrantWeight=%s", player:GetName(), america:GetExcessHappiness(), player:GetExcessHappiness(), avgHappy, immigrateWeight[playerID])
	
	local numEmigrants = math.floor(-avgHappy / GameInfo.Immigration.NumEmigrantsDenominator.Value) + 1
	DoEmigratePlayer(player, numEmigrants)
	--]]
	
	SaveGameData()
end

--Events.ActivePlayerTurnStart.Add( DoImmigration )

--
-- Utility Functions
--

function DoGameInitialization()
	HappinessTable = {}
	for playerID, player in pairs(Players) do
		if player:IsAliveCiv() then
			if player:GetTraitInfo().ImmigrationFrequency then
				americaID = playerID
				america = player
			end
			local SaveData = player:GetScriptData()
			--log:Debug("Attempting to Load Save Data")
			if SaveData == "" then
				HappinessTable[playerID] = Queue:new()
			else
				--log:Debug("Loading Save Data")
				--log:Debug(SaveData)
				SaveData = stringToTable(SaveData, QUEUE_CAPACITY, 1, {","}, 1)
				HappinessTable[playerID] = Queue:new(SaveData)
			end
		end
	end
end
------------------------------------------------------------------------------
function SaveGameData()
	for playerID,player in pairs(Players) do
		if player:IsAliveCiv() then
			--log:Debug("Attempting to Save Data")
			local tbl = tableToString(HappinessTable[playerID], QUEUE_CAPACITY, 1, {","}, 1)
			--log:Debug("Save Data Created")
			--log:Debug(tbl)
			player:SetScriptData(tbl)
		end
	end
end
------------------------------------------------------------------------------

------------------------------------------------------------------------------
function PrintContentsOfTable(incoming_table)
	if DebugMode then
		print("--------------------------------------------------")
		print("Table printout for table ID:", incoming_table)
		for index, data in pairs(incoming_table) do
			print("Table index:", index, " Table entry:", data)
		end
		print("- - - - - - - - - - - - - - - - - - - - - - - - - -")
	end
end
------------------------------------------------------------------------------
function UpdateHappinessInfo()
	log:Debug("UpdateHappinessInfo")
	for playerID,player in pairs(Players) do
		if player:IsAliveCiv() then
			HappinessTable[playerID]:push(player:GetExcessHappiness())
		end
	end
end
------------------------------------------------------------------------------
------------------------------------------------------------------------------
------------------------------------------------------------------------------
function GetCityByIndex(player, N)
	local n = 0
	for city in player:Cities() do
		if (n == N) then
			return city
		end
		n = n + 1
	end
end
------------------------------------------------------------------------------
function HasPolicyType(player, policyName)
	local policy = GameInfo.Policies[policyName]
	return policy and player:HasPolicy(policy.ID)
end
------------------------------------------------------------------------------
function DoEmigratePlayer(fromPlayer, numEmigrants)
	log:Debug("numEmigrants = " .. numEmigrants)
	local cityWeights = GetCityWeights(fromPlayer, false)
	local passNum = 0
	
	while numEmigrants > 0 and passNum <= GameInfo.Immigration["MaxPasses"].Value do
		passNum = passNum + 1
		
		local cityID = Game.GetRandomWeighted(cityWeights)
		if cityID then
			local fromCity = Map_GetCity(cityID)		
			local toPlayer = america--GetBestDestination(fromPlayer)	
			log:Info("Immigrate from %s to %s", fromPlayer:GetName(), toPlayer and toPlayer:GetName() or "nil")
			if toPlayer then
				log:Debug(" " .. Locale.ConvertTextKey(fromCity:GetNameKey()))
				cityWeights[cityID] = cityWeights[cityID] * GameInfo.Immigration_Weights.EmigratedOnceAlready.Value
				MovePopulation(fromPlayer, fromCity, toPlayer)
				numEmigrants = numEmigrants - 1
				if numEmigrants == 0 then return end
			end
		end
	end
end
------------------------------------------------------------------------------
function GetCityWeights(player, isDestination)
	local cityWeights = {}
	local cityProb = {}
	local totalCulture = 0
	local cityID = 0
	
	for city in player:Cities() do
		cityID = City_GetID(city)
		if city:GetPopulation() > 1 or isDestination then
			cityWeights[cityID] = 1
			
			-- retrieve function and weight from jump table stored in database
			for weight in GameInfo.Immigration_Weights() do
				if weight.IsCityStatus and (weight.IsOriginMod or isDestination) and city[weight.Type](city) then
					local bUseWeight = true

					for j in GameInfo.Immigration_Weight_Policy_Requirements() do
						if weight.Type == j.WeightType then
							if (j.ExcludesWeight and HasPolicyType(player, j.PolicyType)) then
								bUseWeight = false
							elseif (not j.ExcludesWeight and not HasPolicyType(player, j.PolicyType)) then
								bUseWeight = false
							end
						end
					end

					if bUseWeight then
						cityWeights[cityID] = cityWeights[cityID] * weight.Value
					end
				end
			end
			
			if isDestination then
				-- go to small frontier cities
				cityWeights[cityID] = cityWeights[cityID] * 1.2 ^ (-1 * city:GetPopulation())
			else
				-- come from large, low culture cities
				cityWeights[cityID] = cityWeights[cityID] * 1.2 ^ city:GetPopulation()
				cityWeights[cityID] = cityWeights[cityID] / (GameInfo.Immigration_Weights.Culture.Value * math.log(city:GetJONSCultureThreshold() + 2))
			end
			
			log:Debug("%20s %20s immigration weight = %s", player:GetName(), city:GetName(), cityWeights[cityID])
		end
	end
	return cityWeights
end
------------------------------------------------------------------------------
function GetBestDestination(fromPlayer)
	local fromPlayerTeam = Teams[fromPlayer:GetTeam()]
	local bestPlayer
	local iBestCountryValue = 0
	
	for playerID,player in pairs(Players) do
		if player:IsAliveCiv() then
			log:Debug("   is " .. player:GetName() .. " best?")
			if ( player ~= fromPlayer and fromPlayerTeam:IsHasMet(player:GetTeam()) and not fromPlayerTeam:IsAtWar(player:GetTeam())) then
				local averageHappiness = HappinessTable[playerID]:average()
				log:Debug("    averageHappiness = " .. averageHappiness)
				if (averageHappiness > 0) then
					local iPlayerValue = Map.Rand(averageHappiness, "Random country to emigrate to - Lua")	--calculate an immigration value TODO: add culture, open borders etc.
					log:Debug("    iPlayerValue = " .. iPlayerValue)
					if (iPlayerValue > iBestCountryValue) then
						iBestCountryValue = iPlayerValue
						bestPlayer = player
						log:Debug("   bestPlayer = " .. player:GetName())
					end
				end
			end
		end
	end
	return bestPlayer
end
------------------------------------------------------------------------------
function MovePopulation(fromPlayer, fromCity, toPlayer)
	local toCityID = Game.GetRandomWeighted(GetCityWeights(toPlayer, true))
	local toCity = Map_GetCity(toCityID)
	if not toCity then
		log:Error("MovePopulation: %s cityID=%s", toPlayer:GetName(), toCityID)
		return
	end
	
	fromCity:ChangePopulation(-1, true)
	toCity:ChangePopulation(1, true)

	if fromPlayer:IsHuman() then
		Alert(ModLocale.ConvertTextKey( "TXT_KEY_MIGRATE_OUT", fromCity:GetName(), "America" ))
	elseif toPlayer:IsHuman() then
		Alert(ModLocale.ConvertTextKey( "TXT_KEY_MIGRATE_IN", fromPlayer:GetCivName(), toCity:GetName() ))
	end
end
------------------------------------------------------------------------------
function Alert(text)
	-- should ideally do this as a right-side notification,
	-- but cannot add custom notifications in the unmodded game
	log:Info(text)
	Events.GameplayAlertMessage(text)
end
