/* The sql commands and text below were formulated in the Framework tab of the Google Spreadsheet 'CAT_Language'.
https://docs.google.com/spreadsheet/ccc?key=0Ap8Ehya83q19dGtjX2JldHBzdXhRbGNxVFgxT1E2OHc&usp=drive_web#gid=9
If you make any changes be sure to update the spreadsheet also.*/
REPLACE INTO Language_IT_IT (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_USER_EVENT_OPTION_SELECT', 'Selezionare', '', '');
REPLACE INTO Language_IT_IT (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_USER_EVENT_OPTION_OK', 'Bene', '', '');
REPLACE INTO Language_IT_IT (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_DISTANT_PLAYER', 'un lettore insoddisfatto', '', '');
REPLACE INTO Language_IT_IT (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_DISTANT_CITY', 'una città lontana', '', '');
REPLACE INTO Language_IT_IT (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_DISTANT_UNIT', 'unità lontana', '', '');
REPLACE INTO Language_IT_IT (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_TRIGGER_YIELD_COST', '{1_iconstring} Costo: {2_sign} {3_num}', '', '');
REPLACE INTO Language_IT_IT (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_TRIGGER_YIELD_PER_TURN', '{1_iconstring} {2_yieldname}: {3_sign} {4_yield}', '', '');






UPDATE LoadedFile SET Value=1, IT_IT=1 Where Type='Framework.sql';
