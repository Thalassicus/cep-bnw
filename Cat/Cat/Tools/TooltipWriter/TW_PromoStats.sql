-- This TW_PromoStats.sql data created by:
-- BuildingStats tab of Cat_Details.xls spreadsheet (in mod folder).

-- Range --
INSERT INTO PromotionStats(Section, Priority, Type, Value) VALUES (1,  1, 'RangedSupportFire'                  , 'cepObjectInfo.RangedSupportFire');
INSERT INTO PromotionStats(Section, Priority, Type, Value) VALUES (1,  2, 'RangeChange'                        , 'cepObjectInfo.RangeChange');

-- RangedStrength --
INSERT INTO PromotionStats(Section, Priority, Attack,  Type, Value) VALUES (2,  1, 1, 'RangeAttackIgnoreLOS'               , 'cepObjectInfo.RangeAttackIgnoreLOS');
INSERT INTO PromotionStats(Section, Priority, Attack,  Opposite, Type, Value) VALUES (2,  2, 1, 'cepObjectInfo.RangedDefenseMod',      'RangedAttackModifier'               , 'cepObjectInfo.RangedAttackModifier');
INSERT INTO PromotionStats(Section, Priority, Defense, Opposite, Type, Value) VALUES (2,  3, 1, 'cepObjectInfo.RangedAttackModifier',  'RangedDefenseMod'                   , 'cepObjectInfo.RangedDefenseMod');
INSERT INTO PromotionStats(Section, Priority, Attack,  Type, Value) VALUES (2,  4, 1, 'OpenRangedAttackMod'                , 'cepObjectInfo.OpenRangedAttackMod');
INSERT INTO PromotionStats(Section, Priority, Attack,  Type, Value) VALUES (2,  5, 1, 'RoughRangedAttackMod'               , 'cepObjectInfo.RoughRangedAttackMod');

-- Strength --
INSERT INTO PromotionStats(Section, Priority, Dynamic, Type, Value) VALUES (3,  1, 1, 'CombatPercent'                      , 'Game.GetDefaultPromotionStatText');
INSERT INTO PromotionStats(Section, Priority, Dynamic, Attack,  Opposite, Type, Value) VALUES (3,  2, 1, 1, 'cepObjectInfo.CityDefense',           'CityAttack'                         , 'Game.GetDefaultPromotionStatText');
INSERT INTO PromotionStats(Section, Priority, Dynamic, Defense, Opposite, Type, Value) VALUES (3,  3, 1, 1, 'cepObjectInfo.CityAttack',            'CityDefense'                        , 'Game.GetDefaultPromotionStatText');
INSERT INTO PromotionStats(Section, Priority, Dynamic, Attack,  Opposite, Type, Value) VALUES (3,  4, 1, 1, 'cepObjectInfo.HillsDefense',          'HillsAttack'                        , 'Game.GetDefaultPromotionStatText');
INSERT INTO PromotionStats(Section, Priority, Dynamic, Defense, Opposite, Type, Value) VALUES (3,  5, 1, 1, 'cepObjectInfo.HillsAttack',           'HillsDefense'                       , 'Game.GetDefaultPromotionStatText');
INSERT INTO PromotionStats(Section, Priority, Dynamic, Attack,  Opposite, Type, Value) VALUES (3,  6, 1, 1, 'cepObjectInfo.OpenDefense',           'OpenAttack'                         , 'Game.GetDefaultPromotionStatText');
INSERT INTO PromotionStats(Section, Priority, Dynamic, Defense, Opposite, Type, Value) VALUES (3,  7, 1, 1, 'cepObjectInfo.OpenAttack',            'OpenDefense'                        , 'Game.GetDefaultPromotionStatText');
INSERT INTO PromotionStats(Section, Priority, Dynamic, Attack,  Opposite, Type, Value) VALUES (3,  8, 1, 1, 'cepObjectInfo.RoughDefense',          'RoughAttack'                        , 'Game.GetDefaultPromotionStatText');
INSERT INTO PromotionStats(Section, Priority, Dynamic, Defense, Opposite, Type, Value) VALUES (3,  9, 1, 1, 'cepObjectInfo.RoughAttack',           'RoughDefense'                       , 'Game.GetDefaultPromotionStatText');
INSERT INTO PromotionStats(Section, Priority, Dynamic, Attack,  Type, Value) VALUES (3, 10, 1, 1, 'AttackFortifiedMod'                 , 'Game.GetDefaultPromotionStatText');
INSERT INTO PromotionStats(Section, Priority, Dynamic, Attack,  Type, Value) VALUES (3, 11, 1, 1, 'AttackWoundedMod'                   , 'Game.GetDefaultPromotionStatText');
INSERT INTO PromotionStats(Section, Priority, Dynamic, Type, Value) VALUES (3, 12, 1, 'AdjacentMod'                        , 'Game.GetDefaultPromotionStatText');
INSERT INTO PromotionStats(Section, Priority, Dynamic, Attack,  Opposite, Type, Value) VALUES (3, 13, 1, 1, 'cepObjectInfo.DefenseMod',            'AttackMod'                          , 'Game.GetDefaultPromotionStatText');
INSERT INTO PromotionStats(Section, Priority, Dynamic, Defense, Opposite, Type, Value) VALUES (3, 14, 1, 1, 'cepObjectInfo.AttackMod',             'DefenseMod'                         , 'Game.GetDefaultPromotionStatText');
INSERT INTO PromotionStats(Section, Priority, Dynamic, Type, Value) VALUES (3, 15, 1, 'FriendlyLandsModifier'              , 'Game.GetDefaultPromotionStatText');
INSERT INTO PromotionStats(Section, Priority, Dynamic, Attack,  Type, Value) VALUES (3, 16, 1, 1, 'FriendlyLandsAttackModifier'        , 'Game.GetDefaultPromotionStatText');
INSERT INTO PromotionStats(Section, Priority, Dynamic, Type, Value) VALUES (3, 17, 1, 'OutsideFriendlyLandsModifier'       , 'Game.GetDefaultPromotionStatText');

-- Moves --
INSERT INTO PromotionStats(Section, Priority, Type, Value) VALUES (4,  1, 'EnemyRoute'                         , 'cepObjectInfo.EnemyRoute');
INSERT INTO PromotionStats(Section, Priority, Type, Value) VALUES (4,  2, 'RivalTerritory'                     , 'cepObjectInfo.RivalTerritory');
INSERT INTO PromotionStats(Section, Priority, Type, Value) VALUES (4,  3, 'CanMoveAfterAttacking'              , 'cepObjectInfo.CanMoveAfterAttacking');
INSERT INTO PromotionStats(Section, Priority, Type, Value) VALUES (4,  4, 'HillsDoubleMove'                    , 'cepObjectInfo.HillsDoubleMove');
INSERT INTO PromotionStats(Section, Priority, Type, Value) VALUES (4,  5, 'IgnoreTerrainCost'                  , 'cepObjectInfo.IgnoreTerrainCost');
INSERT INTO PromotionStats(Section, Priority, Type, Value) VALUES (4,  6, 'HoveringUnit'                       , 'cepObjectInfo.HoveringUnit');
INSERT INTO PromotionStats(Section, Priority, Type, Value) VALUES (4,  7, 'FlatMovementCost'                   , 'cepObjectInfo.FlatMovementCost');
INSERT INTO PromotionStats(Section, Priority, Type, Value) VALUES (4,  8, 'CanMoveImpassable'                  , 'cepObjectInfo.CanMoveImpassable');
INSERT INTO PromotionStats(Section, Priority, Type, Value) VALUES (4,  9, 'CanMoveAllTerrain'                  , 'cepObjectInfo.CanMoveAllTerrain');
INSERT INTO PromotionStats(Section, Priority, Type, Value) VALUES (4, 10, 'FreePillageMoves'                   , 'cepObjectInfo.FreePillageMoves');
INSERT INTO PromotionStats(Section, Priority, Type, Value) VALUES (4, 11, 'ExtraNavalMovement'                 , 'cepObjectInfo.ExtraNavalMovement');
INSERT INTO PromotionStats(Section, Priority, Type, Value) VALUES (4, 12, 'MovesChange'                        , 'cepObjectInfo.MovesChange');
INSERT INTO PromotionStats(Section, Priority, Type, Value) VALUES (4, 13, 'MoveDiscountChange'                 , 'cepObjectInfo.MoveDiscountChange');
INSERT INTO PromotionStats(Section, Priority, Type, Value) VALUES (4, 14, 'DropRange'                          , 'cepObjectInfo.DropRange');
INSERT INTO PromotionStats(Section, Priority, Type, Value) VALUES (4, 15, 'ExtraWithdrawal'                    , 'cepObjectInfo.ExtraWithdrawal');

-- Heal --
INSERT INTO PromotionStats(Section, Priority, Type, Value) VALUES (5,  1, 'InstaHeal'                          , 'cepObjectInfo.InstaHeal');
INSERT INTO PromotionStats(Section, Priority, Type, Value) VALUES (5,  2, 'AlwaysHeal'                         , 'cepObjectInfo.AlwaysHeal');
INSERT INTO PromotionStats(Section, Priority, Type, Value) VALUES (5,  3, 'HealOutsideFriendly'                , 'cepObjectInfo.HealOutsideFriendly');
INSERT INTO PromotionStats(Section, Priority, Type, Value) VALUES (5,  4, 'EnemyHealChange'                    , 'cepObjectInfo.EnemyHealChange');
INSERT INTO PromotionStats(Section, Priority, Type, Value) VALUES (5,  5, 'NeutralHealChange'                  , 'cepObjectInfo.NeutralHealChange');
INSERT INTO PromotionStats(Section, Priority, Type, Value) VALUES (5,  6, 'FriendlyHealChange'                 , 'cepObjectInfo.FriendlyHealChange');
INSERT INTO PromotionStats(Section, Priority, Type, Value) VALUES (5,  7, 'SameTileHealChange'                 , 'cepObjectInfo.SameTileHealChange');
INSERT INTO PromotionStats(Section, Priority, Type, Value) VALUES (5,  8, 'AdjacentTileHealChange'             , 'cepObjectInfo.AdjacentTileHealChange');
INSERT INTO PromotionStats(Section, Priority, Type, Value) VALUES (5,  9, 'HPHealedIfDestroyEnemy'             , 'cepObjectInfo.HPHealedIfDestroyEnemy');
INSERT INTO PromotionStats(Section, Priority, Type, Value) VALUES (5, 10, 'HealIfDestroyExcludesBarbarians'    , 'cepObjectInfo.HealIfDestroyExcludesBarbarians');

-- Sight --
INSERT INTO PromotionStats(Section, Priority, Type, Value) VALUES (6,  1, 'Recon'                              , 'cepObjectInfo.Recon');
INSERT INTO PromotionStats(Section, Priority, Type, Value) VALUES (6,  2, 'VisibilityChange'                   , 'cepObjectInfo.VisibilityChange');
INSERT INTO PromotionStats(Section, Priority, Type, Value) VALUES (6,  3, 'EmbarkExtraVisibility'              , 'cepObjectInfo.EmbarkExtraVisibility');
INSERT INTO PromotionStats(Section, Priority, Type, Value) VALUES (6,  4, 'Invisible'                          , 'cepObjectInfo.Invisible');
INSERT INTO PromotionStats(Section, Priority, Type, Value) VALUES (6,  5, 'SeeInvisible'                       , 'cepObjectInfo.SeeInvisible');

-- Air --
INSERT INTO PromotionStats(Section, Priority, Type, Value) VALUES (7,  1, 'AirSweepCapable'                    , 'cepObjectInfo.AirSweepCapable');
INSERT INTO PromotionStats(Section, Priority, Type, Value) VALUES (7,  2, 'InterceptionCombatModifier'         , 'cepObjectInfo.InterceptionCombatModifier');
INSERT INTO PromotionStats(Section, Priority, Type, Value) VALUES (7,  3, 'InterceptionDefenseDamageModifier'  , 'cepObjectInfo.InterceptionDefenseDamageModifier');
INSERT INTO PromotionStats(Section, Priority, Type, Value) VALUES (7,  4, 'AirSweepCombatModifier'             , 'cepObjectInfo.AirSweepCombatModifier');
INSERT INTO PromotionStats(Section, Priority, Type, Value) VALUES (7,  5, 'InterceptChanceChange'              , 'cepObjectInfo.InterceptChanceChange');
INSERT INTO PromotionStats(Section, Priority, Type, Value) VALUES (7,  6, 'NumInterceptionChange'              , 'cepObjectInfo.NumInterceptionChange');
INSERT INTO PromotionStats(Section, Priority, Type, Value) VALUES (7,  7, 'EvasionChange'                      , 'cepObjectInfo.EvasionChange');
INSERT INTO PromotionStats(Section, Priority, Type, Value) VALUES (7,  8, 'CargoChange'                        , 'cepObjectInfo.CargoChange');

-- Naval --
INSERT INTO PromotionStats(Section, Priority, Type, Value) VALUES (8,  1, 'Amphib'                             , 'cepObjectInfo.Amphib');
INSERT INTO PromotionStats(Section, Priority, Type, Value) VALUES (8,  2, 'River'                              , 'cepObjectInfo.River');
INSERT INTO PromotionStats(Section, Priority, Type, Value) VALUES (8,  3, 'AllowsEmbarkation'                  , 'cepObjectInfo.AllowsEmbarkation');
INSERT INTO PromotionStats(Section, Priority, Type, Value) VALUES (8,  4, 'EmbarkedAllWater'                   , 'cepObjectInfo.EmbarkedAllWater');

-- Gold --
INSERT INTO PromotionStats(Section, Priority, Type, Value) VALUES (9,  1, 'UpgradeDiscount'                    , 'cepObjectInfo.UpgradeDiscount');

-- Great_General --
INSERT INTO PromotionStats(Section, Priority, Type, Value) VALUES (10,  1, 'GreatAdmiral'                       , 'cepObjectInfo.GreatAdmiral');
INSERT INTO PromotionStats(Section, Priority, Type, Value) VALUES (10,  2, 'GreatGeneral'                       , 'cepObjectInfo.GreatGeneral');
INSERT INTO PromotionStats(Section, Priority, Type, Value) VALUES (10,  3, 'GreatGeneralModifier'               , 'cepObjectInfo.GreatGeneralModifier');

-- Res_Uranium --
INSERT INTO PromotionStats(Section, Priority, Type, Value) VALUES (11,  1, 'NukeImmune'                         , 'cepObjectInfo.NukeImmune');

-- War --
INSERT INTO PromotionStats(Section, Priority, Type, Value) VALUES (12,  1, 'Blitz'                              , 'cepObjectInfo.Blitz');
INSERT INTO PromotionStats(Section, Priority, Type, Value) VALUES (12,  2, 'ExperiencePercent'                  , 'cepObjectInfo.ExperiencePercent');
INSERT INTO PromotionStats(Section, Priority, Type, Value) VALUES (12,  3, 'ExtraAttacks'                       , 'cepObjectInfo.ExtraAttacks');

-- Negative --
INSERT INTO PromotionStats(Section, Priority, Type, Value) VALUES (13,  1, 'MustSetUpToRangedAttack'            , 'cepObjectInfo.MustSetUpToRangedAttack');
INSERT INTO PromotionStats(Section, Priority, Type, Value) VALUES (13,  2, 'RoughTerrainEndsTurn'               , 'cepObjectInfo.RoughTerrainEndsTurn');
INSERT INTO PromotionStats(Section, Priority, Type, Value) VALUES (13,  3, 'NoCapture'                          , 'cepObjectInfo.NoCapture');
INSERT INTO PromotionStats(Section, Priority, Type, Value) VALUES (13,  4, 'NoDefensiveBonus'                   , 'cepObjectInfo.NoDefensiveBonus');
INSERT INTO PromotionStats(Section, Priority, Type, Value) VALUES (13,  5, 'NoRevealMap'                        , 'cepObjectInfo.NoRevealMap');
INSERT INTO PromotionStats(Section, Priority, Type, Value) VALUES (13,  6, 'EnemyDamageChance'                  , 'cepObjectInfo.EnemyDamageChance');
INSERT INTO PromotionStats(Section, Priority, Type, Value) VALUES (13,  7, 'NeutralDamageChance'                , 'cepObjectInfo.NeutralDamageChance');

-- Other --
INSERT INTO PromotionStats(Section, Priority, Type, Value) VALUES (14,  1, 'Leader'                             , 'cepObjectInfo.Leader');
INSERT INTO PromotionStats(Section, Priority, Type, Value) VALUES (14,  2, 'HiddenNationality'                  , 'cepObjectInfo.HiddenNationality');

UPDATE LoadedFile SET Value=1 WHERE Type='TW_PromoStats.sql';
