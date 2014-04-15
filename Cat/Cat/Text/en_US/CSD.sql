/* The sql commands and text below were formulated in the CSD tab of the Google Spreadsheet 'Cep_Language'.
https://docs.google.com/spreadsheets/d/1ptQRfVsW7UT_8gPexioizS31sM7K_3eBT3tjr4jruTs/edit#gid=9391984
If you make any changes be sure to update the spreadsheet also.*/

REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_POLICY_PHILANTHROPY_HELP_EXTRA', '[NEWLINE]+1 [ICON_HAPPINESS_1] City Happiness from Schools of Scribes.', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_POLICY_CULTURAL_DIPLOMACY_HELP_EXTRA', '[NEWLINE]+3 [ICON_CULTURE] Culture from Foreign Office.', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_POLICY_AESTHETICS_HELP_EXTRA', '[NEWLINE]+20% [ICON_GOLD] Gold from Gutenberg Press.', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_POLICY_SCHOLASTICISM_HELP_EXTRA', '[NEWLINE]+10% [ICON_RESEARCH] Science from Postal Services.', '', '');
REPLACE INTO Language_en_US (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_POLICY_TRADE_PACT_HELP_EXTRA', '[NEWLINE]+2 Envoys.', '', '');














UPDATE LoadedFile SET Value=1, en_US=1 Where Type='CSD.sql';



