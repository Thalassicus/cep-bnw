/* The sql commands and text below were formulated in the Framework tab of the Google Spreadsheet 'CAT_Language'.
https://docs.google.com/spreadsheet/ccc?key=0Ap8Ehya83q19dGtjX2JldHBzdXhRbGNxVFgxT1E2OHc&usp=drive_web#gid=9
If you make any changes be sure to update the spreadsheet also.*/
REPLACE INTO Language_KO_KR (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_USER_EVENT_OPTION_SELECT', '선택', '', '');
REPLACE INTO Language_KO_KR (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_USER_EVENT_OPTION_OK', 'OK', '', '');
REPLACE INTO Language_KO_KR (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_DISTANT_PLAYER', '충족 플레이어', '', '');
REPLACE INTO Language_KO_KR (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_DISTANT_CITY', '먼 도시', '', '');
REPLACE INTO Language_KO_KR (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_DISTANT_UNIT', '먼 단위', '', '');
REPLACE INTO Language_KO_KR (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_TRIGGER_YIELD_COST', '{1_iconstring] 비용 : {2_sign} {3_num]', '', '');
REPLACE INTO Language_KO_KR (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_TRIGGER_YIELD_PER_TURN', '{1_iconstring} {2_yieldname} {3_sign} {4_yield]', '', '');






UPDATE Loaded File SET Value=1, KO_KR=1 Where Type='Framework.sql';
