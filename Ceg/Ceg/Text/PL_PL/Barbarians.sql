/* The sql commands and text below were formulated in the Barbarians tab of the Google Spreadsheet 'Cep_Language'.
https://docs.google.com/spreadsheets/d/1ptQRfVsW7UT_8gPexioizS31sM7K_3eBT3tjr4jruTs/edit#gid=846200653
If you make any changes be sure to update the spreadsheet also.*/

REPLACE INTO Language_PL_PL (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_UNIT_BARBARIAN_ARCHER', 'Kłusownik', '', '');
REPLACE INTO Language_PL_PL (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_UNIT_BARBARIAN_SPEARMAN', 'Pillager', '', '');
REPLACE INTO Language_PL_PL (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_UNIT_BARBARIAN_SWORDSMAN', 'Plunderer', '', '');
REPLACE INTO Language_PL_PL (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_UNIT_BARBARIAN_PIKEMAN', 'Najemnik', '', '');
REPLACE INTO Language_PL_PL (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_UNIT_BARBARIAN_CROSSBOWMAN', 'Morderca', '', '');
REPLACE INTO Language_PL_PL (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_UNIT_BARBARIAN_LONGSWORDSMAN', 'Banita', '', '');
REPLACE INTO Language_PL_PL (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_UNIT_BARBARIAN_MUSKETMAN', 'Bandyta', '', '');
REPLACE INTO Language_PL_PL (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_UNIT_BARBARIAN_RIFLEMAN', 'Agitator', '', '');
REPLACE INTO Language_PL_PL (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_UNIT_BARBARIAN_INFANTRY', 'Partyzant', '', '');
REPLACE INTO Language_PL_PL (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_UNIT_BARBARIAN_PARATROOPER', 'Guerilla', '', '');
REPLACE INTO Language_PL_PL (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_UNIT_BARBARIAN_MECHANIZED_INFANTRY', 'Buntownik', '', '');
REPLACE INTO Language_PL_PL (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_UNIT_BARBARIAN_CHARIOT_ARCHER', 'Hunter', '', '');
REPLACE INTO Language_PL_PL (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_UNIT_BARBARIAN_HORSEMAN', 'Rabuś', '', '');
REPLACE INTO Language_PL_PL (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_UNIT_BARBARIAN_KNIGHT', 'Złodziej', '', '');
REPLACE INTO Language_PL_PL (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_UNIT_BARBARIAN_LANCER', 'Rozbójnik', '', '');
REPLACE INTO Language_PL_PL (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_UNIT_BARBARIAN_CAVALRY', 'Bandyta', '', '');
REPLACE INTO Language_PL_PL (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_UNIT_BARBARIAN_MECH', 'Łobuz', '', '');
REPLACE INTO Language_PL_PL (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_UNIT_BARBARIAN_GALLEY', 'Ślinić', '', '');
REPLACE INTO Language_PL_PL (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_UNIT_BARBARIAN_TRIREME', 'Pirat', '', '');
REPLACE INTO Language_PL_PL (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_UNIT_BARBARIAN_GALLEASS', 'Korsarz', '', '');
REPLACE INTO Language_PL_PL (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_UNIT_BARBARIAN_FRIGATE', 'Kaper', '', '');
REPLACE INTO Language_PL_PL (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_UNIT_BARBARIAN_IRONCLAD', 'Korsarz', '', '');
REPLACE INTO Language_PL_PL (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_UNIT_BARBARIAN_SUBMARINE', 'Przemytnik', '', '');





UPDATE LoadedFile SET Value=1, PL_PL=1 Where Type='Barbarians.sql';




