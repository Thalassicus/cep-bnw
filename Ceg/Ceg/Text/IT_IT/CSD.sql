/* The sql commands and text below were formulated in the CSD tab of the Google Spreadsheet 'Cep_Language'.
https://docs.google.com/spreadsheets/d/1ptQRfVsW7UT_8gPexioizS31sM7K_3eBT3tjr4jruTs/edit#gid=9391984
If you make any changes be sure to update the spreadsheet also.*/

REPLACE INTO Language_IT_IT (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_POLICY_PHILANTHROPY_HELP_EXTRA', '[NEWLINE] 1 [ICON_HAPPINESS_1] Città Felicità da scuole di scribi.', '', '');
REPLACE INTO Language_IT_IT (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_POLICY_CULTURAL_DIPLOMACY_HELP_EXTRA', '[NEWLINE] +3 Cultura [ICON_CULTURE] dal Foreign Office.', '', '');
REPLACE INTO Language_IT_IT (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_POLICY_AESTHETICS_HELP_EXTRA', '[NEWLINE] +20% [ICON_GOLD] oro da stampa di Gutenberg.', '', '');
REPLACE INTO Language_IT_IT (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_POLICY_SCHOLASTICISM_HELP_EXTRA', '[NEWLINE] +10% [ICON_RESEARCH] Scienza da servizi postali.', '', '');
REPLACE INTO Language_IT_IT (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_POLICY_TRADE_PACT_HELP_EXTRA', '[NEWLINE] 2 Inviati.', '', '');














UPDATE LoadedFile SET Value=1, IT_IT=1 Where Type='CSD.sql';



