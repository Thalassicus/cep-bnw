/* The sql commands and text below were formulated in the Barbarians tab of the Google Spreadsheet 'Cep_Language'.
https://docs.google.com/spreadsheets/d/1ptQRfVsW7UT_8gPexioizS31sM7K_3eBT3tjr4jruTs/edit#gid=846200653
If you make any changes be sure to update the spreadsheet also.*/

REPLACE INTO Language_DE_DE (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_UNIT_BARBARIAN_ARCHER', 'Wilderer', '', '');
REPLACE INTO Language_DE_DE (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_UNIT_BARBARIAN_SPEARMAN', 'Pillager', '', '');
REPLACE INTO Language_DE_DE (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_UNIT_BARBARIAN_SWORDSMAN', 'Plünderer', '', '');
REPLACE INTO Language_DE_DE (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_UNIT_BARBARIAN_PIKEMAN', 'Söldner', '', '');
REPLACE INTO Language_DE_DE (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_UNIT_BARBARIAN_CROSSBOWMAN', 'Attentäter', '', '');
REPLACE INTO Language_DE_DE (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_UNIT_BARBARIAN_LONGSWORDSMAN', 'Outlaw', '', '');
REPLACE INTO Language_DE_DE (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_UNIT_BARBARIAN_MUSKETMAN', 'Räuber', '', '');
REPLACE INTO Language_DE_DE (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_UNIT_BARBARIAN_RIFLEMAN', 'Agitator', '', '');
REPLACE INTO Language_DE_DE (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_UNIT_BARBARIAN_INFANTRY', 'Partisan', '', '');
REPLACE INTO Language_DE_DE (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_UNIT_BARBARIAN_PARATROOPER', 'Guerilla', '', '');
REPLACE INTO Language_DE_DE (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_UNIT_BARBARIAN_MECHANIZED_INFANTRY', 'Rebell', '', '');
REPLACE INTO Language_DE_DE (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_UNIT_BARBARIAN_CHARIOT_ARCHER', 'Jäger', '', '');
REPLACE INTO Language_DE_DE (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_UNIT_BARBARIAN_HORSEMAN', 'Marodeur', '', '');
REPLACE INTO Language_DE_DE (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_UNIT_BARBARIAN_KNIGHT', 'Räuber', '', '');
REPLACE INTO Language_DE_DE (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_UNIT_BARBARIAN_LANCER', 'Räuber', '', '');
REPLACE INTO Language_DE_DE (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_UNIT_BARBARIAN_CAVALRY', 'Bandit', '', '');
REPLACE INTO Language_DE_DE (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_UNIT_BARBARIAN_MECH', 'Schelm', '', '');
REPLACE INTO Language_DE_DE (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_UNIT_BARBARIAN_GALLEY', 'Sklavenhändler', '', '');
REPLACE INTO Language_DE_DE (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_UNIT_BARBARIAN_TRIREME', 'Pirat', '', '');
REPLACE INTO Language_DE_DE (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_UNIT_BARBARIAN_GALLEASS', 'Korsar', '', '');
REPLACE INTO Language_DE_DE (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_UNIT_BARBARIAN_FRIGATE', 'Freibeuter', '', '');
REPLACE INTO Language_DE_DE (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_UNIT_BARBARIAN_IRONCLAD', 'Räuber', '', '');
REPLACE INTO Language_DE_DE (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_UNIT_BARBARIAN_SUBMARINE', 'Schmuggler', '', '');





UPDATE LoadedFile SET Value=1, DE_DE=1 Where Type='Barbarians.sql';




