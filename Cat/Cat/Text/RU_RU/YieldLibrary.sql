/* The sql commands and text below were formulated in the YieldLibrary tab of the Google Spreadsheet 'CAT_Language'.
https://docs.google.com/spreadsheet/ccc?key=0Ap8Ehya83q19dGtjX2JldHBzdXhRbGNxVFgxT1E2OHc&usp=drive_web#gid=7
If you make any changes be sure to update the spreadsheet also.*/
/* Выход Распределение Подсказка */
REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_CULTURE_WONDER_BONUS', '{1_Num}% от того, Всемирный Wonder', '', '');
REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_CULTURE_CITY_MOD', '{1_Num}% от города', '', '');
REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_CULTURE_PLAYER_MOD', ' {1_Num}% от империи', '', '');
REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_FOOD_USAGE', '[COLOR_POSITIVE_TEXT] {1_Num} [ENDCOLOR] - [COLOR_NEGATIVE_TEXT] {2_Num} [ENDCOLOR] съедены [ICON_CITIZEN] граждан', '', '');
REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_FOODMOD_PLAYER', '[NEWLINE] [ICON_BULLET] {1_Num}% от империи', '', '');
REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_FOODMOD_CAPITAL', '[NEWLINE] [ICON_BULLET] {1_Num}% для [ICON_CAPITAL] Капитал', '', '');
REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_FOODMOD_UNHAPPY', '[NEWLINE] [ICON_BULLET] [COLOR_WARNING_TEXT] {1_Num}% [ENDCOLOR] из [ICON_HAPPINESS_4] Несчастье', '', '');
REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_FOODMOD_WLTKD', '[NEWLINE] [ICON_BULLET] {1_Num}% от We Love День короля', '', '');
REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_PRODMOD_FOOD_CONVERSION', '[NEWLINE] [ICON_BULLET] + {1_Num} [ICON_PRODUCTION] от избытка [ICON_FOOD] Еда', '', '');
REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_PRODMOD_RAILROAD_CONNECTION', '[NEWLINE] [ICON_BULLET] {1_Num} от железнодорожного сообщения', '', '');
REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_PRODMOD_UNIT_DOMAIN', '[NEWLINE] [ICON_BULLET] {1_Num}% для единицы домена', '', '');
REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_PRODMOD_UNIT_COMBAT_TYPE', '{1_Num}% для [ICON_BULLET] боевой класса [NEWLINE]', '', '');
REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_PRODMOD_MILITARY', '[NEWLINE] [ICON_BULLET] {1_Num}% для воинских частей', '', '');
REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_PRODMOD_UNIT_WITH_BUILDING', '[NEWLINE] [ICON_BULLET] {1_Num}% для {2_BuildingName}', '', '');
REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_PRODMOD_WONDER_CITY', '[NEWLINE] [ICON_BULLET] {1_Num}% для чудес (Город)', '', '');
REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_PRODMOD_WONDER_PLAYER', '[NEWLINE] [ICON_BULLET] {1_Num}% для чудес (Империя)', '', '');
REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_PRODMOD_WONDER_LOCAL_RES', '[NEWLINE] [ICON_BULLET] {1_Num}% для чудес ({2_ResourceName})', '', '');
REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_PRODMOD_BUILDING_CITY', '[NEWLINE] [ICON_BULLET] {1_Num}% для зданий', '', '');
REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_PRODMOD_CAPITAL_BUILDING_TRAIT', '[NEWLINE] [ICON_BULLET] {1_Num}% от зданий в [ICON_CAPITAL] Capital (Черта)', '', '');
REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_PRODMOD_SPACE', '[NEWLINE] [ICON_BULLET] {1_Num}% для космического корабля (Империя)', '', '');
REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_PRODMOD_UNIT_SUPPLY', '[NEWLINE] [ICON_BULLET] {1_Num}% для блока питания (Империя)', '', '');
REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_PRODMOD_MILITARY_PLAYER', '{1_Num}% для [NEWLINE] [ICON_BULLET] воинских частей (Империя)', '', '');
REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_PRODMOD_SETTLER_PLAYER', '[NEWLINE] [ICON_BULLET] {1_Num}% для Settlers (Империя)', '', '');
REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_PRODMOD_CAPITAL_SETTLER_PLAYER', '[NEWLINE] [ICON_BULLET] {1_Num}% для Settlers (капитала)', '', '');
REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_PRODMOD_RELIGION_PLAYER', '[NEWLINE] [ICON_BULLET] {1_Num}% по религиозным Строит (империю)', '', '');
REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_PRODMOD_UNIT_COBMAT_CLASS_PLAYER', '[NEWLINE] [ICON_BULLET] {1_Num}% для боевой класса (Империя)', '', '');
REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_PRODMOD_UNIT_TRAIT', '{1_Num}% для [NEWLINE] [ICON_BULLET] Тип блока (Черта)', '', '');
REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_PRODMOD_BUILDING_TRAIT', '[NEWLINE] [ICON_BULLET] {1_Num}% для зданий (Черта)', '', '');
REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_PRODMOD_WONDER_POLICY', '[NEWLINE] [ICON_BULLET] {1_Num}% для чудес (Политика)', '', '');
REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_PRODMOD_BUILDING_POLICY', '[NEWLINE] [ICON_BULLET] {1_Num}% для зданий (Политика)', '', '');
REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_PRODMOD_WORLD_WONDER_PLAYER', '[NEWLINE] [ICON_BULLET] {1_Num}% для чудес мира (Империя)', '', '');
REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_PRODMOD_TEAM_WONDER_PLAYER', '[NEWLINE] [ICON_BULLET] {1_Num}% для команды чудес (Империя)', '', '');
REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_PRODMOD_NATIONAL_WONDER_PLAYER', '[NEWLINE] [ICON_BULLET] {1_Num}% для национальных чудес (Империя)', '', '');
REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_PRODMOD_BUILDING_POLICY_PLAYER', '[NEWLINE] [ICON_BULLET] {1_Num}% для зданий (Политика Империя Mod)', '', '');
REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_PRODMOD_SPACE_PLAYER', '[NEWLINE] [ICON_BULLET] {1_Num}% для космического корабля (Империя)', '', '');
REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_PRODMOD_SPECIALIST_PLAYER', '[NEWLINE] [ICON_BULLET] {1_Num}% для специалистов (Империя)', '', '');
REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_PRODMOD_YIELD', '[NEWLINE] [ICON_BULLET] {1_Num}% от городской', '', '');
REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_PRODMOD_YIELD_RESOURCES', '[NEWLINE] [ICON_BULLET] {1_Num}% от ресурсов', '', '');
REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_PRODMOD_YIELD_HAPPINESS', '[NEWLINE] [ICON_BULLET] {1_Num}% от счастья', '', '');
REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_PRODMOD_YIELD_AREA', '{1_Num}% от [ICON_BULLET] Площадь [NEWLINE]', '', '');
REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_PRODMOD_YIELD_PLAYER', '[NEWLINE] [ICON_BULLET] {1_Num}% от Разное', '', '');
REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_PRODMOD_YIELD_CAPITAL', '[NEWLINE] [ICON_BULLET] {1_Num}% для [ICON_CAPITAL] Капитал', '', '');
REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_PRODMOD_YIELD_GOLDEN_AGE', '[NEWLINE] [ICON_BULLET] {1_Num}% от Золотого века', '', '');
/* Разное */
REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_YIELD_BREAKDOWN', '{[1_color}] {2_stored} [ENDCOLOR] / {[1_color}] {3_needed} [ENDCOLOR] ({[1_color}] + {4_rate} [ENDCOLOR] за ход ) {5_icon} {6_desc}', '', '');
REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_TOPIC_LAW', 'Закон', '', '');
REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_TOPIC_POPULATION', 'Гражданин', '', '');
REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_TOPIC_CS_MILITARY', 'очков за свою очередь', '', '');
REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_PER_CITY', 'По городам', '', '');
REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_SPLIT_AMONG_CITIES', 'разделить среди ваших городах', '', '');
REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_MILITARY_UNIT_REWARDS', 'Войсковая часть', '', '');
REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_TP_SCIENCE_FROM_HAPPINESS', '[ICON_BULLET] [COLOR_POSITIVE_TEXT] {1_Num}% [ENDCOLOR] [ICON_RESEARCH] из {1_Num} [ICON_HAPPINESS_1] Счастье.', '', '');
REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_TP_SCIENCE_FROM_UNHAPPINESS', '[ICON_BULLET] [COLOR_POSITIVE_TEXT] - {1_Num}% [ENDCOLOR] [ICON_RESEARCH] из {1_Num} [ICON_HAPPINESS_4] Несчастье.', '', '');
REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_TP_GOLD_FOR_FREE', '{1_Num} бесплатно.', '', '');
REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_TP_GOLD_FROM_OPEN_BORDERS', '{1_Num} от взаимных открыть границы с другими лидерами.', '', '');
REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_TP_HAPPINESS_CITYSTATES', '{1_Num} национальное счастье от городов-государств.', '', '');
REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_TP_HAPPINESS_DIFFICULTY_LEVEL', '{1_Num} национальное счастье бесплатно.', '', '');
REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_TP_SCIENCE_FROM_RESEARCH_AGREEMENTS', '[ICON_BULLET] [COLOR_POSITIVE_TEXT] {1_Num} [ENDCOLOR] [ICON_RESEARCH] из исследовательских соглашений.', '', '');
REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_TP_YIELD_FROM_LUXURIES', '{1_Num} от Luxury ресурсов.', '', '');
REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_TP_GOLD_FROM_POLICIES', '{1_Num} от политики.', '', '');
REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_YIELD_FROM_POLICIES', '{1_Num} {2_icon} от политики', '', '');
REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_YIELD_FROM_TRAITS', '{1_Num} {2_icon} из Черты', '', '');
REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_YIELD_FROM_PROCESSES', '{1_Num} {2_IconString} от процесса', '', '');
REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_YIELD_FROM_MINOR_CIVS', '{1_Num} {2_icon} из городов-государств', '', '');
REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_CITYSTATE_MODIFIER_FOCUS', '{2_icon} Город Фокус: {1_Num}%', '', '');
REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_CITYSTATE_MODIFIER_POPULATION', '[ICON_CITIZEN] Население: {1_Num}', '', '');
REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_CITYSTATE_MODIFIER_NOT_CONNECTED', '[ICON_CONNECTED] Не подключен: {1_Num}%', '', '');
REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_CITYSTATE_MODIFIER_IS_RAZING', '[ICON_RAZING] Если разрушить: {1_Num}%', '', '');
REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_CITYSTATE_MODIFIER_IS_RESISTANCE', '[ICON_RESISTANCE] Сопротивление: {1_Num}%', '', '');
REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_CITYSTATE_MODIFIER_IS_PUPPET', '[ICON_PUPPET] кукол: {1_Num}%', '', '');
REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_CITYSTATE_MODIFIER_IS_OCCUPIED', '[ICON_OCCUPIED] Занято: {1_Num}%', '', '');
REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_CITYSTATE_MODIFIER_IS_BLOCKADED', '[ICON_BLOCKADED] блокадного: {1_Num}%', '', '');
REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_CITYSTATE_MODIFIER_IS_CAPITAL', '[ICON_CAPITAL] Столица: {1_Num}%', '', '');
REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_CITYSTATE_MODIFIER_IS_AVOID', '[ICON_MUSHROOM] Избегайте рост: {1_Num}%', '', '');
REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_CITYSTATE_MODIFIER_IS_AVOID_MANY', '(Более {1_Num}% городов на избегают)', '', '');
REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_CITYSTATE_MODIFIER_WEIGHT_TOTAL', '{1_Num} (город) / {2_Num} (империя) = {3_Num}% от {4_num} {5_icon}', '', '');
REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_YIELD_USAGE', '([COLOR_POSITIVE_TEXT] {1_Num} [ENDCOLOR] - [COLOR_NEGATIVE_TEXT] {2_Num} [ENDCOLOR] потребляется)', '', '');
REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_YIELD_SURPLUS', '{1_Num} {2_icon} Профицит', '', '');
REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_YIELD_FROM_OTHER_YIELDS', '({1_Num} {2_icon} + {3_Num} {4_icon} {5_yieldstring})', '', '');
REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_PRODMOD_YIELD_SETTLER_POLICY', '[NEWLINE] [ICON_BULLET] Политика Модификатор для Settlers: {1_Num}%', '', '');
REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_PRODMOD_YIELD_POLICY', '[NEWLINE] [ICON_BULLET] Политика Множитель: {1_Num}%', '', '');
REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_PRODMOD_YIELD_BUILDINGS', '[NEWLINE] [ICON_BULLET] Строительство Множитель: {1_Num}%', '', '');
REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_PRODMOD_CAPITAL_BUILDING_TRAIT', '[NEWLINE] [ICON_BULLET] Модификатор для зданий в [ICON_CAPITAL] Столица: {1_Num}%', '', '');
REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_YIELD_MOD_GLOBAL_BUILDINGS', '[NEWLINE] [ICON_BULLET] Здания в других городах: {1_Num}%', '', '');
REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_PRODMOD_YIELD_HAPPINESS', '[NEWLINE] [ICON_BULLET] [COLOR_WARNING_TEXT] [ICON_HAPPINESS_4] Несчастье Множитель: {1_Num}% [ENDCOLOR]', '', '');
REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_TP_YIELD_FOR_FREE', '[ICON_BULLET] [COLOR_POSITIVE_TEXT] {1_Num} [ENDCOLOR] {2_icon} бесплатно.', '', '');
REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_TP_YIELD_FROM_CITIES', '[ICON_BULLET] [COLOR_POSITIVE_TEXT] {1_Num} [ENDCOLOR] {2_icon} из городов.', '', '');
REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_TP_YIELD_FROM_POLICIES', '[ICON_BULLET] [COLOR_POSITIVE_TEXT] {1_Num} [ENDCOLOR] {2_icon} от политики', '', '');
REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_TP_YIELD_FROM_MINORS', '[ICON_BULLET] [COLOR_POSITIVE_TEXT] {1_Num} [ENDCOLOR] {2_icon} из городов-государств.', '', '');
REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_TP_YIELD_FROM_HAPPINESS', '[ICON_BULLET] [COLOR_POSITIVE_TEXT] {1_Num} [ENDCOLOR] {2_icon} от избыточного [ICON_HAPPINESS_1] Счастье.', '', '');
REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_TP_YIELD_FROM_RESEARCH_AGREEMENTS', '[ICON_BULLET] [COLOR_POSITIVE_TEXT] {1_Num} [ENDCOLOR] {2_icon} из исследовательских соглашений с другими игроками.', '', '');
REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_TP_SCIENCE', '[ICON_RESEARCH] Наука производится общеимперских к текущей научно-исследовательского проекта.', '', '');
REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_NEXT_POLICY_TURN_LABEL', '{1_Num: номер #} Поворот (ей) Следующая политики', '', '');








UPDATE Loaded File SET Value=1, RU_RU=1 Where Type='YieldLibrary.sql';