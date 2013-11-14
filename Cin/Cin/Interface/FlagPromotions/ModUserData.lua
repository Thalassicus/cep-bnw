-- ModUserData
-- Author: Erendir
-- DateCreated: 1/23/2011 12:36:56 PM
--------------------------------------------------------------

local startClockTime = os.clock()

include("ModTools")

local log = Events.LuaLogger:New()
log:SetLevel("WARN")

local _VERBOSE = false
local print
if not _VERBOSE then print = function() end end

ModID		= "01127f62-3896-4897-b169-ecab445786cd";
ModVersion	= Modding.GetActivatedModVersion(ModID) or 3;
ModUserData = Modding.OpenUserData(ModID, ModVersion);

local query = nil

function IsAlwaysInvisible(promotionName)
	return (
	   string.find(promotionName,"PENALTY")
	or string.find(promotionName,"NOUPGRADE")
	or promotionName == "PROMOTION_ROUGH_TERRAIN_ENDS_TURN"		--penalty
	or promotionName == "PROMOTION_ONLY_DEFENSIVE"				--penalty
	or promotionName == "PROMOTION_NO_DEFENSIVE_BONUSES"		--penalty
	or promotionName == "PROMOTION_MUST_SET_UP"					--penalty
	or promotionName == "PROMOTION_CITY_SIEGE"					--demolish
	or promotionName == "PROMOTION_CITY_ASSAULT"				--demolish
	or promotionName == "PROMOTION_NEW_UNIT"					--
	or promotionName == "PROMOTION_DEFENSE_1"					--
	or promotionName == "PROMOTION_DEFENSE_2"					--
	or promotionName == "PROMOTION_CAN_MOVE_AFTER_ATTACKING"	--
	or promotionName == "PROMOTION_GREAT_GENERAL"				--
	or promotionName == "PROMOTION_INDIRECT_FIRE"				--
	or promotionName == "PROMOTION_FREE_UPGRADES"				--citystates	
	or promotionName == "PROMOTION_ANTI_CAVALRY"				--Ottomans
	or promotionName == "PROMOTION_MEDIC_GENERAL"				--Mongolia
	or promotionName == "PROMOTION_SENTRY"						--America
	or promotionName == "PROMOTION_DEFENSIVE_EMBARKATION"		--Songhai
	or promotionName == "PROMOTION_FREE_PILLAGE_MOVES"			--Denmark
	or promotionName == "PROMOTION_OCEAN_MOVEMENT"				--England
	or promotionName == "PROMOTION_OCEAN_IMPASSABLE"			--Korea
	)
end

--[[ this query works in SQL but fails on Arctic_Power in Lua for some reason I can't identify - thal
query = 
        PediaType = 'PEDIA_ATTRIBUTES'
OR      PediaType = 'PEDIA_SHARED'
OR		Type LIKE '%PENALTY%'
OR		Type LIKE '%NOUPGRADE%'
OR		Type = 'PROMOTION_ROUGH_TERRAIN_ENDS_TURN'		-- penalty
OR		Type = 'PROMOTION_ONLY_DEFENSIVE' 				-- penalty
OR		Type = 'PROMOTION_NO_DEFENSIVE_BONUSES' 		-- penalty
OR		Type = 'PROMOTION_MUST_SET_UP' 					-- penalty
OR		Type = 'PROMOTION_CITY_SIEGE' 					-- demolish
OR		Type = 'PROMOTION_GREAT_GENERAL' 				-- leadership
OR		Type = 'PROMOTION_CAN_MOVE_AFTER_ATTACKING' 	-- mobile
AND NOT Type = 'PROMOTION_INDIRECT_FIRE' 				-- earned
AND NOT Type = 'PROMOTION_CAN_MOVE_AFTER_ATTACKING' 	-- not important
AND NOT Type = 'PROMOTION_DESERT_POWER' 				-- barbarians
AND NOT Type = 'PROMOTION_ARCTIC_POWER' 				-- barbarians
AND NOT Type = 'PROMOTION_HILL_FIGHTER' 				-- barbarians
AND NOT Type = 'PROMOTION_WOODSMAN' 					-- barbarians
AND NOT Type IN ( 
	SELECT PromotionType
	FROM Unit_FreePromotions
	WHERE UnitType IN (
		SELECT UnitType
		FROM Civilization_UnitClassOverrides
		WHERE CivilizationType != 'CIVILIZATION_BARBARIAN'
		)
	)
--]]


default_ignoredPromotion = {}
for promotionInfo in GameInfo.UnitPromotions() do
	if (
		   promotionInfo.PediaType == "PEDIA_ATTRIBUTES"
		or promotionInfo.PediaType == "PEDIA_SHARED"
		or IsAlwaysInvisible(promotionInfo.Type)
		) then
		default_ignoredPromotion[promotionInfo.Type] = true
	end
end

--[[
query = 
UnitType IN (
	SELECT UnitType
	FROM Civilization_UnitClassOverrides
	WHERE CivilizationType != 'CIVILIZATION_BARBARIAN'
	)

for promotionInfo in GameInfo.Unit_FreePromotions(query) do
	if not IsAlwaysInvisible(promotionInfo.PromotionType) then
		default_ignoredPromotion[promotionInfo.PromotionType] = false
	end
end
--]]

default_ignoredPromotion["PROMOTION_IGNORE_TERRAIN_COST"]	= false --not on all units
default_ignoredPromotion["PROMOTION_SKIRMISH"] 				= false --earned
default_ignoredPromotion["PROMOTION_MORALE"] 				= false --not on all units
default_ignoredPromotion["PROMOTION_STATUE_ZEUS"] 			= false --not on all units
default_ignoredPromotion["PROMOTION_MERCENARY"] 			= false --Germans
default_ignoredPromotion["PROMOTION_DESERT_POWER"]			= false --barbarians
default_ignoredPromotion["PROMOTION_ARCTIC_POWER"]			= false --barbarians
default_ignoredPromotion["PROMOTION_HILL_FIGHTER"]			= false --barbarians
default_ignoredPromotion["PROMOTION_WOODSMAN"] 				= false --barbarians
default_ignoredPromotion["PROMOTION_BOMBARDMENT_1"]			= false --
default_ignoredPromotion["PROMOTION_BOMBARDMENT_2"]			= false --
default_ignoredPromotion["PROMOTION_BOMBARDMENT_3"]			= false --
default_ignoredPromotion["PROMOTION_BLITZ"]					= false --
default_ignoredPromotion["PROMOTION_LOGISTICS"]				= false --
default_ignoredPromotion["PROMOTION_EXTRA_MOVES_I"]			= false --

	
ignorePromotion = {}

function updateIgnoredPromotions()
	print'updateIgnoredPromotions'
    -- get list of ignored promotion from ModUserData
    for promotion in GameInfo.UnitPromotions() do
		local id = promotion.ID
		ignorePromotion[id] = default_ignoredPromotion[promotion.Type]
		if Civup.USE_FLAG_PROMOTION_DEFAULTS == 1 then
			ignorePromotion[id] = default_ignoredPromotion[promotion.Type]
		else
			local ignore = ModUserData.GetValue(id)
			if ignore == nil then
				ignore = default_ignoredPromotion[promotion.Type]
				ModUserData.SetValue(id, ignore and 0 or 1)
			else
				ignore = (ignore == 0) and true or false
			end
			ignorePromotion[id]=ignore
		end
    end
end

updateIgnoredPromotions()

print(string.format("%3s ms loading ModUserData.lua", Game.Round((os.clock() - startClockTime)*1000)))