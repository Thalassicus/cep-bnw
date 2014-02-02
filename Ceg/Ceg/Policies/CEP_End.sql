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
	'POLICY_HOMESTEAD_ACT', 
	BuildingClass, 
	-1
FROM Buildings WHERE BuildingClass IN (
	'BUILDINGCLASS_MONUMENT'	,
	'BUILDINGCLASS_GRANARY'		,
	'BUILDINGCLASS_BARRACKS'	,
	'BUILDINGCLASS_LIGHTHOUSE'	,
	'BUILDINGCLASS_LIBRARY'		,
	'BUILDINGCLASS_CARAVANSARY'	,
	'BUILDINGCLASS_STABLE'		,
	'BUILDINGCLASS_SMITH'		,
	'BUILDINGCLASS_WALLS'		,
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

-- Policy changes from pre-BNW for reference
/*
INSERT INTO Policy_BuildingClassYieldChanges(
	PolicyType, 
	BuildingClassType, 
	YieldType,
	YieldChange)
SELECT DISTINCT
	'POLICY_INSPIRATION', 
	BuildingClass, 
	'YIELD_CULTURE',
	2
FROM Buildings WHERE BuildingClass IN (
	'BUILDINGCLASS_SHRINE',
	'BUILDINGCLASS_TEMPLE',
	'BUILDINGCLASS_PAGODA',
	'BUILDINGCLASS_CATHEDRAL',
	'BUILDINGCLASS_MONASTERY',
	'BUILDINGCLASS_MOSQUE'
);

/*
INSERT INTO Policy_BuildingClassYieldChanges(
	PolicyType, 
	BuildingClassType, 
	YieldType,
	YieldChange)
SELECT DISTINCT
	'POLICY_LANDED_ELITE', 
	BuildingClass, 
	'YIELD_FOOD',
	2
FROM Buildings WHERE BuildingClass IN (
	'BUILDINGCLASS_WALLS'			,
	'BUILDINGCLASS_CASTLE'			,
	'BUILDINGCLASS_ARSENAL'			,
	'BUILDINGCLASS_MILITARY_BASE'	
);
*/

/*
INSERT INTO Policy_BuildingClassYieldChanges(
	PolicyType, 
	BuildingClassType, 
	YieldType,
	YieldChange)
SELECT DISTINCT
	'POLICY_REPUBLIC', 
	BuildingClass, 
	'YIELD_PRODUCTION',
	2
FROM Buildings WHERE BuildingClass IN (
	'BUILDINGCLASS_WALLS'			,
	'BUILDINGCLASS_CASTLE'			,
	'BUILDINGCLASS_ARSENAL'			,
	'BUILDINGCLASS_MILITARY_BASE'	
);

INSERT INTO Policy_BuildingClassYieldChanges(
	PolicyType, 
	BuildingClassType, 
	YieldType,
	YieldChange)
SELECT DISTINCT
	'POLICY_RATIONALISM', 
	BuildingClass, 
	'YIELD_SCIENCE',
	1
FROM Buildings WHERE BuildingClass IN (
	'BUILDINGCLASS_MENTORS_HALL'	,
	'BUILDINGCLASS_LIBRARY'			,
	'BUILDINGCLASS_UNIVERSITY'		,
	'BUILDINGCLASS_PUBLIC_SCHOOL'	,
	'BUILDINGCLASS_LABORATORY'		,
	'BUILDINGCLASS_OBSERVATORY'		
);

INSERT INTO Policy_BuildingClassYieldModifiers(
	PolicyType, 
	BuildingClassType, 
	YieldType,
	YieldMod)
SELECT DISTINCT
	'POLICY_CHARITY', 
	BuildingClass, 
	'YIELD_GOLD',
	5
FROM Buildings WHERE BuildingClass IN (
	'BUILDINGCLASS_SHRINE',
	'BUILDINGCLASS_TEMPLE',
	'BUILDINGCLASS_PAGODA',
	'BUILDINGCLASS_CATHEDRAL',
	'BUILDINGCLASS_MONASTERY',
	'BUILDINGCLASS_MOSQUE'
);

INSERT INTO Policy_BuildingClassProductionModifiers
	(PolicyType, BuildingClassType,  ProductionModifier)
SELECT DISTINCT
	'POLICY_MILITARY_TRADITION', BuildingClass, 20
FROM Buildings WHERE (
	Defense > 0
	OR GlobalDefenseMod > 0 
	OR Experience > 0
	OR GlobalExperience > 0
	OR Type IN (SELECT BuildingType FROM Building_DomainFreeExperiences)
	OR Type IN (SELECT BuildingType FROM Building_DomainProductionModifiers)
	OR Type IN (SELECT BuildingType FROM Building_UnitCombatFreeExperiences)
	OR Type IN (SELECT BuildingType FROM Building_UnitCombatProductionModifiers)
);

/*
INSERT INTO Policy_BuildingClassProductionModifiers(
	PolicyType, 
	BuildingClassType, 
	ProductionModifier)
SELECT DISTINCT
	'POLICY_DEMOCRACY', 
	BuildingClass, 
	20
FROM Buildings WHERE (
	SpecialistCount > 0
);
*/

/*
INSERT INTO Policy_BuildingClassYieldChanges(
	PolicyType, 
	BuildingClassType, 
	YieldType,
	YieldChange)
SELECT DISTINCT
	'POLICY_ORDER_FINISHER', 
	BuildingClass, 
	'YIELD_PRODUCTION',
	1
FROM Buildings WHERE BuildingClass IN (
	'BUILDINGCLASS_FACTORY',
	'BUILDINGCLASS_SPACESHIP_FACTORY',
	'BUILDINGCLASS_HYDRO_PLANT',
	'BUILDINGCLASS_SOLAR_PLANT',
	'BUILDINGCLASS_NUCLEAR_PLANT'
);
*/
/*
INSERT INTO Policy_BuildingClassYieldModifiers(
	PolicyType, 
	BuildingClassType, 
	YieldType,
	YieldMod)
SELECT DISTINCT
	'POLICY_ORDER_FINISHER', 
	BuildingClass, 
	'YIELD_PRODUCTION',
	10
FROM Buildings WHERE BuildingClass IN (
	'BUILDINGCLASS_FACTORY',
	'BUILDINGCLASS_SPACESHIP_FACTORY',
	'BUILDINGCLASS_HYDRO_PLANT',
	'BUILDINGCLASS_SOLAR_PLANT',
	'BUILDINGCLASS_NUCLEAR_PLANT'
);

INSERT INTO Policy_ImprovementYieldChanges
	(PolicyType, ImprovementType, YieldType, Yield)
SELECT
	'POLICY_FREE_SPEECH', 'IMPROVEMENT_MOAI', 'YIELD_CULTURE', '1'
WHERE EXISTS (SELECT * FROM Improvements WHERE Type='IMPROVEMENT_MOAI' );

INSERT INTO Policy_BuildingClassHappiness(
	PolicyType,
	BuildingClassType,
	Happiness)
SELECT DISTINCT
	'POLICY_WAR_EPICS',
	BuildingClass,
	1
FROM Buildings WHERE BuildingClass IN (
	'BUILDINGCLASS_MONUMENT'		,
	'BUILDINGCLASS_AMPHITHEATER'	,
	'BUILDINGCLASS_OPERA_HOUSE'		,
	'BUILDINGCLASS_MUSEUM'			,
	'BUILDINGCLASS_BROADCAST_TOWER'	
);

/*
INSERT INTO Policy_BuildingClassHappiness
	(PolicyType, BuildingClassType, Happiness)
SELECT DISTINCT
	'POLICY_TRADITION_FINISHER', BuildingClass, 1
FROM Buildings WHERE BuildingClass IN (
	SELECT Type FROM BuildingClasses
	WHERE (
		MaxGlobalInstances = 1
		OR MaxTeamInstances = 1
		OR MaxPlayerInstances = 1
	) AND NOT Type IN (
		'BUILDINGCLASS_PALACE'
	)
) AND NOT BuildingClass IN (
	SELECT BuildingClass FROM Buildings WHERE IsVisible = 0
);
*/

/*
INSERT INTO Policy_BuildingClassYieldChanges
	(PolicyType, BuildingClassType, YieldType, YieldChange)
SELECT DISTINCT
	'POLICY_ARISTOCRACY', BuildingClass, 'YIELD_CULTURE', 2
FROM Buildings WHERE BuildingClass IN (
	SELECT Type FROM BuildingClasses
	WHERE (
		MaxGlobalInstances = 1
		OR MaxTeamInstances = 1
		OR MaxPlayerInstances = 1
	) AND NOT Type IN (
		'BUILDINGCLASS_PALACE'
	)
) AND NOT BuildingClass IN (
	SELECT BuildingClass FROM Buildings WHERE IsVisible = 0
);
*/

UPDATE Policies
SET MinorGoldFriendshipMod = 0
WHERE Type = 'POLICY_PHILANTHROPY' AND EXISTS (SELECT Value FROM Cep WHERE Type='USING_CSD' AND Value= 1 );

INSERT INTO Policy_BuildingClassHappiness
(PolicyType, BuildingClassType, Happiness)
SELECT 'POLICY_PHILANTHROPY', 'BUILDINGCLASS_SCRIBE', '1'
WHERE EXISTS (SELECT Value FROM Cep WHERE Type='USING_CSD' AND Value= 1 );

UPDATE LoadedFile SET Value=1 WHERE Type='CEP_End.sql';