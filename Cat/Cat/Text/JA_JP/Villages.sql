/* The sql commands and text below were formulated in the Villages tab of the Google Spreadsheet 'CAT_Language'.
https://docs.google.com/spreadsheet/ccc?key=0Ap8Ehya83q19dGtjX2JldHBzdXhRbGNxVFgxT1E2OHc&usp=drive_web#gid=6
If you make any changes be sure to update the spreadsheet also.*/
REPLACE INTO Language_JA_JP (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_IMPROVEMENT_TRADING_POST', '村', '', '');
REPLACE INTO Language_JA_JP (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_CIV5_IMPROVEMENTS_TRADING_POST_TEXT', '村は、数百から数千に及ぶ人口を持つクラスタ化された人間の居住またはコミュニティです。これらの小さな集落は、社会の経済に追加します。', '', '');
REPLACE INTO Language_JA_JP (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_CIV5_IMPROVEMENTS_TRADINGPOST', '村', '', '');
REPLACE INTO Language_JA_JP (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_GOLD_TRADINGPOST_ADV_QUEST', '村は金を提供していますか？', '', '');
REPLACE INTO Language_JA_JP (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_GOLD_TRADINGPOST_HEADING3_BODY', '金色の出力を高めるために、タイルの村の改善を構築します。', '', '');
REPLACE INTO Language_JA_JP (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_GOLD_TRADINGPOST_HEADING3_TITLE', '村', '', '');
REPLACE INTO Language_JA_JP (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_WORKERS_TRADINGPOST_HEADING3_BODY', '村は1金でタイルの出力を増加させる。これは、リソースにアクセスできません[NEWLINE]テクノロジー必須：。トラッピング[NEWLINE]の構築時間：任意の土地のタイルが、氷：5ターンが[NEWLINE]で構築することができる', '', '');
REPLACE INTO Language_JA_JP (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_POLICY_FREE_THOUGHT_HELP', '大学から[COLOR_POSITIVE_TEXT]自由思想村の[ENDCOLOR] [NEWLINE] 1 [ICON_RESEARCH]サイエンス[NEWLINE] 17パーセント[ICON_RESEARCH]科学。', '', '');
REPLACE INTO Language_JA_JP (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_BUILD_TRADING_POST', '[LINK = IMPROVEMENT_TRADING_POST]ヴィレッジ[\ LINK]を構築する', '', '');
REPLACE INTO Language_JA_JP (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_BUILD_GOLD_REC', 'それは我々が費やす必要がお金の量を高め、このタイルが提供する[ICON_GOLD]金の量が増加します！', '', '');








UPDATE LoadedFile SET Value=1, JA_JP=1 Where Type='Villages.sql';