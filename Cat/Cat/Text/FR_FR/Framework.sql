/* The sql commands and text below were formulated in the Framework tab of the Google Spreadsheet 'CAT_Language'.
https://docs.google.com/spreadsheet/ccc?key=0Ap8Ehya83q19dGtjX2JldHBzdXhRbGNxVFgxT1E2OHc&usp=drive_web#gid=9
If you make any changes be sure to update the spreadsheet also.*/
REPLACE INTO Language_FR_FR (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_USER_EVENT_OPTION_SELECT', 'Sélectionner', '', '');
REPLACE INTO Language_FR_FR (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_USER_EVENT_OPTION_OK', 'Bien', '', '');
REPLACE INTO Language_FR_FR (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_DISTANT_PLAYER', 'un joueur non satisfaits', '', '');
REPLACE INTO Language_FR_FR (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_DISTANT_CITY', 'une ville lointaine', '', '');
REPLACE INTO Language_FR_FR (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_DISTANT_UNIT', 'Unité distante', '', '');
REPLACE INTO Language_FR_FR (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_TRIGGER_YIELD_COST', '{1_iconstring} Coût: {2_sign} {3_num}', '', '');
REPLACE INTO Language_FR_FR (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_TRIGGER_YIELD_PER_TURN', '{1_iconstring} {2_yieldname}: {3_sign} {4_yield}', '', '');






UPDATE Loaded File SET Value=1, FR_FR=1 Where Type='Framework.sql';
