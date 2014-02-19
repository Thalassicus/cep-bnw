/* The sql commands and text below were formulated in the Villages tab of the Google Spreadsheet 'CAT_Language'.
https://docs.google.com/spreadsheet/ccc?key=0Ap8Ehya83q19dGtjX2JldHBzdXhRbGNxVFgxT1E2OHc&usp=drive_web#gid=6
If you make any changes be sure to update the spreadsheet also.*/
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_IMPROVEMENT_TRADING_POST', '村', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_CIV5_IMPROVEMENTS_TRADING_POST_TEXT', '一個村莊是一個群集的人類住區和社區，人口從幾百到幾千。這些小定居點添加到您的社會的經濟。', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_CIV5_IMPROVEMENTS_TRADINGPOST', '村', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_GOLD_TRADINGPOST_ADV_QUEST', '難道村里提供黃金？', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_GOLD_TRADINGPOST_HEADING3_BODY', '構建在一個平鋪的一個村莊的改善，以增加其黃金產量。', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_GOLD_TRADINGPOST_HEADING3_TITLE', '村', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_WORKERS_TRADINGPOST_HEADING3_BODY', '村由1個金幣提高瓷磚的輸出。它不訪問資源[NEWLINE]技術要求：。補漏[NEWLINE]建造時間：5圈[NEWLINE]可以構造上：任何土地瓷磚但冰', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_POLICY_FREE_THOUGHT_HELP', '[COLOR_POSITIVE_TEXT]自由思考[ENDCOLOR] [NEWLINE] 1 [ICON_RESEARCH]科學上村。[NEWLINE] +17％[ICON_RESEARCH]科學的大學。', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_BUILD_TRADING_POST', '構造一個[LINK = IMPROVEMENT_TRADING_POST]村[\ LINK]', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_BUILD_GOLD_REC', '這無疑增加了該瓷磚提供黃金[ICON_GOLD]量，提高資金的金額，我們將不得不花費！', '', '');








UPDATE Loaded File SET Value=1, ZH_HANT_HK=1 Where Type='Villages.sql';