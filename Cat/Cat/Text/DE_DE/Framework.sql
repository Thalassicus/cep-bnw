/* The sql commands and text below were formulated in the Framework tab of the Google Spreadsheet 'CAT_Language'.
https://docs.google.com/spreadsheet/ccc?key=0Ap8Ehya83q19dGtjX2JldHBzdXhRbGNxVFgxT1E2OHc&usp=drive_web#gid=9
If you make any changes be sure to update the spreadsheet also.*/
REPLACE INTO Language_DE_DE (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_USER_EVENT_OPTION_SELECT', 'Wählen', '', '');
REPLACE INTO Language_DE_DE (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_USER_EVENT_OPTION_OK', 'Ok', '', '');
REPLACE INTO Language_DE_DE (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_DISTANT_PLAYER', 'ein ungedeckter Spieler', '', '');
REPLACE INTO Language_DE_DE (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_DISTANT_CITY', 'eine ferne Stadt', '', '');
REPLACE INTO Language_DE_DE (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_DISTANT_UNIT', 'fernen Einheit', '', '');
REPLACE INTO Language_DE_DE (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_TRIGGER_YIELD_COST', '{1_iconstring} Kosten: {2_sign} {3_num}', '', '');
REPLACE INTO Language_DE_DE (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_TRIGGER_YIELD_PER_TURN', '{1_iconstring} {2_yieldname}: {3_sign} {4_yield}', '', '');






UPDATE LoadedFile SET Value=1, DE_DE=1 Where Type='Framework.sql';
