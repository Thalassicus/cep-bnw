-- 


--
-- Availability: Builds
--

-- Common like farms
UPDATE Builds SET AIAvailability = 8
WHERE Type IN (SELECT build.Type FROM Improvements improve, Builds build
WHERE ( build.PrereqTech IS NOT NULL
	AND build.ImprovementType = improve.Type
	AND improve.SpecificCivRequired = 0
	AND improve.Type IN (SELECT ImprovementType FROM Improvement_ValidTerrains)
) OR  ( build.PrereqTech IS NOT NULL
	AND build.RouteType IS NOT NULL
));

-- Resource-specific
UPDATE Builds SET AIAvailability = 4
WHERE Type IN (SELECT build.Type FROM Improvements improve, Builds build
WHERE ( build.PrereqTech IS NOT NULL
	AND build.ImprovementType = improve.Type
	AND improve.SpecificCivRequired = 0
	AND improve.Type NOT IN (SELECT ImprovementType FROM Improvement_ValidTerrains)
));

-- Great improvements
UPDATE Builds SET AIAvailability = 2
WHERE Type IN (SELECT build.Type FROM Improvements improve, Builds build
WHERE ( build.ImprovementType = improve.Type
	AND improve.CreatedByGreatPerson = 1
));

-- Double
UPDATE Builds SET AIAvailability = 2
WHERE Type IN ('BUILD_WELL', 'BUILD_OFFSHORE_PLATFORM');