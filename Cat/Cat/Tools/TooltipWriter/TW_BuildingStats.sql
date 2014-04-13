-- This TW_BuildingStats.sql data created by:
-- BuildingStats tab of Cat_Details spreadsheet (in mod folder).

-- Header --

INSERT INTO BuildingStats(ID, Section, Priority, Dynamic, Type, Value) VALUES (0, 0,  1, 1, 'Name'                        , 'Game.GetDefaultBuildingStatText');


-- Special Abilities --

INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (1,  1, 0, 'Capital'                     , 'cepObjectInfo.Capital');
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (1,  2, 0, 'GoldenAge'                   , 'cepObjectInfo.GoldenAge');
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (1,  3, 0, 'FreeGreatPeople'             , 'cepObjectInfo.FreeGreatPeople');
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (1,  4, 0, 'FreeUnits'                   , 'Game.HasValue({BuildingType=cepObjectInfo.Type}, GameInfo.Building_FreeUnits)');
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (1,  5, 0, 'FreeBuildingThisCity'        , 'cepObjectInfo.FreeBuildingThisCity');
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (1,  6, 0, 'FreeBuilding'                , 'cepObjectInfo.FreeBuilding');
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (1,  7, 0, 'FreeResources'               , 'Game.HasValue({BuildingType=cepObjectInfo.Type}, GameInfo.Building_ResourceQuantity)');
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (1,  8, 0, 'TrainedFreePromotion'        , 'cepObjectInfo.TrainedFreePromotion and Locale.ConvertTextKey(GameInfo.UnitPromotions[cepObjectInfo.TrainedFreePromotion].Help) or false');
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (1,  9, 0, 'MapCentering'                , 'cepObjectInfo.MapCentering');
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (1, 10, 0, 'AllowsWaterRoutes'           , 'cepObjectInfo.AllowsWaterRoutes');
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (1, 11, 0, 'ExtraLuxuries'               , 'cepObjectInfo.ExtraLuxuries');

INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (1, 12, 0, 'DiplomaticVoting'            , 'cepObjectInfo.DiplomaticVoting');
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (1, 13, 0, 'GreatGeneralRateModifier'    , 'cepObjectInfo.GreatGeneralRateModifier');
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (1, 14, 0, 'GoldenAgeModifier'           , 'cepObjectInfo.GoldenAgeModifier');
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (1, 15, 0, 'UnitUpgradeCostMod'          , 'cepObjectInfo.UnitUpgradeCostMod');
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (1, 16, 0, 'CityCountUnhappinessMod'     , 'cepObjectInfo.CityCountUnhappinessMod');
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (1, 17, 0, 'WorkerSpeedModifier'         , 'cepObjectInfo.WorkerSpeedModifier');
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (1, 18, 0, 'CapturePlunderModifier'      , 'cepObjectInfo.CapturePlunderModifier');
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (1, 19, 0, 'PolicyCostModifier'          , 'cepObjectInfo.PolicyCostModifier');
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (1, 20, 0, 'GlobalInstantBorderRadius'   , 'cepObjectInfo.GlobalInstantBorderRadius');
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (1, 21, 0, 'PlotCultureCostModifier'     , 'cepObjectInfo.PlotCultureCostModifier');
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (1, 22, 0, 'PlotBuyCostModifier'         , 'cepObjectInfo.PlotBuyCostModifier');
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (1, 23, 0, 'GlobalPlotCultureCostModifier'      , 'cepObjectInfo.GlobalPlotCultureCostModifier');
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (1, 24, 0, 'GlobalPlotBuyCostModifier'   , 'cepObjectInfo.GlobalPlotBuyCostModifier');

INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (1, 25, 0, 'FoundsReligion'              , 'cepObjectInfo.FoundsReligion');
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (1, 26, 0, 'IsReligious'                 , 'cepObjectInfo.IsReligious');
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (1, 27, 0, 'Airlift'                     , 'cepObjectInfo.Airlift');
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (1, 28, 0, 'NukeExplosionRand'           , 'cepObjectInfo.NukeExplosionRand');
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (1, 29, 0, 'ExtraMissionarySpreads'      , 'cepObjectInfo.ExtraMissionarySpreads');
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (1, 30, 0, 'EspionageModifier'           , 'cepObjectInfo.EspionageModifier');
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (1, 31, 0, 'GlobalEspionageModifier'     , 'cepObjectInfo.GlobalEspionageModifier');
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (1, 32, 0, 'ExtraSpies'                  , 'cepObjectInfo.ExtraSpies');
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (1, 33, 0, 'SpyRankChange'               , 'cepObjectInfo.SpyRankChange');
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (1, 34, 0, 'InstantSpyRankChange'        , 'cepObjectInfo.InstantSpyRankChange');
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (1, 35, 0, 'ReplacementBuildingClass'    , 'cepObjectInfo.ReplacementBuildingClass');
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (1, 36, 0, 'SpecialistExtraCulture'      , 'cepObjectInfo.SpecialistExtraCulture');

INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (1, 37, 0, 'GlobalPopulationChange'      , 'cepObjectInfo.GlobalPopulationChange');
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (1, 38, 0, 'TechShare'                   , 'cepObjectInfo.TechShare');
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (1, 39, 0, 'FreeTechs'                   , 'cepObjectInfo.FreeTechs');
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (1, 40, 0, 'FreePolicies'                , 'cepObjectInfo.FreePolicies');
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (1, 41, 0, 'MinorFriendshipChange'       , 'cepObjectInfo.MinorFriendshipChange');
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (1, 42, 0, 'MinorFriendshipFlatChange'   , 'cepObjectInfo.MinorFriendshipFlatChange');
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (1, 43, 0, 'VictoryPoints'               , 'cepObjectInfo.VictoryPoints');
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (1, 44, 0, 'BorderObstacle'              , 'cepObjectInfo.BorderObstacle');
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (1, 45, 0, 'PlayerBorderObstacle'        , 'cepObjectInfo.PlayerBorderObstacle');
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (1, 46, 0, 'HealRateChange'              , 'cepObjectInfo.HealRateChange');
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (1, 47, 0, 'MountainImprovement'         , 'cepObjectInfo.MountainImprovement and Locale.ConvertTextKey(GameInfo.Improvements[cepObjectInfo.MountainImprovement].Description) or false');
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (1, 48, 0, 'FreePromotion'               , 'cepObjectInfo.FreePromotion and Locale.ConvertTextKey(GameInfo.UnitPromotions[cepObjectInfo.FreePromotion].Help) or false');
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (1, 49, 0, 'FreePromotionAllCombatUnits' , 'cepObjectInfo.FreePromotionAllCombatUnits and Locale.ConvertTextKey(GameInfo.UnitPromotions[cepObjectInfo.FreePromotionAllCombatUnits].Help) or false');

INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (1, 50, 0, 'TradeDealModifier'           , 'cepObjectInfo.TradeDealModifier');
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (1, 51, 0, 'GlobalGreatPeopleRateModifier'      , 'cepObjectInfo.GlobalGreatPeopleRateModifier');
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (1, 52, 1, 'UnmoddedHappiness'           , 'Game.GetDefaultBuildingStatText');
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (1, 53, 1, 'Happiness'                   , 'Game.GetDefaultBuildingStatText');
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (1, 54, 0, 'HappinessPerCity'            , 'cepObjectInfo.HappinessPerCity');
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (1, 55, 0, 'HappinessPerXPolicies'       , 'cepObjectInfo.HappinessPerXPolicies');
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (1, 56, 0, 'UnhappinessModifier'         , 'cepObjectInfo.UnhappinessModifier');
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (1, 57, 0, 'NoOccupiedUnhappiness'       , 'cepObjectInfo.NoOccupiedUnhappiness');
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (1, 58, 0, 'InstantHappiness'            , 'cepObjectInfo.InstantHappiness');
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (1, 59, 0, 'GoldenAgePoints'             , 'cepObjectInfo.GoldenAgePoints');
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (1, 60, 0, 'Experience'                  , 'cepObjectInfo.Experience');
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (1, 61, 0, 'ExperienceDomain'            , 'Game.HasValue({BuildingType=cepObjectInfo.Type}, GameInfo.Building_DomainFreeExperiences)');
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (1, 62, 0, 'ExperienceCombat'            , 'Game.HasValue({BuildingType=cepObjectInfo.Type}, GameInfo.Building_UnitCombatFreeExperiences)');
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (1, 63, 0, 'ExperiencePerTurn'           , 'cepObjectInfo.ExperiencePerTurn');
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (1, 64, 0, 'GlobalExperience'            , 'cepObjectInfo.GlobalExperience');
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (1, 65, 0, 'Defense'                     , 'cepObjectInfo.Defense / 100');
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (1, 66, 0, 'GlobalDefenseMod'            , 'cepObjectInfo.GlobalDefenseMod');
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (1, 67, 0, 'ExtraCityHitPoints'          , 'cepObjectInfo.ExtraCityHitPoints');
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (1, 68, 0, 'AirModifier'                 , 'cepObjectInfo.AirModifier');
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (1, 69, 0, 'NukeModifier'                , 'cepObjectInfo.NukeModifier');
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (1, 70, 0, 'YieldModInAllCities'         , 'Game.HasValue({BuildingType=cepObjectInfo.Type}, GameInfo.Building_GlobalYieldModifiers)');
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (1, 71, 0, 'YieldFromUsingGreatPeople'   , 'cepObjectInfo.GreatPersonExpendGold');
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (1, 72, 0, 'YieldModHurry'               , 'Game.HasValue({BuildingType=cepObjectInfo.Type}, GameInfo.Building_HurryModifiers)');
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (1, 73, 0, 'CityConnectionTradeRouteModifier'   , 'cepObjectInfo.CityConnectionTradeRouteModifier');
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (1, 74, 0, 'MedianTechPercentChange'     , 'cepObjectInfo.MedianTechPercentChange * 2');
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (1, 75, 0, 'InstantBorderRadius'         , 'cepObjectInfo.InstantBorderRadius');
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (1, 76, 0, 'InstantBorderPlots'          , 'Game.HasValue({BuildingType=cepObjectInfo.Type}, GameInfo.Building_PlotsYieldChanges)');
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (1, 77, 0, 'ReligiousPressureModifier'   , 'cepObjectInfo.ReligiousPressureModifier');

INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (1, 78, 0, 'NullifyInfluenceModifier'    , 'cepObjectInfo.NullifyInfluenceModifier');
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (1, 79, 0, 'LeagueCost'                  , 'cepObjectInfo.LeagueCost');
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (1, 80, 0, 'UnlockedByLeague'            , 'cepObjectInfo.UnlockedByLeague');
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (1, 81, 0, 'ExtraLeagueVotes'            , 'cepObjectInfo.ExtraLeagueVotes');
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (1, 82, 0, 'InstantMilitaryIncrease'     , 'cepObjectInfo.InstantMilitaryIncrease');
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (1, 83, 0, 'XBuiltTriggersIdeologyChoice'       , 'cepObjectInfo.XBuiltTriggersIdeologyChoice');
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (1, 84, 0, 'GreatScientistBeakerModifier'       , 'cepObjectInfo.GreatScientistBeakerModifier');

-- Abilities --

INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (2,  1, 0, 'SpecialistType'              , 'cepObjectInfo.SpecialistType');
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (2,  2, 0, 'GreatGeneralRateChange'      , 'cepObjectInfo.GreatGeneralRateChange');
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (2,  3, 0, 'GreatPeopleRateModifier'     , 'cepObjectInfo.GreatPeopleRateModifier');

-- Yields --
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (3,  1, 0, 'YieldPerPop'                 , 'Game.HasValue({BuildingType=cepObjectInfo.Type}, GameInfo.Building_YieldChangesPerPop)');
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (3,  2, 1, 'YieldInstant'                , 'Game.GetDefaultBuildingStatText');
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (3,  3, 1, 'YieldChange'                 , 'Game.GetDefaultBuildingStatText');
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (3,  4, 0, 'YieldFromPlots'              , 'Game.HasValue({BuildingType=cepObjectInfo.Type}, GameInfo.Building_PlotYieldChanges)');
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (3,  5, 0, 'YieldFromSea'                , 'Game.HasValue({BuildingType=cepObjectInfo.Type}, GameInfo.Building_SeaPlotYieldChanges)');
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (3,  6, 0, 'YieldFromLakes'              , 'Game.HasValue({BuildingType=cepObjectInfo.Type}, GameInfo.Building_LakePlotYieldChanges)');
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (3,  7, 0, 'YieldFromTerrain'            , 'Game.HasValue({BuildingType=cepObjectInfo.Type}, GameInfo.Building_TerrainYieldChanges)');
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (3,  8, 0, 'YieldFromRivers'             , 'Game.HasValue({BuildingType=cepObjectInfo.Type}, GameInfo.Building_RiverPlotYieldChanges)');
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (3,  9, 0, 'YieldFromFeatures'           , 'Game.HasValue({BuildingType=cepObjectInfo.Type}, GameInfo.Building_FeatureYieldChanges)');
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (3, 10, 0, 'YieldFromResources'          , 'Game.HasValue({BuildingType=cepObjectInfo.Type}, GameInfo.Building_ResourceYieldChanges)');
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (3, 11, 0, 'YieldFromSpecialists'        , 'Game.HasValue({BuildingType=cepObjectInfo.Type}, GameInfo.Building_SpecialistYieldChanges)');
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (3, 12, 0, 'YieldFromTech'               , 'Game.HasValue({BuildingType=cepObjectInfo.Type}, GameInfo.Building_TechEnhancedYieldChanges)');
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (3, 13, 0, 'YieldFromReligion'           , 'Game.HasValue({BuildingType=cepObjectInfo.Type}, GameInfo.Building_YieldChangesPerReligion)');
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (3, 14, 0, 'YieldFromBuildings'          , 'Game.HasValue({BuildingType=cepObjectInfo.Type}, GameInfo.Building_BuildingClassYieldChanges)');
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (3, 15, 0, 'TradeRouteLandGoldBonus'     , 'cepObjectInfo.TradeRouteLandGoldBonus / 100');
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (3, 16, 0, 'TradeRouteSeaGoldBonus'      , 'cepObjectInfo.TradeRouteSeaGoldBonus / 100');
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (3, 17, 1, 'YieldMod'                    , 'Game.GetDefaultBuildingStatText');
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (3, 18, 0, 'YieldModFromBuildings'       , 'Game.HasValue({BuildingType=cepObjectInfo.Type}, GameInfo.Building_BuildingClassYieldModifiers)');
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (3, 19, 0, 'YieldModMilitary'            , 'cepObjectInfo.MilitaryProductionModifier');
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (3, 20, 0, 'YieldModDomain'              , 'Game.HasValue({BuildingType=cepObjectInfo.Type}, GameInfo.Building_DomainProductionModifiers)');
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (3, 21, 0, 'YieldModCombat'              , 'Game.HasValue({BuildingType=cepObjectInfo.Type}, GameInfo.Building_UnitCombatProductionModifiers)');
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (3, 22, 0, 'YieldModBuilding'            , 'cepObjectInfo.BuildingProductionModifier');
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (3, 23, 0, 'YieldModWonder'              , 'cepObjectInfo.WonderProductionModifier');
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (3, 24, 0, 'YieldModSpace'               , 'cepObjectInfo.SpaceProductionModifier');
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (3, 25, 0, 'YieldModSurplus'             , 'Game.HasValue({BuildingType=cepObjectInfo.Type}, GameInfo.Building_YieldSurplusModifiers)');
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (3, 26, 0, 'YieldStorage'                , 'cepObjectInfo.FoodKept');
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (3, 27, 0, 'AllowsFoodTradeRoutes'       , 'cepObjectInfo.AllowsFoodTradeRoutes');
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (3, 28, 0, 'AllowsProductionTradeRoutes' , 'cepObjectInfo.AllowsProductionTradeRoutes');

INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (4,  1, 0, 'TradeRouteLandDistanceModifier'     , 'cepObjectInfo.TradeRouteLandDistanceModifier');
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (4,  2, 0, 'TradeRouteSeaDistanceModifier'      , 'cepObjectInfo.TradeRouteSeaDistanceModifier');
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (4,  3, 0, 'TradeRouteRecipientBonus'    , 'cepObjectInfo.TradeRouteRecipientBonus');
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (4,  4, 0, 'TradeRouteTargetBonus'       , 'cepObjectInfo.TradeRouteTargetBonus');
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (4,  5, 0, 'CityStateTradeRouteProductionModifier'       , 'cepObjectInfo.CityStateTradeRouteProductionModifier');
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (4,  6, 0, 'NumTradeRouteBonus'          , 'cepObjectInfo.NumTradeRouteBonus');
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (4,  7, 0, 'GreatWorkSlotType'           , 'cepObjectInfo.GreatWorkSlotType');
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (4,  8, 0, 'GreatWorksTourismModifier'   , 'cepObjectInfo.GreatWorksTourismModifier');
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (4,  9, 0, 'FreeGreatWork'               , 'cepObjectInfo.FreeGreatWork');
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (4,  10, 0, 'ExperiencePerGreatWork'      , 'Game.HasValue({BuildingType=cepObjectInfo.Type}, GameInfo.Building_DomainFreeExperiencePerGreatWork)');
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (4, 11, 0, 'TechEnhancedTourism'         , 'cepObjectInfo.TechEnhancedTourism');
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (4, 12, 0, 'LandmarksTourismPercent'     , 'cepObjectInfo.LandmarksTourismPercent');
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (4, 13, 0, 'ThemingBonusHelp'            , 'cepObjectInfo.ThemingBonusHelp');
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (4, 14, 1, 'Replaces'                    , 'Game.GetDefaultBuildingStatText');


-- Requirements --

INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (5,  1, 1, 'Cost'                        , 'Game.GetDefaultBuildingStatText');
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (5,  2, 1, 'NumCityCostMod'              , 'Game.GetDefaultBuildingStatText');
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (5,  3, 1, 'PopCostMod'                  , 'Game.GetDefaultBuildingStatText');
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (5,  4, 1, 'HurryCostModifier'           , 'Game.GetDefaultBuildingStatText');
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (5,  5, 1, 'GoldMaintenance'             , 'Game.GetDefaultBuildingStatText');
--INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (5,  6, 0, 'UnlockedByBelief'            , 'cepObjectInfo.UnlockedByBelief');

INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (5,  7, 0, 'NationalLimit'               , 'cepClassInfo.MaxPlayerInstances');
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (5,  8, 0, 'TeamLimit'                   , 'cepClassInfo.MaxTeamInstances');
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (5,  9, 0, 'WorldLimit'                  , 'cepClassInfo.MaxGlobalInstances');
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (5, 10, 0, 'NotFeature'                  , 'cepObjectInfo.NotFeature');
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (5, 11, 0, 'NearbyTerrainRequired'       , 'cepObjectInfo.NearbyTerrainRequired');
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (5, 12, 0, 'ProhibitedCityTerrain'       , 'cepObjectInfo.ProhibitedCityTerrain');
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (5, 12, 0, 'Water'                       , 'cepObjectInfo.Water');
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (5, 13, 0, 'River'                       , 'cepObjectInfo.River');
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (5, 14, 0, 'FreshWater'                  , 'cepObjectInfo.FreshWater and (cepObjectInfo.BuildingClass ~= "BUILDINGCLASS_GARDEN")');
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (5, 15, 0, 'Mountain'                    , 'cepObjectInfo.Mountain');
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (5, 16, 0, 'NearbyMountainRequired'      , 'cepObjectInfo.NearbyMountainRequired');
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (5, 17, 0, 'Hill'                        , 'cepObjectInfo.Hill');
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (5, 18, 0, 'Flat'                        , 'cepObjectInfo.Flat');
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (5, 19, 0, 'HolyCity'                    , 'cepObjectInfo.HolyCity');
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (5, 20, 0, 'RequiresTech'                , 'Game.HasValue({BuildingType=cepObjectInfo.Type}, GameInfo.Building_TechAndPrereqs)');
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (5, 21, 0, 'RequiresBuilding'            , 'Game.HasValue({BuildingType=cepObjectInfo.Type}, GameInfo.Building_ClassesNeededInCity) and not cepObjectInfo.OnlyAI');
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (5, 22, 0, 'RequiresBuildingInCities'    , 'Game.HasValue({BuildingType=cepObjectInfo.Type}, GameInfo.Building_PrereqBuildingClasses)');
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (5, 23, 0, 'RequiresBuildingInPercentCities'    , 'Game.HasValue({BuildingType=cepObjectInfo.Type}, GameInfo.Building_PrereqBuildingClassesPercentage)');
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (5, 24, 0, 'RequiresNearAll'             , 'Game.HasValue({BuildingType=cepObjectInfo.Type}, GameInfo.Building_LocalResourceAnds)');
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (5, 25, 0, 'RequiresNearAny'             , 'Game.HasValue({BuildingType=cepObjectInfo.Type}, GameInfo.Building_LocalResourceOrs)');
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (5, 26, 0, 'RequiresResourceConsumption' , 'Game.HasValue({BuildingType=cepObjectInfo.Type}, GameInfo.Building_ResourceQuantityRequirements)');

INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (5, 27, 0, 'ObsoleteTech'                , 'cepObjectInfo.ObsoleteTech and Locale.ConvertTextKey(GameInfo.Technologies[cepObjectInfo.ObsoleteTech].Description)');
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (5, 28, 1, 'AlreadyBuilt'                , 'Game.GetDefaultBuildingStatText');
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (5, 29, 0, 'MinAreaSize'                 , '(cepObjectInfo.MinAreaSize ~= -1) and cepObjectInfo.MinAreaSize');
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (5, 30, 0, 'CitiesPrereq'                , 'cepObjectInfo.CitiesPrereq');
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (5, 31, 0, 'LevelPrereq'                 , 'cepObjectInfo.LevelPrereq');
INSERT INTO BuildingStats(Section, Priority, Dynamic, Type, Value) VALUES (5, 32, 0, 'PolicyBranchType'            , 'cepObjectInfo.PolicyBranchType and Locale.ConvertTextKey(GameInfo.PolicyBranchTypes[cepObjectInfo.PolicyBranchType] and GameInfo.PolicyBranchTypes[cepObjectInfo.PolicyBranchType].Description or cepObjectInfo.PolicyBranchType)');

UPDATE LoadedFile SET Value=1 WHERE Type='TW_BuildingStats.sql';
