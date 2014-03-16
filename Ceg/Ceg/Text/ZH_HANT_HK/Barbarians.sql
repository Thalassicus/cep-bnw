/* The sql commands and text below were formulated in the Barbarians tab of the Google Spreadsheet 'Cep_Language'.
https://docs.google.com/spreadsheets/d/1ptQRfVsW7UT_8gPexioizS31sM7K_3eBT3tjr4jruTs/edit#gid=846200653
If you make any changes be sure to update the spreadsheet also.*/

REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_UNIT_BARBARIAN_ARCHER', '偷獵者', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_UNIT_BARBARIAN_SPEARMAN', '亂兵', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_UNIT_BARBARIAN_SWORDSMAN', '掠奪者', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_UNIT_BARBARIAN_PIKEMAN', '僱傭兵', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_UNIT_BARBARIAN_CROSSBOWMAN', '刺客', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_UNIT_BARBARIAN_LONGSWORDSMAN', '取締', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_UNIT_BARBARIAN_MUSKETMAN', '匪', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_UNIT_BARBARIAN_RIFLEMAN', '攪拌器', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_UNIT_BARBARIAN_INFANTRY', '黨派', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_UNIT_BARBARIAN_PARATROOPER', '游擊隊', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_UNIT_BARBARIAN_MECHANIZED_INFANTRY', '反叛', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_UNIT_BARBARIAN_CHARIOT_ARCHER', '獵人', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_UNIT_BARBARIAN_HORSEMAN', '掠奪者', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_UNIT_BARBARIAN_KNIGHT', '強盜', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_UNIT_BARBARIAN_LANCER', '強盜', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_UNIT_BARBARIAN_CAVALRY', '強盜', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_UNIT_BARBARIAN_MECH', '流氓', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_UNIT_BARBARIAN_GALLEY', '垂涎', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_UNIT_BARBARIAN_TRIREME', '海盜', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_UNIT_BARBARIAN_GALLEASS', '海盜', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_UNIT_BARBARIAN_FRIGATE', '私', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_UNIT_BARBARIAN_IRONCLAD', '侵入者', '', '');
REPLACE INTO Language_ZH_HANT_HK (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_UNIT_BARBARIAN_SUBMARINE', '走私者', '', '');





UPDATE LoadedFile SET Value=1, ZH_HANT_HK=1 Where Type='Barbarians.sql';




