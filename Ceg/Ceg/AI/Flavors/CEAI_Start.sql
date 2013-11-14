-- 

/*
UPDATE Building_Flavors SET Flavor = 8;

UPDATE Building_Flavors SET Flavor = 16
WHERE BuildingType IN (SELECT building.Type
FROM Buildings building, BuildingClasses class
WHERE (building.BuildingClass = class.Type AND (
	   class.MaxGlobalInstances = 1
	OR class.MaxPlayerInstances = 1
	OR class.MaxTeamInstances = 1
)));
*/



UPDATE Resources SET Land = 1 WHERE Type IN (
	SELECT res.Type
	FROM Resources res, Improvements improve, Improvement_ResourceTypes improveRes
	WHERE res.Type      = improveRes.ResourceType
	  AND improve.Type  = improveRes.ImprovementType
	  AND improve.Water <> 1
	  );

UPDATE Resources SET Water = 1 WHERE Type IN (
	SELECT res.Type
	FROM Resources res, Improvements improve, Improvement_ResourceTypes improveRes
	WHERE res.Type      = improveRes.ResourceType
	  AND improve.Type  = improveRes.ImprovementType
	  AND improve.Water = 1
	  );

UPDATE CitySpecialization_TargetYields
SET Yield = 50
WHERE YieldType = 'YIELD_FOOD';

UPDATE UnitCombatInfos SET FlavorType = 'FLAVOR_OFFENSE';
UPDATE UnitCombatInfos SET FlavorType = 'FLAVOR_RECON'			WHERE Type IN ('UNITCOMBAT_RECON' );
UPDATE UnitCombatInfos SET FlavorType = 'FLAVOR_SOLDIER'		WHERE Type IN ('UNITCOMBAT_MELEE' );
UPDATE UnitCombatInfos SET FlavorType = 'FLAVOR_MOBILE'			WHERE Type IN ('UNITCOMBAT_MOUNTED', 'UNITCOMBAT_GUN', 'UNITCOMBAT_ARMOR' );
UPDATE UnitCombatInfos SET FlavorType = 'FLAVOR_RANGED'			WHERE Type IN ('UNITCOMBAT_ARCHER' );
UPDATE UnitCombatInfos SET FlavorType = 'FLAVOR_SIEGE'			WHERE Type IN ('UNITCOMBAT_SIEGE' );
UPDATE UnitCombatInfos SET FlavorType = 'FLAVOR_OFFENSE'		WHERE Type IN ('UNITCOMBAT_HELICOPTER' );
UPDATE UnitCombatInfos SET FlavorType = 'FLAVOR_NAVAL'			WHERE Type IN ('UNITCOMBAT_NAVALMELEE', 'UNITCOMBAT_SUBMARINE' );
UPDATE UnitCombatInfos SET FlavorType = 'FLAVOR_NAVAL_BOMBARDMENT'	WHERE Type IN ('UNITCOMBAT_NAVALRANGED');
UPDATE UnitCombatInfos SET FlavorType = 'FLAVOR_AIR'			WHERE Type IN ('UNITCOMBAT_FIGHTER', 'UNITCOMBAT_BOMBER' );
UPDATE UnitCombatInfos SET FlavorType = 'FLAVOR_AIR_CARRIER'	WHERE Type IN ('UNITCOMBAT_CARRIER' );



-- TODO: Temporary changes to remove once we set up full AI enhancements for new leaders
UPDATE Leader_Flavors
SET Flavor = MIN(10, Flavor + 3)
WHERE FlavorType = 'FLAVOR_EXPANSION';

UPDATE Leader_MajorCivApproachBiases
SET Bias = Bias + 2
WHERE Bias >= 5 AND MajorCivApproachType = 'MAJOR_CIV_APPROACH_WAR';

UPDATE Leaders SET Personality = 'PERSONALITY_EXPANSIONIST';

UPDATE LoadedFile SET Value=1 WHERE Type='CEAI__Start.sql';