/* The sql commands and text below were formulated in the YieldLibrary tab of the Google Spreadsheet 'CAT_Language'.
https://docs.google.com/spreadsheet/ccc?key=0Ap8Ehya83q19dGtjX2JldHBzdXhRbGNxVFgxT1E2OHc&usp=drive_web#gid=7
If you make any changes be sure to update the spreadsheet also.*/
/*  Yield Breakdown Tooltip */
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_CULTURE_WONDER_BONUS', '+{1_Num}% from having a World Wonder', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_CULTURE_CITY_MOD', '+{1_Num}% from City', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_CULTURE_PLAYER_MOD', ' +{1_Num}% from Empire', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_FOOD_USAGE', '[COLOR_POSITIVE_TEXT]{1_Num}[ENDCOLOR] - [COLOR_NEGATIVE_TEXT]{2_Num}[ENDCOLOR] eaten by [ICON_CITIZEN] Citizens', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_FOODMOD_PLAYER', '[NEWLINE][ICON_BULLET]{1_Num}% from Empire', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_FOODMOD_CAPITAL', '[NEWLINE][ICON_BULLET]{1_Num}% for [ICON_CAPITAL] Capital', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_FOODMOD_UNHAPPY', '[NEWLINE][ICON_BULLET][COLOR_WARNING_TEXT]{1_Num}%[ENDCOLOR] from [ICON_HAPPINESS_4] Unhappiness', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_FOODMOD_WLTKD', '[NEWLINE][ICON_BULLET]{1_Num}% from We Love the King Day', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_PRODMOD_FOOD_CONVERSION', '[NEWLINE][ICON_BULLET]+{1_Num} [ICON_PRODUCTION] from excess [ICON_FOOD] Food', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_PRODMOD_RAILROAD_CONNECTION', '[NEWLINE][ICON_BULLET]{1_Num} from Railroad Connection', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_PRODMOD_UNIT_DOMAIN', '[NEWLINE][ICON_BULLET]{1_Num}% for Unit Domain', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_PRODMOD_UNIT_COMBAT_TYPE', '[NEWLINE][ICON_BULLET]{1_Num}% for Combat Class', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_PRODMOD_MILITARY', '[NEWLINE][ICON_BULLET]{1_Num}% for Military Units', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_PRODMOD_UNIT_WITH_BUILDING', '[NEWLINE][ICON_BULLET]{1_Num}% for {2_BuildingName}', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_PRODMOD_WONDER_CITY', '[NEWLINE][ICON_BULLET]{1_Num}% for Wonders (City)', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_PRODMOD_WONDER_PLAYER', '[NEWLINE][ICON_BULLET]{1_Num}% for Wonders (Empire)', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_PRODMOD_WONDER_LOCAL_RES', '[NEWLINE][ICON_BULLET]{1_Num}% for Wonders ({2_ResourceName})', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_PRODMOD_BUILDING_CITY', '[NEWLINE][ICON_BULLET]{1_Num}% for Buildings', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_PRODMOD_CAPITAL_BUILDING_TRAIT', '[NEWLINE][ICON_BULLET]{1_Num}% from Buildings in [ICON_CAPITAL] Capital (Trait)', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_PRODMOD_SPACE', '[NEWLINE][ICON_BULLET]{1_Num}% for Spaceship (Empire)', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_PRODMOD_UNIT_SUPPLY', '[NEWLINE][ICON_BULLET]{1_Num}% for Unit Supply (Empire)', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_PRODMOD_MILITARY_PLAYER', '[NEWLINE][ICON_BULLET]{1_Num}% for Military Units (Empire)', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_PRODMOD_SETTLER_PLAYER', '[NEWLINE][ICON_BULLET]{1_Num}% for Settlers (Empire)', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_PRODMOD_CAPITAL_SETTLER_PLAYER', '[NEWLINE][ICON_BULLET]{1_Num}% for Settlers (Capital)', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_PRODMOD_RELIGION_PLAYER', '[NEWLINE][ICON_BULLET]{1_Num}% for Religious Builds (Empire)', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_PRODMOD_UNIT_COBMAT_CLASS_PLAYER', '[NEWLINE][ICON_BULLET]{1_Num}% for Combat Class (Empire)', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_PRODMOD_UNIT_TRAIT', '[NEWLINE][ICON_BULLET]{1_Num}% for Unit Type (Trait)', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_PRODMOD_BUILDING_TRAIT', '[NEWLINE][ICON_BULLET]{1_Num}% for Buildings (Trait)', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_PRODMOD_WONDER_POLICY', '[NEWLINE][ICON_BULLET]{1_Num}% for Wonders (Policy)', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_PRODMOD_BUILDING_POLICY', '[NEWLINE][ICON_BULLET]{1_Num}% for Buildings (Policy)', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_PRODMOD_WORLD_WONDER_PLAYER', '[NEWLINE][ICON_BULLET]{1_Num}% for World Wonders (Empire)', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_PRODMOD_TEAM_WONDER_PLAYER', '[NEWLINE][ICON_BULLET]{1_Num}% for Team Wonders (Empire)', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_PRODMOD_NATIONAL_WONDER_PLAYER', '[NEWLINE][ICON_BULLET]{1_Num}% for National Wonders (Empire)', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_PRODMOD_BUILDING_POLICY_PLAYER', '[NEWLINE][ICON_BULLET]{1_Num}% for Buildings (Policy Empire Mod)', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_PRODMOD_SPACE_PLAYER', '[NEWLINE][ICON_BULLET]{1_Num}% for Spaceship (Empire)', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_PRODMOD_SPECIALIST_PLAYER', '[NEWLINE][ICON_BULLET]{1_Num}% for Specialists (Empire)', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_PRODMOD_YIELD', '[NEWLINE][ICON_BULLET]{1_Num}% from City', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_PRODMOD_YIELD_RESOURCES', '[NEWLINE][ICON_BULLET]{1_Num}% from Resources', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_PRODMOD_YIELD_HAPPINESS', '[NEWLINE][ICON_BULLET]{1_Num}% from Happiness', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_PRODMOD_YIELD_AREA', '[NEWLINE][ICON_BULLET]{1_Num}% from Area', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_PRODMOD_YIELD_PLAYER', '[NEWLINE][ICON_BULLET]{1_Num}% from Misc', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_PRODMOD_YIELD_CAPITAL', '[NEWLINE][ICON_BULLET]{1_Num}% for [ICON_CAPITAL] Capital', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_PRODMOD_YIELD_GOLDEN_AGE', '[NEWLINE][ICON_BULLET]{1_Num}% from Golden Age', '', '');
/*  Misc */
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_YIELD_BREAKDOWN', '[{1_color}]{2_stored}[ENDCOLOR]/[{1_color}]{3_needed}[ENDCOLOR] ([{1_color}]+{4_rate}[ENDCOLOR] per turn) {5_icon} {6_desc}', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_TOPIC_LAW', 'Law', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_TOPIC_POPULATION', 'Citizen', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_TOPIC_CS_MILITARY', 'points per turn ', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_PER_CITY', 'per city', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_SPLIT_AMONG_CITIES', 'split among your cities', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_MILITARY_UNIT_REWARDS', 'Military Unit', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_TP_SCIENCE_FROM_HAPPINESS', '[ICON_BULLET][COLOR_POSITIVE_TEXT]{1_Num}%[ENDCOLOR] [ICON_RESEARCH] from {1_Num} [ICON_HAPPINESS_1] Happiness.', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_TP_SCIENCE_FROM_UNHAPPINESS', '[ICON_BULLET][COLOR_POSITIVE_TEXT]-{1_Num}%[ENDCOLOR] [ICON_RESEARCH] from {1_Num} [ICON_HAPPINESS_4] Unhappiness.', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_TP_GOLD_FOR_FREE', '{1_Num} for free.', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_TP_GOLD_FROM_OPEN_BORDERS', '{1_Num} from mutual Open Borders with other leaders.', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_TP_HAPPINESS_CITYSTATES', '{1_Num} National Happiness from City-States.', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_TP_HAPPINESS_DIFFICULTY_LEVEL', '{1_Num} National Happiness for free.', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_TP_SCIENCE_FROM_RESEARCH_AGREEMENTS', '[ICON_BULLET][COLOR_POSITIVE_TEXT]{1_Num}[ENDCOLOR] [ICON_RESEARCH] from Research Agreements.', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_TP_YIELD_FROM_LUXURIES', '{1_Num} from Luxury Resources.', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_TP_GOLD_FROM_POLICIES', '{1_Num} from Policies.', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_YIELD_FROM_POLICIES', '{1_Num} {2_icon} from Policies', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_YIELD_FROM_TRAITS', '{1_Num} {2_icon} from Traits', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_YIELD_FROM_PROCESSES', '{1_Num} {2_IconString} from Process', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_YIELD_FROM_MINOR_CIVS', '{1_num} {2_icon} from City-States', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_CITYSTATE_MODIFIER_FOCUS', '{2_icon} City Focus: {1_num}%', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_CITYSTATE_MODIFIER_POPULATION', '[ICON_CITIZEN] Population: {1_num}', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_CITYSTATE_MODIFIER_NOT_CONNECTED', '[ICON_CONNECTED] Not Connected: {1_num}%', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_CITYSTATE_MODIFIER_IS_RAZING', '[ICON_RAZING] Razing: {1_num}%', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_CITYSTATE_MODIFIER_IS_RESISTANCE', '[ICON_RESISTANCE] Resistance: {1_num}%', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_CITYSTATE_MODIFIER_IS_PUPPET', '[ICON_PUPPET] Puppet: {1_num}%', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_CITYSTATE_MODIFIER_IS_OCCUPIED', '[ICON_OCCUPIED] Occupied: {1_num}%', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_CITYSTATE_MODIFIER_IS_BLOCKADED', '[ICON_BLOCKADED] Blockaded: {1_num}%', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_CITYSTATE_MODIFIER_IS_CAPITAL', '[ICON_CAPITAL] Capital: {1_num}%', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_CITYSTATE_MODIFIER_IS_AVOID', '[ICON_MUSHROOM] Avoid Growth: {1_num}%', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_CITYSTATE_MODIFIER_IS_AVOID_MANY', '(More than {1_num}% of cities on avoid)', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_CITYSTATE_MODIFIER_WEIGHT_TOTAL', '{1_num} (city) / {2_num} (empire)={3_num}% of {4_num}{5_icon}', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_YIELD_USAGE', '([COLOR_POSITIVE_TEXT]{1_num}[ENDCOLOR] - [COLOR_NEGATIVE_TEXT]{2_num}[ENDCOLOR] consumed)', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_YIELD_SURPLUS', '{1_num} {2_icon} Surplus', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_YIELD_FROM_OTHER_YIELDS', '({1_num} {2_icon} + {3_num} {4_icon} {5_yieldstring})', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_PRODMOD_YIELD_SETTLER_POLICY', '[NEWLINE][ICON_BULLET]Policy Modifier for Settlers: {1_num}%', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_PRODMOD_YIELD_POLICY', '[NEWLINE][ICON_BULLET]Policy Modifier: {1_Num}%', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_PRODMOD_YIELD_BUILDINGS', '[NEWLINE][ICON_BULLET]Building Modifier: {1_Num}%', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_PRODMOD_CAPITAL_BUILDING_TRAIT', '[NEWLINE][ICON_BULLET]Modifier for Buildings in [ICON_CAPITAL] Capital: {1_Num}%', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_YIELD_MOD_GLOBAL_BUILDINGS', '[NEWLINE][ICON_BULLET]Buildings in Other Cities: {1_Num}%', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_PRODMOD_YIELD_HAPPINESS', '[NEWLINE][ICON_BULLET][COLOR_WARNING_TEXT][ICON_HAPPINESS_4] Unhappiness Modifier: {1_Num}%[ENDCOLOR]', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_TP_YIELD_FOR_FREE', '[ICON_BULLET][COLOR_POSITIVE_TEXT]{1_Num}[ENDCOLOR] {2_icon} for free.', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_TP_YIELD_FROM_CITIES', '[ICON_BULLET][COLOR_POSITIVE_TEXT]{1_Num}[ENDCOLOR] {2_icon} from Cities.', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_TP_YIELD_FROM_POLICIES', '[ICON_BULLET][COLOR_POSITIVE_TEXT]{1_Num}[ENDCOLOR] {2_icon} from Policies', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_TP_YIELD_FROM_MINORS', '[ICON_BULLET][COLOR_POSITIVE_TEXT]{1_Num}[ENDCOLOR] {2_icon} from City-States.', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_TP_YIELD_FROM_HAPPINESS', '[ICON_BULLET][COLOR_POSITIVE_TEXT]{1_Num}[ENDCOLOR] {2_icon} from excess [ICON_HAPPINESS_1] Happiness.', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_TP_YIELD_FROM_RESEARCH_AGREEMENTS', '[ICON_BULLET][COLOR_POSITIVE_TEXT]{1_Num}[ENDCOLOR] {2_icon} from Research Agreements with other players.', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_TP_SCIENCE', '[ICON_RESEARCH] Science being produced empire-wide towards the current research project.', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_NEXT_POLICY_TURN_LABEL', '{1_Num: number #} Turn(s) to Next Policy', '', '');








UPDATE LoadedFile SET Value=1, en_US=1 Where Type='YieldLibrary.sql';