/* The sql commands and text below were formulated in the Villages tab of the Google Spreadsheet 'CAT_Language'.
https://docs.google.com/spreadsheet/ccc?key=0Ap8Ehya83q19dGtjX2JldHBzdXhRbGNxVFgxT1E2OHc&usp=drive_web#gid=6
If you make any changes be sure to update the spreadsheet also.*/
REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_IMPROVEMENT_TRADING_POST', 'Деревня', '', '');
REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_CIV5_IMPROVEMENTS_TRADING_POST_TEXT', 'Деревня является кластерным человеческое поселение или сообщество с населением от нескольких сотен до нескольких тысяч. Эти небольшие поселения добавить в экономику вашего общества.', '', '');
REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_CIV5_IMPROVEMENTS_TRADINGPOST', 'Деревня', '', '');
REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_GOLD_TRADINGPOST_ADV_QUEST', 'Деревня Предоставляет ли золото?', '', '');
REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_GOLD_TRADINGPOST_HEADING3_BODY', 'Построить улучшение село в плитке, чтобы увеличить добычу золота.', '', '');
REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_GOLD_TRADINGPOST_HEADING3_TITLE', 'Деревня', '', '');
REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_WORKERS_TRADINGPOST_HEADING3_BODY', 'Деревня увеличивает выход плитки на 1 золота. Это не доступ к ресурсу [NEWLINE] Технология Требуется:. Захват [NEWLINE] Строительство Время: 5 Оборотов [NEWLINE] Может быть построена на: Любая земля плитки, но лед', '', '');
REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_POLICY_FREE_THOUGHT_HELP', '[COLOR_POSITIVE_TEXT] Свободная мысль [ENDCOLOR] [NEWLINE] +1 [ICON_RESEARCH] Наука на деревни. +17% [ICON_RESEARCH] Наука из университетов [NEWLINE].', '', '');
REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_BUILD_TRADING_POST', 'Построить [LINK = IMPROVEMENT_TRADING_POST] Village [\ LINK]', '', '');
REPLACE INTO Language_RU_RU (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_BUILD_GOLD_REC', 'Это увеличит количество [ICON_GOLD] Золото, предусмотренных настоящим плитки, повышая количество денег у нас будет потратить!', '', '');








UPDATE LoadedFile SET Value=1, RU_RU=1 Where Type='Villages.sql';