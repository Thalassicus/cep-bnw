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


-- TODO: Temporary changes to remove later once we reactivate full AI enhancements
UPDATE Leader_Flavors
SET Flavor = MIN(10, Flavor + 3)
WHERE FlavorType = 'FLAVOR_EXPANSION';

UPDATE Leader_MajorCivApproachBiases
SET Bias = Bias + 2
WHERE Bias >= 5 AND MajorCivApproachType = 'MAJOR_CIV_APPROACH_WAR';

UPDATE Leaders SET Personality = 'PERSONALITY_EXPANSIONIST';

UPDATE LoadedFile SET Value=1 WHERE Type='CEAI__Start.sql';