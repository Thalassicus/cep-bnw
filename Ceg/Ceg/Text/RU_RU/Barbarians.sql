/* The sql commands and text below were formulated in the Barbarians tab of the Google Spreadsheet 'Cep_Language'.
https://docs.google.com/spreadsheets/d/1ptQRfVsW7UT_8gPexioizS31sM7K_3eBT3tjr4jruTs/edit#gid=846200653
If you make any changes be sure to update the spreadsheet also.*/

REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_UNIT_BARBARIAN_ARCHER', 'Браконьер', '', '');
REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_UNIT_BARBARIAN_SPEARMAN', 'Мародер', '', '');
REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_UNIT_BARBARIAN_SWORDSMAN', 'Грабитель', '', '');
REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_UNIT_BARBARIAN_PIKEMAN', 'Наемник', '', '');
REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_UNIT_BARBARIAN_CROSSBOWMAN', 'Убийца', '', '');
REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_UNIT_BARBARIAN_LONGSWORDSMAN', 'Вне закона', '', '');
REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_UNIT_BARBARIAN_MUSKETMAN', 'Разбойник', '', '');
REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_UNIT_BARBARIAN_RIFLEMAN', 'Агитатор', '', '');
REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_UNIT_BARBARIAN_INFANTRY', 'Партизан', '', '');
REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_UNIT_BARBARIAN_PARATROOPER', 'Партизанский', '', '');
REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_UNIT_BARBARIAN_MECHANIZED_INFANTRY', 'Мятежник', '', '');
REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_UNIT_BARBARIAN_CHARIOT_ARCHER', 'Охотник', '', '');
REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_UNIT_BARBARIAN_HORSEMAN', 'Мародер', '', '');
REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_UNIT_BARBARIAN_KNIGHT', 'Грабитель', '', '');
REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_UNIT_BARBARIAN_LANCER', 'Разбойник', '', '');
REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_UNIT_BARBARIAN_CAVALRY', 'Бандит', '', '');
REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_UNIT_BARBARIAN_MECH', 'Жулик', '', '');
REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_UNIT_BARBARIAN_GALLEY', 'Работорговец', '', '');
REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_UNIT_BARBARIAN_TRIREME', 'Пират', '', '');
REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_UNIT_BARBARIAN_GALLEASS', 'Корсар', '', '');
REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_UNIT_BARBARIAN_FRIGATE', 'Капер', '', '');
REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_UNIT_BARBARIAN_IRONCLAD', 'Рейдер', '', '');
REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_UNIT_BARBARIAN_SUBMARINE', 'Контрабандист', '', '');





UPDATE LoadedFile SET Value=1, RU_RU=1 Where Type='Barbarians.sql';




