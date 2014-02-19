/* The sql commands and text below were formulated in the Villages tab of the Google Spreadsheet 'CAT_Language'.
https://docs.google.com/spreadsheet/ccc?key=0Ap8Ehya83q19dGtjX2JldHBzdXhRbGNxVFgxT1E2OHc&usp=drive_web#gid=6
If you make any changes be sure to update the spreadsheet also.*/
REPLACE INTO Language_PL_PL (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_IMPROVEMENT_TRADING_POST', 'Wieś', '', '');
REPLACE INTO Language_PL_PL (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_CIV5_IMPROVEMENTS_TRADING_POST_TEXT', 'Wieś jest osada ludzka klastra lub społeczności z ludnością w zakresie od kilkuset do kilku tysięcy. Te małe osady dodać do gospodarki swojego społeczeństwa.', '', '');
REPLACE INTO Language_PL_PL (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_CIV5_IMPROVEMENTS_TRADINGPOST', 'Wieś', '', '');
REPLACE INTO Language_PL_PL (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_GOLD_TRADINGPOST_ADV_QUEST', 'Czy wieś dostarczyć złoto?', '', '');
REPLACE INTO Language_PL_PL (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_GOLD_TRADINGPOST_HEADING3_BODY', 'Skonstruować lepszy osadę w płytkę zwiększenie wydobycia złota.', '', '');
REPLACE INTO Language_PL_PL (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_GOLD_TRADINGPOST_HEADING3_TITLE', 'Wieś', '', '');
REPLACE INTO Language_PL_PL (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_WORKERS_TRADINGPOST_HEADING3_BODY', 'Wioska zwiększa moc o 1 płytki złota. Nie ma dostępu do zasobu [NEWLINE] Technologia Wymagania:. Wychwytywanie [NEWLINE] Czas budowy: 5 tur [NEWLINE] może zostać skonstruowana na: Dowolna płytki terenu, ale lód', '', '');
REPLACE INTO Language_PL_PL (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_POLICY_FREE_THOUGHT_HELP', '[COLOR_POSITIVE_TEXT] wolnej myśli [ENDCOLOR] [NEWLINE] +1 [ICON_RESEARCH] Nauka na wsi. [NEWLINE] +17% [ICON_RESEARCH] Nauka z uniwersytetów.', '', '');
REPLACE INTO Language_PL_PL (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_BUILD_TRADING_POST', 'Skonstruować [LINK = IMPROVEMENT_TRADING_POST] Wieś [\ LINK]', '', '');
REPLACE INTO Language_PL_PL (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_BUILD_GOLD_REC', 'Pozwoli to na zwiększenie ilości [ICON_GOLD] Złoto świadczonych przez tego płytki, zwiększenie ilości pieniędzy będziemy musieli wydać!', '', '');








UPDATE Loaded File SET Value=1, PL_PL=1 Where Type='Villages.sql';