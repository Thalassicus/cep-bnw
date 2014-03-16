/* The sql commands and text below were formulated in the Villages tab of the Google Spreadsheet 'CAT_Language'.
https://docs.google.com/spreadsheet/ccc?key=0Ap8Ehya83q19dGtjX2JldHBzdXhRbGNxVFgxT1E2OHc&usp=drive_web#gid=6
If you make any changes be sure to update the spreadsheet also.*/
REPLACE INTO Language_IT_IT (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_IMPROVEMENT_TRADING_POST', 'Villaggio', '', '');
REPLACE INTO Language_IT_IT (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_CIV5_IMPROVEMENTS_TRADING_POST_TEXT', 'Un villaggio è un insediamento umano cluster o comunità con una popolazione che vanno da poche centinaia a qualche migliaio. Questi piccoli insediamenti aggiungono per l''economia della vostra società.', '', '');
REPLACE INTO Language_IT_IT (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_CIV5_IMPROVEMENTS_TRADINGPOST', 'Villaggio', '', '');
REPLACE INTO Language_IT_IT (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_GOLD_TRADINGPOST_ADV_QUEST', 'La frazione di fornire oro?', '', '');
REPLACE INTO Language_IT_IT (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_GOLD_TRADINGPOST_HEADING3_BODY', 'Costruisci un miglioramento villaggio in una tegola per aumentare la produzione di oro.', '', '');
REPLACE INTO Language_IT_IT (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_GOLD_TRADINGPOST_HEADING3_TITLE', 'Il villaggio', '', '');
REPLACE INTO Language_IT_IT (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_WORKERS_TRADINGPOST_HEADING3_BODY', 'Il Villaggio aumenta la produzione di una piastrella da 1 oro. Non accedere a una risorsa [NEWLINE] Tecnologia richiesta:. Trapping [NEWLINE] Tempo di costruzione: 5 turni [NEWLINE] può essere costruito in: Qualsiasi piastrella terra, ma il ghiaccio', '', '');
REPLACE INTO Language_IT_IT (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_POLICY_FREE_THOUGHT_HELP', '[COLOR_POSITIVE_TEXT] Libero Pensiero [ENDCOLOR] [NEWLINE] 1 [ICON_RESEARCH] Science on Villaggi. [NEWLINE] +17% Scienza [ICON_RESEARCH] da Università.', '', '');
REPLACE INTO Language_IT_IT (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_BUILD_TRADING_POST', 'Costruire un [LINK = IMPROVEMENT_TRADING_POST] Village [\ LINK]', '', '');
REPLACE INTO Language_IT_IT (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_BUILD_GOLD_REC', 'Esso aumenterà la quantità di [ICON_GOLD] Oro offerto da questa tessera, aumentando la quantità di soldi dovremo spendere!', '', '');








UPDATE LoadedFile SET Value=1, IT_IT=1 Where Type='Villages.sql';