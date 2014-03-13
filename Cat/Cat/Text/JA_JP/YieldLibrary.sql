/* The sql commands and text below were formulated in the YieldLibrary tab of the Google Spreadsheet 'CAT_Language'.
https://docs.google.com/spreadsheet/ccc?key=0Ap8Ehya83q19dGtjX2JldHBzdXhRbGNxVFgxT1E2OHc&usp=drive_web#gid=7
If you make any changes be sure to update the spreadsheet also.*/
/*収量内訳ツールチップ*/
REPLACE INTO Language_JA_JP (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_CULTURE_WONDER_BONUS', '+ {1_Num}％ワールド·ワンダーを持っていることから', '', '');
REPLACE INTO Language_JA_JP (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_CULTURE_CITY_MOD', '市から+ {1_Num}％', '', '');
REPLACE INTO Language_JA_JP (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_CULTURE_PLAYER_MOD', ' 帝国から+ {1_Num}％', '', '');
REPLACE INTO Language_JA_JP (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_FOOD_USAGE', '[COLOR_POSITIVE_TEXT] {1_Num} [ENDCOLOR]  -  [COLOR_NEGATIVE_TEXT] {2_Num} [ENDCOLOR] [ICON_CITIZEN]市民に食わ', '', '');
REPLACE INTO Language_JA_JP (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_FOODMOD_PLAYER', '帝国から[NEWLINE] [ICON_BULLET] {1_Num}％', '', '');
REPLACE INTO Language_JA_JP (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_FOODMOD_CAPITAL', '[NEWLINE] [ICON_BULLET] {1_Num}％[ICON_CAPITAL]の設備投資', '', '');
REPLACE INTO Language_JA_JP (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_FOODMOD_UNHAPPY', '[NEWLINE] [ICON_BULLET] [COLOR_WARNING_TEXT] {1_Num}％[ENDCOLOR] [ICON_HAPPINESS_4]不幸から', '', '');
REPLACE INTO Language_JA_JP (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_FOODMOD_WLTKD', '[NEWLINE] [ICON_BULLET] {1_Num}％我々は王の日愛から', '', '');
REPLACE INTO Language_JA_JP (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_PRODMOD_FOOD_CONVERSION', '[NEWLINE] [ICON_BULLET] + {1_Num} [ICON_PRODUCTION]過剰[ICON_FOOD]フードから', '', '');
REPLACE INTO Language_JA_JP (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_PRODMOD_RAILROAD_CONNECTION', '[NEWLINE] [ICON_BULLET] {1_Num}鉄道Connectionから', '', '');
REPLACE INTO Language_JA_JP (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_PRODMOD_UNIT_DOMAIN', 'ユニットドメインの[NEWLINE] [ICON_BULLET] {1_Num}％', '', '');
REPLACE INTO Language_JA_JP (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_PRODMOD_UNIT_COMBAT_TYPE', '戦闘クラスA [NEWLINE] [ICON_BULLET] {1_Num}％', '', '');
REPLACE INTO Language_JA_JP (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_PRODMOD_MILITARY', '軍隊のための[NEWLINE] [ICON_BULLET] {1_Num}％', '', '');
REPLACE INTO Language_JA_JP (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_PRODMOD_UNIT_WITH_BUILDING', '[NEWLINE] [ICON_BULLET] {1_Num}％{2_BuildingName}のために', '', '');
REPLACE INTO Language_JA_JP (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_PRODMOD_WONDER_CITY', '[NEWLINE] [ICON_BULLET] {1_Num}％の驚異のための（市）', '', '');
REPLACE INTO Language_JA_JP (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_PRODMOD_WONDER_PLAYER', '不思議のための[NEWLINE] [ICON_BULLET] {1_Num}％（帝国）', '', '');
REPLACE INTO Language_JA_JP (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_PRODMOD_WONDER_LOCAL_RES', '[NEWLINE] [ICON_BULLET] {1_Num}％の驚異のための（{2_ResourceName}）', '', '');
REPLACE INTO Language_JA_JP (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_PRODMOD_BUILDING_CITY', '建物のための[NEWLINE] [ICON_BULLET] {1_Num}％', '', '');
REPLACE INTO Language_JA_JP (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_PRODMOD_CAPITAL_BUILDING_TRAIT', '[NEWLINE] [ICON_BULLET] {1_Num}％[ICON_CAPITAL]キャピタル（形質）建物から', '', '');
REPLACE INTO Language_JA_JP (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_PRODMOD_SPACE', '宇宙船のための[NEWLINE] [ICON_BULLET] {1_Num}％（帝国）', '', '');
REPLACE INTO Language_JA_JP (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_PRODMOD_UNIT_SUPPLY', '[NEWLINE] [ICON_BULLET] {1_Num}％単位電源用（帝国）', '', '');
REPLACE INTO Language_JA_JP (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_PRODMOD_MILITARY_PLAYER', '[NEWLINE] [ICON_BULLET] {1_Num}％（帝国）軍隊のための', '', '');
REPLACE INTO Language_JA_JP (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_PRODMOD_SETTLER_PLAYER', '入植者のための[NEWLINE] [ICON_BULLET] {1_Num}％（帝国）', '', '');
REPLACE INTO Language_JA_JP (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_PRODMOD_CAPITAL_SETTLER_PLAYER', '[NEWLINE] [ICON_BULLET] {1_Num}％入植者のための（資本）', '', '');
REPLACE INTO Language_JA_JP (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_PRODMOD_RELIGION_PLAYER', '[NEWLINE] [ICON_BULLET] {1_Num}宗教のための％は、（帝国）を構築', '', '');
REPLACE INTO Language_JA_JP (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_PRODMOD_UNIT_COBMAT_CLASS_PLAYER', '[NEWLINE] [ICON_BULLET] {1_Num}％戦闘クラスA（帝国）', '', '');
REPLACE INTO Language_JA_JP (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_PRODMOD_UNIT_TRAIT', '[NEWLINE] [ICON_BULLET] {1_Num}％（形質）ユニットタイプのため', '', '');
REPLACE INTO Language_JA_JP (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_PRODMOD_BUILDING_TRAIT', '建物のための[NEWLINE] [ICON_BULLET] {1_Num}％（形質）', '', '');
REPLACE INTO Language_JA_JP (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_PRODMOD_WONDER_POLICY', '不思議のための[NEWLINE] [ICON_BULLET] {1_Num}％（ポリシー）', '', '');
REPLACE INTO Language_JA_JP (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_PRODMOD_BUILDING_POLICY', '建物のための[NEWLINE] [ICON_BULLET] {1_Num}％（ポリシー）', '', '');
REPLACE INTO Language_JA_JP (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_PRODMOD_WORLD_WONDER_PLAYER', 'ワールドオブワンダー（帝国）のための[NEWLINE] [ICON_BULLET] {1_Num}％', '', '');
REPLACE INTO Language_JA_JP (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_PRODMOD_TEAM_WONDER_PLAYER', '[NEWLINE] [ICON_BULLET] {1_Num}％チームの驚異のための（帝国）', '', '');
REPLACE INTO Language_JA_JP (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_PRODMOD_NATIONAL_WONDER_PLAYER', '国立七不思議のため[NEWLINE] [ICON_BULLET] {1_Num}％（帝国）', '', '');
REPLACE INTO Language_JA_JP (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_PRODMOD_BUILDING_POLICY_PLAYER', '建物のための[NEWLINE] [ICON_BULLET] {1_Num}％（ポリシー帝国MOD）', '', '');
REPLACE INTO Language_JA_JP (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_PRODMOD_SPACE_PLAYER', '宇宙船のための[NEWLINE] [ICON_BULLET] {1_Num}％（帝国）', '', '');
REPLACE INTO Language_JA_JP (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_PRODMOD_SPECIALIST_PLAYER', '専門家のための[NEWLINE] [ICON_BULLET] {1_Num}％（帝国）', '', '');
REPLACE INTO Language_JA_JP (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_PRODMOD_YIELD', '[NEWLINE] [ICON_BULLET] {1_Num}％市から', '', '');
REPLACE INTO Language_JA_JP (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_PRODMOD_YIELD_RESOURCES', '[NEWLINE] [ICON_BULLET] {1_Num}％資源から', '', '');
REPLACE INTO Language_JA_JP (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_PRODMOD_YIELD_HAPPINESS', '幸福から[NEWLINE] [ICON_BULLET] {1_Num}％', '', '');
REPLACE INTO Language_JA_JP (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_PRODMOD_YIELD_AREA', '[NEWLINE] [ICON_BULLET] {1_Num}％エリアから', '', '');
REPLACE INTO Language_JA_JP (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_PRODMOD_YIELD_PLAYER', '[NEWLINE] [ICON_BULLET] {1_Num}％その他から', '', '');
REPLACE INTO Language_JA_JP (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_PRODMOD_YIELD_CAPITAL', '[NEWLINE] [ICON_BULLET] {1_Num}％[ICON_CAPITAL]の設備投資', '', '');
REPLACE INTO Language_JA_JP (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_PRODMOD_YIELD_GOLDEN_AGE', '黄金時代から[NEWLINE] [ICON_BULLET] {1_Num}％', '', '');
/*その他*/
REPLACE INTO Language_JA_JP (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_YIELD_BREAKDOWN', '{[1_color}] {2_stored} [ENDCOLOR] / {[1_color}] {3_needed} [ENDCOLOR]（{[1_color}] + {4_rate} [ENDCOLOR]ターン）{5_icon} {6_desc}', '', '');
REPLACE INTO Language_JA_JP (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_TOPIC_LAW', '法則', '', '');
REPLACE INTO Language_JA_JP (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_TOPIC_POPULATION', '市民', '', '');
REPLACE INTO Language_JA_JP (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_TOPIC_CS_MILITARY', 'ターンごとのポイント', '', '');
REPLACE INTO Language_JA_JP (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_PER_CITY', '都市ごと', '', '');
REPLACE INTO Language_JA_JP (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_SPLIT_AMONG_CITIES', 'あなたの都市の間で分割', '', '');
REPLACE INTO Language_JA_JP (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_MILITARY_UNIT_REWARDS', '部隊', '', '');
REPLACE INTO Language_JA_JP (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_TP_SCIENCE_FROM_HAPPINESS', '[ICON_BULLET] [COLOR_POSITIVE_TEXT] {1_Num}％[ENDCOLOR] [ICON_RESEARCH] {1_Num} [ICON_HAPPINESS_1]幸福から。', '', '');
REPLACE INTO Language_JA_JP (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_TP_SCIENCE_FROM_UNHAPPINESS', '[ICON_BULLET] [COLOR_POSITIVE_TEXT]  -  {1_Num}％[ENDCOLOR] [ICON_RESEARCH] {1_Num} [ICON_HAPPINESS_4]不幸から。', '', '');
REPLACE INTO Language_JA_JP (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_TP_GOLD_FOR_FREE', '{1_Num}無料。', '', '');
REPLACE INTO Language_JA_JP (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_TP_GOLD_FROM_OPEN_BORDERS', '{1_Num}他の指導者との相互国境開放から。', '', '');
REPLACE INTO Language_JA_JP (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_TP_HAPPINESS_CITYSTATES', '都市国家から{1_Num}ナショナル幸福。', '', '');
REPLACE INTO Language_JA_JP (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_TP_HAPPINESS_DIFFICULTY_LEVEL', '自由のための{1_Num}ナショナル幸福。', '', '');
REPLACE INTO Language_JA_JP (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_TP_SCIENCE_FROM_RESEARCH_AGREEMENTS', '[ICON_BULLET] [COLOR_POSITIVE_TEXT] {1_Num} [ENDCOLOR] [ICON_RESEARCH]研究契約から。', '', '');
REPLACE INTO Language_JA_JP (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_TP_YIELD_FROM_LUXURIES', '{1_Num}高級資源から。', '', '');
REPLACE INTO Language_JA_JP (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_TP_GOLD_FROM_POLICIES', '{1_Num}のポリシーから。', '', '');
REPLACE INTO Language_JA_JP (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_YIELD_FROM_POLICIES', '{1_Num} {2_icon}ポリシーから', '', '');
REPLACE INTO Language_JA_JP (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_YIELD_FROM_TRAITS', '{1_Num} {2_icon}形質から', '', '');
REPLACE INTO Language_JA_JP (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_YIELD_FROM_PROCESSES', '{1_Num} {2_IconString}プロセスから', '', '');
REPLACE INTO Language_JA_JP (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_YIELD_FROM_MINOR_CIVS', '{1_num} {2_icon}都市国家から', '', '');
REPLACE INTO Language_JA_JP (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_CITYSTATE_MODIFIER_FOCUS', '{2_icon}シティーフォーカス：{1_num}％', '', '');
REPLACE INTO Language_JA_JP (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_CITYSTATE_MODIFIER_POPULATION', '[ICON_CITIZEN]人口：{1_num}', '', '');
REPLACE INTO Language_JA_JP (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_CITYSTATE_MODIFIER_NOT_CONNECTED', '[ICON_CONNECTED]接続されていません：{1_num}％', '', '');
REPLACE INTO Language_JA_JP (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_CITYSTATE_MODIFIER_IS_RAZING', '[ICON_RAZING] Razing：{1_num}％', '', '');
REPLACE INTO Language_JA_JP (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_CITYSTATE_MODIFIER_IS_RESISTANCE', '[ICON_RESISTANCE]抵抗：{1_num}％', '', '');
REPLACE INTO Language_JA_JP (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_CITYSTATE_MODIFIER_IS_PUPPET', '[ICON_PUPPET]パペット：{1_num}％', '', '');
REPLACE INTO Language_JA_JP (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_CITYSTATE_MODIFIER_IS_OCCUPIED', '[ICON_OCCUPIED]占有：{1_num}％', '', '');
REPLACE INTO Language_JA_JP (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_CITYSTATE_MODIFIER_IS_BLOCKADED', '{1_num}％：[ICON_BLOCKADED]封鎖', '', '');
REPLACE INTO Language_JA_JP (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_CITYSTATE_MODIFIER_IS_CAPITAL', '[ICON_CAPITAL]資本金：{1_num}％', '', '');
REPLACE INTO Language_JA_JP (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_CITYSTATE_MODIFIER_IS_AVOID', '[ICON_MUSHROOM]成長は避けてください：{1_num}％', '', '');
REPLACE INTO Language_JA_JP (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_CITYSTATE_MODIFIER_IS_AVOID_MANY', '（回避上の都市の{1_num}％以上）', '', '');
REPLACE INTO Language_JA_JP (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_CITYSTATE_MODIFIER_WEIGHT_TOTAL', '{4_num} {5_icon}の{1_num}（都市）/ {2_num}（帝国）= {3_num}％', '', '');
REPLACE INTO Language_JA_JP (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_YIELD_USAGE', '（[COLOR_POSITIVE_TEXT] {1_num} [ENDCOLOR]  -  [COLOR_NEGATIVE_TEXT] {2_num} [ENDCOLOR]消費さ）', '', '');
REPLACE INTO Language_JA_JP (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_YIELD_SURPLUS', '{1_num} {2_icon}剰余金', '', '');
REPLACE INTO Language_JA_JP (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_YIELD_FROM_OTHER_YIELDS', '（{1_num} {2_icon} + {3_num} {4_icon} {5_yieldstring}）', '', '');
REPLACE INTO Language_JA_JP (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_PRODMOD_YIELD_SETTLER_POLICY', '入植者のための[NEWLINE] [ICON_BULLET]ポリシー修飾：{1_num}％', '', '');
REPLACE INTO Language_JA_JP (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_PRODMOD_YIELD_POLICY', '[NEWLINE] [ICON_BULLET]ポリシー修飾：{1_Num}％', '', '');
REPLACE INTO Language_JA_JP (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_PRODMOD_YIELD_BUILDINGS', '[NEWLINE] [ICON_BULLET]ビル修飾：{1_Num}％', '', '');
REPLACE INTO Language_JA_JP (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_PRODMOD_CAPITAL_BUILDING_TRAIT', '[NEWLINE] [ICON_BULLET] [ICON_CAPITAL]キャピタル建物の改質剤：{1_Num}％', '', '');
REPLACE INTO Language_JA_JP (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_YIELD_MOD_GLOBAL_BUILDINGS', '他の都市で[NEWLINE] [ICON_BULLET]建物：{1_Num}％', '', '');
REPLACE INTO Language_JA_JP (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_PRODMOD_YIELD_HAPPINESS', '[NEWLINE] [ICON_BULLET] [COLOR_WARNING_TEXT] [ICON_HAPPINESS_4]不幸修飾：{1_Num}％[ENDCOLOR]', '', '');
REPLACE INTO Language_JA_JP (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_TP_YIELD_FOR_FREE', '[ICON_BULLET] [COLOR_POSITIVE_TEXT] {1_Num} [ENDCOLOR] {2_icon}無料。', '', '');
REPLACE INTO Language_JA_JP (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_TP_YIELD_FROM_CITIES', '[ICON_BULLET] [COLOR_POSITIVE_TEXT] {1_Num} [ENDCOLOR] {2_icon}都市から。', '', '');
REPLACE INTO Language_JA_JP (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_TP_YIELD_FROM_POLICIES', '[ICON_BULLET] [COLOR_POSITIVE_TEXT] {1_Num} [ENDCOLOR] {2_icon}ポリシーから', '', '');
REPLACE INTO Language_JA_JP (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_TP_YIELD_FROM_MINORS', '[ICON_BULLET] [COLOR_POSITIVE_TEXT] {1_Num} [ENDCOLOR] {2_icon}都市国家から。', '', '');
REPLACE INTO Language_JA_JP (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_TP_YIELD_FROM_HAPPINESS', '[ICON_BULLET] [COLOR_POSITIVE_TEXT] {1_Num} [ENDCOLOR] {2_icon}過剰[ICON_HAPPINESS_1]幸福から。', '', '');
REPLACE INTO Language_JA_JP (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_TP_YIELD_FROM_RESEARCH_AGREEMENTS', '[ICON_BULLET] [COLOR_POSITIVE_TEXT] {1_Num} [ENDCOLOR] {2_icon}他のプレイヤーとの研究契約による。', '', '');
REPLACE INTO Language_JA_JP (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_TP_SCIENCE', '[ICON_RESEARCH]科学は、現在の研究プロジェクトに向けて帝国全体で生産されて。', '', '');
REPLACE INTO Language_JA_JP (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_NEXT_POLICY_TURN_LABEL', '{1_Num：番号＃]次の方針に変わり（S）', '', '');








UPDATE LoadedFile SET Value=1, JA_JP=1 Where Type='YieldLibrary.sql';