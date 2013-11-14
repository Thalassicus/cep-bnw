--

INSERT INTO Belief_BuildingClassTourism(BeliefType, BuildingClassType, Tourism)
SELECT 'BELIEF_DIVINE_INSPIRATION', Type, 2
FROM BuildingClasses WHERE (
	MaxGlobalInstances = 1
);


/*
UPDATE Beliefs
SET GoldPerFirstCityConversion = 2 * GoldPerFirstCityConversion
WHERE GoldPerFirstCityConversion > 0;
*/

/*
UPDATE Beliefs
SET Follower = 1
WHERE Type IN (
	'BELIEF_PEACE_GARDENS',
	'BELIEF_ASCETISM',
	'BELIEF_RELIGIOUS_CENTER'
);
*/

UPDATE LoadedFile SET Value=1 WHERE Type='CEF_Start.sql';