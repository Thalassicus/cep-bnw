/* The sql commands and text below were formulated in the Villages tab of the Google Spreadsheet 'CAT_Language'.
https://docs.google.com/spreadsheet/ccc?key=0Ap8Ehya83q19dGtjX2JldHBzdXhRbGNxVFgxT1E2OHc&usp=drive_web#gid=6
If you make any changes be sure to update the spreadsheet also.*/
REPLACE INTO Language_DE_DE (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_IMPROVEMENT_TRADING_POST', 'Dorf', '', '');
REPLACE INTO Language_DE_DE (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_CIV5_IMPROVEMENTS_TRADING_POST_TEXT', 'Ein Dorf ist eine gruppierte menschliche Siedlung oder Gemeinde mit einer Bevölkerung von ein paar hundert bis ein paar tausend. Diese kleinen Siedlungen, um eurer Gesellschaft Wirtschaft hinzuzufügen.', '', '');
REPLACE INTO Language_DE_DE (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_CIV5_IMPROVEMENTS_TRADINGPOST', 'Dorf', '', '');
REPLACE INTO Language_DE_DE (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_GOLD_TRADINGPOST_ADV_QUEST', 'Hat das Dorf bieten Gold?', '', '');
REPLACE INTO Language_DE_DE (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_GOLD_TRADINGPOST_HEADING3_BODY', 'Konstruieren Sie eine Verbesserung Dorf in einer Kachel, seine Goldproduktion zu erhöhen.', '', '');
REPLACE INTO Language_DE_DE (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_GOLD_TRADINGPOST_HEADING3_TITLE', 'Das Dorf', '', '');
REPLACE INTO Language_DE_DE (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_WORKERS_TRADINGPOST_HEADING3_BODY', 'Das Dorf erhöht Ausgang einer Fliese um 1 Gold. Es ist nicht eine Ressource zugreifen [NEWLINE] Erforderliche Technologie:. Trapping [NEWLINE] Baudauer: 5 Runden [NEWLINE] konstruiert werden On: Alle Landkärtchen, aber Eis', '', '');
REPLACE INTO Language_DE_DE (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_POLICY_FREE_THOUGHT_HELP', '[COLOR_POSITIVE_TEXT] Free Thought [ENDCOLOR] [NEWLINE] 1 [ICON_RESEARCH] Science on Dorf. [NEWLINE] 17% [ICON_RESEARCH] Wissenschaften von Universitäten.', '', '');
REPLACE INTO Language_DE_DE (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_BUILD_TRADING_POST', 'Konstruieren Sie eine [LINK = IMPROVEMENT_TRADING_POST] Dorf [\ LINK]', '', '');
REPLACE INTO Language_DE_DE (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_BUILD_GOLD_REC', 'Es wird die Menge an [ICON_GOLD] Gold von dieser Fliese vorgesehen zu erhöhen, die Steigerung der Menge an Geld, das wir haben, zu verbringen!', '', '');








UPDATE LoadedFile SET Value=1, DE_DE=1 Where Type='Villages.sql';