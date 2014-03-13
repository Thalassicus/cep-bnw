/* The sql commands and text below were formulated in the Villages tab of the Google Spreadsheet 'CAT_Language'.
https://docs.google.com/spreadsheet/ccc?key=0Ap8Ehya83q19dGtjX2JldHBzdXhRbGNxVFgxT1E2OHc&usp=drive_web#gid=6
If you make any changes be sure to update the spreadsheet also.*/
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_IMPROVEMENT_TRADING_POST', 'Village', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_CIV5_IMPROVEMENTS_TRADING_POST_TEXT', 'A village is a clustered human settlement or community with a population ranging from a few hundred to a few thousands. These small settlements add to your society''s economy.', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_CIV5_IMPROVEMENTS_TRADINGPOST', 'Village', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_GOLD_TRADINGPOST_ADV_QUEST', 'Does the village provide gold?', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_GOLD_TRADINGPOST_HEADING3_BODY', 'Construct a village improvement in a tile to increase its gold output.', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_GOLD_TRADINGPOST_HEADING3_TITLE', 'The village', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_WORKERS_TRADINGPOST_HEADING3_BODY', 'The Village increases output of a tile by 1 gold. It doesn''t access a resource.[NEWLINE]Technology Required: Trapping[NEWLINE]Construction Time: 5 Turns[NEWLINE]May Be Constructed On: Any land tile but ice', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_POLICY_FREE_THOUGHT_HELP', '[COLOR_POSITIVE_TEXT]Free Thought[ENDCOLOR][NEWLINE]+1 [ICON_RESEARCH] Science on Villages.[NEWLINE]+17% [ICON_RESEARCH] Science from Universities.', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_BUILD_TRADING_POST', 'Construct a [LINK=IMPROVEMENT_TRADING_POST]Village[\LINK]', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_BUILD_GOLD_REC', 'It will increase the amount of [ICON_GOLD] Gold provided by this tile, boosting the amount of money we will have to spend!', '', '');








UPDATE LoadedFile SET Value=1, en_US=1 Where Type='Villages.sql';