/* The sql commands and text below were formulated in the CSD tab of the Google Spreadsheet 'Cep_Language'.
https://docs.google.com/spreadsheets/d/1ptQRfVsW7UT_8gPexioizS31sM7K_3eBT3tjr4jruTs/edit#gid=9391984
If you make any changes be sure to update the spreadsheet also.*/

REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_POLICY_PHILANTHROPY_HELP_EXTRA', '[NEWLINE] +1 [ICON_HAPPINESS_1] Город Счастье от школ писцов.', '', '');
REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_POLICY_CULTURAL_DIPLOMACY_HELP_EXTRA', '[NEWLINE] +3 [ICON_CULTURE] Культура от министерства иностранных дел.', '', '');
REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_POLICY_AESTHETICS_HELP_EXTRA', '[NEWLINE] +20% [ICON_GOLD] Золото от Гутенберга Press.', '', '');
REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_POLICY_SCHOLASTICISM_HELP_EXTRA', '[NEWLINE] +10% [ICON_RESEARCH] Наука из почтовых служб.', '', '');
REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_POLICY_TRADE_PACT_HELP_EXTRA', '[NEWLINE] 2 посланники.', '', '');














UPDATE Loaded File SET Value=1, RU_RU=1 Where Type='CSD.sql';



