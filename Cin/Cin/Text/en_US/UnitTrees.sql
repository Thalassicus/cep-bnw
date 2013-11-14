--· EN_US/UnitTrees.sql
/*  Promotion Trees */
INSERT INTO Civup_Language_EN_US (DateModified, Tag, Text, Gender, Plurality) VALUES (date('2013-01-18'), 'TXT_KEY_PROMO_DIPLO_CORNER_HOOK', 'Promotion Tree', '', '');
INSERT INTO Civup_Language_EN_US (DateModified, Tag, Text, Gender, Plurality) VALUES (date('2013-01-18'), 'TXT_KEY_PROMO_DIPLO_CORNER_HOOK_TT', 'Display the Promotion Tree to easily see which promotions are available for a combat class (recon, naval, melee, siege, etc)', '', '');
INSERT INTO Civup_Language_EN_US (DateModified, Tag, Text, Gender, Plurality) VALUES (date('2013-01-18'), 'TXT_KEY_PROMO_OPEN_TREE_FOR_UNIT_TT', 'Display the Promotion Tree to easily see which promotions this unit has and are available', '', '');
INSERT INTO Civup_Language_EN_US (DateModified, Tag, Text, Gender, Plurality) VALUES (date('2013-01-18'), 'TXT_KEY_PROMO_SIZE', 'Small', '', '');
INSERT INTO Civup_Language_EN_US (DateModified, Tag, Text, Gender, Plurality) VALUES (date('2013-01-18'), 'TXT_KEY_PROMO_EARNT', 'Earned', '', '');
INSERT INTO Civup_Language_EN_US (DateModified, Tag, Text, Gender, Plurality) VALUES (date('2013-01-18'), 'TXT_KEY_PROMO_EARNT_TT', 'Promotions already earned by the unit (excludes those from special abilities and wonders)', '', '');
INSERT INTO Civup_Language_EN_US (DateModified, Tag, Text, Gender, Plurality) VALUES (date('2013-01-18'), 'TXT_KEY_PROMO_AVAILABLE', 'Available', '', '');
INSERT INTO Civup_Language_EN_US (DateModified, Tag, Text, Gender, Plurality) VALUES (date('2013-01-18'), 'TXT_KEY_PROMO_AVAILABLE_TT', 'Promotions which may be chosen for the unit', '', '');
INSERT INTO Civup_Language_EN_US (DateModified, Tag, Text, Gender, Plurality) VALUES (date('2013-01-18'), 'TXT_KEY_PROMO_NOT_AVAILABLE', 'Not Yet Available', '', '');
INSERT INTO Civup_Language_EN_US (DateModified, Tag, Text, Gender, Plurality) VALUES (date('2013-01-18'), 'TXT_KEY_PROMO_NOT_AVAILABLE_TT', 'Promotions which are not yet available to the unit', '', '');
INSERT INTO Civup_Language_EN_US (DateModified, Tag, Text, Gender, Plurality) VALUES (date('2013-01-18'), 'TXT_KEY_PROMO_GROUP_UNIT', 'Unit', '', '');
INSERT INTO Civup_Language_EN_US (DateModified, Tag, Text, Gender, Plurality) VALUES (date('2013-01-18'), 'TXT_KEY_PROMO_GROUP_CLASS', 'Combat Class', '', '');
INSERT INTO Civup_Language_EN_US (DateModified, Tag, Text, Gender, Plurality) VALUES (date('2013-01-18'), 'TXT_KEY_PROMO_GROUP_ALL', 'Promotions', '', '');
INSERT INTO Civup_Language_EN_US (DateModified, Tag, Text, Gender, Plurality) VALUES (date('2013-01-18'), 'TXT_KEY_PROMO_GROUP_ALL_TT', 'Promotions that enhance combat skills (bonuses are cumulative)', '', '');
INSERT INTO Civup_Language_EN_US (DateModified, Tag, Text, Gender, Plurality) VALUES (date('2013-01-18'), 'TXT_KEY_PROMO_GROUP_BASE', 'Basic Promotions', '', '');
INSERT INTO Civup_Language_EN_US (DateModified, Tag, Text, Gender, Plurality) VALUES (date('2013-01-18'), 'TXT_KEY_PROMO_GROUP_BASE_TT', 'Promotions that enhance basic combat skills (bonuses are cumulative)', '', '');
INSERT INTO Civup_Language_EN_US (DateModified, Tag, Text, Gender, Plurality) VALUES (date('2013-01-18'), 'TXT_KEY_PROMO_GROUP_DEPENDANT', 'Advanced Promotions', '', '');
INSERT INTO Civup_Language_EN_US (DateModified, Tag, Text, Gender, Plurality) VALUES (date('2013-01-18'), 'TXT_KEY_PROMO_GROUP_DEPENDANT_TT', 'Promotions that provide additional skills', '', '');
/*  Upgrade Trees */
INSERT INTO Civup_Language_EN_US (DateModified, Tag, Text, Gender, Plurality) VALUES (date('2013-01-18'), 'TXT_KEY_UPGRADE_DIPLO_CORNER_HOOK', 'Upgrade Tree', '', '');
INSERT INTO Civup_Language_EN_US (DateModified, Tag, Text, Gender, Plurality) VALUES (date('2013-01-18'), 'TXT_KEY_UPGRADE_DIPLO_CORNER_HOOK_TT', 'Display the Upgrade Tree to easily see which upgrades are available for a combat class (recon, naval, gun, siege, etc)', '', '');
INSERT INTO Civup_Language_EN_US (DateModified, Tag, Text, Gender, Plurality) VALUES (date('2013-01-18'), 'TXT_KEY_UPGRADE_OPEN_TREE_FOR_UNIT_TT', 'Display the Upgrade Tree to easily see the upgrade path for this unit', '', '');
INSERT INTO Civup_Language_EN_US (DateModified, Tag, Text, Gender, Plurality) VALUES (date('2013-01-18'), 'TXT_KEY_UPGRADE_SIZE', 'Small', '', '');
INSERT INTO Civup_Language_EN_US (DateModified, Tag, Text, Gender, Plurality) VALUES (date('2013-01-18'), 'TXT_KEY_UPGRADE_GROUP_UNIT', 'Unit', '', '');
INSERT INTO Civup_Language_EN_US (DateModified, Tag, Text, Gender, Plurality) VALUES (date('2013-01-18'), 'TXT_KEY_UPGRADE_GROUP_CLASS', 'Combat Class', '', '');
INSERT INTO Civup_Language_EN_US (DateModified, Tag, Text, Gender, Plurality) VALUES (date('2013-01-18'), 'TXT_KEY_UPGRADE_UNIT_MOVES', 'Moves: {1_Num}', '', '');
INSERT INTO Civup_Language_EN_US (DateModified, Tag, Text, Gender, Plurality) VALUES (date('2013-01-18'), 'TXT_KEY_UPGRADE_UNIT_COMBAT', 'Strength: {1_Num}', '', '');
INSERT INTO Civup_Language_EN_US (DateModified, Tag, Text, Gender, Plurality) VALUES (date('2013-01-18'), 'TXT_KEY_UPGRADE_UNIT_RANGED', 'Ranged Strength: {1_Num} at {2_Num}', '', '');
INSERT INTO Civup_Language_EN_US (DateModified, Tag, Text, Gender, Plurality) VALUES (date('2013-01-18'), 'TXT_KEY_UPGRADE_UNIT_UPGRADE_COST', '[ICON_GOLD] {1_Num} to upgrade', '', '');


UPDATE LoadedFile SET Value=1 WHERE Type='Civup_UnitTrees.sql';
