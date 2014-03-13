/* The sql commands and text below were formulated in the Barbarians tab of the Google Spreadsheet 'Cep_Language'.
https://docs.google.com/spreadsheets/d/1ptQRfVsW7UT_8gPexioizS31sM7K_3eBT3tjr4jruTs/edit#gid=846200653
If you make any changes be sure to update the spreadsheet also.*/

REPLACE INTO Language_KO_KR (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_UNIT_BARBARIAN_ARCHER', '밀렵 자', '', '');
REPLACE INTO Language_KO_KR (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_UNIT_BARBARIAN_SPEARMAN', 'Pillager에', '', '');
REPLACE INTO Language_KO_KR (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_UNIT_BARBARIAN_SWORDSMAN', '약탈자', '', '');
REPLACE INTO Language_KO_KR (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_UNIT_BARBARIAN_PIKEMAN', '용병', '', '');
REPLACE INTO Language_KO_KR (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_UNIT_BARBARIAN_CROSSBOWMAN', '암살자', '', '');
REPLACE INTO Language_KO_KR (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_UNIT_BARBARIAN_LONGSWORDSMAN', '법률의 보호 밖에 두다', '', '');
REPLACE INTO Language_KO_KR (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_UNIT_BARBARIAN_MUSKETMAN', '산적', '', '');
REPLACE INTO Language_KO_KR (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_UNIT_BARBARIAN_RIFLEMAN', '교반기', '', '');
REPLACE INTO Language_KO_KR (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_UNIT_BARBARIAN_INFANTRY', '당파', '', '');
REPLACE INTO Language_KO_KR (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_UNIT_BARBARIAN_PARATROOPER', '비정규 병', '', '');
REPLACE INTO Language_KO_KR (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_UNIT_BARBARIAN_MECHANIZED_INFANTRY', '반역자', '', '');
REPLACE INTO Language_KO_KR (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_UNIT_BARBARIAN_CHARIOT_ARCHER', '사냥꾼', '', '');
REPLACE INTO Language_KO_KR (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_UNIT_BARBARIAN_HORSEMAN', '약탈자', '', '');
REPLACE INTO Language_KO_KR (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_UNIT_BARBARIAN_KNIGHT', '강도', '', '');
REPLACE INTO Language_KO_KR (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_UNIT_BARBARIAN_LANCER', '노상 강도', '', '');
REPLACE INTO Language_KO_KR (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_UNIT_BARBARIAN_CAVALRY', '산적', '', '');
REPLACE INTO Language_KO_KR (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_UNIT_BARBARIAN_MECH', '악당', '', '');
REPLACE INTO Language_KO_KR (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_UNIT_BARBARIAN_GALLEY', '군침', '', '');
REPLACE INTO Language_KO_KR (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_UNIT_BARBARIAN_TRIREME', '해적', '', '');
REPLACE INTO Language_KO_KR (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_UNIT_BARBARIAN_GALLEASS', '해적', '', '');
REPLACE INTO Language_KO_KR (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_UNIT_BARBARIAN_FRIGATE', '사략 선', '', '');
REPLACE INTO Language_KO_KR (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_UNIT_BARBARIAN_IRONCLAD', '침입자', '', '');
REPLACE INTO Language_KO_KR (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_UNIT_BARBARIAN_SUBMARINE', '밀수 입자', '', '');





UPDATE LoadedFile SET Value=1, KO_KR=1 Where Type='Barbarians.sql';




