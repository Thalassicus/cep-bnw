--

INSERT INTO PolicyBranchTypes(Type, Description, EraPrereq, AIMutuallyExclusive)
SELECT DISTINCT Type, Description, 'ERA_FUTURE', 1
FROM Policies WHERE NOT (
   Type IN (SELECT FreePolicy FROM PolicyBranchTypes)
OR Type IN (SELECT FreeFinishingPolicy FROM PolicyBranchTypes)
);

INSERT INTO Policy_FreeBuildingClass(
	PolicyType, 
	BuildingClass, 
	NumCities)
SELECT DISTINCT
	'POLICY_GLADIATORS', 
	BuildingClass, 
	-1
FROM Buildings WHERE BuildingClass IN (
	'BUILDINGCLASS_COLOSSEUM'	
);


INSERT INTO Policy_BuildingClassYieldChanges
	(PolicyType, BuildingClassType, YieldType, YieldChange)
SELECT DISTINCT
	'POLICY_CULTURAL_CENTERS', BuildingClass, 'YIELD_CULTURE', 2
FROM Buildings WHERE BuildingClass IN (
	SELECT Type FROM BuildingClasses
	WHERE (MaxPlayerInstances = 1) AND NOT Type IN (
		'BUILDINGCLASS_PALACE'
	)
);

INSERT INTO Policy_BuildingClassYieldChanges
	(PolicyType, BuildingClassType, YieldType, YieldChange)
SELECT DISTINCT
	'POLICY_RATIONALISM', BuildingClass, 'YIELD_SCIENCE', 4
FROM Buildings WHERE BuildingClass IN (
	SELECT Type FROM BuildingClasses
	WHERE (MaxPlayerInstances = 1) AND NOT Type IN (
		'BUILDINGCLASS_PALACE'
	)
);

INSERT INTO Policy_BuildingClassYieldChanges
	(PolicyType, BuildingClassType, YieldType, YieldChange)
SELECT DISTINCT
	'POLICY_SOVEREIGNTY', BuildingClass, 'YIELD_HAPPINESS', 1
FROM Buildings WHERE BuildingClass IN (
	SELECT Type FROM BuildingClasses
	WHERE (MaxPlayerInstances = 1) AND NOT Type IN (
		'BUILDINGCLASS_PALACE'
	)
);

/* Commented out until the Yield Library is updated

INSERT INTO Policy_BuildingClassYieldChanges(
	PolicyType, 
	BuildingClassType, 
	YieldType,
	YieldChange)
SELECT DISTINCT
	'POLICY_CEREMONIAL_RITES', 
	BuildingClass, 
	'YIELD_CULTURE',
	1
FROM Buildings WHERE BuildingClass IN (
	'BUILDINGCLASS_MONUMENT'		,
	'BUILDINGCLASS_AMPHITHEATER'	,
	'BUILDINGCLASS_OPERA_HOUSE'		,
	'BUILDINGCLASS_MUSEUM'			,
	'BUILDINGCLASS_BROADCAST_TOWER'	
);*/

INSERT INTO Policy_BuildingClassCultureChanges(
	PolicyType, 
	BuildingClassType, 
	CultureChange)
SELECT DISTINCT
	'POLICY_CEREMONIAL_RITES', 
	BuildingClass, 
	1
FROM Buildings WHERE BuildingClass IN (
	'BUILDINGCLASS_MONUMENT'		,
	'BUILDINGCLASS_AMPHITHEATER'	,
	'BUILDINGCLASS_OPERA_HOUSE'		,
	'BUILDINGCLASS_MUSEUM'			,
	'BUILDINGCLASS_BROADCAST_TOWER'	
);

--CSD Compatibility

UPDATE Policies
SET Help = 'TXT_KEY_POLICY_PHILANTHROPY_HELP_CSD_NODLL'
WHERE Type = 'POLICY_PHILANTHROPY' AND EXISTS (SELECT Value FROM Cep WHERE Type='USING_CSD' AND Value > 0);

UPDATE Policies
SET Help = 'TXT_KEY_POLICY_PHILANTHROPY_HELP_CSD_DLL'
WHERE Type = 'POLICY_PHILANTHROPY' AND EXISTS (SELECT Value FROM Cep WHERE Type='USING_CSD' AND Value = 2);

UPDATE Policies
SET MinorGoldFriendshipMod = 0
WHERE Type = 'POLICY_PHILANTHROPY' AND EXISTS (SELECT Value FROM Cep WHERE Type='USING_CSD' AND Value > 0);

INSERT INTO Policy_BuildingClassHappiness
(PolicyType, BuildingClassType, Happiness)
SELECT 'POLICY_PHILANTHROPY', 'BUILDINGCLASS_SCRIBE', '1'
WHERE EXISTS (SELECT Value FROM Cep WHERE Type='USING_CSD' AND Value > 0);

UPDATE LoadedFile SET Value=1 WHERE Type='CEP_End.sql';