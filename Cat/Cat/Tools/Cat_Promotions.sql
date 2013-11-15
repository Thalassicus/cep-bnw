--

UPDATE UnitPromotions
SET Class = 'PROMOTION_CLASS_ATTRIBUTE_POSITIVE'
WHERE PediaType = 'PEDIA_ATTRIBUTES' AND LostWithUpgrade = 1;

UPDATE UnitPromotions
SET Class = 'PROMOTION_CLASS_ATTRIBUTE_NEGATIVE'
WHERE Type LIKE '%PENALTY%'
OR Type IN (
	'PROMOTION_MUST_SET_UP',
	'PROMOTION_ROUGH_TERRAIN_ENDS_TURN',
	'PROMOTION_FOLIAGE_IMPASSABLE',
	'PROMOTION_NO_CAPTURE',
	'PROMOTION_ONLY_DEFENSIVE',
	'PROMOTION_NO_DEFENSIVE_BONUSES'
);


UPDATE UnitPromotions
SET LostWithUpgrade = 1
WHERE Class = 'PROMOTION_CLASS_ATTRIBUTE_NEGATIVE';

UPDATE UnitPromotions
SET PediaType = 'PEDIA_SHARED'
WHERE Type LIKE '%PROMOTION_BOMBARDMENT%';

UPDATE UnitPromotions
SET SimpleHelpText = 1
WHERE PediaType = 'PEDIA_ATTRIBUTES' AND NOT Type IN (
	'PROMOTION_AI_HANDICAP'				,
	'PROMOTION_AIR_SWEEP'				,
	'PROMOTION_AIR_RECON'				,
	'PROMOTION_ASTRONOMY'				,
	'PROMOTION_CAMARADERIE'				,
	'PROMOTION_DEFEND_NEAR_CAPITAL'		
);

INSERT INTO UnitPromotions_UnitCombats	(PromotionType, UnitCombatType)
SELECT DISTINCT							PromotionType, 'UNITCOMBAT_MOUNTED_ARCHER'
FROM UnitPromotions_UnitCombats WHERE	UnitCombatType = 'UNITCOMBAT_ARCHER';

INSERT INTO UnitPromotions_UnitCombats	(PromotionType, UnitCombatType)
SELECT DISTINCT							PromotionType, 'UNITCOMBAT_SUBMARINE'
FROM UnitPromotions_UnitCombats WHERE	UnitCombatType = 'UNITCOMBAT_NAVALRANGED';

DELETE FROM UnitPromotions_UnitCombats
WHERE UnitCombatType = 'UNITCOMBAT_SUBMARINE' AND PromotionType LIKE 'PROMOTION_BOMBARDMENT_%';

DELETE FROM UnitPromotions_UnitCombats
WHERE UnitCombatType = 'UNITCOMBAT_SUBMARINE' AND PromotionType IN (
	'PROMOTION_INDIRECT_FIRE',
	'PROMOTION_SUPPLY'
);

/*

UPDATE UnitPromotions
SET IsOther = 1;

UPDATE UnitPromotions
SET IsFirst = 1, IsOther = 0
WHERE (RangeChange						<> 0
);

UPDATE UnitPromotions
SET IsAttack = 1, IsOther = 0
WHERE (AdjacentMod						<> 0
	OR AirSweepCombatModifier			<> 0
	OR AttackFortifiedMod				<> 0
	OR AttackMod						<> 0
	OR AttackWoundedMod					<> 0
	OR CityAttack						<> 0
	OR CityAttackOnly					<> 0
	OR CombatPercent					<> 0
	OR ExtraAttacks						<> 0
	OR FlankAttackModifier				<> 0
	OR FriendlyLandsAttackModifier		<> 0
	OR FriendlyLandsModifier			<> 0
	OR HillsAttack						<> 0
	OR OnlyDefensive					<> 0
	OR OpenAttack						<> 0
	OR OpenRangedAttackMod				<> 0
	OR OutsideFriendlyLandsModifier		<> 0
	OR RangeAttackIgnoreLOS				<> 0
	OR RangedAttackModifier				<> 0
	OR RangedSupportFire				<> 0
	OR River							<> 0
	OR RoughAttack						<> 0
	OR RoughRangedAttackMod				<> 0
);

UPDATE UnitPromotions
SET IsDefense = 1, IsOther = 0
WHERE (AdjacentMod						<> 0
	OR CityDefense						<> 0
	OR CombatPercent					<> 0
	OR DefenseMod						<> 0
	OR EmbarkDefenseModifier			<> 0
	OR HillsDefense						<> 0
	OR NoDefensiveBonus					<> 0
	OR OpenDefense						<> 0
	OR OutsideFriendlyLandsModifier		<> 0
	OR RangedDefenseMod					<> 0
	OR RoughDefense						<> 0
);

UPDATE UnitPromotions
SET IsRanged = 1, IsOther = 0
WHERE (AdjacentMod						<> 0
	OR AirSweepCombatModifier			<> 0
	OR AttackFortifiedMod				<> 0
	OR AttackMod						<> 0
	OR AttackWoundedMod					<> 0
	OR CityAttack						<> 0
	OR CityAttackOnly					<> 0
	OR CityDefense						<> 0
	OR CombatPercent					<> 0
	OR DefenseMod						<> 0
	OR ExtraAttacks						<> 0
	OR FlankAttackModifier				<> 0
	OR FriendlyLandsAttackModifier		<> 0
	OR FriendlyLandsModifier			<> 0
	OR HillsAttack						<> 0
	OR HillsDefense						<> 0
	OR NoDefensiveBonus					<> 0
	OR OpenAttack						<> 0
	OR OpenDefense						<> 0
	OR OpenRangedAttackMod				<> 0
	OR OutsideFriendlyLandsModifier		<> 0
	OR RangeAttackIgnoreLOS				<> 0
	OR RangedAttackModifier				<> 0
	OR RangedDefenseMod					<> 0
	OR RangedSupportFire				<> 0
	OR RoughAttack						<> 0
	OR RoughDefense						<> 0
	OR RoughRangedAttackMod				<> 0
);

UPDATE UnitPromotions
SET IsMelee = 1, IsOther = 0
WHERE (AttackFortifiedMod				<> 0
	OR AttackMod						<> 0
	OR AttackWoundedMod					<> 0
	OR CityAttack						<> 0
	OR CityAttackOnly					<> 0
	OR CombatPercent					<> 0
	OR DefenseMod						<> 0
	OR EmbarkDefenseModifier			<> 0
	OR ExtraAttacks						<> 0
	OR FlankAttackModifier				<> 0
	OR FriendlyLandsAttackModifier		<> 0
	OR FriendlyLandsModifier			<> 0
	OR HillsAttack						<> 0
	OR HillsDefense						<> 0
	OR NoDefensiveBonus					<> 0
	OR OpenAttack						<> 0
	OR OpenDefense						<> 0
	OR OutsideFriendlyLandsModifier		<> 0
	OR RangedDefenseMod					<> 0
	OR River							<> 0
	OR RoughAttack						<> 0
	OR RoughDefense						<> 0
);

UPDATE UnitPromotions
SET IsHeal = 1, IsOther = 0
WHERE (AlwaysHeal						<> 0
	OR EnemyHealChange					<> 0
	OR NeutralHealChange				<> 0
	OR FriendlyHealChange				<> 0
	OR AdjacentTileHealChange			<> 0
	OR InstaHeal						<> 0
	OR HealOutsideFriendly				<> 0
	OR HPHealedIfDestroyEnemy			<> 0
	OR HealIfDestroyExcludesBarbarians	<> 0
	OR HealOnPillage					<> 0
	OR SameTileHealChange				<> 0
);

UPDATE UnitPromotions
SET IsMove = 1, IsOther = 0
WHERE (Amphib							<> 0
	OR AllowsEmbarkation				<> 0
	OR DropRange						<> 0
	OR EmbarkedAllWater					<> 0
	OR EnemyRoute						<> 0
	OR ExtraNavalMovement				<> 0
	OR ExtraWithdrawal					<> 0
	OR FlatMovementCost					<> 0
	OR FreePillageMoves					<> 0
	OR GreatGeneralReceivesMovement		<> 0
	OR HillsDoubleMove					<> 0
	OR HoveringUnit						<> 0
	OR IgnoreTerrainCost				<> 0
	OR MoveDiscountChange				<> 0
	OR MovesChange						<> 0
	OR MustSetUpToRangedAttack			<> 0
	OR RivalTerritory					<> 0
	OR RoughTerrainEndsTurn				<> 0
);

UPDATE UnitPromotions SET IsAttack = 1, IsRanged = 1, IsMelee = 1, IsOther = 0
WHERE (Type IN (SELECT PromotionType FROM UnitPromotions_Terrains			WHERE Attack <> 0)
	OR Type IN (SELECT PromotionType FROM UnitPromotions_Features			WHERE Attack <> 0)
	OR Type IN (SELECT PromotionType FROM UnitPromotions_UnitClasses		WHERE Attack <> 0)
	OR Type IN (SELECT PromotionType FROM UnitPromotions_UnitClasses		WHERE Modifier <> 0)
	OR Type IN (SELECT PromotionType FROM UnitPromotions_Domains			WHERE Modifier <> 0)
	OR Type IN (SELECT PromotionType FROM UnitPromotions_UnitCombatMods		WHERE Modifier <> 0)
);

UPDATE UnitPromotions SET IsDefense = 1, IsRanged = 1, IsMelee = 1, IsOther = 0
WHERE (Type IN (SELECT PromotionType FROM UnitPromotions_Terrains			WHERE Defense <> 0)
	OR Type IN (SELECT PromotionType FROM UnitPromotions_Features			WHERE Defense <> 0)
	OR Type IN (SELECT PromotionType FROM UnitPromotions_UnitClasses		WHERE Defense <> 0)
	OR Type IN (SELECT PromotionType FROM UnitPromotions_UnitClasses		WHERE Modifier <> 0)
	OR Type IN (SELECT PromotionType FROM UnitPromotions_Domains			WHERE Modifier <> 0)
	OR Type IN (SELECT PromotionType FROM UnitPromotions_UnitCombatMods		WHERE Modifier <> 0)
);

UPDATE UnitPromotions SET IsMove = 1, IsOther = 0
WHERE (Type IN (SELECT PromotionType FROM UnitPromotions_Terrains			WHERE DoubleMove <> 0)
	OR Type IN (SELECT PromotionType FROM UnitPromotions_Terrains			WHERE Impassable <> 0)
	OR Type IN (SELECT PromotionType FROM UnitPromotions_Terrains			WHERE PassableTech <> 0)
	OR Type IN (SELECT PromotionType FROM UnitPromotions_Features			WHERE DoubleMove <> 0)
	OR Type IN (SELECT PromotionType FROM UnitPromotions_Features			WHERE Impassable <> 0)
	OR Type IN (SELECT PromotionType FROM UnitPromotions_Features			WHERE PassableTech <> 0)
);
*/

UPDATE UnitPromotions
SET Help = Description || '_HELP'
WHERE Type IN (
	'PROMOTION_IGNORE_TERRAIN_COST'			,
	'PROMOTION_FLAT_MOVEMENT_COST'			,
	'PROMOTION_CAN_MOVE_AFTER_ATTACKING'	,
	'PROMOTION_CAN_MOVE_IMPASSABLE'			,
	'PROMOTION_NO_CAPTURE'					,
	'PROMOTION_ONLY_DEFENSIVE'				,
	'PROMOTION_NO_DEFENSIVE_BONUSES'		,
	'PROMOTION_PARADROP'					,
	'PROMOTION_MUST_SET_UP'					,
	'PROMOTION_INTERCEPTION_I'				,
	'PROMOTION_INTERCEPTION_II'				,
	'PROMOTION_INTERCEPTION_III'			,
	'PROMOTION_INTERCEPTION_IV'				,
	'PROMOTION_ANTI_AIR'					,
	'PROMOTION_ANTI_AIR_II'					,
	'PROMOTION_INDIRECT_FIRE'				,
	'PROMOTION_OCEAN_IMPASSABLE'			,
	'PROMOTION_RIVAL_TERRITORY'				,
	'PROMOTION_CARGO_I'						,
	'PROMOTION_CARGO_II'					,
	'PROMOTION_CARGO_III'					,
	'PROMOTION_CARGO_IV'					,
	'PROMOTION_ANTI_TANK'					,
	'PROMOTION_EVASION_I'					,
	'PROMOTION_EVASION_II'					
);


--
-- Done
--
UPDATE LoadedFile SET Value=1 WHERE Type='Cat_Promotions.sql';