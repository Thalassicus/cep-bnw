/* The sql commands and text below were formulated in the Barbarians tab of the Google Spreadsheet 'Cep_Language'.
https://docs.google.com/spreadsheets/d/1ptQRfVsW7UT_8gPexioizS31sM7K_3eBT3tjr4jruTs/edit#gid=846200653
If you make any changes be sure to update the spreadsheet also.*/

REPLACE INTO Language_IT_IT (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_UNIT_BARBARIAN_ARCHER', 'Bracconiere', '', '');
REPLACE INTO Language_IT_IT (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_UNIT_BARBARIAN_SPEARMAN', 'Saccheggiatore', '', '');
REPLACE INTO Language_IT_IT (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_UNIT_BARBARIAN_SWORDSMAN', 'Saccheggiatore', '', '');
REPLACE INTO Language_IT_IT (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_UNIT_BARBARIAN_PIKEMAN', 'Mercenario', '', '');
REPLACE INTO Language_IT_IT (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_UNIT_BARBARIAN_CROSSBOWMAN', 'Assassino', '', '');
REPLACE INTO Language_IT_IT (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_UNIT_BARBARIAN_LONGSWORDSMAN', 'Outlaw', '', '');
REPLACE INTO Language_IT_IT (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_UNIT_BARBARIAN_MUSKETMAN', 'Brigante', '', '');
REPLACE INTO Language_IT_IT (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_UNIT_BARBARIAN_RIFLEMAN', 'Agitatore', '', '');
REPLACE INTO Language_IT_IT (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_UNIT_BARBARIAN_INFANTRY', 'Partigiano', '', '');
REPLACE INTO Language_IT_IT (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_UNIT_BARBARIAN_PARATROOPER', 'Guerriglia', '', '');
REPLACE INTO Language_IT_IT (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_UNIT_BARBARIAN_MECHANIZED_INFANTRY', 'Ribelle', '', '');
REPLACE INTO Language_IT_IT (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_UNIT_BARBARIAN_CHARIOT_ARCHER', 'Cacciatore', '', '');
REPLACE INTO Language_IT_IT (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_UNIT_BARBARIAN_HORSEMAN', 'Predone', '', '');
REPLACE INTO Language_IT_IT (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_UNIT_BARBARIAN_KNIGHT', 'Rapinatore', '', '');
REPLACE INTO Language_IT_IT (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_UNIT_BARBARIAN_LANCER', 'Bandito', '', '');
REPLACE INTO Language_IT_IT (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_UNIT_BARBARIAN_CAVALRY', 'Bandito', '', '');
REPLACE INTO Language_IT_IT (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_UNIT_BARBARIAN_MECH', 'Briccone', '', '');
REPLACE INTO Language_IT_IT (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_UNIT_BARBARIAN_GALLEY', 'Schiavista', '', '');
REPLACE INTO Language_IT_IT (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_UNIT_BARBARIAN_TRIREME', 'Pirata', '', '');
REPLACE INTO Language_IT_IT (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_UNIT_BARBARIAN_GALLEASS', 'Corsaro', '', '');
REPLACE INTO Language_IT_IT (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_UNIT_BARBARIAN_FRIGATE', 'Nave corsara', '', '');
REPLACE INTO Language_IT_IT (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_UNIT_BARBARIAN_IRONCLAD', 'Bandito', '', '');
REPLACE INTO Language_IT_IT (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_UNIT_BARBARIAN_SUBMARINE', 'Contrabbandiere', '', '');





UPDATE LoadedFile SET Value=1, IT_IT=1 Where Type='Barbarians.sql';




