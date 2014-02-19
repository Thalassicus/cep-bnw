/* The sql commands and text below were formulated in the Villages tab of the Google Spreadsheet 'CAT_Language'.
https://docs.google.com/spreadsheet/ccc?key=0Ap8Ehya83q19dGtjX2JldHBzdXhRbGNxVFgxT1E2OHc&usp=drive_web#gid=6
If you make any changes be sure to update the spreadsheet also.*/
REPLACE INTO Language_ES_ES (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_IMPROVEMENT_TRADING_POST', 'Pueblo', '', '');
REPLACE INTO Language_ES_ES (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_CIV5_IMPROVEMENTS_TRADING_POST_TEXT', 'Un pueblo es un asentamiento humano agrupado o comunidad con una población que van desde unos pocos cientos a unos pocos miles. Estos pequeños asentamientos se suman a la economía de su sociedad.', '', '');
REPLACE INTO Language_ES_ES (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_CIV5_IMPROVEMENTS_TRADINGPOST', 'Pueblo', '', '');
REPLACE INTO Language_ES_ES (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_GOLD_TRADINGPOST_ADV_QUEST', '¿El pueblo ofrece el oro?', '', '');
REPLACE INTO Language_ES_ES (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_GOLD_TRADINGPOST_HEADING3_BODY', 'Construir una mejora de las aldeas en el azulejo para incrementar su producción de oro.', '', '');
REPLACE INTO Language_ES_ES (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_GOLD_TRADINGPOST_HEADING3_TITLE', 'El pueblo', '', '');
REPLACE INTO Language_ES_ES (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_WORKERS_TRADINGPOST_HEADING3_BODY', 'The Village aumenta la producción de una baldosa por 1 de oro. No acceder a un recurso [NEWLINE] Tecnología necesaria:. Reventado [NEWLINE] Tiempo de construcción: 5 vueltas [NEWLINE] podrá reconstruirse sobre: ​​Cualquier pieza de territorio que hielo', '', '');
REPLACE INTO Language_ES_ES (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_POLICY_FREE_THOUGHT_HELP', '[COLOR_POSITIVE_TEXT] Libre Pensamiento [ENDCOLOR] [NEWLINE] 1 [ICON_RESEARCH] Ciencia sobre Pueblos. [NEWLINE] [ICON_RESEARCH] Ciencias 17% de las universidades.', '', '');
REPLACE INTO Language_ES_ES (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_BUILD_TRADING_POST', 'Construir un [LINK = IMPROVEMENT_TRADING_POST] Pueblo [\ LINK]', '', '');
REPLACE INTO Language_ES_ES (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_BUILD_GOLD_REC', 'Se aumentará la cantidad de [ICON_GOLD] Oro proporcionada por esta baldosa, aumentando la cantidad de dinero que tendrá que gastar!', '', '');








UPDATE Loaded File SET Value=1, ES_ES=1 Where Type='Villages.sql';