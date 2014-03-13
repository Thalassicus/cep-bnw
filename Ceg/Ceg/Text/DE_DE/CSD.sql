/* The sql commands and text below were formulated in the CSD tab of the Google Spreadsheet 'Cep_Language'.
https://docs.google.com/spreadsheets/d/1ptQRfVsW7UT_8gPexioizS31sM7K_3eBT3tjr4jruTs/edit#gid=9391984
If you make any changes be sure to update the spreadsheet also.*/

REPLACE INTO Language_DE_DE (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_POLICY_PHILANTHROPY_HELP_EXTRA', '[NEWLINE] 1 [ICON_HAPPINESS_1] Stadt Glück aus Schulen der Schriftgelehrten.', '', '');
REPLACE INTO Language_DE_DE (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_POLICY_CULTURAL_DIPLOMACY_HELP_EXTRA', '[NEWLINE] 3 [ICON_CULTURE] Kultur vom Auswärtigen Amt.', '', '');
REPLACE INTO Language_DE_DE (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_POLICY_AESTHETICS_HELP_EXTRA', '[NEWLINE] +20% [ICON_GOLD] Gold aus dem Gutenberg-Presse.', '', '');
REPLACE INTO Language_DE_DE (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_POLICY_SCHOLASTICISM_HELP_EXTRA', '[NEWLINE] +10% [ICON_RESEARCH] Wissenschaft von Postdienstleistungen.', '', '');
REPLACE INTO Language_DE_DE (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_POLICY_TRADE_PACT_HELP_EXTRA', '[NEWLINE] 2 Botschafter.', '', '');














UPDATE LoadedFile SET Value=1, DE_DE=1 Where Type='CSD.sql';



