/* The sql commands and text below were formulated in the CSD tab of the Google Spreadsheet 'Cep_Language'.
https://docs.google.com/spreadsheets/d/1ptQRfVsW7UT_8gPexioizS31sM7K_3eBT3tjr4jruTs/edit#gid=9391984
If you make any changes be sure to update the spreadsheet also.*/

REPLACE INTO Language_KO_KR (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_POLICY_PHILANTHROPY_HELP_EXTRA', '서기관의 학교에서 [NEWLINE] +1 [ICON_HAPPINESS_1] 도시의 행복.', '', '');
REPLACE INTO Language_KO_KR (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_POLICY_CULTURAL_DIPLOMACY_HELP_EXTRA', '외무부에서 [NEWLINE] +3 [ICON_CULTURE] 문화.', '', '');
REPLACE INTO Language_KO_KR (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_POLICY_AESTHETICS_HELP_EXTRA', '구텐베르크 보도에서 [NEWLINE] 20 % [ICON_GOLD] 골드.', '', '');
REPLACE INTO Language_KO_KR (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_POLICY_SCHOLASTICISM_HELP_EXTRA', '우편 서비스에서 [NEWLINE] +10 % [ICON_RESEARCH] 과학.', '', '');
REPLACE INTO Language_KO_KR (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_POLICY_TRADE_PACT_HELP_EXTRA', '[NEWLINE] +2 대사.', '', '');














UPDATE Loaded File SET Value=1, KO_KR=1 Where Type='CSD.sql';



