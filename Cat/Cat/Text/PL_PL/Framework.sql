/* The sql commands and text below were formulated in the Framework tab of the Google Spreadsheet 'CAT_Language'.
https://docs.google.com/spreadsheet/ccc?key=0Ap8Ehya83q19dGtjX2JldHBzdXhRbGNxVFgxT1E2OHc&usp=drive_web#gid=9
If you make any changes be sure to update the spreadsheet also.*/
REPLACE INTO Language_PL_PL (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_USER_EVENT_OPTION_SELECT', 'Wybierać', '', '');
REPLACE INTO Language_PL_PL (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_USER_EVENT_OPTION_OK', 'Dobrze', '', '');
REPLACE INTO Language_PL_PL (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_DISTANT_PLAYER', 'niezaspokojone gracz', '', '');
REPLACE INTO Language_PL_PL (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_DISTANT_CITY', 'odległe miasto', '', '');
REPLACE INTO Language_PL_PL (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_DISTANT_UNIT', 'Jednostka odległe', '', '');
REPLACE INTO Language_PL_PL (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_TRIGGER_YIELD_COST', '{1_iconstring} Koszt: {2_sign} {3_num}', '', '');
REPLACE INTO Language_PL_PL (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_TRIGGER_YIELD_PER_TURN', '{1_iconstring} {2_yieldname}: {3_sign} {4_yield}', '', '');






UPDATE LoadedFile SET Value=1, PL_PL=1 Where Type='Framework.sql';
