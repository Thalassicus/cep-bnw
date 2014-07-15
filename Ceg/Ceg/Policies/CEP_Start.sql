--

DELETE FROM Policy_PrereqPolicies;

--
-- Culture Scaling
--

UPDATE Traits	SET CultureFromKills = 1.5 * CultureFromKills;
UPDATE Traits	SET CityCultureBonus = 1 * CityCultureBonus;
UPDATE Eras		SET StartingCulture = 1 * StartingCulture;

UPDATE Improvement_Yields
SET Yield = 2
WHERE YieldType = 'YIELD_CULTURE' AND ImprovementType = 'IMPROVEMENT_MOAI';

UPDATE Improvements
SET CultureAdjacentSameType = 1 * CultureAdjacentSameType;

UPDATE Policies
SET CulturePerGarrisonedUnit = 1 * CulturePerGarrisonedUnit;

UPDATE Buildings SET PolicyBranchType = NULL
WHERE NOT IconAtlas = 'CSDBUILDINGS_ATLAS';

UPDATE Defines SET Value = 4 WHERE Name = 'NUM_POLICY_BRANCHES_ALLOWED'; --2

UPDATE LoadedFile SET Value=1 WHERE Type='CEP_Start.sql';
