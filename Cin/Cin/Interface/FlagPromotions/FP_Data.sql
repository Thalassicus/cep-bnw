--

/*

Show promotions which are not obvious from looking at the unit.

The basic pattern is "equipment" effects do not show, and don't upgrade with the unit.
This includes anything we can see immediately by looking at the unit.

One example is all catapults get an anti-city bonus. This is obvious by looking at the unit,
so it does not need to be shown over the unit.

*/

UPDATE UnitPromotions SET IsVisibleAboveFlag = 0;

UPDATE UnitPromotions SET IsVisibleAboveFlag = 1
WHERE Type IN (
	-- explicitly show these
	'PROMOTION_IGNORE_TERRAIN_COST_NOUPGRADE'	, --not on all units
	'PROMOTION_IGNORE_TERRAIN_COST'				, --not on all units
	'PROMOTION_SKIRMISH' 						, --earned
	'PROMOTION_MORALE' 							, --not on all units
	'PROMOTION_STATUE_ZEUS' 					, --not on all units
	'PROMOTION_BOMBARDMENT_1'					, --earned
	'PROMOTION_BOMBARDMENT_2'					, --earned
	'PROMOTION_BOMBARDMENT_3'					, --earned
	'PROMOTION_BLITZ'							, --earned
	'PROMOTION_LOGISTICS'						, --earned
	'PROMOTION_EXTRA_MOVES_I'					, --
	'PROMOTION_DESERT_POWER'					, --barbarians
	'PROMOTION_ARCTIC_POWER'					, --barbarians
	'PROMOTION_HILL_FIGHTER'					, --barbarians
	'PROMOTION_WOODSMAN' 						, --barbarians
	'PROMOTION_MERCENARY' 						, --Germans
	'PROMOTION_CAMARADERIE' 					, --Ottomans
	'PROMOTION_EXTRA_SIGHT_NOUPGRADE_II'		  --China

) -- also show persistant (earned) effects
OR (Class = 'PROMOTION_CLASS_PERSISTENT' 
	AND NOT (
		   --hide penalties and promotions that do not upgrade
		   Type LIKE '%PENALTY%'
		OR Type LIKE '%NOUPGRADE%'
	
		   -- explicitly hide these
		OR Type IN (
			'PROMOTION_ROUGH_TERRAIN_ENDS_TURN'		, --penalty
			'PROMOTION_ONLY_DEFENSIVE'				, --penalty
			'PROMOTION_NO_DEFENSIVE_BONUSES'		, --penalty
			'PROMOTION_MUST_SET_UP'					, --penalty
			'PROMOTION_CITY_SIEGE'					, --demolish
			'PROMOTION_CITY_ASSAULT'				, --demolish
			'PROMOTION_NEW_UNIT'					, --all new units
			'PROMOTION_DEFENSE_1'					, --all vanguards
			'PROMOTION_CAN_MOVE_AFTER_ATTACKING'	, --all horses
			'PROMOTION_GREAT_GENERAL'				, --all generals
			'PROMOTION_INDIRECT_FIRE'				, --all artillery
			'PROMOTION_PANAMA_CANAL'				, --all ships
			'PROMOTION_NAVAL_TRADITION'				, --all ships
			'PROMOTION_ADJACENT_BONUS'				, --all military
			'PROMOTION_FREE_UPGRADES'				, --all citystates
			'PROMOTION_HANDICAP'					, --all AI units
			'PROMOTION_ANTI_CAVALRY'				, --Ottomans
			'PROMOTION_MEDIC_GENERAL'				, --Mongolia
			'PROMOTION_SENTRY'						, --America
			'PROMOTION_DEFENSIVE_EMBARKATION'		, --Songhai
			'PROMOTION_FREE_PILLAGE_MOVES'			, --Denmark
			'PROMOTION_OCEAN_MOVEMENT'				, --England
			'PROMOTION_OCEAN_IMPASSABLE'			, --Korea
			'PROMOTION_EMBARKATION'					  --Once Optics is researched we can conclude all units have this
		)
	)
);
