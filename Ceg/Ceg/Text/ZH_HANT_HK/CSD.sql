/* The sql commands and text below were formulated in the CSD tab of the Google Spreadsheet 'Cep_Language'.
https://docs.google.com/spreadsheets/d/1ptQRfVsW7UT_8gPexioizS31sM7K_3eBT3tjr4jruTs/edit#gid=9391984
If you make any changes be sure to update the spreadsheet also.*/

REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_POLICY_PHILANTHROPY_HELP_EXTRA', '[NEWLINE] 1 [ICON_HAPPINESS_1]城市幸福從文士的學校。', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_POLICY_CULTURAL_DIPLOMACY_HELP_EXTRA', '[NEWLINE] 3 [ICON_CULTURE]文化活動從外交部。', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_POLICY_AESTHETICS_HELP_EXTRA', '[NEWLINE] +20％[ICON_GOLD]黃金從谷登堡出版社。', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_POLICY_SCHOLASTICISM_HELP_EXTRA', '[NEWLINE] +10％[ICON_RESEARCH]科學的郵政服務。', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_POLICY_TRADE_PACT_HELP_EXTRA', '[NEWLINE] +2使節。', '', '');














UPDATE LoadedFile SET Value=1, ZH_HANT_HK=1 Where Type='CSD.sql';



