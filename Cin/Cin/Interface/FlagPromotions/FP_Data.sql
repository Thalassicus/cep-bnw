-- Insert SQL Rules Here 

UPDATE UnitPromotions SET IsVisibleAboveFlag = 0;

UPDATE UnitPromotions SET IsVisibleAboveFlag = 1
WHERE Type IN (
	'PROMOTION_IGNORE_TERRAIN_COST_NOUPGRADE'	, --not on all units
	'PROMOTION_IGNORE_TERRAIN_COST'				, --not on all units
	'PROMOTION_SKIRMISH' 						, --earned
	'PROMOTION_MORALE' 							, --not on all units
	'PROMOTION_STATUE_ZEUS' 					, --not on all units
	'PROMOTION_MERCENARY' 						, --Germans
	'PROMOTION_DESERT_POWER'					, --barbarians
	'PROMOTION_ARCTIC_POWER'					, --barbarians
	'PROMOTION_HILL_FIGHTER'					, --barbarians
	'PROMOTION_WOODSMAN' 						, --barbarians
	'PROMOTION_BOMBARDMENT_1'					, --
	'PROMOTION_BOMBARDMENT_2'					, --
	'PROMOTION_BOMBARDMENT_3'					, --
	'PROMOTION_BLITZ'							, --
	'PROMOTION_LOGISTICS'						, --
	'PROMOTION_EXTRA_SIGHT_NOUPGRADE_II'		, --China
	'PROMOTION_EXTRA_MOVES_I'					--
) OR (Class = 'PROMOTION_CLASS_PERSISTANT' AND NOT (
	   Type LIKE '%PENALTY%'
	OR Type LIKE '%NOUPGRADE%'
	OR Type IN (
		'PROMOTION_ROUGH_TERRAIN_ENDS_TURN'		, --penalty
		'PROMOTION_ONLY_DEFENSIVE'				, --penalty
		'PROMOTION_NO_DEFENSIVE_BONUSES'		, --penalty
		'PROMOTION_MUST_SET_UP'					, --penalty
		'PROMOTION_CITY_SIEGE'					, --demolish
		'PROMOTION_CITY_ASSAULT'				, --demolish
		'PROMOTION_NEW_UNIT'					, --
		'PROMOTION_DEFENSE_1'					, --
		'PROMOTION_DEFENSE_2'					, --
		'PROMOTION_CAN_MOVE_AFTER_ATTACKING'	, --
		'PROMOTION_GREAT_GENERAL'				, --
		'PROMOTION_INDIRECT_FIRE'				, --
		'PROMOTION_FREE_UPGRADES'				, --citystates
		'PROMOTION_ANTI_CAVALRY'				, --Ottomans
		'PROMOTION_MEDIC_GENERAL'				, --Mongolia
		'PROMOTION_SENTRY'						, --America
		'PROMOTION_DEFENSIVE_EMBARKATION'		, --Songhai
		'PROMOTION_FREE_PILLAGE_MOVES'			, --Denmark
		'PROMOTION_OCEAN_MOVEMENT'				, --England
		'PROMOTION_OCEAN_IMPASSABLE'			 --Korea
	))
);
