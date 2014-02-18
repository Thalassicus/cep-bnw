/* The sql commands and text below were formulated in the Framework tab of the Google Spreadsheet 'CAT_Language'.
https://docs.google.com/spreadsheet/ccc?key=0Ap8Ehya83q19dGtjX2JldHBzdXhRbGNxVFgxT1E2OHc&usp=drive_web#gid=9
If you make any changes be sure to update the spreadsheet also.*/
REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_USER_EVENT_OPTION_SELECT', 'Выбирать', '', '');
REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_USER_EVENT_OPTION_OK', 'Хорошо', '', '');
REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_DISTANT_PLAYER', 'неудовлетворенная игрок', '', '');
REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_DISTANT_CITY', 'дальний город', '', '');
REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_DISTANT_UNIT', 'удаленная блок', '', '');
REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_TRIGGER_YIELD_COST', '{1_iconstring} Стоимость: {2_sign} {3_Num}', '', '');
REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_TRIGGER_YIELD_PER_TURN', '{1_iconstring} {2_yieldname}: {3_sign} {4_yield}', '', '');






UPDATE Loaded File SET Value=1, RU_RU=1 Where Type='Framework.sql';
