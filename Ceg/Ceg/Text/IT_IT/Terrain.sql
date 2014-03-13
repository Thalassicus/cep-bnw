/* The sql commands and text below were formulated in the Terrain tab of the Google Spreadsheet 'Cep_Language'.
https://docs.google.com/spreadsheets/d/1ptQRfVsW7UT_8gPexioizS31sM7K_3eBT3tjr4jruTs/edit#gid=1001822344
If you make any changes be sure to update the spreadsheet also.*/

REPLACE INTO Language_IT_IT (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_RESOURCE_MOVIES', 'Film', '', '');
REPLACE INTO Language_IT_IT (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_RESOURCE_MOVIES_PEDIA', 'Un film, chiamato anche un film o di immagini in movimento, è una serie di immagini fisse su una striscia di plastica che, se eseguito attraverso un proiettore e mostrati su uno schermo, crea l''illusione di immagini in movimento. Un film è creato da fotografare scene reali con una cinepresa; fotografando disegni o modelli in miniatura con tecniche tradizionali di animazione; mediante CGI e animazione al computer, o da una combinazione di alcuni o tutte queste tecniche e altri effetti visivi. Il processo di cinema è un''arte e un''industria.', '', '');
REPLACE INTO Language_IT_IT (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_RESOURCE_TYRIAN_PURPLE', 'Porpora di Tiro', '', '');
REPLACE INTO Language_IT_IT (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_RESOURCE_TYRIAN_PURPLE_PEDIA', 'Porpora di Tiro, conosciuta anche come porpora, porpora imperiale o imperiale, è un colorante naturale rosso-viola. Il colorante è una secrezione prodotta dalle lumache predatori marini noti come Murex. Questo colorante è stato probabilmente utilizzato dagli antichi fenici fin dal 1600 aC. Il colorante è stato molto apprezzato in tempi antichi, perché il colore non facile sbiadirsi, ma invece è diventato più luminoso con agenti atmosferici e alla luce solare.', '', '');
REPLACE INTO Language_IT_IT (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_BUILD_FORT_REC', 'Migliorerà la difesa [ICON_STRENGTH] di qualsiasi unità militare di stanza in questa tessera, e offerte 20 danni ai nemici adiacenti.', '', '');
REPLACE INTO Language_IT_IT (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_BUILD_FORT_HELP', '[COLOR_NEGATIVE_TEXT] Costi [ENDCOLOR] 3 [ICON_GOLD] Oro ogni turno per mantenere. [NEWLINE] [NEWLINE] +50% [ICON_STRENGTH] Forza di difesa per ogni unità di stanza in questo Tile, e occupa 20 danni ai nemici adiacenti.', '', '');
REPLACE INTO Language_IT_IT (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_CIV5_IMPROVEMENTS_FORT_TEXT', '[COLOR_NEGATIVE_TEXT] Costi [ENDCOLOR] 3 [ICON_GOLD] Oro ogni turno per mantenere. [NEWLINE] [NEWLINE] Un forte è un miglioramento speciale che migliora il bonus difensivo di un esagono, e occupa 20 danni ai nemici adiacenti. Tuttavia, questi effetti non si applicano nel territorio nemico.', '', '');
REPLACE INTO Language_IT_IT (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_CIV5_FEATURES_EL_DORADO_HELP', 'Concede 100 [ICON_GOLD] d''oro per il primo giocatore a scoprirlo.', '', '');
REPLACE INTO Language_IT_IT (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_FEATURE_ATOLL', 'Isles', '', '');
REPLACE INTO Language_IT_IT (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_CIV5_FEATURES_ATOLL', 'Isles', '', '');
REPLACE INTO Language_IT_IT (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_CIV5_FEATURES_ATOLL_TEXT', 'Un''isola è un qualsiasi pezzo di terra sub-continentale, che è circondato da acqua. Molto piccole isole possono essere chiamati isole, isolotti o chiavi.', '', '');
REPLACE INTO Language_IT_IT (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_SPECIALISTSANDGP_CITADEL_HEADING4_BODY', '{TXT}', '', '');
REPLACE INTO Language_IT_IT (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_BUILD_CITADEL_HELP', '[ICON_STRENGTH] +100% [COLOR_POSITIVE_TEXT] Difesa [ENDCOLOR] su questa tessera. [NEWLINE] [ICON_RANGE_STRENGTH] Offerte 30 [COLOR_POSITIVE_TEXT] Damage [ENDCOLOR] per turno di nemici nelle vicinanze. [NEWLINE] [ICON_CULTURE] espande le frontiere per le piastrelle vicine. [NEWLINE] [ICON_LOCKED] Richiede territorio amico.', '', '');
REPLACE INTO Language_IT_IT (Tag, Text, Gender, Plurality) VALUES ('TXT_KEY_CIV5_IMPROVEMENTS_POLDER_HELP', '[ICON_FOOD] Cucina: 2 [NEWLINE] [ICON_LOCKED] Richiede: Coastal Terra', '', '');





UPDATE LoadedFile SET Value=1, IT_IT=1 Where Type='Terrain.sql';


